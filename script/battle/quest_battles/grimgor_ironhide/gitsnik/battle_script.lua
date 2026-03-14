-- Grimgor Ironhide, Gitsnik, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_prelude_gitsnik_pt_01", "wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_pt_01", nil, 4000, true, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_prelude_gitsnik_pt_02", "wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_pt_02", "gc_medium_army_pan_back_right_to_back_left_far_high_01", 4000, true, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_prelude_gitsnik_pt_03", "wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_pt_03", nil, 4000, true, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_prelude_gitsnik_pt_04", "wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_pt_04", "qb_final_position_sub", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      -- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);




-------GENERALS SPEECH--------


-------ARMY SETUP-------
ga_greenskins = gb:get_army(gb:get_player_alliance_num(0), 1);

ga_dwarfs = gb:get_army(gb:get_non_player_alliance_num(1), 2);
ga_empire = gb:get_army(gb:get_non_player_alliance_num(1), 1);

-------OBJECTIVES-------
gb:set_objective_on_message("battle_started", "wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_main_objective");

-------HINTS-------

gb:queue_help_on_message("battle_started", "wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_hint_objective", 4000, 2000, 1000);
gb:queue_help_on_message("summon_wave_01", "wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_hint_enemy_reinforcements_01", 3000, 2000, 1000);
gb:queue_help_on_message("empire_defeated", "wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_hint_empire_defeated", 5000, 2000, 25000);
gb:queue_help_on_message("dwarfs_defeated", "wh_main_qb_grn_grimgor_ironhide_gitsnik_stage_4_hint_dwarfs_defeated", 5000, 2000, 25000);

-------ORDERS-------
ga_greenskins:message_on_proximity_to_enemy("summon_wave_01", 20);
ga_dwarfs:reinforce_on_message("summon_wave_01", 1000);
ga_empire:message_on_rout_proportion("empire_defeated", 0.8);
ga_dwarfs:message_on_rout_proportion("dwarfs_defeated", 0.8);