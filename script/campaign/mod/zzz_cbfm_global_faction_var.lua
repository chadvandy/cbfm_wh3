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