-- CBFM: Removed CA's v2.3.0 region return dilemma workaround in order to enable the new added database table entries.

function empire_trigger_demand_return(player_key, region_key, conquerer_key, elector_faction_key)
	local player = cm:model():world():faction_by_key(player_key);
	local player_cqi = player:command_queue_index();

	local region = cm:model():world():region_manager():region_by_key(region_key);
	local region_cqi = region:cqi();
	
	local conquerer = cm:model():world():faction_by_key(conquerer_key);
	local conquerer_cqi = conquerer:command_queue_index();
	
	local elector_faction = cm:model():world():faction_by_key(elector_faction_key);
	local elector_faction_cqi = elector_faction:command_queue_index();
	
	empire_demand_return_details = {player = player_key, region = region_key, conquerer = conquerer_key, elector = elector_faction_key};
	
	--if elector_faction:is_dead() == true or not empire_demand_return_dilemma_keys["wh2_dlc13_demand_return_"..region_key] then
	if elector_faction:is_dead() == true then
		empire_remove_from_return_queue(region_key, player_key);
	else
		cm:trigger_dilemma_with_targets(player_cqi, "wh2_dlc13_demand_return_"..region_key, elector_faction_cqi, conquerer_cqi, 0, 0, region_cqi, 0);
	end
end