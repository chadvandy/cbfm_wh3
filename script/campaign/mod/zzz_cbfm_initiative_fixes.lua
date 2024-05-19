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
	end
end

cm:add_loading_game_callback(cbfm_update_initiatives)
