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
	end
end

cm:add_loading_game_callback(cbfm_update_initiatives)
