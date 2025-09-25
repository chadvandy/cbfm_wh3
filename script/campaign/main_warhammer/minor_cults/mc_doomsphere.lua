local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_34",
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
		--["wh2_main_sc_skv_skaven"] = true,
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
	chance_if_valid = 3,
	complete_on_removal = true,
	event_data = {event_chance_per_turn = 100, event_cooldown = 0, event_limit = 999, event_initial_delay = 0, force_trigger = true},
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

function minor_cult:creation_event(region_key, turn_number)
	local region = cm:get_region(region_key);
	local skaven_corruption = cm:get_corruption_value_in_region(region, "wh3_main_corruption_skaven");

	if skaven_corruption < 33 then
		local change = 33 - skaven_corruption;
		cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_skaven", change, "events");
	end
end

function minor_cult:custom_event(faction, region, cult_faction)
	local region_cqi = region:cqi();
	local faction_cqi = faction:command_queue_index();
	local skaven_corruption = cm:get_corruption_value_in_region(region, "wh3_main_corruption_skaven");

	if skaven_corruption >= 100 then
		local cult_cqi = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults"):command_queue_index();
		cm:remove_faction_foreign_slots_from_region(cult_cqi, region_cqi);
		self.saved_data.status = -1;
		
		under_empire_detonate_nuke(region, true, true, 1, "", faction:name());
		return true;
	elseif skaven_corruption == 0 then
		local cult_cqi = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults"):command_queue_index();
		cm:remove_faction_foreign_slots_from_region(cult_cqi, region_cqi);
		self.saved_data.status = -1;
	end
	return false;
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
						local skaven_corruption = cm:get_corruption_value_in_region(current_region, "wh3_main_corruption_skaven");

						if skaven_corruption > 33 then
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