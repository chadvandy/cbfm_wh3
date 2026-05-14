-- Ungrim, Cloak of Fyrskar 5, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_broken_leg", 6000, false, false, false);
gc:add_element("DWF_Un_GS_Qbattle_fyskar_cloak_pt_01", "wh_main_qb_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar_stage_4_pt_01", nil, 4000, true, false, false);
gc:add_element("DWF_Un_GS_Qbattle_fyskar_cloak_pt_02", "wh_main_qb_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar_stage_4_pt_02", "gc_slow_army_pan_front_left_to_front_right_far_high_01", 4000, true, false, false);
gc:add_element("DWF_Un_GS_Qbattle_fyskar_cloak_pt_03", "wh_main_qb_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar_stage_4_pt_03", nil, 4000, true, false, false);
gc:add_element("DWF_Un_GS_Qbattle_fyskar_cloak_pt_04", "wh_main_qb_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar_stage_4_pt_04", "qb_final_position_short", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);



---DWF vs Greenskins, regular version
-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_01_reinforcement = gb:get_army(gb:get_non_player_alliance_num(), 1, "reinforcement");
ga_ai_01_reinforcement_02 = gb:get_army(gb:get_non_player_alliance_num(), 1, "reinforcement_02");

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar_stage_3.2_main_objective");


-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar_stage_3.2_hint_objective", 6000, 2000, 1000);
gb:queue_help_on_message("start_reinforcement", "wh_main_qb_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar_stage_3.2_hint_reinforcements", 6000, 2000, 1000);

-------ORDERS-------
ga_ai_01:release_on_message("battle_started");
ga_ai_01_reinforcement:release_on_message("start_reinforcement");
ga_ai_01_reinforcement_02:release_on_message("start_reinforcement");

ga_player_01:message_on_proximity_to_enemy("start_reinforcement", 100);

ga_ai_01_reinforcement:reinforce_on_message("start_reinforcement", 1000);
ga_ai_01_reinforcement_02:reinforce_on_message("start_reinforcement", 1000);