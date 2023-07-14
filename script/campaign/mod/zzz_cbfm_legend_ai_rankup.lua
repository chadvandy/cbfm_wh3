function character_unlocking:ai_unlock_by_rank(character)
    --out("DRZ ai_unlock_by_rank "..character)
	local character_info = self.character_data[character]
	local character_ai_spawn = character_info.name .. "AISpawn"

	core:add_listener(
		character_ai_spawn,
		"CharacterRankUp",
		function(context)
			local charac = context:character()
			local faction = charac:family_member():character_details():faction()
			local faction_name = faction:name()
			--out("DRZ CharacterRankUp "..charac:character_subtype_key().." "..tostring(charac:rank()))
			for i = 1, #character_info.allowed_factions do
                --out("  DRZ CharacterRankUp "..faction_name.." "..tostring(i).." "..tostring(character_info.allowed_factions[i]))
				if faction_name == character_info.allowed_factions[i] then
                    --out("    DRZ CharacterRankUp")
					return charac:rank() == character_info.ai_unlock_rank and
						self:character_has_valid_faction_in_campaign(character)
				end
			end
		end,
		function(context)
            --out("      DRZ CharacterRankUp spawning "..character)
			local faction = context:character():family_member():character_details():faction()
			self:spawn_hero(faction:name(), character)
		end,
		true
	)
end