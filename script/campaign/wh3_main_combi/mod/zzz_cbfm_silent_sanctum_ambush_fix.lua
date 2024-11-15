local m_regions_with_sanctums = {}
local m_region_to_lord_list = {}
local m_oxyotl_faction_key = "wh2_dlc17_lzd_oxyotl"

-- CBFM: This function is really the only thing being changed. Everything else is copied just to get around local variable issues
-- Fix by Photon:
-- Fixes a bug regarding the strength of the silent sanctum ambushes of oxyotl.
-- These are supposed to get slightly stronger every 20 turns. However this fired only if on the 20th, 40th, 60th, .. turn you succesfully ambushed someone. Also it would increase in strength multiple times if you managed to successfully ambush multiple factions in these turns.
-- These two things are patched out with the mod. Instead the strength is calculated each time by the number of turns that has passed.

local function get_invasion_power_by_turn()
	local turn = cm:model():turn_number()
	m_sanctum_ambush_config.ambush_current_power_level = (turn - (turn % m_sanctum_ambush_config.turns_for_ambush_power_upgrade)) / m_sanctum_ambush_config.turns_for_ambush_power_upgrade + 1
	if m_sanctum_ambush_config.ambush_current_power_level > m_sanctum_ambush_config.ambush_power_cap then
		m_sanctum_ambush_config.ambush_current_power_level = m_sanctum_ambush_config.ambush_power_cap
	end
	return m_sanctum_ambush_config.ambush_current_power_level
end
-- End CBFM edits

local function get_ambush_army_size(building_key)
	if building_key == m_sanctum_ambush_config.small_army_key then
		-- Spawn small army to attack lord army
		return m_sanctum_ambush_config.ambush_force_strength_small
	elseif building_key == m_sanctum_ambush_config.med_army_key then
		-- Spawn medium army to attack lord's army
		return m_sanctum_ambush_config.ambush_force_strength_medium
	else
		-- Unhandled Key error
		script_error("ERROR: lzd_silent_sanctums: Trying to use army size not specified for building key "..building_key)
	end
end

local function get_ambush_roll(building_key)
	local ambush_roll = cm:random_number(m_sanctum_ambush_config.ambush_max_value, m_sanctum_ambush_config.ambush_min_value)
	if building_key == m_sanctum_ambush_config.small_army_key then
		-- Spawn small army to attack lord army
		return ambush_roll <= m_sanctum_ambush_config.ambush_chance.building_1
	elseif building_key == m_sanctum_ambush_config.med_army_key then
		-- Spawn medium army to attack lord's army
		return ambush_roll <= m_sanctum_ambush_config.ambush_chance.building_2
	else
		-- Unhandled Key error
		script_error("ERROR: lzd_silent_sanctums: Trying to use ambush roll for building key "..building_key)
	end
end

local function spawn_ambush_army(enemy_force_cqi, force_size, invasion_power)
	local opt_player_generated_force, is_ambush, is_attacker, destroy_generated_force = true, true, true, true
	local player_vic_incident, player_def_incident, general_level = nil, nil, nil
	local effect_bundle = m_sanctum_ambush_config.ambush_bundle
	Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
		enemy_force_cqi,
		m_oxyotl_faction_key,
		m_sanctum_ambush_config.army_template,
		force_size,
		invasion_power,
		is_attacker,
		destroy_generated_force,
		is_ambush,
		player_vic_incident,
		player_def_incident,
		m_sanctum_ambush_config.general_to_use,
		general_level,
		effect_bundle,
		opt_player_generated_force
	)
end

local function update_oxyotl_sanctum_regions_with_ambush_buildings()
	m_regions_with_sanctums = {}
	local faction = cm:get_faction(m_oxyotl_faction_key)
	local foreign_slot_list = faction:foreign_slot_managers()
	for i = 0, foreign_slot_list:num_items() - 1 do
		local foreign_slot = foreign_slot_list:item_at(i)
		local foreign_building_slot_list = foreign_slot:slots()
		for j = 0, foreign_building_slot_list:num_items() - 1 do
			local building_slot = foreign_building_slot_list:item_at(j)

			if building_slot:has_building() and m_sanctum_ambush_config.ambush_buildings[building_slot:building()] then
				local region_interface = foreign_slot:region()
				local region_name = region_interface:name()
				local sanctum_ambush = {
					["region_name"] = region_name,
					["building_name"] = building_slot:building()
				}
				table.insert(m_regions_with_sanctums, sanctum_ambush)
			end
		end
	end
end

local function check_and_spawn_ambush_battle()
	local ambush_battle_generated = false
	for _, v in ipairs(m_regions_with_sanctums) do
		local lord_list_at_region = m_region_to_lord_list[v.region_name]
		if lord_list_at_region ~= nil then
			-- Found a lord in a region with the sanctum ambush building
			-- Check if ambush succeeds
			for _,lord in ipairs(lord_list_at_region) do
				if get_ambush_roll(v.building_name) then
					-- Spawn and force army to ambush attack given enemy army
					local enemy_force_cqi = lord.enemy_force:command_queue_index()
					local force_size = get_ambush_army_size(v.building_name)
					local invasion_power = get_invasion_power_by_turn()
					spawn_ambush_army(enemy_force_cqi, force_size, invasion_power)
					ambush_battle_generated = true
				end
				if ambush_battle_generated then
					-- Limit ambush to 1 per faction
					break
				end
			end
		end
		if ambush_battle_generated then
			-- Limit ambush to 1 per faction
			break
		end
	end
end

local function init()
	core:remove_listener("oxy_sanctum_ambush")
	core:add_listener(
		"oxy_sanctum_ambush",
		"FactionAboutToEndTurn",
		function(context)
			local oxyotl_faction = cm:get_faction(m_oxyotl_faction_key)
			-- war with Oxyotl?
			return context:faction():at_war_with(oxyotl_faction)
		end,
		function(context)
			m_region_to_lord_list = {}
			-- If faction is at war with oxyotl
			-- Generate list of all characters within that faction with a military force
			local faction_interface = context:faction()
			local forces_list = faction_interface:military_force_list()
			-- Get region of each character in list of forces
			for l = 0, forces_list:num_items() - 1 do
				local enemy_force = forces_list:item_at(l)
				local lord = enemy_force:general_character()
				if lord:is_null_interface() == false and lord:has_region() and not lord:has_garrison_residence() then
					local lord_region_name = lord:region():name()
					local info = {
						["lord"] = lord,
						["enemy_force"] = enemy_force
					}
					if not m_region_to_lord_list[lord_region_name] then m_region_to_lord_list[lord_region_name] = {} end
					table.insert(m_region_to_lord_list[lord_region_name], info)
				end
			end

			update_oxyotl_sanctum_regions_with_ambush_buildings()
			-- Trim list based on each characters location vs Ambush building locations
			check_and_spawn_ambush_battle()
		end,
		true
	)
end

cm:add_post_first_tick_callback(init)