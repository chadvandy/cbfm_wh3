-- script actually by Dux
core:add_listener(
    "tomb_king_ror_unlock_ai",
    "RitualCompletedEvent",
    function(context)
        return not context:performing_faction():is_human()
    end,
    function(context)
        local faction_key = context:performing_faction():name()
        local ritual_key = context:ritual():ritual_key()
        
        if ritual_key == "wh2_dlc09_ritual_tmb_tahoth" then
            cm:remove_event_restricted_unit_record_for_faction("wh2_dlc09_tmb_art_casket_of_souls_0", faction_key)
        end
    end,
    true
)