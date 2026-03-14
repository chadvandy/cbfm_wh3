--Azhag, Crown of Scorcery, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_todtheim_city_01_02", 4000, false, false, false);
gc:add_element("ORC_Azh_GS_Qbattle_crown_of_sorcery_pt_01", "wh_main_qb_grn_azhag_the_slaughterer_crown_of_sorcery_stage_3_pt_01", nil, 4000, true, false, false);
gc:add_element("ORC_Azh_GS_Qbattle_crown_of_sorcery_pt_02", "wh_main_qb_grn_azhag_the_slaughterer_crown_of_sorcery_stage_3_pt_02", "gc_medium_asbolute_todtheim_ceiling_01", 4000, true, false, false);
gc:add_element("ORC_Azh_GS_Qbattle_crown_of_sorcery_pt_03", "wh_main_qb_grn_azhag_the_slaughterer_crown_of_sorcery_stage_3_pt_03", "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 4000, true, false, false);
gc:add_element("ORC_Azh_GS_Qbattle_crown_of_sorcery_pt_04", "wh_main_qb_grn_azhag_the_slaughterer_crown_of_sorcery_stage_3_pt_04", "gc_orbit_90_medium_commander_front_left_close_low_01", 4000, true, false, false);

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
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1); -- Initial Chaos Force
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2); -- Undead Land Force
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3); -- Undead Fliers 1
ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 4); -- Undead Fliers 2

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_grn_azhag_the_slaughterer_crown_of_sorcery_stage_3_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_grn_azhag_the_slaughterer_crown_of_sorcery_stage_3_hint_objective");
gb:queue_help_on_message("reinforcements_2", "wh_main_qb_grn_azhag_the_slaughterer_crown_of_sorcery_stage_3_hint_reinforcements");

-------ORDERS-------
ga_ai_01:attack_on_message("battle_started");

gb:message_on_time_offset("reinforcements_1", 20000);
ga_ai_02:message_on_proximity_to_enemy("reinforcements_2", 150);

ga_ai_02:reinforce_on_message("reinforcements_1");
ga_ai_03:deploy_at_random_intervals_on_message("reinforcements_2", 2, 4, 10000, 30000);
ga_ai_04:deploy_at_random_intervals_on_message("reinforcements_2", 5, 10, 1000, 10000);