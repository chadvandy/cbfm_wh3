local tomb_kings_culture = "wh2_dlc09_tmb_tomb_kings"

local function zzz_cbfm_agemouk_ai_caskets()
	-- Automatically on defined turn unlocks caskets for AI from the crafted RoR's
	core:add_listener(
		"turn_start_ai_workshop_crafted_AI",
		"FactionTurnStart",
		function(context)
            local faction = context:faction()
			return faction:culture() == tomb_kings_culture and faction:is_human() == false;
		end,
		function(context)
			local turn = cm:model():turn_number();
            local faction = context:faction()
            local faction_key = faction:name()
			if turn > 1 then 
			cm:remove_event_restricted_unit_record_for_faction("wh2_dlc09_tmb_art_casket_of_souls_0", faction_key);
        else
				out("Nothing more to unlock")
        end
        end,
		true
	);

end

cm:add_first_tick_callback(function()
	cm:callback(zzz_cbfm_agemouk_ai_caskets, 2.5)
end);