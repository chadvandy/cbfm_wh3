-- Mannfred Von Carstein, Armour of Templehof Stage 3, Barrier Idols, Attacker
-- Should match Slagga's Slashas 2 --

load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("wh_qbattle_prelude_armour_of_templehof_1_pt_01_rev_15_02", "wh_main_qb_vmp_mannfred_von_carstein_armour_of_templehof_stage_3_pt_01", "gc_medium_army_pan_front_right_to_front_left_far_high_01", 4000, true, false, false);
gc:add_element("wh_qbattle_prelude_armour_of_templehof_1_pt_02_rev_15_02", "wh_main_qb_vmp_mannfred_von_carstein_armour_of_templehof_stage_3_pt_02", "gc_orbit_90_medium_commander_back_left_close_low_01", 4000, true, false, false);
gc:add_element("wh_qbattle_prelude_armour_of_templehof_1_pt_03_rev_15_02", "wh_main_qb_vmp_mannfred_von_carstein_armour_of_templehof_stage_3_pt_03", "gc_medium_commander_back_medium_medium_to_close_low_01", 4000, true, false, false);

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
gb:queue_help_on_message("battle_started", "wh_main_qb_vmp_mannfred_von_carstein_armour_of_templehof_stage_3_hint_objective");
gb:queue_help_on_message("battle_started", "wh_main_qb_vmp_mannfred_von_carstein_armour_of_templehof_stage_3_hint_reinforcements", 13000, 2000, 12000);


-------ORDERS-------

ga_ai_02:reinforce_on_message("battle_started", 10000);