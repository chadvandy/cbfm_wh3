local function init()
	core:remove_listener("UnderdeepForeignSlotBuildingCompleteEvent")
	
	core:add_listener(
		"UnderdeepForeignSlotBuildingCompleteEvent",
		"ForeignSlotBuildingCompleteEvent",
		function(context)
			return context:slot_manager():faction():culture() == "wh_main_dwf_dwarfs"
		end,
		function(context)
			local key = context:building();
			local slot_manager = context:slot_manager();
			local region = slot_manager:region();
			local faction = slot_manager:faction();
			local slot_list = slot_manager:slots();
			local climate = region:settlement():get_climate();

			if key == "wh3_main_underdeep_dwf_main_minor_2" then
				cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_buildings_positive", 1);
				if climate == "climate_mountain" then
					underdeep_remove_slot_blockers(slot_list, {3});
				end
			elseif key == "wh3_main_underdeep_dwf_main_major_2" then
				cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_buildings_positive", 1);
				if climate == "climate_mountain" then
					underdeep_remove_slot_blockers(slot_list, {1, 4});
				end
			elseif key == "wh3_main_underdeep_dwf_main_minor_3" or key == "wh3_main_underdeep_dwf_main_major_3" then
				cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_buildings_positive", 1);
				if climate == "climate_mountain" then
					underdeep_remove_slot_blockers(slot_list, {1, 2, 3, 4, 5});
				end
			end

			if key == "wh3_main_underdeep_dwf_grudges_2_a" then
				common.set_context_value("cycle_grudge_target", 0);
				common.set_context_value("cycle_grudge_value", -1);
				grudge_cycle.delayed_factions[faction:name()] = true;

				for i = 0, 5 do
					cm:remove_effect_bundle("wh3_dlc25_grudge_cycle_"..i, faction:name());
				end
				cm:apply_effect_bundle("wh3_dlc25_grudge_cycle_0", faction:name(), 0);
			end

			-- CBFM: Adding a check here to make sure the faction is human
			if key == "wh3_main_underdeep_dwf_main_karak_eight_peaks_3" and faction:is_human() then
				cm:trigger_dilemma(faction:name(), "wh3_main_dwf_move_capital_eight_peaks");
			end
			-- end CBFM edits
		end,
		true
	)
end

cm:add_post_first_tick_callback(init)