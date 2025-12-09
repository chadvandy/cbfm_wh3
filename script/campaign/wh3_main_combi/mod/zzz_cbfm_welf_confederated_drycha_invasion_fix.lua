function Worldroots:trigger_invasion(forest, x, y, force_size, opt_faction_override, opt_template_override)
	out("triggering invasion of" .. forest.glade_region_key)
	
	local invasion_target = forest.glade_region_key
	local glade_owner_key = cm:get_region(invasion_target):owning_faction():name()
	local invasion_faction = opt_faction_override or forest.invasion_faction
	
	--CBFM: Expanding this condition to allow for situations where Drycha was confederated, h/t Mandras2 on GitHub
	if cm:get_faction(invasion_faction):is_human() or cm:get_faction(invasion_faction):was_confederated() then
		invasion_faction = forest.invasion_faction_alternate
	end
	-- end CBFM edits
	
	local invasion_army_template = opt_template_override or cm:get_faction(invasion_faction):subculture()
	
	if not opt_template_override and forest.invasion_army_template_override then
		invasion_army_template = forest.invasion_army_template_override
	end
	
	local unit_list = WH_Random_Army_Generator:generate_random_army(forest.invasion_force_key, invasion_army_template, force_size, self.invasion_power_modifier, true, false)
	
	if x and y then
		local invasion_key = forest.rite_key .. "_invasion_" .. x .. y
		local spawn_location_x, spawn_location_y = cm:find_valid_spawn_location_for_character_from_position(glade_owner_key, x, y, true)
		local invasion_object = invasion_manager:new_invasion(invasion_key, invasion_faction,unit_list, {spawn_location_x, spawn_location_y})
		invasion_object:apply_effect("wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition", -1)
		invasion_object:set_target("REGION", invasion_target,glade_owner_key)
		invasion_object:add_aggro_radius(25, {glade_owner_key}, 1)
		invasion_object:start_invasion(true, true, false, false)
	end
end