cm:add_pre_first_tick_callback(function()
    if Worldroots then
        -- returns the number of pacified and hostile regions adjacent to a forest's glade region
        function Worldroots:check_pacification(forest)
            local hostile_count = 0
            local pacified_count = 0
            local glade_owner = cm:get_region(forest.glade_region_key):owning_faction()
            local region_list = cm:model():world():lookup_regions_from_region_group(forest.region_group)
            
            for i = 0, region_list:num_items() - 1 do
                local adjacent_region = region_list:item_at(i)
                
                if forest.glade_region_key ~= adjacent_region:name() then
                    local adjacent_region_owning_faction = adjacent_region:owning_faction()
                    
                    if adjacent_region:is_abandoned() then
                        pacified_count = pacified_count + self.pacified_value
                    elseif Worldroots:faction_is_human_wood_elf(adjacent_region_owning_faction) then
                        pacified_count = pacified_count + self.pacified_value
                    elseif adjacent_region_owning_faction:is_ally_vassal_or_client_state_of(glade_owner) then
                        pacified_count = pacified_count + self.pacified_value
                    elseif glade_owner:at_war_with(adjacent_region_owning_faction) then
                        hostile_count = hostile_count + self.hostile_value
                    end
                end
            end
            
            return pacified_count, hostile_count
        end
    end
end)