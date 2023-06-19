
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	QUESTS
--	This script kicks off character quests when they rank up to the required level
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function q_setup()
	local quests = {
		----------------------
		------- EMPIRE -------
		----------------------	
		["wh_main_emp_karl_franz"] = {			
			{"mission", "wh2_dlc13_anc_weapon_runefang_drakwald", "wh3_main_ie_qb_emp_karl_franz_reikland_runefang", 7, nil, "war.camp.advice.quests.001", 342, 585},
			{"mission", "wh_main_anc_weapon_ghal_maraz", "wh3_main_ie_qb_emp_karl_franz_ghal_maraz", 12, nil, nil, 440, 439},
			{"mission", "wh_main_anc_talisman_the_silver_seal", "wh3_main_ie_qb_emp_karl_franz_silver_seal", 17, nil, nil, 431, 496},
		},
		["wh_main_emp_balthasar_gelt"] = {			
			{"mission", "wh_main_anc_enchanted_item_cloak_of_molten_metal", "wh3_main_ie_qb_emp_balthasar_gelt_cloak_of_molten_metal", 7, nil, "war.camp.advice.quests.001", 347, 544},
			{"mission", "wh_main_anc_talisman_amulet_of_sea_gold", "wh3_main_ie_qb_emp_balthasar_gelt_amulet_of_sea_gold", 12, nil, nil, 267, 339},
			{"mission", "wh_main_anc_arcane_item_staff_of_volans", "wh3_main_ie_qb_emp_balthasar_gelt_staff_of_volans", 17, nil, nil, 367, 498},
		},		
		["wh_dlc04_emp_volkmar"] = {			
			{"mission", "wh_dlc04_anc_talisman_jade_griffon", "wh3_main_ie_qb_emp_volkmar_the_grim_jade_griffon", 7, nil, "war.camp.advice.quests.001", 465, 502},
			{"mission", "wh_dlc04_anc_weapon_staff_of_command", "wh3_main_ie_qb_emp_volkmar_the_grim_staff_of_command", 12, nil, nil, 343, 496},
		},
		["wh2_dlc13_emp_cha_markus_wulfhart"] = {			
			{"mission", "wh2_dlc13_anc_weapon_amber_bow", "wh3_main_ie_qb_emp_wulfhart_amber_bow", 7, nil, "war.camp.advice.quests.001", 118, 258},
		},
		
		----------------------
		------- DWARFS -------
		----------------------	
		["wh_dlc06_dwf_belegar"] = {			
			{"mission", "wh_dlc06_anc_weapon_the_hammer_of_angrund", "wh3_main_ie_qb_dwf_belegar_ironhammer_hammer_of_angrund", 12, nil, nil, 510, 348},
			{"mission", "wh_dlc06_anc_armour_shield_of_defiance", "wh3_main_ie_qb_dwf_belegar_ironhammer_shield_of_defiance", 7, nil, "war.camp.advice.quests.001", 531, 373},
		},
		["wh_pro01_dwf_grombrindal"] = {			
			{"mission", "wh_pro01_anc_armour_armour_of_glimril_scales", "wh3_main_ie_qb_dwf_grombrindal_armour_of_glimril", 7, nil, "war.camp.advice.quests.001", 337, 525},
			{"mission", "wh_pro01_anc_weapon_the_rune_axe_of_grombrindal", "wh3_main_ie_qb_dwf_grombrindal_rune_axe_of_grombrindal", 12, nil, nil, 422, 628},
			{"mission", "wh_pro01_anc_talisman_cloak_of_valaya", "wh3_main_ie_qb_dwf_grombrindal_rune_cloak_of_valaya", 17, nil, nil, 545, 588},
			{"mission", "wh_pro01_anc_enchanted_item_rune_helm_of_zhufbar", "wh3_main_ie_qb_dwf_grombrindal_rune_helm_of_zhufbar", 22, nil, nil, 531, 408},
		},
		["wh_main_dwf_thorgrim_grudgebearer"] = {			
			{"mission", "wh_main_anc_armour_the_armour_of_skaldour", "wh3_main_ie_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour", 12, nil, nil, 434, 622},
			{"mission", "wh_main_anc_weapon_the_axe_of_grimnir", "wh3_main_ie_qb_dwf_thorgrim_grudgebearer_axe_of_grimnir", 7, nil, "war.camp.advice.quests.001", 467, 277},
			{"mission", "wh_main_anc_enchanted_item_the_great_book_of_grudges", "wh3_main_ie_qb_dwf_thorgrim_grudgebearer_book_of_grudges", 22, nil, nil, 470, 498},
			{"mission", "wh_main_anc_talisman_the_dragon_crown_of_karaz", "wh3_main_ie_qb_dwf_thorgrim_grudgebearer_dragon_crown_of_karaz", 17, nil, nil, 440, 439},
		},
		["wh_main_dwf_ungrim_ironfist"] = {			
			{"mission", "wh_main_anc_weapon_axe_of_dargo", "wh3_main_ie_qb_dwf_ungrim_ironfist_axe_of_dargo", 17, nil, nil, 542, 593},
			{"mission", "wh_main_anc_talisman_dragon_cloak_of_fyrskar", "wh3_main_ie_qb_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar", 12, nil, nil, 506, 510},
			{"mission", "wh_main_anc_armour_the_slayer_crown", "wh3_main_ie_qb_dwf_ungrim_ironfist_slayer_crown", 7, nil, "war.camp.advice.quests.001", 353, 542},
		},
		["wh2_dlc17_dwf_thorek"] = {			
			{"mission", "wh2_dlc17_anc_armour_thoreks_rune_armour", "wh3_main_ie_qb_dwf_thorek_rune_armour_quest", 7},
			{"mission", "wh2_dlc17_anc_weapon_klad_brakak", "wh3_main_ie_qb_dwf_thorek_klad_brakak", 12, nil, "war.camp.advice.quests.001", 481, 156},
		},
		----------------------
		----- GREENSKINS -----
		----------------------	
		["wh2_dlc15_grn_grom_the_paunch"] = {			
			{"mission", "wh2_dlc15_anc_weapon_axe_of_grom", "wh3_main_ie_qb_grn_grom_axe_of_grom", 12, nil, "war.camp.advice.quests.001", 409, 214},
			{"mission", "wh2_dlc15_anc_enchanted_item_lucky_banner", "wh3_main_ie_qb_grn_grom_lucky_banner", 7},
		},
		["wh_dlc06_grn_skarsnik"] = {			
			{"mission", "wh_dlc06_anc_weapon_skarsniks_prodder", "wh3_main_ie_qb_grn_skarsnik_skarsniks_prodder", 7, nil, "war.camp.advice.quests.001", 512, 346},
		},
		["wh_dlc06_grn_wurrzag_da_great_prophet"] = {			
			{"mission", "wh_dlc06_anc_enchanted_item_baleful_mask", "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_baleful_mask", 7, nil, "war.camp.advice.quests.001", 416, 253},
			{"mission", "wh_dlc06_anc_arcane_item_squiggly_beast", "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast", 12, nil, nil, 364, 433},
			{"mission", "wh_dlc06_anc_weapon_bonewood_staff", "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff", 17, nil, nil, 475, 402},
		},
		["wh_main_grn_azhag_the_slaughterer"] = {			
			{"mission", "wh_main_anc_enchanted_item_the_crown_of_sorcery", "wh3_main_ie_qb_grn_azhag_the_slaughterer_crown_of_sorcery", 7, nil, "war.camp.advice.quests.001", 563, 601},
			{"mission", "wh_main_anc_armour_azhags_ard_armour", "wh3_main_ie_qb_grn_azhag_the_slaughterer_azhags_ard_armour", 12, nil, nil, 338, 361},
			{"mission", "wh_main_anc_weapon_slaggas_slashas", "wh3_main_ie_qb_grn_azhag_the_slaughterer_slaggas_slashas", 17, nil, nil, 416, 253},
		},
		["wh_main_grn_grimgor_ironhide"] = {			
			{"mission", "wh_main_anc_armour_blood-forged_armour", "wh3_main_ie_qb_grn_grimgor_ironhide_blood_forged_armour", 12, nil, nil, 542, 593},
			{"mission", "wh_main_anc_weapon_gitsnik", "wh3_main_ie_qb_grn_grimgor_ironhide_gitsnik", 7, nil, "war.camp.advice.quests.001", 450, 420},
		},

		----------------------
		--- VAMPIRE COUNTS ---
		----------------------	
		["wh_main_vmp_mannfred_von_carstein"] = {			
			{"mission", "wh_main_anc_armour_armour_of_templehof", "wh3_main_ie_qb_vmp_mannfred_von_carstein_armour_of_templehof", 12, nil, nil, 336, 367},
			{"mission", "wh_main_anc_weapon_sword_of_unholy_power", "wh3_main_ie_qb_vmp_mannfred_von_carstein_sword_of_unholy_power", 7, nil, "war.camp.advice.quests.001", 467, 277},
		},
		["wh_dlc04_vmp_helman_ghorst"] = {			
			{"mission", "wh_dlc04_anc_arcane_item_the_liber_noctus", "wh3_main_ie_qb_vmp_helman_ghorst_liber_noctus", 7, nil, "war.camp.advice.quests.001", 356, 357},
		},
		["wh_main_vmp_heinrich_kemmler"] = {			
			{"mission", "wh_main_anc_arcane_item_skull_staff", "wh3_main_ie_qb_vmp_heinrich_kemmler_skull_staff", 17, nil, nil, 337, 438},
			{"mission", "wh_main_anc_enchanted_item_cloak_of_mists_and_shadows", "wh3_main_ie_qb_vmp_heinrich_kemmler_cloak_of_mists", 12, nil, nil, 362, 499},
			{"mission", "wh_main_anc_weapon_chaos_tomb_blade", "wh3_main_ie_qb_vmp_heinrich_kemmler_chaos_tomb_blade", 7, nil, "war.camp.advice.quests.001", 356, 357},
		},
		["wh_dlc04_vmp_vlad_con_carstein"] = {			
			{"mission", "wh_dlc04_anc_talisman_the_carstein_ring", "wh3_main_ie_qb_vmp_vlad_von_carstein_the_carstein_ring", 12, nil, nil, 533, 314},
			{"mission", "wh_dlc04_anc_weapon_blood_drinker", "wh3_main_ie_qb_vmp_vlad_von_carstein_blood_drinker", 7, nil, "war.camp.advice.quests.001", 482, 505},
		},
		["wh_pro02_vmp_isabella_von_carstein"] = {			
			{"mission", "wh_pro02_anc_enchanted_item_blood_chalice_of_bathori", "wh3_main_ie_qb_vmp_isabella_von_carstein_blood_chalice_of_bathori", 8, nil, "war.camp.advice.quests.001", 478, 467},
		},
		
		----------------------
		-------- CHAOS -------
		----------------------	
		["wh_main_chs_archaon"] = {			
			{"mission", "wh_main_anc_armour_the_armour_of_morkar", "wh3_main_ie_qb_chs_archaon_armour_of_morkar", 12, nil, nil, 576, 617},
			{"mission", "wh_main_anc_enchanted_item_the_crown_of_domination", "wh3_main_ie_qb_chs_archaon_crown_of_domination", 22, nil, nil, 470, 701},
			{"mission", "wh_main_anc_talisman_the_eye_of_sheerian", "wh3_main_ie_qb_chs_archaon_eye_of_sheerian", 17, nil, nil, 596, 660},
			{"mission", "wh_main_anc_weapon_the_slayer_of_kings", "wh3_main_ie_qb_chs_archaon_slayer_of_kings", 7, nil, "war.camp.advice.quests.001", 543, 593},
		},
		["wh_dlc01_chs_prince_sigvald"] = {			
			{"mission", "wh_main_anc_armour_auric_armour", "wh3_main_ie_qb_chs_prince_sigvald_auric_armour", 12, nil, nil, 434, 622},
			{"mission", "wh_main_anc_weapon_sliverslash", "wh3_main_ie_qb_chs_prince_sigvald_sliverslash", 7, nil, "war.camp.advice.quests.001", 522, 649},
		},
		["wh_dlc01_chs_kholek_suneater"] = {			
			{"mission", "wh_main_anc_weapon_starcrusher", "wh3_main_ie_qb_chs_kholek_suneater_starcrusher", 7, nil, "war.camp.advice.quests.001", 565, 575},
		},
		["wh3_dlc20_sla_azazel"] = {
			{"mission", "wh3_dlc20_anc_weapon_daemonblade", "wh3_dlc20_ie_qb_chs_azazel_daemonblade", 15, nil, "wh3_dlc20_azazel_cam_quest_mission_001", 315, 729}
		},
		["wh3_dlc20_nur_festus"] = {
			{"mission", "wh3_dlc20_anc_enchanted_item_pestilent_potions", "wh3_dlc20_ie_qb_chs_festus_pestilent_potions", 15, nil, "wh3_dlc20_festus_cam_quest_mission_001", 435, 728}
		},
		["wh3_dlc20_kho_valkia"] = {
			{"mission", "wh3_dlc20_anc_armour_the_scarlet_armour", "wh3_dlc20_ie_qb_chs_valkia_the_scarlet_armour", 8},
			{"mission", "wh3_dlc20_anc_enchanted_item_daemonshield", "wh3_dlc20_ie_qb_chs_valkia_daemonshield", 12},
			{"mission", "wh3_dlc20_anc_weapon_the_spear_slaupnir", "wh3_dlc20_ie_qb_chs_valkia_the_spear_slaupnir", 15, nil, "wh3_dlc20_valkia_cam_quest_mission_001", 566, 700}
		},
		["wh3_dlc20_tze_vilitch"] = {
			{"mission", "wh3_dlc20_anc_arcane_item_vessel_of_chaos", "wh3_dlc20_ie_qb_chs_vilitch_vessel_of_chaos", 15, nil, "wh3_dlc20_vilitch_cam_quest_mission_001", 490, 709}
		},
		["wh3_main_dae_belakor"] = {
			{"reward", "wh3_main_anc_weapon_blade_of_shadow", nil, 7}
		},
		----------------------
		------ BEASTMEN ------
		----------------------	
		["wh_dlc03_bst_khazrak"] = {			
			{"mission", "wh_dlc03_anc_armour_the_dark_mail", "wh3_main_ie_qb_bst_khazrak_one_eye_the_dark_mail", 12, nil, nil, 418, 553},
			{"mission", "wh_dlc03_anc_weapon_scourge", "wh3_main_ie_qb_bst_khazrak_one_eye_scourge", 7, nil, "war.camp.advice.quests.001", 360, 544},
		},
		["wh_dlc03_bst_malagor"] = {			
			{"mission", "wh_dlc03_anc_enchanted_item_icons_of_vilification", "wh3_main_ie_qb_bst_malagor_the_dark_omen_the_icons_of_vilification", 7, nil, "war.camp.advice.quests.001", 389, 490},
		},
		["wh_dlc05_bst_morghur"] = {			
			{"mission", "wh_main_anc_weapon_stave_of_ruinous_corruption", "wh3_main_ie_qb_bst_morghur_stave_of_ruinous_corruption", 7, nil, "war.camp.advice.quests.001", 276, 483},
		},
		["wh2_dlc17_bst_taurox"] = {			
			{"mission", "wh2_dlc17_anc_weapon_rune_tortured_axes", "wh3_main_ie_qb_bst_taurox_rune_tortured_axes", 7, nil, "war.camp.advice.quests.001", 108, 637},
		},
		
		---------------------
		----- WOOD ELVES -----
		----------------------	
		["wh_dlc05_wef_orion"] = {
			{"mission", "wh_dlc05_anc_enchanted_item_horn_of_the_wild_hunt", "wh3_main_ie_qb_wef_orion_the_horn_of_the_wild", 7, nil, "war.camp.advice.quests.001", 334, 427},
			{"mission", "wh_dlc05_anc_talisman_cloak_of_isha", "wh3_main_ie_qb_wef_orion_the_cloak_of_isha", 12, nil, nil, 335, 414},
			{"mission", "wh_dlc05_anc_weapon_spear_of_kurnous", "wh3_main_ie_qb_wef_orion_the_spear_of_kurnous", 17, nil, nil, 335, 397},
		},
		["wh_dlc05_wef_durthu"] = {
			{"mission", "wh_dlc05_anc_weapon_daiths_sword", "wh3_main_ie_qb_wef_durthu_daiths_sword", 7, nil, "war.camp.advice.quests.001", 335, 397},
		},
		["wh2_dlc16_wef_sisters_of_twilight"] = {
			{"mission", "wh2_dlc16_anc_mount_wef_cha_sisters_of_twilight_forest_dragon", "wh3_main_ie_qb_wef_sisters_dragon", 12, nil, "war.camp.advice.quests.001", 58, 489},
		},
		["wh2_dlc16_wef_drycha"] = {
			{"mission", "wh2_dlc16_anc_enchanted_item_fang_of_taalroth", "wh3_main_ie_qb_wef_drycha_coeddil_unchained", 7, nil, "war.camp.advice.quests.001", 348, 404},
		},

		----------------------
		------ BRETONNIA -----
		----------------------	
		["wh_main_brt_louen_leoncouer"] = {			
			{"mission", "wh_main_anc_weapon_the_sword_of_couronne", "wh3_main_ie_qb_brt_louen_sword_of_couronne", 12, nil, "war.camp.advice.quests.001", 276, 483},
			{"mission", "wh2_dlc12_anc_armour_brt_armour_of_brilliance", "wh3_main_ie_qb_brt_louen_armour_of_brilliance", 3},
		},
		["wh_dlc07_brt_fay_enchantress"] = {			
			{"mission", "wh_dlc07_anc_arcane_item_the_chalice_of_potions", "wh3_main_ie_qb_brt_fay_enchantress_chalice_of_potions", 12, nil, "war.camp.advice.quests.001", 258, 535},
			{"mission", "wh2_dlc12_anc_enchanted_item_brt_morgianas_mirror", "wh3_main_ie_qb_brt_fay_morgianas_mirror", 3},
		},
		["wh_dlc07_brt_alberic"] = {			
			{"mission", "wh_dlc07_anc_weapon_trident_of_manann", "wh3_main_ie_qb_brt_alberic_trident_of_bordeleaux", 7, nil, "war.camp.advice.quests.001", 264, 347},
			{"mission", "wh2_dlc12_anc_enchanted_item_brt_braid_of_bordeleaux", "wh3_main_ie_qb_brt_alberic_braid_of_bordeleaux", 12},
		},
		["wh2_dlc14_brt_repanse"] = {			
			{"mission", "wh2_dlc14_anc_weapon_sword_of_lyonesse", "wh3_main_ie_qb_brt_repanse_sword_of_lyonesse", 7, nil, "war.camp.advice.quests.001", 325, 237},
		},
		
		----------------------
		------- NORSCA -------
		----------------------
		["wh_dlc08_nor_wulfrik"] = {
			{"mission", "wh_dlc08_anc_weapon_sword_of_torgald", "wh3_main_ie_qb_nor_wulfrik_the_wanderer_sword_of_torgald", 7, nil, "war.camp.advice.quests.001", 251, 500},
		},
		["wh_dlc08_nor_throgg"] = {
			{"mission", "wh_dlc08_anc_enchanted_item_wintertooth_crown", "wh3_main_ie_qb_nor_throgg_wintertooth_crown", 7, nil, "war.camp.advice.quests.001", 502, 509},
		},
		
		----------------------
		----- HIGH ELVES -----
		----------------------
		["wh2_main_hef_tyrion"] = {
			{"mission", "wh2_main_anc_armour_dragon_armour_of_aenarion", "wh3_main_ie_qb_hef_tyrion_dragon_armour_of_aenarion", 7, nil, "war.camp.advice.quest.tyrion.dragon_armour_of_aenarion.001", 135, 398},
			{"mission", "wh2_main_anc_weapon_sunfang", "wh3_main_ie_qb_hef_tyrion_sunfang", 12, nil, "war.camp.advice.quest.tyrion.sunfang.001", 196, 438},
			{"mission", "wh2_main_anc_enchanted_item_heart_of_avelorn", "wh3_main_ie_qb_hef_tyrion_heart_of_avelorn", 17},
		},
		["wh2_main_hef_teclis"] = {
			{"mission", "wh2_main_anc_enchanted_item_scroll_of_hoeth", "wh2_main_vortex_narrative_hef_the_lies_of_the_druchii", 2},
			{"mission", "wh2_main_anc_arcane_item_moon_staff_of_lileath", "wh2_main_vortex_narrative_hef_the_vermin_of_hruddithi", 4},
			{"mission", "wh2_main_anc_armour_war_crown_of_saphery", "wh3_main_ie_qb_hef_teclis_war_crown_of_saphery", 7, nil, "war.camp.advice.quest.teclis.war_crown_of_saphery.001", 91, 173},
			{"mission", "wh2_main_anc_weapon_sword_of_teclis", "wh3_main_ie_qb_hef_teclis_sword_of_teclis", 12, nil, "war.camp.advice.quest.teclis.sword_of_teclis.001", 135, 398},
		},
		["wh2_dlc10_hef_alarielle"] = {
			{"mission", "wh2_dlc10_anc_talisman_shieldstone_of_isha", "wh3_main_ie_qb_hef_alarielle_shieldstone_of_isha", 7},
			{"mission", "wh2_dlc10_anc_enchanted_item_star_of_avelorn", "wh3_main_ie_qb_hef_alarielle_star_of_avelorn", 12, nil, "war.camp.advice.quests.001", 260, 601},
		},
		["wh2_dlc10_hef_alith_anar"] = {
			{"mission", "wh2_dlc10_anc_enchanted_item_the_shadow_crown", "wh3_main_ie_qb_hef_alith_anar_the_shadow_crown", 4},
			{"mission", "wh2_dlc10_anc_weapon_moonbow", "wh3_main_ie_qb_hef_alith_anar_the_moonbow", 7, nil, "war.camp.advice.quests.001", 43, 421},
		},
		["wh2_dlc15_hef_eltharion"] = {
			{"mission", "wh2_dlc15_anc_talisman_talisman_of_hoeth", "wh3_main_ie_qb_hef_eltharion_talisman_of_hoeth", 7, nil, "war.camp.advice.quests.001", 213, 420},
			{"mission", "wh2_dlc15_anc_armour_helm_of_yvresse", "wh3_main_ie_qb_hef_eltharion_helm_of_yvresse", 12},
			{"mission", "wh2_dlc15_anc_weapon_fangsword_of_eltharion", "wh3_main_ie_qb_hef_eltharion_fangsword_of_eltharion", 17},
		},
		["wh2_dlc15_hef_imrik"] = {
			{"mission", "wh2_dlc15_anc_armour_armour_of_caledor", "wh3_main_ie_qb_hef_imrik_armour_of_caledor", 8, nil, "war.camp.advice.quests.001", 164, 509},
		},
		
		----------------------
		----- DARK ELVES -----
		----------------------	
		["wh2_main_def_malekith"] = {
			{"mission", "wh2_main_anc_arcane_item_circlet_of_iron", "wh3_main_ie_qb_def_malekith_circlet_of_iron", 7, nil, "war.camp.advice.quest.malekith.circlet_of_iron.001", 37, 643},
			{"mission", "wh2_main_anc_weapon_destroyer", "wh3_main_ie_qb_def_malekith_destroyer", 12, nil, "war.camp.advice.quest.malekith.destroyer.001", 135, 398},
			{"mission", "wh2_main_anc_enchanted_item_supreme_spellshield", "wh3_main_ie_qb_def_malekith_supreme_spellshield", 17, nil, "war.camp.advice.quest.malekith.supreme_spellshield.001", 148, 222},
			{"mission", "wh2_main_anc_armour_armour_of_midnight", "wh3_main_ie_qb_def_malekith_armour_of_midnight", 4},
		},
		["wh2_main_def_morathi"] = {
			{"mission", "wh2_main_anc_weapon_heartrender_and_the_darksword", "wh3_main_ie_qb_def_morathi_heartrender_and_the_darksword", 12, nil, "war.camp.advice.quest.morathi.heartrender_and_the_darksword.001", 83, 454},
			{"mission", "wh2_main_anc_arcane_item_wand_of_the_kharaidon", "wh3_main_ie_qb_def_morathi_wand_of_kharaidon", 7},
			{"mission", "wh2_main_anc_talisman_amber_amulet", "wh3_main_ie_qb_def_morathi_amber_amulet", 4},
		},
		["wh2_dlc10_def_crone_hellebron"] = {
			{"mission", "wh2_dlc10_anc_weapon_deathsword_and_the_cursed_blade", "wh3_main_ie_qb_def_hellebron_deathsword_and_the_cursed_blade", 12, nil, "war.camp.advice.quests.001", 37, 643},
			{"mission", "wh2_dlc10_anc_talisman_amulet_of_dark_fire", "wh3_main_ie_qb_def_hellebron_amulet_of_dark_fire", 7},
		},
		["wh2_dlc11_def_lokhir"] = {
			{"mission", "wh2_main_anc_armour_helm_of_the_kraken", "wh3_main_ie_qb_lokhir_helm_of_the_kraken", 12, nil, "wh2_dlc11.camp.advice.quest.lokhir.001", 158, 128},
			{"mission", "wh2_dlc11_anc_weapon_red_blades", "wh3_main_ie_qb_def_lokhir_red_blades", 3},
		},
		["wh2_dlc14_def_malus_darkblade"] = {
			{"mission", "wh2_dlc14_anc_weapon_warpsword_of_khaine", "wh3_main_ie_qb_def_malus_warpsword_of_khaine", 7, nil, "war.camp.advice.quests.001", 492, 128},
		},
		["wh2_twa03_def_rakarth"] = {
			{"mission", "wh2_twa03_anc_weapon_whip_of_agony", "wh3_main_ie_qb_def_rakarth_whip_of_agony", 7, nil, "war.camp.advice.quests.001", 238, 557},
		},

		----------------------
		------ LIZARDMEN -----
		----------------------	
		["wh2_main_lzd_lord_mazdamundi"] = {
			{"mission", "wh2_main_anc_weapon_cobra_mace_of_mazdamundi", "wh3_main_ie_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi", 12, nil, "war.camp.advice.quest.mazdamundi.cobra_mace_of_mazdamundi.001", 54, 295},
			{"mission", "wh2_main_anc_magic_standard_sunburst_standard_of_hexoatl", "wh3_main_ie_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl", 7, nil, "war.camp.advice.quest.mazdamundi.sunburst_standard_of_hexoatl.001", 35, 392},
		},
		["wh2_main_lzd_kroq_gar"] = {
			{"mission", "wh2_main_anc_enchanted_item_hand_of_gods", "wh3_main_ie_qb_liz_kroq_gar_hand_of_gods", 12, nil, "war.camp.advice.quest.kroqgar.hand_of_gods.001", 35, 392},
			{"mission", "wh2_main_anc_weapon_revered_spear_of_tlanxla", "wh3_main_ie_qb_liz_kroq_gar_revered_spear_of_tlanxla", 7, nil, "war.camp.advice.quest.kroqgar.revered_spear_of_tlanxla.001", 153, 229},
		},
		["wh2_dlc12_lzd_tehenhauin"] = {
			{"mission", "wh2_dlc12_anc_enchanted_item_plaque_of_sotek", "wh3_main_ie_qb_lzd_tehenhauin_plaque_of_sotek", 7, nil, "war.camp.advice.quests.001", 107, 201},
		},
		["wh2_dlc12_lzd_tiktaqto"] = {
			{"mission", "wh2_dlc12_anc_enchanted_item_mask_of_heavens", "wh3_main_ie_qb_lzd_tiktaqto_mask_of_heavens", 7, nil, "war.camp.advice.quests.001", 331, 191},
		},
		["wh2_dlc13_lzd_nakai"] = {
			{"mission", "wh2_dlc13_anc_enchanted_item_golden_tributes", "wh3_main_ie_qb_lzd_nakai_golden_tributes", 7, nil, "war.camp.advice.quests.001", 105, 195},
			{"mission", "wh2_dlc13_talisman_the_ogham_shard", "wh3_main_ie_qb_lzd_nakai_the_ogham_shard", 10, nil, nil, 227, 566},
		},
		["wh2_dlc13_lzd_gor_rok"] = {
			{"mission", "wh2_dlc13_anc_armour_the_shield_of_aeons", "wh3_main_ie_qb_lzd_gorrok_the_shield_of_aeons", 7, nil, "war.camp.advice.quests.001", 107, 201},
			{"mission", "wh2_dlc13_anc_weapon_mace_of_ulumak", "wh3_main_ie_qb_lzd_the_mace_of_ulumak", 3}
		},
		["wh2_dlc17_lzd_oxyotl"] = {
			{"mission", "wh2_dlc17_anc_weapon_the_golden_blowpipe_of_ptoohee", "wh3_main_ie_qb_lzd_oxyotl_the_golden_blowpipe_of_ptoohee", 7, nil, "war.camp.advice.quests.001", 248, 679},
		},
		
		----------------------
		------- SKAVEN -------
		----------------------	
		["wh2_main_skv_queek_headtaker"] = {
			{"mission", "wh2_main_anc_armour_warp_shard_armour", "wh3_main_ie_qb_skv_queek_headtaker_warp_shard_armour", 7, nil, "war.camp.advice.quest.queek.warp_shard_armour.001", 398, 246},
			{"mission", "wh2_main_anc_weapon_dwarf_gouger", "wh3_main_ie_qb_skv_queek_headtaker_dwarfgouger", 12, nil, "war.camp.advice.quest.queek.dwarfgouger.001", 486, 297},
		},
		["wh2_main_skv_lord_skrolk"] = {
			{"mission", "wh2_main_anc_arcane_item_the_liber_bubonicus", "wh3_main_ie_qb_skv_skrolk_liber_bubonicus", 7, nil, "war.camp.advice.quest.skrolk.liber_bubonicus.001", 114, 155},
			{"mission", "wh2_main_anc_weapon_rod_of_corruption", "wh3_main_ie_qb_skv_skrolk_rod_of_corruption", 12, nil, "war.camp.advice.quest.skrolk.rod_of_corruption.001", 44, 287},
		},
		["wh2_dlc09_skv_tretch_craventail"] = {
			{"mission", "wh2_dlc09_anc_enchanted_item_lucky_skullhelm", "wh3_main_ie_qb_skv_tretch_lucky_skullhelm", 7, nil, "dlc09.camp.advice.quest.tretch.lucky_skullhelm.001", 75, 523},
		},
		["wh2_dlc12_skv_ikit_claw"] = {
			{"mission", "wh2_dlc12_anc_weapon_storm_daemon", "wh3_main_ie_qb_ikit_claw_storm_daemon", 7, nil, "war.camp.advice.quests.001", 97, 270},
		},
		["wh2_dlc14_skv_deathmaster_snikch"] = {
			{"mission", "wh2_dlc14_anc_armour_the_cloak_of_shadows", "wh3_main_ie_qb_skv_snikch_the_cloak_of_shadows", 7, nil, "war.camp.advice.quests.001", 546, 278},
			{"mission", "wh2_dlc14_anc_weapon_whirl_of_weeping_blades", "wh3_main_ie_qb_skv_snikch_whirl_of_weeping_blades", 3},
		},
		["wh2_dlc16_skv_throt_the_unclean"] = {
			{"mission", "wh2_dlc16_anc_enchanted_item_whip_of_domination", "wh3_main_ie_qb_skv_throt_main_whip_of_domination", 7, nil, "war.camp.advice.quests.001", 462, 618},
			{"mission", "wh2_dlc16_anc_weapon_creature_killer", "wh3_main_ie_qb_skv_throt_main_creature_killer", 3},
		},

		----------------------
		----- TOMB KINGS -----
		----------------------	
		["wh2_dlc09_tmb_settra"] = {
			{"mission", "wh2_dlc09_anc_enchanted_item_the_crown_of_nehekhara", "wh3_main_ie_qb_tmb_settra_the_crown_of_nehekhara", 7, nil, "dlc09.camp.advice.quest.settra.the_crown_of_nehekhara.001", 329, 601},
			{"mission", "wh2_dlc09_anc_weapon_the_blessed_blade_of_ptra", "wh3_main_ie_qb_tmb_settra_the_blessed_blade_of_ptra", 12, nil, "dlc09.camp.advice.quest.settra.the_blessed_blade_of_ptra.001", 474, 239},
		},
		["wh2_dlc09_tmb_arkhan"] = {
			{"mission", "wh2_dlc09_anc_weapon_the_tomb_blade_of_arkhan", "wh3_main_ie_qb_tmb_arkhan_the_tomb_blade_of_arkhan", 7, nil, "dlc09.camp.advice.quest.arkhan.the_tomb_blade_of_arkhan.001", 362, 168},
			{"mission", "wh2_dlc09_anc_arcane_item_staff_of_nagash", "wh3_main_ie_qb_tmb_arkhan_the_staff_of_nagash", 12, nil, "dlc09.camp.advice.quest.arkhan.the_staff_of_nagash.001", 370, 218},
		},
		["wh2_dlc09_tmb_khatep"] = {
			{"mission", "wh2_dlc09_anc_arcane_item_the_liche_staff", "wh3_main_ie_qb_tmb_khatep_the_liche_staff", 7, nil, "dlc09.camp.advice.quest.khatep.the_liche_staff.001", 16, 571},
		},
		["wh2_dlc09_tmb_khalida"] = {
			{"mission", "wh2_dlc09_anc_weapon_the_venom_staff", "wh3_main_ie_qb_tmb_khalida_venom_staff", 12, nil, "dlc09.camp.advice.quest.khalida.venom_staff.001", 434, 221},
		},
		
		----------------------
		---- VAMPIRE COAST ---
		----------------------	
		["wh2_dlc11_cst_harkon"] = {
			{"mission", "wh2_dlc11_anc_enchanted_item_slann_gold", "wh3_main_ie_qb_cst_harkon_quest_for_slann_gold", 12, nil, "wh2_dlc11.camp.advice.quest.harkon.001", 89, 354},
		},
		["wh2_dlc11_cst_noctilus"] = {
			{"mission", "wh2_dlc11_anc_enchanted_item_captain_roths_moondial", "wh3_main_ie_qb_cst_noctilus_captain_roths_moondial", 12, nil, "wh2_dlc11.camp.advice.quest.noctilus.001", 220, 230},
		},
		["wh2_dlc11_cst_aranessa"] = {
			{"mission", "wh2_dlc11_anc_weapon_krakens_bane", "wh3_main_ie_qb_cst_aranessa_krakens_bane", 12, nil, "wh2_dlc11.camp.advice.quest.aranessa.001", 260, 590},
		},
		["wh2_dlc11_cst_cylostra"] = {
			{"mission", "wh2_dlc11_anc_arcane_item_the_bordeleaux_flabellum", "wh3_main_ie_qb_cst_cylostra_the_bordeleaux_flabellum", 7, nil, "wh2_dlc11.camp.advice.quest.cylostra.001", 218, 492},
		},
		
		----------------------
		------- KISLEV -------
		----------------------	
		["wh3_main_ksl_katarin"] = {
			{"mission", "wh3_main_anc_weapon_frost_fang", "wh3_main_ie_qb_ksl_katarin_frost_fang", 7},
			{"mission", "wh3_main_anc_armour_the_crystal_cloak", "wh3_main_ie_qb_ksl_katarin_crystal_cloak", 10, nil, "wh3_main_camp_quest_katarin_the_crystal_cloak_001", 497, 698}
		},
		["wh3_main_ksl_kostaltyn"] = {
			{"mission", "wh3_main_anc_weapon_the_burning_brazier", "wh3_main_ie_qb_ksl_kostaltyn_burning_brazier", 10, nil, "wh3_main_camp_quest_kostaltyn_burning_brazier_001", 417, 610}
		},
		["wh3_main_ksl_boris"] = {
			{"mission", "wh3_main_anc_weapon_shard_blade", "wh3_main_ie_qb_ksl_boris_shard_blade", 7},
			{"mission", "wh3_main_anc_armour_armour_of_ursun", "wh3_main_ie_qb_ksl_boris_armour_of_ursun", 10}
		},

		----------------------
		---- OGRE KINGDOMS ---
		----------------------	
		["wh3_main_ogr_greasus_goldtooth"] = {
			{"mission", "wh3_main_anc_weapon_sceptre_of_titans", "wh3_main_ie_qb_ogr_greasus_sceptre_of_titans", 7},
			{"mission", "wh3_main_anc_talisman_overtyrants_crown", "wh3_main_ie_qb_ogr_greasus_overtyrants_crown", 10, nil, "wh3_main_camp_quest_greasus_overtyrants_crown_001", 665, 432}
		},
		["wh3_main_ogr_skrag_the_slaughterer"] = {
			{"mission", "wh3_main_anc_enchanted_item_cauldron_of_the_great_maw", "wh3_main_ie_qb_ogr_skrag_cauldron_of_the_great_maw", 10, nil, "wh3_main_camp_quest_skrag_cauldron_of_the_great_maw_001", 647, 544}
		},
		
		----------------------
		-------- KHORNE ------
		----------------------	
		["wh3_main_kho_skarbrand"] = {
			{"mission", "wh3_main_anc_weapon_slaughter_and_carnage", "wh3_main_ie_qb_kho_skarbrand_slaughter_and_carnage", 10, nil, "wh3_main_camp_quest_skarbrand_slaughter_and_carnage_001", 528, 670}
		},

		----------------------
		-------- NURGLE ------
		----------------------
		["wh3_main_nur_kugath"] = {
			{"mission", "wh3_main_anc_weapon_necrotic_missiles", "wh3_main_ie_qb_nur_kugath_necrotic_missiles", 10, nil, "wh3_main_camp_quest_kugath_necrotic_missiles_001", 585, 588}
		},

		----------------------
		------- SLAANESH -----
		----------------------
		["wh3_main_sla_nkari"] = {
			{"mission", "wh3_main_anc_weapon_witstealer_sword", "wh3_main_ie_qb_sla_nkari_witstealer_sword", 10, nil, "wh3_main_camp_quest_nkari_witstealer_sword_001", 264, 626}
		},

		----------------------
		------- TZEENCH ------
		----------------------
		["wh3_main_tze_kairos"] = {
			{"mission", "wh3_main_anc_arcane_item_staff_of_tomorrow", "wh3_main_ie_qb_tze_kairos_staff_of_tomorrow", 10, nil, "wh3_main_camp_quest_kairos_staff_of_tomorrow_001", 490, 711}
		},

		----------------------
		---- CHAOS DWARFS ----
		----------------------
		["wh3_dlc23_chd_drazhoath"] = {
			{"mission", "wh3_dlc23_anc_weapon_the_graven_sceptre", "wh3_dlc23_ie_chd_drazhoath_the_graven_sceptre", 8},
			{"mission", "wh3_dlc23_anc_arcane_item_daemonspite_crucible", "wh3_dlc23_ie_chd_drazhoath_daemonspite_crucible", 12},
			{"mission", "wh3_dlc23_anc_talisman_hellshard_amulet", "wh3_dlc23_ie_chd_drazhoath_hellshard_amulet", 15, nil, "wh3_dlc23_drazhoath_cam_quest_mission_001", 627, 340}
		},
		["wh3_dlc23_chd_zhatan"] = {
			{"mission", "wh3_dlc23_anc_armour_chd_armour_of_gazrakh", "wh3_dlc23_ie_qb_chd_zhatan_armour_of_gazrakh", 8},
			{"mission", "wh3_dlc23_anc_weapon_chd_the_obsidian_axe", "wh3_dlc23_ie_qb_chd_zhatan_the_obsidian_axe", 12},
			{"mission", "wh3_dlc23_anc_enchanted_item_chd_chaos_runeshield", "wh3_dlc23_ie_qb_chd_zhatan_chaos_runeshield", 15, nil, "wh3_dlc23_zhatan_cam_quest_mission_001", 608, 501}
		},
		["wh3_dlc23_chd_astragoth"] = {
			{"mission", "wh3_dlc23_anc_talisman_stone_mantle", "wh3_dlc23_ie_chd_astragoth_stone_mantle", 8},
			{"mission", "wh3_dlc23_anc_weapon_black_hammer_of_hashut", "wh3_dlc23_ie_qb_chd_astragoth_black_hammer_of_hashut", 12, nil, "wh3_dlc23_astragoth_cam_quest_mission_001", 569, 508}
		}
	}
	
	-- assemble infotext about quests
	local infotext = {
		"wh2.camp.advice.quests.info_001",
		"wh2.camp.advice.quests.info_002",
		"wh2.camp.advice.quests.info_003"
	};
	
	-- establish the listeners
	for k, v in pairs(quests) do
		set_up_rank_up_listener(v, k, infotext);
	end;
end;