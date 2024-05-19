function nurgle_plagues:randomise_symptom_location(faction)

    local pfi = self.plague_faction_info    
    local faction_name = faction:name()
    local faction_info = pfi[faction_name]
    local symptom_list = self:copy_symptom_table()
    -- CBFM: swapped order of operations around so correct symptoms are used after being randomized
    for i = #symptom_list, 2, -1 do
        local j = cm:random_number(i)
        symptom_list[i], symptom_list[j] = symptom_list[j], symptom_list[i]
    end
    
    faction_info.current_symptoms_list = symptom_list
    if faction_name == self.festus_faction then
        self:festus_symptom_swap(faction_info)
    end
    -- END CBFM
    common.set_context_value("random_plague_component_list_" .. faction_name, symptom_list)

    faction_info.plague_creation_counter = self.plague_creation_base_counter
    common.set_context_value("random_plague_creation_count_" .. faction_name, faction_info.plague_creation_counter)
    self:add_blessed_symptoms(faction)
end