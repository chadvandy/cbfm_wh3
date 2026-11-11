--- Chaos Invasion: invasion armies keep the "AI vs AI" autoresolve bonus (+99% Ward Save) in player battles,
--- and Archaon's invasion Ward Save stops updating.
---
--- Cause: in running campaigns the shared state endgame_chaos_invasion_enabled can be false although the invasion
--- is in progress (observed since the game update of 2026-11-04). is_available_this_game() then returns false, the
--- episode is never registered with episodes_manager, and its persistent data is neither loaded nor saved.
--- episode_chaos_invasion:is_main_invasion_active() returns false, and every listener gated by it stops working:
---   1. chaos_invasion_PendingBattle never runs -> wh3_main_effect_force_total_autoresolve_victory is not
---      removed when a human is involved (shows up as +99% Ward Save in the pre-battle screen).
---   2. chaos_invasion_effects_FactionTurnEnd / chaos_invasion_BattleCompleted never run ->
---      update_archaon_effects() is never called and Archaon's Ward Save stays frozen.
---   3. Regions stop being devastated and the "world razed" percentage freezes.
---   4. chaos_invasion_CharacterDestroyed never runs -> Archaon's death does not start the final battle.
---
--- Fix: on load, if the episode is listed as running and the invasion has spawned, register the episode again and
--- restore its persistent data (and start the final battle if Archaon is already dead). Vanilla then works by itself.
--- The listeners below are a fallback that run the same vanilla logic ONLY while the vanilla check is still wrongly
--- false. In healthy saves this file does nothing. Everything runs on model events, so it is multiplayer safe.
---
--- Original mod: https://steamcommunity.com/sharedfiles/filedetails/?id=3836794597 (Fionnysos)

local AUTORESOLVE_BUNDLE = "wh3_main_effect_force_total_autoresolve_victory"
local ENFORCE_AUTORESOLVE_EFFECT = "wh3_main_effect_force_enforce_autoresolver_battle"

local function log(text)
	out("[cbfm] chaos invasion ward save fix: " .. tostring(text))
end

local function invasion_script_loaded()
	return is_table(episode_chaos_invasion)
		and is_function(episode_chaos_invasion.is_main_invasion_active)
		and is_function(episode_chaos_invasion.update_archaon_effects)
		and is_function(episode_chaos_invasion.remove_autoresolve_bonus_from_battle)
		and is_string(episode_chaos_invasion.invasion_faction_key)
end

local function get_invasion_faction()
	local faction = cm:get_faction(episode_chaos_invasion.invasion_faction_key)
	if not faction or faction:is_null_interface() or faction:is_dead() then
		return nil
	end
	if faction:military_force_list():is_empty() then
		return nil
	end
	return faction
end

--- True only if the invasion is running but the vanilla script thinks it is not.
local function vanilla_listeners_blind()
	if not invasion_script_loaded() then
		return false
	end

	local ok, active = pcall(function() return episode_chaos_invasion:is_main_invasion_active() end)
	if ok and active then
		-- vanilla works, leave everything to it
		return false
	end

	return get_invasion_faction() ~= nil
end

--- Same value vanilla reads in chaos_invasion_PendingBattle (96 at the time of writing).
local function archaon_required_bonus()
	local required_bonus = 90
	if is_table(episode_chaos_invasion.archaon_force_effect_list) then
		for _, effect in ipairs(episode_chaos_invasion.archaon_force_effect_list) do
			if effect.key == ENFORCE_AUTORESOLVE_EFFECT and is_number(effect.required_bonus) then
				required_bonus = effect.required_bonus
				break
			end
		end
	end
	return required_bonus
end

--------------------------------------------------------------------------------------------------
--- 1. Mirror of the autoresolve part of chaos_invasion_PendingBattle
--------------------------------------------------------------------------------------------------
core:add_listener(
	"cbfm_chaos_invasion_ward_save_fix_PendingBattle",
	"PendingBattle",
	function()
		return vanilla_listeners_blind()
	end,
	function()
		local pb = cm:model():pending_battle()
		if pb:has_been_fought() or not cm:pending_battle_cache_faction_is_involved(episode_chaos_invasion.invasion_faction_key) then
			return
		end

		local invasion_faction = get_invasion_faction()
		local archaon_involved = invasion_faction
			and not invasion_faction:faction_leader():is_null_interface()
			and cm:pending_battle_cache_char_is_involved(invasion_faction:faction_leader())

		if archaon_involved then
			cm:win_next_autoresolve_battle(episode_chaos_invasion.invasion_faction_key)

			if cm:pending_battle_cache_char_is_attacker(invasion_faction:faction_leader()) then
				cm:modify_next_autoresolve_battle(1, 0, 1, 9, true)
			else
				cm:modify_next_autoresolve_battle(0, 1, 9, 1, true)
			end

			if cm:pending_battle_cache_human_is_involved() then
				local ward_save = cm:model():shared_states_manager():get_state_as_float_value("invasion_ward_save") or 0
				if ward_save < archaon_required_bonus() then
					episode_chaos_invasion:remove_autoresolve_bonus_from_battle()
					log("removed autoresolve bonus (Archaon battle, ward save " .. ward_save .. ")")
				end
			end
		elseif cm:pending_battle_cache_human_is_involved() then
			episode_chaos_invasion:remove_autoresolve_bonus_from_battle()
			log("removed autoresolve bonus (player battle)")
		else
			local removal_chance = 10
			if cm:model():shared_states_manager():get_state_as_bool_value("endgame_legendary_difficulty") then
				removal_chance = 5
			end
			if cm:model():random_percent(removal_chance) then
				episode_chaos_invasion:remove_autoresolve_bonus_from_battle()
			end
		end
	end,
	true
)

--------------------------------------------------------------------------------------------------
--- 2. Mirror of chaos_invasion_effects_FactionTurnEnd and the Archaon part of chaos_invasion_BattleCompleted
--------------------------------------------------------------------------------------------------
core:add_listener(
	"cbfm_chaos_invasion_ward_save_fix_FactionTurnEnd",
	"FactionTurnEnd",
	function(context)
		return invasion_script_loaded()
			and context:faction():name() == episode_chaos_invasion.invasion_faction_key
			and vanilla_listeners_blind()
	end,
	function()
		episode_chaos_invasion:update_archaon_effects()
		log("updated Archaon effects at end of invasion turn")
	end,
	true
)

core:add_listener(
	"cbfm_chaos_invasion_ward_save_fix_BattleCompleted",
	"BattleCompleted",
	function()
		return vanilla_listeners_blind()
			and cm:pending_battle_cache_faction_is_involved(episode_chaos_invasion.invasion_faction_key)
	end,
	function()
		episode_chaos_invasion:update_archaon_effects(true)
		log("updated Archaon effects after battle")
	end,
	true
)

--------------------------------------------------------------------------------------------------
--- 3. Restore the episode on load
--------------------------------------------------------------------------------------------------
local MAIN_STAGE_KEY = "episode_chaos_invasion_stage_main"

local function episode_is_running(episode)
	local active_episodes = episodes_manager.persistent.active_episodes
	local active_in_set = is_table(active_episodes) and active_episodes[episode.episode_set]
	if not is_table(active_in_set) then
		return false
	end
	for _, episode_name in ipairs(active_in_set) do
		if episode_name == episode.episode_name then
			return true
		end
	end
	return false
end

--- Vanilla only sets this once the invasion armies have actually been created.
local function invasion_has_spawned()
	local initial_forces = cm:model():shared_states_manager():get_state_as_float_value("invasion_forces_initial_count")
	return is_number(initial_forces) and initial_forces > 0
end

local function persistent_is_healthy(episode)
	local persistent = episode.persistent
	return is_table(persistent)
		and persistent.invasion_spawned == true
		and is_number(persistent.current_stage_index)
		and is_table(persistent.stages_persistent_data)
		and is_table(persistent.stages_persistent_data[persistent.current_stage_index])
end

local function archaon_is_alive(episode)
	local faction = cm:get_faction(episode.invasion_faction_key)
	if not faction or faction:is_null_interface() then
		return false
	end
	for _, character in model_pairs(faction:character_list()) do
		if character:character_subtype(episode.archaon_subtype_key) then
			return true
		end
	end
	return false
end

local function find_dark_fortresses(episode)
	local dark_fortresses = {}
	local faction = cm:get_faction(episode.invasion_faction_key)
	if faction and not faction:is_null_interface() then
		for _, military_force in model_pairs(faction:military_force_list()) do
			if military_force:has_general() and military_force:general_character():character_subtype_key() == episode.dark_fortress_subtype_key then
				dark_fortresses[#dark_fortresses + 1] = military_force:command_queue_index()
			end
		end
	end
	return dark_fortresses
end

local function restore_persistent(episode, main_stage_index)
	if not is_table(episode.persistent) then
		episode.persistent = {}
	end
	local persistent = episode.persistent

	persistent.stages_persistent_data = is_table(persistent.stages_persistent_data) and persistent.stages_persistent_data or {}
	if not is_table(persistent.stages_persistent_data[main_stage_index]) then
		persistent.stages_persistent_data[main_stage_index] = { turn_started = cm:turn_number() }
	end
	persistent.current_stage = persistent.current_stage or 1
	persistent.current_stage_index = main_stage_index
	persistent.invasion_spawned = true
	persistent.dark_fortresses = find_dark_fortresses(episode)
	persistent.invasion_forces = is_table(persistent.invasion_forces) and persistent.invasion_forces or {}
	persistent.dilemmas = is_table(persistent.dilemmas) and persistent.dilemmas or {}
	persistent.legendary_lords = is_table(persistent.legendary_lords) and persistent.legendary_lords or {}
	persistent.regions_razed = cm:model():shared_states_manager():get_state_as_float_value("invasion_regions_razed") or persistent.regions_razed or 0

	episode:update_world_razed_count()
end

local function repair_invasion_state()
	if not is_table(episodes_manager) or not is_table(episodes_manager.persistent) or not invasion_script_loaded() then
		return
	end

	local episode = episode_chaos_invasion
	local finished_episodes = episodes_manager.persistent.finished_episodes
	if is_table(finished_episodes) and finished_episodes[episode.episode_name] then
		return
	end
	if not episode_is_running(episode) or not invasion_has_spawned() then
		return
	end

	if episodes_manager.cached_data.all_episodes_by_name[episode.episode_name] == nil then
		episode.episode_disabled = false
		cm:set_script_state(episode.episode_frontend_enabled_shared_state_key, true)
		episodes_manager:add_available_episode(episode)
		log("invasion episode registered again")
	end

	if persistent_is_healthy(episode) then
		return
	end

	local main_stage_index = episodes_manager:get_episode_stage_index_by_name(episode, MAIN_STAGE_KEY)
	if not is_number(main_stage_index) or main_stage_index < 1 then
		log("main invasion stage not found, nothing restored")
		return
	end

	restore_persistent(episode, main_stage_index)
	log("invasion state restored")

	if archaon_is_alive(episode) then
		return
	end

	-- Short delay like vanilla uses, so the mission payload fires reliably right after loading.
	cm:callback(function()
		if episode.persistent.current_stage_index == main_stage_index and not archaon_is_alive(episode) then
			episodes_manager:advance_stage(episode, main_stage_index)
			log("Archaon already dead, advanced to the final battle")
		end
	end, 0.5)
end

cm:add_post_first_tick_callback(function()
	local ok, err = pcall(repair_invasion_state)
	if not ok then
		log("repair failed: " .. tostring(err))
	end
end)
