local waaagh_list =
{
	"wh2_dlc15_army_abilities_azhags_big_waaagh",
	"wh2_dlc15_army_abilities_azhags_waaagh",
	"wh2_dlc15_army_abilities_big_waaagh",
	"wh2_dlc15_army_abilities_grimgors_big_waaagh",
	"wh2_dlc15_army_abilities_grimgors_waaagh",
	"wh2_dlc15_army_abilities_groms_big_waaagh",
	"wh2_dlc15_army_abilities_groms_waaagh",
	"wh2_dlc15_army_abilities_skarsniks_big_waaagh",
	"wh2_dlc15_army_abilities_skarsniks_waaagh",
	"wh2_dlc15_army_abilities_waaagh",
	"wh2_dlc15_army_abilities_wurrzags_big_waaagh",
	"wh2_dlc15_army_abilities_wurrzags_waaagh"
}

waaagh_use_table = {}
waaagh_active_table = {}
waaagh_army_unit_counts = {}

local function fire_waaagh(army,army_id_str)
	for i = 1, #waaagh_list do		
		army:use_special_ability(waaagh_list[i],v(0,0,0)) -- only the waaagh ability this army actually has will be used
	end
	--army:reset_currency_amount("army_ability_bar_fill") -- this needs to be reset in script for AI, which is... interesting. also, this command doesn't work, hence the reason for this time delay scheme
	waaagh_use_table[army_id_str] = waaagh_use_table[army_id_str] * 2
	waaagh_active_table[army_id_str] = false
end

local function waaagh_loop()
	for _, alliance in model_pairs(bm:alliances()) do
		for _, army in model_pairs(alliance:armies()) do
			if army:subculture_key() == "wh_main_sc_grn_greenskins" and not army:is_player_controlled() then
				local army_id_str = tostring(army:unique_id())
				
				if not waaagh_use_table[army_id_str] then waaagh_use_table[army_id_str] = 1 end -- set a unique counter for this army to 1 if it hasn't been generated yet
				if not waaagh_army_unit_counts[army_id_str] then waaagh_army_unit_counts[army_id_str] = army:units():count() end -- saving this once here at the beginning so the value doesn't change as units get killed or rout
				
				local points_required = 250 * waaagh_army_unit_counts[army_id_str] * waaagh_use_table[army_id_str] - 1 -- -1 to prevent rounding errors
				if army:currency_amount("army_ability_bar_fill") >= points_required and not waaagh_active_table[army_id_str] then
					local delay = 20000 * (waaagh_use_table[army_id_str] - 1) -- first waaagh has no delay, then 20 seconds per level (levels double each time, so :20 > 1:00 > 2:20 > 5:00)
					waaagh_active_table[army_id_str] = true
					bm:callback(function() fire_waaagh(army,army_id_str) end,delay)
				end
			end
		end
	end
end

bm:repeat_callback(waaagh_loop,3000,"waaagh_callback")