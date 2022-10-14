local followers = {
	----------------
	-- TOMB KINGS --
	----------------
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_acolyte_of_sokth",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function(context)
				return not context:character():has_ancillary("wh2_dlc09_anc_follower_tmb_acolyte_of_sokth");
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_charnel_valley_necrotect",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():settlement():get_climate() == "climate_mountain" and not character:has_ancillary("wh2_dlc09_anc_follower_tmb_charnel_valley_necrotect");
			end,
		["chance"] = 35
	},
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_cultist_of_usirian",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) > 15 and not character:has_ancillary("wh2_dlc09_anc_follower_tmb_cultist_of_usirian");
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_dog_headed_ushabti",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				local pb = context:pending_battle();
				return cm:char_is_general(character) and not character:won_battle() and (pb:attacker() == character and pb:defender():faction():culture() == "wh2_dlc09_tmb_tomb_kings") or (pb:defender() == character and pb:attacker():faction():culture() == "wh2_dlc09_tmb_tomb_kings") and not character:has_ancillary("wh2_dlc09_anc_follower_tmb_dog_headed_ushabti");
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_high_born_of_khemri",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return cm:char_is_general_with_army(character) and character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20 and not character:has_ancillary("wh2_dlc09_anc_follower_tmb_high_born_of_khemri");
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_legionnaire_of_asaph",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:mission_result_failure() and not context:character():has_ancillary("wh2_dlc09_anc_follower_tmb_legionnaire_of_asaph");
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_priest_of_ptra",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():culture() == "wh_main_vmp_vampire_counts" and not character:has_ancillary("wh2_dlc09_anc_follower_tmb_priest_of_ptra");
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_skeletal_labourer",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				return not context:character():has_ancillary("wh2_dlc09_anc_follower_tmb_skeletal_labourer");
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_tombfleet_taskmaster",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "release" and not context:character():has_ancillary("wh2_dlc09_anc_follower_tmb_tombfleet_taskmaster");
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh2_dlc09_anc_follower_tmb_ushabti_bodyguard",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return char_army_has_unit(character, {"wh2_dlc09_tmb_mon_ushabti_0", "wh2_dlc09_tmb_mon_ushabti_1"}) and not character:has_ancillary("wh2_dlc09_anc_follower_tmb_ushabti_bodyguard");
			end,
		["chance"] = 10
	},
	
	----------------
	-- HIGH ELVES --
	----------------
	{
		["follower"] = "wh2_main_anc_follower_hef_admiral",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_hef_port") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_assassin",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_bard",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():offensive_battles_won() > 5;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_beard_weaver",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh_main_dwf_dwarfs");
			end,
		["chance"] = 50
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_counsellor",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_hef_court") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_counterspy",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				local character = context:character();
				return context:mission_result_failure() and context:ability() ~= "assist_army";
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_dragon_armourer",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_hef_dragons") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_dragon_tamer",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_hef_dragons") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_food_taster",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_horsemaster",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_special_ellyrian_stables") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_librarian",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_special_tower_of_hoeth") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_minstrel",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_hef_order") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_poisoner",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_hef_mages") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_priest_vaul",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_special_hall_of_dragons") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_priestess_isha",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_special_everqueen_court") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_raven_keeper",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_scout",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:pending_battle():ambush_battle();
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_shrine_keeper",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_hef_worship") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_trappist",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_hef_mages") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_hef_wine_merchant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local turn = cm:model():turn_number();
				return context:character():faction():trade_value_percent() > 40 and turn > 5 and turn % 5 == 0;
			end,
		["chance"] = 10
	},
	
	---------------
	-- LIZARDMEN --
	---------------
	{
		["follower"] = "wh2_main_anc_follower_lzd_acolyte_priest",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 2 and region_has_chain_or_superchain(character:region(), "wh2_main_sch_support2_worship");
			end,
		["chance"] = 1
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_architect",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():has_technology("wh2_main_tech_lzd_4_4") and character:has_region() and character:turns_in_own_regions() >= 1 and (region_has_chain_or_superchain(character:region(), "wh_main_sch_settlement_major") or (region_has_chain_or_superchain(character:region(), "wh_main_sch_settlement_major_coast")));
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_archivist",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local turn = cm:model():turn_number();
				return context:character():faction():trade_value_percent() > 40 and turn > 5 and turn % 5 == 0;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_army_beast_hunter",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:pending_battle():ambush_battle();
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_artefact_hunter",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_astronomer",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_lzd_worship_oldones") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_attendant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_cleaner",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():has_technology("wh2_main_tech_lzd_1_6") and character:has_region() and character:turns_in_own_regions() >= 1 and (region_has_chain_or_superchain(character:region(), "wh2_main_sch_military2_stables") or region_has_chain_or_superchain(character:region(), "wh2_main_sch_military1_barracks"));
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_clerk",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():battles_won() > 19;
			end,
		["chance"] = 7
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_defence_expert",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_sch_defence_major_lzd");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_fan_waver",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():battles_won() > 3;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_gardener",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_sch_defence_major_lzd");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_metallurgist",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():has_technology("wh2_main_tech_lzd_4_6") and character:has_region() and character:turns_in_own_regions() >= 1 and (region_has_chain_or_superchain(character:region(), "wh_main_sch_settlement_major") or region_has_chain_or_superchain(character:region(), "wh_main_sch_settlement_major_coast"));
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_sacrificial_victim_human",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 50
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_sacrificial_victim_skv",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh2_main_skv_skaven");
			end,
		["chance"] = 11
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_temple_cleaner",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_lzd_worship_sotek") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_veteran_warrior",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() > 1 and region_has_chain_or_superchain(character:region(), "wh2_main_sch_defence_minor");
			end,
		["chance"] = 1
	},
	{
		["follower"] = "wh2_main_anc_follower_lzd_zoat",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():turns_in_enemy_regions() > 3;
			end,
		["chance"] = 25
	},
	
	------------
	-- SKAVEN --
	------------
	{
		["follower"] = "wh2_main_anc_follower_skv_artefact_hunter",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_bell_polisher",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_skv_order") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_bodyguard",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:mission_result_failure() and context:ability() ~= "assist_army";
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_chemist",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 1
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_clerk",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_engineering_student",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and context:pending_battle():siege_battle();
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_female",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_skv_farm") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_hell_pit_attendant",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():has_technology("wh2_main_tech_skv_4_1");
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_mechanic",
		["event"] = "HeroCharacterParticipatedInBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:character_type("engineer");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_messenger",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 1
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_pet_wolf_rat",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_saboteur",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_sacrificial_victim_dwarf",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh_main_dwf_dwarfs");
			end,
		["chance"] = 11
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_sacrificial_victim_lizardman",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh2_main_lzd_lizardmen");
			end,
		["chance"] = 11
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_scavenger_1",
		["event"] = "CharacterGarrisonTargetAction",
		["condition"] =
			function(context)
				return context:mission_result_success() or context:mission_result_critial_success();
			end,
		["chance"] = 9
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_scribe",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function(context)
				local character = context:character();
				return cm:char_is_general_with_army(character) and character:military_force():unit_list():num_items() > 10;
			end,
		["chance"] = 6
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_slave_human",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 33
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_slave_skv",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				return context:garrison_residence():faction():culture() == "wh2_main_hef_high_elves";
			end,
		["chance"] = 33
	},
	{
		["follower"] = "wh2_main_anc_follower_skv_trainee_assassin",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and (region_has_chain_or_superchain(character:region(), "wh2_main_skv_assassins") or region_has_chain_or_superchain(character:region(), "wh2_main_skv_assassins_eshin")) and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	
	-----------------------
	-- WARRIORS OF CHAOS --
	-----------------------
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_barbarian",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():started_war_this_turn() and character:offensive_battles_won() > 3;
			end,
		["chance"] = 18
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_beast_tamer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return char_army_has_unit(context:character(), "wh_main_chs_mon_chaos_warhounds_0");
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_collector",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_cultist",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) < 10;
			end,
		["chance"] = 3
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_darksoul",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 6
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_demagogue",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():treasury() < 3000;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_huscarl",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_kurgan_chieftain",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_magister",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():offensive_battles_won() > 5;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_mutant",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end,
		["chance"] = 6
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_oar_slave",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local region_data = context:character():region_data();
				return not region_data:is_null_interface() and region_data:is_sea();
			end,
		["chance"] = 12
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_possessed",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():has_technology("wh_main_tech_chs_main_3") and character:battles_fought() > 3;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_slave_master",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				return context:character():faction():started_war_this_turn();
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh_dlc01_anc_follower_chaos_zealot",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) < 10;
			end,
		["chance"] = 3
	},
	
	--------------
	-- BEASTMEN --
	--------------
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_bray_shamans_familiar",
		["event"] = "HeroCharacterParticipatedInBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:character_type("wizard");
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_chieftains_pet",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:won_battle() and char_army_has_unit(character, {"wh_dlc03_bst_inf_chaos_warhounds_1", "wh_dlc03_bst_inf_chaos_warhounds_0"});
			end,
		["chance"] = 35
	},
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_doe",
		["event"] = "CharacterRazedSettlement",
		["condition"] =
			function(context)
				return not context:character():has_ancillary("wh_dlc03_anc_follower_beastmen_doe");
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_flayer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():started_war_this_turn() and character:offensive_battles_won() > 3;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_flying_spy",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() < 11;
			end,
		["chance"] = 2
	},
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_herdstone_keeper",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) < 10;
			end,
		["chance"] = 3
	},
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_mannish_thrall",
		["event"] = "HeroCharacterParticipatedInBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_pox_carrier",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 4
	},
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_spawn_wrangler",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return char_can_recruit_unit(context:character(), "wh_dlc03_bst_mon_chaos_spawn_0");
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_dlc03_anc_follower_beastmen_ungor_whelp",
		["event"] = "CharacterRazedSettlement",
		["condition"] =
			function(context)
				local character = context:character();
				return character:battles_won() > 5 and not character:faction():ancillary_exists("wh_dlc03_anc_follower_beastmen_ungor_whelp");
			end,
		["chance"] = 3
	},
	
	----------------
	-- WOOD ELVES --
	----------------
	{
		["follower"] = "wh_dlc05_anc_follower_dryad_spy",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc05_anc_follower_elder_scout",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() > 21;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc05_anc_follower_eternal_guard_commander",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() > 21;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc05_anc_follower_forest_spirit",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_dlc05_anc_follower_hawk_companion",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() < 11;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc05_anc_follower_hunting_hound",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() < 11;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc05_anc_follower_royal_standard_bearer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc05_anc_follower_vauls_anvil_smith",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc05_anc_follower_wardancer_drummer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc05_anc_follower_young_stag",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() < 11;
			end,
		["chance"] = 10
	},
	
	------------
	-- NORSCA --
	------------
	{
		["follower"] = "wh_dlc08_anc_follower_baernsonlings_berserker",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc08_anc_follower_baernsonlings_werekin",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return (char_can_recruit_unit(character, "wh_dlc08_nor_mon_skinwolves_0") or char_can_recruit_unit(character, "wh_dlc08_nor_mon_skinwolves_1"));
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc08_anc_follower_beserker",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_dlc08_anc_follower_cathy_slave_dancers",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc08_anc_follower_dragonbone_raiders",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_military_force() then
					local mf = character:military_force();
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
				end;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_dlc08_anc_follower_kurgan_slave_merchant",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				return context:garrison_residence():faction():culture() == "wh_main_emp_empire";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc08_anc_follower_mammoth",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_dlc08_anc_follower_marauder_champion",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():started_war_this_turn() and character:offensive_battles_won() > 3;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc08_anc_follower_mountain_scout",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() < 11;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_dlc08_anc_follower_seer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:character_type("wizard") and not character:is_embedded_in_military_force();
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc08_anc_follower_skaeling_trader",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				return context:garrison_residence():faction():culture() == "wh_main_emp_empire";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc08_anc_follower_slave_worker",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				return true;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc08_anc_follower_vargs_beast_trainer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return char_can_recruit_unit(character, "wh_dlc08_nor_mon_war_mammoth_0") or char_can_recruit_unit(character, "wh_dlc08_nor_mon_war_mammoth_1") or char_can_recruit_unit(character, "wh_dlc08_nor_mon_war_mammoth_2") or char_can_recruit_unit(character, "wh_main_nor_mon_chaos_warhounds_0") or char_can_recruit_unit(character, "wh_main_nor_mon_chaos_warhounds_1");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_dlc08_anc_follower_whalers",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local region_data = context:character():region_data();
				return not region_data:is_null_interface() and region_data:is_sea();
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_norsca_berserker",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 3
	},
	
	--------------------
	-- HUMANS/GENERIC --
	--------------------
	{
		["follower"] = "wh_main_anc_follower_all_hedge_wizard",
		["event"] = "HeroCharacterParticipatedInBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:character_type("wizard");
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_bailiff",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_boatman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region():name();
					return (region == "wh3_main_combi_region_marienburg" or region == "wh3_main_chaos_region_marienburg") and cm:model():turn_number() % 5 == 0;
				end;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_bodyguard",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:mission_result_failure() and context:ability() ~= "assist_army";
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_bounty_hunter",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function(context)
				local character = context:character();
				return cm:char_is_general_with_army(character) and character:military_force():unit_list():num_items() < 10;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_fisherman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region():name();
					return region == "wh3_main_combi_region_marienburg" or region == "wh3_main_chaos_region_marienburg";
				end;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_grave_robber",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				local pb = context:pending_battle();
				return cm:char_is_general(character) and not character:won_battle() and (pb:attacker() == character and pb:defender():faction():culture() == "wh_main_vmp_vampire_counts") or (pb:defender() == character and pb:attacker():faction():culture() == "wh_main_vmp_vampire_counts");
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_initiate",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():culture() == "wh_main_vmp_vampire_counts";
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_kislevite_kossar",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character()
				return character:has_region() and character:region():owning_faction():culture() == "wh3_main_ksl_kislev" and cm:model():turn_number() > 1;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_mercenary",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_militiaman",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_ogres_pit_fighter",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_outlaw",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_military_force() and (character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_outrider",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():started_war_this_turn() and character:offensive_battles_won() > 3;
			end,
		["chance"] = 14
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_protagonist",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end,
		["chance"] = 4
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_rogue",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return cm:model():turn_number() % 2 == 0 and context:character():faction():is_human() and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_servant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() > 21;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_smuggler",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				local turn = cm:model():turn_number();
				return character:faction():trade_value_percent() > 40 and turn > 5 and turn % 5 == 0 and character:can_equip_ancillary("wh_main_anc_follower_all_men_smuggler");
			end,
		["chance"] = 7
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_soldier",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end,
		["chance"] = 2
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_thug",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				local character = context:character();
				return not (cm:model():turn_number() % 2 == 0) and character:faction():is_human() and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_tollkeeper",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() < 11;
			end,
		["chance"] = 1
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_tomb_robber",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function(context)
				return context:garrison_residence():faction():culture() == "wh_main_vmp_vampire_counts";
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_vagabond",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() > 21;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_valet",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():offensive_battles_won() > 5;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_all_men_zealot",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():culture() == "wh_main_vmp_vampire_counts";
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_all_student",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():faction():research_queue_idle() and cm:model():turn_number() > 1;
			end,
		["chance"] = 13
	},
	
	---------------
	-- BRETONNIA --
	---------------
	{
		["follower"] = "wh_main_anc_follower_bretonnia_court_jester",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) > 30;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_bretonnia_squire",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 8
	},
	
	------------
	-- DWARFS --
	------------
	{
		["follower"] = "wh_main_anc_follower_dwarfs_archivist",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():faction():research_queue_idle() and cm:model():turn_number() > 1;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_brewmaster",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():faction():trade_resource_exists("res_rom_glass");
			end,
		["chance"] = 3
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_candle_maker",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:mission_result_failure() and context:ability() ~= "assist_army";
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_choir_master",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 12
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_cooper",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():treasury() < 3000;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_daughter_of_valaya",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():has_technology("wh_main_tech_dwf_civ_6_4") and character:battles_fought() > 3;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_dwarf_bride",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():offensive_battles_won() > 5;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_dwarfen_tattooist",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) > 30;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_goldsmith",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and (character:region():building_exists("wh_main_dwf_resource_gold_1") or character:region():building_exists("wh_main_dwf_resource_gold_2") or character:region():building_exists("wh_main_dwf_resource_gold_3") or character:region():building_exists("wh_main_dwf_resource_gold_4"));
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_grudgekeeper",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				local pb = context:pending_battle();
				return cm:char_is_general(character) and not character:won_battle() and (pb:attacker() == character and pb:defender():faction():culture() == "wh_main_grn_greenskins") or (pb:defender() == character and pb:attacker():faction():culture() == "wh_main_grn_greenskins");
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_guildmaster",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local turn = cm:model():turn_number();
				return context:character():faction():trade_value_percent() > 40 and turn > 5 and turn % 5 == 0;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_jewelsmith",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and (character:region():building_exists("wh_main_dwf_resource_gems_1") or character:region():building_exists("wh_main_dwf_resource_gems_2") or character:region():building_exists("wh_main_dwf_resource_gems_3") or character:region():building_exists("wh_main_dwf_resource_gems_4"));
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_miner",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and (character:region():building_exists("wh_main_dwf_resource_iron_1") or character:region():building_exists("wh_main_dwf_resource_iron_2") or character:region():building_exists("wh_main_dwf_resource_iron_3") or character:region():building_exists("wh_main_dwf_resource_iron_4"));
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_powder_mixer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return char_can_recruit_unit(context:character(), "wh_main_dwf_art_cannon");
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_prospector",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_reckoner",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_runebearer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:character_subtype("wh_main_dwf_runesmith") and not character:is_embedded_in_military_force();
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_runesmith_apprentice",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():can_recruit_agent_at_settlement("runesmith");
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_sapper",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and context:pending_battle():siege_battle();
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_shieldbreaker",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_military_force() and character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_TUNNELING";
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_shipwright",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local region_data = context:character():region_data();
				return not region_data:is_null_interface() and region_data:is_sea();
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_slayer_ward",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return char_army_has_unit(context:character(), "wh_main_dwf_inf_slayers");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_stonemason",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():faction():trade_resource_exists("res_rom_marble");
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_teller_of_tales",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_treasure_hunter",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_dwarfs_troll_slayer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:pending_battle_cache_unit_key_exists("wh_main_grn_mon_trolls");
			end,
		["chance"] = 20
	},
	
	------------
	-- EMPIRE --
	------------
	{
		["follower"] = "wh_main_anc_follower_empire_agitator",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_empire_apprentice_wizard",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 4
	},
	{
		["follower"] = "wh_main_anc_follower_empire_barber_surgeon",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function(context)
				local character = context:character();
				return cm:char_is_general_with_army(character) and character:military_force():unit_list():num_items() > 10;
			end,
		["chance"] = 6
	},
	{
		["follower"] = "wh_main_anc_follower_empire_bone_picker",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():culture() == "wh_main_vmp_vampire_counts";
			end,
		["chance"] = 7
	},
	{
		["follower"] = "wh_main_anc_follower_empire_burgher",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 12
	},
	{
		["follower"] = "wh_main_anc_follower_empire_camp_follower",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 6
	},
	{
		["follower"] = "wh_main_anc_follower_empire_charcoal_burner",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh_main_anc_follower_empire_coachman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				local turn = cm:model():turn_number();
				return character:faction():trade_value_percent() > 40 and turn > 5 and turn % 5 == 0;
			end,
		["chance"] = 7
	},
	{
		["follower"] = "wh_main_anc_follower_empire_entertainer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():treasury() < 3000;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_empire_estalian_diestro",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:action_points_remaining_percent() > 75 and (character:region():name() == "wh3_main_combi_region_bilbali" or character:region():name() == "wh3_main_combi_region_magritta" or character:region():name() == "wh3_main_combi_region_tobaro") and not character:has_ancillary("wh_main_anc_follower_empire_estalian_diestro");
			end,
		["chance"] = 6
	},
	{
		["follower"] = "wh_main_anc_follower_empire_ferryman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local turn = cm:model():turn_number()
				return context:character():faction():trade_value_percent() > 40 and turn > 5 and turn % 5 == 0;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_empire_hunter",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_empire_jailer",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function(context)
				return context:garrison_residence():faction():culture() == "wh_main_emp_empire";
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_empire_light_college_acolyte",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) > 30;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_empire_marine",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():name() == "wh3_main_combi_region_marienburg" and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_empire_messenger",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and not character:has_ancillary("wh_main_anc_follower_empire_messenger");
			end,
		["chance"] = 4
	},
	{
		["follower"] = "wh_main_anc_follower_empire_noble",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() > 1 and character:region():public_order() < -25 and character:rank() > 11 and character:rank() < 21;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_empire_peasant",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh_main_anc_follower_empire_rat_catcher",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():turns_in_enemy_regions() > 3;
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_empire_road_warden",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:pending_battle():ambush_battle();
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh_main_anc_follower_empire_scribe",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:turns_in_own_regions() > 3 and character:battles_won() > 2;
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_empire_seaman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():name() == "wh3_main_combi_region_marienburg";
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_empire_thief",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_military_force() and (character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_empire_tradesman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():faction():trade_value_percent() > 40 and cm:model():turn_number() > 5 and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 3
	},
	{
		["follower"] = "wh_main_anc_follower_empire_watchman",
		["event"] = "CharacterGarrisonTargetAction",
		["condition"] =
			function(context)
				return context:mission_result_success() or context:mission_result_critial_success();
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_empire_woodsman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and (character:region():building_exists("wh_main_emp_resource_timber_1") or character:region():building_exists("wh_main_emp_resource_timber_2") or character:region():building_exists("wh_main_emp_resource_timber_3"));
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh_main_anc_follower_halfling_fieldwarden",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:action_points_remaining_percent() > 75 and character:region():name() == "wh3_main_combi_region_the_moot" and not character:has_ancillary("wh_main_anc_follower_halfling_fieldwarden");
			end,
		["chance"] = 6
	},
	
	----------------
	-- GREENSKINS --
	----------------
	{
		["follower"] = "wh_main_anc_follower_greenskins_backstabba",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():started_war_this_turn() and character:offensive_battles_won() > 3;
			end,
		["chance"] = 50
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_bat-winged_loony",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_military_force() and (character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_boggart",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:character_subtype("wh_main_grn_goblin_great_shaman") and character:turns_in_own_regions() > 3 and character:battles_won() > 2;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_bully",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_dog_boy_scout",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_dung_collector",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:building_exists("wh_main_special_greenskin_vandalisation_1") or region:building_exists("wh_main_special_greenskin_vandalisation_2") or region:building_exists("wh_main_special_greenskin_vandalisation_3") or region:building_exists("wh_main_special_greenskin_vandalisation_4") or region:building_exists("wh_main_special_greenskin_vandalisation_5");
				end;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_gobbo_ranta",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) > 30;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_idol_carva",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_pit_boss",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():offensive_battles_won() > 5;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_savage_orc_prodda",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return char_army_has_unit(character, {"wh_main_grn_inf_savage_orcs", "wh_main_grn_inf_savage_orc_arrer_boyz", "wh_main_grn_cav_savage_orc_boar_boyz"});
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_serial_loota",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_shamans_lacky",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:character_type("wizard") and not character:is_embedded_in_military_force();
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_shroom_gathera",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return char_army_has_unit(character, {"wh_main_grn_inf_night_goblins", "wh_main_grn_inf_night_goblin_archers"});
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_shroom_gathera",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():character_subtype("wh_main_grn_night_goblin_shaman");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_snotling_scavengers",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function(context)
				return context:character():faction():losing_money();
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_snotling_scavengers",
		["event"] = "HeroCharacterParticipatedInBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_spider-god_priest",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():has_technology("wh_main_tech_grn_main_4_1") and character:battles_fought() > 3;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_squig_mascot",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():character_subtype("wh_main_grn_goblin_great_shaman");
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_squig_mascot",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():character_subtype("wh_main_grn_night_goblin_shaman");
			end,
		["chance"] = 4
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_swindla",
		["event"] = "HeroCharacterParticipatedInBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_swindla",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh_main_anc_follower_greenskins_troll_herder",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return char_army_has_unit(context:character(), "wh_main_grn_mon_trolls");
			end,
		["chance"] = 10
	},
	
	--------------------
	-- VAMPIRE COUNTS --
	--------------------
	{
		["follower"] = "wh_main_anc_follower_undead_black_cat",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_undead_carrion",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) < 10;
			end,
		["chance"] = 3
	},
	{
		["follower"] = "wh_main_anc_follower_undead_corpse_thief",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 3
	},
	{
		["follower"] = "wh_main_anc_follower_undead_crone",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():can_recruit_agent_at_settlement("spy");
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_undead_dreg",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_undead_flesh_golem",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh_main_anc_follower_undead_grave_digger",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_military_force() and character:military_force():contains_mercenaries();
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_undead_manservant",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function(context)
				return context:garrison_residence():faction():culture() == "wh_main_emp_empire";
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_undead_mortal_informer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 13
	},
	{
		["follower"] = "wh_main_anc_follower_undead_poltergeist",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh_main_anc_follower_undead_possessed_mirror",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:mission_result_failure() and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh_main_anc_follower_undead_treasurer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():treasury() < 3000;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh_main_anc_follower_undead_warlock",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:pending_battle():ambush_battle();
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh_main_anc_follower_undead_warp_stone_hunter",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 25
	},
	
	-------------------
	-- VAMPIRE COAST --
	-------------------
	{
		["follower"] = "wh2_dlc11_anc_follower_cst_drawn_chef",
		["event"] = "CharacterRazedSettlement",
		["condition"] =
			function(context)
				return cm:char_is_general(context:character());
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh2_dlc11_anc_follower_cst_sartosa_navigator",
		["event"] = "HeroCharacterParticipatedInBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh2_dlc11_anc_follower_cst_shipwright",
		["event"] = "HeroCharacterParticipatedInBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh2_dlc11_anc_follower_cst_siren",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local region_data = context:character():region_data();
				return not region_data:is_null_interface() and region_data:is_sea();
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_dlc11_anc_follower_cst_travelling_necromancer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 4
	},
	
	----------------
	-- DARK ELVES --
	----------------
	{
		["follower"] = "wh2_main_anc_follower_def_apprentice_assassin",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:faction():has_technology("wh2_main_tech_def_2_3_3") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_murder") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_def_beastmaster",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_beasts") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_def_bodyguard",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh2_main_anc_follower_def_cultist",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_pleasure_cult") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_def_daemon_whisperer",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_pleasure_cult") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_def_diplomat",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():started_war_this_turn() and character:offensive_battles_won() > 3;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh2_main_anc_follower_def_diplomat_slaanesh",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:faction():has_technology("wh2_main_tech_def_3_3_3") and character:has_region() and cm:get_corruption_value_in_region(character:region(), chaos_corruption_string) > 10 and not character:has_ancillary("wh2_main_anc_follower_def_diplomat_slaanesh");
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh2_main_anc_follower_def_fanatic",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_worship");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_def_fimir_balefiend",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh2_main_anc_follower_def_gravedigger",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh2_main_anc_follower_def_harem_attendant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_pleasure_cult");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_def_harem_keeper",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_pleasure_cult");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_def_merchant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				local turn = cm:model():turn_number();
				return character:faction():trade_value_percent() > 40 and turn > 5 and turn % 5 == 0;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh2_main_anc_follower_def_musician_choirmaster",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_farm") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_def_musician_drum",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_order") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_def_musician_flute",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_pleasure_cult") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_def_organ_merchant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				local faction = character:faction();
				return faction:has_technology("wh2_main_tech_def_2_3_0") and faction:trade_value_percent() > 40;
			end,
		["chance"] = 6
	},
	{
		["follower"] = "wh2_main_anc_follower_def_overseer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				local faction = character:faction();
				return faction:has_technology("wh2_main_tech_def_1_2_0") and faction:trade_value_percent() > 20 and faction:treasury() > 2000;
			end,
		["chance"] = 7
	},
	{
		["follower"] = "wh2_main_anc_follower_def_propagandist",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:character_type("colonel") and character:has_region() and character:turns_in_own_regions() >= 1 and region_has_chain_or_superchain(character:region(), "wh2_main_def_worship") and cm:model():turn_number() % 5 == 0;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh2_main_anc_follower_def_servant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():has_technology("wh2_main_tech_def_2_2_0") and character:rank() > 10;
			end,
		["chance"] = 50
	},
	{
		["follower"] = "wh2_main_anc_follower_def_slave",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh2_main_anc_follower_def_slave_trader",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	
	------------
	-- KHORNE --
	------------
	{
		["follower"] = "wh3_main_anc_follower_kho_agent_of_blood",
		["event"] = "CharacterRazedSettlement",
		["condition"] =
			function(context)
				return cm:char_is_general(context:character());
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_arena_fighter",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_blood_collector",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_cult_book_keeper",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("dignitary") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_drillmaster",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:battles_won() > 5;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_fire_starter",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_military_force() and (character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_flesh_hound_handler",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return char_army_has_unit(context:character(), "wh3_main_kho_inf_flesh_hounds_of_khorne_0");
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_khornate_familiar",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():turns_in_enemy_regions() > 0;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_khornate_mutant",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_reinforced_alongside_culture(context:character(), "wh3_main_kho_khorne");
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_khornate_zealot",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_corruption_value_in_region(character:region(), khorne_corruption_string) < 2 and not character:has_ancillary("wh3_main_anc_follower_kho_khornate_zealot");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_norscan_marauder",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh_dlc08_nor_norsca");
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_norscan_sage",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_reinforced_alongside_culture(context:character(), "wh_dlc08_nor_norsca");
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_slaughterman",
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				return true;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_kho_stoker_of_fires",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():military_allies_with(character:faction());
			end,
		["chance"] = 10
	},
	
	--------------
	-- SLAANESH --
	--------------
	{
		["follower"] = "wh3_main_anc_follower_sla_agent_of_temptation",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character == context:pending_battle():defender();
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_card_shark",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "release" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_courtesan",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:public_order() < -20;
				end;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_cult_neophyte",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("dignitary") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_cult_treasurer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_dominatrix",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_enticer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"});
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_epicurean",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "enslave_slaves_only" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_gourmand",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:faction_province_growth_per_turn() < 10;
				end;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_master_musician",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 3
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_master_painter",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and char_army_has_unit(character, {"wh3_main_sla_inf_marauders_0", "wh3_main_sla_inf_marauders_1", "wh3_main_sla_inf_marauders_2"});
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_master_poet",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_paramour",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():military_allies_with(character:faction());
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_slaaneshi_familiar",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():turns_in_enemy_regions() > 0;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_slaaneshi_mutant",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_reinforced_alongside_culture(context:character(), "wh3_main_sla_slaanesh");
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_sla_slaaneshi_zealot",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_corruption_value_in_region(character:region(), slaanesh_corruption_string) < 2;
			end,
		["chance"] = 10
	},
	
	------------
	-- NURGLE --
	------------
	{
		["follower"] = "wh3_main_anc_follower_nur_agent_of_decay",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("spy") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_agitator",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():military_allies_with(character:faction());
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_bruntos_bowelpurge",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and count_char_army_has_unit(character, "wh3_main_nur_inf_nurglings_0") > 7;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_comptroller",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					if character == context:pending_battle():attacker() then
						return cm:pending_battle_cache_unit_key_exists_in_defenders("wh3_main_nur_inf_plaguebearers_0") or cm:pending_battle_cache_unit_key_exists_in_defenders("wh3_main_nur_inf_plaguebearers_1");
					else
						return cm:pending_battle_cache_unit_key_exists_in_attackers("wh3_main_nur_inf_plaguebearers_0") or cm:pending_battle_cache_unit_key_exists_in_attackers("wh3_main_nur_inf_plaguebearers_1");
					end;
				end;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_dark_apothecary",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("dignitary") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_entomologist",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:faction_province_growth_per_turn() < 10;
				end;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_leper_lord",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and char_army_has_unit(character, {"wh3_main_nur_inf_plaguebearers_0", "wh3_main_nur_inf_plaguebearers_1"});
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_nurglish_familiar",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():turns_in_enemy_regions() > 0;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_nurglish_jester",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character == context:pending_battle():defender();
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_nurglish_mutant",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_reinforced_alongside_culture(context:character(), "wh3_main_nur_nurgle");
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_nurglish_zealot",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_corruption_value_in_region(character:region(), nurgle_corruption_string) < 2 and not character:has_ancillary("wh3_main_anc_follower_nur_nurglish_zealot");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_plague_doctor",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"});
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_plagueship_captain",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 3
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_poisoner",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:military_force():will_suffer_any_attrition() and character:faction():has_home_region();
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_preacher_of_decay",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_nur_nurgle");
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_nur_sceptic",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 40
	},
	
	--------------
	-- TZEENTCH --
	--------------
	{
		["follower"] = "wh3_main_anc_follower_tze_agent_of_change",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and context:pending_battle():battle_type() == "land_normal";
			end,
		["chance"] = 4
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_alchemist",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_conspiracy_theorist",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_cult_scribe",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("dignitary") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_masked_dilettante",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:faction_province_growth_per_turn() < 10;
				end;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_mythomaniac",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"});
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_player_of_games",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:public_order() < -20;
				end;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_schemer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and context:pending_battle():ambush_battle();
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_sorcerers_apprentice",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_treacher",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:has_region() and character:region():owning_faction():military_allies_with(character:faction());
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_trickster",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character == context:pending_battle():defender();
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_tzeentchian_familiar",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():turns_in_enemy_regions() > 0;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_tzeentchian_mutant",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_reinforced_alongside_culture(context:character(), "wh3_main_tze_tzeentch");
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_tzeentchian_philosopher",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "release" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_tzeentchian_zealot",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_corruption_value_in_region(character:region(), tzeentch_corruption_string) < 2 and not character:has_ancillary("wh3_main_anc_follower_tze_tzeentchian_zealot");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_tze_weaver",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():military_allies_with(character:faction());
			end,
		["chance"] = 10
	},
	
	------------
	-- KISLEV --
	------------
	{
		["follower"] = "wh3_main_anc_follower_ksl_akshina_informant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():turns_in_enemy_regions() > 0;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_atamans_administrator",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction() == character:faction();
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_knights_squire",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and char_army_has_unit(character, {"wh3_main_ksl_inf_tzar_guard_0", "wh3_main_ksl_inf_tzar_guard_1"});
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_knights_ward",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character == context:pending_battle():defender();
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_kvas_deye",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():military_allies_with(character:faction());
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_nomad_riding_master",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and (count_char_army_has_unit_category(character, "cavalry") > 3 or count_char_army_has_unit_category(character, "war_beast") > 3);
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_old_crone",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("wizard") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_orthodoxy_cleric",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("dignitary") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_priest_of_taal",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return not character:has_ancillary("wh3_main_anc_follower_ksl_priest_of_taal") and character_won_battle_against_culture(character, {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh_dlc03_bst_beastmen", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"});
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_priest_of_ursun",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				local target_character_culture = context:target_character():faction():culture();
				return not context:character():has_ancillary("wh3_main_anc_follower_ksl_priest_of_ursun") and (target_character_culture == "wh_main_chs_chaos" or target_character_culture == "wh_dlc08_nor_norsca" or target_character_culture == "wh_dlc03_bst_beastmen" or target_character_culture == "wh3_main_dae_daemons" or target_character_culture == "wh3_main_kho_khorne" or target_character_culture == "wh3_main_nur_nurgle" or target_character_culture == "wh3_main_sla_slaanesh" or target_character_culture == "wh3_main_tze_tzeentch") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_ritual_enforcer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) > 15 and not character:has_ancillary("wh3_main_anc_follower_ksl_ritual_enforcer");
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_steppe_shepherd",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:faction_province_growth_per_turn() < 10;
				end;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_tax_collector",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_veteran_warrior",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and (count_char_army_has_unit_category(character, "inf_melee") + count_char_army_has_unit_category(character, "inf_ranged")) > 7;
			end,
		["chance"] = 20
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_vodka_distiller",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:public_order() < -20;
				end;
			end,
		["chance"] = 15
	},
	
	-----------
	-- OGRES --
	-----------
	{
		["follower"] = "wh3_main_anc_follower_ogr_artificer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and char_army_has_unit(character, "wh3_main_ogr_inf_leadbelchers_0");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_bellower",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:faction_province_growth_per_turn() < 10;
				end;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_brewer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:public_order() < -20;
				end;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_campfire_storyteller",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) > 15 and not character:has_ancillary("wh3_main_anc_follower_ogr_campfire_storyteller");
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_cave_painter",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:has_region() and character:region():settlement():get_climate() == "climate_mountain";
			end,
		["chance"] = 12
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_eastern_traveller",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_reinforced_alongside_culture(context:character(), "wh3_main_cth_cathay");
			end,
		["chance"] = 50
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_enforcer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:public_order() < -75;
				end;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_gnoblar_chief",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and char_army_has_unit(character, {"wh3_main_ogr_inf_gnoblars_0", "wh3_main_ogr_inf_gnoblars_1"});
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_gnoblar_inventor",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:military_force():will_suffer_any_attrition() and character:faction():has_home_region();
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_gnoblar_treasurer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_halfling_cook",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_pit_fighter",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:battles_won() > 5;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_ransom_negotiator",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():military_allies_with(character:faction());
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_rhinoxen_handler",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and char_army_has_unit(character, {"wh3_main_ogr_cav_crushers_0", "wh3_main_ogr_cav_crushers_1"});
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_spider_hunter",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_unit(context:character(), {"wh_dlc06_grn_mon_spider_hatchlings_0_summoned", "wh_dlc06_grn_mon_spider_hatchlings_0", "wh_dlc08_grn_mon_arachnarok_spider_boss", "wh_main_grn_cav_forest_goblin_spider_riders_0", "wh_main_grn_cav_forest_goblin_spider_riders_1", "wh_main_grn_mon_arachnarok_spider_0"});
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh3_main_anc_follower_ogr_yhetee_wrangler",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 3
	},
	
	------------
	-- CATHAY --
	------------
	{
		["follower"] = "wh3_main_anc_follower_cth_aged_sage",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character == context:pending_battle():defender();
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_assassins_apprentice",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("engineer") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_city_administrator",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:faction_province_growth_per_turn() < 10;
				end;
			end,
		["chance"] = 25
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_fu_hung_monk",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) > 15 and not character:has_ancillary("wh3_main_anc_follower_cth_fu_hung_monk");
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_horse_husband",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and count_char_army_has_unit_category(character, "cavalry") > 3;
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_jade_lion_whisperer",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle();
			end,
		["chance"] = 3
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_jade_sculptor",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_unit(context:character(), {"wh3_main_cth_inf_jade_warriors_0", "wh3_main_cth_inf_jade_warriors_1"});
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_mercantilist",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_reinforced_alongside_culture(context:character(), "wh_main_emp_empire");
			end,
		["chance"] = 50
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_messenger",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():military_allies_with(character:faction());
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_ogre_mercenary",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local pb = context:pending_battle();
				local character = context:character();
				
				if character:won_battle() and pb:has_attacker() and pb:attacker() == character then
					local defender_family_member = cm:get_family_member_by_cqi(cm:pending_battle_cache_get_defender_fm_cqi(1));
					
					return defender_family_member and defender_family_member:character_details():character_subtype_key() == "wh3_main_ogr_tyrant_camp";
				end;
			end,
		["chance"] = 50
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_scrivener",
		["event"] = "CharacterGarrisonTargetAction",
		["condition"] =
			function(context)
				return context:mission_result_success() or context:mission_result_critial_success();
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_sentinel_technician",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and char_army_has_unit(character, "wh3_main_cth_mon_terracotta_sentinel_0");
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_silk_weaver",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:military_force():will_suffer_any_attrition() and character:faction():has_home_region();
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_sword_master",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and char_army_has_unit(character, {"wh3_main_cth_inf_jade_warriors_0", "wh3_main_cth_inf_jade_warriors_1"});
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_tax_collector",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 40
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_tea_master",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:public_order() < -20;
				end;
			end,
		["chance"] = 15
	},
	{
		["follower"] = "wh3_main_anc_follower_cth_water_snake_breeder",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:battles_won() > 5;
			end,
		["chance"] = 10
	}
};



function load_followers()
	for i = 1, #followers do
		core:add_listener(
			followers[i].follower,
			followers[i].event,
			followers[i].condition,
			function(context)
				local character = context:character();
				local chance = followers[i].chance;
				
				-- daemon prince shares followers, so has a bigger pool, so the chance is reduced for them
				if character:faction():culture() == "wh3_main_dae_daemons" then
					chance = math.round(chance * 0.5);
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