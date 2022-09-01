-- initiative unlocking system
initiative_unlock = {
	cm = false,
	initiative_key = "",
	event = "",
	condition = false
};

local initiative_cultures = {
	wh3_main_ogr_ogre_kingdoms = true,
	wh_main_chs_chaos = true
}

local initiative_templates = {

	--- OGRE BIG NAMES----
	-- gatecrasher (greasus)
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_gatecrasher",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():pending_battle():battle_type() == "settlement_standard";
			end
	},
	-- hoardmaster (greasus)
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_hoardmaster",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_ogr_ogre_kingdoms");
			end
	},
	-- shockingly obese (greasus)
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_shockingly_obese",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill";
			end
	},
	-- tradelord (greasus)
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_tradelord",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_military_force() then
					local mf = character:military_force();
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
				end;
			end
	},
	
	-- ever famished (skrag)
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_ever_famished",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				local mf = false;
				
				if character:has_military_force() then 
					mf = character:military_force();
				end;
				
				if mf then
					local meat = mf:pooled_resource_manager():resource("wh3_main_ogr_meat");
					
					return not meat:is_null_interface() and meat:value() > 50;
				end;
			end
	},
	-- gore harvester (skrag)
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_gore_harvester",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill";
			end
	},
	-- maw that walks (skrag)
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_maw_that_walks",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name and pb:has_attacker() then
						return pb:attacker():is_caster();
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						return pb:defender():is_caster();
					end;
				end;
			end
	},
	-- world swallower (skrag)
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_world_swallower",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and character:battles_won() > 4;
			end
	},
	
	-- arsebelcher
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_arsebelcher",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function()
				return cm:random_number(100) < 6;
			end
	},
	-- beastkiller
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_beastkiller",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh_dlc03_bst_beastmen");
			end
	},
	-- beastrider
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_beastrider",
		["event"] = "CharacterAncillaryGained",
		["condition"] =
			function(context)
				return context:ancillary() == "wh3_main_anc_mount_ogr_hunter_stonehorn";
			end
	},
	-- bellyslapper
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_bellyslapper",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "enslave";
			end
	},
	-- bigbellower
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_bigbellower",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and ((cm:pending_battle_cache_faction_is_attacker(character:faction():name()) and cm:pending_battle_cache_num_attackers() > 1) or cm:pending_battle_cache_num_defenders() > 1);
			end
	},
	-- bonechewer
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_bonechewer",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				local mf = false;
				
				if character:has_military_force() then 
					mf = character:military_force();
				elseif not character:embedded_in_military_force():is_null_interface() then
					mf = character:embedded_in_military_force();
				end;
				
				if mf then
					local meat = mf:pooled_resource_manager():resource("wh3_main_ogr_meat");
					
					return not meat:is_null_interface() and meat:value() > 50;
				end;
			end
	},
	-- boommaker
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_boommaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and char_army_has_unit(character, "wh3_main_ogr_inf_leadbelchers_0");
			end
	},
	-- brawlerguts
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_brawlerguts",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and character:battles_won() > 4;
			end
	},
	-- campmaker
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_campmaker",
		["event"] = "SpawnableForceCreatedEvent",
		["condition"] =
			function(context)
				return true;
			end
	},
	-- chaos_slayer
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_chaos_slayer",
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				local region_name = context:garrison_residence():region():name();
				
				return region_name == "wh3_main_chaos_region_the_challenge_stone" or region_name == "wh3_main_combi_region_the_challenge_stone";
			end
	},
	-- daemonbreaker
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_daemonbreaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character_won_battle_against_culture(character, {"wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_tze_tzeentch", "wh3_main_sla_slaanesh", "wh3_main_dae_daemons"})
			end
	},
	-- deathcheater
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_deathcheater",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end
	},
	-- dwarfsquasher
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_dwarfsquasher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh_main_dwf_dwarfs");
			end
	},
	-- elfmulcher
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_elfmulcher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)				
				return character_won_battle_against_culture(context:character(), {"wh2_main_hef_high_elves", "wh_dlc05_wef_wood_elves", "wh2_main_def_dark_elves"});
			end
	},
	-- giantbreaker
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_giantbreaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_unit(context:character(), {"wh3_main_ogr_mon_giant_0", "wh_dlc03_bst_mon_giant_0", "wh_dlc08_nor_mon_norscan_giant_0", "wh_main_chs_mon_giant", "wh_main_grn_mon_giant"});
			end
	},
	-- gnoblarkicker
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_gnoblarkicker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and count_char_army_has_unit(character, {"wh3_main_ogr_inf_gnoblars_0", "wh3_main_ogr_inf_gnoblars_1"}) > 4;
			end
	},
	-- goldhoarder
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_goldhoarder",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true;
			end
	},
	-- grandfeaster
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_grandfeaster",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() >= 40;
			end
	},
	-- groundbreaker
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_groundbreaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_cth_cathay");
			end
	},
	-- gutcrusher
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_gutcrusher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if attacker_faction_name == character_faction_name then
						return pb:attacker_kills() > 2500;
					elseif defender_faction_name == character_faction_name then
						return pb:defender_kills() > 2500;
					end;
				end;
			end
	},
	-- kineater
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_kineater",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				if not character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name then
						return pb:defender_kills() > pb:attacker_kills();
					elseif attacker_faction_name == character_faction_name then
						return pb:attacker_kills() > pb:defender_kills();
					end;
				end;
			end
	},
	-- lizardstrangler
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_lizardstrangler",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh2_main_lzd_lizardmen");
			end
	},
	-- longstrider
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_longstrider",
		["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 10;
			end
	},
	-- magichunter
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_magichunter",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name and pb:has_attacker() then
						return pb:attacker():is_caster();
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						return pb:defender():is_caster();
					end;
				end;
			end
	},
	-- maneater
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_maneater",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia"});
			end
	},
	-- mawseeker
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_mawseeker",
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				local region_name = context:garrison_residence():region():name();
				
				return region_name == "wh3_main_chaos_region_xen_wu" or region_name == "wh3_main_combi_region_xen_wu";
			end
	},
	-- mountaineater
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_mountaineater",
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				return context:garrison_residence():region():settlement():get_climate() == "climate_mountain";
			end
	},
	-- mountaintalker
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_mountaintalker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				if context:character():won_battle() then
					local region = cm:get_region(cm:model():pending_battle():region_data():key());
					
					return region and region:settlement():get_climate() == "climate_mountain";
				end;
			end
	},
	-- ogrekiller
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_ogrekiller",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_ogr_ogre_kingdoms");
			end
	},
	-- orcsplitter
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_orcsplitter",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh_main_grn_greenskins");
			end
	},
	-- ratkiller
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_ratkiller",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh2_main_skv_skaven");
			end
	},
	-- staydeader
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_staydeader",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), {"wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_tomb_kings", "wh2_dlc11_cst_vampire_coast"});
			end
	},
	-- wallcrusher
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_wallcrusher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():pending_battle():battle_type() == "settlement_standard";
			end
	},

	-----------------------------------------------
	---	CHAOS PATH TO GLORY	- MARKS/ASCESNSION	---    
	-----------------------------------------------
	-- Daemon Princes
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_khorne", "wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_nurgle",				-- Khorne & Nurgle
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_tzeentch", "wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_slaanesh",			-- Tzeentch & Slaanesh
			},
		["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 20
			end
	},

	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_undivided", 
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_khorne_from_und",
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_nurgle_from_und",
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_slaanesh_from_und",
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_tzeentch_from_und"
			},
		["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 30
			end
	},
	-- Lords and Heroes
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_devote_exalted_hero_to_khorne", "wh3_dlc20_character_initiative_devote_exalted_hero_to_nurgle",							-- 	Exalted Hero - Khorne & Nurgle
				"wh3_dlc20_character_initiative_devote_lord_to_khorne", "wh3_dlc20_character_initiative_devote_lord_to_slaanesh",										-- 	Chaos Lord - Khorne & Slaanesh 
				"wh3_dlc20_character_initiative_devote_sorceror_to_tzeentch_tzeentch", 																					--	Sorceror - Tzeentch (Tzeentch) 
				"wh3_dlc20_character_initiative_devote_sorceror_lord_to_tzeentch_tzeentch",																				--	Sorceror Lord - Tzeentch (Tzeentch)
				"wh3_dlc20_character_initiative_devote_sorceror_to_slaanesh_slaanesh",																					--	Sorceror - Slaanesh (Slaanesh) 
				"wh3_dlc20_character_initiative_devote_sorceror_lord_to_nurgle_nurgle", 																				--	Sorceror Lord - Nurgle (Nurgle) 
			},
		["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 5
			end
	},
	-- Lords and Heroes (Alternate spell lores; these are split from the above to avoid duplicate events in the Event Feed)
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_devote_sorceror_to_tzeentch_metal",																						--	Sorceror - Tzeentch  (Metal)
				"wh3_dlc20_character_initiative_devote_sorceror_lord_to_tzeentch_metal", 																				--	Sorceror Lord - Tzeentch (Metal)
				"wh3_dlc20_character_initiative_devote_sorceror_to_slaanesh_shadows", 																					--	Sorceror - Slaanesh (Shadows)
				"wh3_dlc20_character_initiative_devote_sorceror_lord_to_nurgle_death",	 																				--	Sorceror Lord - Nurgle (Death)
			},
		["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 5
			end
		},
	-----------------------------------------------
	---	CHAOS PATH TO GLORY	- 		BOONS		---
	-----------------------------------------------
	-- Winning a battle with 2000 kills (Attack buff Boon)
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_und_03", "wh3_dlc20_character_initiative_chs_chaos_lord_und_02", "wh3_dlc20_character_initiative_chs_daemon_prince_und_03",	-- 	Undivided (Exalted Hero, Chaos Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_05", "wh3_dlc20_character_initiative_chs_chaos_lord_kho_03", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_03",	-- 	Khorne (Exalted Hero, Chaos Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_exalted_hero_nur_03", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_03",															-- 	Nurgle (Exalted Hero, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_chaos_lord_sla_03", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_03", 																-- 	Slaanesh (Chaos Lord, Daemon Prince)
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if attacker_faction_name == character_faction_name then
						return pb:attacker_kills() > 2000;
					elseif defender_faction_name == character_faction_name then
						return pb:defender_kills() > 2000;
					end;
				end;
			end,
		["grant_immediately"] = true
	},
	-- Win 5 Battles (Defence buff Boon)
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_und_01", "wh3_dlc20_character_initiative_chs_exalted_hero_kho_01", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_01",																																	-- Exalted Heroes
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_01", "wh3_dlc20_character_initiative_chs_chaos_lord_kho_01", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_01", 							-- Chaos Lords
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_01", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_01", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_01", 				-- Chaos Sorcerers
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_01", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_01", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_01", 	-- Chaos Sorcerer Lords
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_01", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_01", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_01", 					-- Daemon Princes
				"wh3_dlc20_character_initiative_chs_daemon_prince_sla_01", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_01",  																				-- Daemon Princes
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and character:battles_won() > 4;
			end,
		["grant_immediately"] = true
	},
	-- Reaching Rank 15 (Indisputable Champion)
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_09", "wh3_dlc20_character_initiative_chs_daemon_prince_und_08",	-- 	Undivided (Chaos Lord, Chaos Sorcerer Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_08", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_08",																	-- 	Khorne (Chaos Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_09", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_08",															-- 	Nurgle (Chaos Sorcerer Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_chaos_lord_sla_08", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_08",																	-- 	Slaanesh (Chaos Lord,Daemon Prince)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_09", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_08",															-- 	Tzeentch (Chaos Sorcerer Lord, Daemon Prince)
			},
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() >= 15
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against Nurgle 
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_04", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_06", 			-- Nurgle - Corruption
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_06", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_06",			-- Favoured by Nurgle
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_05", 																	-- Tempted by Decay
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_nur_nurgle");
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against Slaanesh 
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_07", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_06",				-- Favoured by Slaanesh
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_05", 																		-- Tempted by Excess
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_sla_slaanesh");
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against Tzeentch 
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_07", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_08", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_06",		-- Favoured by Tzeentch
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_06", 																-- Tempted by Change
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return character_won_battle_against_culture(context:character(), "wh3_main_tze_tzeentch");
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against Daemons of Chaos.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_09", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_09", "wh3_dlc20_character_initiative_chs_exalted_hero_und_08", 						-- Mortal Champion (Exalted Hero)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_10", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_10", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_10", 				-- Mortal Prophet (Chaos Sorcerer)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_08", 	-- Mortal Supremacy (Chaos Sorcerer Lord)
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_07", "wh3_dlc20_character_initiative_chs_chaos_lord_kho_07", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_07", 							-- Mortal Supremacy (Chaos Lord)
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_04", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_04", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_04", 					-- Mortal Supremacy (Daemon Prince)
				"wh3_dlc20_character_initiative_chs_daemon_prince_nur_04", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_04", 																				-- Mortal Supremacy (Daemon Prince)
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character_won_battle_against_culture(character, {"wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_tze_tzeentch", "wh3_main_sla_slaanesh", "wh3_main_dae_daemons"})
			end,
		["grant_immediately"] = true
	},
	-- Use the Sacrifice Captives post-battle captive option.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_09", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_09", "wh3_dlc20_character_initiative_chs_chaos_lord_und_09", 							-- Soul Harvester (Chaos Lord)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_10", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_10", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_10", 	-- Soul Harvester (Chaos Sorcerer Lord)
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_09", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_09", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_09",				 	-- Soul Harvester (Daemon Prince) 
				"wh3_dlc20_character_initiative_chs_daemon_prince_sla_09", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_09", 																				-- Soul Harvester (Daemon Prince) 
			},
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "release";
			end,
		["grant_immediately"] = true
	},
	-- Use the Sacrifice Captives post-battle captive option.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_05", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_05", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_05",				 	-- Power Hungry (Daemon Prince) 
				"wh3_dlc20_character_initiative_chs_daemon_prince_kho_05", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_05", 																				-- Power Hungry (Daemon Prince) 
			},
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill";
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against multiple armies.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_daemon_prince_kho_02", "wh3_dlc20_character_initiative_chs_chaos_lord_kho_02", "wh3_dlc20_character_initiative_chs_exalted_hero_kho_04", -- Slaughterlord
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and ((cm:pending_battle_cache_faction_is_attacker(character:faction():name()) and cm:pending_battle_cache_num_defenders() > 1) or cm:pending_battle_cache_num_attackers() > 1);
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against an army led by a spellcaster.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_04", 		-- Mage Hunter (Chaos Sorcerer)
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_06", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_04", "wh3_dlc20_character_initiative_chs_exalted_hero_und_04", 				-- Mage Hunter (Exalted Hero)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_03", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_03", 	-- Master Sorcerer
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_06",  																																-- Pyromancer
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name and pb:has_attacker() then
						return pb:attacker():is_caster();
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						return pb:defender():is_caster();
					end;
				end;
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with another spellcaster in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_02", 					-- Partners in Chaos (Chaos Sorcerer)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_02", 		-- Partners in Chaos (Chaos Sorcerer Lord)
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_02", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_02", 																					-- Partners in Chaos (Daemon Prince)
				"wh3_dlc20_character_initiative_chs_daemon_prince_sla_02", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_02", 																					-- Partners in Chaos (Daemon Prince)
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					local num_friendly_casters = 0

					if defender_faction_name == character_faction_name and pb:has_attacker() then
						defender_char_list = pb:defender():military_force():character_list()

						for i = 0, defender_char_list:num_items() - 1 do
							local temp_character = defender_char_list:item_at(i)
							if temp_character:is_caster() then
								num_friendly_casters = num_friendly_casters + 1
							end
						end
						
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						attacker_char_list = pb:attacker():military_force():character_list()

						for i = 0, attacker_char_list:num_items() - 1 do
							local temp_character = attacker_char_list:item_at(i)
							if temp_character:is_caster() then
								num_friendly_casters = num_friendly_casters + 1
							end
						end

					end;

					return num_friendly_casters > 1
				end;
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against an army with 3 characters.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_04", "wh3_dlc20_character_initiative_chs_chaos_lord_und_03", -- Slayer of Champions
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					local num_enemy_characters = 0

					if defender_faction_name == character_faction_name and pb:has_attacker() then
						attacker_char_list = pb:attacker():military_force():character_list()

						for i = 0, attacker_char_list:num_items() - 1 do
							local temp_character = attacker_char_list:item_at(i)
							if temp_character:is_caster() then
								num_enemy_characters = num_enemy_characters + 1
							end
						end
						
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						defender_char_list = pb:defender():military_force():character_list()

						for i = 0, defender_char_list:num_items() - 1 do
							local temp_character = defender_char_list:item_at(i)
							if temp_character:is_caster() then
								num_enemy_characters = num_enemy_characters + 1
							end
						end
					end;

					return num_enemy_characters >2
				end;
			end,
		["grant_immediately"] = true
	},
	-- Lose a battle and survive.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_07", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_07", "wh3_dlc20_character_initiative_chs_exalted_hero_und_06", 		-- Survivor (Exalted Hero)
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_06", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_06", "wh3_dlc20_character_initiative_chs_chaos_lord_und_06", 			-- Survivor (Chaos Lord)				
				"wh3_dlc20_character_initiative_chs_daemon_prince_kho_07", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_07", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_07", 	-- Survivor (Daemon Prince)
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_07", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_07",  																-- Survivor (Daemon Prince)
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end,
		["grant_immediately"] = true
	},
	-- Win an ambush battle.
	{
		["initiative_key"] = "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_06", -- Shrouded in Chaos
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():pending_battle():ambush_battle()
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with 2 Chaos Knights units in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_und_02", "wh3_dlc20_character_initiative_chs_exalted_hero_kho_02", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_02", -- Chaos Knight Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				local chaos_knights = {
					"wh_main_chs_cav_chaos_knights_0", "wh_main_chs_cav_chaos_knights_1", "wh_pro04_chs_cav_chaos_knights_ror_0",
					"wh3_dlc20_chs_cav_chaos_knights_mkho", "wh3_dlc20_chs_cav_chaos_knights_mkho_lances",
					"wh3_dlc20_chs_cav_chaos_knights_mnur", "wh3_dlc20_chs_cav_chaos_knights_mnur_lances",
					"wh3_dlc20_chs_cav_chaos_knights_msla", "wh3_dlc20_chs_cav_chaos_knights_msla_lances",
					"wh3_main_tze_cav_chaos_knights_0", "wh3_dlc20_chs_cav_chaos_knights_mtze_lances",
				}
				return character:won_battle() and count_char_army_has_unit(character, chaos_knights) > 1;
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with 2 Hellstriders of Slaanesh units in your army.
	{
		["initiative_key"] = "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_03",																										-- Hellstrider Leader
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();

				return character:won_battle() and count_char_army_has_unit(character, {"wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_1"}) > 1
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with 3 Chosen units in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_und_07", "wh3_dlc20_character_initiative_chs_exalted_hero_kho_08", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_08", -- Chosen Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				local chosen = {
					"wh_main_chs_inf_chosen_0", "wh_main_chs_inf_chosen_1", "wh_dlc01_chs_inf_chosen_2",
					"wh3_dlc20_chs_inf_chosen_mkho", "wh3_dlc20_chs_inf_chosen_mkho_dualweapons",
					"wh3_dlc20_chs_inf_chosen_mnur", "wh3_dlc20_chs_inf_chosen_mnur_greatweapons",
					"wh3_dlc20_chs_inf_chosen_msla", "wh3_dlc20_chs_inf_chosen_msla_hellscourges",
					"wh3_dlc20_chs_inf_chosen_mtze", "wh3_dlc20_chs_inf_chosen_mtze_halberds",
				}
				return character:won_battle() and count_char_army_has_unit(character, chosen) > 2;
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with a unit of Aspiring Champions in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_03", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_03", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_03", 	-- Aspiring Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and char_army_has_unit(character, {"wh_dlc06_chs_inf_aspiring_champions_0","wh3_dlc20_chs_inf_aspiring_champions_mtze_ror"})
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with a unit of Skullcrushers in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_03", 						-- Skullcrusher Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and char_army_has_unit(character, {"wh3_main_kho_cav_skullcrushers_0","wh3_dlc20_kho_cav_skullcrushers_mkho_ror"})
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with a unit of Fiends of Slaanesh in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_sla_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_06", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_08", 	-- Fiend Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and char_army_has_unit(character, "wh3_main_sla_mon_fiends_of_slaanesh_0")
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against an army containing 5 missile units.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_05", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_05", 	-- Impenetrable
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_05", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_06",  -- Impenetrable
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name and pb:has_attacker() then
						return character:won_battle() and count_char_army_has_unit_category(pb:attacker(), unit_category) > 4;
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						return character:won_battle() and count_char_army_has_unit_category(pb:defender(), unit_category) > 4;
					end;
				end;

			end,
		["grant_immediately"] = true
	},
	-- Successfully use an Agent Action with this character.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_10", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_10", "wh3_dlc20_character_initiative_chs_exalted_hero_und_09", 			-- Chaos Assassin
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_09", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_09", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_09", 	-- Oppressive Force
			},
		["event"] = {"CharacterCharacterTargetAction", "CharacterGarrisonTargetAction"},
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and not (context:ability() == "assist_army")
			end,
		["grant_immediately"] = true
	},
	-- Rank-up in Raiding stance.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_sla_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_05", 			-- Living Nightmare
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_05", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_05",		-- Aura of Atrophy
			},
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_military_force() then
					local mf = character:military_force();
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
				elseif not character:embedded_in_military_force():is_null_interface() then
					local mf = character:embedded_in_military_force();
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
				end;
			end,
		["grant_immediately"] = true
	},
	-- Rank-up in Channelling stance.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_05", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_05", 																-- Arcane Exemplar
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_06", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_06",															-- Attuned to Chamon (Chaos Sorcerer Lord)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_07", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_07", 																	-- Attuned to Chamon (Chaos Sorcerr)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_07", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_08", 	-- Attuned to Ulgu
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_07", 																															-- Attuned to Shyish	
			},
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_military_force() then
					local mf = character:military_force();
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING");
				elseif not character:embedded_in_military_force():is_null_interface() then
					local mf = character:embedded_in_military_force()
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING");
				end;
			end,
		["grant_immediately"] = true
	},
	-- End your turn with over 80 Winds of Magic reserves.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_03", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_03", 																		-- Master Sorcerer
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_07", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_08",	-- Attuned to Ulgu
			},
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				local mf = false;
				
				if character:has_military_force() then 
					mf = character:military_force();
				elseif not character:embedded_in_military_force():is_null_interface() then
					mf = character:embedded_in_military_force();
				end;
			
				if mf then
					local wom = mf:pooled_resource_manager():resource("wh3_main_winds_of_magic");
					
					return not wom:is_null_interface() and wom:value() > 80;
				end;
			end,
		["grant_immediately"] = true
	},
	-- End your turn with less than 30 Winds of Magic reserves.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_05", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_05", -- Arcane Exemplar
			},
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				local mf = false;
				
				if character:has_military_force() then 
					mf = character:military_force();
				elseif not character:embedded_in_military_force():is_null_interface() then
					mf = character:embedded_in_military_force();
				end;
			
				if mf then
					local wom = mf:pooled_resource_manager():resource("wh3_main_winds_of_magic");
					
					return not wom:is_null_interface() and wom:value() < 30;
				end;
			end,
		["grant_immediately"] = true
	},
	-- End turn in a friendly region with less than -50 Control.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_03", "wh3_dlc20_character_initiative_chs_exalted_hero_und_05", -- Undivided - Corruption
			},
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				local region = character:region()
				
				if region:is_null_interface() == false then
					local region_faction = region:owning_faction()

					if region_faction:is_null_interface() == false then
						if region_faction:is_faction(character:faction()) then
							return region:public_order() < -50
						end
					end
				else
					return false
				end

			end,
		["grant_immediately"] = true
	},
	-- Occupy a settlement with a Chaotic Wasteland climate.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_nur_06", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_04", -- Nurgle - Corruption
			},
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				return context:garrison_residence():region():settlement():get_climate() == "climate_chaotic";
			end
	},
	["grant_immediately"] = true
};

function initiative_unlock_listeners()
	local factions = cm:model():world():faction_list();
	
	for _, current_faction in model_pairs(factions) do
		if initiative_cultures[current_faction:culture()]then
			initiative_faction_exists = true;
			local character_list = current_faction:character_list();
			
			for j = 0, character_list:num_items() - 1 do
				local current_character = character_list:item_at(j);
				
				if not current_character:character_type("colonel") and not current_character:character_details():character_initiative_sets():is_empty() then
					collect_initiatives(current_character);
				end;
			end;
		end;
	end;
	
	if initiative_faction_exists then
		core:add_listener(
			"initiative_character_created",
			"CharacterCreated",
			function(context)
				local character = context:character();
				local faction = character:faction();
				
				return initiative_cultures[faction:culture()] and not character:character_type("colonel") and not character:character_details():character_initiative_sets():is_empty();
			end,
			function(context)
				collect_initiatives(context:character());
			end,
			true
		);
	end;
end;

function collect_initiatives(character)
	local character_initiative_sets = character:character_details():character_initiative_sets();
	
	for k, initiative_set in model_pairs(character_initiative_sets) do
		for l, initiative in model_pairs(initiative_set:all_initiatives()) do
			local current_initiative_key = initiative:record_key();
			if initiative:is_script_locked() then
				for i = 1, #initiative_templates do
					local current_initiative_template = initiative_templates[i]
					if is_string(current_initiative_template.initiative_key) then
						current_initiative_template.initiative_key = {current_initiative_template.initiative_key}
					end
					if is_string(current_initiative_template.event) then
						current_initiative_template.event = {current_initiative_template.event}
					end
					
					for j = 1, #current_initiative_template.initiative_key do
						if current_initiative_key == current_initiative_template.initiative_key[j] then
							local initiative = initiative_unlock:new(
								current_initiative_template.initiative_key,
								current_initiative_template.event,
								current_initiative_template.condition,
								current_initiative_template.grant_immediately
							);

							initiative:start(character:command_queue_index());
						end;
					end
				end;
			end;
		end;
	end
end;

function initiative_unlock:new(initiative_key, event, condition, grant_immediately)


	if not is_table(initiative_key) then
		script_error("ERROR: initiative_unlock:new() called but supplied initiative_key [" .. tostring(initiative_key) .."] is not a table");
		return false;
	elseif not is_table(event) then
		script_error("ERROR: initiative_unlock:new() called but supplied event [" .. tostring(event) .."] is not a table");
		return false;
	elseif not is_function(condition) then
		script_error("ERROR: initiative_unlock:new() called but supplied condition [" .. tostring(condition) .."] is not a function");
		return false;
	end;
	
	local initiative = {};
	setmetatable(initiative, self);
	self.__index = self;
	
	initiative.cm = get_cm();
	initiative.initiative_key = initiative_key;
	initiative.event = event;
	initiative.condition = condition;
	initiative.grant_immediately = grant_immediately;
	
	return initiative;
end;

function initiative_unlock:start(cqi)
	local cm = self.cm;
		
	for i = 1, #self.event do

		for j = 1, #self.initiative_key do

			--out.design("Initiatives -- Starting listener for Initiative with key [" .. self.initiative_key[j] .. "] for character with cqi [" .. cqi .. "]");
			
			core:add_listener(
				self.initiative_key[j] .. "_" .. cqi .. "_listener",
				self.event[i],
				function(context)
					local character_cqi = false;
					
					-- get the characters cqi from the event
					if is_function(context.character) and context:character() and not context:character():is_null_interface() then
						character_cqi = context:character():command_queue_index();
					elseif is_function(context.parent_character) and context:parent_character() and not context:parent_character():is_null_interface() then
						character_cqi = context:parent_character():command_queue_index();
					end;
					
					return character_cqi and character_cqi == cqi and self.condition(context);
				end,
				function()
					out.design("Initiatives -- Conditions met for event [" .. self.event[i] .. "], unlocking Initiative with key [" .. self.initiative_key[j] .. "] for character with cqi [" .. cqi .. "]");
					
					local character = cm:get_character_by_cqi(cqi);

					for k, initiative_set in model_pairs(character:character_details():character_initiative_sets()) do
						if not initiative_set:lookup_initiative_by_key(self.initiative_key[j]):is_null_interface() then
							cm:toggle_character_initiative_script_locked(initiative_set, self.initiative_key[j], false);
							if self.grant_immediately then
								cm:toggle_character_initiative_active(initiative_set, self.initiative_key[j], true);
							end
						end
					end
					
					for l = 1, #self.initiative_key do 
						core:remove_listener(self.initiative_key[l] .. "_" .. cqi .. "_listener");
					end

					-- Save number of Initiatives unlocked by this faction, and trigger an event for narrative scripts
					local saved_value_name = "num_big_names_unlocked_" .. character:faction():name();
					local num_big_names_unlocked = cm:get_saved_value(saved_value_name) or 0;
					cm:set_saved_value(saved_value_name, num_big_names_unlocked + 1);
					core:trigger_custom_event("ScriptEventBigNameUnlocked", {character = character, initiative_key = self.initiative_key[j]});

				end,
				false
			);

		end

	end;
end;