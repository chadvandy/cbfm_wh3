local function is_female(character)
	return character:character_details():character_subtype_has_female_name() and not character:character_subtype("wh2_dlc14_brt_repanse")
end

local vow_to_troth = {
	["wh_dlc07_trait_brt_knights_vow_knowledge_pledge"] = "wh_dlc07_trait_brt_protection_troth_knowledge_pledge",
	["wh_dlc07_trait_brt_knights_vow_order_pledge"] = "wh_dlc07_trait_brt_protection_troth_order_pledge",
	["wh_dlc07_trait_brt_knights_vow_chivalry_pledge"] = "wh_dlc07_trait_brt_protection_troth_chivalry_pledge",
	["wh_dlc07_trait_brt_questing_vow_campaign_pledge"] = "wh_dlc07_trait_brt_wisdom_troth_campaign_pledge",
	["wh_dlc07_trait_brt_questing_vow_heroism_pledge"] = "wh_dlc07_trait_brt_wisdom_troth_heroism_pledge",
	["wh_dlc07_trait_brt_questing_vow_protect_pledge"] = "wh_dlc07_trait_brt_wisdom_troth_protect_pledge",
	["wh_dlc07_trait_brt_grail_vow_untaint_pledge"] = "wh_dlc07_trait_brt_virtue_troth_untaint_pledge",
	["wh_dlc07_trait_brt_grail_vow_valour_pledge"] = "wh_dlc07_trait_brt_virtue_troth_valour_pledge",
	["wh_dlc07_trait_brt_grail_vow_destroy_pledge"] = "wh_dlc07_trait_brt_virtue_troth_destroy_pledge",
	["wh_dlc07_trait_brt_knights_vow_knowledge_pledge_agent"] = "wh_dlc07_trait_brt_protection_troth_knowledge_pledge_agent",
	["wh_dlc07_trait_brt_knights_vow_order_pledge_agent"] = "wh_dlc07_trait_brt_protection_troth_order_pledge_agent",
	["wh_dlc07_trait_brt_knights_vow_chivalry_pledge_agent"] = "wh_dlc07_trait_brt_protection_troth_chivalry_pledge_agent",
	["wh_dlc07_trait_brt_questing_vow_campaign_pledge_agent"] = "wh_dlc07_trait_brt_wisdom_troth_campaign_pledge_agent",
	["wh_dlc07_trait_brt_questing_vow_heroism_pledge_agent"] = "wh_dlc07_trait_brt_wisdom_troth_heroism_pledge_agent",
	["wh_dlc07_trait_brt_questing_vow_protect_pledge_agent"] = "wh_dlc07_trait_brt_wisdom_troth_protect_pledge_agent",
	["wh_dlc07_trait_brt_grail_vow_untaint_pledge_agent"] = "wh_dlc07_trait_brt_virtue_troth_untaint_pledge_agent",
	["wh_dlc07_trait_brt_grail_vow_valour_pledge_agent"] = "wh_dlc07_trait_brt_virtue_troth_valour_pledge_agent",
	["wh_dlc07_trait_brt_grail_vow_destroy_pledge_agent"] = "wh_dlc07_trait_brt_virtue_troth_destroy_pledge_agent"
}

local vow_max_points = {
	["wh_dlc07_trait_brt_questing_vow_campaign_pledge"] = 2,
	["wh_dlc07_trait_brt_questing_vow_heroism_pledge"] = 2,
	["wh_dlc07_trait_brt_questing_vow_protect_pledge"] = 2,
	["wh_dlc07_trait_brt_grail_vow_untaint_pledge"] = 2
}

local function init()
	local vow_agents = 
	{
		["wh_main_brt_paladin"] = true,
		["wh2_dlc14_brt_henri_le_massif"] = true,
		["wh_main_brt_damsel_heavens"] = true,
		["wh_dlc07_brt_damsel_beasts"] = true,
		["wh_dlc07_brt_damsel_life"] = true
	}
	
	-- unfortunately, we need to start be rewriting this function in 3.1, as it is the only way to get the last two agent troths to work
	function add_vow_progress(character, trait, ai, agents)
		if character:is_null_interface() then
			return false
		end
		
		local faction = character:faction()
		
		if not ai and not faction:is_human() then
			return false -- Make sure AI doesn't get Vows when we don't want them to
		end
		
		local char_cqi = character:cqi()
		out.design("------------------------------------------------")
		out.design("add_vow_progress - " .. char_cqi .. " - " .. trait .. " - " .. tostring(ai) .. " - " .. tostring(agents))
		local max_trait_points = vow_max_points[trait] or 6
		out.design("\tMax Points - " .. max_trait_points)
		local incident = "wh_dlc07_incident_brt_vow_gained"
		local incident_uc = incident
		local trait_uc = trait
		
		if character:character_details():character_subtype_has_female_name() and not character:character_subtype("wh2_dlc14_brt_repanse") then
			out.design("\tFemale Character")
			trait = vow_to_troth[trait]
			out.design("\tTrait - " .. trait)
			incident = incident .. "_female"
			
			if trait:starts_with("wh_dlc07_trait_brt_virtue_troth") == true and character:character_subtype("wh_dlc07_brt_fay_enchantress") == true then
				trait = trait .. "_fay"
				out.design("\tFay Trait - " .. trait)
			end
		end
		
		local event_key = trait
		
		local faction_cqi = faction:command_queue_index()
		local points = character:trait_points(trait)
		out.design("\tPoints: " .. points)
		
		if points > 0 or ai == true then
			if points < max_trait_points then
				out.design("\tAdding trait - " .. trait)
				cm:force_add_trait(cm:char_lookup_str(character), trait, false, 1)
				points = points + 1
				out.design("\tNew Points: " .. points)
				
				if points == max_trait_points and ai == false then
					out.design("\tTriggering event: " .. char_cqi)
					cm:trigger_incident_with_targets(faction_cqi, incident, 0, 0, char_cqi, 0, 0, 0)
					
					if event_key:starts_with("wh_dlc07_trait_brt_knights_vow") then 
						core:trigger_event("ScriptEventBretonniaKnightsVowCompleted", character)
					elseif event_key:starts_with("wh_dlc07_trait_brt_questing_vow") then
						core:trigger_event("ScriptEventBretonniaQuestingVowCompleted", character)
					elseif event_key:starts_with("wh_dlc07_trait_brt_grail_vow") then
						core:trigger_event("ScriptEventBretonniaGrailVowCompleted", character)
					elseif event_key:starts_with("wh_dlc07_trait_brt_virtue_troth") then
						core:trigger_event("ScriptEventBretonniaVirtueTrothCompleted", character) 
					end
				end
			end
		end
		
		-- Do all Paladins (AND DAMSELS, IT'S TIME FOR EQUALITY BOYS, C'MON) in this characters army
		if agents and character:has_military_force() then
			--trait = trait_uc .. "_agent"
			local force_characters = character:military_force():character_list()
			local force_character_count = force_characters:num_items()
			out.design("Checking agents (" .. force_character_count .. ")...")
			
			for i = 0, force_character_count - 1 do
				local current_char = force_characters:item_at(i)
				local subtype_key = current_char:character_subtype_key()
				if is_female(current_char) then
					trait = vow_to_troth[trait_uc] .. "_agent"
				else
					trait = trait_uc .. "_agent"
				end
				out.design("\t\tCharacter: " .. subtype_key)
				
				if vow_agents[subtype_key] then
					local agent_points = current_char:trait_points(trait)
					out.design("\t\t\tPoints: " .. agent_points)
					
					if agent_points > 0 and agent_points < max_trait_points then
						out.design("\t\t\tAdding agent trait - " .. trait)
						char_cqi = current_char:command_queue_index()
						cm:force_add_trait(cm:char_lookup_str(current_char), trait, false, 1)
						agent_points = agent_points + 1
						out.design("\t\t\tNew Points: " .. agent_points)
						
						if agent_points == max_trait_points then
							out.design("\t\t\tTriggering event: " .. char_cqi)
							cm:trigger_incident_with_targets(faction_cqi, incident_uc, 0, 0, char_cqi, 0, 0, 0)
						end
					end
				end
			end
		end
		out.design("------------------------------------------------")
	end

    core:remove_listener("character_completed_battle_pledge_to_campaign")
    core:add_listener(
	"character_completed_battle_pledge_to_campaign",
	"CharacterCompletedBattle",
	function(context)
		local pb = context:pending_battle()
		local battle_type = pb:battle_type()
		
		if battle_type == "settlement_standard" or battle_type == "settlement_unfortified" then
			local character = context:character()
			if character:won_battle() then
				local faction = character:faction()
				if faction:is_human() and faction:culture() == "wh_main_brt_bretonnia" and pb:has_attacker() and pb:attacker() == character and character:has_region() then
					local climate = character:region():settlement():get_climate()
					
					return climate == "climate_desert" or climate == "climate_jungle"
				end
			end
		end
	end,
	function(context)
		add_vow_progress(context:character(), "wh_dlc07_trait_brt_questing_vow_campaign_pledge", false, true)
	end,
	true
	)
	core:add_listener(
	"character_completed_battle_pledge_to_campaign_secondary_general",
	"CharacterParticipatedAsSecondaryGeneralInBattle",
	function(context)
		local pb = cm:model():pending_battle()
		local battle_type = pb:battle_type()
		
		if battle_type == "settlement_standard" or battle_type == "settlement_unfortified" then
			local character = context:character()
			if character:won_battle() then
				local faction = character:faction()
				
				local was_attacking = false -- default
				local secondary_attackers = pb:secondary_attackers()
				for _, this_attacker in model_pairs(secondary_attackers) do
					if this_attacker == character then 
						was_attacking = true
						break
					end
				end
				
				if faction:is_human() and faction:culture() == "wh_main_brt_bretonnia" and pb:has_attacker() and was_attacking and character:has_region() then
					local climate = character:region():settlement():get_climate()
					
					return climate == "climate_desert" or climate == "climate_jungle"
				end
			end
		end
	end,
	function(context)
		add_vow_progress(context:character(), "wh_dlc07_trait_brt_questing_vow_campaign_pledge", false, true)
	end,
	true
	)
	
	-- added fix for ai lords skipping vows when gaining multiple levels in one turn, which is a new thing in wh3. much of this is based on a different fix from sm0kin in the wh2 days
	local knights_protection = 
	{
		"wh_dlc07_trait_brt_knights_vow_knowledge_pledge", 
		"wh_dlc07_trait_brt_knights_vow_knowledge_pledge_agent",
		"wh_dlc07_trait_brt_knights_vow_order_pledge",
		"wh_dlc07_trait_brt_knights_vow_order_pledge_agent",
		"wh_dlc07_trait_brt_knights_vow_chivalry_pledge",
		"wh_dlc07_trait_brt_knights_vow_chivalry_pledge_agent",
		"wh_dlc07_trait_brt_protection_troth_knowledge_pledge",
		"wh_dlc07_trait_brt_protection_troth_knowledge_pledge_agent",
		"wh_dlc07_trait_brt_protection_troth_order_pledge",
		"wh_dlc07_trait_brt_protection_troth_order_pledge_agent",
		"wh_dlc07_trait_brt_protection_troth_chivalry_pledge",
		"wh_dlc07_trait_brt_protection_troth_chivalry_pledge_agent"
	}
	local questing_wisdom = 
	{
		"wh_dlc07_trait_brt_questing_vow_campaign_pledge",
		"wh_dlc07_trait_brt_questing_vow_campaign_pledge_agent",
		"wh_dlc07_trait_brt_questing_vow_heroism_pledge",
		"wh_dlc07_trait_brt_questing_vow_heroism_pledge_agent",
		"wh_dlc07_trait_brt_questing_vow_protect_pledge",
		"wh_dlc07_trait_brt_questing_vow_protect_pledge_agent",
		"wh_dlc07_trait_brt_wisdom_troth_campaign_pledge",
		"wh_dlc07_trait_brt_wisdom_troth_campaign_pledge_agent",
		"wh_dlc07_trait_brt_wisdom_troth_heroism_pledge",
		"wh_dlc07_trait_brt_wisdom_troth_heroism_pledge_agent",
		"wh_dlc07_trait_brt_wisdom_troth_protect_pledge",
		"wh_dlc07_trait_brt_wisdom_troth_protect_pledge_agent"
	}
	local grail_virtue = 
	{
		"wh_dlc07_trait_brt_grail_vow_untaint_pledge",
		"wh_dlc07_trait_brt_grail_vow_untaint_pledge_agent",
		"wh_dlc07_trait_brt_grail_vow_valour_pledge",
		"wh_dlc07_trait_brt_grail_vow_valour_pledge_agent",
		"wh_dlc07_trait_brt_grail_vow_destroy_pledge",
		"wh_dlc07_trait_brt_grail_vow_destroy_pledge_agent",
		"wh_dlc07_trait_brt_virtue_troth_untaint_pledge",
		"wh_dlc07_trait_brt_virtue_troth_untaint_pledge_agent",
		"wh_dlc07_trait_brt_virtue_troth_valour_pledge",
		"wh_dlc07_trait_brt_virtue_troth_valour_pledge_agent",
		"wh_dlc07_trait_brt_virtue_troth_destroy_pledge",
		"wh_dlc07_trait_brt_virtue_troth_destroy_pledge_agent"
	}
	
	local function has_pledge(character,pledge_table)
		for i = 1, #pledge_table do
			if character:has_trait(pledge_table[i]) then 
				return true
			end
		end  
		return false
	end
	
	core:remove_listener("character_rank_up_vows_per_level_ai")
	core:add_listener(
	"character_rank_up_vows_per_level_ai",
	"CharacterRankUp",
	function(context)
		local character = context:character()
		local faction = character:faction()
		
		return faction:culture() == "wh_main_brt_bretonnia" and not faction:is_human()
	end,
	function(context)
		local character = context:character()	
		local rank = character:rank()
		
		if character:character_type("general") or vow_agents[character:character_subtype_key()] then
			if rank >= 2 and not has_pledge(character,knights_protection) then
				for i = 1, 6 do
					if character:character_type("general") then
						add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", true, false)
					elseif vow_agents[character:character_subtype_key()] then
						add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge_agent", true, false)
					end
				end
			elseif rank >= 5 and not has_pledge(character,questing_wisdom) then
				for i = 1, 6 do
					if character:character_type("general") then
						add_vow_progress(character, "wh_dlc07_trait_brt_questing_vow_protect_pledge", true, false)
					elseif vow_agents[character:character_subtype_key()] then
						add_vow_progress(character, "wh_dlc07_trait_brt_questing_vow_protect_pledge_agent", true, false)
					end
				end
			elseif rank >= 10 and not has_pledge(character,grail_virtue) then
				for i = 1, 6 do
					if character:character_type("general") then
						add_vow_progress(character, "wh_dlc07_trait_brt_grail_vow_valour_pledge", true, false)
					elseif vow_agents[character:character_subtype_key()] then
						add_vow_progress(character, "wh_dlc07_trait_brt_grail_vow_valour_pledge_agent", true, false)
					end
				end
			end
		end
	end,
	true
	)
	
	-- rewrites for 3.1 agent troth additions --
	-- Pledge to Order
	core:remove_listener("building_completed_pledge_to_knowledge")
	core:add_listener(
		"building_completed_pledge_to_knowledge",
		"BuildingCompleted",
		function(context)
			local faction = context:building():faction()
			return not faction:is_null_interface() and faction:is_human() and faction:culture() == "wh_main_brt_bretonnia"
		end,
		function(context)
			local building = context:building()
			local building_region = building:region():name()
			local characters = building:faction():character_list()
			
			for i = 0, characters:num_items() - 1 do
				local current_character = characters:item_at(i)
				
				if current_character:has_region() and current_character:region():name() == building_region then
					if vow_agents[current_character:character_subtype_key()] then
						local trait
						if is_female(current_character) then
							trait = "wh_dlc07_trait_brt_protection_troth_order_pledge_agent"
						else
							trait = "wh_dlc07_trait_brt_knights_vow_order_pledge_agent"
						end
						cm:force_add_trait(cm:char_lookup_str(current_character), trait, false)
					else
						add_vow_progress(current_character, "wh_dlc07_trait_brt_knights_vow_order_pledge", false, false)
					end
				end
			end
		end,
		true
	)
	
	-- Pledge to Chivalry
	core:remove_listener("character_rank_up_pledge_to_chivalry")
	core:add_listener(
		"character_rank_up_pledge_to_chivalry",
		"CharacterRankUp",
		function(context)
			local faction = context:character():faction()
			
			return faction:is_human() and faction:culture() == "wh_main_brt_bretonnia"
		end,
		function(context)
			local character = context:character()
			local ranks_gained = context:ranks_gained()
			
			if character:character_type("general") then
				for i = 1, ranks_gained do
					add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_chivalry_pledge", false, false)
				end
			elseif vow_agents[character:character_subtype_key()] then
				local trait
				if is_female(character) then
					trait = "wh_dlc07_trait_brt_protection_troth_chivalry_pledge_agent"
				else
					trait = "wh_dlc07_trait_brt_knights_vow_chivalry_pledge_agent"
				end
		
				if character:trait_points(trait) > 0 then
					for i = 1, ranks_gained do
						cm:force_add_trait(cm:char_lookup_str(character), trait, false)
					end
				end
			end
		end,
		true
	)
	
	-- Pledge to Knowledge (Agent)
	local function add_pledge_to_knowledge_trait(context)
		if context:mission_result_critial_success() or context:mission_result_success() then
			local character = context:character()
			local trait
			if is_female(character) then
				trait = "wh_dlc07_trait_brt_protection_troth_knowledge_pledge_agent"
			else
				trait = "wh_dlc07_trait_brt_knights_vow_knowledge_pledge_agent"
			end
			if vow_agents[character:character_subtype_key()] and character:trait_points(trait) > 0 then
				cm:force_add_trait(cm:char_lookup_str(character), trait, false)
			end
		end
	end

	core:remove_listener("character_character_target_action_pledge_to_knowledge")
	core:add_listener(
		"character_character_target_action_pledge_to_knowledge",
		"CharacterCharacterTargetAction",
		true,
		function(context)
			add_pledge_to_knowledge_trait(context)
		end,
		true
	)

	core:remove_listener("character_garrison_target_action_pledge_to_knowledge")
	core:add_listener(
		"character_garrison_target_action_pledge_to_knowledge",
		"CharacterGarrisonTargetAction",
		true,
		function(context)
			add_pledge_to_knowledge_trait(context)
		end,
		true
	)
end

cm:add_post_first_tick_callback(init)