-- CBFM: Fixing Caradryan spawning twice
character_unlocking.character_data.caradryan_aislinn.ai_unlock_turn = 999 -- we don't want the AI to ever spawn the Aislinn version of Caradryan; we will add Aislinn to the main list for the AI instead

function character_unlocking:ai_unlock_by_turn(character)
	local character_info = self.character_data[character]
	
	-- CBFM: adding a check to this function specifically for handling AI Caradryan with Aislinn having a unique spawn mechanic
	if character == "caradryan" then
		if cm:is_faction_human("wh3_dlc27_hef_aislinn") then
			return nil -- if Aislinn is human, we don't want Caradryan spawning for the AI at all; exit here
		else
			table.insert(character_info.allowed_factions, "wh3_dlc27_hef_aislinn") -- if Aislinn is not human, then he should be a valid option for AI spawning; add Caradryan to the main list
		end
	end
	-- end CBFM edits
			
	local character_ai_spawn = character_info.name .. "AISpawn"
	core:add_listener(
		character_ai_spawn,
		"WorldStartRound",
		function(context)
			return cm:turn_number() >= character_info.ai_unlock_turn and self:character_has_valid_faction_in_campaign(character)
		end,
		function(context)
			if character_info.has_spawned == false then
				local ai_faction = self:get_strongest_ai_faction_available_to_character(character)
				if character_info.priority_ai_faction ~= nil then
					local priority_ai_faction = cm:get_faction(character_info.priority_ai_faction)
					if priority_ai_faction and priority_ai_faction:is_null_interface() == false then
						ai_faction = character_info.priority_ai_faction
					end
				end

				self:spawn_hero(ai_faction, character)
			end
		end,
		false
	)
end
