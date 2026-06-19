local wulfhart_faction = "wh2_dlc13_emp_the_huntmarshals_expedition"
local acclaim_resource_key = "emp_progress"
local acclaim_resource_factors = {
	["increase"] =			{"settlements_captured",	3},
	["decrease"] =			{"lost_territory",			-2},
	["increase_ports"] =	{"ports_built_or_upgraded",	1},
	["increase_hunters"] =	{"hunters_unlocked",		4}
}
local acclaim_lock = false

function update_acclaim_bar(factor)
	local faction = cm:get_faction(wulfhart_faction)
	
	local previous_acclaim_value = faction:pooled_resource_manager():resource(acclaim_resource_key):value()
	
	if factor and acclaim_resource_factors[factor] and not acclaim_lock then
		cm:faction_add_pooled_resource(wulfhart_faction, acclaim_resource_key, acclaim_resource_factors[factor][1], acclaim_resource_factors[factor][2])
	end
	
	local current_acclaim_value = faction:pooled_resource_manager():resource(acclaim_resource_key):value()
	
	-- BEGIN CBFM FIX
	local function lock_wulfhart_buildings(index)
		-- index == 0 is only used to set up initial locks for Wulfhart
		if index == 0 then
			for i = 1, #wulfhart_buildings_to_lock do
				cm:add_event_restricted_building_record_for_faction(wulfhart_buildings_to_lock[i], wulfhart_faction, "wulfhart_building_lock")
			end
		else
			for i = 1, #wulfhart_buildings_to_unlock[index] do -- Instead of using "wulfhart_buildings_to_lock" array here, which was getting mismatched, we are reusing ehe same table used for unlocking, "wulfhart_buildings_to_unlock"
				cm:add_event_restricted_building_record_for_faction(wulfhart_buildings_to_unlock[index][i], wulfhart_faction, "wulfhart_building_lock")
			end
		end
	end
	
	-- trigger an event reminding about progression reward
	for i = 1, #acclaim_thresholds do
		if previous_acclaim_value < acclaim_thresholds[i] and current_acclaim_value >= acclaim_thresholds[i] then
			cm:trigger_incident(wulfhart_faction, "wh2_dlc13_emp_wulfhart_progress_level_increase", true)
			
			for j = 1, #wulfhart_buildings_to_unlock[i + 1] do
				cm:remove_event_restricted_building_record_for_faction(wulfhart_buildings_to_unlock[i + 1][j], wulfhart_faction)
			end
		elseif previous_acclaim_value >= acclaim_thresholds[i] and current_acclaim_value < acclaim_thresholds[i] then
			lock_wulfhart_buildings(i + 1)
		elseif current_acclaim_value < acclaim_thresholds[1] then -- CBFM note: This is only needed to set up the initial locks
			lock_wulfhart_buildings(0) -- CBFM note: Changing this to 0 to indicate to our modified function that we just want to lock everything to get to the initial state
		end
	end
	-- END CBFM FIX
	
	update_imperial_reinforcements_strength()
	
	-- trigger endgame mechanics
	if faction:pooled_resource_manager():resource(acclaim_resource_key):value() >= acclaim_thresholds[#acclaim_thresholds] and not acclaim_lock then
		acclaim_lock = true
	end
end

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("acclaim_lock", acclaim_lock, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			acclaim_lock = cm:load_named_value("acclaim_lock", acclaim_lock, context)
		end
	end
)