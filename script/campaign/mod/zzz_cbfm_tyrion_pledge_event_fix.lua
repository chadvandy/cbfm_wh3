-- only the second listener is modified, but the whole function is being reproduced here for this to work right

function asur_dilemmas:add_listeners()
	core:add_listener(
		"asur_dilemmas_ritual",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == self.faction_key;
		end,
		function(context)
			local faction = context:performing_faction();
			local ritual = context:ritual():ritual_key();

			if self.rituals[ritual] then
				local dilemma = self.rituals[ritual].dilemma;
				local level = self.rituals[ritual].level;
				local other_faction = cm:get_faction(self.rituals[ritual].faction);

				if self.rituals[ritual].downgradable == true then
					local already_given = cm:get_saved_value("asur_dilemma_"..self.rituals[ritual].faction);

					if already_given then
						level = level - 1;
					end
				end
				dilemma = dilemma.."_"..tostring(level);
				
				cm:trigger_dilemma_with_targets(
					faction:command_queue_index(),
					dilemma,
					other_faction:command_queue_index(),
					0, 0, 0, 0, 0
				);
			end
		end,
		true
	);
	core:add_listener(
		"asur_dilemmas_choice",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:faction():name() == self.faction_key;
		end,
		function(context)
			local dilemma = context:dilemma();
			local choice = context:choice();
			
			if choice == 3 then
				for key, ritual in pairs(self.rituals) do
					if ritual.downgradable == true and dilemma == ritual.dilemma.."_3" then
						cm:set_saved_value("asur_dilemma_"..ritual.faction, true);
						break;
					end
				end
			end

			if choice == 2 then
				local faction = context:faction();

				if dilemma == "wh3_dlc27_hef_asur_domination_avelorn_2" or dilemma == "wh3_dlc27_hef_asur_domination_avelorn_3" then
					local military_force_list = faction:military_force_list();
		
					for i = 0, military_force_list:num_items() - 1 do
						local military_force = military_force_list:item_at(i);
						cm:heal_military_force(military_force);
					end
				-- CBFM: This is the specific dilemma choice for Tyrion that we need to fix
				elseif dilemma == "wh3_dlc27_hef_asur_domination_eataine_2" or dilemma == "wh3_dlc27_hef_asur_domination_eataine_3" then
					local char_list = faction:character_list();

					for i = 0, char_list:num_items() - 1 do
						local current_char = char_list:item_at(i);
						local rank = current_char:rank()
						-- begin CBFM edits
						local wanted_rank = math.min(rank + 1, #cm.character_xp_per_level)
						local current_xp = cm.character_xp_per_level[rank]
						local required_xp = cm.character_xp_per_level[wanted_rank]
						local needed_xp = required_xp - current_xp
						
						cm:add_agent_experience(cm:char_lookup_str(current_char), needed_xp)
						-- end CBFM edits
					end
				elseif dilemma == "wh3_dlc27_hef_asur_domination_imrik_2" or dilemma == "wh3_dlc27_hef_asur_domination_imrik_3" then
					local char_list = faction:character_list();

					for i = 0, char_list:num_items() - 1 do
						local current_char = char_list:item_at(i);
						cm:replenish_action_points(cm:char_lookup_str(current_char));
					end
				elseif dilemma == "wh3_dlc27_hef_asur_domination_loremasters_2" or dilemma == "wh3_dlc27_hef_asur_domination_loremasters_3" then
					cm:grant_research_points(self.faction_key, 1000);
				--elseif dilemma == "wh3_dlc27_hef_asur_domination_nagarythe_2" or dilemma == "wh3_dlc27_hef_asur_domination_nagarythe_3" then
				elseif dilemma == "wh3_dlc27_hef_asur_domination_yvresse_2" or dilemma == "wh3_dlc27_hef_asur_domination_yvresse_3" then
					local region_list = faction:region_list();

					for i = 0, region_list:num_items() - 1 do
						local region = region_list:item_at(i);
						cm:create_storm_for_region(region:name(), 1, 8, "hef_mist_storm");
					end
				end
			end
		end,
		true
	);
end