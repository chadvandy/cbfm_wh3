morbidex_nurglings_spawn = {
	countdown = 4,
	bonus_value_name = "wh3_dlc29_morbidex_nurglings",
	host_of_the_triplets = "wh3_dlc29_chs_host_of_the_triplets",
	the_fecundites = "wh3_dlc20_chs_festus",
	nurgle_culture = "wh3_main_nur_nurgle",
	nurglings_unit_key =  "wh3_main_nur_inf_nurglings_0",
	gardens_of_nurgle = "wh3_dlc29_woc_gardens_of_nurgle",
	daemonic_summoning = "daemonic_summoning",
	nurgle_buildings = "nurgle_buildings",
	nurglings_spawn_data = {}
};

core:add_listener(
	"Morbidex_Nurglings_BV",
	"FactionTurnStart",
	true,
	function(context)

		local faction_interface = context:faction()
		local faction_name = faction_interface:name()
		local faction_culture = faction_interface:culture()

		local scripted_bonus_value = cm:get_factions_bonus_value(faction_interface,morbidex_nurglings_spawn.bonus_value_name)

		if scripted_bonus_value > 0 then

			-- Create faction entry if missing
			if not morbidex_nurglings_spawn.nurglings_spawn_data[faction_name] then
				morbidex_nurglings_spawn.nurglings_spawn_data[faction_name] = {
					countdown = morbidex_nurglings_spawn.countdown
				}
			end

			local faction_data = morbidex_nurglings_spawn.nurglings_spawn_data[faction_name]

			faction_data.countdown = faction_data.countdown - 1

			if faction_data.countdown <= 0 then

				faction_data.countdown = morbidex_nurglings_spawn.countdown

				if faction_name == morbidex_nurglings_spawn.host_of_the_triplets then

					cm:add_unit_to_faction_mercenary_pool(faction_interface,
						morbidex_nurglings_spawn.nurglings_unit_key,
						morbidex_nurglings_spawn.gardens_of_nurgle,
						1, 100, 20, 0.25,
						"", "", "",
						true,
						morbidex_nurglings_spawn.nurglings_unit_key
					)

				elseif faction_name == morbidex_nurglings_spawn.the_fecundites then

					cm:add_unit_to_faction_mercenary_pool(
						faction_interface,
						morbidex_nurglings_spawn.nurglings_unit_key,
						morbidex_nurglings_spawn.daemonic_summoning,
						1, 100, 20, 0.25,
						"", "", "",
						true,
						morbidex_nurglings_spawn.nurglings_unit_key
					)

				elseif faction_culture == morbidex_nurglings_spawn.nurgle_culture then

					cm:add_unit_to_faction_mercenary_pool(
						faction_interface,
						morbidex_nurglings_spawn.nurglings_unit_key,
						morbidex_nurglings_spawn.nurgle_buildings,
						1, 100, 20, 0.25,
						"", "", "",
						true,
						morbidex_nurglings_spawn.nurglings_unit_key
					)
				end
			end
		end
	end,
	true
)

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
    function(context)
        cm:save_named_value("nurglings_spawn_data", morbidex_nurglings_spawn.nurglings_spawn_data,context)
    end
)

cm:add_loading_game_callback(
    function(context)
        if not cm:is_new_game() then
            morbidex_nurglings_spawn.nurglings_spawn_data = cm:load_named_value("nurglings_spawn_data",{},context)
        end
    end
)
