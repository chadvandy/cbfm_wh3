function trigger_gotrek_and_felix_cutscene(key, cqi, loc, kill, intervention)
	local gotrek = cm:get_character_by_cqi(cqi)
	
	-- CBFM fix: Remove Gotrek and Felix ancillaries from faction if we're killing them. Ancillaries will be recreated whenever they come back; this prevents potential duplicates.
	if kill then
		local faction = gotrek:faction()
		cm:force_remove_ancillary_from_faction(faction,"wh2_pro08_anc_weapon_gotrek_axe")
		cm:force_remove_ancillary_from_faction(faction,"wh2_pro08_anc_weapon_felix_sword")
	end
	-- end CBFM fix
	
	if gotrek and not gotrek:faction():is_human() then
		if kill then
			kill_gotrek_and_felix_characters()
		end
		
		if intervention then
			intervention:complete()
		end
		
		return
	end
	
	-- multiplayer, don't play the cutscene
	if not intervention then
		if kill then
			kill_gotrek_and_felix_characters()
		end
		
		return
	end
	
	local length = 20
	cm:trigger_campaign_vo(key, cm:char_lookup_str(cqi), 3)
	
	local cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h = cm:get_camera_position()
	cm:take_shroud_snapshot()
	
	local gotrek_and_felix_cutscene = campaign_cutscene:new(
		"gotrek_and_felix_cutscene",
		length,
		function()
			cm:modify_advice(true)
			cm:set_camera_position(cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h)
			cm:restore_shroud_from_snapshot()
			cm:fade_scene(1, 1)
			
			-- complete supplied intervention
			if intervention then
				cm:callback(function() intervention:complete() end, 1)
			end
		end
	)
	
	gotrek_and_felix_cutscene:set_skippable(true, function() gotrek_and_felix_cutscene_skipped(kill) end)
	gotrek_and_felix_cutscene:set_skip_camera(cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h)
	gotrek_and_felix_cutscene:set_disable_settlement_labels(false)
	gotrek_and_felix_cutscene:set_dismiss_advice_on_end(true)
	
	gotrek_and_felix_cutscene:action(
		function()
			cm:fade_scene(0, 2)
			cm:clear_infotext()
		end,
		0
	)
	
	gotrek_and_felix_cutscene:action(
		function()
			cm:show_shroud(false)
			
			local x_pos, y_pos = cm:log_to_dis(loc[1], loc[2])
			cm:set_camera_position(x_pos, y_pos, cam_skip_d, cam_skip_b, cam_skip_h)
			cm:fade_scene(1, 2)
		end,
		2
	)
	
	gotrek_and_felix_cutscene:action(
		function()
			cm:fade_scene(0, 1)
		end,
		length - 1
	)
	
	gotrek_and_felix_cutscene:action(
		function()
			cm:set_camera_position(cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h)
			cm:fade_scene(1, 1)
			if kill then
				kill_gotrek_and_felix_characters()
			end
		end,
		length
	)
	
	gotrek_and_felix_cutscene:start()
	
	core:add_listener(
		"skip_camera_after_vo_ended",
		"ScriptTriggeredVOFinished",
		true,
		function()
			gotrek_and_felix_cutscene:skip(false)
		end,
		true
	)
end

-- this listener removes Gotrek's axe whenever he dies because Gotrek also gets a duplicate copy of his axe whenever he dies (CA missed a check)
-- if CA ever fixes the above, this listener MUST be removed or else Gotrek will lose his weapon if killed in battle for the duration of his 30-turn residency
core:add_listener(
	"cbfm_gotrek_killed",
	"CharacterConvalescedOrKilled",
	function(context)
		return context:character():character_subtype_key() == "wh2_pro08_neu_gotrek"
	end,
	function(context)
		local faction = context:character():faction()
		cm:force_remove_ancillary_from_faction(faction,"wh2_pro08_anc_weapon_gotrek_axe")
	end,
	true
)