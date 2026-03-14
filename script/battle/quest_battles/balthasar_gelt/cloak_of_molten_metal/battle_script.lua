-- Balthasar Gelt, Cloak of Molten metal 3.1, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_broken_leg", 4000, false, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_molten_metal_cloak1_pt_01", "wh_main_qb_emp_balthasar_gelt_cloak_of_molten_metal_stage_3.1_pt_01", nil, 4000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_molten_metal_cloak1_pt_02", "wh_main_qb_emp_balthasar_gelt_cloak_of_molten_metal_stage_3.1_pt_02", "gc_slow_army_pan_front_left_to_front_right_far_high_01", 4000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_molten_metal_cloak1_pt_03", "wh_main_qb_emp_balthasar_gelt_cloak_of_molten_metal_stage_3.1_pt_03", "gc_orbit_90_medium_commander_front_left_close_low_01", 4000, true, false, false);
gc:add_element(nil, nil, "qb_final_position_short", 4000, false, true, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      -- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);


-- Gelt vs Greenskins, easier battle

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02_reinforcement = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_03_reinforcement = gb:get_army(gb:get_non_player_alliance_num(), 3);
ga_ai_04_reinforcement = gb:get_army(gb:get_non_player_alliance_num(), 4);

ga_ai_02_reinforcement:release_on_message("battle_started");
ga_ai_03_reinforcement:release_on_message("battle_started");
ga_ai_04_reinforcement:release_on_message("battle_started");

ga_player_01:message_on_proximity_to_enemy("start_reinforcement1", 100);
ga_player_01:message_on_proximity_to_enemy("start_reinforcement2", 50);
ga_player_01:message_on_proximity_to_enemy("start_reinforcement3", 10);

ga_ai_02_reinforcement:reinforce_on_message("start_reinforcement1");
ga_ai_03_reinforcement:reinforce_on_message("start_reinforcement2");
ga_ai_04_reinforcement:reinforce_on_message("start_reinforcement3");


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_emp_balthasar_gelt_cloak_of_molten_metal_hint_objective", 6000, 2000, 1000);
gb:queue_help_on_message("start_reinforcement1", "wh_main_qb_emp_balthasar_gelt_cloak_of_molten_metal_hint_reinforcements", 6000, 2000, 1000);