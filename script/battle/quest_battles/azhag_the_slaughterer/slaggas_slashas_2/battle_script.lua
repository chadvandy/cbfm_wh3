--Azhag, Slaggas Slashas Stage 4, Attacker
-- Should match armour of templehof --

load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_ccw_360_slow_ground_offset_south_east_extreme_high_02", 4000, false, false, false);
gc:add_element("ORC_Azh_GS_Qbattle_slaggas_slashas2_FULL_REV_17_02", "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_4_pt_01", "gc_orbit_90_medium_commander_front_left_close_low_01", 7250, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_4_pt_02", "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 7490, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_4_pt_03", "gc_slow_commander_front_medium_medium_to_close_low_01", 10600, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_4_pt_04", "gc_medium_army_pan_front_right_to_front_left_far_high_01", 3769, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_4_pt_05", "gc_orbit_90_medium_commander_front_left_close_low_01", 12800, true, false, false);

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
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_4_hint_objective");
gb:queue_help_on_message("battle_started", "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_4_hint_reinforcements", 13000, 2000, 4000);


-------ORDERS-------

ga_ai_02:reinforce_on_message("battle_started");
ga_ai_02:message_on_proximity_to_enemy("player_close", 340);
ga_ai_01:message_on_proximity_to_enemy("player_close", 500);
ga_ai_01:attack_on_message("player_close", 50);