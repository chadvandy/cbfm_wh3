-- Grimgor Ironhide,Blood forged armour stage 4, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_blood_forged_armour2_pt_01", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_4_pt_01", nil, 4000, true, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_blood_forged_armour2_pt_02", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_4_pt_02", "gc_orbit_ccw_360_slow_commander_back_left_close_low_01", 4000, true, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_blood_forged_armour2_pt_03", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_4_pt_03", nil, 4000, true, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_blood_forged_armour2_pt_04", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_4_pt_04", "gc_medium_enemy_army_pan_back_left_to_back_right_far_high_01", 4000, true, false, false);
gc:add_element(nil, nil, "gc_fast_commander_back_medium_medium_to_close_low_01", 400, false, true, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);


-- Stage 4: Grimgor vs reforming chaos invaders

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 1, "reinforcement1");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 1, "reinforcement2");
ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 1, "reinforcement3");

ga_ai_02:reinforce_on_message("battle_started", 65000);
ga_ai_03:reinforce_on_message("battle_started", 140000);
ga_ai_04:reinforce_on_message("battle_started", 220000);

ga_ai_01:release_on_message("battle_started");
ga_ai_02:release_on_message("battle_started");
ga_ai_03:release_on_message("battle_started");
ga_ai_04:release_on_message("battle_started");


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_4_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_4_hint_objective");
gb:queue_help_on_message("battle_started", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_4_hint_reinforcements", 13000, 2000, 66000);