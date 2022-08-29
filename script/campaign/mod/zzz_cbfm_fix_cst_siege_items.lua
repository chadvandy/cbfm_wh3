local function cbfm_vampire_coast_tower_fix()
	local custom_eb = cm:create_new_custom_effect_bundle("wh2_dlc11_faction_trait_vampire_coast")
	
	-- all vamp coast factions except for rebels and rogues
	local sartosa = cm:get_faction("wh2_dlc11_cst_pirates_of_sartosa")
	local noctilus = cm:get_faction("wh2_dlc11_cst_noctilus")
	local drowned = cm:get_faction("wh2_dlc11_cst_the_drowned")
	local harkon = cm:get_faction("wh2_dlc11_cst_vampire_coast")
	local sartosa_sep = cm:get_faction("wh2_dlc11_cst_pirates_of_sartosa_separatists")
	local noctilus_sep = cm:get_faction("wh2_dlc11_cst_noctilus_separatists")
	local drowned_sep = cm:get_faction("wh2_dlc11_cst_the_drowned_separatists")
	local harkon_sep = cm:get_faction("wh2_dlc11_cst_vampire_coast_separatists")
	local coast_encounters = cm:get_faction("wh2_dlc11_cst_vampire_coast_encounters")
	local coast_qb1 = cm:get_faction("wh2_dlc11_cst_vampire_coast_qb1")
	local coast_qb2 = cm:get_faction("wh2_dlc11_cst_vampire_coast_qb2")
	local coast_qb3 = cm:get_faction("wh2_dlc11_cst_vampire_coast_qb3")
	local coast_qb4 = cm:get_faction("wh2_dlc11_cst_vampire_coast_qb4")
	local dead_flag_fleet = cm:get_faction("wh3_dlc21_cst_dead_flag_fleet")
	local dread_rock_privateers = cm:get_faction("wh3_main_cst_dread_rock_privateers")
	
	-- put vamp coasts factions into an array
	local vamp_coast_factions = {sartosa,noctilus,drowned,harkon,sartosa_sep,noctilus_sep,drowned_sep,harkon_sep,coast_encounters,coast_qb1,coast_qb2,coast_qb3,coast_qb4,dead_flag_fleet,dread_rock_privateers}
	
	-- add our custom effect that adds the correct siege towers
    custom_eb:add_effect("CBFM_wh2_dlc11_effect_siege_engine_number_cst_siege_tower","faction_to_force_own",2)	
	
	-- apply this new effect to all vamp coast factions
	for i = 1, #vamp_coast_factions do
		cm:apply_custom_effect_bundle_to_faction(custom_eb,vamp_coast_factions[i])
	end
end

cm:add_first_tick_callback(cbfm_vampire_coast_tower_fix)