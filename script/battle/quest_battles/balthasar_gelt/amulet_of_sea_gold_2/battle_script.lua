-- Balthasar Gelt, Amulet of Sea Gold 4.2, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

-------GENERALS SPEECH--------
local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "qb_estalian_tomb_01", 4000, false, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_sea_gold_amulet2_pt_01", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_1_pt_01", nil, 2000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_sea_gold_amulet2_pt_02", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_1_pt_02", "qb_estalian_tomb_02", 15000, false, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_sea_gold_amulet2_pt_03", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_1_pt_03", nil, 7000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_sea_gold_amulet2_pt_04", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_1_pt_04", "qb_estalian_tomb_03", 12000, true, false, false);

-------BATTLE SETUP--------

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      -- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);
gb:set_cutscene_during_deployment(true);

-------AUDIO-------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "army_01");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_east");
ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), "wave_01_west");

ga_ai_02:get_army():suppress_reinforcement_adc();
ga_ai_03:get_army():suppress_reinforcement_adc();
ga_ai_04:get_army():suppress_reinforcement_adc();

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_hint_objective", 4000, 2000, 1000);
gb:queue_help_on_message("summon_wave_01", "wh_main_qb_emp_balthasar_gelt_amulet_of_sea_gold_stage_4_hint_enemy_reinforcements_01", 3000, 2000, 20000);

-------ORDERS-------
ga_player_01:message_on_proximity_to_enemy("summon_wave_01", 150);

ga_ai_02:reinforce_on_message("summon_wave_01", 125000);
ga_ai_03:reinforce_on_message("summon_wave_01", 125000);
ga_ai_04:reinforce_on_message("summon_wave_01", 0);
