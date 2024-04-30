local function init()
	core:remove_listener("force_scribes_cataclysm_bundle")

	core:add_listener(
		"force_scribes_cataclysm_bundle",
		"CharacterTurnStart",
		function(context)
		return cm:get_characters_bonus_value(context:character(), "scribes_random_cataclysm") == 1
		end,
		function(context)
			local force = context:character():military_force()
			local bundle = cm:create_new_custom_effect_bundle("wh3_dlc24_scripted_scribes_random_cataclysm")
			local roll = cm:random_number(8)
			bundle:add_effect("wh3_dlc24_effect_scribes_random_cataclysm_roll_"..roll, "force_to_force_own", 1)
			-- CBFM: set_duration of bundle to 2 so it gets applied one effective turn
			-- Rhox: giving 1 won't work and it needs to give 2 at least. Effect bundle duration deduction occurs at turn start, and after giving effect bundle via listeners.
			bundle:set_duration(2)
			cm:apply_custom_effect_bundle_to_force(bundle, force)
		end,
		true
	)
end

cm:add_first_tick_callback(init)