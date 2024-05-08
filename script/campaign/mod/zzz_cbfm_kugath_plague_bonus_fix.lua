local function init()
	cbfm_kugath_bonus_tracker = cm:get_cached_value("cbfm_kugath_bonus_tracker",function() return 10 end) -- check if saved value exists, otherwise default to 10

	core:remove_listener("Plagues_AdditionalMaxBlessedCharacterRankUp")
	core:add_listener(
		"Plagues_AdditionalMaxBlessedCharacterRankUp",
		"CharacterRankUp",
		function(context)
			local character = context:character()
			-- CBFM: Checking if Kugath's rank is equal to or above the last tracked bonus number (increments of 10) instead of checking if rank is divisible by 10, which could fail in case of multi-rank experience gain
			return character:character_subtype(nurgle_plagues.kugath_subtype_key) and character:rank() >= cbfm_kugath_bonus_tracker and character:faction():name() == nurgle_plagues.kugath_faction
		end,
		function (context)
			local pfi = nurgle_plagues.plague_faction_info
			local faction_info = pfi[nurgle_plagues.kugath_faction]
			faction_info.max_blessed_symptoms = faction_info.max_blessed_symptoms + 1
			-- CBFM additions:
			cbfm_kugath_bonus_tracker = cbfm_kugath_bonus_tracker + 10
			cm:set_saved_value("cbfm_kugath_bonus_tracker",cbfm_kugath_bonus_tracker)
		end,
		true
	)
end

cm:add_first_tick_callback(init)