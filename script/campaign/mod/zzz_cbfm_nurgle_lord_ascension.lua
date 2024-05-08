local function init()
	if not greater_daemons.character_types then
		ModLog("CBFM: Greater Daemon character type list not found! Can't proceed with modifying this list to fix Nurgle Chaos Lord ascension.")
		return nil
	end
	greater_daemons.character_types = {
		wh3_main_kho_herald_of_khorne = {
			agent = "wh3_main_kho_exalted_bloodthirster", 
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_kho",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "kho"
		},
		wh3_main_nur_herald_of_nurgle_death	= {
			agent = "wh3_main_nur_exalted_great_unclean_one_death",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_nur",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "nur"
		},
		wh3_main_nur_herald_of_nurgle_nurgle = {
			agent = "wh3_main_nur_exalted_great_unclean_one_nurgle",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_nur",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "nur"
		},
		wh3_main_sla_herald_of_slaanesh_shadow	= {
			agent = "wh3_main_sla_exalted_keeper_of_secrets_shadow",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_sla",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "sla"
		},
		wh3_main_sla_herald_of_slaanesh_slaanesh = {
			agent = "wh3_main_sla_exalted_keeper_of_secrets_slaanesh",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_sla",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "sla"
		},
		wh3_main_tze_herald_of_tzeentch_metal = {
			agent = "wh3_main_tze_exalted_lord_of_change_metal",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_tze",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "tze"
		},
		wh3_main_tze_herald_of_tzeentch_tzeentch = {
			agent = "wh3_main_tze_exalted_lord_of_change_tzeentch",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_tze",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "tze"
		},
		wh3_dlc20_chs_lord_mkho = {
			agent = "wh3_dlc20_chs_daemon_prince_khorne",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		wh3_dlc20_chs_lord_msla	= {
			agent = "wh3_dlc20_chs_daemon_prince_slaanesh",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		wh3_dlc24_chs_lord_mtze = {
			agent = "wh3_dlc20_chs_daemon_prince_tzeentch",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		-- CBFM fix: "wh3_dlc25_chs_lord_nurgle_mnur" changed to correct key, which does not have "nurgle" in it
		wh3_dlc25_chs_lord_mnur = {
			agent = "wh3_dlc20_chs_daemon_prince_nurgle",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		wh3_dlc20_chs_sorcerer_lord_death_mnur = {
			agent = "wh3_dlc20_chs_daemon_prince_nurgle",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		wh3_dlc20_chs_sorcerer_lord_nurgle_mnur = {
			agent = "wh3_dlc20_chs_daemon_prince_nurgle",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		wh3_dlc20_chs_sorcerer_lord_metal_mtze = {
			agent = "wh3_dlc20_chs_daemon_prince_tzeentch", 
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension",
		},
		wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze = {
			agent =  "wh3_dlc20_chs_daemon_prince_tzeentch",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		}
	}
end

cm:add_pre_first_tick_callback(init)