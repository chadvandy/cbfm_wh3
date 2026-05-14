-- Thorgrim, Armour of skaldour, Defender
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_armour_of_skaldour_pt_01", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_pt_01", "gc_orbit_90_medium_commander_back_close_low_01", 4000, true, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_armour_of_skaldour_pt_02", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_pt_02", "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 4000, true, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_armour_of_skaldour_pt_03", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_pt_03", nil, 4000, true, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_armour_of_skaldour_pt_04", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_pt_04", "gc_slow_enemy_army_pan_front_left_to_front_right_far_high_01", 4000, true, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_armour_of_skaldour_pt_05", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_pt_05", "gc_orbit_90_medium_commander_front_right_close_low_01", 4000, true, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_armour_of_skaldour_pt_06", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_pt_06", "gc_medium_commander_back_medium_medium_to_close_low_01", 4000, true, true, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);



-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1); --main + reinforcements
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_hint_objective");


gb:queue_help_on_message("reinforcements_1", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_hint_reinforcements_1", 13000, 2000, 4000);



gb:queue_help_on_message("reinforcements_2", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_hint_reinforcements_2", 13000, 2000, 4000);


gb:queue_help_on_message("reinforcements_3", "wh_main_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour_stage_4_hint_reinforcements_2", 13000, 2000, 4000);

-------ORDERS-------
gb:message_on_time_offset("reinforcements_1", 10000);
gb:message_on_time_offset("reinforcements_2", 40000);
gb:message_on_time_offset("reinforcements_3", 80000);

ga_ai_01:reinforce_on_message("reinforcements_1");
ga_ai_02:reinforce_on_message("reinforcements_2");
ga_ai_03:reinforce_on_message("reinforcements_3");