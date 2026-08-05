function caravans:reward_item_check(faction, region_key, caravan_master)
	local culture = faction:culture()
	local faction_name = faction:name()
	local reward = self.reward_list[culture][region_key]
	local anc_exists = false -- CBFM: new variable to track if ancillary exists so function does not need to exit prematurely, precluding other rewards
	local alt_reward = false -- CBFM: new variable to track if there is an alternate (non-ancillary) reward at stake, so the payload should still be applied even if there is no ancillary available

	-- faction specific override
	if self.reward_list[faction_name] and self.reward_list[faction_name][region_key] then
		reward = self.reward_list[faction_name][region_key]
	end

	-- get a different ancillary if the faction already owns it
	if faction:ancillary_exists(reward[1]) then
		if cm:random_number(5) == 1 then
			local campaign_key = cm:model():campaign_name_key()
			local item_list = self.special_reward_list[campaign_key][culture]

			-- faction specific override.
			if self.special_reward_list[campaign_key] and self.special_reward_list[campaign_key][faction_name] then
				item_list = self.special_reward_list[campaign_key][faction_name]
			end

			if item_list then
				reward = item_list[cm:random_number(#item_list)]

				if faction:ancillary_exists(reward[1]) then anc_exists = true end
			else
				anc_exists = true
			end
		else
			anc_exists = true
		end
	end
	
	local character = caravan_master:character()
	local payload_builder = cm:create_payload()
	local iron_favor = self.payload_iron_favor;
	
	if not anc_exists then
		payload_builder:character_ancillary_gain(character, reward[1], false)
	end
	
	if reward[3] then
		payload_builder:add_unit(character:military_force(), reward[3], 1 + cm:get_factions_bonus_value(faction, "chd_convoy_additional_unit_reward_scripted"), 0)
		alt_reward = true
	end
	
	if reward[4] then
		payload_builder:faction_pooled_resource_transaction(iron_favor.key, iron_favor.factor, iron_favor.amount, false)
		alt_reward = true
	end

	if not anc_exists or alt_reward then
		cm:trigger_custom_incident_with_targets(
			faction:command_queue_index(),
			reward[2],
			true,
			payload_builder,
			0,
			0,
			character:command_queue_index(),
			0,
			0,
			0
		)
	end
end