-- Heinrich Kemmler, Chaos TOmb Blade, Glacial Lake, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_glacial_lake", 4000, false, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_tomb_blade_pt_01", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_pt_01", nil, 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_tomb_blade_pt_02", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_pt_02", "gc_slow_army_pan_back_right_to_back_left_far_high_01", 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_tomb_blade_pt_03", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_pt_03", nil, 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_tomb_blade_pt_04", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_pt_04", "gc_orbit_360_slow_commander_back_right_close_low_01", 4000, true, false, false);
gc:add_element("VAMP_Kemm_GS_Qbattle_tomb_blade_pt_05", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_pt_05", "qb_final_position_short", 6000, true, false, false);

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
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(),"army_01");

ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(),"wave_01_inf");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(),"wave_02_inf");

ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(),"wave_01_cav");
ga_ai_05 = gb:get_army(gb:get_non_player_alliance_num(),"wave_02_cav");

ga_ai_06 = gb:get_army(gb:get_non_player_alliance_num(),"wave_01_light_cav");
ga_ai_07 = gb:get_army(gb:get_non_player_alliance_num(),"wave_02_light_cav");

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_main_objective");
gb:complete_objective_on_message("summon_wave_01", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_main_objective");

gb:add_listener(
	"summon_wave_01", 
	function() gb:message_on_time_offset("defend_phase", 5000); end
);

gb:set_objective_on_message("defend_phase", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_second_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_hint_objective", 4000, 2000, 1000);
gb:queue_help_on_message("defend_phase", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_hint_reinforcements_01", 1500, 1000, 500);
gb:queue_help_on_message("defend_phase", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_hint_reinforcements_02", 3500, 1000, 2000);
gb:queue_help_on_message("summon_wave_02", "wh_main_qb_vmp_heinrich_kemmler_chaos_tomb_blade_stage_4_hint_reinforcements_03", 5000, 2000, 12000);

-------ORDERS-------
ga_player_01:message_on_proximity_to_enemy("summon_wave_01", 10);
ga_ai_01:message_on_rout_proportion("summon_wave_02", 0.3);

ga_ai_02:reinforce_on_message("summon_wave_01", 5000);
ga_ai_03:reinforce_on_message("summon_wave_02", 15000);
ga_ai_04:reinforce_on_message("summon_wave_01", 0);
ga_ai_05:reinforce_on_message("summon_wave_02", 10000);
ga_ai_06:reinforce_on_message("summon_wave_01", 10000);
ga_ai_07:reinforce_on_message("summon_wave_02", 20000);

ga_ai_02:get_army():suppress_reinforcement_adc();
ga_ai_03:get_army():suppress_reinforcement_adc();
ga_ai_04:get_army():suppress_reinforcement_adc();
ga_ai_05:get_army():suppress_reinforcement_adc();
ga_ai_06:get_army():suppress_reinforcement_adc();
ga_ai_07:get_army():suppress_reinforcement_adc();
