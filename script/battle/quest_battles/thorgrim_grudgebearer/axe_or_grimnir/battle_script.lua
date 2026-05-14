-- Thorgrim, Axe of Grimnir, Attacker, Pillar of Bone.
-- Uses data from Sword of Unholy power.

load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);
--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_axe_of_grimnir_pt_01", "wh_main_qb_dwf_thorgrim_grudgebearer_axe_of_grimnir_stage_3_pt_01", "army_pan_front_close", 4000, true, true, false);
gc:add_element("DWF_Thor_GS_Qbattle_axe_of_grimnir_pt_02", "wh_main_qb_dwf_thorgrim_grudgebearer_axe_of_grimnir_stage_3_pt_02", "gc_orbit_90_medium_commander_front_left_close_low_01", 4000, true, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_axe_of_grimnir_pt_03", "wh_main_qb_dwf_thorgrim_grudgebearer_axe_of_grimnir_stage_3_pt_03", nil, 4000, true, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_axe_of_grimnir_pt_04", "wh_main_qb_dwf_thorgrim_grudgebearer_axe_of_grimnir_stage_3_pt_04", "qb_sword_of_unholy_power_pillar_of_bone_pan", 4000, true, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_axe_of_grimnir_pt_05", "wh_main_qb_dwf_thorgrim_grudgebearer_axe_of_grimnir_stage_3_pt_05", "gc_orbit_ccw_90_medium_commander_front_close_low_01", 4000, true, false, false);
gc:add_element("DWF_Thor_GS_Qbattle_axe_of_grimnir_pt_06", "wh_main_qb_dwf_thorgrim_grudgebearer_axe_of_grimnir_stage_3_pt_06", nil, 4000, true, false, false);
gc:add_element(nil,nil, nil, 3000, true, true, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                       -- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end,  -- intro cutscene function
	true                                       -- debug mode
);

gb:set_cutscene_during_deployment(true);



num_shamans_killed = 0;
required_shaman_kills = 4;


-------GENERALS SPEECH--------

-------ARMY SETUP-------
-- Get all our armies
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_shaman_01 = gb:get_army(gb:get_non_player_alliance_num(), 1, "grn_shaman_1");
ga_ai_shaman_02 = gb:get_army(gb:get_non_player_alliance_num(), 1, "grn_shaman_2");
ga_ai_shaman_03 = gb:get_army(gb:get_non_player_alliance_num(), 1, "grn_shaman_3");
ga_ai_shaman_04 = gb:get_army(gb:get_non_player_alliance_num(), 1, "grn_shaman_4");
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_vmp_mannfred_von_carstein_sword_of_unholy_power_stage_4_main_objective", 0, 0, 4);
gb:set_objective_on_message("one_shaman_dead", "wh_main_qb_vmp_mannfred_von_carstein_sword_of_unholy_power_stage_4_main_objective", 0, 1, 4);
gb:set_objective_on_message("two_shamans_dead", "wh_main_qb_vmp_mannfred_von_carstein_sword_of_unholy_power_stage_4_main_objective", 0, 2, 4);
gb:set_objective_on_message("three_shamans_dead", "wh_main_qb_vmp_mannfred_von_carstein_sword_of_unholy_power_stage_4_main_objective", 0, 3, 4);
gb:set_objective_on_message("all_shamans_dead", "wh_main_qb_vmp_mannfred_von_carstein_sword_of_unholy_power_stage_4_main_objective", 0, 4, 4);
gb:complete_objective_on_message("all_shamans_dead", "wh_main_qb_vmp_mannfred_von_carstein_sword_of_unholy_power_stage_4_main_objective");

-------ORDERS-------
ga_ai_02:reinforce_on_message("battle_started");
ga_ai_02:attack_on_message("battle_started");

ga_ai_03:reinforce_on_message("battle_started", 2000);


-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_vmp_mannfred_von_carstein_sword_of_unholy_power_stage_4_hint_objective");

-------VICTORY CONDITIONS-------
ga_ai_shaman_01:message_on_rout_proportion("enemy_shaman_dead", 1);
ga_ai_shaman_02:message_on_rout_proportion("enemy_shaman_dead", 1);
ga_ai_shaman_03:message_on_rout_proportion("enemy_shaman_dead", 1);
ga_ai_shaman_04:message_on_rout_proportion("enemy_shaman_dead", 1);
ga_player_01:force_victory_on_message("all_shamans_dead"); 

gb:add_listener(
	"enemy_shaman_dead",
	function()
		num_shamans_killed = num_shamans_killed + 1;
		
		print("Shaman Killed - Num Shamans Killed: " .. num_shamans_killed);
		
		if num_shamans_killed == 1 then
			sm:trigger_message("one_shaman_dead");
		elseif num_shamans_killed == 2 then
			sm:trigger_message("two_shamans_dead");
		elseif num_shamans_killed == 3 then
			sm:trigger_message("three_shamans_dead");
		elseif num_shamans_killed == 4 then
			sm:trigger_message("all_shamans_dead");
			gb:remove_listener("enemy_shaman_dead");
		end
	end,
	true
);

