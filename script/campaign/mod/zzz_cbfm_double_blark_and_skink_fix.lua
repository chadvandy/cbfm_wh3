core:add_listener(
	"cbfm_double_blark_fix",
	"RitualCompletedEvent",
	function(context)
		local ritual_key = context:ritual():ritual_key()
		return ritual_key == "wh2_main_ritual_def_mathlann" or ritual_key == "wh2_dlc12_tehenhauin_sacrifice_of_xlaxgor"
	end,
	function(context)
		local ritual_key = context:ritual():ritual_key()
		local faction = context:performing_faction()
		local is_human = faction:is_human()
		local char_list = faction:character_list()
		local latest_char = char_list:item_at(char_list:num_items() - 1)
		
		-- if this is for Tehenhauin's badass skinks, clear the message about recruiting the dude we're about to delete to avoid confusion
		if is_human and ritual_key == "wh2_dlc12_tehenhauin_sacrifice_of_xlaxgor" then
			local function clear_recruitment_event()
				local local_event_str = common.get_localised_string("event_feed_targeted_events_title_agent_recruitedevent_feed_target_agent_faction")
				local num_categories = common.get_context_value("RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList.Size") - 1 -- subtracting 1 to disregard the template

				for i = 1, num_categories do
					local num_events_in_category = common.get_context_value("RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList[" .. i .. "].ChildContext('events_list').ChildList.Size") - 1
					for j = 1, num_events_in_category do
						local event_title = common.get_context_value("RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList[" .. i .. "].ChildContext('events_list').ChildList[" .. j .. "].ContextsList[0].Title")
						if event_title == local_event_str then
							common.call_context_command("RootComponent.ChildContext('dropdown_events').ChildContext('list_box').ChildList[" .. i .. "].ChildContext('events_list').ChildList[" .. j .. "].Trash")
							break
						end
					end
				end
			end
			cm:callback(clear_recruitment_event,0.1)
		end
		
		-- disable death message in ui if faction is human
		if is_human then cm:disable_event_feed_events(true,"","wh_event_subcategory_character_deaths","") end
		
		cm:suppress_immortality(latest_char:family_member():command_queue_index(),true)
		cm:kill_character(cm:char_lookup_str(latest_char),true)
		
		-- re-enable death event feed messages
		if is_human then cm:disable_event_feed_events(false,"","wh_event_subcategory_character_deaths","") end
	end,
	true
)