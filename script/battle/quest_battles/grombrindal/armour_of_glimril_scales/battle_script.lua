-- Grombrindal - Armour of Glimril Scales - Defender
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_Glimril_Scales_pt_01", "wh_pro01_qb_dwf_grombrindal_glimril_scales_pt_01", nil, 4000, true, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_Glimril_Scales_pt_02", "wh_pro01_qb_dwf_grombrindal_glimril_scales_pt_02", "gc_slow_army_pan_back_left_to_back_right_far_high_01", 4000, true, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_Glimril_Scales_pt_03", "wh_pro01_qb_dwf_grombrindal_glimril_scales_pt_03", nil, 4000, true, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_Glimril_Scales_pt_04", "wh_pro01_qb_dwf_grombrindal_glimril_scales_pt_04", "qb_final_position_short", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);



-------GENERALS SPEECH--------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_main");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "bst_enemy");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "spawn_1");
ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), "spawn_2");



-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_pro01_qb_dwf_grombrindal_armour_of_glimril_stage_3_hint_objective", 4000, 2000, 1000);
gb:queue_help_on_message("wave_arrive", "wh_pro01_qb_dwf_grombrindal_armour_of_glimril_stage_3_hint_reinforcements", 3000, 2000, 10000);

-------ORDERS-------
ga_player_01:message_on_proximity_to_enemy("summon_wave_01", 60);
ga_player_01:message_on_proximity_to_enemy("summon_wave_02", 20);
ga_ai_01:halt();
ga_ai_01:attack_on_message("battle_started", 30000);

ga_ai_02:halt();
ga_ai_02:attack_on_message("battle_started",1000);

ga_ai_03:reinforce_on_message("summon_wave_01", 90000);
ga_ai_03:attack_on_message("summon_wave_01", 90000);

ga_ai_04:reinforce_on_message("summon_wave_02", 90000);
ga_ai_04:attack_on_message("summon_wave_02", 90000);
ga_ai_04:message_on_deployed("wave_arrive"); 