Bloodgrounds = {
	debug_enabled = false,
	--GENERAL CONSTANTS -- these should never need to change
	herdstone_settlement_options = { --- which settlement options in data will create a herdstone
		["717853131"] = true,
		["1102425063"] = true,
		["189700220"] = true,
	},
	razing_settlement_options = { --- which settlement options in data will raze a settlement, and the amount of AP they will replenish
		["1172"] = 0.2, -- full raze
		["411"] = 0.4 -- raze and retreat
	},
	beastmen_sc_key = "wh_dlc03_sc_bst_beastmen",
	beastmen_factions = {
		"wh2_dlc17_bst_malagor",
		"wh2_dlc17_bst_taurox",
		"wh_dlc03_bst_beastmen",
		"wh_dlc05_bst_morghur_herd"
	},



	---RESOURCE CONSTANTS -- constants related to the Devastation pseudo-resource and Ruination pooled resource
	ruination_key = "bst_ruination",
	ruination_factor = "wh2_dlc17_bst_ruination_gained_settlement",
	ruination_incident = "wh2_dlc17_incident_bst_ritual_of_ruin_performed",
	herdstone_resource_key = "bst_herdstone_shard",
	herdstone_factor_key = "wh2_dlc17_bst_herdstone_shard_gain_abandon_settlement",

	settlement_razed_multiplier = 2, --- exponent applied to settlement level for devastation gained from razing
	battle_victory_value = 2, --- flat Devastation gain from battle victories

	ritual_of_ruin_threshold = 10,
	moon_multipliers = { --- bonus Ruination you get from performing the ritual in particular Moon states. Dummy variable in DB needs changing to match.
		full_moon = 1.1,
		lunar_eclipse = 1.2,
		solar_eclipse = 1.3
	},


	----BLOODGROUND GENERATION CONSTANTS --- 
	search_distance_initial = 1500, -- maximum squared distance between herdstone and adjacent region on first loop
	region_target = 5, --- if we don't have a bloodground with > this number of regions on the first loop of adjacent regions, we try again with max_distance*number of loops
	max_loops = 3, --- number of loops before the script gives up trying to find more regions.
	use_double_adjacency = true, -- if true, check each adjacent region's own adjacent regions. 
	force_include_province = true, -- if true, will try to include everything in the target region's province even it's not adjacent. Still obeys range rules

	---UI AND VFX CONSTANTS ---
	bloodground_vfx_key = "",
	defiled_bloodground_vfx_key = "wh2_dlc17_bloodground_defilement",
	ritual_ready_vfx_key = "wh2_dlc17_ritual_of_ruin_ready",
	occupation_button = "occupy_button",
	colonise_button = "subjugation_button",
	raze_settlement_vfx = "raze_settlement",
	bloodgrounds_uic_name = "bloodgrounds",
	bloodgrounds_ritual_button_uic_name = "herdstone_ritual_button",
	ritual_script_trigger_prefix = "ritual_of_ruin_",

	----BLOODGROUNDS BUILDINGS AND BUNDLES
	bloodground_effect_bundle_key = "wh2_dlc17_effect_bundle_bloodgrounds",
	defiled_bloodground_effect_bundle_key = "wh2_dlc17_effect_bundle_defiled_bloodgrounds",

	bloodgrounds_bundles_to_buildings = { --- make sure any bloodground-scoped effects match up between the building effects and the effect bundles
		wh2_dlc17_bundle_bst_bloodground_building_spells = {
			"wh2_dlc17_bst_special_secondary_spell",
			"wh2_dlc17_bst_special_secondary_spell_2",
			"wh2_dlc17_bst_special_secondary_spell_3"},
		wh2_dlc17_bundle_bst_bloodground_building_plagues = {
			"wh2_dlc17_bst_special_secondary_attrition",
			"wh2_dlc17_bst_special_secondary_attrition_2",
			"wh2_dlc17_bst_special_secondary_attrition_3"},
		wh2_dlc17_bundle_bst_bloodground_building_sieges= {"wh2_dlc17_bst_special_secondary_resistances"},
		wh2_dlc17_bundle_bst_bloodground_building_sieges_2=   {"wh2_dlc17_bst_special_secondary_resistances_2"},
		wh2_dlc17_bundle_bst_bloodground_building_sieges_3 = {"wh2_dlc17_bst_special_secondary_resistances_3"},
	},

	bloodgrounds_vision_bundle_key = "wh2_dlc17_bundle_bst_bloodground_building_spells",
	bloodgrounds_plague_bundle_key = "wh2_dlc17_bundle_bst_bloodground_building_plagues",
	bloodgrounds_plague_spawn_chance = 2, -- percent chance per region per effect update to spawn a plague
	bloodgrounds_plague_key = "wh2_dlc17_plague_beastmen"
}

Bloodgrounds.active_bloodgrounds = {

}


--------------------
-----FUNCTIONS------
--------------------
function Bloodgrounds:setup()
	if self.debug_enabled then
		self:output_bloodgrounds_status()
	end

	self:preview_ui_listeners()
	self:setup_post_battle_listener()
	self:setup_herdstone_listeners()
	self:setup_ritual_of_ruin_listener()
	self:restore_bloodground_ui()

	if cm:is_new_game() then
		for i =1, #self.beastmen_factions do
			self:grant_herdstone_shards(self.beastmen_factions[i], 1)
		end
	end
end

function Bloodgrounds:setup_post_battle_listener()
	core:add_listener(
		"CharacterCompletedBattleBloodgrounds",
		"CharacterCompletedBattle",
		function(context)

			if self.occupation_options_are_locked then
				uim:override(self.occupation_button):unlock();
				self.occupation_options_are_locked = false
			end

			-- make sure character isn't at sea or in a non-region
			if not context:character():has_region() then
				return false
			end

			local beastmen_won, were_attacker = self:did_beastmen_win(context:pending_battle())
			return beastmen_won

		end,
		function(context)
			local beastmen_won, were_attacker = self:did_beastmen_win(context:pending_battle())

			local bloodground = self:is_bloodground_region(context:character():region():name())

			if context:pending_battle():has_contested_garrison() and were_attacker then
				self.stored_settlement_level = context:pending_battle():contested_garrison():settlement_interface():primary_slot():building():building_level()
			end

			if bloodground then
				if were_attacker and context:character():faction():is_human() then
					uim:override(self.occupation_button):lock();
					self.occupation_options_are_locked = true
				end

				self:modify_devastation(bloodground, self.battle_victory_value)
				local settlement_level = self:get_stored_settlement_level()
				if settlement_level then
					self:modify_devastation(bloodground, self:get_settlement_devastation_value(settlement_level, false))
				end
			end
		end,
		true
	)
end

function Bloodgrounds:setup_herdstone_listeners()
	core:add_listener(
		"CharacterPerformsSettlementOccupationDecisionHerdstone",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			if self.occupation_options_are_locked then
				uim:override(self.occupation_button):unlock(true);
				uim:override(self.colonise_button):unlock(true);
				self.occupation_options_are_locked = false
			end
			local decision = context:occupation_decision()
			return self.herdstone_settlement_options[decision] or self.razing_settlement_options[decision]
		end,
		function(context)
			local decision = context:occupation_decision()
			local region = context:garrison_residence():region()
			local region_key = region:name()
			local bloodground = self:is_bloodground_region(region_key)

			if self.herdstone_settlement_options[decision] then
				if not bloodground then
					self:create_bloodground(region)
				else
					self:out("# Herdstone built in existing Bloodground, not making a new one")
				end
			else
				if bloodground and bloodground.ritual_completed then
					self:apply_vfx(region_key, self.defiled_bloodground_vfx_key)
				end

				local character_cqi = context:character():command_queue_index()
				cm:replenish_action_points("character_cqi:"..character_cqi, self.razing_settlement_options[decision])
			end

			self:update_effect_bundles_for_bloodgrounds()
	
		end,
		true
	)

	core:add_listener(
		"RegionFactionChangeEventBeastmen",
		"RegionFactionChangeEvent",
		function(context)
			return context:previous_faction():subculture() == self.beastmen_sc_key
		end,
		function(context)
			local region = context:region()
			local region_key = region:name()
			local display_chain = region:settlement():display_primary_building_chain()

			local bloodground = self.active_bloodgrounds[region_key] 

			if bloodground then
				local original_display_chain = bloodground.settlement_display_details

				if not bloodground.ritual_completed or not self:bloodground_is_human(bloodground) then
					local previous_faction_key = context:previous_faction():name()
    
    ---RGP: checking a persistent flag regarding a ritual was enacted in this region prior to the 
    ---     last change in ownership. If so, do not grant a herdstone shard (the player already received
    ---     their shard back for completing the ritual.
    
                    if not bloodground.ritual_already_completed then
					Bloodgrounds:grant_herdstone_shards(previous_faction_key, 1)
                    bloodground.ritual_already_completed = false
    
				end

				if context:region():owning_faction():subculture() ~= self.beastmen_sc_key then
					cm:override_building_chain_display(display_chain, original_display_chain, region_key);
					self:remove_bloodground(region_key)
				else
					self:update_effect_bundles_for_bloodgrounds()
				end
			end
		end,
		true
	)

	core:add_listener(
		"CharacterCapturedSettlementUnopposedBloodgrounds",
		"CharacterCapturedSettlementUnopposed",
		function(context)
			local region_key = context:garrison_residence():region():name()
			local character_is_human = context:character():faction():is_human()
			
			if self.occupation_options_are_locked then
				uim:override(self.occupation_button):unlock(true)
				uim:override(self.colonise_button):unlock(true)
				self.occupation_options_are_locked = false
			end
		
			return self:is_bloodground_region(region_key) and character_is_human
		end,
		function(context)
			local region_key = context:garrison_residence():region():name()
			local bloodground = self:is_bloodground_region(region_key)
			local character_is_beastmen = context:character():faction():subculture() == self.beastmen_sc_key
			local region_is_ruin = context:garrison_residence():region():is_abandoned()

			if character_is_beastmen then
				uim:override(self.occupation_button):lock(true)
				uim:override(self.colonise_button):lock(true)
				self.occupation_options_are_locked = true

			elseif bloodground.ritual_completed and region_is_ruin then 
				uim:override(self.colonise_button):lock(true)
				self.occupation_options_are_locked = true
			end
			
		end,
		true
	)

	core:add_listener(
		"BuildingCompletedBeastmen",
		"BuildingCompleted",
		function(context)
			return context:garrison_residence():faction():subculture() == self.beastmen_sc_key
		end,
		function(context)
			self:update_effect_bundles_for_bloodgrounds()
		end,
		true
	)


end


function Bloodgrounds:setup_ritual_of_ruin_listener()
	core:add_listener(
		"LClickUpRitualOfRuin",
		"ComponentLClickUp",
		function(context)
			return context.string == self.bloodgrounds_ritual_button_uic_name
		end,
		function(context)
			
			local region_key = UIComponent(context.component):GetProperty("id")

			local bloodground = self:is_bloodground_region(region_key)

			if bloodground.ritual_unlocked and not bloodground.ritual_completed then
				self:create_confirmation_dialogue(region_key)
			end
		end,
		true
	);

	core:add_listener(
		"UITriggerRitualOfRuin",
		"UITrigger",
		function(context)
			return string.find(context:trigger(), self.ritual_script_trigger_prefix)
		end,
		function(context)
			local region_key = string.gsub(context:trigger(), self.ritual_script_trigger_prefix, "")
			local bloodground = self:is_bloodground_region(region_key)

			if bloodground.ritual_unlocked and not bloodground.ritual_completed then
				self:out("Performing Ritual of Ruin!")
				bloodground.ritual_completed = true
				self:apply_vfx(region_key, self.defiled_bloodground_vfx_key)

				cm:remove_scripted_composite_scene(region_key.."_ritual_ready_fx")
				
				core:trigger_event("ScriptEventRitualofRuinPerformed")

				if self:bloodground_is_human(bloodground) then
					self:grant_ritual_of_ruin_rewards(bloodground)
				end

				self:update_effect_bundles_for_bloodgrounds()

				self:ui_update_ritual_state(bloodground)
			end

		end,
		true
	);

	core:add_listener(
		"ScriptEventWorldStartRoundUpdateBloodgrounds",
		"WorldStartRound",
		true,
		function(context)
			self:update_effect_bundles_for_bloodgrounds()
		end,
		true
	);
end

function Bloodgrounds:restore_bloodground_ui()
	for bloodground_key, bloodground in pairs(self.active_bloodgrounds) do
		for region_key,value in pairs(bloodground.region_list) do
			--convert any saved data that was using the old boolean system so the UI doesn't explode
			if is_boolean(value) then
				local settlement_level = cm:get_region(region_key):settlement():primary_slot():building():building_level()
				bloodground.region_list[region_key] = self:get_settlement_devastation_value(settlement_level, true)
			end
		end
		self:interface_function("AddActiveBloodground", bloodground)
	end
end

function Bloodgrounds:create_bloodground(region, is_preview)
	local bloodground_key = region:name()
	local faction = region:owning_faction()

	self:out("#######Generating potential bloodground around: "..bloodground_key)
	local temp_region_list = self:find_regions_in_range(region, region:adjacent_region_list(), self.search_distance_initial, self.region_target, self.max_loops, self.use_double_adjacency, self.force_include_province)

	if not is_preview then
		---VFX and settlement display overrides
		local primary_chain = region:settlement():primary_building_chain()
		local display_chain = region:settlement():display_primary_building_chain()
		cm:override_building_chain_display(display_chain, primary_chain, bloodground_key);
		cm:add_scripted_composite_scene_to_settlement(
			"settlement_razed",
			self.raze_settlement_vfx,
			region,
			0,
			0,
			true,
			true,
			false
		)


		for region_key,v in pairs(temp_region_list) do
			local region_bloodground = self:is_bloodground_region(region_key)
			if region_bloodground then
				region_bloodground.region_list[region_key] = nil
			end
		end

		self.active_bloodgrounds[bloodground_key] = {
			herdstone_region = bloodground_key,
			region_list = temp_region_list,
			devastation = 0,
			ritual_unlocked = false,
			ritual_completed = false,
			settlement_display_details = display_chain
		}
		

		self:update_effect_bundles_for_bloodgrounds()
		self:out("# Converting into actual bloodground")
		self:create_debug_ui(bloodground_key)
		core:trigger_event("ScriptEventBloodgroundCreated", faction)

		self:interface_function("AddActiveBloodground", self.active_bloodgrounds[bloodground_key])

		local settlement_level = self:get_stored_settlement_level()

		if settlement_level then
			self:modify_devastation(self.active_bloodgrounds[bloodground_key], self:get_settlement_devastation_value(settlement_level, true))
		end

		--fire event for herdstone created
		core:trigger_event("ScriptEventBloodgroundsHerdstoneCreated");

	elseif self:is_bloodground_region(bloodground_key) then
		self:interface_function("SetPreviewRegions", self:is_bloodground_region(bloodground_key).region_list)
	else
		self:interface_function("SetPreviewRegions", temp_region_list)
	end
end

function Bloodgrounds:find_regions_in_range(starting_region, region_list, starting_range, target_regions, num_loops, use_double_adjacency, force_include_province)
	local starting_region_x, starting_region_y = starting_region:settlement():logical_position_x(), starting_region:settlement():logical_position_y()
	local starting_region_key = starting_region:name()
	local regions_in_range = {}
	local settlement_level = starting_region:settlement():primary_slot():building():building_level()
	regions_in_range[starting_region_key] = self:get_settlement_devastation_value(settlement_level, true)
	local region_count = 1
	
	for i = 1, num_loops do
		local max_distance = starting_range*i
		self:out("Using max distance threshold of "..tostring(max_distance))

		if force_include_province then
			local regions_to_add = GeneratedConstants:get_other_regions_in_province(starting_region_key)
			for i, region_to_add in ipairs(regions_to_add) do
				if self:is_region_valid_for_bloodground(region_to_add, regions_in_range, starting_region_x, starting_region_y, max_distance, "same province") then

					local settlement_level = cm:get_region(region_to_add):settlement():primary_slot():building():building_level()
					regions_in_range[region_to_add] = self:get_settlement_devastation_value(settlement_level, true)
					region_count = region_count + 1
				end	
			end	
		end

		for i = 0, region_list:num_items() - 1 do 
			local region_to_add = region_list:item_at(i)
			local region_to_add_key = region_to_add:name()

			if self:is_region_valid_for_bloodground(region_to_add_key, regions_in_range, starting_region_x, starting_region_y, max_distance, "adjacent") then
				local settlement_level = region_to_add:settlement():primary_slot():building():building_level()
				regions_in_range[region_to_add_key] = self:get_settlement_devastation_value(settlement_level, true)
				region_count = region_count + 1
			end

			if use_double_adjacency then
				local region_list_2 = region_to_add:adjacent_region_list()
				for i = 0, region_list_2:num_items() - 1 do 
					local region_to_add = region_list_2:item_at(i)
					local region_to_add_key = region_to_add:name()
			
					if self:is_region_valid_for_bloodground(region_to_add_key, regions_in_range, starting_region_x, starting_region_y, max_distance, "double-adjacent") then
						local settlement_level = region_to_add:settlement():primary_slot():building():building_level()
						regions_in_range[region_to_add_key] = self:get_settlement_devastation_value(settlement_level, true)
						region_count = region_count + 1
					end
				end			
			end
		end

		if region_count >= target_regions then
			self:out("## Our Bloodground is big enough, stopping the search early")
			return regions_in_range
		end
	end

	self:out("## Couldn't hit target region count within max loops")
	return regions_in_range
end

function Bloodgrounds:is_region_valid_for_bloodground(region_key, excluded_regions, start_x, start_y, max_distance, inclusion_type)
	local region_interface = cm:get_region(region_key)
	if not excluded_regions[region_key] and not self.active_bloodgrounds[region_key] and not (self:region_is_devastated(region_interface)) then
		local region_distance = self:get_region_distance_from_position(start_x, start_y, region_interface)
		if region_distance <= max_distance then
			self:out("###Region "..region_key.." is in "..inclusion_type.." and within range ("..tostring(region_distance)..")")
			return true
		end
	end	
end


function Bloodgrounds:region_is_devastated(region_interface)
	local bloodground = self:is_bloodground_region(region_interface:name())
	if bloodground and bloodground.ritual_completed and region_interface:is_abandoned() then
		return true
	end

	return false
end


function Bloodgrounds:get_settlement_devastation_value(settlement_level, include_battle_bonus)
	local settlement_value = settlement_level * self.settlement_razed_multiplier
	if include_battle_bonus and settlement_value > 0 then
		settlement_value = settlement_value + self.battle_victory_value
	end
	
	return settlement_value
end

function Bloodgrounds:get_region_distance_from_position(start_x, start_y, region_interface)
	local region_to_add_x, region_to_add_y = region_interface:settlement():logical_position_x(), region_interface:settlement():logical_position_y()
	return distance_squared(region_to_add_x, region_to_add_y, start_x, start_y)
end

    ---RGP: Establishing a second flag that will prevent a player from receiving herdstone shards from
    ---     settlements where the ritual has already been completed, becuase those herdstone shards have
    ---     already been returned.

function Bloodgrounds:remove_bloodground(herdstone_region_key)
	local bloodground = self:is_bloodground_region(herdstone_region_key)

	cm:remove_scripted_composite_scene(herdstone_region_key.."_ritual_ready_fx")

	self:interface_function("RemoveActiveBloodground", bloodground.herdstone_region)

	bloodground.ritual_completed = false
    bloodground.ritual_already_completed = true 
	bloodground.pending_removal = true

	self:update_effect_bundles_for_bloodgrounds()

	self.active_bloodgrounds[herdstone_region_key] = nil
end


function Bloodgrounds:modify_devastation(bloodground, amount)
	if bloodground.ritual_completed then
		return
	else
		self:out("Adding "..amount.." devastation to Bloodground "..bloodground.herdstone_region)
		bloodground.devastation = bloodground.devastation + amount
		self:out("New total is "..bloodground.devastation)

		self:ui_update_ritual_state(bloodground)
	end

	if bloodground.devastation >= self.ritual_of_ruin_threshold then

		if self:bloodground_is_human(bloodground) then
			self:unlock_ritual_of_ruin(bloodground)
		else
			bloodground.ritual_available = true
			bloodground.ritual_completed = true
			CampaignUI.TriggerCampaignScriptEvent(0, self.ritual_script_trigger_prefix..bloodground.herdstone_region)
		end

	end
end

function Bloodgrounds:bloodground_is_human(bloodground)
	return cm:get_region(bloodground.herdstone_region):owning_faction():is_human()
end

function Bloodgrounds:unlock_ritual_of_ruin(bloodground)
	if bloodground.ritual_unlocked then return end

	bloodground.ritual_unlocked = true
	self:out("Ritual of ruin unlocked!")
	local herdstone_key = bloodground.herdstone_region
	local region_interface = cm:get_region(herdstone_key)

	if not region_interface then return end

	cm:show_message_event_located(
		region_interface:owning_faction():name(),
		"event_feed_strings_text_wh2_dlc17_event_feed_string_bst_ritual_of_ruin_available_title",
		"regions_onscreen_"..herdstone_key,
		"event_feed_strings_text_wh2_dlc17_event_feed_string_bst_ritual_of_ruin_available_secondary_detail",
		region_interface:settlement():logical_position_x(),
		region_interface:settlement():logical_position_y(),
		true,
		1803
	)

	cm:add_scripted_composite_scene_to_settlement(herdstone_key .. "_ritual_ready_fx", self.ritual_ready_vfx_key, region_interface, 1, 1, false, true, false)

	core:trigger_event("ScriptEventRitualofRuinUnlocked")
	self:ui_update_ritual_state(bloodground)
end

function Bloodgrounds:update_effect_bundles_for_bloodgrounds()
	for k, bloodground in pairs(self.active_bloodgrounds) do
		local vfx
		local bundles_to_apply = {}
		local bundles_to_remove = {}
		local game_interface = cm:get_game_interface();
		local herdstone_region_interface = cm:get_region(bloodground.herdstone_region)
		local bloodground_owner = herdstone_region_interface:owning_faction()
		local bloodground_owner_key = bloodground_owner:name()

		self:ui_update_ritual_state(bloodground)

		if bloodground.pending_removal then
			table.insert(bundles_to_remove, self.bloodground_effect_bundle_key)
		else
			table.insert(bundles_to_apply, self.bloodground_effect_bundle_key)
		end

	
		if bloodground.ritual_completed then
			vfx = self.defiled_bloodground_vfx_key
			table.insert(bundles_to_apply, self.defiled_bloodground_effect_bundle_key)
		else
			vfx = self.bloodground_vfx_key
			table.insert(bundles_to_remove, self.defiled_bloodground_effect_bundle_key)
		end

		for bundle_key, buildings  in pairs(self.bloodgrounds_bundles_to_buildings) do
			local bundle_found = false

			for i=1, #buildings do
				if herdstone_region_interface:building_exists(buildings[i]) then
					table.insert(bundles_to_apply, bundle_key)
					bundle_found = true
					break
				end
			end

			if not bundle_found then
				table.insert(bundles_to_remove, bundle_key)
			end
		end

		for k,v in pairs(bloodground.region_list) do
			local region = k
			local region_interface = cm:get_region(region)
			local settlement_level = cm:get_region(k):settlement():primary_slot():building():building_level()
			bloodground.region_list[k] = self:get_settlement_devastation_value(settlement_level, true)

			for i = 1, #bundles_to_apply do
				local bundle_key = bundles_to_apply[i]
				if bundle_key == self.defiled_bloodground_effect_bundle_key then
					if region ~= bloodground.herdstone_region and region_interface:is_abandoned() then
						cm:cai_disable_targeting_against_settlement("settlement:"..region)
						game_interface:apply_effect_bundle_to_region(bundle_key,region,-1)
					end

				elseif bundle_key == self.bloodgrounds_vision_bundle_key then
					cm:make_region_visible_in_shroud(bloodground_owner_key, region)
					game_interface:apply_effect_bundle_to_region(bundle_key,region,-1)
				
				elseif bundle_key == self.bloodgrounds_plague_bundle_key then
					game_interface:apply_effect_bundle_to_region(bundle_key,region,-1)

					if cm:random_number() <= self.bloodgrounds_plague_spawn_chance then
						cm:spawn_plague_at_region(bloodground_owner, region_interface, self.bloodgrounds_plague_key)
					end

				elseif bundle_key == self.bloodground_effect_bundle_key then
					if not region_interface:has_effect_bundle(self.defiled_bloodground_effect_bundle_key) then
						game_interface:apply_effect_bundle_to_region(bundle_key,region,-1)
					elseif region_interface:has_effect_bundle(bundle_key) then
						game_interface:remove_effect_bundle_from_region(bundle_key,region)
					end

				else
					game_interface:apply_effect_bundle_to_region(bundle_key,region,-1)
				end
			end

			for i = 1, #bundles_to_remove do
				local bundle_key = bundles_to_remove[i]
				if region_interface:has_effect_bundle(bundle_key) then
					game_interface:remove_effect_bundle_from_region(bundle_key,region)
				end

				if bundle_key == self.defiled_bloodground_effect_bundle_key then
					cm:cai_enable_targeting_against_settlement("settlement:"..region)
					self:apply_vfx(region)
				end
			end
		end
		if not bloodground.pending_removal then
			self:interface_function("RemoveActiveBloodground", bloodground.herdstone_region)
			self:interface_function("AddActiveBloodground", bloodground)
		end
	end
end

function Bloodgrounds:grant_ritual_of_ruin_rewards(bloodground)
	local bloodground_owner = cm:get_region(bloodground.herdstone_region):owning_faction()
	local bloodground_owner_key = bloodground_owner:name()
	local moon_multiplier = 1
	local ruination_incident_suffix = ""

	if beastmen_moon.moon_phase == beastmen_moon.moon_max_phase then
		if beastmen_moon.selected_moon_type == "preparations_full_moon" then
			moon_multiplier = self.moon_multipliers.full_moon
			ruination_incident_suffix = "_full_moon"
		elseif beastmen_moon.selected_moon_type == "lunar_eclipse" then
			moon_multiplier = self.moon_multipliers.lunar_eclipse
			ruination_incident_suffix = "_lunar_eclipse"
		elseif beastmen_moon.selected_moon_type == "solar_eclipse" then
			moon_multiplier = self.moon_multipliers.solar_eclipse
			ruination_incident_suffix = "_solar_eclipse"
		end
	end

	local marks_to_gain = math.floor(bloodground.devastation*moon_multiplier + 0.5)

	local payload_string = "payload{faction_pooled_resource_transaction{resource "..self.ruination_key..";factor "..self.ruination_factor..";amount "..tostring(marks_to_gain)..";context absolute;}}"
	
	cm:trigger_custom_incident(bloodground_owner_key,self.ruination_incident..ruination_incident_suffix,true,payload_string)

	self:grant_herdstone_shards(bloodground_owner_key, 1)
	
	Ruination:update_beastmen_progress(bloodground_owner_key, marks_to_gain)
end

---if no vfx key provided, will just clear existing fx
function Bloodgrounds:apply_vfx(region_key, opt_vfx_key, opt_is_preview)
	cm:remove_scripted_composite_scene(region_key.."_bloodground_fx")

	if opt_vfx_key then
		cm:add_scripted_composite_scene_to_settlement(region_key.."_bloodground_fx", opt_vfx_key, cm:get_region(region_key), 1, 1, true, true, true)
		if opt_is_preview then
			cm:callback(
				function()
					self:apply_vfx(region_key)
				end, 
				3
			)
		end
	end
end



function Bloodgrounds:create_confirmation_dialogue(bloodground_key)

	local ui_root = core:get_ui_root()
	local uic_ritual_of_ruin_confirm = UIComponent(ui_root:CreateComponent("ritual_of_ruin_confirmation", "UI/Common UI/dialogue_box"));
	local uic_dialogue_text = find_uicomponent(ui_root, "ritual_of_ruin_confirmation", "DY_text")

	local dialogue_string = common.get_localised_string("campaign_localised_strings_string_ritual_of_ruin_confirm")

	uic_dialogue_text:SetStateText(dialogue_string, "campaign_localised_strings_string_ritual_of_ruin_confirm")
	
	uic_ritual_of_ruin_confirm:PropagatePriority(99)
	uic_ritual_of_ruin_confirm:LockPriority()

	core:add_listener(
		"LClickUpRitualOfRuinConfirmed",
		"ComponentLClickUp",
		function(context)
			return context.string == "button_tick" or context.string == "button_cancel"
		end,
		function(context)
			if context.string == "button_tick" then
				CampaignUI.TriggerCampaignScriptEvent(0, self.ritual_script_trigger_prefix..bloodground_key);
				---can't fire the ritual directly from here because it will cause desyncs - instead fire a Uitrigger that contains the region key
			end

			uic_ritual_of_ruin_confirm = find_uicomponent(ui_root, "ritual_of_ruin_confirmation")
			
			if uic_ritual_of_ruin_confirm then
				uic_ritual_of_ruin_confirm:UnLockPriority()
				uic_ritual_of_ruin_confirm:Destroy()
			end
		end,
		false
	);
	
end

---- Old debug UI, can be reactivated if needed
function Bloodgrounds:create_debug_ui(region_name)

	if not self.debug_enabled then return end
	
	local settlement_bar = find_uicomponent("settlement_panel")

	local bloodground = self:is_bloodground_region(region_name)

	if find_uicomponent("settlement_panel", region_name) then
		return
	end

	local dragon_icon = find_uicomponent(core:get_ui_root(), "dragon_taming_icon", "timer")

	local devastation_counter = UIComponent(dragon_icon:CopyComponent(region_name))
	common.set_context_value("dragon_taming_turns_until_next", bloodground.devastation);
	
	local devastation_counter_address = devastation_counter:Address()

	if settlement_bar then
		settlement_bar:Adopt(devastation_counter_address)
		devastation_counter:SetDockingPoint(1)
		devastation_counter:PropagateVisibility(true)
		devastation_counter:SetDockOffset(0, -40)
		devastation_counter:SetInteractive(true)
		if bloodground.devastation >= self.ritual_of_ruin_threshold then
			devastation_counter:ShaderTechniqueSet("red_pulse_t0", true, true)
		end
	end	
end

function Bloodgrounds:grant_herdstone_shards(faction_key, amount)
	cm:faction_add_pooled_resource(faction_key, self.herdstone_resource_key, self.herdstone_factor_key, amount)
end

function Bloodgrounds:get_stored_settlement_level()
	local return_val = self.stored_settlement_level
	self.stored_settlement_level = nil
	return return_val or false
end

function Bloodgrounds:preview_ui_listeners()
	core:add_listener(
		"SettlementSelectedBloodgrounds",
		"SettlementSelected",
		function()
			return cm:get_local_faction(true):subculture() == self.beastmen_sc_key
		end,
		function(context)
			local region = context:garrison_residence():region()

			self:create_bloodground(region, true)

		end,
		true
	);	
end

----------------------------
-----HELPERS & QUERIES------
----------------------------

function Bloodgrounds:ui_update_ritual_state(bloodground)
	self:interface_function("UpdateRitualOfRuinState", bloodground.herdstone_region, bloodground.ritual_unlocked, bloodground.ritual_completed, bloodground.devastation)
end

function Bloodgrounds:did_beastmen_win(pending_battle)
	if pending_battle:is_null_interface() then
		script_error("Function Bloodgrounds:did_beastmen_win() called without valid pending battle interface")
		return false, false
	end

	local beastmen_won = false
	local were_attacker = false
	local winner_subculture_key = ""

	if pending_battle:has_attacker() then
		local attacker_subculture_key = pending_battle:attacker():faction():subculture()
		if pending_battle:attacker():won_battle() then
			winner_subculture_key = attacker_subculture_key
			were_attacker = true
		end
	end

	if pending_battle:has_defender() then
		local defender_subculture_key = pending_battle:defender():faction():subculture()
		if pending_battle:defender():won_battle() then
			winner_subculture_key = defender_subculture_key
		end
	end

	if winner_subculture_key == self.beastmen_sc_key then
		beastmen_won = true
	end

	return beastmen_won, were_attacker
end


---returns bloodground table if a region is part of said bloodground. false if not.
function Bloodgrounds:is_bloodground_region(region_key)
	for key,bloodground in pairs(self.active_bloodgrounds) do
		if bloodground.region_list[region_key] then
			return bloodground
		end
	end
	return false
end


function Bloodgrounds:out(string)
	if self.debug_enabled then
		out.design(string)
	end
end

function Bloodgrounds:output_bloodgrounds_status()
	---debug output
	for k,v in pairs(self.active_bloodgrounds) do
		self:out("#Current Bloodgrounds Status:")
		self:out("## Bloodground"..k.." regions:")
		self:out("## Devastation: "..v.devastation)
		self:out("## Ritual available: "..tostring(v.ritual_unlocked))
		self:out("## Ritual completed: "..tostring(v.ritual_completed))
	end

end

function Bloodgrounds:interface_function(function_key, parameter_1, parameter_2, parameter_3, parameter_4)
	local bloodgrounds_component = find_uicomponent(core:get_ui_root(), self.bloodgrounds_uic_name)

	--- the UI doesn't handle nil parameters in the same way as lua, so we need to explictly get rid of them before calling the interface function
	--- horrible and hacky I know.
	if bloodgrounds_component then 
		if parameter_2 == nil then
			bloodgrounds_component:InterfaceFunction(function_key, parameter_1)
		elseif parameter_3 == nil  then 
			bloodgrounds_component:InterfaceFunction(function_key, parameter_1, parameter_2)
		elseif parameter_4 == nil  then
			bloodgrounds_component:InterfaceFunction(function_key, parameter_1, parameter_2, parameter_3)
		else
			bloodgrounds_component:InterfaceFunction(function_key, parameter_1, parameter_2, parameter_3, parameter_4)
		end
	end

end

function Bloodgrounds:are_there_any_human_beastmen()
	return cm:are_any_factions_human(self.beastmen_factions, nil, nil)
end

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ActiveBloodgrounds", Bloodgrounds.active_bloodgrounds, context)
	end
);

cm:add_loading_game_callback(
	function(context)
		Bloodgrounds.active_bloodgrounds = cm:load_named_value("ActiveBloodgrounds", {}, context)
	end
);