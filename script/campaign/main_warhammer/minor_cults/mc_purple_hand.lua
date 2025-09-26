local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_32",
	intro_incident_key = "wh3_main_minor_cult_intro",
	effect_bundle = "wh3_main_minor_cult_assassins_hideout",
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
		--["wh3_main_sc_tze_tzeentch"] = true,
		["wh_dlc03_sc_bst_beastmen"] = true,
		["wh_dlc08_sc_nor_norsca"] = true,
		["wh_main_sc_chs_chaos"] = true
	},
	force_region = nil,
	valid_provinces = nil,
	valid_from_turn = 5,
	chance_if_valid = 5,
	complete_on_removal = true,
	event_data = {event_chance_per_turn = 100, event_cooldown = 0, event_limit = 999, event_initial_delay = 0, force_trigger = true},
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

local required_cult_spread = 9;
local worldwide_cult_chance = 50;

function minor_cult:creation_event(region_key, turn_number)
	local region = cm:get_region(region_key);
	cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_tzeentch", 10, "events");
end

function minor_cult:custom_event(faction, region, cult_faction)
	local spread_chance = cm:get_factions_bonus_value(faction, "purple_hand_cult_spread_chance");

	if cm:model():random_percent(spread_chance) then
		local cult_created, new_cult_region = self:spread_cult(faction, region, cult_faction);

		if cult_created == true then
			local faction_cqi = faction:command_queue_index();
			local amount_spread = cm:get_factions_bonus_value(faction, "purple_hand_cult_amount_spread");

			if amount_spread >= required_cult_spread then
				-- Enact the grand plan!
				self:remove_cult(cult_faction);
				self:spawn_hidden_cults(region, worldwide_cult_chance);
				local region_cqi = region:cqi();
				cm:trigger_incident_with_targets(faction_cqi, "wh3_main_minor_cult_purple_hand_cult_complete", 0, 0, 0, 0, region_cqi, 0);
				self.saved_data.status = -1;
			else
				-- Notify player of the new cult
				local region_cqi = region:cqi();
				
				if new_cult_region ~= nil then
					region_cqi = new_cult_region:cqi();
				end
				cm:trigger_dilemma_with_targets(faction_cqi, "wh3_main_minor_cult_purple_hand_cult_spread", 0, 0, 0, 0, region_cqi, 0);
				self:update_existing_cult(region, amount_spread);
			end
			return true;
		end
	end
	local amount_spread = cm:get_factions_bonus_value(faction, "purple_hand_cult_amount_spread");
	self:update_existing_cult(region, amount_spread);
	return false;
end

function minor_cult:custom_listeners()
	core:add_listener(
		"RegionTurnStart_"..self.key,
		"RegionTurnStart",
		true,
		function(context)
			local region = context:region();
			local removal_chance = cm:get_regions_bonus_value(region, "purple_hand_cult_removal_chance");

			if removal_chance > 0 and cm:model():random_percent(removal_chance) then
				local region_cqi = region:cqi();
				local cult_cqi = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults"):command_queue_index();
				cm:remove_faction_foreign_slots_from_region(cult_cqi, region_cqi);
			end
		end,
		true
	);
end

function minor_cult:update_existing_cult(region, amount_spread)
	local fsm = region:foreign_slot_manager_for_faction("wh3_main_rogue_minor_cults");

	if fsm:is_null_interface() == false then
		local slots = fsm:slots();
		
		for i = 0, slots:num_items() - 1 do
			local slot = slots:item_at(i);
			
			if slot:is_null_interface() == false and slot:has_building() == true then
				if slot:building():starts_with("wh3_main_minor_cult_purple_hand") then
					cm:foreign_slot_instantly_upgrade_building(slot, "wh3_main_minor_cult_purple_hand_"..amount_spread);
					cm:foreign_slot_set_reveal_to_faction(region:owning_faction(), fsm);
					break;
				end
			end
		end
	end
end

function minor_cult:spread_cult(faction, origin_region, cult_faction)
	local possible_regions = weighted_list:new();
	local region_list = faction:region_list(); -- Players regions

	for i = 0, region_list:num_items() - 1 do
		local possible_region = region_list:item_at(i);

		if MINOR_CULT_REGIONS[possible_region:name()] == nil and possible_region:is_abandoned() == false then
			possible_regions:add_item(possible_region, 1);
		end
	end

	if #possible_regions.items > 0 then
		local selected_region, index = possible_regions:weighted_select();
		cm:add_foreign_slot_set_to_region_for_faction(cult_faction:command_queue_index(), selected_region:cqi(), self.slot_key.."_extra");
		local slot_manager = selected_region:foreign_slot_manager_for_faction(cult_faction:name());
		cm:foreign_slot_set_reveal_to_faction(selected_region:owning_faction(), slot_manager);
		MINOR_CULT_REGIONS[selected_region:name()] = self.key.."_extra";
		return true, selected_region;
	end
	return false, nil;
end

function minor_cult:spawn_hidden_cults(origin_region, chance_per_region)
	local potential_factions = {
		"wh3_main_tze_oracles_of_tzeentch",
		"wh3_main_tze_sarthoraels_watchers",
		"wh3_dlc20_tze_apostles_of_change",
		"wh3_main_tze_all_seeing_eye",
		"wh3_dlc20_tze_the_sightless",
		"wh3_main_tze_flaming_scribes",
		"wh3_main_tze_broken_wheel",
	};
	local selected_faction = cm:model():world():faction_by_key("wh3_main_tze_sarthoraels_watchers");
	local selected = false;
	local is_dead = false;
	
	for i = 1, #potential_factions do
		local faction = cm:model():world():faction_by_key(potential_factions[i]);

		if faction:is_null_interface() == false and faction:is_human() == false and faction:is_dead() == false then
			-- Factions are ordered in priority order, so this is our first choice that meets all criteria
			selected_faction = faction;
			selected = true;
			break;
		end
	end

	if selected == false then
		-- Not found a faction yet, so allow dead factions (not ideal)
		for i = 1, #potential_factions do
			local faction = cm:model():world():faction_by_key(potential_factions[i]);

			if faction:is_null_interface() == false and faction:is_human() == false then
				selected_faction = faction;
				selected = true;
				is_dead = true;
				break;
			end
		end
	end

	local tze_cqi = selected_faction:command_queue_index();
	local tze_key = selected_faction:name();
	local region_list = cm:model():world():region_manager():region_list();

	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i);
		local region_cqi = region:cqi();

		if region:is_abandoned() == false and region_cqi ~= origin_region:cqi() and region:owning_faction():command_queue_index() ~= tze_cqi then
			if cm:model():random_percent(chance_per_region) then
				local fsm = region:foreign_slot_manager_for_faction(tze_key);

				if fsm:is_null_interface() == true then -- No previous Cult
					cm:add_foreign_slot_set_to_region_for_faction(tze_cqi, region_cqi, "wh3_main_slot_set_tze_cult");
				end
			end
		end
	end
	cm:apply_effect_bundle("wh3_main_minor_cult_purple_hand_success", tze_key, 100);

	if is_dead == true then
		-- Crude revival
		local army = "wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze";
		army = army..",wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze,wh3_dlc20_chs_inf_chosen_mtze";
		army = army..",wh3_main_tze_mon_soul_grinder_0,wh3_main_tze_mon_soul_grinder_0,wh3_main_tze_mon_soul_grinder_0";
		army = army..",wh3_main_tze_cav_chaos_knights_0,wh3_main_tze_cav_chaos_knights_0,wh3_main_tze_cav_chaos_knights_0";
		army = army..",wh3_main_tze_mon_lord_of_change_0,wh3_dlc20_chs_mon_warshrine_mtze,wh3_dlc24_tze_mon_mutalith_vortex_beast";

		cm:create_force(
			tze_key,
			army,
			"wh3_main_combi_region_fateweavers_crevasse",
			513,
			18,
			false,
			function(cqi)
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
				cm:add_agent_experience(cm:char_lookup_str(cqi), 40, true);
			end
		);
	end
end

function minor_cult:remove_cult(cult_faction)
	local region_list = cm:model():world():region_manager():region_list();

	for i = 0, region_list:num_items() - 1 do
		local possible_region = region_list:item_at(i);
		local region_key = possible_region:name();
		local region_cqi = possible_region:cqi();

		if MINOR_CULT_REGIONS[region_key] == self.key or MINOR_CULT_REGIONS[region_key] == self.key.."_extra" then
			cm:remove_faction_foreign_slots_from_region(cult_faction:command_queue_index(), region_cqi);
		end
	end
end

function minor_cult:removal_event(remover, region)
	local amount_spread = cm:get_factions_bonus_value(remover, "purple_hand_cult_amount_spread");

	if amount_spread >= 2 then
		cm:apply_effect_bundle("wh3_main_minor_cult_purple_hand_removed", remover:name(), 10);
	end
	self.saved_data.status = -1;
	return true;
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