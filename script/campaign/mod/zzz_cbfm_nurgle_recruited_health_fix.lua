-- recruited_unit_health object is defined in main campaign script wh3_campaign_recruited_unit_health.lua, which should load before this
if not recruited_unit_health then
	ModLog("CBFM: recruited_unit_health object not found; Nurgle recruitment HP fix will not function!")
else
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
		wh3_dlc20_chs_inf_chaos_marauders_mnur = "recruit_hp_inf_chaos_marauders_mnur",
		wh3_dlc20_chs_cav_chaos_chariot_mnur = "recruit_hp_chaos_chariot_mnur",
		wh3_dlc20_chs_cav_chaos_knights_mnur = "recruit_hp_chaos_knights_mnur",
		wh3_dlc20_chs_cav_chaos_knights_mnur_lances = "recruit_hp_chaos_knights_mnur_lances",
		wh3_dlc20_chs_cav_marauder_horsemen_mnur_throwing_axes = "recruit_hp_marauder_horsemen_mnur_throwing_axes",
		wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons = "recruit_hp_chaos_marauders_mnur_greatweapons",
		wh3_dlc20_chs_inf_chaos_warriors_mnur = "recruit_hp_chaos_warriors_mnur",
		wh3_dlc20_chs_inf_chosen_mnur = "recruit_hp_chosen_mnur",
		wh3_dlc20_chs_inf_chosen_mnur_greatweapons = "recruit_hp_chosen_mnur_greatweapons"
	}
end