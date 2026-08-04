----------------------------------------------------------------------------------------------------------
-- A notable bug with the Lizardmen tier 4-5 settlement climate nullification effect granted by the tech 
-- "Determining the Great Plan" is that it takes one turn to become active and resets itself after
-- loading a save or entering/exiting a battle. Most of the time it is competely non-functional.

-- This same issue impacts Kislev's highest public order bonus and the Ataman skill "Groundbreaker".

-- The particulars of the bonus_value_id "ignore_climate_bundle" used by 
-- "wh3_main_effect_ignore_climate_penalties" aren't exposed, so it can't be directly addressed, but
-- this mod disables CA's climate nullification system and use scripts entirely, leaving the dummy
-- text on the buildings/PO effects.
----------------------------------------------------------------------------------------------------------


-- Check these climate suitability tables for Lizardmen (except Oxoytl, no climate prefs).
local mnd_lzd_climates_uninhabitable = {
    "climate_ocean",
    "climate_wasteland",
    "climate_chaotic",
    "climate_frozen"
}

local mnd_lzd_climates_unpleasant = {
    "climate_island",
    "climate_magicforest",
    "climate_mountain",
    "climate_temperate"
}

-- The two effects bundles for unpleasant and uninhabitable.
-- For some reason, cm:apply_effect_bundle_to_region doesn't accept custom bundles from the 
-- bundle maker so they are prefinded in the db fragments.
local mnd_eb_uninhabitable = "mnd_main_effect_ignore_climate_penalties_hidden_forced_lzd"
local mnd_eb_unpleasant = "mnd_main_effect_ignore_climate_penalties_hidden_forced_unsuitable_lzd"


-- All faction regions and checked and climate null effects bundles are added to relevant regions/provinces.
local function mnd_lzd_force_climate_nullification_init(supplied_faction)

    local lzd_faction = cm:get_local_faction()
    out("Local Faction is " .. tostring(lzd_faction:name()))
    
    if supplied_faction ~= nil then
        lzd_faction = supplied_faction
        out("Supplied Faction is " .. tostring(lzd_faction:name()))
    end
    out("Local Faction is " .. tostring(lzd_faction:name()))
    
    local lzd_faction_region_list = lzd_faction:region_list()
    
    if lzd_faction:has_technology("wh2_main_tech_lzd_0_2") and lzd_faction:name() ~= "wh2_dlc17_lzd_oxyotl" then
        
        for i = 0, lzd_faction_region_list:num_items() - 1 do
            local lzd_region_at_i = lzd_faction_region_list:item_at(i)
            local province_cap_level = lzd_region_at_i:province():capital_region():settlement():primary_slot():building():building_level()
            local province_cap_bldng = lzd_region_at_i:province():capital_region():settlement():primary_slot():building()
            local lzd_region_climate = lzd_region_at_i:settlement():get_climate()

            if province_cap_level > 3 and not
                (lzd_region_at_i:has_effect_bundle(mnd_eb_unpleasant) or 
                lzd_region_at_i:has_effect_bundle(mnd_eb_uninhabitable)) then
                
                for key, value in pairs(mnd_lzd_climates_uninhabitable) do
                    if lzd_region_climate == value then
                        cm:apply_effect_bundle_to_region(mnd_eb_uninhabitable, lzd_region_at_i:name(), 0)
                        out("MND -Init- temp null climate bundle applied - inhospitable")
                    end
                end
                
                for key, value in pairs(mnd_lzd_climates_unpleasant) do
                    if lzd_region_climate == value then
                        cm:apply_effect_bundle_to_region(mnd_eb_unpleasant, lzd_region_at_i:name(), 0)
                        out("MND -Init- temp null climate bundle applied - unpleasant")
                    end
                end
                
            elseif province_cap_level < 4 then
                if lzd_region_at_i:has_effect_bundle(mnd_eb_unpleasant) or lzd_region_at_i:has_effect_bundle(mnd_eb_uninhabitable) then
                    cm:remove_effect_bundle_from_region(mnd_eb_unpleasant, lzd_region_at_i:name())
                    cm:remove_effect_bundle_from_region(mnd_eb_uninhabitable, lzd_region_at_i:name())
                    out("MND -Init- temp null climate bundle removed")
                end
            end
        end
    end
end

-- Checks a single province.
local function mnd_lzd_force_climate_nullification_province_check(supplied_faction, supplied_province_region_list)

    local lzd_faction = supplied_faction
    local lzd_province_region_list = supplied_province_region_list
    
    for i = 0, lzd_province_region_list:num_items() - 1 do
        local lzd_region_at_i = lzd_province_region_list:item_at(i)
        local province_cap_level = lzd_region_at_i:province():capital_region():settlement():primary_slot():building():building_level()
        local province_cap_bldng = lzd_region_at_i:province():capital_region():settlement():primary_slot():building()
        local lzd_region_climate = lzd_region_at_i:settlement():get_climate()

        if province_cap_level > 3 and lzd_faction:name() ~= "wh2_dlc17_lzd_oxyotl" and not
            (lzd_region_at_i:has_effect_bundle(mnd_eb_unpleasant) or
            lzd_region_at_i:has_effect_bundle(mnd_eb_uninhabitable)) then
            
            for key, value in pairs(mnd_lzd_climates_uninhabitable) do
                if lzd_region_climate == value then
                    cm:apply_effect_bundle_to_region(mnd_eb_uninhabitable, lzd_region_at_i:name(), 0)
                    out("MND -Capital Region Sacked- temp null climate bundle maintained/applied - inhospitable")
                end
            end
            
            for key, value in pairs(mnd_lzd_climates_unpleasant) do
                if lzd_region_climate == value then
                    cm:apply_effect_bundle_to_region(mnd_eb_unpleasant, lzd_region_at_i:name(), 0)
                    out("MND -Capital Region Sacked- temp null climate bundle maintained/applied - unpleasant")
                end
            end
            
        elseif province_cap_level < 4 then
            if lzd_region_at_i:has_effect_bundle(mnd_eb_unpleasant) or lzd_region_at_i:has_effect_bundle(mnd_eb_uninhabitable) then
                cm:remove_effect_bundle_from_region(mnd_eb_unpleasant, lzd_region_at_i:name())
                cm:remove_effect_bundle_from_region(mnd_eb_uninhabitable, lzd_region_at_i:name())
                out("MND -Capital Region Sacked below tier 4- temp null climate bundle removed")
            end
        end
    end
end

-- Recheck at new turn start, to account for building upgrades, etc.
function mnd_lzd_force_climate_nullification_turn_start()

    core:add_listener(
        "mnd_lzd_force_climate_null_new_turn_update",
        "FactionTurnStart",
        function(context)
            local lzd_faction = context:faction()
            return lzd_faction:subculture() == "wh2_main_sc_lzd_lizardmen" and
            lzd_faction:has_technology("wh2_main_tech_lzd_0_2")
        end,
        function(context)
            mnd_lzd_force_climate_nullification_init(lzd_faction)
        end,
        true
    )

end

-- Region downgraded.
-- If a province capital is sacked and downgraded below level 4, update bundles for regions in that province.
-- This would likely already be covered by FactionTurnStart, but faction would get a free turn of climate 
-- nullification during the end turn phase.
function mnd_lzd_force_climate_nullification_settlement_downgraded()

    core:add_listener(
        "mnd_lzd_force_climate_null_sacked",
        "CharacterSackedSettlement",
        function(context)
            local enemy_char = context:character()
            return context:garrison_residence():faction():subculture() == "wh2_main_sc_lzd_lizardmen" and
            context:garrison_residence():faction():has_technology("wh2_main_tech_lzd_0_2")
        end,
        function(context)
            local lzd_faction = context:garrison_residence():faction()
            local province_region_list = context:garrison_residence():region():province():regions()
            mnd_lzd_force_climate_nullification_province_check(lzd_faction, province_region_list)
        end,
        true
    )
    
    core:add_listener(
        "mnd_lzd_force_climate_null_DOOOM_engineer",
        "CharacterGarrisonTargetAction",
        function(context)
            return context:character():subtype() == "wh2_main_skv_warlock_engineer_ritual" and
            context:garrison_residence():faction():has_technology("wh2_main_tech_lzd_0_2")
        end,
        function(context)
            local lzd_faction = context:garrison_residence():faction()
            local province_region_list = context:garrison_residence():region():province():regions()
            mnd_lzd_force_climate_nullification_province_check(lzd_faction, province_region_list)
        end,
        true
    )

end

-- Region ownership changes.
function mnd_lzd_force_climate_nullification_region_exchanged()

    -- Lose a settlement.
    -- For minor regions, any bundle is simply removed. For capitals, a check is performed on all regions in province.
    core:add_listener(
        "mnd_lzd_force_climate_null_region_lost",
        "RegionFactionChangeEvent",
        function(context)
            return context:previous_faction():subculture() == "wh2_main_sc_lzd_lizardmen" --[[and 
                   context:previous_faction():has_technology("wh2_main_tech_lzd_0_2") and
                   context:previous_faction():name() ~= "wh2_dlc17_lzd_oxyotl" and
                   context:region():owning_faction():subculture() ~= "wh2_main_sc_lzd_lizardmen" ]]
        end,
        function(context)
            local former_lzd_region = context:region()
            local province_regions_list = context:region():province():regions()
            out ("MND -Lost Settlement- started")
            
            -- if province capital is lost, remove all climate null bundles from regions in that province
            if former_lzd_region:is_province_capital() --[[ and
                (former_lzd_region:has_effect_bundle(mnd_eb_unpleasant) or 
                former_lzd_region:has_effect_bundle(mnd_eb_uninhabitable)) ]] then
                out ("MND -Lost Settlement- capital region")
                
                for i = 0, province_regions_list:num_items() - 1 do
                    local region_at_i = province_regions_list:item_at(i)
                    cm:remove_effect_bundle_from_region(mnd_eb_unpleasant, region_at_i:name())
                    cm:remove_effect_bundle_from_region(mnd_eb_uninhabitable, region_at_i:name())
                    out("MND -Lost Settlement Capital- temp null climate bundle removed from all regions in province")
                end
            end
            -- if not province capital, remove any bundles from that region
            if not context:region():is_province_capital() then
                    cm:remove_effect_bundle_from_region(mnd_eb_unpleasant, former_lzd_region:name())
                    cm:remove_effect_bundle_from_region(mnd_eb_uninhabitable, former_lzd_region:name())
                    out("MND -Lost Settlement- temp null climate bundle removed from region")
            end
        end,
        true
    )
    
    -- Gain a settlement.
    -- Uses a partial string search on the faction based region climate bundles that are already placed 
    -- by the game to determine climate and assign corresponding bundle.
    core:add_listener(
        "mnd_lzd_force_climate_null_region_gained",
        "RegionFactionChangeEvent",
        function(context)
            return context:region():owning_faction():subculture() == "wh2_main_sc_lzd_lizardmen" and 
                   context:region():owning_faction():has_technology("wh2_main_tech_lzd_0_2") and
                   context:region():owning_faction():name() ~= "wh2_dlc17_lzd_oxyotl"
        end,
        function(context)
            local lzd_region = context:region()
            local unsuitable = "_climate_unsuitable"
            local uninhabitable = "_climate_uninhabitable"
            local region_bundles = context:region():effect_bundles()
            local province_cap_level = context:region():province():capital_region():settlement():primary_slot():building():building_level()
            local province_regions_list = context:region():province():regions()
            
            if province_cap_level > 3 and not
                (lzd_region:has_effect_bundle(mnd_eb_unpleasant) or 
                lzd_region:has_effect_bundle(mnd_eb_uninhabitable)) then
                
                for i = 0, province_regions_list:num_items() - 1 do
                    local region_at_i = province_regions_list:item_at(i)
                    local region_bundles = region_at_i:effect_bundles()
                    
                    for i = 0, region_bundles:num_items() - 1 do
                        local region_bundle_at_i = region_bundles:item_at(i)
                        out("MND -Gained Settlment- begin partial string search")
                        
                        if string.find(region_bundle_at_i:key(), unsuitable) and
                        region_at_i:owning_faction():name() == lzd_region:owning_faction():name() then
                            out("MND partial string match unsuitable, bundle applied")
                            cm:apply_effect_bundle_to_region(mnd_eb_unpleasant, region_at_i:name(), 0)
                        end
                        
                        if string.find(region_bundle_at_i:key(), uninhabitable) and
                        region_at_i:owning_faction():name() == lzd_region:owning_faction():name() then
                            out("MND partial string match uninhabitable, bundle applied")
                            cm:apply_effect_bundle_to_region(mnd_eb_uninhabitable, region_at_i:name(), 0)
                        end
                    end
                end
                
            elseif province_cap_level < 4 then
                if lzd_region:has_effect_bundle(mnd_eb_unpleasant) or lzd_region:has_effect_bundle(mnd_eb_uninhabitable) then
                    cm:remove_effect_bundle_from_region(mnd_eb_unpleasant, lzd_region:name())
                    cm:remove_effect_bundle_from_region(mnd_eb_uninhabitable, lzd_region:name())
                    out("MND -Gained Settlement- temp null climate bundle removed from region")
                end
            end
        end,
        true
    )

end


cm:add_post_first_tick_callback(function() mnd_lzd_force_climate_nullification_init() end)
cm:add_post_first_tick_callback(mnd_lzd_force_climate_nullification_turn_start)
cm:add_first_tick_callback(mnd_lzd_force_climate_nullification_region_exchanged)
cm:add_first_tick_callback(mnd_lzd_force_climate_nullification_settlement_downgraded)