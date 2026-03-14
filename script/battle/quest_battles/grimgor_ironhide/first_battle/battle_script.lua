-- Grimgor Ironhide,Intro Subterranean, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_slow_absolute_thundering_falls_waterfalls_01_to_absolute_thundering_falls_waterfalls_02", 5000, false, false, false);

-- This stops the game playing the regular cutscene if the player has NOT brought Grimgor into the battle.
if gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh_main_grn_cha_grimgor_ironhide") then
	gc:add_element("ORC_Grim_GS_Qbattle_prelude_grimgor_pt_01", "wh_main_qb_grn_grimgor_ironhide_intro_subterranean_pt_01", nil, 4000, true, false, false);
	gc:add_element("ORC_Grim_GS_Qbattle_prelude_grimgor_pt_02", "wh_main_qb_grn_grimgor_ironhide_intro_subterranean_pt_02", "gc_orbit_360_slow_commander_front_left_close_low_01", 4000, true, false, false);
	gc:add_element("ORC_Grim_GS_Qbattle_prelude_grimgor_pt_03", "wh_main_qb_grn_grimgor_ironhide_intro_subterranean_pt_03", "gc_medium_army_pan_front_right_to_front_left_far_high_01", 4000, true, false, false);
	gc:add_element("ORC_Grim_GS_Qbattle_prelude_grimgor_pt_04", "wh_main_qb_grn_grimgor_ironhide_intro_subterranean_pt_04", "gc_slow_absolute_thundering_falls_shrine_01_to_absolute_thundering_falls_shrine_02", 4000, true, false, false);
	gc:add_element("ORC_Grim_GS_Qbattle_prelude_grimgor_pt_05", "wh_main_qb_grn_grimgor_ironhide_intro_subterranean_pt_05", "qb_final_position_sub", 4000, true, false, false);
else
	gc:add_element(nil, nil, "gc_slow_absolute_thundering_falls_entrance_01_to_absolute_thundering_falls_entrance_02", 5000, true, false, false); -- Bridge
	gc:add_element(nil, nil, "qb_final_position_sub", 5000, false, true, false);-- Army Pan
end;

-------BATTLE SETUP--------

gb:set_cutscene_during_deployment(true);

-------AUDIO-------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 1, "gyrocopters");

-------ORDERS-------
ga_player_01:message_on_proximity_to_enemy("player_visible", 50);
ga_player_01:message_on_proximity_to_enemy("player_advancing", 130);
ga_ai_01:attack_on_message("player_advancing", 3000);

ga_ai_02:reinforce_on_message("player_visible", 60000);


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_grn_grimgor_ironhide_subterranean_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_grn_grimgor_ironhide_subterranean_hint_objective");
gb:queue_help_on_message("player_visible", "wh_main_qb_grn_grimgor_ironhide_subterranean_hint_reinforcement", 13000, 2000, 60000);
