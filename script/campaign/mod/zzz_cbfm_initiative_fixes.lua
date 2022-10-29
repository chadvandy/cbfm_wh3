function cbfm_update_initiatives()
	if not is_table(initiative_templates) then return end
	--ModLog("cbfm_update_initiatives has started")
    for key, value in ipairs(initiative_templates) do
		-- "Slayer of Champions" boon fix
		if value.initiative_key[1] == "wh3_dlc20_character_initiative_chs_chaos_lord_kho_04" then
			initiative_templates[key] = 
			{
				["initiative_key"] = 
				{
					"wh3_dlc20_character_initiative_chs_chaos_lord_kho_04", "wh3_dlc20_character_initiative_chs_chaos_lord_und_03", -- Slayer of Champions
				},
				["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle","CharacterParticipatedAsSecondaryGeneralInBattle"},
				["condition"] =
					function(context)
						local character = context:character();
						local character_faction_name = character:faction():name();
						local character_cqi = character:cqi()
						local pb = cm:model():pending_battle();
						
						if pb:has_defender() and pb:has_attacker() and character:won_battle() then
							
							local num_defenders = cm:pending_battle_cache_num_defenders()
							local num_attackers = cm:pending_battle_cache_num_attackers()
							
							local defender_char_cqi = {}
							local defender_mf_cqi = {}
							local defender_faction_name = {}
							local attacker_char_cqi = {}
							local attacker_mf_cqi = {}
							local attacker_faction_name = {}
							
							for i = 1, num_defenders do
								defender_char_cqi[i], defender_mf_cqi[i], defender_faction_name[i] = cm:pending_battle_cache_get_defender(i);
							end
							
							for i = 1, num_attackers do
								attacker_char_cqi[i], attacker_mf_cqi[i], attacker_faction_name[i] = cm:pending_battle_cache_get_attacker(i);
							end
							
							local num_enemy_characters = 0
							local unit_class_localised = common.get_localised_string("unit_class_onscreen_com")

							for h = 1, num_defenders do
								if (defender_faction_name[h] == character_faction_name) and (defender_char_cqi[h] == character_cqi) then
									for i = 1, num_attackers do
										local units = cm:pending_battle_cache_get_attacker_units(i)
										for j = 1, #units do
											local unit_key = units[j].unit_key
											local this_class = common.get_context_value("CcoMainUnitRecord",unit_key,"ClassName")
											if this_class == unit_class_localised then
												num_enemy_characters = num_enemy_characters + 1
											end
										end
									end
								end
							end
							
							for h = 1, num_attackers do
								if (attacker_faction_name[h] == character_faction_name) and (attacker_char_cqi[h] == character_cqi) then
									for i = 1, num_defenders do
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
							end

							--ModLog("total number of characters counted: " .. tostring(num_enemy_characters))
							return num_enemy_characters > 2
						end;
					end,
				["grant_immediately"] = true
			}
		end
		-- "Impenetrable" boon fix
		if value.initiative_key[1] == "wh3_dlc20_character_initiative_chs_chaos_lord_kho_05" then
			initiative_templates[key] =
			{
				["initiative_key"] = 
				{
					"wh3_dlc20_character_initiative_chs_chaos_lord_kho_05", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_05", 	-- Impenetrable
					"wh3_dlc20_character_initiative_chs_chaos_lord_und_05", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_06",  -- Impenetrable
				},
				["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle","CharacterParticipatedAsSecondaryGeneralInBattle"},
				["condition"] =
					function(context)
						-- ModLog("Triggering Impenetrable initiative test.")
						local character = context:character();
						local character_faction_name = character:faction():name();
						local character_cqi = character:cqi()
						local pb = cm:model():pending_battle();
						
						if pb:has_defender() and pb:has_attacker() and character:won_battle() then

							-- ModLog("our char won and this is indeed a real battle")
							
							local num_defenders = cm:pending_battle_cache_num_defenders()
							local num_attackers = cm:pending_battle_cache_num_attackers()
							
							local defender_char_cqi = {}
							local defender_mf_cqi = {}
							local defender_faction_name = {}
							local attacker_char_cqi = {}
							local attacker_mf_cqi = {}
							local attacker_faction_name = {}
							
							for i = 1, num_defenders do
								defender_char_cqi[i], defender_mf_cqi[i], defender_faction_name[i] = cm:pending_battle_cache_get_defender(i);
							end
							
							for i = 1, num_attackers do
								attacker_char_cqi[i], attacker_mf_cqi[i], attacker_faction_name[i] = cm:pending_battle_cache_get_attacker(i);
							end
							
							local num_enemy_archers = 0
							local unit_class_localised = common.get_localised_string("unit_class_onscreen_inf_mis")

							for h = 1, num_defenders do
								if (defender_faction_name[h] == character_faction_name) and (defender_char_cqi[h] == character_cqi) then
									for i = 1, num_attackers do
										local units = cm:pending_battle_cache_get_attacker_units(i)
										-- ModLog("There are " .. #units .. " units")
										for j = 1, #units do
											local unit_key = units[j].unit_key
											-- ModLog("This unit key is " .. unit_key)
											local this_class = common.get_context_value("CcoMainUnitRecord", unit_key, "ClassName")
											if this_class == unit_class_localised then
												num_enemy_archers = num_enemy_archers + 1
											end
										end
									end
								end
							end
							
							for h = 1, num_attackers do
								if (attacker_faction_name[h] == character_faction_name) and (attacker_char_cqi[h] == character_cqi) then
									for i = 1, num_defenders do
										local units = cm:pending_battle_cache_get_defender_units(i)
										--ModLog("There are " .. #units .. " units")
										for j = 1, #units do
											local unit_key = units[j].unit_key
											--ModLog("This unit key is " .. unit_key)
											local this_class = common.get_context_value("CcoMainUnitRecord", unit_key, "ClassName")
											--ModLog("This class is " .. this_class)
											if this_class == unit_class_localised then
												num_enemy_archers = num_enemy_archers + 1
											end
										end
									end
								end
							end
							
							--ModLog("Our char is attacker, defender army has " .. tostring(num_enemy_archers) .. " archers.")
							return num_enemy_archers > 4
						end
					end,
				["grant_immediately"] = true
			
			}
		end
	end
end

cm:add_loading_game_callback(cbfm_update_initiatives);