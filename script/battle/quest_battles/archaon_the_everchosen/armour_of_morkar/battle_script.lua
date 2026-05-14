-- Archaon, Armour of Morkar, defending
load_script_libraries();

local gc = generated_cutscene:new(true);
--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_armour_of_morkar_pt_01", "wh_dlc01_qb_chs_archaon_armour_of_morkar_stage_3_pt_01", "gc_orbit_90_medium_commander_back_right_extreme_high_01", 4000, true, false, true);
gc:add_element("CHAOS_Arc_GS_Qbattle_armour_of_morkar_pt_02", "wh_dlc01_qb_chs_archaon_armour_of_morkar_stage_3_pt_02", "gc_orbit_90_medium_commander_front_close_low_01", 4000, true, false, true);
gc:add_element("CHAOS_Arc_GS_Qbattle_armour_of_morkar_pt_03", "wh_dlc01_qb_chs_archaon_armour_of_morkar_stage_3_pt_03", "gc_orbit_90_medium_enemy_commander_front_right_close_low_01", 4000, true, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_armour_of_morkar_pt_04", "wh_dlc01_qb_chs_archaon_armour_of_morkar_stage_3_pt_04", "gc_slow_army_pan_front_left_to_right_medium_low_01", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                       -- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end,  -- intro cutscene function
	true                                       -- debug mode
);

gb:set_cutscene_during_deployment(true);



-------ARMY SETUP-------
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_defend_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc01_qb_chs_archaon_armour_of_morkar_stage_3_hint_objective");
gb:queue_help_on_message("reinforcements_1", "wh_dlc01_qb_chs_archaon_armour_of_morkar_stage_3_hint_reinforcements", 13000, 2000, 4000);


-------ORDERS-------
gb:message_on_time_offset("reinforcements_1", 20000);

ga_ai_02:reinforce_on_message("reinforcements_1");