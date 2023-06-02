cbfm_coc_exalted_upgrade_techs = {
	wh3_dlc20_chs_valkia = "wh3_main_chs_belakor_1",
	wh3_dlc20_chs_festus = "wh3_main_chs_belakor_2",
	wh3_dlc20_chs_vilitch = "wh3_main_chs_belakor_3",
	wh3_dlc20_chs_azazel = "wh3_main_chs_belakor_4"
}
	
local function check_tech()
	for faction_key, tech_key in pairs(cbfm_coc_exalted_upgrade_techs) do
		cm:instantly_research_technology(faction_key,tech_key,false)
	end
	cm:set_saved_value("cbfm_coc_exalted_upgrade_fix_status",true)
	return true
end

local function init()
	local techs_given = cm:get_cached_value("cbfm_coc_exalted_upgrade_fix_status",check_tech)
	local coc_is_human = cbfm_coc_exalted_upgrade_techs[cm:get_local_faction_name(true)] -- use of get_local_faction should be mp-safe here, as we are only using this information to hide (local) ui elements
	if techs_given and coc_is_human then
		core:add_listener(
			"cbfm_coc_exalted_upgrade_fix_panel_listener",
			"PanelOpenedCampaign",
			function(context) return context.string == "technology_panel" end,
			function()
				local local_faction_key = cm:get_local_faction_name(true) -- use of get_local_faction should be mp-safe here, as we are only using this information to hide (local) ui elements
				local function hide_tech()
					local uic = find_uicomponent("technology_panel",cbfm_coc_exalted_upgrade_techs[local_faction_key])
					if uic then uic:SetVisible(false) end
				end
				cm:real_callback(hide_tech,25)
			end,
			true
		)
	end
end

cm:add_first_tick_callback(init)