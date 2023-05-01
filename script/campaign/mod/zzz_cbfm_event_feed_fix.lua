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
	if hud_uic and hud_uic:Visible() then
		ModLog("DUX_EVENT_FEED_FIX: hud_uic found, waiting one game model second")
		cm:callback(dux_event_feed_fix_persistent_hud,1)
		cm:remove_real_callback("dux_event_feed_fix_first_loop")
	elseif not cm:is_human_factions_turn() then
		ModLog("DUX_EVENT_FEED_FIX: events check ended/skipped because this is not (or no longer) a player turn")
		cm:remove_real_callback("dux_event_feed_fix_first_loop")
	end
end

function dux_event_feed_fix_persistent_hud()
	local hud_uic = find_uicomponent("hud_campaign")
	if hud_uic and hud_uic:Visible() then
		ModLog("DUX_EVENT_FEED_FIX: hud_uic is still visible after one game model second, beginning events loop")
		cm:repeat_real_callback(dux_event_feed_fix_second_loop,250,"dux_event_feed_fix_second_loop")
	else
		ModLog("DUX_EVENT_FEED_FIX: hud_uic is no longer visible after one game model second, could be at post-battle screen or in a cutscene, waiting for hud_uic to come back before proceeding")
		cm:repeat_real_callback(dux_event_feed_fix_first_loop,250,"dux_event_feed_fix_first_loop")
	end
end

function dux_event_feed_fix_second_loop()
	local events_uic = find_uicomponent("events")
	if not events_uic then
		ModLog("DUX_EVENT_FEED_FIX: events_uic not found, attempting to stir up")
		cm:suppress_all_event_feed_event_types(false)
		dux_event_feed_fix_counter = dux_event_feed_fix_counter + 1
	else
		dux_event_feed_fix_counter = 0
	end
	if dux_event_feed_fix_counter >= 4 then
		ModLog("DUX_EVENT_FEED_FIX: events_uic has not been present for four cycles (one full second), priority events seem to be done, no longer checking")
		cm:remove_real_callback("dux_event_feed_fix_second_loop")
	end
	if not cm:is_human_factions_turn() then
		ModLog("DUX_EVENT_FEED_FIX: events check ended/skipped because this is not (or no longer) a player turn")
		cm:remove_real_callback("dux_event_feed_fix_second_loop")
	end
end

cm:add_post_first_tick_callback(dux_event_feed_fix_init)