-- This listener listens for the completion of all the required missions and once true will trigger the final battle missions for the set
function malakai_battles:setup_narrative_battle_listeners(mission_set)
	local set_data = self.mission_data[mission_set]
	core:add_listener(
		"final_battle_unlock_listener_" .. mission_set,
		"MissionSucceeded",
		function(context)
			if set_data.adventure_battle_completed ~= true then
				if self:is_key_in_list(context:mission():mission_record_key(), set_data.missions_required_to_unlock_battle_mission) then
					set_data.missions_completed_count = set_data.missions_completed_count + 1
					if set_data.missions_completed_count >= set_data.missions_required_to_trigger_battle_mission then
						return true
					end
				end
			end
		end,
		function(context)
			-- trigger narrative battle mission
			local campaign_name = cm:get_campaign_name()
			-- CBFM: checking if the narrative battle mission was completed instead of the precursor mission that triggered this event; this will ensure that the narrative mission is only started once and rewards are not duplicated
			local mission_key = set_data.narrative_battle_mission_key[campaign_name]
			if not cm:mission_is_active_for_faction(context:faction(), mission_key) then -- end CBFM edits
				cm:trigger_mission(self.malakai_faction, mission_key, true)
				cm:trigger_incident(self.malakai_faction, self.adventure_battle_ready..mission_set, true, true)
			end
		end,
		false
	)

	core:add_listener(
		"final_battle_complete_listener_" .. mission_set,
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == set_data.narrative_battle_mission_key[cm:get_campaign_name()]
		end,
		function()
			set_data.adventure_battle_completed = true
			out.design(self.adventure_battle_complete..mission_set)
			cm:trigger_incident(self.malakai_faction, self.adventure_battle_complete..mission_set, true, true)
		end,
		true
	)
end