local cbfm_followers = {
    -- Issue 1203
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_mutant",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle()
			end,
		["chance"] = 6
	},
	-- Issue 1153
	{
		["follower"] = "wh_main_anc_follower_empire_road_warden",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and context:pending_battle():ambush_battle()
			end,
		["chance"] = 25
	},
	{
        ["follower"] = "wh2_main_anc_follower_hef_scout",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and context:pending_battle():ambush_battle()
			end,
		["chance"] = 25
	},
	{
        ["follower"] = "wh2_main_anc_follower_lzd_army_beast_hunter",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and context:pending_battle():ambush_battle()
			end,
		["chance"] = 25
	},
	{
        ["follower"] = "wh_main_anc_follower_undead_warlock",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and context:pending_battle():ambush_battle()
			end,
		["chance"] = 25
	}
}

function load_cbfm_followers()
	for i = 1, #cbfm_followers do
        -- remove vanilla listener
        core:remove_listener(cbfm_followers[i].follower)
        -- add fixed cbfm listener
		core:add_listener(
			cbfm_followers[i].follower,
			cbfm_followers[i].event,
			cbfm_followers[i].condition,
			function(context)
				local character = context:character();
				local chance = cbfm_followers[i].chance;
				
				-- daemon prince shares followers, so has a bigger pool, so the chance is reduced for them
				if character:faction():culture() == "wh3_main_dae_daemons" then
					chance = math.round(chance * 0.5);
				end;
				
				if core:is_tweaker_set("SCRIPTED_TWEAKER_13") then
					chance = 100;
				end;
				
				if not character:character_type("colonel") and not character:character_subtype("wh_dlc07_brt_green_knight") and not character:character_subtype("wh2_dlc10_hef_shadow_walker") and cm:random_number(100) <= chance then
					cm:force_add_ancillary(context:character(), cbfm_followers[i].follower, false, false);
				end;
			end,
			true
		);
	end;
end;

cm:add_first_tick_callback(function() load_cbfm_followers() end)