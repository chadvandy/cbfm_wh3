-------------------------------------------------------------------------------------------------
----------------------------------------- INITIAL ORDERS ----------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping player from firing until the cutscene is done
ga_taurox:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_army_morghur_main:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_taurox:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_army_morghur_main:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, false);


function start_patrol_1()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_army_morghur_patrol_pigs.sunits:count() do
		local current_sunit = ga_enemy_army_morghur_patrol_pigs.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_bst_patrol_01", current_sunit, player_armies, 40);
		--pm:set_debug();
		pm:add_waypoint(v(152.662,161.796), true);
		pm:add_waypoint(v(-299.575,146.627), true);
		pm:loop(true);
		pm:set_stop_on_intercept(true);
		pm:set_stop_on_rout(true);
		pm:start();
	end;
end;

function start_patrol_2()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_reinforcement_army_prisoners_01.sunits:count() do
		local current_sunit = ga_reinforcement_army_prisoners_01.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_emp_patrol_01", current_sunit, player_armies, 0);
		--pm:set_debug();
		pm:add_waypoint(v(-379.617, 332.133), true);
		pm:add_waypoint(v(-312.042, 279.866), true);
		pm:add_waypoint(v(-117.898, 448.889), true);
		pm:loop(false);
		pm:set_stop_on_intercept(false);
		pm:set_stop_on_rout(false);
		pm:start();
	end;
end;

function start_patrol_3()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_reinforcement_army_prisoners_02.sunits:count() do
		local current_sunit = ga_reinforcement_army_prisoners_02.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_emp_patrol_02", current_sunit, player_armies, 0);
		--pm:set_debug();
		pm:add_waypoint(v(-117.898, 448.889), true);
		pm:add_waypoint(v(256.504, 272.957), true);
		pm:add_waypoint(v(65.7345, 463.31), true);
		pm:loop(false);
		pm:set_stop_on_intercept(false);
		pm:set_stop_on_rout(false);
		pm:start();
	end;
end;

function move_morghur()
	local player_armies = bm:alliances():item(gb:get_player_alliance_num()):armies();
--	bm:out("It's workiiiing");
	for i = 1, ga_enemy_army_morghur_main.sunits:count() do
		local current_sunit = ga_enemy_army_morghur_main.sunits:item(i);

		--set up patrol manager here, one for each sunit
		local pm = patrol_manager:new(current_sunit.name .. "_bst_patrol_02", current_sunit, player_armies, 0);
		--pm:set_debug();
		pm:add_waypoint(v(-271.253, 308.378), true);
		pm:add_waypoint(v(-190.997, 29.0746), true);
		pm:loop(false);
		pm:set_stop_on_intercept(false);
		pm:set_stop_on_rout(false);
		pm:start();
	end;
end;

--ga_enemy_army_morghur_main:use_army_special_ability_on_message("01_intro_cutscene_end","wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted", v(40, 0, 375), 3.141, 40, 10000);
--ga_enemy_army_morghur_main:use_army_special_ability_on_message("01_intro_cutscene_end","wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted", v(-40, 0, 375), 3.141, 40, 11000);
--ga_enemy_army_morghur_main:use_army_special_ability_on_message("01_intro_cutscene_end","wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted", v(-150, 0, 320), 3.141, 40, 12000);
--ga_enemy_army_morghur_main:use_army_special_ability_on_message("01_intro_cutscene_end","wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted", v(-240, 0, 330), 3.141, 40, 13000);
--ga_enemy_army_morghur_main:use_army_special_ability_on_message("01_intro_cutscene_end","wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted", v(0, 0, 380), 3.141, 40, 14000);
--ga_enemy_army_morghur_main:use_army_special_ability_on_message("01_intro_cutscene_end","wh2_dlc17_army_abilities_chaos_spawn_summon_qb_scripted", v(-170, 0, 375), 3.141, 40, 15000);

gb:add_listener("01_intro_cutscene_end", function() move_morghur() end);
--ga_enemy_army_morghur_main:move_to_position_on_message("01_intro_cutscene_end", v(-271.253, 308.378));

--ga_enemy_army_morghur_main:defend_on_message("01_intro_cutscene_end", -10.4747,487.706, 400);
ga_enemy_army_morghur_main:attack_on_message("01_intro_cutscene_end", 60000);
ga_enemy_army_morghur_main:message_on_proximity_to_enemy("morghur_under_attack", 30);
ga_enemy_army_morghur_main:release_on_message("morghur_under_attack");

ga_enemy_army_morghur_fast_beasts:attack_force_on_message("01_intro_cutscene_end", ga_taurox, 20000)
ga_enemy_army_morghur_fast_beasts:rout_over_time_on_message("morghur_dead", 10000);
ga_enemy_army_morghur_fast_beasts:release_on_message("morghur_under_attack");

ga_enemy_army_morghur_patrol_pigs:attack_force_on_message("01_intro_cutscene_end", ga_taurox, 20000)
ga_enemy_army_morghur_patrol_pigs:rout_over_time_on_message("morghur_dead", 10000);
ga_enemy_army_morghur_patrol_pigs:release_on_message("morghur_under_attack");

-- Morghur Defeat Conditions
ga_enemy_army_morghur_main:message_on_commander_dead_or_shattered("morghur_dead");
ga_enemy_army_morghur_main:rout_over_time_on_message("morghur_dead", 10000);
ga_enemy_army_morghur_main:message_on_casualties("morghur_forces_dead", 0.9);
ga_enemy_army_morghur_main:message_on_rout_proportion("morghur_forces_dead", 1);
ga_enemy_army_morghur_main.sunits:prevent_rallying_if_routing(true);
ga_enemy_army_morghur_fast_beasts.sunits:prevent_rallying_if_routing(true);
ga_enemy_army_morghur_patrol_pigs.sunits:prevent_rallying_if_routing(true);
gb:message_on_all_messages_received("morghur_total_dead", "morghur_dead", "morghur_forces_dead");
bm:debug_drawing():draw_white_circle_on_terrain(v(-10.4747,487.706), 400, 100000000);

-- Prisoners
ga_reinforcement_army_prisoners_01:reinforce_on_message("morghur_dead");
ga_reinforcement_army_prisoners_02:reinforce_on_message("morghur_dead");

ga_reinforcement_army_prisoners_01_general:reinforce_on_message("don't do that");

ga_reinforcement_army_prisoners_01:message_on_under_attack("aaahh_01");
ga_reinforcement_army_prisoners_01:release_on_message("aaahh_01");

ga_reinforcement_army_prisoners_02:message_on_under_attack("aaahh_02");
ga_reinforcement_army_prisoners_02:release_on_message("aaahh_02");

-- Lizardmen --
ga_enemy_army_krox:reinforce_on_message("morghur_total_dead");
ga_enemy_army_krox:move_to_position_on_message("lzd_move", v(-34.5288, 336.677));
ga_enemy_army_krox:attack_on_message("cutscene_morghur_dead_end");
ga_enemy_army_krox:message_on_casualties("krox_forces_dead", 0.9);
ga_enemy_army_krox:message_on_rout_proportion("krox_forces_dead", 1);

--Main Force
ga_enemy_army_oxyotl_main:reinforce_on_message("kill_threshold_reached");
--ga_enemy_army_oxyotl_main:move_to_position_on_message("lzd_move", v(-34.5288, 336.677));
ga_enemy_army_oxyotl_main:release_on_message("kill_threshold_reached");

ga_enemy_army_oxyotl_main:message_on_casualties("oxyotl_forces_dead", 0.9);
ga_enemy_army_oxyotl_main:message_on_rout_proportion("oxyotl_forces_dead", 1);

-- Oxyotl
--ga_enemy_army_oxyotl:reinforce_on_message("01_intro_cutscene_end");
ga_enemy_army_oxyotl:reinforce_on_message("kill_threshold_reached");
--ga_enemy_army_oxyotl:move_to_position_on_message("cutscene_ritual_complete_end", v(-104.757, -351.255));
ga_enemy_army_oxyotl:release_on_message("cutscene_ritual_complete_end")
ga_enemy_army_oxyotl:message_on_commander_dead_or_routing("oxyotl_dead");
gb:message_on_all_messages_received("lzd_forces_dead", "oxyotl_forces_dead", "krox_forces_dead");
gb:message_on_all_messages_received("oxyotl_total_dead", "oxyotl_dead", "oxyotl_forces_dead", "krox_forces_dead");

-- Allies

ga_enemy_army_krox:message_on_proximity_to_enemy("lzd_sighted", 30);
ga_enemy_army_oxyotl_main:message_on_proximity_to_enemy("lzd_sighted", 30);

-- Great Bray 01
ga_ally_great_bray_01:reinforce_on_message("morghur_total_dead");
--ga_ally_great_bray_01:move_to_position_on_message("brays_move", v(307.922, 295.457));
ga_ally_great_bray_01:release_on_message("lzd_sighted");


-- Great Bray 02
ga_ally_great_bray_02:reinforce_on_message("morghur_total_dead");
--ga_ally_great_bray_02:move_to_position_on_message("brays_move", v(293.09, 351.837));
ga_ally_great_bray_02:release_on_message("lzd_sighted");

-- Prison Guards 1
ga_ally_prison_guards_01:reinforce_on_message("morghur_total_dead");
ga_ally_prison_guards_01:release_on_message("lzd_sighted");

-- Prison Guards 2
ga_ally_prison_guards_02:reinforce_on_message("morghur_total_dead");
ga_ally_prison_guards_02:release_on_message("lzd_sighted");


gb:add_listener("start_patrol_3", function() start_patrol_3() end);
gb:message_on_time_offset("start_patrol_3", 30000, "cutscene_morghur_dead_end")
gb:message_on_time_offset("spawn_guards", 60000, "cutscene_morghur_dead_end")
ga_ally_prison_guards_01:set_enabled_on_message("spawn_guards", true);
ga_ally_prison_guards_02:set_enabled_on_message("spawn_guards", true);
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("trigger_objective_1", 5000, "01_intro_cutscene_end")
gb:add_ping_icon_on_message("trigger_objective_1", v(-6.5, 60, 410.706), 11, 0, 20000);
ga_enemy_army_morghur_main:add_ping_icon_on_message("trigger_objective_1", 15, 1);
ga_enemy_army_morghur_main:remove_ping_icon_on_message("morghur_total_dead", 1);

gb:set_locatable_objective_callback_on_message(
    "trigger_objective_1",
    "wh2_dlc17_qb_bst_taurox_final_battle_objective_01",
    0,
    function()
        local sunit = ga_enemy_army_morghur_main.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);

gb:queue_help_on_message("trigger_objective_1", "wh2_dlc17_qb_bst_taurox_final_battle_objective_01_popup", 6000, nil, 0);
gb:complete_objective_on_message("morghur_total_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_01")
gb:queue_help_on_message("morghur_total_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_01_complete", 6000, nil);
gb:remove_objective_on_message("trigger_cutscene_morghur_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_01")

-- Kill Counter Objective
gb:message_on_time_offset("start_kill_counter", 5000, "cutscene_morghur_dead_end")

gb:set_objective_on_message("start_kill_counter", "wh2_dlc17_qb_bst_taurox_final_battle_objective_02a")
gb:queue_help_on_message("start_kill_counter", "wh2_dlc17_qb_bst_taurox_final_battle_objective_02_popup", 6000, nil, 0);

gb:add_ping_icon_on_message("start_kill_counter", v(-456.31, 100, 366), 11, 0, 20000);
gb:add_ping_icon_on_message("start_kill_counter", v(459.215, 120, -57.218), 11, 0, 20000);

gb:complete_objective_on_message("kill_threshold_reached", "wh2_dlc17_qb_bst_taurox_final_battle_objective_02a")
gb:queue_help_on_message("kill_threshold_reached", "wh2_dlc17_qb_bst_taurox_final_battle_objective_02_complete", 6000, nil, 0);

gb:add_listener(
    "start_kill_counter",
	function()
		local unit_size_to_kills_threshold = {
            [0] = 500,            -- small
            [1] = 1000,
            [2] = 1500,
            [3] = 2000            -- ultra
        };
        local unit_size_setting = bm:unit_scale_factor_index();
        local kills_threshold;

        if unit_size_setting then
            kills_threshold = unit_size_to_kills_threshold[unit_size_setting];
            bm:out("Starting kills monitor, unit size setting is [" .. unit_size_setting .. "] which corresponds to a kill threshold of [" .. kills_threshold .. "]");
        else
            kills_threshold = unit_size_to_kills_threshold[1];
            script_error("WARNING: couldn't read unit size preference, assuming normal unit size which corresponds to a kill threshold of [" .. kills_threshold .. "]");
        end;

        local objective_key = "wh2_dlc17_qb_bst_taurox_final_battle_objective_02b";
        local sunits_player = ga_taurox.sunits;
		local sunits_ally_01 = ga_ally_great_bray_01.sunits;
		local sunits_ally_02 = ga_ally_great_bray_02.sunits;
		local num_killed_start = sunits_player:number_of_enemies_killed() + sunits_ally_01:number_of_enemies_killed() + sunits_ally_02:number_of_enemies_killed();
        bm:repeat_callback(
            function()
                local num_killed = sunits_player:number_of_enemies_killed() + sunits_ally_01:number_of_enemies_killed() + sunits_ally_02:number_of_enemies_killed() - num_killed_start;
                if num_killed > kills_threshold then
                    num_killed = kills_threshold;
                    bm:complete_objective(objective_key);
                    bm:remove_process("enemies_killed_monitor");
                    gb.sm:trigger_message("kill_threshold_reached");
                    --bm:callback(
                        --function()
                            --bm:remove_objective(objective_key);
                        --end,
                        --2000
                    --);
                end;
                bm:set_objective(objective_key, num_killed, kills_threshold);
            end,
            200,
            "enemies_killed_monitor"
        );
    end
);

gb:remove_objective_on_message("trigger_cutscene_ritual_complete", "wh2_dlc17_qb_bst_taurox_final_battle_objective_02a")
gb:remove_objective_on_message("trigger_cutscene_ritual_complete", "wh2_dlc17_qb_bst_taurox_final_battle_objective_02b")

-- Objective 3
gb:message_on_time_offset("trigger_lzd_objective", 14000, "start_kill_counter")

gb:add_ping_icon_on_message("trigger_lzd_objective", v(-377.466, 120, -335.124), 11, 0, 60000);

gb:set_objective_on_message("trigger_lzd_objective", "wh2_dlc17_qb_bst_taurox_final_battle_objective_03")
gb:complete_objective_on_message("lzd_forces_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_03")
gb:queue_help_on_message("trigger_lzd_objective", "wh2_dlc17_qb_bst_taurox_final_battle_objective_03_popup", 6000, nil, 0);

-- Objective 4
gb:message_on_time_offset("trigger_final_objective", 5000, "cutscene_ritual_complete_end")
gb:queue_help_on_message("trigger_final_objective", "wh2_dlc17_qb_bst_taurox_final_battle_objective_04_popup", 6000, nil);

--gb:add_ping_icon_on_message("trigger_final_objective", v(239.023, 130, -129.067), 11, 0, 20000);
gb:add_ping_icon_on_message("trigger_final_objective", v(-92.2427, 120, -362.031), 11, 0, 20000);

gb:set_locatable_objective_callback_on_message(
    "trigger_final_objective",
    "wh2_dlc17_qb_bst_taurox_final_battle_objective_04",
    0,
    function()
        local sunit = ga_enemy_army_oxyotl.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);
gb:complete_objective_on_message("oxyotl_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_04")
ga_enemy_army_oxyotl:add_ping_icon_on_message("trigger_final_objective", 15, 1);
ga_enemy_army_oxyotl:remove_ping_icon_on_message("oxyotl_dead", 1);
gb:queue_help_on_message("oxyotl_total_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_03_04_complete", 6000, nil, 0);

-- Victory Trigger
ga_taurox:force_victory_on_message("oxyotl_total_dead", 10000)

-- Defeat Trigger
gb:set_locatable_objective_callback_on_message(
    "01_intro_cutscene_end",
    "wh2_dlc17_qb_bst_taurox_final_battle_objective_05",
    0,
    function()
        local sunit = ga_taurox.sunits:get_general_sunit();
        if sunit then
            local cam_targ = sunit.unit:position();
            local cam_pos = v_offset_by_bearing(
                cam_targ,
                get_bearing(cam_targ, bm:camera():position()),    -- horizontal bearing from camera target to current camera position
                100,                                                -- distance from camera position to camera target
                d_to_r(30)                                        -- vertical bearing from horizon to cam-targ/cam-pos line
            );
            return cam_pos, cam_targ;
        end;
    end,
    2
);
ga_taurox:message_on_commander_dead_or_shattered("taurox_dead");

gb:complete_objective_on_message("oxyotl_total_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_05")

gb:fail_objective_on_message("taurox_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_05")
gb:queue_help_on_message("taurox_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_05_failed", 6000, nil, 0);
ga_enemy_army_oxyotl:force_victory_on_message("taurox_dead", 10000)

gb:remove_objective_on_message("taurox_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_01")
gb:remove_objective_on_message("taurox_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_02a")
gb:remove_objective_on_message("taurox_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_02b")
gb:remove_objective_on_message("taurox_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_03")
gb:remove_objective_on_message("taurox_dead", "wh2_dlc17_qb_bst_taurox_final_battle_objective_04")