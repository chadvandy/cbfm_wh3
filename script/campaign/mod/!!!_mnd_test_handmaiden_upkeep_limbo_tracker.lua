-- Characters in limbo (off-map running a coven, etc) don't have their factionwide effects from traits applied.
-- Limbo seems to ignore the distinction made between the scope locations factionwide/factionwide_when_on_map
-- that were added in 6.0/7.0 to handle this in a clear manner.
-- This limbo feature has been built out heavily with 9.0; its now used by Nagash mortarchs, Thanquol's schemers,
-- Ulric decrees... so its likely that problems with it will be more noticeable to the player.
-- Lahmian Handmaidens get a trait through technology that grants -1% upkeep factionwide (for units), but it doesn't
-- apply when in this limbo state, except for the brief time they are on the campaign map.
-- This script monitors the game's own tracking system of coven region/character_cqi key value pairs to apply
-- and update an effects bundle that grants the appropriate upkeep reduction for each Handmaiden currently in a limbo.
-- The effect bundle is visible for testing, but the final seamless version would be hidden by unchecking
-- "is global effect" in effect_bundles_tables.


local mnd_nef_faction = "wh3_dlc29_vmp_neferata"

-- Use a partial string match to handle the multiple subtypes.
local mnd_nef_hm_subtype_partial = "dlc29_vmp_handmai"
                                 --"wh3_dlc29_vmp_handmaiden"
                                 --"wh3_dlc29_vmp_handmaiden_imentet"


-- Counts the number of handmaidens in limbo, multiplies it by an upkeep value and returns thes results.
-- For some reason this function needs to hooked into "vampire_covens" using colon syntax to see the table.
function vampire_covens:mnd_count_handmaidens_in_limbo()
    local mnd_upkeep_reduction_value = -1 -- -1; for testing purposes, using a larger value
    local mnd_amount_in_limbo = 0
    
    -- Count entries in handmaiden tracker table.
    for k,v in pairs(self.handmaiden_tracker) do
		mnd_amount_in_limbo = mnd_amount_in_limbo + 1
		out("MND TEST iterate - "..k..", "..v)
	end
	
    local mnd_returned_amount = mnd_amount_in_limbo
    out("MND TEST - "..mnd_returned_amount)
    local mnd_returned_amount_with_upkeep = mnd_amount_in_limbo*mnd_upkeep_reduction_value
    out("MND TEST - "..mnd_returned_amount_with_upkeep)
        
	-- Return values for number of handmaidens and that number times upkeep reduction.
	return {
        mnd_returned_amount, --[1]
        mnd_returned_amount_with_upkeep --[2]
        }
end

-- Apply/reapply a hidden effect bundle that grants the upkeep reduction when handmaidens are in limbo.
local function mnd_handmaiden_limbo_apply_bundle()
    -- Run the handmaiden counting function to get the number of handmaidens in limbo and the upkeep reduction.
    local mnd_limbo_count_returns = vampire_covens:mnd_count_handmaidens_in_limbo()
    local mnd_amount = mnd_limbo_count_returns[1]
    local mnd_amount_upkeep = mnd_limbo_count_returns[2]
    
    -- Create the custom effects bundle and assign effects.
	local mnd_handmaiden_limbo_tracker_effects_bundle = cm:create_new_custom_effect_bundle("mnd_handmaiden_limbo_tracker_effects")
	mnd_handmaiden_limbo_tracker_effects_bundle:add_effect("wh_main_effect_force_all_campaign_upkeep", "faction_to_force_own_alt_text", (0+mnd_amount_upkeep))
	mnd_handmaiden_limbo_tracker_effects_bundle:add_effect("mnd_limbo_vampire_counter", "faction_to_faction_own_unseen", (mnd_amount))
    
    -- Always remove existing bundle and reapply it.
    cm:remove_effect_bundle("mnd_handmaiden_limbo_tracker_effects", mnd_nef_faction)
    
    -- Add bundle if the value is not 0, meaning there are one or more entries in the handmaiden tracker table.
    if mnd_amount ~= 0 then
        cm:apply_custom_effect_bundle_to_faction(mnd_handmaiden_limbo_tracker_effects_bundle, cm:get_faction(mnd_nef_faction))
        out("MND TEST - Handmaidens in limbo ".. tostring(mnd_amount))
    end
    -- Otherwise do nothing, the bundle is already removed, no handmaidens in limbo.
    if mnd_amount == 0 then
        out("MND TEST - No Handmaidens in limbo ".. tostring(mnd_amount))
    end
end

--Listens for handmaidens going in and out of limbo by subtype and whether the technology that grants the trait is unlocked.
local function mnd_handmaiden_limbo_listeners()
	core:add_listener(
		"MND_HANDMAIDEN_ENTERS_LIMBO",
		"CharacterEntersLimboEvent",
		function(context)
            -- Partial match on subtype key because there is a special version for Imentet.
            -- Note to self: use character_subtype_key for comparisons; character_subtype is a boolean
			return context:character():faction():name() == mnd_nef_faction and
			string.find(context:character():character_subtype_key(), mnd_nef_hm_subtype_partial)
		end,
        function(context)
        -- Wait 1 full second for the game to update its own handmaiden tracker before the bundle function starts its count.
        -- Otherwise it will count before the game updates the table and result in no change to number of limbo'd characters.
            if context:character():faction():has_technology("wh3_dlc29_tech_nef_covens_2c") then
                cm:callback(
                    function()
                        mnd_handmaiden_limbo_apply_bundle()
                        out("MND TEST - Handmaiden entered limbo, counting again")
                    end,
                1)
            end
        end,
		true
	)

	core:add_listener(
		"MND_HANDMAIDEN_EXITS_LIMBO",
		"CharacterExitsLimboEvent",
		function(context)
			return context:character():faction():name() == mnd_nef_faction and
			context:character():faction():has_technology("wh3_dlc29_tech_nef_covens_2c") and
			string.find(context:character():character_subtype_key(), mnd_nef_hm_subtype_partial)
		end,
		function(context)
            if context:character():faction():has_technology("wh3_dlc29_tech_nef_covens_2c") then
                cm:callback(
                    function()
                        mnd_handmaiden_limbo_apply_bundle()
                        out("MND TEST - Handmaiden left limbo, counting again")
                    end,
                1)
            end
		end,
		true
	)
end

-- Game state initialization (loading a game).
cm:add_post_first_tick_callback(function() mnd_handmaiden_limbo_apply_bundle() end)
-- Listeners for ongoing events (forming new covens, evacuating existing covens).
cm:add_post_first_tick_callback(function() mnd_handmaiden_limbo_listeners() end)