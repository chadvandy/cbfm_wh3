cbfm_names_of_power_traits = {"wh2_main_trait_def_name_of_power_ar_01_lifequencher","wh2_main_trait_def_name_of_power_ar_12_grimgaze","wh2_main_trait_def_name_of_power_ar_02_the_tempest_of_talons","wh2_main_trait_def_name_of_power_ar_03_shadowdart","wh2_main_trait_def_name_of_power_ar_04_barbstorm","wh2_main_trait_def_name_of_power_ar_07_wrathbringer","wh2_main_trait_def_name_of_power_ar_05_beastbinder","wh2_main_trait_def_name_of_power_ar_06_fangshield","wh2_main_trait_def_name_of_power_ar_08_moonshadow","wh2_main_trait_def_name_of_power_ar_09_granitestance","wh2_main_trait_def_name_of_power_ar_10_the_grey_vanquisher","wh2_main_trait_def_name_of_power_ar_11_krakenclaw","wh2_main_trait_def_name_of_power_ca_01_dreadtongue","wh2_main_trait_def_name_of_power_ca_02_darkpath","wh2_main_trait_def_name_of_power_ca_03_khainemarked","wh2_main_trait_def_name_of_power_ca_04_the_black_conqueror","wh2_main_trait_def_name_of_power_ca_05_leviathanrage","wh2_main_trait_def_name_of_power_ca_11_gatesmiter","wh2_main_trait_def_name_of_power_ca_06_emeraldeye","wh2_main_trait_def_name_of_power_ca_08_pathguard","wh2_main_trait_def_name_of_power_ca_07_barbedlash","wh2_main_trait_def_name_of_power_ca_09_the_dark_marshall","wh2_main_trait_def_name_of_power_ca_10_the_dire_overseer","wh2_main_trait_def_name_of_power_ca_12_the_tormentor","wh2_main_trait_def_name_of_power_co_01_blackstone","wh2_main_trait_def_name_of_power_co_07_bloodscourge","wh2_main_trait_def_name_of_power_co_02_wyrmscale","wh2_main_trait_def_name_of_power_co_11_drakecleaver","wh2_main_trait_def_name_of_power_co_03_poisonblade","wh2_main_trait_def_name_of_power_co_04_headreaper","wh2_main_trait_def_name_of_power_co_05_spiteheart","wh2_main_trait_def_name_of_power_co_09_the_hand_of_wrath","wh2_main_trait_def_name_of_power_co_08_griefbringer","wh2_main_trait_def_name_of_power_co_10_fatedshield","wh2_main_trait_def_name_of_power_co_06_soulblaze","wh2_main_trait_def_name_of_power_co_12_hydrablood"}

-- key = dilemma name, value = first choice trait payload
cbfm_names_of_power_first_choices =
{
	["wh2_main_def_names_of_power_ar_1_sacrifice"] = "wh2_main_trait_def_name_of_power_ar_01_lifequencher",
	["wh2_main_def_names_of_power_ar_2_caravan"] = "wh2_main_trait_def_name_of_power_ar_02_the_tempest_of_talons",
	["wh2_main_def_names_of_power_ar_3_battle"] = "wh2_main_trait_def_name_of_power_ar_04_barbstorm",
	["wh2_main_def_names_of_power_ar_4_beast"] = "wh2_main_trait_def_name_of_power_ar_05_beastbinder",
	["wh2_main_def_names_of_power_ar_5_tideofbattle"] = "wh2_main_trait_def_name_of_power_ar_08_moonshadow",
	["wh2_main_def_names_of_power_ar_6_raid"] = "wh2_main_trait_def_name_of_power_ar_10_the_grey_vanquisher",
	["wh2_main_def_names_of_power_ca_1_ambush"] = "wh2_main_trait_def_name_of_power_ca_01_dreadtongue",
	["wh2_main_def_names_of_power_ca_2_spoils"] = "wh2_main_trait_def_name_of_power_ca_03_khainemarked",
	["wh2_main_def_names_of_power_ca_3_siege"] = "wh2_main_trait_def_name_of_power_ca_05_leviathanrage",
	["wh2_main_def_names_of_power_ca_4_sorceress"] = "wh2_main_trait_def_name_of_power_ca_06_emeraldeye",
	["wh2_main_def_names_of_power_ca_5_draft"] = "wh2_main_trait_def_name_of_power_ca_07_barbedlash",
	["wh2_main_def_names_of_power_ca_6_captive"] = "wh2_main_trait_def_name_of_power_ca_10_the_dire_overseer",
	["wh2_main_def_names_of_power_co_1_potion"] = "wh2_main_trait_def_name_of_power_co_01_blackstone",
	["wh2_main_def_names_of_power_co_2_dragon"] = "wh2_main_trait_def_name_of_power_co_02_wyrmscale",
	["wh2_main_def_names_of_power_co_3_smith"] = "wh2_main_trait_def_name_of_power_co_03_poisonblade",
	["wh2_main_def_names_of_power_co_4_teacher"] = "wh2_main_trait_def_name_of_power_co_05_spiteheart",
	["wh2_main_def_names_of_power_co_5_hex"] = "wh2_main_trait_def_name_of_power_co_08_griefbringer",
	["wh2_main_def_names_of_power_co_6_hydra"] = "wh2_main_trait_def_name_of_power_co_06_soulblaze"
}

function cbfm_quick_array_copy(array)
	local copy = {}
	for i = 1, #array do
		copy[i] = array[i]
	end
	return copy
end

local function names_of_power_fix_human(context)
	-- delay needed for dilemma window to pop up
	cm:callback(function()
		local char_cqi = common.get_context_value("CcoComponent","","RootComponent.ChildContext('dilemma').ChildContext('character_portrait').ContextsList[0].CQI")
		local char_obj = cm:model():character_for_command_queue_index(char_cqi)
		local has_name_of_power = false -- default
	
		for _, trait in ipairs(cbfm_names_of_power_traits) do
			if char_obj:has_trait(trait) then
				has_name_of_power = true
				break
			end
		end
		
		if has_name_of_power then
			-- if we already have a name of power, set up a listener that will immediately axe the new trait when chosen and (attempt to) remove all traces of it from the ui
			core:add_listener(
				"cbfm_duplicate_names_choice_listener",
				"DilemmaChoiceMadeEvent",
				function(context) return context:dilemma():starts_with("wh2_main_def_names_of_power") end,
				function(context)
					local dilemma_key = context:dilemma()
					cm:callback(function()
						-- get rid of the unearned trait
						local char_string = cm:char_lookup_str(common.get_context_value("CcoComponent","","RootComponent.ChildContext('trait_ancillary_gained').ChildContext('dy_name').ContextsList[0].CQI"))
						local trait_to_axe = cbfm_names_of_power_first_choices[dilemma_key]
						cm:force_remove_trait(char_string,trait_to_axe)
					
						-- UI cleanup: --	
						-- first, close trait added pop-up
						common.call_context_command("CcoComponent","","RootComponent.ChildContext('events').ChildContext('button_accept').SimulateLClick")
						-- after a short delay, close trait removed pop-up and then clean up the sidebar stuff
						cm:callback(function()
							common.call_context_command("CcoComponent","","RootComponent.ChildContext('events').ChildContext('button_accept').SimulateLClick") 
							-- look through event feeds to find dilemma and trait notifications, delete both
							local valid_event_feeds = {[common.get_localised_string("event_feed_summary_events_title_character_trait_gained")] = "trait",[common.get_localised_string("campaign_localised_strings_string_event_header_other")] = "world"} -- localised string keys
							local num_active_event_feeds = common.get_context_value("CcoComponent","","RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList.Size")
							local trait_feed_active = false -- default, will be switched in following loop if trait event feed found
							for i = 1, (num_active_event_feeds - 1) do -- i = 1 because first child is always the template, which we don't care about
								local event_feed_title = common.get_context_value("CcoComponent","","RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList[" .. tostring(i) .. "].ChildContext('events_list').ContextsList[0].Title")
								local num_events = common.get_context_value("CcoComponent","","RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList[" .. tostring(i) .. "].ChildContext('events_list').ChildList.Size")
								if valid_event_feeds[event_feed_title] == "trait" then
									trait_feed_active = true -- if trait feed is active, it will always show up before world feed, so it is safe to set this here
									if num_events > 1 then common.call_context_command("CcoComponent","","RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList[" .. tostring(i) .. "].ChildContext('events_list').ChildList[" .. tostring(num_events - 1) .. "].Trash") end
								elseif valid_event_feeds[event_feed_title] == "world" then
									if num_events > 1 then common.call_context_command("CcoComponent","","RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList[" .. tostring(i) .. "].ChildContext('events_list').ChildList[" .. tostring(num_events - 1) .. "].Trash") end
									if num_events > 2 then common.call_context_command("CcoComponent","","RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList[" .. tostring(i) .. "].ChildContext('events_list').ChildList[" .. tostring(num_events - 2) .. "].Trash") end
									-- if no trait feed, that info will also show here
									if not trait_feed_active and num_events > 3 then common.call_context_command("CcoComponent","","RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList[" .. tostring(i) .. "].ChildContext('events_list').ChildList[" .. tostring(num_events - 3) .. "].Trash") end
								end
							end	
						end,0.05)
					end,0.25)
				end,
				false
			)
			-- force first choice
			common.call_context_command("CcoComponent","","RootComponent.CurrentPriorityLocker.ContextsList[0].CustomContext.MakeChoice('FIRST')")
		end
	end,0.1)
end

local function names_of_power_fix_ai(faction_key)
	ModLog("DUX: Checking name of power traits for faction " .. faction_key)
	local faction_obj = cm:get_faction(faction_key)
	
	for _, char_obj in model_pairs(faction_obj:character_list()) do
		local char_name = common:get_localised_string(char_obj:get_forename()) .. " " .. common:get_localised_string(char_obj:get_surname())
		--ModLog("DUX: Now checking name of power traits for " .. char_name)
		if char_obj:character_type_key() ~= "general" then
			--ModLog("DUX: This character is not a general, skipping")
		else
			local char_family_cqi = char_obj:family_member():command_queue_index() -- we need to use the family memeber cqi here so that it stays consistent throughout the campaign, h/t GrooveWizard
			local saved_name_of_power
			local remaining_traits
			if cbfm_ai_saved_names_of_power[char_family_cqi] then saved_name_of_power = cbfm_ai_saved_names_of_power[char_family_cqi] end
			
			for index, trait in ipairs(cbfm_names_of_power_traits) do
				if char_obj:has_trait(trait) then
					ModLog("DUX: Name of power " .. trait .. " found for " .. char_name)
					if not saved_name_of_power then
						ModLog("DUX: no saved name of power was found for this character, marking this trait as saved going forward")
						cbfm_ai_saved_names_of_power[char_family_cqi] = trait
						cm:set_saved_value("cbfm_ai_saved_names_of_power",cbfm_ai_saved_names_of_power)
					elseif saved_name_of_power == trait then
						remaining_traits = cbfm_quick_array_copy(cbfm_names_of_power_traits)
						local trait_removed = table.remove(remaining_traits,index) 					
						ModLog("DUX: trait " .. trait .. " recognized as saved name of power for this character, ensuring no others have been added by searching through name of power traits (sans " .. trait_removed .. ") for any others")
						for _, second_trait in ipairs(remaining_traits) do
							if char_obj:has_trait(second_trait) then
								cm:force_remove_trait(cm:char_lookup_str(char_obj),second_trait)
								ModLog("DUX: Second name of power " .. second_trait .. " found and removed")
								break
							end
						end
					end
					break
				end
			end			
		end
	end
end		
	
local function init()
	-- AI Fix: --
	-- get our table of saved names of power for ai factions if it exists; otherwise, create an empty table
	cbfm_ai_saved_names_of_power = cm:get_cached_value("cbfm_ai_saved_names_of_power",function() return {} end)

	local naggarond = cm:get_faction("wh2_main_def_naggarond")
	if not naggarond then return nil end

	if not cm:is_faction_human("wh2_main_def_naggarond") then
		if not naggarond:is_dead() then cm:add_faction_turn_start_listener_by_name("cbfm_multiple_names_of_power_ai_listener","wh2_main_def_naggarond",function() names_of_power_fix_ai("wh2_main_def_naggarond") end,true) end
	end

	local remaining_dark_elves = naggarond:factions_of_same_subculture()

	for _, faction in model_pairs(remaining_dark_elves) do
		local faction_key = faction:name()
		if not cm:is_faction_human(faction_key) and not faction:is_dead() then
			cm:add_faction_turn_start_listener_by_name("cbfm_multiple_names_of_power_ai_listener",faction_key,function() names_of_power_fix_ai(faction_key) end,true)
		end
	end
	
	-- Player Fix: --
	core:add_listener(
		"cbfm_multiple_names_of_power_human_listener",
		"DilemmaIssuedEvent",
		function(context) return context:dilemma():starts_with("wh2_main_def_names_of_power") and cm:is_faction_human(context:faction():name()) end,
		function() names_of_power_fix_human(context) end,
		true
	)
end

cm:add_first_tick_callback(init)