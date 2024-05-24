function grudges_scripted_bv_check(military_force, bonus_value, forces_with_bonus_value, total_grudges) 

	-- Check if the attacker has the bonus value
	if cm:get_forces_bonus_value(military_force, bonus_value) > 0 then
		table.insert(forces_with_bonus_value, military_force:command_queue_index())
	
	else -- If they do not have the bonus value check if they have over 1000 Grudges

	-- Check if military force is a garrison
		if military_force:is_armed_citizenry() then
			local region = military_force:garrison_residence():region()
			-- Check if region has Grudge resource and if it does, is it over 1000
			if not region:pooled_resource_manager():is_null_interface() then
				local region_prm = region:pooled_resource_manager()
                -- CBFM: changed if test to avoid script break on non-existing value()
				if not region_prm:resource("wh3_dlc25_dwf_grudge_points_enemy_settlements"):is_null_interface() then
					total_grudges = total_grudges + region_prm:resource("wh3_dlc25_dwf_grudge_points_enemy_settlements"):value()
				end
			end
		else
			-- Check if force has Grudge resource and if it does, is it over 1000
			if not military_force:pooled_resource_manager():is_null_interface() then
				local mf_prm = military_force:pooled_resource_manager()
                -- CBFM: changed if test to avoid script break on non-existing value()
				if not mf_prm:resource("wh3_dlc25_dwf_grudge_points_enemy_armies"):is_null_interface() then
					total_grudges = total_grudges + mf_prm:resource("wh3_dlc25_dwf_grudge_points_enemy_armies"):value()
				end
			end
		end
	end
	return total_grudges
end