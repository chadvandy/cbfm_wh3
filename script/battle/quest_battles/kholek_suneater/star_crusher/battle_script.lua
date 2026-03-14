-- Kholek, Starcrusher, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_todtheim_bridge_01_02", 4000, false, false, false);
gc:add_element("Chaos_Kholek_GS_Starcrusher_pt_01", "wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_pt_01", nil, 5000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_left_close_low_01", 4000, true, false, false);
gc:add_element("Chaos_Kholek_GS_Starcrusher_pt_02", "wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_pt_02", "gc_medium_absolute_todtheim_city_01_02", 4000, true, false, false);
gc:add_element("Chaos_Kholek_GS_Starcrusher_pt_03", "wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_pt_03", "gc_orbit_90_medium_commander_back_right_close_low_01", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);

--
undead_armies_routed = 0;

-------GENERALS SPEECH--------
--

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1); -- Orcs
ga_ai_02_vmp_defenders = gb:get_army(gb:get_non_player_alliance_num(), "necromancers"); -- Vamps
ga_ai_02_vmp_side_attack_1 = gb:get_army(gb:get_non_player_alliance_num(), "side_attack_1"); -- Vamps
ga_ai_02_vmp_side_attack_2 = gb:get_army(gb:get_non_player_alliance_num(), "side_attack_2"); -- Vamps
ga_ai_02_vmp_side_attack_3 = gb:get_army(gb:get_non_player_alliance_num(), "side_attack_3"); -- Vamps


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

gb:set_objective_on_message("casualties_sustained_01", "wh_main_qb_objective_defend_defeat_reinforcements");

gb:complete_objective_on_message("greenskins_routed", "wh_main_qb_objective_attack_defeat_army", 0);
gb:complete_objective_on_message("all_vamps_routed", "wh_main_qb_objective_defend_defeat_reinforcements", 0);

-------HINTS-------
-- Removed due to changes to hill hints.
--gb:queue_help_on_message("battle_started", "wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_hint_objective", 13000, 2000, 1000);
gb:queue_help_on_message("battle_started", "wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_hint_objective", 13000, 2000, 1000);


gb:queue_help_on_message("casualties_sustained_01", "wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_hint_reinforcements_1", 13000, 2000, 1000);


gb:queue_help_on_message("casualties_sustained_02", "wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_hint_reinforcements_2", 13000, 2000, 1000);


gb:queue_help_on_message("casualties_sustained_03", "wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_hint_reinforcements_3", 13000, 2000, 1000);


gb:queue_help_on_message("casualties_sustained_04", "wh_dlc01_qb_chs_kholek_suneater_starcrusher_stage_3_hint_reinforcements_4", 13000, 2000, 1000);

-------ORDERS-------

ga_ai_01:message_on_rout_proportion("casualties_sustained_01", 0.1);
ga_ai_01:message_on_rout_proportion("casualties_sustained_02", 0.5);
ga_ai_01:message_on_rout_proportion("casualties_sustained_03", 0.75);
ga_ai_01:message_on_rout_proportion("casualties_sustained_04", 0.9);
ga_ai_01:message_on_rout_proportion("greenskins_routed", 1);

ga_ai_02_vmp_side_attack_1:reinforce_on_message("casualties_sustained_01");
ga_ai_02_vmp_side_attack_1:attack_on_message("casualties_sustained_01", 1000);

ga_ai_02_vmp_side_attack_2:reinforce_on_message("casualties_sustained_02");
ga_ai_02_vmp_side_attack_2:attack_on_message("casualties_sustained_02", 1000);

ga_ai_02_vmp_side_attack_3:reinforce_on_message("casualties_sustained_03");
ga_ai_02_vmp_side_attack_3:attack_on_message("casualties_sustained_03", 1000);

ga_ai_02_vmp_defenders:reinforce_on_message("casualties_sustained_04");
ga_ai_02_vmp_defenders:attack_on_message("casualties_sustained_04", 1000);


ga_ai_02_vmp_side_attack_1:message_on_rout_proportion("vamp_army_01_dead", 1);
ga_ai_02_vmp_side_attack_2:message_on_rout_proportion("vamp_army_02_dead", 1);
ga_ai_02_vmp_side_attack_3:message_on_rout_proportion("vamp_army_03_dead", 1);
ga_ai_02_vmp_defenders:message_on_rout_proportion("vamp_army_04_dead", 1);

--added to simplify ending
gb:message_on_all_messages_received("all_vamps_routed", "vamp_army_01_dead", "vamp_army_02_dead", "vamp_army_03_dead", "vamp_army_04_dead");
--gb:message_on_all_messages_received("end", "all_vamps_routed");

gb:add_listener(
	"all_vamps_routed",
	function()
		-- delay call by 1 second
		bm:callback(
			function()
				bm:end_battle()
			end,
			5000
		);
	end
);

-- gb:add_listener(
-- 	"vamp_army_dead",
-- 	function()
-- 		undead_armies_routed = undead_armies_routed + 1;
		
-- 		print("Undead Army Killed - Num Dead: " .. undead_armies_routed);
		
-- 		if undead_armies_routed == 4 then
-- 			gb:message_on_time_offset("all_vamps_routed", 0);
-- 			gb:remove_listener("vamp_army_dead");
-- 		end
-- 	end,
-- 	true
-- );

