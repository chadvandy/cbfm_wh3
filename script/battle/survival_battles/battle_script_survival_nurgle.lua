load_script_libraries();


gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                     	-- prevent deployment for ai
	function() 
		--battle_start_teleport_units()
		--[[gb:start_generated_cutscene(gc)]] 
	end, 										-- intro cutscene function
	false                                      	-- debug mode
);

--bm.camera():change_height_range(0, 10);

---------------------------
----HARD SCRIPT VERSION----
---------------------------

num_waves_total = 0;
required_waves_kills = 10;

local sm = get_messager();



-------ARMY SETUP-------
ga_ai_def_01 = gb:get_army(gb:get_non_player_alliance_num(), "ai_def_01");

ga_ai_boss_01 = gb:get_army(gb:get_non_player_alliance_num(), "boss_01");
ga_ai_boss_02 = gb:get_army(gb:get_non_player_alliance_num(), "boss_02");
ga_ai_boss_03 = gb:get_army(gb:get_non_player_alliance_num(), "boss_03");

ga_ai_att_01 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_01");
ga_ai_att_02 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_02");
ga_ai_att_03 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_03");
ga_ai_att_04 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_04");
ga_ai_att_05 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_05");
ga_ai_att_06 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_06");
ga_ai_att_07 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_07");
ga_ai_att_08 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_08");
ga_ai_att_09 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_09");
ga_ai_att_10 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_10");

-------ARMY BEHAVIOUR-------

-------COMPOSITE SCENES-------
--gb:stop_terrain_composite_scene_on_message("wave_1", "wh3_nurgle_survival_battle_gate_small.csc");
--gb:start_terrain_composite_scene_on_message("wave_1", "wh3_nurgle_survival_battle_gate_small_fade.csc");

--gb:stop_terrain_composite_scene_on_message("wave_1", "composite_scene/wh3_nurgle_survival_battle_gate_large.csc");
--gb:start_terrain_composite_scene_on_message("wave_1", "wh3_nurgle_survival_battle_gate_large_fade.csc");

-------WAVE 1-------
ga_ai_def_01:message_on_rout_proportion("wave_1", 0.7);
ga_ai_att_01:deploy_at_random_intervals_on_message("wave_1", 1, 3, 5000, 15000, nil, false--[[, true]]);
ga_ai_att_01:attack_on_message("wave_1");
ga_ai_att_01:message_on_proximity_to_enemy("wave_1_close", 10);
ga_ai_att_01:release_on_message("wave_1_close");

-------WAVE 2-------
ga_ai_att_01:message_on_rout_proportion("wave_2", 0.7); 
ga_ai_att_02:deploy_at_random_intervals_on_message("wave_2", 1, 3, 5000, 15000, nil, false--[[, true]]);
ga_ai_att_02:attack_on_message("wave_2");

-------WAVE 3-------
ga_ai_att_02:message_on_rout_proportion("wave_3", 0.7); 
ga_ai_att_03:deploy_at_random_intervals_on_message("wave_3", 1, 3, 5000, 15000, nil, false--[[, true]]);
ga_ai_att_03:attack_on_message("wave_3");

-------BOSS WAVE 1-------
--ga_ai_att_03:message_on_rout_proportion("boss_01", 0.35);
--gb:play_sound_on_message("boss_01", Orc_Horn, nil, 3000);
--ga_ai_boss_01:deploy_at_random_intervals_on_message("boss_01", 1, 3, 10000, 50000, nil, false, true);
--ga_ai_boss_01:attack_on_message("boss_01");

-------WAVE 4-------
ga_ai_att_03:message_on_rout_proportion("wave_4", 0.7); 
--ga_ai_att_04:reinforce_on_message("wave_4", 10000);
ga_ai_att_04:deploy_at_random_intervals_on_message("wave_4", 1, 3, 5000, 15000, nil, false, true);
ga_ai_att_04:attack_on_message("wave_4");

-------WAVE 5-------
ga_ai_att_04:message_on_rout_proportion("wave_5", 0.7); 
ga_ai_att_05:deploy_at_random_intervals_on_message("wave_5", 1, 3, 5000, 15000, nil, false, true);
ga_ai_att_05:attack_on_message("wave_5");

-------WAVE 6-------
ga_ai_att_05:message_on_rout_proportion("wave_6", 0.75); 
ga_ai_att_06:deploy_at_random_intervals_on_message("wave_6", 1, 3, 5000, 20000, nil, false, true);
ga_ai_att_06:attack_on_message("wave_6");

-------BOSS WAVE 2-------
--ga_ai_att_06:message_on_rout_proportion("boss_02", 0.35); 
--gb:play_sound_on_message("boss_02", Orc_Horn, nil, 3000);
--ga_ai_boss_02:deploy_at_random_intervals_on_message("boss_02", 1, 1, 10000, 30000, nil, false, true);
--ga_ai_boss_02:attack_on_message("boss_02");

-------WAVE 7-------
ga_ai_att_06:message_on_rout_proportion("wave_7", 0.75); 
ga_ai_att_07:deploy_at_random_intervals_on_message("wave_7", 1, 3, 5000, 20000, nil, false, true);
ga_ai_att_07:attack_on_message("wave_7");

-------WAVE 8-------
ga_ai_att_07:message_on_rout_proportion("wave_8", 0.75); 
ga_ai_att_08:deploy_at_random_intervals_on_message("wave_8", 1, 3, 5000, 20000, nil, false, true);
ga_ai_att_08:attack_on_message("wave_8");

-------WAVE 9-------
ga_ai_att_08:message_on_rout_proportion("wave_9", 0.75); 
ga_ai_att_09:deploy_at_random_intervals_on_message("wave_9", 1, 3, 5000, 20000, nil, false, true);
ga_ai_att_09:attack_on_message("wave_9");

-------BOSS WAVE 3-------
--ga_ai_att_09:message_on_rout_proportion("boss_03", 0.35); 
--gb:play_sound_on_message("boss_03", Orc_Horn, nil, 3000);
--ga_ai_boss_03:deploy_at_random_intervals_on_message("boss_03", 1, 1, 10000, 30000, nil, false, true);
--ga_ai_boss_03:attack_on_message("boss_03");

-------WAVE 10-------
ga_ai_att_09:message_on_rout_proportion("wave_10", 0.75); 
ga_ai_att_10:deploy_at_random_intervals_on_message("wave_10", 1, 3, 5000, 20000, nil, false, true);
ga_ai_att_10:attack_on_message("wave_10");

-------OBJECTIVES-------

-------HINTS-------
gb:queue_help_on_message("boss_01", "wh3_survival_hint_02");
gb:queue_help_on_message("boss_02", "wh3_survival_hint_02");
gb:queue_help_on_message("boss_03", "wh3_survival_hint_02");

gb:queue_help_on_message("wave_1", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_2", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_3", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_4", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_5", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_6", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_7", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_8", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_9", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_10", "wh3_survival_hint_01");

--gb:play_sound_on_message("wave_10", Orc_Horn, v(-25, 70, -1000), 0, nil,  3000);

-------VICTORY CONDITIONS-------
ga_ai_att_01:message_on_rout_proportion("enemy_wave_defeated", 1);
ga_ai_att_02:message_on_rout_proportion("enemy_wave_defeated", 1);
ga_ai_att_03:message_on_rout_proportion("enemy_wave_defeated", 1);
ga_ai_att_04:message_on_rout_proportion("enemy_wave_defeated", 1);
ga_ai_att_05:message_on_rout_proportion("enemy_wave_defeated", 1);
ga_ai_att_06:message_on_rout_proportion("enemy_wave_defeated", 1);
ga_ai_att_07:message_on_rout_proportion("enemy_wave_defeated", 1);
ga_ai_att_08:message_on_rout_proportion("enemy_wave_defeated", 1);
ga_ai_att_09:message_on_rout_proportion("enemy_wave_defeated", 1);
ga_ai_att_10:message_on_rout_proportion("enemy_wave_defeated", 1);

gb:add_listener(
	"enemy_wave_defeated",
	function()
		num_waves_total = num_waves_total + 1;
		
		print("Wave Killed - Num Waves Killed: " .. num_waves_total);
		
		if num_waves_total == 1 then
			bm:set_objective("wh3_survival_hint_objective", 1, 10);
		elseif num_waves_total == 2 then
			bm:set_objective("wh3_survival_hint_objective", 2, 10);
		elseif num_waves_total == 3 then
			bm:set_objective("wh3_survival_hint_objective", 3, 10);
		elseif num_waves_total == 4 then
			bm:set_objective("wh3_survival_hint_objective", 4, 10);
		elseif num_waves_total == 5 then
			bm:set_objective("wh3_survival_hint_objective", 5, 10);
		elseif num_waves_total == 6 then
			bm:set_objective("wh3_survival_hint_objective", 6, 10);
		elseif num_waves_total == 7 then
			bm:set_objective("wh3_survival_hint_objective", 7, 10);
		elseif num_waves_total == 8 then
			bm:set_objective("wh3_survival_hint_objective", 8, 10);
		elseif num_waves_total == 9 then
			bm:set_objective("wh3_survival_hint_objective", 9, 10);
		elseif num_waves_total == 10 then
			bm:set_objective("wh3_survival_hint_objective", 10, 10);
			--gb.sm:trigger_message("all_waves_dead");
			bm:notify_last_enemy_wave_completed();
			gb:remove_listener("enemy_wave_defeated");
		end
	end,
	true
);