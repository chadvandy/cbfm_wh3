-- Archaon, Crown of Domination, Attacking
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_crown_of_command_pt_01", "wh_dlc01_qb_chs_archaon_crown_of_domination_stage_2_pt_01", "gc_orbit_ccw_90_medium_commander_front_left_extreme_high_01", 4000, true, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_crown_of_command_pt_02", "wh_dlc01_qb_chs_archaon_crown_of_domination_stage_2_pt_02", "gc_orbit_ccw_90_medium_commander_back_left_close_low_01", 4000, true, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_crown_of_command_pt_03", "wh_dlc01_qb_chs_archaon_crown_of_domination_stage_2_pt_03", nil, 4000, true, false, false);
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
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_dlc01_qb_chs_archaon_crown_of_domination_stage_2_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc01_qb_chs_archaon_crown_of_domination_stage_2_hint_objective");
gb:queue_help_on_message("reinforcements_1", "wh_dlc01_qb_chs_archaon_crown_of_domination_stage_2_hint_reinforcements", 13000, 2000, 4000);


-------ORDERS-------
gb:message_on_time_offset("reinforcements_1", 60000);

ga_ai_02:reinforce_on_message("reinforcements_1");