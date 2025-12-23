cbfm_dechala_settlement_conversions = cm:get_saved_value("cbfm_dechala_settlement_conversions") or {}

-- Listens for conversion in the above stored region, sets the primary slot level to stored value.
function cbfm_dechala_war_pit_settlement_level_fix(region_key,settlement_level)
	core:add_listener(
		"dechala_thrall_camp_converted_to_war_pit" .. region_key,
		"SettlementTypeConvertedEvent",
		function(context)
			return context:settlement():region():name() == region_key and cbfm_dechala_settlement_conversions[region_key]
		end,
		function(context)
			local settlement = context:settlement()
			local dechala_adjusted_tier = math.max(settlement_level - 1, 1)
			if settlement:settlement_type_key() == "wh3_dlc27_dechala_war_pit" then
				cm:instantly_set_settlement_primary_slot_level(settlement, dechala_adjusted_tier)
				
				cbfm_dechala_settlement_conversions[region_key] = nil -- remove from conversion queue
				cm:set_saved_value("cbfm_dechala_settlement_conversions", cbfm_dechala_settlement_conversions)
			end
		end,
		false
	)
end

local function init()
	-- Settlement is marked for conversion to war_pit, stores the current region/settlement level,
	-- clamped at 3 since the maximum input is a level 3 thrall_camp converting to a level 2 war_pit.
	core:add_listener(
		"dechala_thrall_camp_marked_for_conversion_to_war_pit",
		"SettlementMarkedForTypeConversionEvent",
		function(context)
			return context:conversion_settlement_type() == "wh3_dlc27_dechala_war_pit"
		end,
		function(context)
			local settlement = context:settlement()
			local building = settlement:primary_slot():building()
			local dechala_region_key = settlement:region():name()
			local dechala_settlement_level = 1 -- default
			if building then
				dechala_settlement_level = math.min(building:building_level(), 3)
			end
			
			-- call function to correct on conversion
			cbfm_dechala_war_pit_settlement_level_fix(dechala_region_key, dechala_settlement_level)
			
			-- add to the list of conversions queued in case of save/load cycle
			cbfm_dechala_settlement_conversions[dechala_region_key] = dechala_settlement_level
			cm:set_saved_value("cbfm_dechala_settlement_conversions", cbfm_dechala_settlement_conversions)
		end,
		true
	)
	
	-- remove conversions from the queue if player cancels them
	core:add_listener(
		"dechala_thrall_camp_unmarked_for_conversion",
		"SettlementUnMarkedForTypeConversionEvent",
		function(context)
			return cbfm_dechala_settlement_conversions[context:settlement():region():name()] ~= nil
		end,
		function(context)
			local region_key = context:settlement():region():name()
			
			core:remove_listener("dechala_thrall_camp_converted_to_war_pit" .. region_key)
			
			cbfm_dechala_settlement_conversions[region_key] = nil
			cm:set_saved_value("cbfm_dechala_settlement_conversions", cbfm_dechala_settlement_conversions)
		end,
		true
	)
	
	-- process conversion queue for saving/loading
	for region_key, settlement_level in pairs(cbfm_dechala_settlement_conversions) do
		cbfm_dechala_war_pit_settlement_level_fix(region_key, settlement_level)
	end
end

cm:add_first_tick_callback(init)