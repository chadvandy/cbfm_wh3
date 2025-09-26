local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_36",
	intro_incident_key = "wh3_main_minor_cult_intro",
	effect_bundle = nil,
	valid_subcultures = {
		-- Good
		["wh2_main_sc_hef_high_elves"] = true,
		["wh2_main_sc_lzd_lizardmen"] = true,
		["wh3_main_sc_cth_cathay"] = true,
		["wh3_main_sc_ksl_kislev"] = true,
		["wh_dlc05_sc_wef_wood_elves"] = true,
		["wh_main_sc_brt_bretonnia"] = true,
		["wh_main_sc_dwf_dwarfs"] = true,
		["wh_main_sc_emp_empire"] = true,
		-- Neutral
		["wh2_dlc09_sc_tmb_tomb_kings"] = true,
		["wh2_dlc11_sc_cst_vampire_coast"] = true,
		["wh2_main_sc_def_dark_elves"] = true,
		["wh2_main_sc_skv_skaven"] = true,
		["wh3_main_sc_ogr_ogre_kingdoms"] = true,
		["wh_main_sc_grn_greenskins"] = true,
		["wh_main_sc_grn_savage_orcs"] = true,
		["wh_main_sc_vmp_vampire_counts"] = true,
		-- Chaos
		["wh3_dlc23_sc_chd_chaos_dwarfs"] = true,
		["wh3_main_sc_dae_daemons"] = true,
		["wh3_main_sc_kho_khorne"] = true,
		["wh3_main_sc_nur_nurgle"] = true,
		["wh3_main_sc_sla_slaanesh"] = true,
		["wh3_main_sc_tze_tzeentch"] = true,
		["wh_dlc03_sc_bst_beastmen"] = true,
		["wh_dlc08_sc_nor_norsca"] = true,
		["wh_main_sc_chs_chaos"] = true
	},
	force_region = nil,
	valid_provinces = nil,
	valid_from_turn = 15,
	chance_if_valid = 5,
	complete_on_removal = true,
	event_data = nil,
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

local last_razed_region_key = "";

function minor_cult:creation_event(region_key, turn_number)
	local region = cm:get_region(region_key);
	cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_chaos", 10, "events");
end

function minor_cult:custom_listeners()
	core:add_listener(
		"ScriptEventRazedRegionProvinceBonusValue_"..self.key,
		"ScriptEventRazedRegionProvinceBonusValue",
		true,
		function(context)
			local razing_faction = context:faction();
			local razed_region = context:region();
			self:show_region_razed_incident(razing_faction, razed_region);
		end,
		true
	);
	core:add_listener(
		"ScriptEventRazedRegionWorldwideBonusValue_"..self.key,
		"ScriptEventRazedRegionWorldwideBonusValue",
		true,
		function(context)
			local razing_faction = context:faction();
			local razed_region = context:region();
			self:show_region_razed_dilemma(razing_faction, razed_region);
		end,
		true
	);
	core:add_listener(
		"MinorCults_DilemmaChoiceMadeEvent_"..self.key,
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			local faction_key = context:faction():name();
			local dilemma = context:dilemma();
			local choice = context:choice();

			if dilemma == "wh3_main_minor_cult_chaos_portal" then
				if choice == 1 then
					-- Show the location, reveal the FOW
					local razed_region = nil;
					
					if last_razed_region_key ~= nil then
						razed_region = cm:get_region(last_razed_region_key);
					end

					if razed_region ~= nil and razed_region:is_null_interface() == false then
						local x, y, d, b, h = cm:get_camera_position();
						local settlement = razed_region:settlement();
						x = settlement:display_position_x();
						y = settlement:display_position_y();
						cm:make_region_visible_in_shroud(faction_key, last_razed_region_key);
						cm:set_camera_position(x, y, d, b, h);
					end
				elseif choice == 2 then
					-- Embrace the Chaos
					local portal_region = cm:get_region(self.saved_data.region_key);
					local portal_province = "";

					if portal_region ~= nil and portal_region:is_null_interface() == false then
						portal_province = portal_region:province_name();
					end

					local province_list = cm:model():world():province_list();
	
					for i = 0, province_list:num_items() - 1 do
						local current_province = province_list:item_at(i):key();

						if current_province ~= portal_province then
							cm:change_corruption_in_province_by(current_province, "wh3_main_corruption_chaos", 10, "events");
						end
					end
				elseif choice == 3 then
					-- No more events
					cm:set_saved_value("minor_cult_chaos_portal_events_off", true);
				end
			end
		end,
		true
	);
end

function minor_cult:show_region_razed_incident(razing_faction, razed_region)
	local faction_cqi = razing_faction:command_queue_index();
	local region_cqi = razed_region:cqi();
	last_razed_region_key = razed_region:name();
	cm:trigger_incident_with_targets(faction_cqi, "wh3_main_minor_cult_chaos_portal", 0, 0, 0, 0, region_cqi, 0);
end

function minor_cult:show_region_razed_dilemma(razing_faction, razed_region)
	if not cm:get_saved_value("minor_cult_chaos_portal_events_off") then
		local faction_cqi = razing_faction:command_queue_index();
		local region_cqi = razed_region:cqi();
		last_razed_region_key = razed_region:name();
		cm:trigger_dilemma_with_targets(faction_cqi, "wh3_main_minor_cult_chaos_portal", 0, 0, 0, 0, region_cqi, 0);
	end
end

function minor_cult:is_valid()
	local debug_validity = true;

	if debug_validity == true then
		out("MINOR CULT - VALIDITY - "..self.key);
	end

	local turn_number = cm:model():turn_number();
	if turn_number < self.valid_from_turn then
		if debug_validity == true then
			out("\tFAIL - VALID TURN - Current:"..turn_number.." / Valid:"..self.valid_from_turn);
		end
		return nil;
	end

	local valid_region_list = weighted_list:new();

	if self.force_region ~= nil then
		if not MINOR_CULT_REGIONS[self.force_region] then
			local current_region = cm:get_region(self.force_region);

			if current_region:is_null_interface() == false and current_region:is_abandoned() == false then
				local owner = current_region:owning_faction();

				if owner:is_null_interface() == false and owner:is_human() == true and owner:is_factions_turn() == true then
					local current_subculture = owner:subculture();

					if self.valid_subcultures[current_subculture] ~= nil then
						valid_region_list:add_item(current_region, 1);
					elseif debug_validity == true then
						out("\tFAIL - FORCED REGION SUBCULTURE - "..current_subculture);
					end
				elseif debug_validity == true then
					out("\tFAIL - FORCED REGION OWNER AI/NOT TURN/NULL");
				end
			elseif debug_validity == true then
				out("\tFAIL - FORCED REGION RAZED/NULL");
			end
		elseif debug_validity == true then
			out("\tFAIL - FORCED REGION FULL - "..MINOR_CULT_REGIONS[self.force_region]);
		end
	else
		local region_list = cm:model():world():region_manager():region_list();

		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i);
			
			if current_region:is_null_interface() == false and current_region:is_abandoned() == false then
				local owner = current_region:owning_faction();

				if owner:is_null_interface() == false and owner:is_human() == true and owner:is_factions_turn() == true then
					if self.valid_subcultures[owner:subculture()] ~= nil then
						local valid = true;

						if self.valid_provinces ~= nil then
							local province_key = current_region:province_name();
							if self.valid_provinces[province_key] == nil then
								valid = false;
							end
						end

						if MINOR_CULT_REGIONS[current_region:name()] then
							valid = false;
						end

						-- CUSTOM REQUIREMENTS START
						local region_count = current_region:province():regions():num_items();

						if region_count < 3 then
							valid = false;
						end
						-- CUSTOM REQUIREMENTS END

						if valid == true then
							valid_region_list:add_item(current_region, 1);
						end
					end
				end
			end
		end
	end

	if #valid_region_list.items == 0 then
		if debug_validity == true then
			out("\tFAIL - NO REGIONS");
		end
		return nil;
	end

	if cm:model():random_percent(self.chance_if_valid) == false then
		if debug_validity == true then
			out("\tFAIL - CHANCE - Required:"..self.chance_if_valid);
		end
		return nil;
	end
	
	local region, index = valid_region_list:weighted_select();
	return region:name();
end

return minor_cult;