local function init()
	core:remove_listener("RegionFactionChangeEventBeastmen")
	core:add_listener(
		"RegionFactionChangeEventBeastmen",
		"RegionFactionChangeEvent",
		function(context)
			return context:previous_faction():subculture() == Bloodgrounds.beastmen_sc_key
		end,
		function(context)
			local region = context:region()
			local region_key = region:name()
			local display_chain = region:settlement():display_primary_building_chain()

			local bloodground = Bloodgrounds.active_bloodgrounds[region_key] 

			if bloodground then
				local original_display_chain = bloodground.settlement_display_details

				if not bloodground.ritual_completed or not Bloodgrounds:bloodground_is_human(bloodground) then
					local previous_faction_key = context:previous_faction():name()
					local shard_tracker = cm:get_saved_value("RGP_shard_tracker")
					if shard_tracker == nil or not shard_tracker[region_key] then
						Bloodgrounds:grant_herdstone_shards(previous_faction_key, 1)
					end 
				end

				if context:region():owning_faction():subculture() ~= Bloodgrounds.beastmen_sc_key then
					cm:override_building_chain_display(display_chain, original_display_chain, region_key);
					Bloodgrounds:remove_bloodground(region_key)
				else
					Bloodgrounds:update_effect_bundles_for_bloodgrounds()
				end
			end
		end,
		true
	)

	core:remove_listener("UITriggerRitualOfRuin")
	core:add_listener(
		"UITriggerRitualOfRuin",
		"UITrigger",
		function(context)
			return string.find(context:trigger(), Bloodgrounds.ritual_script_trigger_prefix)
		end,
		function(context)
			local region_key = string.gsub(context:trigger(), Bloodgrounds.ritual_script_trigger_prefix, "")
			local bloodground = Bloodgrounds:is_bloodground_region(region_key)

			if bloodground.ritual_unlocked and not bloodground.ritual_completed then
				Bloodgrounds:out("Performing Ritual of Ruin!")
				bloodground.ritual_completed = true
				local shard_tracker = cm:get_saved_value("RGP_shard_tracker")
				if shard_tracker ~= nil then
					shard_tracker[region_key] = true
				else
					shard_tracker = {[region_key] = true}
				end
				cm:set_saved_value("RGP_shard_tracker", shard_tracker)
				Bloodgrounds:apply_vfx(region_key, Bloodgrounds.defiled_bloodground_vfx_key)

				cm:remove_scripted_composite_scene(region_key.."_ritual_ready_fx")
				
				core:trigger_event("ScriptEventRitualofRuinPerformed")

				if Bloodgrounds:bloodground_is_human(bloodground) then
					Bloodgrounds:grant_ritual_of_ruin_rewards(bloodground)
				end

				Bloodgrounds:update_effect_bundles_for_bloodgrounds()

				Bloodgrounds:ui_update_ritual_state(bloodground)
			end

		end,
		true
	)
end

cm:add_post_first_tick_callback(init)