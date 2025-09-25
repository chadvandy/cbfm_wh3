MINOR_CULT_LIST = {
	{key = "mc_order_of_vaul", cult = nil},
	{key = "mc_cult_of_painted_skin", cult = nil},
	{key = "mc_silver_pinnacle", cult = nil},
	{key = "mc_order_sacred_scythe", cult = nil},
	{key = "mc_dwarf_miners", cult = nil},
	{key = "mc_black_ark", cult = nil},
	{key = "mc_cult_of_haendryk", cult = nil},
	{key = "mc_cult_of_illumination", cult = nil},
	{key = "mc_cult_of_ulric", cult = nil},
	{key = "mc_cult_of_myrmidia", cult = nil},
	{key = "mc_cult_of_ranald", cult = nil},
	{key = "mc_cult_of_yellow_fang", cult = nil},
	{key = "mc_cult_of_exquisite_cadaver", cult = nil},
	{key = "mc_tilean_traders", cult = nil},
	{key = "mc_witch_hunters", cult = nil},
	{key = "mc_cult_of_shallya", cult = nil},
	{key = "mc_dwarf_rangers", cult = nil},
	{key = "mc_grail_knight_grave", cult = nil},
	{key = "mc_assassins", cult = nil},
	{key = "mc_cult_of_possessed", cult = nil},
	-- BATCH 2
	{key = "mc_carnival_of_chaos", cult = nil},
	{key = "mc_warpstone_meteor", cult = nil},
	{key = "mc_dwarf_builders", cult = nil},
	{key = "mc_forge_of_hashut", cult = nil},
	{key = "mc_ogre_mercs", cult = nil},
	{key = "mc_unearthed_tomb", cult = nil},
	{key = "mc_spawning_pool", cult = nil},
	{key = "mc_crimson_plague", cult = nil, shared_state_key = "endgame_minor_cult_crimson_plague"},
	{key = "mc_sartosan_vault", cult = nil},
	{key = "mc_cathayan_caravan", cult = nil},
	{key = "mc_peg_street_pawnshop", cult = nil},
	{key = "mc_purple_hand", cult = nil, shared_state_key = "endgame_minor_cult_purple_hand"},
	{key = "mc_underworld_sea", cult = nil},
	{key = "mc_doomsphere", cult = nil, shared_state_key = "endgame_minor_cult_doomsphere"},
	{key = "mc_dark_gift", cult = nil},
	{key = "mc_chaos_portal", cult = nil, shared_state_key = "endgame_minor_cult_chaos_portal"},
	{key = "mc_crimson_skull", cult = nil, shared_state_key = "endgame_minor_cult_crimson_skull"},
	{key = "mc_cult_of_pleasure", cult = nil},
	{key = "mc_the_cabal", cult = nil, shared_state_key = "endgame_minor_cult_cabal", disable_in_MP = true},
	{key = "mc_elven_enclave", cult = nil}
};
local status_to_string = {
	[-1] = "COMPLETED",
	[0] = "NOT_STARTED",
	[1] = "STARTED",
	[2] = "EVENTS_ONLY"
};

MINOR_CULT_REGIONS = {};
local minor_cult_faction_key = "wh3_main_rogue_minor_cults";
local spawn_cult_per_turn_chance = 8;
local allow_ai_cults = false; -- WIP, don't enable yet
local cult_last_turn = false;
local cult_debug_output = true;

function add_minor_cults_listeners()
	out("#### Adding Minor Cults Listeners ####");
	for i = 1, #MINOR_CULT_LIST do
		out_mc("\tMinor Cult "..i.." : "..MINOR_CULT_LIST[i].key);
		MINOR_CULT_LIST[i].cult.key = MINOR_CULT_LIST[i].key;

		if MINOR_CULT_LIST[i].shared_state_key ~= nil then
			local should_use = cm:model():shared_states_manager():get_state_as_bool_value(MINOR_CULT_LIST[i].shared_state_key);

			if should_use == false then
				MINOR_CULT_LIST[i].cult.saved_data.status = -1;
				out_mc("\t\tFrontend Setting Required: "..MINOR_CULT_LIST[i].shared_state_key.."  [Disabled]");
			else
				out_mc("\t\tFrontend Setting Required: "..MINOR_CULT_LIST[i].shared_state_key.."  [Enabled]");
			end
		end
		if MINOR_CULT_LIST[i].disable_in_MP ~= nil and cm:is_multiplayer() then
			if MINOR_CULT_LIST[i].disable_in_MP == true then
				MINOR_CULT_LIST[i].cult.saved_data.status = -1;
				out_mc("\t\tDisabled in Multiplayer");
			end
		end
	end

	local minor_cult = cm:model():world():faction_by_key(minor_cult_faction_key);

	if minor_cult:is_null_interface() == false then -- If the faction isn't in the startpos it's likely an old save and we can't use the feature
		cm:force_diplomacy("faction:wh3_main_rogue_minor_cults", "all", "all", false, false, true);
		local cults = minor_cult:foreign_slot_managers();

		for cult_index = 0, cults:num_items() - 1 do
			local cult = cults:item_at(cult_index);
			local region = cult:region();
			cm:foreign_slot_set_reveal_to_faction(region:owning_faction(), cult);

			if allow_ai_cults == true then
				-- TODO: Reveal to all human players also
			end
		end
		
		for i = 1, #MINOR_CULT_LIST do
			if MINOR_CULT_LIST[i].cult.saved_data.status >= 0 then
				if MINOR_CULT_LIST[i].cult.custom_listeners ~= nil then
					MINOR_CULT_LIST[i].cult:custom_listeners();
				end
			end
		end
		
		-- Each turn we get all non-triggered minor cults into a table, shuffle the table, iterate through and trigger the first valid one
		-- We do this on FactionBeginTurnPhaseNormal for each player each round because the buildings have many scripted effects which trigger
		-- on events like RegionTurnStart, meaning spawning too early can allow the effects to trigger on the same turn we create the minor cult (bad)
		-- Hence we choose the latest event possible which is TurnPhaseNormal to let all other events go first before any spawning
		-- This is MP safe because minor cults can only spawn in the players (whose turn it is) regions, meaning we can never be in a state where
		-- a minor cult has spawned in a players regions whose turn has not yet started fully
		core:add_listener(
			"MinorCults_FactionBeginTurnPhaseNormal",
			"FactionBeginTurnPhaseNormal",
			function(context)
				local faction = context:faction();
				return (faction:is_human() or (allow_ai_cults == true and faction:has_home_region() == true)) and faction:is_factions_turn();
			end,
			function(context)
				local turn_number = cm:turn_number();
				local event_triggered_this_turn = false;

				if cult_last_turn == false then -- This avoid any chance of spawning/events one turn after another
					out_mc("MINOR CULTS - TurnStart - "..turn_number);

					if cm:model():random_percent(spawn_cult_per_turn_chance) then
						cm:shuffle_table(MINOR_CULT_LIST);

						for i = 1, #MINOR_CULT_LIST do
							local cult_status = MINOR_CULT_LIST[i].cult.saved_data.status;
							out_mc(MINOR_CULT_LIST[i].key.." - STATUS - "..status_to_string[cult_status].." ("..tostring(cult_status)..")");

							if cult_status == 0 then
								local region_key = MINOR_CULT_LIST[i].cult:is_valid(MINOR_CULT_REGIONS);

								if region_key ~= nil then
									local spawned, log = spawn_minor_cult(region_key, i);
									
									if spawned == true then
										cult_last_turn = true;
										out_mc("\t"..MINOR_CULT_LIST[i].key .. " - VALID - "..log);
										break;
									else
										out_mc("\t"..MINOR_CULT_LIST[i].key .. " - FAILED - "..log);
									end
								else
									out_mc("\t"..MINOR_CULT_LIST[i].key .. " - INVALID");
								end
							end
						end
					else
						out_mc("\tFailed - Spawn Cult Chance ("..spawn_cult_per_turn_chance.."%)");
					end
				else
					out_mc("\tFailed - Cult Spawned Last Turn");
					cult_last_turn = false;
				end

				cm:shuffle_table(MINOR_CULT_LIST);

				for i = 1, #MINOR_CULT_LIST do
					out_mc("MINOR CULT - Event - "..MINOR_CULT_LIST[i].key);
					local cult_status = MINOR_CULT_LIST[i].cult.saved_data.status;
					out_mc("\tSTATUS - "..status_to_string[cult_status].." ("..tostring(cult_status)..")");
					
					if MINOR_CULT_LIST[i].cult.saved_data.status > 0 then
						if MINOR_CULT_LIST[i].cult.event_data ~= nil then
							out_mc("\tEvent Limit - "..MINOR_CULT_LIST[i].cult.saved_data.event_triggers.."/"..MINOR_CULT_LIST[i].cult.event_data.event_limit);

							if MINOR_CULT_LIST[i].cult.saved_data.event_triggers < MINOR_CULT_LIST[i].cult.event_data.event_limit then
								out_mc("\tEvent Cooldown - "..MINOR_CULT_LIST[i].cult.saved_data.event_cooldown);
								
								if MINOR_CULT_LIST[i].cult.saved_data.event_cooldown > 0 then
									MINOR_CULT_LIST[i].cult.saved_data.event_cooldown = MINOR_CULT_LIST[i].cult.saved_data.event_cooldown - 1;
								else
									local should_trigger = cm:model():random_percent(MINOR_CULT_LIST[i].cult.event_data.event_chance_per_turn);

									if should_trigger == true then
										local triggered = false;
										local region = cm:model():world():region_manager():region_by_key(MINOR_CULT_LIST[i].cult.saved_data.region_key);

										if region:is_null_interface() == false then
											if (event_triggered_this_turn == false and cult_last_turn == false) or MINOR_CULT_LIST[i].cult.event_data.force_trigger then
												local faction = region:owning_faction();

												if MINOR_CULT_LIST[i].cult.custom_event ~= nil then
													triggered = MINOR_CULT_LIST[i].cult:custom_event(faction, region, minor_cult);
													out("\tTriggering custom event - Triggered: "..tostring(triggered));
												else
													out_mc("\tEvent data exists but no custom_event declared");
												end
											end
											
											if triggered == true then
												event_triggered_this_turn = true;
												MINOR_CULT_LIST[i].cult.saved_data.event_cooldown = MINOR_CULT_LIST[i].cult.event_data.event_cooldown;
												MINOR_CULT_LIST[i].cult.saved_data.event_triggers = MINOR_CULT_LIST[i].cult.saved_data.event_triggers + 1;
											end
										else
											out_mc("\tRegion was null interface");
										end
									end
								end
							end
						end
					end
				end
			end,
			true
		);
		
		core:add_listener(
			"MinorCults_ForeignSlotManagerRemovedEvent",
			"ForeignSlotManagerRemovedEvent",
			function(context)
				return context:owner():name() == "wh3_main_rogue_minor_cults";
			end,
			function(context)
				local owner_key = context:owner():name();
				local remover = context:remover();
				local region = context:region();
				local region_key = region:name();

				if MINOR_CULT_REGIONS[region_key] ~= nil then
					local cult_key = MINOR_CULT_REGIONS[region_key];

					for i = 1, #MINOR_CULT_LIST do
						if MINOR_CULT_LIST[i].key == cult_key then
							-- If there is a removal event, trigger it
							if MINOR_CULT_LIST[i].cult.removal_event ~= nil then
								MINOR_CULT_LIST[i].cult:removal_event(remover, region);
							end
							
							if MINOR_CULT_LIST[i].cult.effect_bundle ~= nil then
								cm:remove_effect_bundle_from_region(MINOR_CULT_LIST[i].cult.effect_bundle, region_key);
							end
							if MINOR_CULT_LIST[i].cult.event_data ~= nil then
								MINOR_CULT_LIST[i].cult.saved_data.event_triggers = MINOR_CULT_LIST[i].cult.event_data.event_limit;
							end
							if MINOR_CULT_LIST[i].cult.complete_on_removal == true then
								MINOR_CULT_LIST[i].cult.saved_data.status = -1;
							end
							break;
						end
					end
				end
			end,
			true
		);

		core:add_listener(
			"MinorCults_CharacterTurnStart",
			"CharacterTurnStart",
			true,
			function(context)
				local character = context:character();

				if character:has_region() == true then
					local region = character:region();
					local fsm = region:foreign_slot_manager_for_faction("wh3_main_rogue_minor_cults");

					if fsm:is_null_interface() == false then
						-- A character is in a minor cult region, find the cult associated with that region, query if it has a character_in_region function
						local region_key = region:name();

						if MINOR_CULT_REGIONS[region_key] ~= nil then
							local cult_key = MINOR_CULT_REGIONS[region_key];

							for i = 1, #MINOR_CULT_LIST do
								if MINOR_CULT_LIST[i].key == cult_key then
									if MINOR_CULT_LIST[i].cult.saved_data.status == 1 then
										-- If there is a character event, trigger it
										if MINOR_CULT_LIST[i].cult.character_in_region ~= nil then
											local slot_list = fsm:slots();
											local triggered = MINOR_CULT_LIST[i].cult:character_in_region(character, region, slot_list);
										end
									end
									break;
								end
							end
						end
					end
				end
			end,
			true
		);

		core:add_listener(
			"MinorCults_RegionFactionChangeEvent",
			"RegionFactionChangeEvent",
			true,
			function(context)
				local region = context:region();
				local region_key = region:name();
				
				if MINOR_CULT_REGIONS[region_key] ~= nil then
					for i = 1, #MINOR_CULT_LIST do
						if MINOR_CULT_LIST[i].cult.saved_data.region_key == region_key then
							local faction = cm:model():world():faction_by_key(minor_cult_faction_key);
							cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), region:cqi());

							if MINOR_CULT_LIST[i].cult.event_data ~= nil then
								MINOR_CULT_LIST[i].cult.saved_data.event_triggers = MINOR_CULT_LIST[i].cult.event_data.event_limit;
							end
							if MINOR_CULT_LIST[i].cult.effect_bundle ~= nil then
								cm:remove_effect_bundle_from_region(MINOR_CULT_LIST[i].cult.effect_bundle, region_key);
							end
							out_mc("Minor Cult: Removing "..MINOR_CULT_LIST[i].key.." from "..region_key);
							break;
						end
					end
				end
			end,
			true
		);

		-- Debug listener to easily spawn cults
		core:add_listener(
			"MinorCults_ScriptEventHumanFactionTurnStart",
			"ScriptEventHumanFactionTurnStart",
			function(context)
				return cm:is_new_game();
			end,
			function(context)
				local faction = context:faction();
				local capital = "wh3_main_combi_region_altdorf";

				if faction:has_home_region() == true then
					capital = faction:home_region():name();
				end

				--spawn_minor_cult_by_key(capital, "mc_carnival_of_chaos");
				--spawn_minor_cult_by_key(capital, "mc_warpstone_meteor");
				--spawn_minor_cult_by_key(capital, "mc_dwarf_builders");
				--spawn_minor_cult_by_key(capital, "mc_forge_of_hashut");
				--spawn_minor_cult_by_key(capital, "mc_ogre_mercs");
				--spawn_minor_cult_by_key("wh3_main_combi_region_khemri", "mc_unearthed_tomb");
				--spawn_minor_cult_by_key("wh3_main_combi_region_itza", "mc_spawning_pool");
				--spawn_minor_cult_by_key(capital, "mc_crimson_plague");
				--spawn_minor_cult_by_key(capital, "mc_sartosan_vault");
				--spawn_minor_cult_by_key(capital, "mc_cathayan_caravan");
				--spawn_minor_cult_by_key(capital, "mc_peg_street_pawnshop");
				--spawn_minor_cult_by_key(capital, "mc_purple_hand");
				--spawn_minor_cult_by_key("wh3_main_combi_region_naggarond", "mc_underworld_sea");
				--spawn_minor_cult_by_key(capital, "mc_doomsphere");
				--spawn_minor_cult_by_key(capital, "mc_dark_gift");
				--spawn_minor_cult_by_key(capital, "mc_chaos_portal");
				--spawn_minor_cult_by_key(capital, "mc_crimson_skull");
				--spawn_minor_cult_by_key(capital, "mc_cult_of_pleasure");
				--spawn_minor_cult_by_key(capital, "mc_the_cabal");
				--spawn_minor_cult_by_key(capital, "mc_elven_enclave");
			end,
			false
		);
	end
end

function spawn_minor_cult(region_key, cult_index)
	if MINOR_CULT_LIST[cult_index].cult.saved_data.status == 0 then
		local spawn_log = "";
		local region = cm:get_region(region_key);
		local mcf = cm:model():world():faction_by_key(minor_cult_faction_key);
		cm:add_foreign_slot_set_to_region_for_faction(mcf:command_queue_index(), region:cqi(), MINOR_CULT_LIST[cult_index].cult.slot_key);

		local slot_manager = region:foreign_slot_manager_for_faction(minor_cult_faction_key);
		cm:foreign_slot_set_reveal_to_faction(region:owning_faction(), slot_manager);

		if MINOR_CULT_LIST[cult_index].cult.effect_bundle ~= nil then
			cm:apply_effect_bundle_to_region(MINOR_CULT_LIST[cult_index].cult.effect_bundle, region_key, 0);
		end

		MINOR_CULT_LIST[cult_index].cult.saved_data.status = 1;
		MINOR_CULT_LIST[cult_index].cult.saved_data.region_key = region_key;
		MINOR_CULT_REGIONS[region_key] = MINOR_CULT_LIST[cult_index].key;

		if MINOR_CULT_LIST[cult_index].cult.event_data ~= nil then
			MINOR_CULT_LIST[cult_index].cult.saved_data.event_cooldown = MINOR_CULT_LIST[cult_index].cult.event_data.event_initial_delay;
		end

		if MINOR_CULT_LIST[cult_index].cult.creation_event ~= nil then
			local turn_number = cm:turn_number();
			local triggered = MINOR_CULT_LIST[cult_index].cult:creation_event(region_key, turn_number);

			if triggered == true then
				spawn_log = spawn_log.." - Creation event = Triggered";
			else
				spawn_log = spawn_log.." - Creation event = Not Triggered";
			end
		end
		
		local faction_cqi = region:owning_faction():command_queue_index();
		cm:trigger_incident_with_targets(faction_cqi, MINOR_CULT_LIST[cult_index].cult.intro_incident_key, 0, 0, 0, 0, region:cqi(), 0);
		return true, MINOR_CULT_LIST[cult_index].cult.key.." - "..MINOR_CULT_LIST[cult_index].cult.slot_key.." - "..region_key..spawn_log;
	else
		local spawn_log = "spawn_minor_cult failed due to status - "..tostring(MINOR_CULT_LIST[cult_index].cult.saved_data.status);
		out_mc(spawn_log);
		return false, spawn_log;
	end
	return false, "ERROR";
end

function spawn_minor_cult_by_key(region_key, cult_key)
	for i = 1, #MINOR_CULT_LIST do
		if MINOR_CULT_LIST[i].key == cult_key then
			spawn_minor_cult(region_key, i);
			break;
		end
	end
end

function debug_minor_cult_events()
	local human_factions = cm:get_human_factions()
				
	for i = 1, #human_factions do
		local emp = cm:model():world():faction_by_key(human_factions[i]);
		local emp_region_cqi = cm:get_region("wh3_main_combi_region_altdorf"):cqi();

		cm:trigger_incident_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_intro", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_incident_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_myrmidia", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_incident_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_skaven", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_incident_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_wine", 0, 0, 0, 0, emp_region_cqi, 0);

		cm:trigger_dilemma_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_earthquake", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_dilemma_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_loan", 0, 0, 0, 0, emp_region_cqi, 0);
		cm:trigger_dilemma_with_targets(emp:command_queue_index(), "wh3_main_minor_cult_settlement_sale", 0, 0, 0, 0, emp_region_cqi, 0);
	end
end

function debug_create_cult(key)
	for i = 1, #MINOR_CULT_LIST do
		if MINOR_CULT_LIST[i].key == key then
			local valid_from_turn = MINOR_CULT_LIST[i].cult.valid_from_turn;
			local chance_if_valid = MINOR_CULT_LIST[i].cult.chance_if_valid;

			MINOR_CULT_LIST[i].cult.valid_from_turn = 0;
			MINOR_CULT_LIST[i].cult.chance_if_valid = 100;

			if MINOR_CULT_LIST[i].cult.saved_data.status == 0 then
				local region_key = MINOR_CULT_LIST[i].cult:is_valid(MINOR_CULT_REGIONS);

				if region_key ~= nil then
					local log = spawn_minor_cult(region_key, i);
					MINOR_CULT_REGIONS[region_key] = MINOR_CULT_LIST[i].key;
					out_mc("\t"..MINOR_CULT_LIST[i].key .. " - VALID - "..log);
					break;
				else
					out_mc("\t"..MINOR_CULT_LIST[i].key .. " - INVALID");
				end
			else
				out_mc("\t"..MINOR_CULT_LIST[i].key .. " - FAILED - Status: "..tostring(MINOR_CULT_LIST[i].cult.saved_data.status));
			end

			MINOR_CULT_LIST[i].cult.valid_from_turn = valid_from_turn;
			MINOR_CULT_LIST[i].cult.chance_if_valid = chance_if_valid;
			break;
		end
	end
end

function out_mc(msg)
	if cult_debug_output then
		out(msg);
	end
end

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("MINOR_CULT_REGIONS", MINOR_CULT_REGIONS, context);

		for i = 1, #MINOR_CULT_LIST do
			cm:save_named_value("MinorCult_"..MINOR_CULT_LIST[i].key, MINOR_CULT_LIST[i].cult.saved_data, context);
		end
	end
);

cm:add_loading_game_callback(
	function(context)
		MINOR_CULT_REGIONS = cm:load_named_value("MINOR_CULT_REGIONS", MINOR_CULT_REGIONS, context);

		for i = 1, #MINOR_CULT_LIST do
			MINOR_CULT_LIST[i].cult.saved_data = cm:load_named_value("MinorCult_"..MINOR_CULT_LIST[i].key, MINOR_CULT_LIST[i].cult.saved_data, context);

			-- PATCH 6.3 POST-LOAD FIXUP
			if MINOR_CULT_LIST[i].cult.saved_data.status == nil then
				out("Minor Cult "..i.." - "..MINOR_CULT_LIST[i].key.." - Post-Load Fixup - Patch 6.3")
				if MINOR_CULT_LIST[i].cult.saved_data.active ~= nil then
					if MINOR_CULT_LIST[i].cult.saved_data.active == true then
						MINOR_CULT_LIST[i].cult.saved_data.status = 1;
					else
						MINOR_CULT_LIST[i].cult.saved_data.status = 0;
					end
				end
			end
		end
	end
);