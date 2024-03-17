function waaagh:waaagh_ended_human(context)
	local faction = context:performing_faction()
	local faction_key = faction:name()
	local region_key = self.factions[faction_key].ritual_region_key
	local region = cm:get_region(region_key)
	
	if not region then
		script_error("ERROR: waaagh_ended_human() called but no region target was found - how did this happen?")
		return false
	end
	
	local waaagh_success = self.factions[faction_key].success or region:is_abandoned() or region:owning_faction():name() == faction_key
	local reward_level = self.factions[faction_key].reward_level
	local reward_culture = self.factions[faction_key].reward_culture

	out.design("##### Waaagh Ended - Ritual target region name: "..region:name())

	-- Remove reward preview
	cm:remove_effect_bundle("wh2_main_faction_boost_reward_preview_level"..reward_level.."_"..reward_culture, faction_key);

	-- Switch active reward
	if self.factions[faction_key].previous_reward_level then
		cm:remove_effect_bundle("wh2_main_faction_boost_reward_level"..self.factions[faction_key].previous_reward_level.."_"..self.factions[faction_key].previous_reward_culture, faction_key)
	end

	-- Set Waaagh to 0
	self:modify_pooled_resource(faction_key, self.rs_waagh_triggered, self.waaagh_ended)

	if waaagh_success then
		cm:apply_effect_bundle("wh2_main_faction_boost_reward_level"..reward_level.."_"..reward_culture, faction_key, 0);
		self.factions[faction_key].previous_reward_level = reward_level;
		self.factions[faction_key].previous_reward_culture = reward_culture;

		-- trigger event for grom's food unlocking
		if reward_culture == "elves" then
			core:trigger_event("PlayerGainedWaghElfTrophy", faction);
		end

		-- trigger successful WAAAGH event
		cm:trigger_incident(faction_key, "wh_main_incident_grn_waaagh_success", true)
		core:trigger_event("PlayerWaghEndedSuccessful", faction);

		out.design("#### Waaagh ended! Reward for culture: "..reward_culture.."! Level: "..reward_level)

		-- Award waaagh and additional unit for successful WAAAGH!
		self:modify_pooled_resource(faction_key, self.rs_waagh_success, self.successful_waaagh_boost*reward_level)
		out.design("### Adding Waaagh units to mercenary pool")
		for i = 1, #self.units["level_"..reward_level] do
			cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), self.units["level_"..reward_level][i], 1);
		end
		self.factions[faction_key].success = false;
	else
		-- trigger fail WAAAGH event
		cm:trigger_incident(faction_key,"wh_main_incident_grn_waaagh_failed", true)
		core:trigger_event("PlayerWaghEndedUnsuccessful", faction);		

		self.factions[faction_key].previous_reward_level = nil;
		self.factions[faction_key].previous_reward_culture = nil;
	end

	local comp_scene = "waaagh_"..region_key;
	cm:remove_scripted_composite_scene(comp_scene);

	self.factions[faction_key].ritual_region_key = nil;
end
