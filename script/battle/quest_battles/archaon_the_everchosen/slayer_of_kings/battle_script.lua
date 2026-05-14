-- Archaon, Slayer of Kings, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_slayer_of_kings_pt_01", "wh_dlc01_qb_chs_archaon_slayer_of_kings_stage_3_pt_01", "gc_orbit_90_medium_commander_front_close_low_01", 4000, true, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_slayer_of_kings_pt_02", "wh_dlc01_qb_chs_archaon_slayer_of_kings_stage_3_pt_02", "gc_orbit_90_medium_commander_back_left_extreme_high_01", 4000, true, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_slayer_of_kings_pt_03", "wh_dlc01_qb_chs_archaon_slayer_of_kings_stage_3_pt_03", "gc_medium_army_pan_front_right_to_front_left_close_medium_01", 4000, true, false, false);
gc:add_element(nil, nil, "gc_fast_commander_back_medium_medium_to_close_low_01", 400, false, true, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);
gb:set_cutscene_during_deployment(true);



-------GENERALS SPEECH--------


-------ARMY SETUP-------
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 1, "reinforcements");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 3);

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");
gb:set_objective_on_message("deployment_started", "wh_dlc01_qb_chs_archaon_slayer_of_kings_stage_3_secondary_objective");

gb:complete_objective_on_message("sorceror_dead", "wh_dlc01_qb_chs_archaon_slayer_of_kings_stage_3_secondary_objective");


-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc01_qb_chs_archaon_slayer_of_kings_stage_3_hint_objective");
gb:queue_help_on_message("reinforce_1_message", "wh_dlc01_qb_chs_archaon_slayer_of_kings_stage_3_hint_reinforcements", 13000, 2000, 4000);

gb:queue_help_on_message("sorceror_dead", "wh_dlc01_qb_chs_archaon_slayer_of_kings_stage_3_hint_enemy_general_killed", 13000, 2000, 4000);

-------ORDERS-------
ga_ai_01:message_on_commander_dead_or_shattered("sorceror_dead");

gb:message_on_time_offset("trigger_reinforce_1", 1000,"battle_started");
gb:message_on_time_offset("trigger_reinforce_2", 1000,"battle_started");
gb:message_on_time_offset("trigger_reinforce_3", 1000,"battle_started");

gb:message_on_time_offset("reinforce_1_message", 31000,"trigger_reinforce_1");

ga_ai_02:deploy_at_random_intervals_on_message("trigger_reinforce_1", 1, 1, 30000, 30000, "sorceror_dead");
ga_ai_03:deploy_at_random_intervals_on_message("trigger_reinforce_2", 1, 1, 60000, 60000, "sorceror_dead");
ga_ai_04:deploy_at_random_intervals_on_message("trigger_reinforce_3", 1, 1, 120000, 120000, "sorceror_dead");

-- Kill all reinforcements not on the field. As the battle won't end until they're gone.
gb:add_listener(
	"sorceror_dead", 
	function() 
		for i = 1, ga_ai_02.sunits:count() do
			local current_sunit = ga_ai_02.sunits:item(i);
			
			if not current_sunit.unit:is_valid_target() then
				current_sunit.uc:kill();
			end
		end
		for i = 1, ga_ai_03.sunits:count() do
			local current_sunit = ga_ai_03.sunits:item(i);
			
			if not current_sunit.unit:is_valid_target() then
				current_sunit.uc:kill();
			end
		end
		for i = 1, ga_ai_04.sunits:count() do
			local current_sunit = ga_ai_04.sunits:item(i);
			
			if not current_sunit.unit:is_valid_target() then
				current_sunit.uc:kill();
			end
		end
	end
);