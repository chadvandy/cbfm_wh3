local function cbfm_undercity_cooldown_fix()
	-- remove old listener
	core:remove_listener("underempire_CharacterGarrisonTargetAction")

	-- add new listener, which is almost exactly the same but uses the correct agent_action_key in the condition
	core:add_listener(
		"underempire_CharacterGarrisonTargetAction",
		"CharacterGarrisonTargetAction",
		function(context)
			return (context:mission_result_critial_success() or context:mission_result_success()) and context:agent_action_key():starts_with("wh2_dlc12_agent_action_dignitary_hinder_settlement_expand_underempire") -- agent_action_key in vanilla function is wrong, causing condition to always return false
		end,
		function(context)
			local faction = context:character():faction();
			local faction_key = faction:name();
			
			cm:remove_effect_bundle("wh2_dlc12_bundle_underempire_cooldown", faction_key);
			cm:apply_effect_bundle("wh2_dlc12_bundle_underempire_cooldown", faction_key, 10 + cm:get_factions_bonus_value(faction, "under_empire_cooldown")); -- original function uses local variable "skaven_under_empire_cooldown," but this is always just set to 10 
			core:trigger_event("ScriptEventPlayerUnderEmpireEstablished");
		end,
		true
	);

end

cm:add_first_tick_callback(cbfm_undercity_cooldown_fix)