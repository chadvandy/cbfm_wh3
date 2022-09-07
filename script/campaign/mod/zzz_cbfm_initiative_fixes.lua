function cbfm_update_initiatives()
	--ModLog("cbfm_update_initiatives has started")
    for key, value in ipairs(initiative_templates) do
		if value.initiative_key[1] == "wh3_dlc20_character_initiative_chs_chaos_lord_kho_04" then
			initiative_templates[key] = 
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
								local unit_class_localised = common.get_localised_string("unit_class_onscreen_com")

								if defender_faction_name == character_faction_name and pb:has_attacker() then
									for i = 1, cm:pending_battle_cache_num_attackers() do
										local units = cm:pending_battle_cache_get_attacker_units(i)
										for j = 1, #units do
											local unit_key = units[j].unit_key
											local this_class = common.get_context_value("CcoMainUnitRecord",unit_key,"ClassName")
											if this_class == unit_class_localised then
												num_enemy_characters = num_enemy_characters + 1
											end
										end
									end
								elseif attacker_faction_name == character_faction_name and pb:has_defender() then
									for i = 1, cm:pending_battle_cache_num_defenders() do
										local units = cm:pending_battle_cache_get_defender_units(i)
										for j = 1, #units do
											local unit_key = units[j].unit_key
											local this_class = common.get_context_value("CcoMainUnitRecord",unit_key,"ClassName")
											if this_class == unit_class_localised then
												num_enemy_characters = num_enemy_characters + 1
											end
										end
									end
								end;

								--ModLog("total number of characters counted: " .. tostring(num_enemy_characters))
								return num_enemy_characters > 2
							end;
						end,
					["grant_immediately"] = true
				}
		end
	end
end

cm:add_loading_game_callback(cbfm_update_initiatives);