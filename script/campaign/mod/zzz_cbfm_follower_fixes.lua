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