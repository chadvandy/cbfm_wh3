-- Balthasar Gelt, Amulet of Sea Gold 4.1, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_slow_absolute_marbads_tomb", 6000, false, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_sea_gold_amulet1_PT_01", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4.1_pt_01", nil, 8000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_sea_gold_amulet1_PT_02", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4.1_pt_02", "gc_slow_army_pan_back_left_to_back_right_far_high_01", 4000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_sea_gold_amulet1_PT_03", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4.1_pt_03", nil, 4000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_sea_gold_amulet1_PT_04", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4.1_pt_04", "qb_final_position_short", 4000, true, false, false);


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

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);

ga_ai_02:get_army():suppress_reinforcement_adc();
ga_ai_03:get_army():suppress_reinforcement_adc();

-------OBJECTIVES-------
gb:set_objective_on_message("battle_started", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_hint_objective", 4000, 2000, 1000);
gb:queue_help_on_message("summon_wave_01", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_hint_enemy_reinforcements_01", 3000, 2000, 10000);

-------ORDERS-------
ga_player_01:message_on_proximity_to_enemy("summon_wave_01", 20);
ga_ai_02:reinforce_on_message("summon_wave_01", 1000);
ga_ai_03:reinforce_on_message("summon_wave_01", 1000);
ga_ai_02:attack_on_message("summon_wave_01", 1000);
ga_ai_03:attack_on_message("summon_wave_01", 1000);