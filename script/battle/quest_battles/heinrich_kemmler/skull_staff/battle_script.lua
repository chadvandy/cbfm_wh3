-- Heinrich Kemmler, Skull Staff, La Maisontaal, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_la_maisontaal_lady_01_02", 4000, false, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_skull_staff_pt_01", "wh_main_qb_vmp_heinrich_kemmler_skull_staff_stage_3_pt_01", nil, 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_skull_staff_pt_02", "wh_main_qb_vmp_heinrich_kemmler_skull_staff_stage_3_pt_02", nil, 4000, true, false, true);
gc:add_element("VAMP_Kemm_GS_Qbattle_skull_staff_pt_03", "wh_main_qb_vmp_heinrich_kemmler_skull_staff_stage_3_pt_03", "gc_orbit_ccw_360_slow_commander_front_left_close_low_01", 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_skull_staff_pt_04", "wh_main_qb_vmp_heinrich_kemmler_skull_staff_stage_3_pt_04", "gc_medium_absolute_la_maisontaal_abbey_01_02", 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_skull_staff_pt_05", "wh_main_qb_vmp_heinrich_kemmler_skull_staff_stage_3_pt_05", nil, 6000, false, false, false);
gc:add_element(nil, nil, "gc_medium_army_pan_back_right_to_back_left_far_high_01", 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_skull_staff_pt_06", "wh_main_qb_vmp_heinrich_kemmler_skull_staff_stage_3_pt_06", "gc_orbit_360_slow_commander_front_right_close_low_01", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      -- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);



-------GENERALS SPEECH--------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ally_01 = gb:get_army(gb:get_player_alliance_num(), "attacker_1");

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "defender_1");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "defender_2");

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_vmp_heinrich_kemmler_skull_staff_stage_3_hint_objective");
gb:queue_help_on_message("vampires_approaching_mercenaries", "wh_main_qb_vmp_heinrich_kemmler_skull_staff_stage_3_hint_empire", 13000, 2000, 4000);


-------ORDERS-------
ga_ally_01:message_on_proximity_to_ally("vampires_approaching_mercenaries", 150);
ga_ally_01:rout_over_time_on_message("vampires_approaching_mercenaries", 10000);