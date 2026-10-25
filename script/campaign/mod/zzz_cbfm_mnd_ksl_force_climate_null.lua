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


-- Check these climate suitability tables for Kislev factions.
local mnd_ksl_climates_uninhabitable_boris = {
    "climate_ocean",
    "climate_desert",
    "climate_magicforest"
}
-- IEE mod faction support
local mnd_ksl_climates_uninhabitable_rota = {
    "climate_ocean",
    "climate_desert",
    "climate_magicforest"
}

local mnd_ksl_climates_uninhabitable = {
    "climate_ocean",
    "climate_desert",
    "climate_chaotic",
    "climate_magicforest"
}

local mnd_ksl_climates_unpleasant_boris = {
    "climate_island",
    "climate_jungle",
    "climate_savannah",
    "climate_chaotic"
}
-- IEE mod faction support
local mnd_ksl_climates_unpleasant_rota = {
    "climate_island",
    "climate_jungle",
    "climate_wasteland",
    "climate_savannah"
}

local mnd_ksl_climates_unpleasant = {
    "climate_island",
    "climate_jungle",
    "climate_wasteland",
    "climate_savannah"
}

--Boris and the IEE mod faction have different climate suitabilities.
local mnd_ksl_special_boris = "wh3_main_ksl_ursun_revivalists"
local mnd_ksl_special_rota = "cr_ksl_rota_of_the_dawn"


-- The two effects bundles for unpleasant and uninhabitable.
-- For some reason, cm:apply_effect_bundle_to_region doesn't accept custom bundles from the 
-- bundle maker so they are prefinded in the db fragments.
local mnd_eb_uninhabitable = "mnd_main_effect_ignore_climate_penalties_hidden_forced_ksl"
local mnd_eb_unpleasant = "mnd_main_effect_ignore_climate_penalties_hidden_forced_unsuitable_ksl"
-- Ataman specific versions
local mnd_eb_uninhabitable_ata = "mnd_main_effect_ignore_climate_penalties_hidden_forced_ksl_ata"
local mnd_eb_unpleasant_ata = "mnd_main_effect_ignore_climate_penalties_hidden_forced_unsuitable_ksl_ata"



-- When a game is loaded/initialized, an effects bundle is added to relevant regions/provinces.
local function mnd_ksl_force_climate_nullification_init(supplied_faction)

    local ksl_faction = cm:get_local_faction()
    out("Local Faction is " .. tostring(ksl_faction:name()))
    
    if supplied_faction ~= nil then
        ksl_faction = supplied_faction
        out("Supplied Faction is " .. tostring(ksl_faction:name()))
    end
    out("Faction (final) is " .. tostring(ksl_faction:name()))
    
    local ksl_faction_region_list = ksl_faction:region_list()
    local ksl_faction_char_list = ksl_faction:character_list()
    
    if ksl_faction:subculture() == "wh3_main_sc_ksl_kislev" then
        
        -- Regular factions. Checks for highest tier public order 75-100.
        for i = 0, ksl_faction_region_list:num_items() - 1 do
            local ksl_region_at_i = ksl_faction_region_list:item_at(i)
            local ksl_region_climate = ksl_region_at_i:settlement():get_climate()

            if ksl_region_at_i:public_order() >= 75 and
            ksl_faction:name() ~= mnd_ksl_special_boris and
            ksl_faction:name() ~= mnd_ksl_special_rota and not
            (ksl_region_at_i:has_effect_bundle(mnd_eb_unpleasant) or
            ksl_region_at_i:has_effect_bundle(mnd_eb_uninhabitable)) then
                
                for key, value in pairs(mnd_ksl_climates_uninhabitable) do
                    if ksl_region_climate == value then
                        cm:apply_effect_bundle_to_region(mnd_eb_uninhabitable, ksl_region_at_i:name(), 0)
                        out("MND -Init- temp null climate bundle applied - kislev inhospitable")
                    end
                end
                
                for key, value in pairs(mnd_ksl_climates_unpleasant) do
                    if ksl_region_climate == value then
                        cm:apply_effect_bundle_to_region(mnd_eb_unpleasant, ksl_region_at_i:name(), 0)
                        out("MND -Init- temp null climate bundle applied - kislev unpleasant")
                    end
                end
            end
            
            -- Boris faction. Checks for highest tier public order 75-100.
            if ksl_region_at_i:public_order() >= 75 and
            ksl_faction:name() == mnd_ksl_special_boris and not
            (ksl_region_at_i:has_effect_bundle(mnd_eb_unpleasant) or
            ksl_region_at_i:has_effect_bundle(mnd_eb_uninhabitable)) then
                
                for key, value in pairs(mnd_ksl_climates_uninhabitable_boris) do
                    if ksl_region_climate == value then
                        cm:apply_effect_bundle_to_region(mnd_eb_uninhabitable, ksl_region_at_i:name(), 0)
                        out("MND -Init- temp null climate bundle applied - boris inhospitable")
                    end
                end
                
                for key, value in pairs(mnd_ksl_climates_unpleasant_boris) do
                    if ksl_region_climate == value then
                        cm:apply_effect_bundle_to_region(mnd_eb_unpleasant, ksl_region_at_i:name(), 0)
                        out("MND -Init- temp null climate bundle applied - boris unpleasant")
                    end
                end
            end
            
            -- Rota of Dawn faction. Checks for highest tier public order 75-100.
            if ksl_region_at_i:public_order() >= 75 and
            ksl_faction:name() == mnd_ksl_special_rota and not
            (ksl_region_at_i:has_effect_bundle(mnd_eb_unpleasant) or
            ksl_region_at_i:has_effect_bundle(mnd_eb_uninhabitable)) then
                
                for key, value in pairs(mnd_ksl_climates_uninhabitable_rota) do
                    if ksl_region_climate == value then
                        cm:apply_effect_bundle_to_region(mnd_eb_uninhabitable, ksl_region_at_i:name(), 0)
                        out("MND -Init- temp null climate bundle applied - rota inhospitable")
                    end
                end
                
                for key, value in pairs(mnd_ksl_climates_unpleasant_rota) do
                    if ksl_region_climate == value then
                        cm:apply_effect_bundle_to_region(mnd_eb_unpleasant, ksl_region_at_i:name(), 0)
                        out("MND -Init- temp null climate bundle applied - rota unpleasant")
                    end
                end
            end
                
            -- Removes all bundles when PO is below threshold.
            if ksl_region_at_i:public_order() < 75 then
                if ksl_region_at_i:has_effect_bundle(mnd_eb_unpleasant) or ksl_region_at_i:has_effect_bundle(mnd_eb_uninhabitable) then
                    cm:remove_effect_bundle_from_region(mnd_eb_unpleasant, ksl_region_at_i:name())
                    cm:remove_effect_bundle_from_region(mnd_eb_uninhabitable, ksl_region_at_i:name())
                    out("MND -Init- temp null climate bundle removed - kislev")
                end
            end
        end
        
        -- Ataman check.
        for i = 0, ksl_faction_char_list:num_items() - 1 do
            
            local ksl_char_at_i = ksl_faction_char_list:item_at(i)
            local ksl_char_at_i_province_region_list = ksl_char_at_i:region():province():regions()
            
            if ksl_char_at_i:has_skill("wh3_main_skill_ksl_ataman_unique_1") and
            ksl_char_at_i:character_subtype("wh3_main_ksl_ataman") and
            ksl_char_at_i:has_region() and not
            ksl_char_at_i:is_wounded() then
            
                out("MND -Init- ataman check running")
                mnd_ksl_force_climate_nullification_ataman_check(ksl_faction, ksl_char_at_i_province_region_list)
            end
        end
        
    end
    
end

-- Single province check for Atamans.
-- A Ataman-specific bundle will be applied for 1 turn every turn as long as they remain governor of the province
-- and the Public Order bonus isn't already applied.
function mnd_ksl_force_climate_nullification_ataman_check(supplied_faction, supplied_province_region_list)

    local ksl_faction = supplied_faction

    local unsuitable = "_climate_unsuitable"
    local uninhabitable = "_climate_uninhabitable"
    local province_regions_list = supplied_province_region_list
        
    for i = 0, province_regions_list:num_items() - 1 do
        local region_at_i = province_regions_list:item_at(i)
        local region_bundles = region_at_i:effect_bundles()
        
        for i = 0, region_bundles:num_items() - 1 do
            local region_bundle_at_i = region_bundles:item_at(i)
            out("MND -Ataman Check- begin partial string search")
            
            if string.find(region_bundle_at_i:key(), unsuitable) and
            region_at_i:owning_faction():name() == ksl_faction:name() and not
            (region_at_i:has_effect_bundle(mnd_eb_unpleasant) or
            region_at_i:has_effect_bundle(mnd_eb_uninhabitable)) then
                out("MND -Ataman Check- partial string match unsuitable, bundle applied")
                cm:apply_effect_bundle_to_region(mnd_eb_unpleasant_ata, region_at_i:name(), 1)
            end
            
            if string.find(region_bundle_at_i:key(), uninhabitable) and
            region_at_i:owning_faction():name() == ksl_faction:name() and not
            (region_at_i:has_effect_bundle(mnd_eb_unpleasant) or
            region_at_i:has_effect_bundle(mnd_eb_uninhabitable)) then
                out("MND -Ataman Check- partial string match uninhabitable, bundle applied")
                cm:apply_effect_bundle_to_region(mnd_eb_uninhabitable_ata, region_at_i:name(), 1)
            end
            
            if not string.find(region_bundle_at_i:key(), unsuitable) and not
            string.find(region_bundle_at_i:key(), uninhabitable) then
                out("MND -Ataman Check- no partial string match, climate is already suitable, no bundle applied")
            end
        end
    end
end

-- Recheck at faction turn start.
function mnd_ksl_force_climate_nullification_turn_start()

    core:add_listener(
        "mnd_ksl_force_climate_null_new_turn_update",
        "FactionTurnStart",
        function(context)
            local ksl_faction = context:faction()
            return ksl_faction:subculture() == "wh3_main_sc_ksl_kislev"
        end,
        function(context)
            mnd_ksl_force_climate_nullification_init(ksl_faction)
        end,
        true
    )

end

-- Handles region ownership changes.
function mnd_ksl_force_climate_nullification_region_exchanged()

    -- Lose a settlement.
    core:add_listener(
        "mnd_ksl_force_climate_null_region_lost",
        "RegionFactionChangeEvent",
        function(context)
            return context:previous_faction():subculture() == "wh3_main_sc_ksl_kislev"
        end,
        function(context)
            local former_ksl_region = context:region()
            out ("MND -Lost Settlement- started")
            cm:remove_effect_bundle_from_region(mnd_eb_unpleasant, former_ksl_region:name())
            cm:remove_effect_bundle_from_region(mnd_eb_uninhabitable, former_ksl_region:name())
            out("MND -Lost Settlement - temp null climate bundle removed from region")
        end,
        true
    )
    
    -- Gain a settlement.
    -- Uses partial string search of climate bundles used by the game to determine per faction 
    -- suitability for regions instead of checking a table. Three different suitabilities is a 
    -- headache to manage (regular, boris, rota).
    core:add_listener(
        "mnd_ksl_force_climate_null_region_gained",
        "RegionFactionChangeEvent",
        function(context)
            return context:region():owning_faction():subculture() == "wh3_main_sc_ksl_kislev"
        end,
        function(context)
            local ksl_region = context:region()
            local unsuitable = "_climate_unsuitable"
            local uninhabitable = "_climate_uninhabitable"
            local province_regions_list = context:region():province():regions()
            
            if ksl_region:public_order() >= 75 and not
            (ksl_region:has_effect_bundle(mnd_eb_unpleasant) or
            ksl_region:has_effect_bundle(mnd_eb_uninhabitable)) then
                
                for i = 0, province_regions_list:num_items() - 1 do
                    local region_at_i = province_regions_list:item_at(i)
                    local region_bundles = region_at_i:effect_bundles()
                    
                    for i = 0, region_bundles:num_items() - 1 do
                        local region_bundle_at_i = region_bundles:item_at(i)
                        out("MND -Gained Settlment- begin partial string search")
                        
                        if string.find(region_bundle_at_i:key(), unsuitable) and
                        region_at_i:owning_faction():name() == ksl_region:owning_faction():name() then
                            out("MND partial string match unsuitable, bundle applied")
                            cm:apply_effect_bundle_to_region(mnd_eb_unpleasant, region_at_i:name(), 0)
                        end
                        
                        if string.find(region_bundle_at_i:key(), uninhabitable) and
                        region_at_i:owning_faction():name() == ksl_region:owning_faction():name() then
                            out("MND partial string match uninhabitable, bundle applied")
                            cm:apply_effect_bundle_to_region(mnd_eb_uninhabitable, region_at_i:name(), 0)
                        end
                    end
                end
                
            elseif ksl_region:public_order() < 75 then
                if ksl_region:has_effect_bundle(mnd_eb_unpleasant) or ksl_region:has_effect_bundle(mnd_eb_uninhabitable) then
                    cm:remove_effect_bundle_from_region(mnd_eb_unpleasant, ksl_region:name())
                    cm:remove_effect_bundle_from_region(mnd_eb_uninhabitable, ksl_region:name())
                    out("MND -Gained Settlement- public order too low, temp climate bundle removed from region")
                end
            end
        end,
        true
    )

end

-- Checks for Atamans with the skill that nullifies climate "Groundbreaker".
-- Not perfect as there is no way to immediately update when newly assigned/replaced.
function mnd_ksl_force_climate_nullification_ataman()

    core:add_listener(
        "mnd_ataman_skill_allocated",
        "CharacterSkillPointAllocated",
        function(context)
            local character = context:character()
            return context:skill_point_spent_on() == "wh3_main_skill_ksl_ataman_unique_1" and
            character:character_subtype("wh3_main_ksl_ataman") and
             -- has_region being true means they are assigned as a governor
            character:has_region() and not
            character:is_wounded()
        end,
        function(context)
            local character = context:character()
            local ksl_faction = character:faction()
            local ksl_region = character:region()
            local province_regions_list = ksl_region:province():regions()
            
            mnd_ksl_force_climate_nullification_ataman_check(ksl_faction, province_regions_list)
        end,
        true
    )

    core:add_listener(
        "mnd_ataman_character_turn_start",
        "CharacterTurnStart",
        function(context)
            local character = context:character()
            return character:character_subtype("wh3_main_ksl_ataman") and
            character:has_skill("wh3_main_skill_ksl_ataman_unique_1") and
             -- has_region being true means they are assigned as a governor
            character:has_region() and not
            character:is_wounded()
        end,
        function(context)
            local character = context:character()
            local ksl_faction = character:faction()
            local ksl_region = character:region();
            local province_regions_list = ksl_region:province():regions()
            
            mnd_ksl_force_climate_nullification_ataman_check(ksl_faction, province_regions_list)
        end,
        true
    )
    
end

-- Testing/debug stuff. 
-- Uncomment the callback at bottom of lua file to raise Public Order when selecting regions.
function mnd_ksl_force_climate_nullification_debug()

    core:add_listener(
        "mnd_ksl_force_climate_null_po_test",
        "SettlementSelected",
        function(context)
            return context:garrison_residence():faction():subculture() == "wh3_main_sc_ksl_kislev"
        end,
        function(context)
            local ksl_faction = context:garrison_residence():faction()
            local ksl_faction_region_list = ksl_faction:region_list()
            local ksl_region = context:garrison_residence():region()
            
            -- Instant PO for testing/debug.
            cm:set_public_order_of_province_for_region(ksl_region:name(), 95)
        end,
        true
    )
    
end


cm:add_post_first_tick_callback(function() mnd_ksl_force_climate_nullification_init() end)
cm:add_post_first_tick_callback(mnd_ksl_force_climate_nullification_turn_start)
cm:add_post_first_tick_callback(mnd_ksl_force_climate_nullification_ataman)
cm:add_post_first_tick_callback(mnd_ksl_force_climate_nullification_region_exchanged)
--cm:add_post_first_tick_callback(mnd_ksl_force_climate_nullification_debug)