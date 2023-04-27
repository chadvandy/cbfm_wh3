caravans.region_to_incident.wh3_main_cth_cathay.wh3_main_combi_region_castle_drakenhof = "wh3_main_cth_caravan_completed_castle_drakenhof"
caravans.region_to_incident.wh3_main_cth_cathay.wh3_main_chaos_region_castle_drakenhof = "wh3_main_cth_caravan_completed_castle_drakenhof"
	
caravans.traits_to_units.wh3_dlc23_skill_innate_chd_convoy_overseer_retired_daemonsmither = {
		"wh3_dlc23_chd_cha_bull_centaur_taurruk",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_warriors",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses",
		"wh3_dlc23_chd_cav_bull_centaurs_greatweapons"
		}
	
	
local function zzz_fix_caravan_master_stealth()
	core:add_listener(
		"zzz_fix_caravan_master_stealth",
		"CaravanRecruited",
		true,
		function(context)
				local caravan = context:caravan();
                local force_cqi = caravan:caravan_force():command_queue_index();
                local commander = caravan:caravan_force():general_character()
                local lord_cqi = commander:command_queue_index();
                local lord_str = cm:char_lookup_str(lord_cqi);
                local innate_skill = commander:background_skill()
                if innate_skill == "wh3_main_skill_innate_cth_caravan_master_stealth" then
                    cm:add_experience_to_units_commanded_by_character(lord_str, 3)
                end
		end,
		true
	)
end

cm:add_first_tick_callback(function() 
                           zzz_fix_caravan_master_stealth() 
                           end);