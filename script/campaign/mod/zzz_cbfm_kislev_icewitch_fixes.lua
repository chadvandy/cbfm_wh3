local function init()
    cm:add_faction_turn_start_listener_by_culture(
        "cbfm_ksl_auto_tech",
        "wh3_main_ksl_kislev",
        function(context)
            local faction = context:faction()
            local faction_key = faction:name()
            local turn = cm:turn_number()
            if not faction:is_human() and turn == 10 then
                cm:instantly_research_technology(faction_key,"wh3_main_tech_ksl_4_03",false)
            end
        end,
        true
    )
end

cm:add_first_tick_callback(init)