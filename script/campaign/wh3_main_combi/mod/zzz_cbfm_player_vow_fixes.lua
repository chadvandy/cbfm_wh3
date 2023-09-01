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
end

cm:add_post_first_tick_callback(init)