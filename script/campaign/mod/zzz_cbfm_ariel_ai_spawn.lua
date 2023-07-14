function character_unlocking:add_ritual_listener(character)
	local character_info = self.character_data[character]
	local character_ritual_success = character_info.name .. "ritualCompletedEvent"

	for i = 1, #character_info.allowed_factions do
		local faction = cm:get_faction(character_info.allowed_factions[i])

		if faction and faction:is_human() then
			local faction_name = faction:name()
			if character_info.factions_involved[faction_name] ~= true then
				character_info.factions_involved[faction_name] = true
			end
            
			core:add_listener(
				faction_name .. character_ritual_success,
				"RitualCompletedEvent",
				function(context)
					return self:is_match_key_from_list(
						context:ritual():ritual_key(),
						character_info.ritual_keys,
						context:performing_faction():name()
					)
				end,
				function(context)
					local name = context:performing_faction():name()
					if not character_info.alternate_grant_condition then
						self:spawn_hero(name, character, faction:faction_leader():command_queue_index())

						for _, v in ipairs(character_info.allowed_factions) do
							if v ~= name and character_info.factions_involved[v] == true then
								core:remove_listener(v .. character_ritual_success)
							end

							if character_info.factions_involved[v] then
								character_info.factions_involved[v] = false
							end
						end
					end
				end,
				true
			)
			return
		end
	end
	self:spawn_hero_for_ai(character)
end
