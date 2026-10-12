function episode_glottkin:initialise()
    if self:is_available_this_game() then
        episode_glottkin:listeners()
        -- The game uses three listeners with the name "Second_Stage_Mission"...
        -- The Glottkin version is renamed in !_episode_glottkin_listeners_override" 
        -- so only that one is removed and not the ones used by Neferata and Nagash.
        core:remove_listener("Second_Stage_Mission_GLOTTKIN")
        episode_glottkin:mnd_fixed_confed_listener()
    end
end

-- The normal means of scripted confederation used in the vanilla listener doesn't work with Warriors of Chaos.
-- This method uses a payload system to force it, in the same way Archaon subjugates other WoC.
function episode_glottkin:mnd_fixed_confed_listener()
    core:add_listener(
        "Second_Stage_Mission_GLOTTKIN_FIXED",
        "MissionSucceeded",
        function(context)
            return context:mission():mission_record_key() == episode_glottkin.pestilence_and_plagues
        end,
        function(context)
            local glottkin_faction = cm:get_faction("wh3_dlc29_chs_host_of_the_triplets")
            local festus_faction = cm:get_faction("wh3_dlc20_chs_festus")
            cm:force_diplomacy("faction:wh3_dlc29_chs_host_of_the_triplets", "faction:wh3_dlc20_chs_festus", "form confederation", true, true)
            
            -- If Festus is dead.
            if cm:get_faction("wh3_dlc20_chs_festus"):is_dead() then
                -- Forces a confederation using a payload.
                local confed_payload = cm:create_payload()
                -- Note, this revives the faction from the dead as well.
                confed_payload:form_confederation(glottkin_faction, festus_faction, false, false)
                cm:apply_payload(confed_payload, glottkin_faction)
                -- Add LL to pool (if missing)
                local festus_is_in_character_list = episode_glottkin.check_for_festus_character_in_faction(glottkin_faction)
                if festus_is_in_character_list == false then
                    out("MND FESTUS - No character of Festus subtype, adding to pool.")
                    episode_glottkin.manually_add_festus()
                end
                
            -- If Festus is alive. Same thing but no extra handling to force Festus to the lord pool.
            else
                local confed_payload = cm:create_payload()
                confed_payload:form_confederation(glottkin_faction, festus_faction, false, false)
                cm:apply_payload(confed_payload, glottkin_faction)
            end

            episode_glottkin:episode_mission(episode_glottkin.narrative_doctors_orders)
            episode_glottkin:set_up_invastion_markers_brass_keep()
        end,
        true
    )
end

-- Looks through Glottkin faction character_list for Festus, if not found return true.
function episode_glottkin.check_for_festus_character_in_faction(faction)
    for i = 0, faction:character_list():num_items() - 1 do
        local character = faction:character_list():item_at(i)
        if character:character_subtype_key() == "wh3_dlc20_nur_festus" then
            return true
        end
    end
    return false
end

-- Force adds Festus to the lord recruitment pool.
function episode_glottkin.manually_add_festus()
    cm:spawn_character_to_pool(
        "wh3_dlc29_chs_host_of_the_triplets",
        "names_name_521322027", -- Festus the Leechlord
        "",
        "",
        "",
        21,
        true,
        "general",
        "wh3_dlc20_nur_festus",
        true,
        ""
    )
end