-- Heinrich Kemmler, CLoak of Mists, Marbad's Tomb, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_cloak_mist_shadows_pt_01", "wh_main_qb_vmp_heinrich_kemmler_cloak_of_mists_stage_3_pt_01", nil, 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_cloak_mist_shadows_pt_02", "wh_main_qb_vmp_heinrich_kemmler_cloak_of_mists_stage_3_pt_02", "gc_slow_army_pan_back_left_to_back_right_far_high_01", 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_cloak_mist_shadows_pt_03", "wh_main_qb_vmp_heinrich_kemmler_cloak_of_mists_stage_3_pt_03", nil, 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_cloak_mist_shadows_pt_04", "wh_main_qb_vmp_heinrich_kemmler_cloak_of_mists_stage_3_pt_04", nil, 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_cloak_mist_shadows_pt_05", "wh_main_qb_vmp_heinrich_kemmler_cloak_of_mists_stage_3_pt_05", "qb_final_position_short", 4000, true, false, false);

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

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"army_01");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"wave_01");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 2,"wave_02");
ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 3,"wave_03");

ga_ai_02:get_army():suppress_reinforcement_adc();
ga_ai_03:get_army():suppress_reinforcement_adc();
ga_ai_04:get_army():suppress_reinforcement_adc();

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army_ambush");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_vmp_heinrich_kemmler_cloak_of_mists_stage_3_hint_objective", 5000, 2000, 1000);
gb:queue_help_on_message("summon_wave_01", "wh_main_qb_vmp_heinrich_kemmler_cloak_of_mists_stage_3_hint_reinforcements_01", 5000, 2000, 1000);
gb:queue_help_on_message("summon_wave_01", "wh_main_qb_vmp_heinrich_kemmler_cloak_of_mists_stage_3_hint_reinforcements_02", 5000, 2000, 60000);

-------ORDERS-------
ga_player_01:message_on_proximity_to_enemy("summon_wave_01", 5);

ga_ai_02:reinforce_on_message("summon_wave_01", 0);
ga_ai_03:reinforce_on_message("summon_wave_01", 60000);
ga_ai_04:reinforce_on_message("summon_wave_01", 60000);

--ga_ai_02:attack_on_message("summon_wave_01", 10000);
--ga_ai_03:attack_on_message("summon_wave_01", 15000);
--ga_ai_04:attack_on_message("summon_wave_01", 15000);