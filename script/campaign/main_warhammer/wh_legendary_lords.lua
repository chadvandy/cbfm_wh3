--- This vanilla script causes a script error because it's trying to unlock legendary lords that have their own faction. Just emptying it out!

function unlock_ai_starting_generals() end
function ll_setup() end


----------------- ========================= ------------------
----------------- Vanilla script:
----------------- ========================= ------------------
--[[
    
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	LEGENDARY LORDS
--	This script unlocks legendary lords on bespoke triggers
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- unlock starting generals for the AI - ensure that these are in the start pos but NOT on the map!
-- this gets called in wh_start
function unlock_ai_starting_generals()
	out.design("Legendary Lords -- Turn number reached, unlocking non-faction leader legendary lords for the AI");
	out.design("###############################################");
	
	local ai_starting_generals = {
		{["id"] = "370363105",	["forename"] = "names_name_2147358917",	["faction"] = "wh_main_dwf_dwarfs"},			-- Grombrindal
		{["id"] = "1117066715",	["forename"] = "names_name_2147358013",	["faction"] = "wh_main_emp_empire"},			-- Volkmar the Grim
		{["id"] = "1454422795",	["forename"] = "names_name_2147358044",	["faction"] = "wh_main_vmp_vampire_counts"},	-- Helman Ghorst
		{["id"] = "1332300096",	["forename"] = "names_name_2147345124",	["faction"] = "wh_main_vmp_schwartzhafen"}		-- Isabella von Carstein
	};
	
	for i = 1, #ai_starting_generals do
		local faction = cm:get_faction(ai_starting_generals[i].faction);
		
		if not faction:is_human() then
			out.design("Unlocking legendary lord with forename [" .. ai_starting_generals[i].forename .. "] for AI faction [" .. ai_starting_generals[i].faction .. "]");
			cm:unlock_starting_character_recruitment(ai_starting_generals[i].id, ai_starting_generals[i].faction);
		end;
	end;
	
	out.design("###############################################");
end;

-- load the listeners for every human faction
function ll_setup()
	local emp = cm:get_faction("wh_main_emp_empire")
	
	if emp:is_human() then
		for i = 1, #ll_empire do
			ll_empire[i]:start();
		end;
	end;
	
	local dwf = cm:get_faction("wh_main_dwf_dwarfs")
	
	if dwf:is_human() then
		for i = 1, #ll_dwarfs do
			ll_dwarfs[i]:start();
		end;
	end;
end;



-------------------------------------------------------
--	Empire
-------------------------------------------------------

ll_empire = {
	-- Karl Franz
	ll_unlock:new(
		"wh_main_emp_empire",
		"341461509",
		"names_name_2147343849",
		"FactionJoinsConfederation",
		function(context)
			return context:confederation():name() == "wh_main_emp_empire";
		end
	),

	-- Volkmar the Grim
	ll_unlock:new(
		"wh_main_emp_empire",
		"1117066715",
		"names_name_2147358013",
		"BuildingCompleted",
		function(context)
			local building = context:building();
			return building:name() == "wh_main_emp_worship_2" and building:faction():name() == "wh_main_emp_empire";
		end
	),

	-- Volkmar the Grim - alternate method
	ll_unlock:new(
		"wh_main_emp_empire",
		"1117066715",
		"names_name_2147358013",
		"GarrisonOccupiedEvent",
		function(context)
			return context:character():faction():name() == "wh_main_emp_empire" and context:garrison_residence():region():building_exists("wh_main_emp_worship_2");
		end
	)
};



-------------------------------------------------------
--	Dwarfs
-------------------------------------------------------

ll_dwarfs = {
	-- Thorgrim Grudgebearer
	ll_unlock:new(
		"wh_main_dwf_dwarfs",
		"1031657108",
		"names_name_2147343883",
		"MissionSucceeded",
		function(context)
			if context:faction():name() == "wh_main_dwf_dwarfs" then
				local grudge_count = cm:get_saved_value("ll_dwarfs_thorgrim_grudge_count");
				if grudge_count == nil then grudge_count = 0 end;
				
				local mission = context:mission():mission_record_key();
				
				if string.find(mission, "_grudge_") or string.find(mission, "_prelude_") then
					grudge_count = grudge_count + 1;
					
					cm:set_saved_value("ll_dwarfs_thorgrim_grudge_count", grudge_count);
				end;
				
				return grudge_count > 7;
			end;
		end
	),

	-- Grombrindal
	ll_unlock:new(
		"wh_main_dwf_dwarfs",
		"370363105",
		"names_name_2147358917",
		"BuildingCompleted",
		function(context)
			local building = context:building();
			return building:name() == "wh_main_dwf_slayer_2" and building:faction():name() == "wh_main_dwf_dwarfs";
		end
	),

	-- Grombrindal - alternate method
	ll_unlock:new(
		"wh_main_dwf_dwarfs",
		"370363105",
		"names_name_2147358917",
		"GarrisonOccupiedEvent",
		function(context)
			return context:character():faction():name() == "wh_main_dwf_dwarfs" and context:garrison_residence():region():building_exists("wh_main_dwf_slayer_2");
		end
	)
};
]]