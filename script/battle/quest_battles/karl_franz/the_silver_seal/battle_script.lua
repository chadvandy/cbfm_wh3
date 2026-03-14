-- Karl Franz, Silver Seal 3.1, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, play_taunt)
gc:add_element(nil, nil, "gc_slow_absolute_shrine_omen_hill_pan_01_to_absolute_shrine_omen_hill_pan_02", 4000, false, false, false);
gc:add_element("EMP_KF_GS_Qbattle_silver_seal_pt_01", "wh_main_qb_emp_karl_franz_silver_seal_stage_3.1_pt_01", nil, 4000, true, false, false);
gc:add_element("EMP_KF_GS_Qbattle_silver_seal_pt_02", "wh_main_qb_emp_karl_franz_silver_seal_stage_3.1_pt_02", "gc_orbit_90_medium_commander_back_left_extreme_high_01", 4000, true, false, false);
gc:add_element("EMP_KF_GS_Qbattle_silver_seal_pt_03", "wh_main_qb_emp_karl_franz_silver_seal_stage_3.1_pt_03", "gc_slow_absolute_shrine_omen_hill_pan_03_to_absolute_shrine_omen_hill_pan_04", 4000, true, false, true);
gc:add_element("EMP_KF_GS_Qbattle_silver_seal_pt_04", "wh_main_qb_emp_karl_franz_silver_seal_stage_3.1_pt_04", nil, 4000, true, false, false);
gc:add_element("EMP_KF_GS_Qbattle_silver_seal_pt_05", "wh_main_qb_emp_karl_franz_silver_seal_stage_3.1_pt_05", "gc_orbit_90_medium_commander_front_close_low_01", 4000, true, true, true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      -- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);
-- Karl vs Vampiress with reinforcements


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "defender_1");

ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "defender_2");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "defender_3");

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_emp_karl_franz_silver_seal_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_emp_karl_franz_silver_seal_hint_objective");
gb:queue_help_on_message("battle_started", "wh_main_qb_emp_karl_franz_silver_seal_hint_reinforcements", 13000, 2000, 10000);

-------ORDERS-------
ga_ai_02:attack_on_message("battle_started");
ga_ai_03:attack_on_message("battle_started");

ga_ai_02:reinforce_on_message ("battle_started", 10000);
ga_ai_03:reinforce_on_message ("battle_started", 12500);