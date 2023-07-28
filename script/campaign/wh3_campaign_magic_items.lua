--------Fixes arcane drop chances for armies with caster heroes
--------Adds missing ancillaries (marked as randomly dropped in the db) to the list
--------Adds CD ancillaries, previously these could only be dropped by the tower of zharr -  not clear if intentional
--------This needs to be likely updated with each patch to keep the ancillary list up to date


local ancillary_list = {
	["armour"] = {
		["common"] = {
			"wh_dlc03_anc_armour_blackened_plate",
			"wh_dlc03_anc_armour_ramhorn_helm",
			"wh_dlc05_anc_armour_the_helm_of_the_hunt",
			"wh_dlc07_anc_armour_cuirass_of_fortune",
			"wh_main_anc_armour_charmed_shield",
			"wh_main_anc_armour_dragonhelm",
			"wh_main_anc_armour_enchanted_shield",
			"wh_main_anc_armour_gamblers_armour",
			"wh_main_anc_armour_glittering_scales",
			"wh_main_anc_armour_shield_of_ptolos",
			"wh_main_anc_armour_spellshield",
			"wh2_main_anc_armour_armour_of_darkness",
			"wh2_main_anc_armour_cloak_of_hag_graef",
			"wh2_main_anc_armour_dragonscale_shield",
			"wh2_main_anc_armour_helm_of_fortune",
			"wh2_main_anc_armour_shadow_armour",
			"wh2_main_anc_armour_shield_of_distraction",
			"wh2_main_anc_armour_shield_of_the_merwyrm",
			"wh2_main_anc_armour_the_bane_shield",
			"wh2_main_anc_armour_worlds_edge_armour",
			"wh3_main_anc_armour_greatskull",
			"wh3_main_anc_armour_quicksilver_armour"
		},

		["uncommon"] = {
			"wh_dlc03_anc_armour_pelt_of_the_shadowgave",
			"wh_dlc07_anc_armour_armour_of_the_midsummer_sun",
			"wh_main_anc_armour_armour_of_fortune",
			"wh_main_anc_armour_armour_of_silvered_steel",
			"wh_main_anc_armour_helm_of_discord",
			"wh_main_anc_armour_helm_of_many_eyes",
			"wh_main_anc_armour_nightshroud",
			"wh_dlc08_anc_armour_helm_of_reavers",
			"wh2_main_anc_armour_armour_of_the_stars",
			"wh2_main_anc_armour_sacred_stegadon_helm_of_itza",
			"wh2_main_anc_armour_shield_of_ghrond",
			"wh2_main_anc_armour_shield_of_the_mirrored_pool",
			"wh2_main_anc_armour_the_maiming_shield",
			"wh2_main_anc_armour_warpstone_armour",
			"wh2_dlc11_anc_armour_seadragon_buckler",
			"wh3_main_anc_armour_great_bear_pelt",
			"wh3_main_anc_armour_shield_of_sacrifice",
			"wh3_main_anc_armour_gut_maw",
			"wh3_main_anc_armour_mastodon_armour",
			"wh3_main_anc_armour_laminate_shield",
			"wh3_dlc20_anc_armour_bronze_armour_of_zhrakk",
			---CD ancillaries
			"wh3_dlc23_anc_armour_armour_of_the_forge"
		},

		["rare"] = {
			"wh_dlc03_anc_armour_trollhide",
			"wh_dlc07_anc_armour_gilded_cuirass",
			"wh_dlc07_anc_armour_the_grail_shield",
			"wh_main_anc_armour_armour_of_destiny",
			"wh_main_anc_armour_armour_of_gork",
			"wh_main_anc_armour_magnificent_armour_of_borek_beetlebrow",
			"wh_main_anc_armour_the_armour_of_meteoric_iron",
			"wh_main_anc_armour_tricksters_helm",
			"wh_dlc08_anc_armour_blood_stained_armour_of_morkar",
			"wh_dlc08_anc_armour_huskarl_plates",
			"wh_dlc08_anc_armour_mammoth_hide_cape",
			"wh2_main_anc_armour_armour_of_caledor",
			"wh2_main_anc_armour_armour_of_eternal_servitude",
			"wh2_main_anc_armour_armour_of_living_death",
			"wh2_main_anc_armour_hide_of_the_cold_ones",
			"wh2_dlc11_anc_armour_the_gunnarsson_kron",
			"wh2_dlc11_anc_armour_armour_of_the_depth",
			"wh3_main_anc_armour_frost_shard_armour",
			"wh3_main_anc_armour_iron_ice_armour",
			"wh3_main_anc_armour_wyrm_harness",
			"wh3_main_anc_armour_armour_of_khorne",
			"wh3_main_anc_armour_bullgut",
			"wh3_main_anc_armour_obsidian_armour",
			"wh3_main_anc_armour_robes_of_shang_yang",
			"wh3_main_anc_armour_scales_of_the_celestial_court",
			"wh3_main_anc_armour_ascendant_celestial_armour",
			"wh3_main_anc_armour_shield_of_the_nan_gau",
			"wh3_main_anc_armour_fused_armour",
			"wh3_main_anc_armour_null_plate",
			"wh3_main_anc_armour_void_armour",
			"wh3_main_anc_armour_weird_plate",
			---CD ancillaries
			"wh3_dlc23_anc_armour_armour_of_bazherak_the_cruel",
			"wh3_dlc23_anc_armour_blackshard_armour"
		},
	},
		
	["enchanted_item"] = {
		["common"] = {
			"wh_main_anc_enchanted_item_featherfoe_torc",
			"wh_main_anc_enchanted_item_ironcurse_icon",
			"wh_main_anc_enchanted_item_potion_of_foolhardiness",
			"wh_main_anc_enchanted_item_potion_of_speed",
			"wh_main_anc_enchanted_item_potion_of_strength",
			"wh_main_anc_enchanted_item_potion_of_toughness",
			"wh_main_anc_enchanted_item_ruby_ring_of_ruin",
			"wh_main_anc_enchanted_item_silver_horn_of_vengeance",
			"wh_main_anc_enchanted_item_the_terrifying_mask_of_eee",
			"wh2_main_anc_enchanted_item_blood_statuette_of_spite",
			"wh2_main_anc_enchanted_item_carnosaur_pendant",
			"wh2_main_anc_enchanted_item_curse_charm_of_tepok",
			"wh2_main_anc_enchanted_item_dragonfly_of_quicksilver",
			"wh2_main_anc_enchanted_item_dragonhorn",
			"wh2_main_anc_enchanted_item_pipes_of_piebald",
			"wh2_main_anc_enchanted_item_portents_of_verminous_doom",
			"wh2_main_anc_enchanted_item_radiant_gem_of_hoeth",
			"wh2_main_anc_enchanted_item_talisman_of_loec",
			"wh2_main_anc_enchanted_item_the_guiding_eye",
			"wh2_main_anc_enchanted_item_venom_of_the_firefly_frog",
			"wh2_main_anc_enchanted_item_whip_of_agony",
			"wh3_main_anc_enchanted_item_steppe_hunters_horn",
			"wh3_main_anc_enchanted_item_greyback_pelt",
			"wh3_main_anc_enchanted_item_rock_eye",
			"wh3_main_anc_enchanted_item_astromancers_spyglass"
		},
		
		["uncommon"] = {
			"wh_dlc05_anc_enchanted_item_hail_of_doom_arrow",
			"wh_dlc07_anc_enchanted_item_holy_icon",
			"wh_main_anc_enchanted_item_crown_of_command",
			"wh_main_anc_enchanted_item_fiery_ring_of_thori",
			"wh_main_anc_enchanted_item_healing_potion",
			"wh_main_anc_enchanted_item_pendant_of_slaanesh",
			"wh_main_anc_enchanted_item_rod_of_flaming_death",
			"wh_main_anc_enchanted_item_van_horstmanns_speculum",
			"wh_dlc08_anc_enchanted_item_manticore_horn",
			"wh2_main_anc_enchanted_item_cloak_of_beards",
			"wh2_main_anc_enchanted_item_divine_plaque_of_protection",
			"wh2_main_anc_enchanted_item_folariaths_robe",
			"wh2_main_anc_enchanted_item_khaines_ring_of_fury",
			"wh2_main_anc_enchanted_item_skalm",
			"wh2_main_anc_enchanted_item_the_book_of_the_phoenix",
			"wh2_main_anc_enchanted_item_the_cloak_of_feathers",
			"wh2_main_anc_enchanted_item_the_horn_of_kygor",
			"wh2_main_anc_enchanted_item_war_drum_of_xahutec",
			"wh2_dlc09_anc_enchanted_item_cloak_of_the_dunes",
			"wh2_dlc09_anc_enchanted_item_golden_deathmask_of_kharnut",
			"wh2_dlc11_anc_enchanted_item_moonshine",
			"wh2_dlc11_anc_enchanted_item_pyrotechnic_compound",
			"wh3_main_anc_enchanted_item_saint_annushkas_finger_bone",
			"wh3_main_anc_enchanted_item_brahmir_statue",
			"wh3_main_anc_enchanted_item_daemon_killer_scars",
			"wh3_main_anc_enchanted_item_jade_lion",
			"wh3_main_anc_enchanted_item_celestial_silk_robe",
			"wh3_main_anc_enchanted_item_cloak_of_the_moon_wind",
			"wh3_main_anc_enchanted_item_fan_of_the_magister",
			"wh3_main_anc_enchanted_item_jar_of_all_souls",
			"wh3_main_anc_enchanted_item_alchemists_elixir_of_venom",
			"wh3_main_anc_enchanted_item_alchemists_mask",
			"wh3_main_anc_enchanted_item_alchemists_elixir_of_iron_skin",
			"wh3_main_anc_enchanted_item_icon_of_the_spirit_dragon",
			"wh3_dlc20_anc_enchanted_item_blasphemous_amulet",
			"wh3_dlc20_anc_enchanted_item_doom_totem",
			"wh3_dlc20_anc_item_armour_of_damnation",
			"wh3_dlc20_anc_item_crown_of_everlasting_conquest",
			"wh3_dlc20_anc_enchanted_item_the_beguiling_gem"
			---moved wh3_dlc20_anc_item_the_festering_shroud to rare
		},
			
		["rare"] = {
			"wh_dlc03_anc_enchanted_item_horn_of_the_first_beast",
			"wh_dlc03_anc_enchanted_item_shard_of_the_herdstone",
			"wh_dlc07_anc_enchanted_item_mane_of_the_purebreed",
			"wh_main_anc_enchanted_item_chalice_of_chaos",
			"wh_main_anc_enchanted_item_skull_wand_of_kaloth",
			"wh_main_anc_enchanted_item_the_other_tricksters_shard",
			"wh_dlc08_anc_enchanted_item_frost_wyrm_scale",
			"wh_dlc08_anc_enchanted_item_vial_of_troll_blood",
			"wh2_main_anc_enchanted_item_black_dragon_egg",
			"wh2_main_anc_enchanted_item_cloak_of_twilight",
			"wh2_main_anc_enchanted_item_moranions_wayshard",
			"wh2_main_anc_enchanted_item_ring_of_corin",
			"wh2_main_anc_enchanted_item_rubric_of_dark_dimensions",
			"wh2_main_anc_enchanted_item_skavenbrew",
			"wh2_dlc11_anc_enchanted_item_black_buckthorns_treasure_map",
			"wh3_main_anc_enchanted_item_balalaika_of_the_arari",
			"wh3_main_anc_enchanted_item_ever_full_kovsh",
			"wh3_main_anc_enchanted_item_fistful_of_laurels",
			"wh3_main_anc_enchanted_item_the_rock_of_inevitability",
			"wh3_main_anc_enchanted_item_alchemists_elixir_of_puissance",
			"wh3_main_anc_enchanted_item_catalytic_kiln",
			"wh3_main_anc_enchanted_item_cleansing_water",
			"wh3_main_anc_enchanted_item_kite_of_the_uttermost_airs",
			"wh3_main_anc_enchanted_item_crackleblaze",
			"wh3_main_anc_enchanted_item_the_chromatic_tome",
			"wh3_main_anc_enchanted_item_the_portalglyph",
			"wh3_main_anc_enchanted_item_bloodstone",
			"wh3_main_anc_enchanted_item_deaths_head",
			"wh3_main_anc_enchanted_item_enthralling_musk",
			---moved shroud from uncommon
			"wh3_dlc20_anc_item_the_festering_shroud",
			---CD ancillaries
			"wh3_dlc23_anc_enchanted_item_daemon_flask_of_ashak",
			"wh3_dlc23_anc_enchanted_item_furnace_blast_gem",
			"wh3_dlc23_anc_enchanted_item_gauntlets_of_bazherak_the_cruel",
			"wh3_dlc23_anc_enchanted_item_the_mask_of_the_furnace",
			"wh3_dlc23_anc_enchanted_item_the_vial_of_hashut"
		},
	},
	
	["banner"] = {
		["common"] = {
			"wh_dlc03_anc_magic_standard_banner_of_outrage",
			"wh_dlc03_anc_mark_of_chaos_gnarled_hide",
			"wh_dlc03_anc_mark_of_chaos_gouge_tusks",
			"wh_dlc03_anc_mark_of_chaos_many_limbed_fiend",
			"wh_dlc03_anc_mark_of_chaos_shadow_hide",
			"wh_dlc03_anc_mark_of_chaos_uncanny_senses",
			"wh_dlc07_anc_magic_standard_errantry_banner",
			"wh_dlc07_anc_magic_standard_twilight_banner",
			"wh_main_anc_magic_standard_banner_of_eternal_flame",
			"wh_main_anc_magic_standard_banner_of_rage",
			"wh_main_anc_magic_standard_banner_of_swiftness",
			"wh_main_anc_magic_standard_blasted_standard",
			"wh_main_anc_magic_standard_gleaming_pennant",
			"wh_main_anc_magic_standard_griffon_banner",
			"wh_main_anc_magic_standard_lichbone_pennant",
			"wh_main_anc_magic_standard_scarecrow_banner",
			"wh_main_anc_magic_standard_standard_of_discipline",
			"wh_main_anc_magic_standard_the_screaming_banner",
			"wh_main_anc_rune_ancestor_rune",
			"wh_main_anc_rune_master_rune_of_courage",
			"wh_dlc08_anc_magic_standard_banner_of_wolfclaw",
			"wh_dlc08_anc_magic_standard_black_iron_reavers",
			"wh_dlc08_anc_magic_standard_crimson_reapers",
			"wh_dlc08_anc_magic_standard_drake_hunters",
			"wh2_main_anc_magic_standard_banner_of_ellyrion",
			"wh2_main_anc_magic_standard_banner_of_the_under_empire",
			"wh2_main_anc_magic_standard_banner_of_verminous_scurrying",
			"wh2_main_anc_magic_standard_dwarf_hide_banner",
			"wh2_main_anc_magic_standard_huanchis_blessed_totem",
			"wh2_main_anc_magic_standard_lion_standard",
			"wh2_main_anc_magic_standard_sea_serpent_standard",
			"wh2_main_anc_magic_standard_the_blood_banner",
			"wh2_dlc11_anc_magic_standard_dead_mans_chest",
			"wh2_dlc11_anc_magic_standard_boatswain",
			"wh2_dlc11_anc_magic_standard_corpse_surgeon",
			"wh2_dlc11_anc_magic_standard_rookie_gunner",
			"wh3_main_anc_magic_standard_father_niklas_mantle",
			"wh3_main_anc_magic_standard_bull_standard",
			"wh3_main_anc_magic_standard_standard_of_wei_jin"
		},
		
		["uncommon"] = {
			"wh_dlc03_anc_mark_of_chaos_slug_skin",
			"wh_main_anc_magic_standard_banner_of_lost_holds",
			"wh_main_anc_magic_standard_razor_standard",
			"wh_main_anc_magic_standard_steel_standard",
			"wh_main_anc_magic_standard_war_banner",
			"wh_main_anc_rune_master_rune_of_groth_one-eye",
			"wh_main_anc_rune_master_rune_of_grungni",
			"wh_main_anc_rune_master_rune_of_sanctuary",
			"wh_main_anc_rune_master_rune_of_stoicism",
			"wh_main_anc_rune_strollaz_rune",
			"wh2_main_anc_magic_standard_banner_of_murder",
			"wh2_main_anc_magic_standard_grand_banner_of_clan_superiority",
			"wh2_main_anc_magic_standard_shroud_of_dripping_death",
			"wh2_main_anc_magic_standard_standard_of_hag_graef",
			"wh2_main_anc_magic_standard_sun_standard_of_chotec",
			"wh2_dlc09_anc_magic_standard_banner_of_the_hidden_dead",
			"wh2_dlc09_anc_magic_standard_standard_of_the_undying_legion",
			"wh2_dlc11_anc_magic_standard_bloodied_banner_of_slayers",
			"wh2_dlc11_anc_magic_standard_burnt_banner_of_knights",
			"wh2_dlc11_anc_magic_standard_holed_banner_of_militia",
			"wh2_dlc11_anc_magic_standard_torn_banner_of_pilgrims",
			"wh3_main_anc_magic_standard_banner_of_praag",
			"wh3_main_anc_magic_standard_standard_of_the_empty_steppe",
			"wh3_main_anc_magic_standard_banner_of_hellfire",
			"wh3_main_anc_magic_standard_banner_of_unholy_victory",
			"wh3_main_anc_magic_standard_cannibal_totem",
			"wh3_main_anc_magic_standard_great_icon_of_despair",
			"wh3_main_anc_magic_standard_icon_of_endless_war",
			"wh3_main_anc_magic_standard_ragbanner",
			"wh3_main_anc_magic_standard_skull_totem",
			"wh3_main_anc_magic_standard_standard_of_chaos_glory",
			"wh3_main_anc_magic_standard_serene_cloud_prayer_flag",
			"wh3_main_anc_magic_standard_banner_of_change",
			"wh3_main_anc_magic_standard_banner_of_ecstacy",
			"wh3_main_anc_magic_standard_great_standard_of_sundering",
			"wh3_main_anc_magic_standard_icon_of_eternal_virulence",
			"wh3_main_anc_magic_standard_icon_of_sorcery",
			"wh3_main_anc_magic_standard_siren_standard",
			"wh3_main_anc_magic_standard_standard_of_nan_gau",
			"wh3_main_anc_magic_standard_standard_of_seeping_decay"
		},
		
		["rare"] = {
			"wh_dlc03_anc_magic_standard_manbane_standard",
			"wh_dlc03_anc_magic_standard_the_beast_banner",
			"wh_dlc03_anc_magic_standard_totem_of_rust",
			"wh_dlc03_anc_mark_of_chaos_crown_of_horns",
			"wh_dlc05_anc_magic_standard_the_banner_of_the_eternal_queen",
			"wh_dlc05_anc_magic_standard_the_banner_of_the_hunter_king",
			"wh_dlc07_anc_magic_standard_banner_of_defence",
			"wh_dlc07_anc_magic_standard_valorous_standard",
			"wh_main_anc_magic_standard_banner_of_the_barrows",
			"wh_main_anc_magic_standard_morks_war_banner",
			"wh_main_anc_magic_standard_rampagers_standard",
			"wh_main_anc_magic_standard_rangers_standard",
			"wh_main_anc_magic_standard_spider_banner",
			"wh_main_anc_magic_standard_the_bad_moon_banner",
			"wh_main_anc_magic_standard_wailing_banner",
			"wh_main_anc_rune_master_rune_of_battle",
			"wh_main_anc_rune_master_rune_of_stromni_redbeard",
			"wh_main_anc_rune_master_rune_of_valaya",
			"wh2_main_anc_magic_standard_banner_of_the_world_dragon",
			"wh2_main_anc_magic_standard_battle_banner",
			"wh2_main_anc_magic_standard_dread_banner",
			"wh2_main_anc_magic_standard_horn_of_isha",
			"wh2_main_anc_magic_standard_hydra_banner",
			"wh2_main_anc_magic_standard_sacred_banner_of_the_horned_rat",
			"wh2_main_anc_magic_standard_skavenpelt_banner",
			"wh2_main_anc_magic_standard_storm_banner",
			"wh2_main_anc_magic_standard_the_jaguar_standard",
			"wh2_main_anc_magic_standard_totem_of_prophecy",
			"wh2_dlc11_anc_magic_standard_ships_colors",
			"wh3_main_anc_magic_standard_dragonhide_banner",
			"wh3_main_anc_magic_standard_rune_maw",
			"wh3_main_anc_magic_standard_standard_of_shang_yang",
			"wh3_main_anc_magic_standard_revered_banner_of_the_ancestors",
			"wh3_main_anc_magic_standard_bastion_standard",
			"wh3_main_anc_magic_standard_flag_of_grand_cathay",
			----CD items added here. There are two other 100 uniqueness score banners above
			"wh3_dlc23_anc_banner_chd_banner_of_the_khanate",
			"wh3_dlc23_anc_banner_chd_eye_of_hashut",
			"wh3_dlc23_anc_banner_chd_hellbound_standard",
			"wh3_dlc23_anc_banner_chd_hobgoblin_standard",
			"wh3_dlc23_anc_banner_chd_oath_of_contempt",
			"wh3_dlc23_anc_banner_chd_standard_of_zharr"
		},
	},
	
	["talisman"] = {
		["common"]	= {
			"wh_main_anc_talisman_dragonbane_gem",
			"wh_main_anc_talisman_luckstone",
			"wh_main_anc_talisman_pidgeon_plucker_pendant",
			---"wh2_main_anc_enchanted_item_talisman_of_loec" should only be in enchanted items
			"wh_main_anc_talisman_seed_of_rebirth",
			"wh2_main_anc_talisman_rival_hide_talisman",
			"wh_main_anc_talisman_obsidian_trinket",
			"wh_main_anc_talisman_opal_amulet",
			"wh_main_anc_talisman_talisman_of_protection",
			"wh2_main_anc_talisman_amulet_of_fire",
			"wh_dlc07_anc_talisman_dragons_claw",
			"wh2_main_anc_talisman_pearl_of_infinite_blackness",
			"wh_main_anc_talisman_dawnstone",
			"wh3_main_anc_talisman_jet_amulet",
			"wh3_main_anc_talisman_cathayan_jet",
			"wh3_main_anc_talisman_jade_blood_pendant",
			"wh3_main_anc_talisman_spangleshard"
		},
		
		["uncommon"] = {
			"wh_dlc03_anc_talisman_chalice_of_dark_rain",
			"wh_dlc07_anc_talisman_siriennes_locket",
			"wh_main_anc_talisman_obsidian_amulet",
			"wh_main_anc_talisman_obsidian_lodestone",
			"wh_main_anc_talisman_talisman_of_endurance",
			"wh_dlc08_anc_talisman_lootbag_of_marauders",
			"wh_dlc08_anc_talisman_slave_chain",
			"wh_dlc08_anc_talisman_wolf_teeth_amulet",
			"wh2_main_anc_talisman_amulet_of_itzl",
			"wh2_main_anc_talisman_aura_of_quetzl",
			"wh2_main_anc_talisman_crown_of_black_iron",
			"wh2_main_anc_talisman_foul_pendant",
			"wh2_main_anc_talisman_glyph_necklace",
			"wh2_main_anc_talisman_golden_crown_of_atrazar",
			"wh2_main_anc_talisman_loremasters_cloak",
			"wh2_main_anc_talisman_ring_of_darkness",
			"wh2_main_anc_talisman_sacred_incense",
			"wh2_main_anc_talisman_shadow_magnet_trinket",
			"wh2_main_anc_talisman_talisman_of_saphery",
			"wh2_dlc11_anc_talisman_blackpearl_eye",
			"wh2_dlc11_anc_talisman_jellyfish_in_a_jar",
			"wh3_main_anc_talisman_star_iron_ring",
			"wh3_main_anc_talisman_wyrdstone_necklace",
			"wh3_main_anc_talisman_greedy_fist",
			"wh3_main_anc_talisman_jade_amulet",
			"wh3_main_anc_talisman_gnoblar_thiefstone"
		},
		
		["rare"] = {
			"wh_main_anc_talisman_talisman_of_preservation",
			"wh_main_anc_talisman_the_white_cloak_of_ulric",
			"wh_dlc08_anc_talisman_headband_of_berserker",
			"wh2_main_anc_talisman_deathmask",
			"wh2_main_anc_talisman_ring_of_hotek",
			"wh2_main_anc_talisman_the_black_amulet",
			"wh2_main_anc_talisman_vambraces_of_defence",
			"wh2_dlc11_anc_talisman_kraken_fang",
			"wh3_main_anc_talisman_blizzard_broach",
			"wh3_main_anc_talisman_blood_of_the_motherland",
			"wh3_main_anc_talisman_crystal_of_kunlan",
			"wh3_main_anc_talisman_collar_of_khorne",
			"wh3_main_anc_talisman_crystal_pendant",
			"wh3_main_anc_talisman_fractured_clasp",
			"wh3_main_anc_talisman_jewel_of_denial",
			"wh3_main_anc_talisman_ring_of_sensation",
			"wh3_main_anc_talisman_spore_censer",
			"wh3_main_anc_talisman_tarnished_torque",
			"wh3_main_anc_talisman_the_bloody_shackle",
			"wh3_main_anc_talisman_vile_seed",
			"wh3_main_anc_talisman_warp_mirror",
			---CD ancillaries
			"wh3_dlc23_anc_talisman_black_gem_of_gnar",
			"wh3_dlc23_anc_talisman_talisman_of_obsidian",
			"wh3_dlc23_anc_talisman_possessed_amulet",
			"wh3_dlc23_anc_talisman_malignant_totem"
		},
	},
	
	["weapon"] = {
		["common"] = {
			"wh_dlc03_anc_weapon_everbleed",
			"wh_dlc05_anc_weapon_the_bow_of_loren",
			"wh_dlc07_anc_weapon_sword_of_the_quest",
			"wh_dlc07_anc_weapon_the_wyrmlance",
			"wh_main_anc_weapon_berserker_sword",
			"wh_main_anc_weapon_biting_blade",
			"wh_main_anc_weapon_gold_sigil_sword",
			"wh_main_anc_weapon_relic_sword",
			"wh_main_anc_weapon_shrieking_blade",
			"wh_main_anc_weapon_sword_of_battle",
			"wh_main_anc_weapon_sword_of_might",
			"wh_main_anc_weapon_sword_of_striking",
			"wh_main_anc_weapon_sword_of_swift_slaying",
			"wh_main_anc_weapon_tormentor_sword",
			"wh_main_anc_weapon_warrior_bane",
			"wh2_main_anc_weapon_blade_of_nurglitch",
			"wh2_main_anc_weapon_burning_blade_of_chotec",
			"wh2_main_anc_weapon_dagger_of_sotek",
			"wh2_main_anc_weapon_deathpiercer",
			"wh2_main_anc_weapon_dwarfbane",
			"wh2_main_anc_weapon_foe_bane",
			"wh2_main_anc_weapon_heartseeker",
			"wh2_main_anc_weapon_sword_of_the_hornet",
			"wh2_main_anc_weapon_web_of_shadows",
			"wh3_main_anc_weapon_ursuns_claws",
			"wh3_main_anc_weapon_blade_of_blood",
			"wh3_main_anc_weapon_blood_cleaver",
			"wh3_main_anc_weapon_skull_plucker",
			"wh3_main_anc_weapon_the_tenderiser",
			"wh3_main_anc_weapon_plague_flail"
		},
		
		["uncommon"] = {
			"wh_dlc03_anc_weapon_axes_of_khorgor",
			"wh_dlc03_anc_weapon_hunting_spear",
			"wh_dlc03_anc_weapon_the_brass_cleaver",
			"wh_dlc03_anc_weapon_the_steel_claws",
			"wh_dlc07_anc_weapon_sword_of_the_ladys_champion",
			"wh_main_anc_weapon_fencers_blades",
			"wh_main_anc_weapon_filth_mace",
			"wh_main_anc_weapon_hellfire_sword",
			"wh_main_anc_weapon_ogre_blade",
			"wh_main_anc_weapon_skabscrath",
			"wh_main_anc_weapon_sword_of_anti-heroes",
			"wh_main_anc_weapon_sword_of_strife",
			"wh_main_anc_weapon_the_hammer_of_karak_drazh",
			"wh_dlc08_anc_weapon_fimir_hammer",
			"wh_dlc08_anc_weapon_troll_fang_dagger",
			"wh2_main_anc_weapon_blade_of_corruption",
			"wh2_main_anc_weapon_blade_of_darting_steel",
			"wh2_main_anc_weapon_caledors_bane",
			"wh2_main_anc_weapon_crimson_death",
			"wh2_main_anc_weapon_dagger_of_hotek",
			"wh2_main_anc_weapon_the_white_sword",
			"wh2_main_anc_weapon_warlock_augmented_weapon",
			"wh2_main_anc_weapon_weeping_blade",
			"wh3_main_anc_weapon_etherblade",
			"wh3_main_anc_weapon_firestorm_blade",
			"wh3_main_anc_weapon_torment_blade",
			"wh3_main_anc_weapon_vorpal_shard",
			"wh3_dlc20_anc_weapon_sword_of_change"
		},
		
		["rare"] = {
			"wh_dlc03_anc_weapon_axe_of_men",
			"wh_dlc03_anc_weapon_mangelder",
			"wh_dlc03_anc_weapon_primeval_club",
			"wh_dlc03_anc_weapon_stonecrusher_mace",
			"wh_dlc05_anc_weapon_daiths_reaper",
			"wh_dlc05_anc_weapon_the_spirit_sword",
			"wh_dlc07_anc_weapon_the_silver_lance_of_the_blessed",
			"wh_main_anc_weapon_bashas_axe_of_stunty_smashin",
			"wh_main_anc_weapon_battleaxe_of_the_last_waaagh",
			"wh_main_anc_weapon_giant_blade",
			"wh_main_anc_weapon_obsidian_blade",
			"wh_main_anc_weapon_red_axe_of_karak_eight_peaks",
			"wh_main_anc_weapon_runefang",
			"wh_main_anc_weapon_sword_of_bloodshed",
			"wh_main_anc_weapon_the_mace_of_helsturm",
			"wh_dlc08_anc_weapon_flaming_axe_of_cormac",
			"wh2_main_anc_weapon_blade_of_bel_korhadris",
			"wh2_main_anc_weapon_blade_of_leaping_gold",
			"wh2_main_anc_weapon_blade_of_revered_tzunki",
			"wh2_main_anc_weapon_blade_of_ruin",
			"wh2_main_anc_weapon_bow_of_the_seafarer",
			"wh2_main_anc_weapon_chillblade",
			"wh2_main_anc_weapon_executioners_axe",
			"wh2_main_anc_weapon_hydra_blade",
			"wh2_main_anc_weapon_scimitar_of_the_sun_resplendent",
			"wh2_main_anc_weapon_stegadon_war_spear",
			"wh2_main_anc_weapon_the_blade_of_realities",
			"wh2_main_anc_weapon_the_fellblade",
			"wh2_main_anc_weapon_the_piranha_blade",
			"wh2_main_anc_weapon_venom_sword",
			"wh2_main_anc_weapon_warpforged_blade",
			"wh2_dlc11_anc_weapon_double_barrel",
			"wh2_dlc11_anc_weapon_lucky_levis_hookhand",
			"wh2_dlc11_anc_weapon_masamune",
			"wh3_main_anc_weapon_axe_of_tor",
			"wh3_main_anc_weapon_frost_shard_glaive",
			"wh3_main_anc_weapon_the_rime_blade",
			"wh3_main_anc_weapon_wyrmspike",
			"wh3_main_anc_weapon_dazhs_brazier",
			"wh3_main_anc_weapon_axe_of_khorne",
			"wh3_main_anc_weapon_siegebreaker",
			"wh3_main_anc_weapon_the_eternal_blade",
			"wh3_main_anc_weapon_thundermace",
			"wh3_main_anc_weapon_bale_sword",
			"wh3_main_anc_weapon_lash_of_despair",
			"wh3_main_anc_weapon_staff_of_change",
			"wh3_main_anc_weapon_staff_of_nurgle",
			"wh3_main_anc_weapon_silver_moon_bow",
			"wh3_main_anc_weapon_ascendant_celestial_blade",
			"wh3_main_anc_weapon_jade_blade_of_the_great_fleet",
			"wh3_main_anc_weapon_serpent_fang",
			"wh3_main_anc_weapon_nuku_chos_crossbow",
			"wh3_main_anc_weapon_vermillion_blade",
			"wh3_main_anc_weapon_blade_of_xen_wu",
			"wh3_main_anc_weapon_spirit_qilin_spear",
			"wh3_main_anc_weapon_dawn_glaive",
			"wh3_main_anc_weapon_hellblade",
			"wh3_dlc20_anc_weapon_aether_sword",
			---"wh3_dlc20_anc_weapon_axe_of_khorne" removed since duplicate of "wh3_main_anc_weapon_axe_of_khorne" and not in db
			---CA did a typo here "wh3_dlc20_anc_weapon_rapier_of_ecstacy"
			"wh3_dlc20_anc_weapon_rapier_of_ecstasy",
			---CD ancillaries
			"wh3_dlc23_anc_weapon_dark_mace",
			"wh3_dlc23_anc_weapon_life_bane_blade"
		},
	},
	
	["arcane_item"] = {
		["common"] = {
			"wh_dlc07_anc_arcane_item_sacrament_of_the_lady",
			"wh_main_anc_arcane_item_book_of_arkhan",
			"wh_main_anc_arcane_item_channelling_staff",
			"wh_main_anc_arcane_item_earthing_rod",
			"wh_main_anc_arcane_item_power_scroll",
			"wh_main_anc_arcane_item_power_stone",
			"wh_main_anc_arcane_item_sceptre_of_stability",
			"wh_main_anc_arcane_item_scroll_of_shielding",
			"wh_main_anc_arcane_item_skull_of_katam",
			"wh_main_anc_arcane_item_wand_of_jet",
			"wh_dlc03_anc_arcane_item_jagged_dagger",
			"wh_dlc03_anc_arcane_item_hagtree_fetish",
			"wh2_main_anc_arcane_item_scrying_stone",
			"wh2_main_anc_arcane_item_warpstone_tokens",
			"wh2_main_anc_arcane_item_warp_energy_condenser",
			"wh2_main_anc_arcane_item_diadem_of_power",
			"wh2_main_anc_arcane_item_itxi_grubs",
			"wh2_main_anc_arcane_item_plaque_of_dominion",
			"wh2_main_anc_arcane_item_rod_of_the_storm",
			"wh2_main_anc_arcane_item_darkstar_cloak",
			"wh2_main_anc_arcane_item_tome_of_furion",
			"wh2_dlc10_anc_arcane_item_scroll_of_blast",
			"wh2_dlc10_anc_arcane_item_scroll_of_speed_of_lykos",
			"wh2_dlc10_anc_arcane_item_scroll_of_the_amber_trance",
			"wh3_main_anc_arcane_item_bangstick",
			"wh3_main_anc_arcane_item_wand_of_whimsey"
		},
		
		["uncommon"] = {
			"wh_main_anc_arcane_item_forbidden_rod",
			"wh_main_anc_arcane_item_staff_of_damnation",
			"wh_main_anc_arcane_item_tricksters_shard",
			"wh2_main_anc_arcane_item_cube_of_darkness",
			"wh2_main_anc_arcane_item_cupped_hands_of_the_old_ones",
			"wh2_main_anc_arcane_item_the_seerstaff_of_saphery",
			"wh2_main_anc_arcane_item_the_tricksters_pendant",
			"wh2_main_anc_arcane_item_starwood_staff",
			"wh2_dlc10_anc_arcane_item_scroll_of_assault_of_stone",
			"wh2_dlc10_anc_arcane_item_scroll_of_fear_of_aramar",
			"wh3_main_anc_arcane_item_snowflake_pendant",
			"wh3_main_anc_arcane_item_halfling_cookbook",
			"wh3_main_anc_arcane_item_skullmantle",
			"wh3_main_anc_arcane_item_maw_shard",
			"wh3_main_anc_arcane_item_scrolls_of_astromancy"
		},
		
		["rare"] = {
			"wh_main_anc_arcane_item_black_periapt",
			"wh_main_anc_arcane_item_book_of_ashur",
			"wh_main_anc_arcane_item_lucky_shrunken_head",
			"wh_main_anc_arcane_item_scroll_of_leeching",
			"wh_dlc03_anc_arcane_item_staff_of_darkoth",
			"wh_dlc03_anc_arcane_item_skull_of_rarkos",
			"wh2_main_anc_arcane_item_warpstorm_scroll",
			"wh2_main_anc_arcane_item_black_staff",
			"wh2_main_anc_arcane_item_book_of_hoeth",
			"wh2_main_anc_arcane_item_the_vortex_shard",
			"wh2_main_anc_arcane_item_the_gem_of_sunfire",
			"wh2_dlc10_anc_arcane_item_scroll_of_arnizipals_black_horror",
			"wh3_main_anc_arcane_item_mirror_of_the_ice_queen",
			"wh3_main_anc_arcane_item_gastuvas_egg",
			"wh3_main_anc_arcane_item_gruts_sickle",
			"wh3_main_anc_arcane_item_hellheart",
			"wh3_main_anc_arcane_item_cloak_of_po_mei",
			"wh3_main_anc_arcane_item_staff_of_wu_xing",
			"wh3_main_anc_arcane_item_abhorrent_lodestone",
			"wh3_main_anc_arcane_item_prismatic_amplifier",
			"wh3_main_anc_arcane_item_rod_of_command",
			"wh3_main_anc_arcane_item_sceptre_of_entropy",
			"wh3_main_anc_arcane_item_void_pendulum",
			"wh3_dlc20_anc_arcane_item_rod_of_torment",
			---CD ancillaries
			"wh3_dlc23_anc_arcane_item_dweomer_leach_orb",
			"wh3_dlc23_anc_arcane_item_spell_wrought_sceptre",
			"wh3_dlc23_anc_arcane_item_chalice_of_blood_and_darkness"
		}
	}
};


local valid_ancillary_category = {};
local valid_ancillary_rarities = {};

do
	local rarities_parsed = false;
	for category, category_data in pairs(ancillary_list) do
		table.insert(valid_ancillary_category, category);
		if not rarities_parsed then
			for rarity in pairs(category_data) do
				table.insert(valid_ancillary_rarities, rarity);
			end;
			rarities_parsed = true;
		end;
	end;
end;


core:add_listener(
	"award_random_magical_item",
	"TriggerPostBattleAncillaries",
	true,
	function(context)
		local character = context:character();
		return character:won_battle() and cm:char_is_general_with_army(character) and not context:has_stolen_ancillary() and attempt_to_award_random_magical_item(context);
	end,
	true
);


----------CHANGE: Adds new function that can check for casters inside the army
function military_force_has_character_that_can_equip_ancillary(military_force, ancillary)
	local character_list = military_force:character_list()
	
	for i = 0, character_list:num_items() - 1 do
		if character_list:item_at(i):can_equip_ancillary(ancillary) then
			return true
		end
	end
	
	return false
end

function attempt_to_award_random_magical_item(context)
	if not cm:model():campaign_name("wh3_main_prologue") then
		-- don't award a magical item if it is a quest battle
		local a_char_cqi, a_mf_cqi, a_faction_name = cm:pending_battle_cache_get_attacker(1);
		local d_char_cqi, d_mf_cqi, d_faction_name = cm:pending_battle_cache_get_defender(1);
		
		local attacker = cm:get_faction(a_faction_name);
		local defender = cm:get_faction(d_faction_name);
		
		if (attacker and attacker:is_quest_battle_faction()) or (defender and defender:is_quest_battle_faction()) then
			out.traits("attempt_to_award_random_magical_item() called, but it is a quest battle. Not going to award anything.");
			return;
		end;
		
		local index = 0;
		
		local character = context:character();
		local faction = character:faction();
		
		if character:is_caster() or cm:general_has_caster_embedded_in_army(character) then
			index = cm:random_number(7); -- this will weigh slightly towards arcane items when the character is a caster (6 or higher)
		else
			index = cm:random_number(5); -- don't drop arcane items if the character involved is not a caster
		end;
		
		local new_ancillary_list = {};
		
		if index == 1 then
			new_ancillary_list = ancillary_list.armour;
		elseif index == 2 then
			new_ancillary_list = ancillary_list.enchanted_item;
		elseif index == 3 then
			new_ancillary_list = ancillary_list.banner;
		elseif index == 4 then
			new_ancillary_list = ancillary_list.talisman;
		elseif index == 5 then
			new_ancillary_list = ancillary_list.weapon;
		else
			new_ancillary_list = ancillary_list.arcane_item;
		end;
		
		-- get the list of ancillaries based on the rarity
		local rarity_roll = cm:random_number(100);
		
		if rarity_roll > 90 then
			new_ancillary_list = new_ancillary_list.rare;
		elseif rarity_roll > 61 then
			new_ancillary_list = new_ancillary_list.uncommon;
		else
			new_ancillary_list = new_ancillary_list.common;
		end;
		
		local pb = context:pending_battle();
		local model = pb:model();
		local campaign_difficulty = model:difficulty_level();
		local chance = 40;
		local bv_chance = character:post_battle_ancillary_chance();
		
		-- mod the chance based on the bonus value state
		chance = chance + bv_chance;
		
		-- mod the chance based on campaign difficulty (only if singleplayer)
		local campaign_difficulty_mod = 0
		if model:is_multiplayer() then
			-- in mp, modify as if playing on normal difficulty
			campaign_difficulty_mod = 6;
		elseif faction:is_human() then							-- player
			if campaign_difficulty == 1 then					-- easy
				campaign_difficulty_mod = 8;
			elseif campaign_difficulty == 0 then				-- normal
				campaign_difficulty_mod = 6;
			elseif campaign_difficulty == -1 then				-- hard
				campaign_difficulty_mod = 4;
			elseif campaign_difficulty == -2 then				-- very hard
				campaign_difficulty_mod = 2;
			end;
		else													-- AI
			if campaign_difficulty == 0 then					-- normal
				campaign_difficulty_mod = 2;
			elseif campaign_difficulty == -1 then				-- hard
				campaign_difficulty_mod = 4;
			elseif campaign_difficulty == -2 then				-- very hard
				campaign_difficulty_mod = 6;
			else												-- legendary
				campaign_difficulty_mod = 8;
			end;
		end;

		chance = chance + campaign_difficulty_mod;
		
		-- mod the chance based on victory type
		local victory_type_mod = 0;
		if pb:has_attacker() and pb:attacker() == character then
			if pb:attacker_battle_result() == "close_victory" then
				victory_type_mod = 2;
			elseif pb:attacker_battle_result() == "decisive_victory" then
				victory_type_mod = 4;
			elseif pb:attacker_battle_result() == "heroic_victory" then
				victory_type_mod = 6;
			end;
		elseif pb:has_defender() then
			if pb:defender_battle_result() == "close_victory" then
				victory_type_mod = 2;
			elseif pb:defender_battle_result() == "decisive_victory" then
				victory_type_mod = 4;
			elseif pb:defender_battle_result() == "heroic_victory" then
				victory_type_mod = 6;
			end;
		end;
		
		chance = chance + victory_type_mod;

		if chance > 100 then
			chance = 100
		end;
		
		-- tomb kings chance is cut in half due to mortuary cult
		if faction:culture() == "wh2_dlc09_tmb_tomb_kings" then
			chance = chance * 0.5;
		end;
		
		local roll = cm:random_number(100);
		
		if core:is_tweaker_set("FORCE_ANCILLARY_DROP_POST_BATTLE") then
			roll = 1;
		end;
		
		out.traits("Rolled a " .. roll .. " to assign an ancillary with a chance of " .. chance .. " for a character belonging to the faction " .. faction:name());
		
		if roll <= chance then
			local can_equip = false;
			local count = 0;
			local is_daemon_prince = character:character_subtype("wh3_main_dae_daemon_prince");
			
			-- daemon prince can't equip any ancillaries, so test the next available general instead
			if is_daemon_prince then
				mf_list = faction:military_force_list();
				
				for i = 0, mf_list:num_items() - 1 do
					local current_mf = mf_list:item_at(i);
					
					if not current_mf:is_armed_citizenry() and current_mf:has_general() then
						local current_general = current_mf:general_character();
						
						if not current_general:character_subtype("wh3_main_dae_daemon_prince") then
							character = current_general;
							break;
						end;
					end;
				end;
			end;
			
			while not can_equip and count < 20 do
				local ancillary_index = cm:random_number(#new_ancillary_list);
				local chosen_ancillary = new_ancillary_list[ancillary_index];
				
				count = count + 1;
				
				--if character:can_equip_ancillary(chosen_ancillary) then
				-------CHANGE: Checks not just for general but all characters in armies, otherwise only caster lords can drop arcane items
				if military_force_has_character_that_can_equip_ancillary(character:military_force(), chosen_ancillary) then
					can_equip = true;
					out.traits("Trying to assign the ancillary " .. chosen_ancillary .. " for a character belonging to the faction " .. faction:name());
					
					-- daemon prince cannot equip items, so assign it to the faction instead
					if is_daemon_prince then
						cm:add_ancillary_to_faction(faction, chosen_ancillary, false);
					else
						common.ancillary(chosen_ancillary, 100, context);
					end;
				end;
			end;
		end;

		if faction:is_human() then
			common.dev_ui_log_drop_chance(roll, chance, bv_chance, campaign_difficulty_mod, victory_type_mod);
		end;
	end;
end;



function get_random_ancillary_key_for_faction(faction_key, specified_category, rarity)
	if not validate.is_string(faction_key) then
		return false;
	end;

	local faction = cm:get_faction(faction_key);
	if not faction then
		script_error("ERROR: get_random_ancillary_key_for_faction() called but no faction with supplied key [" .. faction_key .. "] could be found");
		return;
	end;

	-- if the faction is Daemons of Chaos then return nothing as the faction leader cannot equip any standard ancillaries
	if faction:culture() == "wh3_main_dae_daemons" then
		return;
	end;

	if not faction:has_faction_leader() then
		script_error("ERROR: get_random_ancillary_key_for_faction() called but faction with supplied key [" .. faction_key .. "] has no faction leader - how can this be?");
		return;
	end;
	
	local valid_ancillary_categories = {
		"armour",
		"enchanted_item",
		"banner",
		"talisman",
		"weapon",
		"arcane_item"
	};
	
	local category = specified_category;
	
	if not specified_category then
		category = valid_ancillary_categories[cm:random_number(#valid_ancillary_categories)];
	elseif not validate.is_string(category) then
		return false;
	end;

	if not ancillary_list[category] then
		script_error("ERROR: get_random_ancillary_key_for_faction() called with category [" .. category .. "], but this is not a valid ancillary category. Valid categories are " .. table.concat(valid_ancillary_categories, ", "));
		return;
	end;
	
	local valid_ancillary_rarities = {
		"common",
		"uncommon",
		"rare"
	};
	
	if not rarity then
		rarity = valid_ancillary_rarities[cm:random_number(#valid_ancillary_rarities)];
	elseif not validate.is_string(rarity) then
		return false;
	end;

	if not ancillary_list[category][rarity] then
		script_error("ERROR: get_random_ancillary_key_for_faction() called with rarity [" .. rarity .. "], but this is not a valid ancillary rarity. Valid rarities are " .. table.concat(valid_ancillary_rarities, ", "));
		return;
	end;

	local char = faction:faction_leader();
	
	-- if we're looking for an arcane item, try and find a caster in the faction if the faction leader isn't one (they can't equip arcane items)
	if category == "arcane_item" and not char:is_caster() then
		local character_list = faction:character_list();
		
		for i = 0, character_list:num_items() - 1 do
			local current_character = character_list:item_at(i);
			
			if current_character:is_caster() and not current_character:character_type("colonel") then
				char = current_character;
				break;
			end;
		end;
	end;
	
	-- we still haven't found a caster to test, and the random category selected was arcane item - so change the random category to something else, otherwise we'll never find an equippable arcane item
	if category == "arcane_item" and specified_category ~= "arcane_item" and not char:is_caster() then
		table.remove(valid_ancillary_categories, 6);

		category = valid_ancillary_categories[cm:random_number(#valid_ancillary_categories)];
	end;

	local ancillary_list_for_category_for_faction = cm:random_sort(ancillary_list[category][rarity]);
	ancillary_list[category][rarity] = ancillary_list_for_category_for_faction;

	for i = 1, #ancillary_list_for_category_for_faction do
		local current_ancillary_key = ancillary_list_for_category_for_faction[i];
		if char:can_equip_ancillary(current_ancillary_key) then
			return current_ancillary_key;
		end;
	end;

	script_error("ERROR: get_random_ancillary_key_for_faction() called with category [" .. category .. "] and rarity [" .. rarity .. "] for faction [" .. faction_key .. "] but no equippable ancillaries could be found. Will return one at random.");
	return ancillary_list_for_category_for_faction[1];
end;