function da_plan:trigger_waaagh_missions()
	local mission_data = self.missions.scripted.waaagh

	for _, mission_key in ipairs(mission_data.missions) do
		if mission_data.complete[mission_key] == false then
			local mm = mission_manager:new(self.faction_key, mission_key)

			mm:add_new_scripted_objective(
				"mission_text_text_" .. mission_key,
				"RitualCompletedEvent",
				function(context)
					-- Begin CBFM edits
					local ritual_faction_key = context:performing_faction():name()  -- additional check for faction key to ensure this is gorbad's waaagh
					if context:ritual():ritual_key() == self.missions.scripted.waaagh.ritual and ritual_faction_key == self.faction_key then
					-- End CBFM edits
						mission_data.counts[mission_key] = mission_data.counts[mission_key] + 1

						mm:update_scripted_objective_text("mission_text_text_"..mission_key, mission_data.counts[mission_key], mission_data.targets[mission_key], mission_key)

						if mission_data.counts[mission_key] >= mission_data.targets[mission_key] then
							mission_data.complete[mission_key] = true
							return true
						end
					end
				end,
				mission_key
			)

			mm:add_payload("effect_bundle{bundle_key wh_main_bundle_dummy;turns 0;}")
			mm:set_should_whitelist(false)
			
			if cm:mission_is_active_for_faction(cm:get_faction(self.faction_key), mission_key) == false then
				mm:trigger()
			end

			mm:update_scripted_objective_text("mission_text_text_"..mission_key, mission_data.counts[mission_key], mission_data.targets[mission_key], mission_key)
		end
	end
end