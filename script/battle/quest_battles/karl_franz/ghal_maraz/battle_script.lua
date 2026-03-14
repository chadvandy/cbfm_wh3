-- KArl Franz, Ghal Maraz, Defender
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_ghal_maraz", 6000, false, false, false);
gc:add_element("EMP_KF_GS_Qbattle_ghal_maraz_v5_pt_01", "wh_main_qb_emp_karl_franz_ghal_maraz_stage_4_pt_01", nil, 4000, true, false, false);
gc:add_element("EMP_KF_GS_Qbattle_ghal_maraz_v5_pt_02", "wh_main_qb_emp_karl_franz_ghal_maraz_stage_4_pt_02", "gc_slow_army_pan_back_right_to_back_left_far_high_01", 8000, true, false, false);
gc:add_element("EMP_KF_GS_Qbattle_ghal_maraz_v5_pt_03", "wh_main_qb_emp_karl_franz_ghal_maraz_stage_4_pt_03", "qb_final_position", 4000, true, true, false);

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
ga_empire = gb:get_army(gb:get_player_alliance_num(0), 1);
ga_dwarfs = gb:get_army(gb:get_player_alliance_num(0), 2);

ga_greenskins_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_greenskins_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
ga_greenskins_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);

ga_greenskins_02:get_army():suppress_reinforcement_adc();
ga_greenskins_03:get_army():suppress_reinforcement_adc();

-------ORDERS-------
ga_empire:message_on_proximity_to_enemy("army_routing", 10);
ga_dwarfs:reinforce_on_message("army_routing");
ga_dwarfs:attack_on_message("army_routing");

ga_greenskins_01:message_on_rout_proportion("summon_wave_02", 0.2);
ga_greenskins_02:message_on_rout_proportion("summon_wave_03", 0.1);

ga_greenskins_02:reinforce_on_message("summon_wave_02", 0);
ga_greenskins_03:reinforce_on_message("summon_wave_03", 0);

-------OBJECTIVES-------
gb:set_objective_on_message("battle_started", "wh_main_qb_emp_karl_franz_ghal_maraz_stage_4_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_emp_karl_franz_ghal_maraz_stage_4_hint_objective", 5000, 2000, 1000);
gb:queue_help_on_message("army_routing", "wh_main_qb_emp_karl_franz_ghal_maraz_stage_4_hint_allied_reinforcements", 5000, 2000, 4000);
gb:queue_help_on_message("summon_wave_02", "wh_main_qb_emp_karl_franz_ghal_maraz_stage_4_hint_enemy_reinforcements_01", 5000, 2000, 25000);
gb:queue_help_on_message("summon_wave_03", "wh_main_qb_emp_karl_franz_ghal_maraz_stage_4_hint_enemy_reinforcements_02", 5000, 2000, 25000);

-------VICTORY CONDITIONS-------
