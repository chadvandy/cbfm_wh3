function cbfm_update_initiatives()
	if not is_table(initiative_templates) then return end
	--ModLog("cbfm_update_initiatives has started")
    for key, value in ipairs(initiative_templates) do
		-- "Arcane Exemplar" boon fix, part 1
		if value.initiative_key[1] == "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_05" and #value.initiative_key > 2 then
			initiative_templates[key] = 
			{
				["initiative_key"] = 
					{
						-- CBFM: removing the new version of Arcane Exemplar because the text doesn't match and it conflicts with the old, where the text does match
						-- "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_05", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_05", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_03", "wh3_dlc24_character_initiative_chs_chaos_lord_tze_02",	-- Arcane Exemplar
						"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_06", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_06", "wh3_dlc24_character_initiative_chs_chaos_lord_tze_04",														-- Attuned to Chamon (Chaos Sorcerer Lord)
						"wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_07", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_07", 																														-- Attuned to Chamon (Chaos Sorcerer)
						"wh3_dlc24_character_initiative_chs_exalted_hero_tze_04", 																																														-- Attuned to Chamon (Exalted Hero)
						"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_07", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_08", 														-- Attuned to Ulgu
						"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_07", 																																												-- Attuned to Shyish	
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
			}
		end
		-- "Arcane Exemplar" boon fix, part 2
		if value.initiative_key[1] == "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_05" and #value.initiative_key < 3 then
			initiative_templates[key] =
			{
				["initiative_key"] = 
					{
						-- CBFM: adding new exalted hero and chaos lord for the old requirements
						"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_05", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_05", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_03", "wh3_dlc24_character_initiative_chs_chaos_lord_tze_02" -- Arcane Exemplar
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
			}
		end
	end
end

cm:add_loading_game_callback(cbfm_update_initiatives)