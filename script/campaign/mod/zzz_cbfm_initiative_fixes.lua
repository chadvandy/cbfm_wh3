function cbfm_update_initiatives()
	if not is_table(initiative_templates) then return end
	--ModLog("cbfm_update_initiatives has started")
    for key, value in ipairs(initiative_templates) do
		-- "Wastelander" fix
		if value.initiative_key[1] == "wh3_dlc20_character_initiative_chs_exalted_hero_nur_06" then
			initiative_templates[key] =
			{
				["initiative_key"] = 
					{
						"wh3_dlc20_character_initiative_chs_exalted_hero_nur_06", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_04", -- Nurgle - Corruption
					},
				["event"] = "GarrisonOccupiedEvent",
				["condition"] =
					function(context)
						return context:garrison_residence():region():settlement():get_climate() == "climate_chaotic";
					end,
				-- CBFM: this was missing from the original script
				["grant_immediately"] = true 
			}
		end
		-- "Magic Feaster" Big Name fix
		if value.initiative_key == "wh3_dlc26_character_initiative_ogr_big_name_magic_feaster" then
			initiative_templates[key] =
			{
				["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_magic_feaster",
				["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
				["condition"] =
					function(context)
						local character = context:character()
						
						local pb = cm:model():pending_battle()
						local attack_force = pb:attacker():military_force()
						local defense_force = pb:defender():military_force()
						local hero_attacker = false
						local hero_defender = false
						
						for _, check_char in model_pairs(attack_force:character_list()) do
							if check_char == character then
								hero_attacker = true
								break
							end
						end
						
						for _, check_char in model_pairs(defense_force:character_list()) do
							if check_char == character then
								hero_defender = true
								break
							end
						end
						
						if character:won_battle() then
							--local pb = cm:model():pending_battle()
							return (pb:has_attacker() and (pb:attacker() == character or hero_attacker) and cm:get_saved_value("big_name_defender_spellcaster")) or (pb:has_defender() and (pb:defender() == character or hero_defender) and cm:get_saved_value("big_name_attacker_spellcaster"))
						end
					end,
				["grant_immediately"] = true
			}
		end
		if value.initiative_key == "wh3_dlc26_character_initiative_ogr_big_name_greasus_drakecrush" then
			initiative_templates[key] =
			{
				["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_greasus_drakecrush",
				["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
				["condition"] =
					function(context)
						local character = context:character()	
						local units_to_defeat = {
							"wh2_main_hef_mon_moon_dragon",
							"wh2_main_hef_mon_star_dragon",
							"wh2_main_hef_mon_sun_dragon",
							"wh_dlc05_wef_forest_dragon_0",
							"wh2_main_def_mon_black_dragon",
							"wh2_dlc15_grn_mon_wyvern_waaagh_0",
							"wh_dlc08_nor_mon_frost_wyrm_0",
							"wh_dlc08_nor_mon_frost_wyrm_ror_0",
							--mounts
							"wh2_dlc10_def_cha_supreme_sorceress_beasts_5",
							"wh2_dlc10_def_cha_supreme_sorceress_dark_5",
							"wh2_dlc10_def_cha_supreme_sorceress_death_5",
							"wh2_dlc10_def_cha_supreme_sorceress_fire_5",
							"wh2_dlc10_def_cha_supreme_sorceress_shadow_5",
							"wh2_dlc11_def_cha_lokhir_fellheart_1",
							"wh2_dlc11_vmp_cha_bloodline_blood_dragon_lord_1",
							"wh2_dlc11_vmp_cha_bloodline_blood_dragon_lord_3",
							"wh2_dlc11_vmp_cha_bloodline_lahmian_lord_3",
							"wh2_dlc11_vmp_cha_bloodline_necrarch_lord_3",
							"wh2_dlc11_vmp_cha_bloodline_von_carstein_lord_3",
							"wh2_dlc15_hef_cha_imrik_2",
							"wh2_dlc15_hef_cha_mage_fire_3",
							"wh2_main_def_cha_dreadlord_4",
							"wh2_main_def_cha_dreadlord_female_4",
							"wh2_main_def_cha_malekith_3",
							"wh2_main_hef_cha_alastar_4",
							"wh2_main_hef_cha_alastar_5",
							"wh2_main_hef_cha_prince_4",
							"wh2_main_hef_cha_prince_5",
							"wh2_main_hef_cha_princess_4",
							"wh2_main_hef_cha_princess_5",
							"wh_dlc01_chs_cha_chaos_lord_2",
							"wh_dlc01_chs_cha_chaos_sorcerer_lord_death_10",
							"wh_dlc01_chs_cha_chaos_sorcerer_lord_fire_10",
							"wh_dlc01_chs_cha_chaos_sorcerer_lord_metal_10",
							"wh_dlc01_chs_cha_chaos_sorcerer_lord_shadows_4",
							"wh_dlc05_vmp_cha_red_duke_3",
							"wh_dlc05_wef_cha_female_glade_lord_3",
							"wh_dlc05_wef_cha_glade_lord_3",
							"wh_dlc08_chs_cha_chaos_lord_2_qb",
							"wh_dlc08_nor_cha_kihar_0",
							"wh_main_vmp_cha_mannfred_von_carstein_3",
							"wh_main_vmp_cha_vampire_lord_3",
							"wh2_dlc15_hef_cha_archmage_beasts_4",
							"wh2_dlc15_hef_cha_archmage_death_4",
							"wh2_dlc15_hef_cha_archmage_fire_4",
							"wh2_dlc15_hef_cha_archmage_heavens_4",
							"wh2_dlc15_hef_cha_archmage_high_4",
							"wh2_dlc15_hef_cha_archmage_life_4",
							"wh2_dlc15_hef_cha_archmage_light_4",
							"wh2_dlc15_hef_cha_archmage_metal_4",
							"wh2_dlc15_hef_cha_archmage_shadows_4",
							"wh_main_grn_cha_azhag_the_slaughterer_1",
							"wh_main_grn_cha_orc_warboss_1",
							"wh2_dlc16_wef_cha_sisters_of_twilight_1",
							"wh2_twa03_def_cha_rakarth_3",
							"wh3_main_cth_cha_iron_dragon_0",
							"wh3_main_cth_cha_iron_dragon_1",
							"wh3_main_cth_cha_storm_dragon_0",
							"wh3_main_cth_cha_storm_dragon_1",
							"wh3_dlc24_cth_cha_yuan_bo_dragon",
							"wh3_dlc24_cth_cha_yuan_bo_human",
							-- CBFM: adding missing mounts here, h/t Obsidian#4875 on CA forums
							"wh3_dlc25_emp_cha_elspeth_von_draken_carmine_dragon",
							"wh3_dlc25_nur_cha_exalted_hero_chieftain_chaos_dragon",
							"wh3_dlc26_grn_cha_savage_orc_great_shaman_wyvern"
							-- end CBFM edits
						}
						return character:won_battle() and cm:character_won_battle_against_unit(character, units_to_defeat)
					end,
				["grant_immediately"] = true
			}
		end
	end
end

cm:add_loading_game_callback(cbfm_update_initiatives)
