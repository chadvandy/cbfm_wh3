

recruited_unit_health = {
	start_hp_bonus_value = "recruit_hp_all_units" -- scripted_bonus_value_id set in db
}

---list of units that have an associated scripted_bonus_value_id set in db. Unit must be in this table for effect to apply
recruited_unit_health.units_to_starting_health_bonus_values = {
	wh3_main_nur_cav_plague_drones_0 = "recruit_hp_cav_plague_drones_0",
	wh3_main_nur_cav_plague_drones_1 = "recruit_hp_cav_plague_drones_1",
	wh3_main_nur_cav_pox_riders_of_nurgle_0 = "recruit_hp_cav_pox_riders_of_nurgle_0",
	wh3_main_nur_inf_chaos_furies_0 = "recruit_hp_inf_chaos_furies_0",
	wh3_main_nur_inf_forsaken_0 = "recruit_hp_inf_forsaken_0",
	wh3_main_nur_inf_nurglings_0 = "recruit_hp_inf_nurglings_0",
	wh3_main_nur_inf_plaguebearers_0 = "recruit_hp_inf_plaguebearers_0",
	wh3_main_nur_inf_plaguebearers_1 = "recruit_hp_inf_plaguebearers_1",
	wh3_main_nur_mon_beast_of_nurgle_0 = "recruit_hp_mon_beast_of_nurgle_0",
	wh3_main_nur_mon_great_unclean_one_0 = "recruit_hp_mon_great_unclean_one_0",
	wh3_main_nur_mon_plague_toads_0 = "recruit_hp_mon_plague_toads_0",
	wh3_main_nur_mon_rot_flies_0 = "recruit_hp_mon_rot_flies_0",
	wh3_main_nur_mon_soul_grinder_0 = "recruit_hp_mon_soul_grinder_0",
	wh3_main_nur_mon_spawn_of_nurgle_0 = "recruit_hp_mon_spawn_of_nurgle_0",
	wh_main_chs_mon_chaos_warhounds_1 = "recruit_hp_mon_chaos_warhounds_1",
	wh3_dlc20_chs_mon_warshrine_mnur = "recruit_hp_mon_warshrine_mnur",
	wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons = "recruit_hp_inf_chaos_warriors_mnur_greatweapons",
	wh3_dlc20_chs_inf_chaos_marauders_mnur = "recruit_hp_inf_chaos_marauders_mnur",
	wh3_dlc20_chs_cav_chaos_chariot_mnur = "recruit_hp_chaos_chariot_mnur",
	wh3_dlc20_chs_cav_chaos_knights_mnur = "recruit_hp_chaos_knights_mnur",
	wh3_dlc20_chs_cav_chaos_knights_mnur_lances = "recruit_hp_chaos_knights_mnur_lances",
	wh3_dlc20_chs_cav_marauder_horsemen_mnur_throwing_axes = "recruit_hp_marauder_horsemen_mnur_throwing_axes",
	wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons = "recruit_hp_chaos_marauders_mnur_greatweapons",
	wh3_dlc20_chs_inf_chaos_warriors_mnur = "recruit_hp_chaos_warriors_mnur",
	wh3_dlc20_chs_inf_chosen_mnur = "recruit_hp_chosen_mnur",
	wh3_dlc20_chs_inf_chosen_mnur_greatweapons = "recruit_hp_chosen_mnur_greatweapons"
,
}


function recruited_unit_health:initialise()
	core:add_listener(
		"UnitStartingHealth",
		"UnitTrained",
		function(context)
			if self.units_to_starting_health_bonus_values[context:unit():unit_key()] then
				local bonus_value = cm:get_forces_bonus_value(context:unit():military_force(), self.start_hp_bonus_value)
				return bonus_value > 0 and bonus_value < 100
			end
		end,
		function(context)
			local unit = context:unit()
			local force = unit:military_force()
			local base = cm:get_forces_bonus_value(force, self.start_hp_bonus_value)/100
			local unit_bonus = 0

			if self.units_to_starting_health_bonus_values[unit:unit_key()] then
				unit_bonus = cm:get_forces_bonus_value(force, self.units_to_starting_health_bonus_values[unit:unit_key()])/100
			end

			cm:set_unit_hp_to_unary_of_maximum(unit, math.clamp(base +unit_bonus, 0.01,1))
		end,
		true
	)

end