-- script/campaign/wh3_campaign_ai.lua:213
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
            -- CBFM: switch faction to local
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

-- script/_lib/lib_campaign_manager.lua:4347
function campaign_manager:faction_has_dlc_or_is_ai(dlc_key, faction_key)
    -- CBFM: switch faction to local
	local faction = self:get_faction(faction_key)
	if not faction then return false end;
	
	if not faction:is_human() then
		return true;
	else
		return self:is_dlc_flag_enabled(dlc_key, faction_key)
	end;
end;

-- why
function nurgle_plagues:plague_listeners()

	-- add ap when plague cultist spawns
	core:add_listener(
		"Plagues_CultistCreated",
		"CharacterCreated",
		function(context)
			return context:character():character_subtype("wh3_main_nur_cultist_plague_ritual")
		end,
		function(context)
			local character = cm:char_lookup_str(context:character():cqi())
			cm:callback(function() cm:replenish_action_points(character) end, 0.2)
		end,
		true
	)

	core:add_listener(
		"Plagues_AchievementListener",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) and faction:is_human()	
		end,
		function(context)
			local all_unlocked = true
			-- CBFM: "faction" has to be defined, turns out
			local faction = context:faction()
			-- end CBFM
			local component_list = faction:plagues():plague_component_list()	
			--loop through all components to see if any are locked
			for i = 0, component_list:num_items() -1 do
				local symptom = component_list:item_at(i)
				if not symptom:has_state("UNLOCKED") and not string.find(symptom:key(), "mutation") then
					--not all symptoms unlocked yet
					all_unlocked = false
					break
				end
			end
			if all_unlocked then
				core:trigger_event("ScriptEvent_AllPlagueComponentsUnlocked", context)
			end
		end,
		true
	)

	--remove blessed state on any symptoms spawned with a plague cultist
	core:add_listener(
		"Plagues_CultistCreated",
		"AgentPlagueDataCreatedEvent",
		function(context)
			return context:agent():character():character_subtype("wh3_main_nur_cultist_plague_ritual")
		end,
		function(context)
			local plague_components = context:agent():character():try_get_agent_plague_components()
			self:remove_blessed_symptom(plague_components)
		end,
		true
	)

	core:add_listener(
		"Plagues_PlagueCreationCounter",
		"RitualStartedEvent",
		function(context)			
			return context:performing_faction():is_human() and string.find(context:ritual():ritual_key(), "wh3_main_ritual_nur_plague_") 
		end,
		function(context)
			local faction = context:performing_faction()
			local pfi = self.plague_faction_info	
			local faction_info = pfi[faction:name()]

			faction_info.plague_creation_counter = faction_info.plague_creation_counter - 1

			if faction_info.plague_creation_counter <= 0 then
				--adding a callback as RitualStartedEvent triggers before MilitaryForceInfectionEvent or RegionInfectionEvent 
				--this results in blessed symptoms not being granted if its part of the final Plague before reset positions and blessed symptoms		
				cm:callback(function() self:randomise_symptom_location(faction) end, 0.5)
			end

			common.set_context_value("random_plague_creation_count_" .. faction:name(), faction_info.plague_creation_counter)
		end,
		true
	)

	core:add_listener(
		"Plagues_TrackFactionTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.epidemius_faction
		end,
		function (context)
			self:count_plagues_on_non_nurgle_targets()	
		end,
		true
	)

	core:add_listener(
		"Plagues_AdditionalMaxBlessedCharacterRankUp",
		"CharacterRankUp",
		function(context)
			local character = context:character()
			return character:character_subtype(self.kugath_subtype_key) and character:rank() % 10 == 0 and character:faction():name() == self.kugath_faction
		end,
		function (context)
			local pfi = self.plague_faction_info	
			local faction_info = pfi[self.kugath_faction]
			faction_info.max_blessed_symptoms = faction_info.max_blessed_symptoms + 1
		end,
		true
	)


	core:add_listener(
		"Plagues_TrackBlessedSymptom_Region",
		"RegionInfectionEvent",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			--check that the plague has just been created and wasnt spread by an agent
			if context:is_creation() and context:spreading_agent() ~= nil then 
				self:remove_blessed_symptom(context:plague():plague_components())	
			else
				core:trigger_custom_event("ScriptEventPlagueSpreading", {faction = context:faction()})
			end	
			if context:plague():creator_faction():name() == self.epidemius_faction then
				self:count_plagues_on_non_nurgle_targets()	
			end			
		end,
		true
	)

	core:add_listener(
		"Plagues_TrackBlessedSymptom_Force",
		"MilitaryForceInfectionEvent",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			--check that the plague has just been created and wasnt spread by an agent
			if context:is_creation() and context:spreading_agent() ~= nil then 
				self:remove_blessed_symptom(context:plague():plague_components())	
			else
				core:trigger_custom_event("ScriptEventPlagueSpreading", {faction = context:faction()})
			end
			if context:plague():creator_faction():name() == self.epidemius_faction then
				self:count_plagues_on_non_nurgle_targets()	
			end
		end,
		true
	)

	core:add_listener(
		"Plagues_TrackBattleCompleted",
		"BattleCompleted",
		function()
			return cm:model():pending_battle():has_been_fought() and cm:pending_battle_cache_human_is_involved()
		end,
		function (context)
			self:count_plagues_on_non_nurgle_targets()	
		end,
		true
	)

	core:add_listener(
		"Plagues_AdditionalMaxBlessedTech",
		"ResearchCompleted",
		function(context)
			local technology = context:technology()
			local faction = context:faction()

			if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) then	
				return faction:is_human() and technology == self.blessed_tech
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local pfi = self.plague_faction_info	
			local faction_info = pfi[faction:name()]
			faction_info.max_blessed_symptoms = faction_info.max_blessed_symptoms + 1

		end,
		true
	)

	core:add_listener(
		"Plagues_PooledResourceChanged",
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) and faction:is_human() then	
					local pbu = self.plague_button_unlock	
					local unlock_info = pbu[faction:name()]
					
					return unlock_info.button_locked
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local pbu = self.plague_button_unlock	
			local unlock_info = pbu[faction:name()]

			local pr_changed = context:resource():key()
			local pr = faction:pooled_resource_manager():resource(self.pr_key)

			if pr_changed == self.pr_key then
				local amount_changed = context:amount()
				if amount_changed > 0 then
					unlock_info.infections_gained = unlock_info.infections_gained + amount_changed
				end
			end
			if unlock_info.infections_gained >= self.pr_required_to_unlock then
				self:unlock_plagues_button(faction, unlock_info)				
			end
			common.set_context_value("unlock_plague_button_" .. faction:name(), unlock_info.infections_gained)
		end,
		true
	)

	core:add_listener(
		"Plagues_PooledResourceFactionTurnStart",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) and faction:is_human() then	
					local pbu = self.plague_button_unlock	
					local unlock_info = pbu[faction:name()]
					
					return unlock_info.button_locked
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local pbu = self.plague_button_unlock	
			local unlock_info = pbu[faction:name()]

			local pr_value = faction:pooled_resource_manager():resource(self.pr_key):value()
			
			if pr_value > unlock_info.infections_end_of_last_turn then
				local amount = pr_value - unlock_info.infections_end_of_last_turn
				unlock_info.infections_gained = unlock_info.infections_gained + amount
			end			
			if unlock_info.infections_gained >= self.pr_required_to_unlock then
				self:unlock_plagues_button(faction, unlock_info)				
			end
			common.set_context_value("unlock_plague_button_" .. faction:name(), unlock_info.infections_gained)
		end,
		true
	)

	core:add_listener(
		"Plagues_PooledResourceFactionTurnEnd",
		"FactionTurnEnd",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) and faction:is_human() then	
					local pbu = self.plague_button_unlock	
					local unlock_info = pbu[faction:name()]
					
					return unlock_info.button_locked
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local pbu = self.plague_button_unlock	
			local unlock_info = pbu[faction:name()]

			unlock_info.infections_end_of_last_turn = faction:pooled_resource_manager():resource(self.pr_key):value()
		end,
		true
	)

end