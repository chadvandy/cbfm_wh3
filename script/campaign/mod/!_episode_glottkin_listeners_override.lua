-- Just the add listeners function copy/pasted from the main script, but the
-- listener "Second_Stage_Mission" is renamed "Second_Stage_Mission_GLOTTKIN"
-- to make it unique from the other two listeners used by the game with this name.

------------------
--- Listeners ----
------------------
function episode_glottkin:listeners()
	core:add_listener(
		"Glottkin_Episode_Start",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			return context:faction():name() == episode_glottkin.faction_key and faction:is_human() and cm:turn_number() == 1
		end,
		function(context)
			local altdorf_interface = cm:get_region(episode_glottkin.altdorf_settlement_key)
			cm:instantly_set_settlement_primary_slot_level(altdorf_interface:settlement(),episode_glottkin.altdorf_main_building_level)
			for i = 1, #episode_glottkin.cai_disable_regions do
				cm:cai_disable_targeting_against_settlement(episode_glottkin.cai_disable_regions[i])
			end
			for i = 1, #episode_glottkin.factions_increased_potential do
				local faction = cm:get_faction(episode_glottkin.factions_increased_potential[i])
				if faction and not faction:is_null_interface() then
					cm:faction_set_potential_modifier(faction, episode_glottkin.cai_increased_potential)
				end
			end
		end,
		false
	)

	core:add_listener(
		"Glottkin_Vassal_Mission_Diplomacy",
		"FactionBecomesVassal",
		function(context)
			local vassal = context:vassal()
			local glottkin_faction = cm:get_faction(episode_glottkin.faction_key)
			if glottkin_faction and not glottkin_faction:is_dead() then
				local mission_data = episode_glottkin.scripted_mission_data[episode_glottkin.narrative_assert_dominance]
				return vassal:is_vassal_of(glottkin_faction) and table.contains(mission_data.objective_cultures, vassal:culture()) and cm:mission_is_active_for_faction(glottkin_faction, episode_glottkin.narrative_assert_dominance)
			else
				return false
			end
		end,
		function(context)
			cm:increase_scripted_mission_count(episode_glottkin.narrative_assert_dominance, episode_glottkin.narrative_assert_dominance, 1)
		end,
		true
	)


	-- Act 2 - Tier 3 Garden built in Empire territory
	core:add_listener(
		"Act_2_Nurgle_Garden_Empire",
		"BuildingCompleted",
		function(context)
			return context:building():name() == episode_glottkin.nurgle_garden_tier_5 and context:building():faction():is_human()
		end,
		function(context)
			local region_interface = context:garrison_residence():region();
			local region_key = region_interface:name()
			local glottkin_faction_interface = context:building():faction()

			for _, empire_region_key in ipairs(imperial_authority.empire_regions) do
				if(region_key == empire_region_key) then
					if region_key ~= "wh3_main_combi_region_brass_keep" and cm:mission_is_active_for_faction(glottkin_faction_interface, episode_glottkin.narrative_weaking_the_veil) then
						episode_glottkin.persistent.pesticide_region = region_key
						cm:complete_scripted_mission_objective(episode_glottkin.faction_key, episode_glottkin.narrative_weaking_the_veil, episode_glottkin.narrative_weaking_the_veil, true)
						episode_glottkin:set_up_invastion_markers_garden_of_nurgle(region_interface)
						table.insert(episode_glottkin.empire_regions_converted_to_garden, region_key)
						core:remove_listener("Act_2_Nurgle_Garden_Empire")
					end
				end
			end	
		end,
		true
	)

	---------------------------------------------------------------
	-- -- Act 2 - Invasion on Garden of Nurgle Tier 3
	
	core:add_listener(
		"Enemy_Invasion_Garden_Destroyed",
		"MilitaryForceDestroyed",
		function(context)

			local nurgle_garden_invasion_armies = cm:get_saved_value("nurgle_garden_invasion_armies_cqi") or {}
			local mf_cqi = context:military_force():command_queue_index()

			return table.contains(nurgle_garden_invasion_armies, mf_cqi)

		end,
		function(context)
			local glottkin_faction_interface = cm:get_faction(episode_glottkin.faction_key)

			if cm:mission_is_active_for_faction(glottkin_faction_interface, episode_glottkin.narrative_pesticide)  then
				cm:increase_scripted_mission_count(episode_glottkin.narrative_pesticide, episode_glottkin.narrative_pesticide, 1)
			end
		end,
		true
	)

	---------------------------------------------------------------
	-- Act 2 - Invasion on Brass Keep


	core:add_listener(
		"Enemy_Invasion_Brass_Keep_Destroyed",
		"MilitaryForceDestroyed",
		function(context)

			local brass_keep_invasion_armies = cm:get_saved_value("brass_keep_invasion_armies_cqi") or {}
			local mf_cqi = context:military_force():command_queue_index()

			return table.contains(brass_keep_invasion_armies, mf_cqi)
		end,
		function(context)
			local glottkin_faction_interface = cm:get_faction(episode_glottkin.faction_key)
			if cm:mission_is_active_for_faction(glottkin_faction_interface, episode_glottkin.narrative_doctors_orders)  then
					cm:increase_scripted_mission_count(episode_glottkin.narrative_doctors_orders, episode_glottkin.narrative_doctors_orders, 1)
			end
		end,
		true
	)

	-- Act 2 - Plague Spreading mission
	core:add_listener(
		"Pestilence_and_Plagues_Region_Infection",
		"RegionInfectionEvent",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			local is_in_empire = context:target_region():is_contained_in_region_group(episode_glottkin.empire_region_group_key)
			if not is_in_empire then
				return
			end

			local faction = context:faction()
			local creator_name = context:plague():creator_faction():name()
			local has_mission = cm:mission_is_active_for_faction(faction, episode_glottkin.pestilence_and_plagues)
			if has_mission and creator_name == episode_glottkin.faction_key then
				if not context:is_creation() and not context:is_removed() then
					cm:increase_scripted_mission_count(episode_glottkin.pestilence_and_plagues, episode_glottkin.pestilence_and_plagues, 1) 					
				end
			end
		end,
		true
	)

	core:add_listener(
		"Pestilence_and_Plagues_MilForces_Infection",
		"MilitaryForceInfectionEvent",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			local general = context:target_force():general_character()
			if not general or not general:has_region() then
				return
			end

			local is_in_empire = general:region():is_contained_in_region_group(episode_glottkin.empire_region_group_key)
			if not is_in_empire then
				return
			end

			local faction = context:faction()
			local creator_name = context:plague():creator_faction():name()
			local has_mission = cm:mission_is_active_for_faction(faction, episode_glottkin.pestilence_and_plagues)
			if has_mission and creator_name == episode_glottkin.faction_key then
				if not context:is_creation() and not context:is_removed() then
					cm:increase_scripted_mission_count(episode_glottkin.pestilence_and_plagues, episode_glottkin.pestilence_and_plagues, 1) 					
				end
			end
		end,
		true
	)		

	-- Act 2 - 
	core:add_listener(
		"Second_Stage_Mission_GLOTTKIN",--CBFM; renamed this listener to be unique
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == episode_glottkin.pestilence_and_plagues
		end,
		function(context)
			cm:force_awake_from_death_and_confederate(episode_glottkin.faction_key, episode_glottkin.festus_faction_key)
			episode_glottkin:episode_mission(episode_glottkin.narrative_doctors_orders)
			episode_glottkin:set_up_invastion_markers_brass_keep()
		end,
		true
	)	

	-- Act 2 - Brass keep Marker expired -> invade
	core:add_listener(
		"ScriptEventBrassKeepInvasionMarkerExpired",
		"ScriptEventBrassKeepInvasionMarkerExpired",
		true,
		function(context)
			local marker_ref = context.stored_table.marker_ref
			local instance_ref = context.stored_table.instance_ref
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(instance_ref)
			cm:remove_interactable_campaign_marker(marker_ref)
			episode_glottkin:trigger_glottkin_episode_invasion(x, y, episode_glottkin.enemy_invasion_brass_keep)
			
			if not episode_glottkin.brass_keep_invasion_has_spawned_event_feed then
				cm:show_message_event_located(
					episode_glottkin.faction_key,
					"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_invasion_title_glottkin",
					"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
					"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail",
					x,
					y,
					true,
					558
				)
				episode_glottkin.brass_keep_invasion_has_spawned_event_feed = true
			end
		end,
		true
	)

	core:add_listener(
		"ScriptEventBrassKeepInvasionMarkerInteraction",
		"ScriptEventBrassKeepInvasionMarkerInteraction",
		true,
		function(context)
			local area_info = context.stored_table
			local marker_ref = area_info.marker_ref
			local invasion_faction = nil
			local invasion_data = episode_glottkin.enemy_invasion_brass_keep
			for _, faction_key in ipairs(invasion_data.faction_data) do
				local faction = cm:get_faction(faction_key)
				if faction and faction:is_dead() then
					invasion_faction = faction_key
					break
				end
			end
			if not invasion_faction then
				invasion_faction = "wh2_dlc16_emp_empire_invasion"
			end

			local forced_battle = Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
				context:character():military_force():command_queue_index(),
				invasion_faction,
				cm:get_faction(invasion_faction):subculture(),
				19,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10),
				false,
				false,
				true,
				nil,
				nil,
				nil,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10), --increases general level based on turn number
				nil
			)

			local invasion_armies = cm:get_saved_value(invasion_data.saved_value_key) or {}
			table.insert(invasion_armies, forced_battle.target.cqi)
			cm:set_saved_value(invasion_data.saved_value_key, invasion_armies)
		end,
		true
	)

	-- Act 2 - Occupy/Colonize Marienburg as a DF or Garden
	core:add_listener(
		"Occupy_Marienburg",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():name() == episode_glottkin.faction_key and episode_glottkin.valid_occupation_options[context:occupation_decision()] and context:character():faction():is_human()
		end,
		function(context)
			local decision = context:occupation_decision()
			local region = context:garrison_residence():region()
			local region_key = region:name()

			if region_key == episode_glottkin.marienburg_key then
				local glottkin_faction_interface = cm:get_faction(episode_glottkin.faction_key);
				if cm:mission_is_active_for_faction(glottkin_faction_interface, episode_glottkin.narrative_plague_fleet_assault) then
					cm:complete_scripted_mission_objective(episode_glottkin.faction_key, episode_glottkin.narrative_plague_fleet_assault, episode_glottkin.narrative_plague_fleet_assault, true)
					core:remove_listener("Occupy_Marienburg")
				end
			end
			
		end,
		true
	)

	-- Act 2 - Build Port Landmark
	core:add_listener(
		"Plague_Fleet_Assault_Mission",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == episode_glottkin.narrative_plague_fleet_assault
		end,
		function(context)
			local glottkin_faction_interface = context:faction() 
			if glottkin_faction_interface:is_human() then
				episode_glottkin:episode_mission_ruinous_reik()
			end
		end,
		true
	)

	-- Act 2 - Ruinous Reik part 2 Dilemma
	core:add_listener(
		"Glottkin_Final_Battle_Modifiers_Mission_Rewards",
		"MissionSucceeded",
		function(context)
			return context:faction():is_human() and context:faction():name() == episode_glottkin.faction_key
		end,
		function(context)
			local mission = context:mission():mission_record_key()
			if episode_glottkin.mission_to_final_battle_modifiers[mission] then 
				core:svr_save_registry_string(episode_glottkin.mission_to_final_battle_modifiers[mission], "1")

				if mission == episode_glottkin.narrative_ruinous_reik then
					cm:trigger_dilemma(episode_glottkin.faction_key, episode_glottkin.dilemma_ruinous_reik);
				end
			end
		end,
		true
	)
	
	-- Act 2 - Grant a GUO for Planting Tier 3 Garden in Empire territory
	core:add_listener(
		"Weaking_the_Veil_Great_Unclean_one",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == episode_glottkin.narrative_weaking_the_veil
		end,
		function(context)
			local faction = context:faction() 
			if faction:is_human() then
				cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "wh3_main_nur_mon_great_unclean_one_0", 1)

				if episode_glottkin.persistent.pesticide_region ~= nil and is_string(episode_glottkin.persistent.pesticide_region) then
					local entity = {
						type = "region",
						key = {episode_glottkin.persistent.pesticide_region},
					}
					episode_glottkin.scripted_mission_data[episode_glottkin.narrative_pesticide].entity = entity
				end
				episode_glottkin:episode_mission(episode_glottkin.narrative_pesticide)
			end
		end,
		true
	)

	-- Act 2 - Gain Altdorf after winning the Final Battle
	core:add_listener(
		"Fall_of_Altdorf_Battle_Completed",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == episode_glottkin.quest_battle_fall_of_altdorf
		end,
		function(context)
			cm:transfer_region_to_faction(episode_glottkin.altdorf_settlement_key, episode_glottkin.faction_key, episode_glottkin.dark_fortress)
		end,
		true
	)

	core:add_listener(
		"Glottkin_Block_Shortcuts",
		"IncidentOccuredEvent",
		function(context)
			local faction = cm:get_faction(episode_glottkin.faction_key)

			if faction 
			and context:faction() == faction 
			and faction:is_human() then
				local key = context:dilemma()
				return key == episode_glottkin.incident_narrative_act_1 or key == episode_glottkin.incident_narrative_act_2
			end
			return false
		end,
		function(context)
			ui_scripted_tour:toggle_shortcuts(false)
		end,
		true
	)

	core:add_listener(
		"Glottkin_Unblock_Shortcuts",
		"IncidentOccuredEvent",
		function(context)
			local faction = cm:get_faction(episode_glottkin.faction_key)
			if faction 
			and context:faction() == faction 
			and faction:is_human() then
				local key = context:dilemma()
				return key == episode_glottkin.incident_narrative_act_1 or key == episode_glottkin.incident_narrative_act_2
			end
			return false
		end,
		function(context)
			core:add_listener(
				"Glottkin_Incident_Closed",
				"PanelClosedCampaign",
				true,
				function()
					ui_scripted_tour:toggle_shortcuts(true)
				end,
				false
			)
		end,
		true
	)

	core:add_listener(
		"Garden_of_Nurgle_MarkerInteraction", 
		"ScriptEvent_Garden_of_Nurgle_MarkerInteraction",
		true,
		function(context)
			local area_info = context.stored_table
			local marker_ref = area_info.marker_ref
			local invasion_faction = nil
			local invasion_data = episode_glottkin.enemy_invasion_garden_of_nurgle
			for _, faction_key in ipairs(invasion_data.faction_data) do
				local faction = cm:get_faction(faction_key)
				if faction and faction:is_dead() then
					invasion_faction = faction_key
					break
				end
			end
			if not invasion_faction then
				invasion_faction = "wh2_dlc16_emp_empire_invasion"
			end

			local forced_battle = Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
				context:character():military_force():command_queue_index(),
				invasion_faction,
				cm:get_faction(invasion_faction):subculture(),
				19,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10),
				false,
				false,
				true,
				nil,
				nil,
				nil,
				math.clamp(math.round(cm:turn_number() / 10), 1, 10),
				nil
			)


			local invasion_armies = cm:get_saved_value(invasion_data.saved_value_key) or {}
			table.insert(invasion_armies, forced_battle.target.cqi)
			cm:set_saved_value(invasion_data.saved_value_key, invasion_armies)
		end,
		true
	)

	core:add_listener(
		"ScriptEvent_Garden_of_Nurgle_MarkerExpired",
		"ScriptEvent_Garden_of_Nurgle_MarkerExpired",
		true,
		function(context)
			local marker_ref = context.stored_table.marker_ref
			local instance_ref = context.stored_table.instance_ref
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(instance_ref)
			local region_data = cm:get_region_data_at_position(x, y)
			local region = region_data:region()
			episode_glottkin.enemy_invasion_garden_of_nurgle.region_key = region:name()
			cm:remove_interactable_campaign_marker(marker_ref)
			episode_glottkin:trigger_glottkin_episode_invasion(x, y, episode_glottkin.enemy_invasion_garden_of_nurgle)

			if not episode_glottkin.garden_invasion_has_spawned_event_feed then
				cm:show_message_event_located(
					episode_glottkin.faction_key,
					"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_invasion_title_glottkin",
					"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
					"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail",
					x,
					y,
					true,
					558
				)
				episode_glottkin.garden_invasion_has_spawned_event_feed = true
			end
		end,
		true
	)

	core:add_listener(
		"Glottkin_Episode_Final_Battle_Won",
		"BattleCompleted",
		function() 
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key() == episode_glottkin.final_quest_battle_key
		end,
		function()
			-- If Glottkin won the final battle, unlock Altdorf for CAI targeting
			-- Assuming player is attacker as set in battle_set_pieces
			if cm:pending_battle_cache_attacker_value() then 
				cm:cai_enable_targeting_against_settlement(episode_glottkin.altdorf_settlement_key)
			end
		end,
		true
	)

	--- Act 5 --- 
	-- Construct Tier 5 garden in Altdorf
	core:add_listener(
		"Act_5_Corrupt_Altdorf_Building_Completed",
		"BuildingCompleted",
		function(context)
			local building = context:building()
			local faction = building:faction()
			return building:name() == episode_glottkin.nurgle_garden_tier_5 
				and faction:is_human()
				and cm:mission_is_active_for_faction(faction, episode_glottkin.final_mission_corrupt_altdorf)
		end,
		function(context)
			local region_interface = context:garrison_residence():region();
			local region_key = region_interface:name()
			local glottkin_faction_interface = context:building():faction()

			if region_key == episode_glottkin.altdorf_settlement_key then 
				cm:complete_scripted_mission_objective(episode_glottkin.faction_key, episode_glottkin.final_mission_corrupt_altdorf, episode_glottkin.final_mission_corrupt_altdorf, true)
			end
		end,
		true
	)

	-- Construct Tier 5 garden in Altdorf - settlement conversion
	core:add_listener(
		"Act_5_Corrupt_Altdorf_Settlement_Conversion",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == glottkin_gardens_of_nurgle.config.garden_conversion_ritual_key
				and cm:mission_is_active_for_faction(context:performing_faction(), episode_glottkin.final_mission_corrupt_altdorf)
		end,
		function(context)
			local region_interface = context:ritual_target_region()

			if not region_interface or region_interface:is_null_interface() then 
				return
			end

			if region_interface:name() == episode_glottkin.altdorf_settlement_key then 
				local primary_building = region_interface:settlement():primary_slot():building()

				if not primary_building or primary_building:is_null_interface() then 
					return
				end

				if primary_building:name() == episode_glottkin.nurgle_garden_tier_5 then 
					cm:complete_scripted_mission_objective(episode_glottkin.faction_key, episode_glottkin.final_mission_corrupt_altdorf, episode_glottkin.final_mission_corrupt_altdorf, true)
				end
			end
		end,
		true
	)

end