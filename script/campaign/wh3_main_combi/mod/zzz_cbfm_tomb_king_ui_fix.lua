local function init()
	if (cm:get_local_faction_culture(true) == "wh2_dlc09_tmb_tomb_kings") then
		local uic = find_uicomponent("resources_bar_holder","right_spacer_tomb_kings","frame")
		
		uic:SetCanResizeCurrentStateImageWidth(0,true)
		uic:SetCanResizeWidth()
		uic:Resize(151,77)

		local button = find_uicomponent(uic,"button_books_of_nagash")
		local num = find_uicomponent(uic,"dy_num_books")
		local children = {button,num}
		
		local function loop()
			if button:Visible() then
				for _, child in pairs(children) do
					local x,y = child:Position()
					child:MoveTo(x + 20,y)
				end
				cm:remove_real_callback("cbfm_tk_ui_fix_loop")
			end
		end
		
		cm:repeat_real_callback(loop,50,"cbfm_tk_ui_fix_loop")
	end
end

cm:add_post_first_tick_callback(init)