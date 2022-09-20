local lizardmen_sc = "wh2_main_sc_lzd_lizardmen"
local nakai_faction = "wh2_dlc13_lzd_spirits_of_the_jungle"
local nakai_key = "wh2_dlc13_lzd_nakai"

core:add_listener(
	"fix_nakai_horde__FactionTurnStart",
	"FactionTurnStart",
	function(context)
		return 
            context:faction():subculture() == lizardmen_sc
            and context:faction():name() ~= nakai_faction
	end,
	function(context)
		local character_list = context:faction():character_list()
		for i = 0, character_list:num_items() - 1 do
			local character = character_list:item_at(i)
			if character:has_military_force() and character:military_force():force_type():key() ~= "ARMY" and character:character_subtype_key() == nakai_key then
				cm:convert_force_to_type(character:military_force(), "ARMY")
			end
		end
	end,
	true
)

core:add_listener(
	"fix_nakai_horde_FactionTurnStart",
	"MilitaryForceCreated",
	function(context)
        local mf = context:military_force_created()
        local faction = mf:faction()
		
        return 
            faction:subculture() == lizardmen_sc
            and faction:name() ~= nakai_faction
            and mf:has_general()
            and mf:general_character():character_subtype_key() == nakai_key
            and mf:force_type():key() ~= "ARMY"
	end,
	function(context)
		cm:convert_force_to_type(context:military_force_created(), "ARMY")
	end,
	true
)