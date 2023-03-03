local function init()
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
		"wh_dlc07_trait_brt_knights_vow_order_pledge",
		"wh_dlc07_trait_brt_knights_vow_chivalry_pledge",
		"wh_dlc07_trait_brt_protection_troth_knowledge_pledge",
		"wh_dlc07_trait_brt_protection_troth_order_pledge",
		"wh_dlc07_trait_brt_protection_troth_chivalry_pledge"
	}
	local questing_wisdom = 
	{
		"wh_dlc07_trait_brt_questing_vow_campaign_pledge",
		"wh_dlc07_trait_brt_questing_vow_heroism_pledge",
		"wh_dlc07_trait_brt_questing_vow_protect_pledge",
		"wh_dlc07_trait_brt_wisdom_troth_campaign_pledge",
		"wh_dlc07_trait_brt_wisdom_troth_heroism_pledge",
		"wh_dlc07_trait_brt_wisdom_troth_protect_pledge"
	}
	local grail_virtue = 
	{
		"wh_dlc07_trait_brt_grail_vow_untaint_pledge",
		"wh_dlc07_trait_brt_grail_vow_valour_pledge",
		"wh_dlc07_trait_brt_grail_vow_destroy_pledge",
		"wh_dlc07_trait_brt_virtue_troth_untaint_pledge",
		"wh_dlc07_trait_brt_virtue_troth_valour_pledge",
		"wh_dlc07_trait_brt_virtue_troth_destroy_pledge"
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
	true,
	function(context)
		local character = context:character()
		local faction = character:faction()
		
		if not faction:is_human() and faction:culture() == "wh_main_brt_bretonnia" and character:character_type("general") then
			local rank = character:rank()
			
			if rank >= 2 and not has_pledge(character,knights_protection) then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", true, false)
				end
			elseif rank >= 5 and not has_pledge(character,questing_wisdom) then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_questing_vow_protect_pledge", true, false)
				end
			elseif rank >= 10 and not has_pledge(character,grail_virtue) then
				for i = 1, 6 do
					add_vow_progress(character, "wh_dlc07_trait_brt_grail_vow_valour_pledge", true, false)
				end
			end
		end
	end,
	true
)
end

cm:add_post_first_tick_callback(init)