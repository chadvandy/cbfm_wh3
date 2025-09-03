local braindead_factions = 
{
	["wh2_main_lzd_hexoatl"] = "wh3_main_combi_region_hexoatl",
	["wh2_main_lzd_tlaqua"] = "wh3_main_combi_region_tlaqua",
	["wh2_dlc17_lzd_oxyotl"] = "wh3_main_combi_region_the_godless_crater",
	["wh2_main_lzd_last_defenders"] = "wh3_main_combi_region_the_golden_tower",
	["wh2_dlc12_lzd_cult_of_sotek"] = "wh3_main_combi_region_kaiax",
	["wh2_main_lzd_itza"] = "wh3_main_combi_region_itza"
}

local function init()
	if cm:is_new_game() then
		for faction_key, capital_key in pairs(braindead_factions) do
			local is_human = cm:is_human_faction(faction_key)
			if not is_human then
				local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key,capital_key,false,true)
				local unit_string = "wh2_main_lzd_inf_skink_cohort_1"
				cm:create_force(faction_key,unit_string,capital_key,x,y,true)
			end
		end
	end
end

cm:add_first_tick_callback(init)