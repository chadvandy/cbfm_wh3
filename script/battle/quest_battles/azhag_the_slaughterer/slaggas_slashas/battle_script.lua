--Azhag, Slaggas Slashas Stage 2, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("ORC_Azh_GS_Qbattle_slaggas_slashas1_FULL_24_02", "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_2_pt_01", "gc_slow_commander_front_medium_medium_to_close_low_01", 13550, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_2_pt_02", "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 4100, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_2_pt_03", nil, 9000, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_2_pt_04", "gc_orbit_90_medium_commander_front_left_close_low_01", 7500, false, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);
gb:set_cutscene_during_deployment(true);


-- Azhag vs Empire with Mortar detachment and Steam Tank reinforcement

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);

--ga_ai_01:defend_on_message("battle_started", -45, 369, 30); 

--ga_ai_01:release(true);
ga_ai_02:attack_on_message("battle_started")

ga_ai_01:release_on_message("battle_started");  --- hill in south east 200, -255, 40
--ga_ai_02:release_on_message("battle_started");  --- hill in south east 200, -255, 40
ga_ai_03:release_on_message("battle_started");
ga_ai_03:reinforce_on_message("battle_started", 90000);

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_2_hint_reinforcements", 13000, 2000, 87000);


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_grn_azhag_the_slaughterer_slaggas_slashas_stage_2_main_objective");
