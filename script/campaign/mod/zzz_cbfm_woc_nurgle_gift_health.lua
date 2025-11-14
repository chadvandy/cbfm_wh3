function recruited_unit_health:initialise()
	core:add_listener(
		"UnitStartingHealth",
		"UnitTrained",
		function(context)
			local faction_culture = context:unit():faction():culture() -- CBFM: Getting the culture of this unit's faction
			if self.units_to_starting_health_bonus_values[context:unit():unit_key()] then
				local bonus_value = cm:get_forces_bonus_value(context:unit():military_force(), self.start_hp_bonus_value)
				return bonus_value > 0 and bonus_value < 100 and faction_culture == "wh3_main_nur_nurgle" --CBFM: adding a culture check here so that this script only runs for Nurgle factions (not WoC)
			end
		end,
		function(context)
			local unit = context:unit()
			local force = unit:military_force()
			local base = cm:get_forces_bonus_value(force, self.start_hp_bonus_value)/100
			local unit_bonus = 0

			if self.units_to_starting_health_bonus_values[unit:unit_key()] then
				unit_bonus = cm:get_forces_bonus_value(force, self.units_to_starting_health_bonus_values[unit:unit_key()])/100
			end

			cm:set_unit_hp_to_unary_of_maximum(unit, math.clamp(base +unit_bonus, 0.01,1))
		end,
		true
	)

end