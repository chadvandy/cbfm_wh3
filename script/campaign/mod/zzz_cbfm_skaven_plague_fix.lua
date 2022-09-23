local function cbfm_plague_fix()
	core:add_listener(
		"cbfm_plague_fix_listener",
		"CharacterGarrisonTargetAction",
		function(context)
			return (context:mission_result_critial_success() or context:mission_result_success()) and context:agent_action_key() == "wh2_main_agent_action_wizard_hinder_settlement_plague_priest_ritual"
		end,
		function(context)
			local faction = context:character():faction()
			local settlement = context:garrison_residence():settlement_interface()
		
			cm:spawn_plague_at_settlement(faction,settlement,"wh2_main_plague_skaven")
		end,
		true
	)
end

cm:add_first_tick_callback(cbfm_plague_fix)