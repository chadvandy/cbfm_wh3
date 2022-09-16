cbfm_chs_mil_tech_init_eb_table = {}
cbfm_chs_mil_tech_init_faction_info_table = 
{
	["wh3_dlc20_chs_valkia"] = {["tech"] = "wh3_dlc20_chs_kho_valkia_military_1",["init_set"] = "wh3_dlc20_faction_initiative_set_chs_khorne",["effect_bundle"] = "CBFM_upgrade_all_kho_weapon_strength",["base_value"] = 5},
	["wh3_dlc20_chs_azazel"] = {["tech"] = "wh3_dlc20_chs_sla_azazel_military_1",["init_set"] = "wh3_dlc20_faction_initiative_set_chs_slaanesh",["effect_bundle"] = "CBFM_upgrade_all_nur_healing_cap",["base_value"] = 5},
	["wh3_dlc20_chs_vilitch"] = {["tech"] = "wh3_dlc20_chs_tze_vilitch_military_1",["init_set"] = "wh3_dlc20_faction_initiative_set_chs_tzeentch",["effect_bundle"] = "CBFM_upgrade_all_tze_physical_resistance",["base_value"] = 3},
	["wh3_dlc20_chs_festus"] = {["tech"] = "wh3_dlc20_chs_nur_festus_military_1",["init_set"] = "wh3_dlc20_faction_initiative_set_chs_nurgle",["effect_bundle"] = "CBFM_upgrade_all_sla_speed",["base_value"] = 10}
}


function cbfm_chs_mil_tech_init_update(faction)

	--ModLog("DUX: cbfm_chs_mil_tech_init_update function started with parameter " .. tostring(faction))
	
	local faction_entry = cbfm_chs_mil_tech_init_faction_info_table[faction]
	
	-- if an invalid faction was passed or we don't have the right tech, we can stop right here
	if not faction_entry then
		--ModLog("DUX: invalid parameter or non-applicable faction, exiting")
		return nil 
	end
	if not cm:get_faction(faction):has_technology(faction_entry.tech) then
		--ModLog("DUX: required tech not unlocked yet, exiting")
		return nil
	end
	
	-- create our custom effect bundle interface if it doesn't already exist
	if not cbfm_chs_mil_tech_init_eb_table[faction] then 
		--ModLog("DUX: custom effect bundle not yet created for " .. faction .. ", creating now")
		cbfm_chs_mil_tech_init_eb_table[faction] = cm:create_new_custom_effect_bundle(faction_entry.effect_bundle)
	else
		--ModLog("DUX: custom effect bundle already created for " .. faction .. ", using existing bundle")
	end
	
	-- call upon the forces of CCO to get active faction initiative data
	local num_initiative_sets = common.get_context_value("CcoCampaignFaction",faction,"InitiativeSetList.Size")
	local num_active = 0
	
	for i = 0, (num_initiative_sets - 1) do
		local set_to_check = common.get_context_value("CcoCampaignFaction",faction,("InitiativeSetList[" .. tostring(i) .. "].InitiativeSetContext.Key"))
		if set_to_check == faction_entry.init_set then
			num_active = common.get_context_value("CcoCampaignFaction",faction,("InitiativeSetList[" .. tostring(i) .. "].ActiveInitiatives.Size"))
			--ModLog("DUX: valid initiative set found with " .. tostring(num_active) .. " initiatives active")
		end
	end
	
	if num_active == 0 then ModLog("DUX: no active initatives were found, setting effect value for " .. faction .. " to zero") end
	
	-- modify our effect bundle as required
	local effect = cbfm_chs_mil_tech_init_eb_table[faction]:effects():item_at(0) -- there is only one effect in each of these bundles
	cbfm_chs_mil_tech_init_eb_table[faction]:set_effect_value(effect,(faction_entry.base_value * num_active))
	
	-- apply our effect bundle
	--ModLog("DUX: custom effect bundle now being applied for " .. faction)
	cm:apply_custom_effect_bundle_to_faction(cbfm_chs_mil_tech_init_eb_table[faction],(cm:get_faction(faction)))
end

for faction, v in pairs(cbfm_chs_mil_tech_init_faction_info_table) do
	cm:add_first_tick_callback(function() cbfm_chs_mil_tech_init_update(faction) end)
	cm:add_faction_turn_start_listener_by_name("cbfm_chs_mil_tech_init_listener",faction,function() cbfm_chs_mil_tech_init_update(faction) end,true)
end