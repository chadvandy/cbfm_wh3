-- Prince Sigvald, Sliverslash, Defender
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, false, false);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, taunt)
gc:add_element(nil, nil, "gc_medium_absolute_cliff_beasts_pan_01_to_absolute_cliff_beasts_pan_02", 4000, false, false, false);
gc:add_element("CHAOS_Sig_GS_Qbattle_sliverslash_pt_01", "wh_dlc01_qb_chs_prince_sigvald_sliverslash_stage_4_pt_01", nil, 4000, true, false, false);
gc:add_element("CHAOS_Sig_GS_Qbattle_sliverslash_pt_02", "wh_dlc01_qb_chs_prince_sigvald_sliverslash_stage_4_pt_02", "gc_orbit_90_medium_commander_back_left_extreme_high_01", 4000, true, false, false);
gc:add_element("CHAOS_Sig_GS_Qbattle_sliverslash_pt_03", "wh_dlc01_qb_chs_prince_sigvald_sliverslash_stage_4_pt_03", "gc_orbit_90_medium_commander_front_right_close_low_01", 4000, true, false, false);
gc:add_element("CHAOS_Sig_GS_Qbattle_sliverslash_pt_04", "wh_dlc01_qb_chs_prince_sigvald_sliverslash_stage_4_pt_04", nil, 4000, true, false, false);

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
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1); -- initial
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2); -- cavalry
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3); -- horrors

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_defend_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc01_qb_chs_prince_sigvald_sliverslash_stage_4_hint_objective");


gb:queue_help_on_message("reinforcement_one", "wh_dlc01_qb_chs_prince_sigvald_sliverslash_stage_4_hint_reinforcements");



gb:queue_help_on_message("reinforcement_two", "wh_dlc01_qb_chs_prince_sigvald_sliverslash_stage_4_hint_reinforcements_2");

-------ORDERS-------
gb:message_on_time_offset("reinforcement_one", 50000);
gb:message_on_time_offset("reinforcement_two", 110000);

ga_ai_02:reinforce_on_message("reinforcement_one", 0);
ga_ai_03:reinforce_on_message("reinforcement_two", 0);

ga_ai_02:message_on_deployed("first_attack") 
ga_ai_03:message_on_deployed("second_attack") 

ga_ai_02:attack_on_message("first_attack");

ga_ai_01:attack_on_message("second_attack");
ga_ai_03:attack_on_message("second_attack");






