local yvresse_faction_key = "wh2_main_hef_yvresse"
local lair_max_prisoners = 1 -- default, changed to 2 via loading_game_callback as required

local function init()
	core:remove_listener("lair_BattleCompleted")
	core:add_listener(
		"lair_BattleCompleted",
		"BattleCompleted",
		function()
			return cm:get_faction(yvresse_faction_key):is_human()
		end,
		function()
			local pending_battle = cm:model():pending_battle();
			local warden = cm:get_faction(yvresse_faction_key);
			
			if pending_battle:is_auto_resolved() then
				local prison_system = cm:model():prison_system();
				local prisoners = prison_system:get_faction_prisoners(warden);
				
				if prisoners:num_items() < lair_max_prisoners then
					if cm:pending_battle_cache_faction_is_attacker(yvresse_faction_key) and pending_battle:has_been_fought() and pending_battle:attacker_won() and not pending_battle:ended_with_withdraw() and cm:random_number(100) <= 50 then
						local count = cm:pending_battle_cache_num_defenders();
						
						if pending_battle:night_battle() then
							count = 1;
						end
						
						for i = 1, count do
							local defender_cqi = cm:pending_battle_cache_get_defender_fm_cqi(i);
							local enemy = cm:get_character_by_fm_cqi(defender_cqi);
							if enemy:is_null_interface() == false then
								local enemy_is_general = enemy:character_details():character_type("general")

								if enemy and not enemy:is_null_interface() and enemy_is_general then
									cm:faction_imprison_character(warden, enemy);
								end
							end
						end
					end
				end
			end
			
			-- checking to see if faction has been wiped out, resulting in lost prisoners 
			cm:callback(
				function()
					lair_CheckDeadPrisoners()
					lair_UpdatePrisonAbility(warden)
					lair_UpdatePrisonerEffects(warden)
				end,
				0.5
			)
		end,
		true
	)
end

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			lair_max_prisoners = cm:load_named_value("lair_max_prisoners", lair_max_prisoners, context)
		end
	end
)

cm:add_post_first_tick_callback(init)