--[[
Fix for a script break when, as cathay, your caravan arrives at it's destination, while you're the owner of the destination.

The bug is that, when triggering the event about the caravan reaching your city, caravan_master is read as global variable, not from the context.
]]--

-- Remove the vanilla listener and replace it with the fixed one.
core:remove_listener("caravan_finished")
core:add_listener(
    "caravan_finished",
    "CaravanCompleted",
    function(context)
        return context:faction():is_human()
    end,
    function(context)
        -- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
        local region_name = context:complete_position():node():region_key()
        local region_owner = context:complete_position():node():region_data():region():owning_faction();

        out.design("Caravan (player) arrived in: "..region_name)

        local faction_key = context:faction():name();
        local prev_total_goods_moved = cm:get_saved_value("caravan_goods_moved_" .. faction_key) or 0;
        local num_caravans_completed = cm:get_saved_value("caravans_completed_" .. faction_key) or 0;
        cm:set_saved_value("caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
        cm:set_saved_value("caravans_completed_" .. faction_key, num_caravans_completed + 1);
        core:trigger_event("ScriptEventCaravanCompleted", context);

        reward_item_check(
            context:faction(),
            region_name,
            context:caravan_master()
            )

        -- FRODO: A consequence of this fix is that this finally executes (the script break happened when triggering the following incident).
        -- This causes an event to trigger for kislev and cathay that just gives 3000 gold to the owner of the province where this caravan ends.
        -- My guess is that this was intended for these two cultures because they're the two playable "humans" (or order factions) in ROC, and in multiplayer, you would reward
        -- the other human for "receiving" the caravan goods. For that reason, I've expanded the check to work with all IME-related playable order factions that would logically trade (sorry lizards).
        -- Also, I'm very tempted to add a check to make sure this doesn't trigger for the player if it's both, the owner of the caravan and the owner of the province.
        if region_owner:is_human() and (region_owner:subculture() == "wh2_main_sc_def_dark_elves" or
                                        region_owner:subculture() == "wh2_main_sc_hef_high_elves" or
                                        region_owner:subculture() == "wh3_main_sc_cth_cathay" or
                                        region_owner:subculture() == "wh3_main_sc_ksl_kislev" or
                                        region_owner:subculture() == "wh3_main_sc_ogr_ogre_kingdoms" or
                                        region_owner:subculture() == "wh_dlc05_sc_wef_wood_elves" or
                                        region_owner:subculture() == "wh_dlc08_sc_nor_norsca" or
                                        region_owner:subculture() == "wh_main_sc_brt_bretonnia" or
                                        region_owner:subculture() == "wh_main_sc_dwf_dwarfs" or
                                        region_owner:subculture() == "wh_main_sc_emp_empire" or
                                        region_owner:subculture() == "wh_main_sc_teb_teb") then

            cm:trigger_incident_with_targets(
                region_owner:command_queue_index(),
                "wh3_main_cth_caravan_completed_received",
                0,
                0,
                context:caravan_master():character():command_queue_index(),
                0,
                0,
                0
                )
        end

        --Reduce demand
        local cargo = context:caravan():cargo()
        local cargo = context:caravan():cargo()
        local value = math.floor(-cargo/18);
        out.design("Reduce "..region_name)

        cm:callback(function()adjust_end_node_value(region_name, value, "add") end, 5);

        --[[
        --only trigger after player has recieved money
        core:add_listener(
            "caravans_decrease_demand_"..context:caravan_master():command_queue_index(),
            "WorldStartRound",
            true,
            function(context)
                adjust_end_node_value(region_name, value, "add");
            end,
            false
            );
        ]]

        if not region_owner:is_null_interface() then
            out.design("Inserting a diplomatic event for caravan arriving. Factions: "..region_owner:name()..", "..faction_key)
            cm:cai_insert_caravan_diplomatic_event(region_owner:name(),faction_key)
        end
    end,
    true
);
