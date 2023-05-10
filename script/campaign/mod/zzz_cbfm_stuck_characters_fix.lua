local listFactions

local function MoveStuckCharacters()

    local tablePositionsToCharacters = {}

    for iFactionCounter = 0, listFactions:num_items() - 1 do

        local factionCurrent = listFactions:item_at(iFactionCounter)

        if factionCurrent:is_dead() == false then

            local listCharacters = factionCurrent:character_list()

            for iCharacterCounter = 0, listCharacters:num_items() - 1 do

                local characterCurrent = listCharacters:item_at(iCharacterCounter)

                if (
                    (characterCurrent:is_wounded() == false) and
                    (characterCurrent:character_type("colonel") == false) and
                    (characterCurrent:has_garrison_residence() == false) and
                    (characterCurrent:is_embedded_in_military_force() == false)
                ) then

                    strPosition = "x" ..tostring(characterCurrent:logical_position_x()) .."_y" ..tostring(characterCurrent:logical_position_y())

                    if tablePositionsToCharacters[strPosition] ~= nil then

                        table.insert(tablePositionsToCharacters[strPosition], characterCurrent)

                    else

                        tablePositionsToCharacters[strPosition] = {}
                        table.insert(tablePositionsToCharacters[strPosition], characterCurrent)

                    end

                end

            end
        
        end

    end

    for strPosition, tableCharacters in pairs(tablePositionsToCharacters) do

        if #tableCharacters > 1 then

            for iStuckCounter = 2, #tableCharacters do

                local characterFirst = tableCharacters[1]
                local characterCurrent = tableCharacters[iStuckCounter]
                local strFaction = characterCurrent:faction():name()
                local strLookupCurrent = cm:char_lookup_str(characterCurrent)
                local strLookupFirst = cm:char_lookup_str(characterFirst)

                cm:callback(function()

                    local iPosX, iPosY = cm:find_valid_spawn_location_for_character_from_character(
                        strFaction,
                        strLookupFirst,
                        true
                    )

                    cm:teleport_to(
                        strLookupCurrent,
                        iPosX,
                        iPosY
                    )

                end,
                0.1)


            end

        end

    end

end

function AAAFyTyStuckCharactersFixListeners()

    listFactions = cm:model():world():faction_list()
    
    core:add_listener(
    "AAAFyTyStuckCharactersFix_WorldStartRound",
    "WorldStartRound",
    function(context)

        return cm:turn_number() > 1

    end,
    function(context)

        MoveStuckCharacters()


    end,
    true
    )

end

cm:add_first_tick_callback(function() AAAFyTyStuckCharactersFixListeners() end);