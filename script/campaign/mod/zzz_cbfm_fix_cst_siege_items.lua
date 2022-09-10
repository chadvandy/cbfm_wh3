local function cbfm_vampire_coast_tower_fix()
	local custom_eb = cm:create_new_custom_effect_bundle("wh2_dlc11_faction_trait_vampire_coast")
	-- add our custom effect that adds the correct siege towers
	custom_eb:add_effect("CBFM_wh2_dlc11_effect_siege_engine_number_cst_siege_tower","faction_to_force_own",2)	

	local harkon = cm:get_faction("wh2_dlc11_cst_vampire_coast")
	if not harkon then return end

    cm:apply_custom_effect_bundle_to_faction(custom_eb,harkon)
	
	local all_coast = harkon:factions_of_same_subculture()
     
	---@param coast FACTION_SCRIPT_INTERFACE
	for i, coast in model_pairs(all_coast) do
		cm:apply_custom_effect_bundle_to_faction(custom_eb, coast)
	end
end

cm:add_first_tick_callback(cbfm_vampire_coast_tower_fix)