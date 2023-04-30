local function cbfm_lzd_coven_visibility()
    --- get UI components
    local settlement_list = find_uicomponent("settlement_panel","settlement_list")
    if settlement_list then
        local child_count = settlement_list:ChildCount()

        --- Turn on visibility in every settlement
        for i=1, child_count - 1  do
            local child = UIComponent(settlement_list:Find(i))
            local button_holder = find_uicomponent(child,"settlement_view","toggle_button_holder")
            local button_default = find_uicomponent(button_holder,"button_default_view")
            if button_holder then
                if button_holder:Visible() == false then
                    button_holder:SetVisible(true)
                    button_default:SetVisible(false) -- this prevents the default button from always displaying everywhere
                end
            end
        end 
    end
end


--- Trigger check for visibility when settlement is selected
core:add_listener(
    "cbfm_lzd_less_button_holder_trigger",
    "SettlementSelected",
    true,
    function()
        cm:real_callback(function()
            cbfm_lzd_coven_visibility()
        end,500)
    end,
    true
)