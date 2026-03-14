-- Archaon, Eye of Sheerian, Attacking
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_cliff_beasts_pan_01_to_absolute_cliff_beasts_pan_02", 4000, false, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_eye_of_sheerian_pt_01", "wh_dlc01_qb_chs_archaon_eye_of_sheerian_stage_3_pt_01", nil, 4000, true, false, false);
gc:add_element("CHAOS_Arc_GS_Qbattle_eye_of_sheerian_pt_02", "wh_dlc01_qb_chs_archaon_eye_of_sheerian_stage_3_pt_02", "gc_medium_army_pan_back_right_to_back_left_far_high_01", 4000, true, false, false);

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
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2, "reinforcements");
ga_ai_dragon_lord = gb:get_army(gb:get_non_player_alliance_num(), 2, "dragon_lord");


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");
gb:set_objective_on_message("reinforcements_1", "wh_main_qb_objective_kill_enemy_general");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc01_qb_chs_archaon_eye_of_sheerian_stage_3_hint_objective");
gb:queue_help_on_message("reinforcements_1", "wh_dlc01_qb_chs_archaon_eye_of_sheerian_stage_3_hint_reinforcements", 13000, 2000, 4000);


-------ORDERS-------
ga_ai_01:message_on_rout_proportion("reinforcements_1", 0.5);

ga_ai_02:reinforce_on_message("reinforcements_1");
ga_ai_dragon_lord:reinforce_on_message("reinforcements_1");
ga_ai_02:attack_on_message("reinforcements_1");
ga_ai_dragon_lord:attack_on_message("reinforcements_1");

ga_ai_dragon_lord:message_on_casualties("dragon_lord_killed", 1);
ga_player_01:force_victory_on_message("dragon_lord_killed");