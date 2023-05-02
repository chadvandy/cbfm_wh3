dux_event_feed_fix_counter = 0

function dux_event_feed_fix_init()
	local player_factions = cm:get_active_human_factions()
	for _, faction_key in ipairs(player_factions) do
		cm:add_faction_turn_start_listener_by_name("dux_event_feed_fix_for_" .. faction_key,faction_key,dux_event_feed_fix_start_loops,true)
	end
	
	if not cm:is_new_game() then
		dux_event_feed_fix_start_loops()
	end
end

function dux_event_feed_fix_start_loops()
	cm:repeat_real_callback(dux_event_feed_fix_first_loop,250,"dux_event_feed_fix_first_loop")
end

function dux_event_feed_fix_first_loop()
	local hud_uic = find_uicomponent("hud_campaign")
	if not cm:is_human_factions_turn() then
		ModLog("DUX_EVENT_FEED_FIX: events check ended/skipped because this is not (or no longer) a player turn")
		cm:remove_real_callback("dux_event_feed_fix_first_loop")
		return nil
	elseif hud_uic and hud_uic:Visible() then
		ModLog("DUX_EVENT_FEED_FIX: hud_uic found, starting event feed loop")
		cm:repeat_real_callback(dux_event_feed_fix_second_loop,250,"dux_event_feed_fix_second_loop")
		cm:remove_real_callback("dux_event_feed_fix_first_loop")
	end
end

function dux_event_feed_fix_second_loop()
	local events_uic = find_uicomponent("events")
	local hud_uic = find_uicomponent("hud_campaign")
	if not events_uic then
		ModLog("DUX_EVENT_FEED_FIX: events_uic not found, attempting to stir up")
		cm:suppress_all_event_feed_event_types(false)
		dux_event_feed_fix_counter = dux_event_feed_fix_counter + 1
	else
		dux_event_feed_fix_counter = 0
	end
	if dux_event_feed_fix_counter >= 8 then
		ModLog("DUX_EVENT_FEED_FIX: events_uic has not been present for eight cycles (two full seconds), priority events seem to be done, no longer checking")
		cm:remove_real_callback("dux_event_feed_fix_second_loop")
	end
	if not cm:is_human_factions_turn() then
		ModLog("DUX_EVENT_FEED_FIX: events check ended/skipped because this is not (or no longer) a player turn")
		cm:remove_real_callback("dux_event_feed_fix_second_loop")
		return nil
	end
	if not hud_uic:Visible() then
		ModLog("DUX_EVENT_FEED_FIX: hud_uic lost visibility while checking for priority events, but this is still a player turn; could be post-battle or a cutscene, restarting hud check loop")
		dux_event_feed_fix_counter = 0
		cm:remove_real_callback("dux_event_feed_fix_second_loop")
		cm:repeat_real_callback(dux_event_feed_fix_first_loop,250,"dux_event_feed_fix_first_loop")
	end
end

cm:add_post_first_tick_callback(dux_event_feed_fix_init)