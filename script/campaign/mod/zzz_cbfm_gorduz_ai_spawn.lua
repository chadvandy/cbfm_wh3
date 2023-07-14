function character_unlocking:add_building_completed_listeners(character)
	local character_info = self.character_data[character]
	local character_building_complete = character_info.name .. "buildingcompleted"

	-- Setup mission trigger listeners
	for i = 1, #character_info.allowed_factions do
		local faction = cm:get_faction(character_info.allowed_factions[i])

		if faction and faction:is_human() then
			local faction_name = faction:name()
			if character_info.factions_involved[faction_name] ~= true then
				character_info.factions_involved[faction_name] = true
			end

			core:add_listener(
				faction_name..character_building_complete,
				"BuildingCompleted",
				function(context)
					local building_interface = context:building()
					local faction_key = building_interface:faction():name()
					local building_key = building_interface:name()
					return faction_key == faction_name and self:is_match_key_from_list(building_key, character_info.required_buildings)
				end,
				function(context)
					local faction_key = context:building():faction():name()
					cm:trigger_mission(faction_key, self:get_mission_key(character_info.mission_keys, faction_key), true)
					core:remove_listener(faction_name..character_building_complete)
				end,
				true
			)
			
			local building_mission_success = "legendary_character_building_mission_success"
			
            core:add_listener(
            building_mission_success,
            "MissionSucceeded",
            function(context)
                return self:is_match_key_from_list(
                    context:mission():mission_record_key(),
                    character_info.mission_keys,
                    context:faction():name()
                )
            end,
            function(context)
                local faction_interface = context:faction()
                local faction_name = faction_interface:name()
                if not character_info.alternate_grant_condition then
                    self:spawn_hero(faction_name, character, faction_interface:faction_leader():command_queue_index())
                    self:cancel_missions_for_other_players(faction_name, character, building_mission_success)
                end
            end,
            false
            )
			return
		end
	end
	self:spawn_hero_for_ai(character)
end