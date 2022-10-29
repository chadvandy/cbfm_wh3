local function init()
	core:remove_listener("wh2_main_anc_follower_def_diplomat_slaanesh")

	core:add_listener(
		"wh2_main_anc_follower_def_diplomat_slaanesh",
		"CharacterTurnStart",
		function(context)
			local character = context:character()
			return not character:character_type("colonel") and character:faction():has_technology("wh2_main_tech_def_3_3_3") and character:has_region() and cm:get_corruption_value_in_region(character:region(), slaanesh_corruption_string) > 10 and not character:has_ancillary("wh2_main_anc_follower_def_diplomat_slaanesh")
		end,
		function(context)
			local character = context:character()
			local chance = 5
			
			if core:is_tweaker_set("SCRIPTED_TWEAKER_13") then
				chance = 100
			end
			
			if not character:character_type("colonel") and not character:character_subtype("wh_dlc07_brt_green_knight") and not character:character_subtype("wh2_dlc10_hef_shadow_walker") and cm:random_number(100) <= chance then
				cm:force_add_ancillary(character, "wh2_main_anc_follower_def_diplomat_slaanesh", false, false)
			end
		end,
		true
	)
end

cm:add_first_tick_callback(init)