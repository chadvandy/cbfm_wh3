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


	----------------
	-- GREENSKINS --
	----------------

	{
		["follower"] = "wh_main_anc_follower_greenskins_snotling_scavengers",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				return context:character():faction():losing_money();
			end,
		["chance"] = 30
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
				local base_chance = followers[i].chance;
				local drop_chance = calculate_ancillary_drop_chance(character:faction(), followers[i].follower) / 100;
				local true_chance = base_chance * drop_chance;
				
				if core:is_tweaker_set("SCRIPTED_TWEAKER_13") then
					true_chance = 100;
				end
				
				if cm:model():random_percent(true_chance) then
					if not character:character_type("colonel") and not character:character_subtype("wh_dlc07_brt_green_knight") and not character:character_subtype("wh2_dlc10_hef_shadow_walker") then
						cm:force_add_ancillary(context:character(), followers[i].follower, false, false);
					end
				end
			end,
			true
		);
	end;
end;

cm:add_first_tick_callback(cbfm_load_followers)