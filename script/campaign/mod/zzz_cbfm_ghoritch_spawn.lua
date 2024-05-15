function character_unlocking:setup_mission_completed_spawn_hero_listener(character, faction_name, character_mission_success)
	local character_info = self.character_data[character]

	core:add_listener(
		faction_name .. character_mission_success,
		"MissionSucceeded",
		function(context)
			return self:is_match_key_from_list(
				context:mission():mission_record_key(),
				character_info.mission_keys,
				context:faction():name()
			)
		end,
		function(context)
			local faction_name = context:faction():name()
			if not character_info.alternate_grant_condition then
                -- CBFM: fixed spawn_hero argument to use context faction
				self:spawn_hero(faction_name, character, context:faction():faction_leader():command_queue_index())
                -- END CBFM
				self:cancel_missions_for_other_players(faction_name, character, character_mission_success)
			end
		end,
		true
	)
end
