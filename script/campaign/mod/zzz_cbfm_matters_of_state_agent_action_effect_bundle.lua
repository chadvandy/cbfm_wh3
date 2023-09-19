-- original script by Rhox

local function init()
	core:add_listener(
		"JadeDragonHeroActionListener",
		"CharacterCharacterTargetAction",
		function(context)
			return (context:mission_result_critial_success() or context:mission_result_success()) and context:character():faction():name() == matters_of_state.faction_string and context:target_character():faction():name() ~= matters_of_state.faction_string
		end,
		function()
			cm:remove_effect_bundle(matters_of_state.agent_success_effect_bundle, matters_of_state.faction_string)
			core:remove_listener("JadeDragonHeroActionListenerSettlement")
		end,
		false
	)

	core:add_listener(
		"JadeDragonHeroActionListenerSettlement",
		"CharacterGarrisonTargetAction", 
		function(context)
			return (context:mission_result_critial_success() or context:mission_result_success()) and context:character():faction():name() == matters_of_state.faction_string
		end,
		function()
			cm:remove_effect_bundle(matters_of_state.agent_success_effect_bundle, matters_of_state.faction_string)
			core:remove_listener("JadeDragonHeroActionListener")
		end,
		false
	)
end

cm:add_first_tick_callback(init)