local followers = {
	---------------
	-- LIZARDMEN --
	---------------
	{
		["follower"] = "wh2_main_anc_follower_lzd_architect",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():has_technology("wh2_main_tech_lzd_4_4") and character:has_region() and character:turns_in_own_regions() >= 1 and (cm:region_has_chain_or_superchain(character:region(), "wh_main_sch_main_settlement") or (cm:region_has_chain_or_superchain(character:region(), "wh_main_sch_settlement_major_coast")));
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_metallurgist",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():has_technology("wh2_main_tech_lzd_4_6") and character:has_region() and character:turns_in_own_regions() >= 1 and (cm:region_has_chain_or_superchain(character:region(), "wh_main_sch_main_settlement") or cm:region_has_chain_or_superchain(character:region(), "wh_main_sch_settlement_major_coast"));
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_acolyte_priest",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 2 and cm:region_has_chain_or_superchain(character:region(), "wh2_main_sch_support2_worship");
			end,
		["chance"] = 2
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_veteran_warrior",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() > 1 and cm:region_has_chain_or_superchain(character:region(), "wh2_main_sch_defence_minor");
			end,
		["chance"] = 2
	},
	
	----------------
	-- DARK ELVES --
	----------------
	
	{
		["follower"] = "wh2_main_anc_follower_def_slave",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				local target_faction = context:garrison_residence():faction()
				return target_faction:culture() == "wh2_main_hef_high_elves"
			end,
		["chance"] = 50
	},

	------------
	-- SKAVEN --
	------------
	
	{
		["follower"] = "wh2_main_anc_follower_skv_chemist",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 2
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_messenger",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 2
	},
	
	--------------------
	-- HUMANS/GENERIC --
	--------------------
	
	{
		["follower"] = "wh_main_anc_follower_all_men_tollkeeper",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() < 11;
			end,
		["chance"] = 2
	}
};

local function cbfm_load_followers()
	for i = 1, #followers do
		core:remove_listener(followers[i].follower)
		core:add_listener(
			followers[i].follower,
			followers[i].event,
			followers[i].condition,
			function(context)
				local character = context:character();
				local chance = followers[i].chance;
				
				-- daemon prince shares followers, so has a bigger pool, so the chance is reduced for them
				if character:faction():culture() == "wh3_main_dae_daemons" then
					chance = math.round(chance * 0.4);
				else
					chance = chance * 0.5;
				end;
				
				if core:is_tweaker_set("SCRIPTED_TWEAKER_13") then
					chance = 100;
				end;
				
				if not character:character_type("colonel") and not character:character_subtype("wh_dlc07_brt_green_knight") and not character:character_subtype("wh2_dlc10_hef_shadow_walker") and cm:random_number(100) <= chance then
					cm:force_add_ancillary(context:character(), followers[i].follower, false, false);
				end;
			end,
			true
		);
	end;
end;

cm:add_first_tick_callback(cbfm_load_followers)