-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--	CAMPAIGN AI SCRIPT
--	This script contains a wide variety of functions which affect AI behaviour, which aren't specifically related to another script. Some are only active on the RoC map and some are only 
--  active on IE, while others are active on both maps, so please take care	that you are targetting the correct combination of maps when modifying this script. 
--
--  Handles the following parts of the CAI behaviour:
--  - Adjusting strategic threat based on the number of souls gathered
--  - Norsca VS Cathay bastion AI logic
--  - First Turn behaviour for AI major factions in the IE map
--  - Functions to improve chaos dwarf occupation logic
-- 	- Functions to trigger the AI has got a bunch of settlements incidents and give the victory effect bundles to those factions.
--	- Handles the application of customization options
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

campaign_ai_script = {
	script_triggered_settlement_attack = false,
	soul_threat_modifier = 100,

	chaos_bastion_related_factions_list = {
		"wh3_main_rogue_kurgan_warband",
		"wh3_main_cth_celestial_loyalists",
		"wh3_main_cth_imperial_wardens",
		"wh3_main_cth_the_jade_custodians",
		"wh3_main_cth_the_northern_provinces",
		"wh3_main_cth_the_western_provinces",
	},
	chaos_bastions_list = {
		"wh3_main_chaos_region_dragon_gate",
		"wh3_main_chaos_region_snake_gate",
		"wh3_main_chaos_region_turtle_gate",
	},
	soul_keys = {
		"wh3_main_realm_complete_khorne",
		"wh3_main_realm_complete_nurgle",
		"wh3_main_realm_complete_slaanesh",
		"wh3_main_realm_complete_tzeentch",
	},
	chaos_dwarf_primary_building_chain_keys = {
		outpost = "wh3_dlc23_chd_settlement_outpost",
		factory = "wh3_dlc23_chd_settlement_factory",
		tower = "wh3_dlc23_chd_settlement_tower",
	},
	short_victory_ai_factions = {},
	long_victory_ai_factions = {},
	MaxDistance = 5000,
	FactionToFactionsDiscovered = {},
	FactionToCoordinates = {},
	FactionToCoordinatesIterator = 1,

	kislev_background_income_data = {
		faction_setup = {
			{
				faction_key = "wh3_main_ksl_the_ice_court",
				effects = {
					{
						key = "wh3_main_effect_ksl_ice_court_support_faction",
						amount = 10,
						effect_scope = "faction_to_faction_own"
					}
				}
			},
			{
				faction_key = "wh3_main_ksl_the_great_orthodoxy",
				effects = {
					{
						key = "wh3_main_effect_ksl_orthodoxy_support_faction",
						amount = 10,
						effect_scope = "faction_to_faction_own"
					}
				}
			},
			{
				faction_key = "wh3_main_ksl_ursun_revivalists",
				effects = {
					{
						key = "wh3_main_effect_ksl_orthodoxy_support_faction",
						amount = 5,
						effect_scope = "faction_to_faction_own"
					}
				}
			},
			{
				faction_key = "wh3_dlc24_ksl_daughters_of_the_forest",
				effects = {
					{
						key = "wh3_main_effect_ksl_ice_court_support_faction",
						amount = 5,
						effect_scope = "faction_to_faction_own"
					},
					{
						key = "wh3_main_effect_ksl_orthodoxy_support_faction",
						amount = 5,
						effect_scope = "faction_to_faction_own"
					},
				}
			},
		},
		bundle_key = "wh3_main_ksl_background_support_income_hidden",
	},

	ai_minor_faction_potential = {
		target_potential_types = {
			combi_minor_strong = 40,
			combi_minor_survivor = 40,
			minor = -25,
			minor_weak = -25,
			minor_strong = 50,
		},
	},
	ai_extra_aggro = {
		target_global_script_context = "cai_global_script_context_special_1",
	},
}

function campaign_ai_script:setup_listeners()
	
	-- ====================== COMBI ONLY LISTENERS ================ --
	if cm:model():campaign_name_key() == "wh3_main_combi" then
		core:add_listener(
			--Force the AI to embed its starting hero (if it has one) and then force it to attack the closest army, then give control back to the AI. 
			"AIGameStartHeroEmbed",
			"FactionBeginTurnPhaseNormal",
			function(context)
				--Skips the human factions
				local faction = context:faction()
				return cm:turn_number() == 1 and not faction:is_human() and faction:is_contained_in_faction_set("all_vanilla_playable_factions")
			end,
			function(context)
				local faction = context:faction()
				local faction_name = faction:name()
				cm:cai_set_global_script_context("cai_global_script_context_alpha")
				cm:cai_disable_movement_for_faction(faction_name)
				self:embed_starting_hero(faction)
				self:fight_starting_battles(faction)
				cm:cai_enable_movement_for_faction(faction_name)
			end, 
			true
		)

		core:add_listener(
			--When the AI attacks a settlement, force it immediately to launch the attack, unless we caused it to attack a settlement earlier.
			"AIGameStartForceSiegeAttack",
			"CharacterBesiegesSettlement",
			function(context)
				--Skips the human factions
				local faction = context:character():faction()
				return cm:turn_number() == 1 and not faction:is_human() and faction:is_contained_in_faction_set("all_vanilla_playable_factions")
			end,
			function(context)
				if not self.script_triggered_settlement_attack then
					local character = context:character()
					cm:attack_region(cm:char_lookup_str(character), character:region():name())
				end
				self.script_triggered_settlement_attack = false
			end,
			true
		)

		core:add_listener(
			"AICleanUp", 
			"WorldStartRound", 
			function()
				return cm:turn_number() > 1
			end,
			function()
				core:remove_listener("AIGameStartHeroEmbed")
				core:remove_listener("AIGameStartForceSiegeAttack")
				cm:cai_clear_global_script_context()
			end,
			false
		)

		core:add_listener(
			"AIRegonCountForFauxVictory",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return not faction:is_human() and not faction:is_vassal() and not faction:is_rebel() and faction:region_list():num_items() >= 25
			end,
			function(context)
				self:process_faux_victory(context:faction())
			end,
			true
		)
	end	

	-- ====================== CHAOS ONLY LISTENERS ================ --
	if cm:model():campaign_name_key() == "wh3_main_chaos" then
		out.design("Initial Bastion state check");
		if self:count_standing_bastions() ~= #self.chaos_bastions_list then
			out.design("============== Campaign started with at least razed Bastion settlement, switching related AI factions to appropriate context ==============")
			self:set_bastion_related_factions_to_context("cai_faction_script_context_special_2")
		end;
		
		out.design("===== CHAOS VS CATHAY BASTION SETUP =====");
		-- BASTION RAZED
		core:add_listener(
			"bastion_settlement_razed",
			"CharacterRazedSettlement",
			function(context)
				local region_name = context:garrison_residence():region():name()
				return cm:cai_get_faction_script_context("wh3_main_rogue_kurgan_warband") ~= "cai_faction_script_context_special_2" and (region_name == "wh3_main_chaos_region_dragon_gate" or region_name == "wh3_main_chaos_region_snake_gate" or region_name == "wh3_main_chaos_region_turtle_gate")
			end,
			function(context)
				--If the Kurgan Warband is not already in "special_2" context, switch to it; Same with Cathay factions
				out.design("============== Bastion settlement razed script running ==============")
				--Kurgan Warband now switches to "free for all" mode, Cathay factions try to capture back the gates
				out.design("============== Bastion settlement was destroyed, related factions will now be set to cai_faction_script_context_special_2 context ==============")
				self:set_bastion_related_factions_to_context("cai_faction_script_context_special_2")
			end,
			true
		)
		
		-- BASTION COLONISED
		core:add_listener(
			"bastion_settlement_colonised",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				local settlement_option = context:settlement_option()
				local region_name = context:garrison_residence():region():name()
				-- Check number of "standing" gates, if it's N-1, then change the context back to default
				return cm:cai_get_faction_script_context("wh3_main_rogue_kurgan_warband") ~= "cai_faction_script_context_type_default" and (settlement_option == "occupation_decision_colonise" or settlement_option == "occupation_decision_resettle") and (region_name == "wh3_main_chaos_region_dragon_gate" or region_name == "wh3_main_chaos_region_snake_gate" or region_name == "wh3_main_chaos_region_turtle_gate") and self:count_standing_bastions() == #self.chaos_bastions_list
			end,
			function(context)
				out.design("============== Bastion settlement colonised script running ==============")
				out.design("============== Bastion settlement was colonised, checking if all bastions are standing ==============")
				out.design("============== No more ruined gates, related factions will now be set to default faction context ==============")
				self:set_bastion_related_factions_to_context("cai_faction_script_context_type_default")
			end,
			true
		)
		
		-- FACTION TURN START - update threat score penalty for souls
		out.design("===== THREAT INCREASE FOR EACH SOUL SETUP =====")
		core:add_listener(
			"update_threat_score_for_souls",
			"FactionTurnStart",
			function(context)
				return context:faction():can_be_human() -- this should filter for only major factions
			end,
			function(context)
				local faction = context:faction()
				-- run a function that counts souls
				local soul_cnt = self:count_souls_for_faction(faction)
				if soul_cnt > 0 then
					-- set threat level modifier based on souls
					local modifier = soul_cnt * self.soul_threat_modifier
					out.design("============== Updated base threat score for faction: "..faction:name().." == "..modifier.."  ==============")
					cm:set_base_strategic_threat_score(faction, modifier)
				end
			end,
			true
		)
	end

	-- ====================== LISTENERS IN BOTH CAMPAIGNS ================ --
	core:add_listener(
		"update_chd_factory_outpost_ratio",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:subculture() == "wh3_dlc23_sc_chd_chaos_dwarfs" and not faction:is_human() and faction:can_be_human()
		end,
		function(context)
			self:calculate_and_set_chaos_dwarf_building_ratios(context:faction())
		end,
		true
	)

	core:add_listener(
		"AINearbyDiplomaticContact",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return not faction:is_rebel() and not faction:is_human()
		end,
		function(context)
			self:nearby_diplomatic_contact(context:faction())
		end,
		true
	)
	
	core:add_listener(
		"AINearbyDiplomaticContactRest",
		"WorldStartRound",
		true,
		function()
			self.FactionToCoordinates = {}
			self.FactionToCoordinatesIterator = 1
		end,
		true
	)	
end 

-- ================================= IE GAME START RELATED FUNCTIONS ================================= --
function campaign_ai_script:embed_starting_hero(faction)
	local list = faction:military_force_list()
	for i = 0, list:num_items() - 1 do
		local force = list:item_at(i)
		if force:is_armed_citizenry() == false and force:is_navy() == false then
			local general = force:general_character()

			local character, x = cm:get_closest_hero_to_position_from_faction(faction, general:logical_position_x(), general:logical_position_y())
			if character and character:is_null_interface() == false and character:is_embedded_in_military_force() == false then
				cm:embed_agent_in_force(character, force)
			end
		end
	end
end

function campaign_ai_script:fight_starting_battles(faction)
	local list = faction:military_force_list()
	local enemy_faction_list = faction:factions_at_war_with() 

	for i = 0, list:num_items() - 1 do
		local force = list:item_at(i)
		if force:is_armed_citizenry() == false and force:is_navy() == false and force:has_garrison_residence() == false then
			local general = force:general_character()

			local enemy_force, in_range = self:find_correct_enemy_force(force, enemy_faction_list, general:logical_position_x(), general:logical_position_y())
			if in_range == false then --If no enemy army is in range this turn then we break and allow the AI to get on with the rest of its turn 
				break
			end
			cm:attack_queued(cm:char_lookup_str(general), cm:char_lookup_str(enemy_force:general_character()))
			out.design("Our force " .. common.get_localised_string(general:get_forename()) .. " is attacking an enemy army led by ".. common.get_localised_string(enemy_force:general_character():get_forename()))
		end
	end
end

function campaign_ai_script:find_correct_enemy_force(our_force, enemy_faction_list, x, y)
	for i = 0, enemy_faction_list:num_items() - 1 do
		enemy_force = cm:get_closest_military_force_from_faction(enemy_faction_list:item_at(i):name(), x, y, true)
		if enemy_force:is_armed_citizenry() == false then
			if cm:character_can_reach_character(our_force:general_character(), enemy_force:general_character()) == true then
				if enemy_force:has_garrison_residence() == true then
					self.script_triggered_settlement_attack = true
				end
				return enemy_force, true
			end
		elseif cm:character_can_reach_settlement(our_force:general_character(), enemy_force:garrison_residence():settlement_interface()) == true then
			self.script_triggered_settlement_attack = true
			return enemy_force, true
		end
	end
	return enemy_force, false
end

-- ================================= BASTION RELATED FUNCTIONS ================================= --
function campaign_ai_script:count_standing_bastions()
	local cnt = 0
	
	for i, v in pairs(self.chaos_bastions_list) do
		-- Get region by name, check if it's not a ruin
		local region = cm:get_region(v)
		if region and not region:is_abandoned() then
			cnt = cnt + 1
		end
	end
	
	return cnt
end

function campaign_ai_script:set_bastion_related_factions_to_context(target_context)
	for i, faction_key in pairs(self.chaos_bastion_related_factions_list) do
		if cm:get_faction(faction_key) then
			cm:cai_set_faction_script_context(faction_key, target_context)
			out.design("============== This faction: "..faction_key.." is now using this context: "..cm:cai_get_faction_script_context(faction_key).." ==============")
		end
	end
end

-- ================================= SOULS RELATED FUNCTIONS ================================= --
function campaign_ai_script:count_souls_for_faction(faction)
	local cnt = 0

	for i = 1, #self.soul_keys do 
		if faction:pooled_resource_manager():resource(self.soul_keys[i]):is_null_interface() and faction:pooled_resource_manager():resource(self.soul_keys[i]) == 1 then
			cnt = cnt + 1
		end
	end

	return cnt
end

-- ================================= CHAOS DWARF OCCUPATION RELATED FUNCTIONS ================================= --
function campaign_ai_script:calculate_and_set_chaos_dwarf_building_ratios(faction)
	local factory_count = 0
	local outpost_count = 0
	local tower_count = 0
	local region_list = faction:region_list()

	for i = 0, region_list:num_items() - 1 do
		local building = region_list:item_at(i):settlement():primary_building_chain()
		if building == self.chaos_dwarf_primary_building_chain_keys.factory then
			factory_count = factory_count + 1
		elseif building == self.chaos_dwarf_primary_building_chain_keys.outpost then
			outpost_count = outpost_count + 1
		elseif building == self.chaos_dwarf_primary_building_chain_keys.tower then
			tower_count = tower_count + 1
		end
	end

	local other_count = factory_count + outpost_count

	if outpost_count == 0 then
		outpost_ratio = 0
	elseif factory_count == 0 then
		outpost_ratio = 10
	else 
		outpost_ratio = outpost_count/factory_count
	end

	if tower_count == 0 then
		tower_ratio = 0.01
	elseif other_count == 0 then
		tower_ratio = 10
	else
		tower_ratio = tower_count/other_count
	end

	outpost_ratio = outpost_ratio - 1.5 --It takes 1.5 outposts to fuel each factory, so we get a negative number if we need outposts and a positive number if we need factories, which we can use in DAVE to get the acutal occupation weights
	tower_ratio = 1 / tower_ratio

	cm:set_script_state(faction, "faction_chaos_dwarf_outpost_ratio", outpost_ratio)
	cm:set_script_state(faction, "faction_chaos_dwarf_tower_ratio", tower_ratio)
end

-- ================================= FAUX VICTORY RELATED FUNCTIONS ================================= --
function campaign_ai_script:process_faux_victory(faction)
	local faction_key = faction:name()
	
	if self.long_victory_ai_factions[faction_key] then
		return
	end
	
	local region_list = faction:region_list()
	local incident_key = "wh3_dlc24_incident_ai_faux_victory_short"
	local faction_subculture_key = faction:subculture()
	local mission_key = "wh_main_short_victory"
	local faction_alignment = victory_objectives_ie.alignments.default
	
	if region_list:num_items() >= 50 then
		incident_key = "wh3_dlc24_incident_ai_faux_victory_long"
		mission_key = "wh_main_long_victory"
		self.long_victory_ai_factions[faction_key] = true
	elseif self.short_victory_ai_factions[faction_key] then
		return
	end

	if victory_objectives_ie.subcultures[faction_subculture_key] then
		faction_alignment = victory_objectives_ie.subcultures[faction_subculture_key].alignment
	end

	local bundle = victory_objectives_ie.alignments[faction_alignment][mission_key].payload_bundle
	local ancillary = victory_objectives_ie.alignments[faction_alignment][mission_key].payload_ancillary

	if ancillary == nil then
		cm:apply_effect_bundle(bundle, faction_key, 0)
	end	
		
	if bundle == nil then
		cm:add_ancillary_to_faction(faction, ancillary, true)
	end
	
	local faction_cqi = faction:command_queue_index()

	for _, current_faction_met in model_pairs(faction:factions_met()) do
		if current_faction_met:is_human() then
			cm:trigger_incident_with_targets(current_faction_met:command_queue_index(), incident_key, faction_cqi, 0, 0, 0, 0, 0)
		end
	end

	self.short_victory_ai_factions[faction_key] = true
end

-- ========================================= DIPLOMATIC CONTACT RELATED FUNCTIONS =========================== --

function campaign_ai_script:nearby_diplomatic_contact(faction)
	local counter = 0
	local region_list = faction:region_list()
	local military_force_list = faction:military_force_list()
	if region_list:num_items() > 0 then
		for j = 0, region_list:num_items() - 1 do
			local Current = {}
			table.insert(Current, faction:name())
			local CurrentX, CurrentY = cm:settlement_logical_pos(region_list:item_at(j):settlement():key())
			table.insert(Current, CurrentX)
			table.insert(Current, CurrentY)
			table.insert(self.FactionToCoordinates,	Current)
			counter = counter + 1
		end
	end
	if military_force_list:num_items() > 0 then
		for j = 0, military_force_list:num_items() - 1 do
			local force = military_force_list:item_at(j)
			
			if not force:is_armed_citizenry() and not force:has_garrison_residence() and force:has_general() then
				local general_character = force:general_character()
				
				if general_character:has_region() then
					local region = general_character:region()
					
					if not region:is_abandoned() and region:owning_faction() ~= faction then
						local Current = {}							--If a force is in a region owned by its faction then we ignore it as the the setttlement will be close enough, and ignoring these forces will be a huge performance gain
						table.insert(Current, faction:name())
						local CurrentX, CurrentY = cm:char_logical_pos(force:general_character())
						table.insert(Current, CurrentX)
						table.insert(Current, CurrentY)
						table.insert(self.FactionToCoordinates,	Current)
						counter = counter + 1
					end
				end
			end
		end
	end

	for i = self.FactionToCoordinatesIterator, #self.FactionToCoordinates do
		local SourceData = self.FactionToCoordinates[i]
		local Source = SourceData[1]
		for j = 1, #self.FactionToCoordinates do 
			TargetData = self.FactionToCoordinates[j]
			Target = TargetData[1]
			if self.FactionToFactionsDiscovered[Source..Target] == nil and Source ~= Target then	
				if distance_squared(SourceData[2], SourceData[3], TargetData[2], TargetData[3]) < self.MaxDistance then
					self.FactionToFactionsDiscovered[Source..Target] = true 										
					self.FactionToFactionsDiscovered[Target..Source] = true
					cm:make_diplomacy_available(Source, Target)
				end
			end
		end
	end
	self.FactionToCoordinatesIterator = self.FactionToCoordinatesIterator + counter
end

-- ========================================= KISLEV RELATED FUNCTIONS =========================== --

function campaign_ai_script:kislev_background_income()
	local data_table = campaign_ai_script.kislev_background_income_data
	for i, faction_data in ipairs(data_table.faction_setup) do
		local faction = cm:get_faction(faction_data.faction_key)
		
		if faction and not faction:is_human() then 
			local bundle = cm:create_new_custom_effect_bundle(data_table.bundle_key)
			if bundle then
				for e, effect in ipairs(faction_data.effects) do
					bundle:add_effect(effect.key, effect.effect_scope, effect.amount)
				end
				cm:apply_custom_effect_bundle_to_faction(bundle, faction)
			end
		end
	end
end

-- ========================================= CUSTOMIZATION =========================== --

cm:add_first_tick_callback(
	function()
		local ssm = cm:model():shared_states_manager()
		local minor_potential = ssm:get_state_as_bool_value("ai_minor_faction_potential")

		if minor_potential == false then
			local faction_list = cm:model():world():faction_list()
			local config = campaign_ai_script.ai_minor_faction_potential
			for i = 0, faction_list:num_items() - 1 do
				local faction = faction_list:item_at(i)
				local override_amount = config.target_potential_types[faction:faction_potential_type()]
				if not faction:is_human() and not faction:is_rebel() and is_number(override_amount) then
					cm:faction_set_total_potential_override_value(faction, true, override_amount)
				end
			end
		end

		local extra_aggro = ssm:get_state_as_bool_value("ai_extra_aggro")
		if extra_aggro == true then
			local config = campaign_ai_script.ai_extra_aggro
			cm:cai_set_global_script_context(config.target_global_script_context)
		end
	end
)
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("AIFactiontoFactionContact", campaign_ai_script.FactionToFactionsDiscovered, context)
		cm:save_named_value("FactionToCoordinatesIterator", campaign_ai_script.FactionToCoordinatesIterator, context)
		cm:save_named_value("FactionToCoordinates", campaign_ai_script.FactionToCoordinates, context)
		cm:save_named_value("short_victory_ai_factions", campaign_ai_script.short_victory_ai_factions, context)
		cm:save_named_value("long_victory_ai_factions", campaign_ai_script.long_victory_ai_factions, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if (cm:is_new_game() == false) then
			campaign_ai_script.FactionToFactionsDiscovered = cm:load_named_value("AIFactiontoFactionContact", campaign_ai_script.FactionToFactionsDiscovered, context)
			campaign_ai_script.FactionToCoordinate = cm:load_named_value("FactionToCoordinates", campaign_ai_script.FactionToCoordinates, context)
			campaign_ai_script.FactionToCoordinatesIterator =  cm:load_named_value("FactionToCoordinatesIterator", campaign_ai_script.FactionToCoordinatesIterator, context)
			campaign_ai_script.short_victory_ai_factions = cm:load_named_value("short_victory_ai_factions", campaign_ai_script.short_victory_ai_factions, context)
			campaign_ai_script.long_victory_ai_factions = cm:load_named_value("long_victory_ai_factions", campaign_ai_script.long_victory_ai_factions, context)
		end
	end
)