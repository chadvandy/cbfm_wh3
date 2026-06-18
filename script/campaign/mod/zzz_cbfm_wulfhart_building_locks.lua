function update_acclaim_bar(factor)
	local faction = cm:get_faction(wulfhart_faction)
	
	local previous_acclaim_value = faction:pooled_resource_manager():resource(acclaim_resource_key):value()
	
	if factor and acclaim_resource_factors[factor] and not acclaim_lock then
		cm:faction_add_pooled_resource(wulfhart_faction, acclaim_resource_key, acclaim_resource_factors[factor][1], acclaim_resource_factors[factor][2])
	end
	
	local current_acclaim_value = faction:pooled_resource_manager():resource(acclaim_resource_key):value()
	
	-- BEGIN CBFM FIX
	local function lock_wulfhart_buildings(index)
		for i = 1, #wulfhart_buildings_to_unlock[index] do -- Abandoning the pointless "wulfhart_buildings_to_lock" array, which was getting mismatched, in favor of the same table used for unlocking, "wulfhart_buildings_to_unlock"
			cm:add_event_restricted_building_record_for_faction(wulfhart_buildings_to_unlock[index][i], wulfhart_faction, "wulfhart_building_lock")
		end
	end
	-- END CBFM FIX
	
	-- trigger an event reminding about progression reward
	for i = 1, #acclaim_thresholds do
		if previous_acclaim_value < acclaim_thresholds[i] and current_acclaim_value >= acclaim_thresholds[i] then
			cm:trigger_incident(wulfhart_faction, "wh2_dlc13_emp_wulfhart_progress_level_increase", true)
			
			for j = 1, #wulfhart_buildings_to_unlock[i + 1] do
				cm:remove_event_restricted_building_record_for_faction(wulfhart_buildings_to_unlock[i + 1][j], wulfhart_faction)
			end
		elseif previous_acclaim_value >= acclaim_thresholds[i] and current_acclaim_value < acclaim_thresholds[i] then
			lock_wulfhart_buildings(i + 1)
		elseif current_acclaim_value < acclaim_thresholds[1] then -- CBFM note: This last elseif is actually 100% pointless, but it won't break anything, so we'll leave it in for posterity
			lock_wulfhart_buildings(1)
		end
	end
	
	update_imperial_reinforcements_strength()
	
	-- trigger endgame mechanics
	if faction:pooled_resource_manager():resource(acclaim_resource_key):value() >= acclaim_thresholds[#acclaim_thresholds] and not acclaim_lock then
		acclaim_lock = true
	end
end