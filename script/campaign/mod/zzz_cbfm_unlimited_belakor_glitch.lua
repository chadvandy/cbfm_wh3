cm:add_loading_game_callback(function()
    if belakor_daemon_prince_creation then
        ---@param character CHARACTER_SCRIPT_INTERFACE
        function belakor_daemon_prince_creation:apply_effect_bundle(character)
            if cm:char_is_general_with_army(character) and character:faction():is_contained_in_faction_set(self.faction_set_key) and not character:character_details():is_unique() and not character:is_faction_leader() and not character:has_effect_bundle(self.effect_bundle_key) then
                cm:apply_effect_bundle_to_character(self.effect_bundle_key, character, self.effect_bundle_duration)
                cm:apply_effect_bundle_to_character(self.infinite_effect_bundle_key, character, 0)
                
                cm:add_turn_countdown_event(self.belakor_faction_key, self.effect_bundle_duration, "ScriptEventBelakorDaemonPrinceEffectBundleExpires", tostring(character:family_member():command_queue_index()))
            end
        end
    end
end)
