local empire_politics_factions = {
	{elector = "reikland", faction = "wh_main_emp_empire"},
	{elector = "golden", faction = "wh2_dlc13_emp_golden_order"},
	{elector = "averland", faction = "wh_main_emp_averland"},
	{elector = "hochland", faction = "wh_main_emp_hochland"},
	{elector = "middenland", faction = "wh_main_emp_middenland"},
	{elector = "nordland", faction = "wh_main_emp_nordland"},
	{elector = "ostermark", faction = "wh_main_emp_ostermark"},
	{elector = "ostland", faction = "wh_main_emp_ostland"},
	{elector = "stirland", faction = "wh_main_emp_stirland"},
	{elector = "talabecland", faction = "wh_main_emp_talabecland"},
	{elector = "wissenland", faction = "wh_main_emp_wissenland"}
};
local empire_politics_events = {
	["wh_main_emp_empire"] = {
		{key = "politics", turns_to_trigger = 7, turn_restriction = 1, cooldown = 2},
		{key = "invasion", turns_to_trigger = 20, turn_restriction = 5, cooldown = 5},
		{key = "civil_war", turns_to_trigger = 30, turn_restriction = 10, cooldown = 10},
		{key = "succession", turns_to_trigger = 40, turn_restriction = 10, cooldown = 10}
	}
};

local empire_political_invasion = {};
local empire_political_invasion_min_loyalty = 1;
local empire_political_invasion_max_loyalty = 9;

local empire_political_succession = {};
local empire_political_succession_min_loyalty = 0;
local empire_political_succession_max_loyalty = 5;

local empire_political_civil_war = {};
local empire_political_civil_war_min_loyalty = 0;
local empire_political_civil_war_max_loyalty = 10;

local empire_political_dilemma = {};
local empire_demand_return_queue = {};
local empire_demand_return_details = {};
local empire_same_turn_dilemmas = false;
local empire_confederation_cooldown = 20;
local empire_loyalty_war_loss = -4;
local empire_at_peace_war_chance_boost = 10;
local empire_max_loyalty_increase_per_turn = 2;

local empire_authority_elector_war = -4;
local empire_authority_elector_died = -2;
local empire_authority_elector_revived = 1;
local empire_authority_region_razed = -1;
local empire_authority_region_returned = 1;

local empire_prestige_gain_per_building_level = 5;
local empire_prestige_gain_per_region = 5;
local empire_prestige_kill_income_mod = 0.2;
local empire_prestige_kill_income_cap = 1000;
local empire_prestige_kill_value_mod = 0.2;

local political_event_count = 20; -- The total number of 'politics' events there are. i.e. how many events are named 'wh2_dlc13_emp_elector_politics_[X]'? These should be named with incremental numbers, starting at 1.
local empire_political_debug_fire_dilemmas = false;

function add_empire_politics_listeners()
	out("#### Adding Empire Politics Listeners ####");

	local player_faction_name = cm:get_local_faction_name(true);
	
	-- Check to only disable diplomacy for the Empire when player is an Empire faction
	local player_factions = cm:get_human_factions();
	local is_human_player_empire = false;
	
	for i = 1, #player_factions do
		if cm:get_faction(player_factions[i]):pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
			is_human_player_empire = true;
		end
	end

	if is_human_player_empire == true then
		core:add_listener(
			"emp_FactionTurnStart",
			"FactionTurnStart",
			true,
			function(context) empire_turn_start(context) end,
			true
		);
		core:add_listener(
			"emp_DilemmaChoiceMadeEvent",
			"DilemmaChoiceMadeEvent",
			true,
			function(context) empire_dilemma_choice(context) end,
			true
		);
	end
	core:add_listener(
		"emp_RegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		true,
		function(context) empire_region_occupied(context) end,
		true
	);
	core:add_listener(
		"emp_CharacterPerformsSettlementOccupationDecision",
		"CharacterPerformsSettlementOccupationDecision",
		true,
		function(context) empire_occupation_decision(context) end,
		true
	);
	core:add_listener(
		"emp_NegativeDiplomaticEvent",
		"NegativeDiplomaticEvent",
		true,
		function(context) empire_war_declared(context) end,
		true
	);
	core:add_listener(
		"emp_BuildingCompleted",
		"BuildingCompleted",
		true,
		function(context) empire_building_created(context) end,
		true
	);
	core:add_listener(
		"emp_BattleCompleted",
		"BattleCompleted",
		true,
		function(context)
			empire_prestige_battle_reward(context);
			empire_kill_invasion_armies();
		end,
		true
	);
	core:add_listener(
		"emp_CharacterAssignedToPost",
		"CharacterAssignedToPost",
		true,
		function(context)
			local character = context:character();
			local faction = character:faction();
			
			if faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
				empire_elector_rewards(faction, character);
			end
		end,
		true
	);
	core:add_listener(
		"emp_PooledResourceEffectChangedEvent",
		"PooledResourceEffectChangedEvent",
		true,
		function(context)
			local faction = context:faction();
			local resource = context:resource();

			if resource:key() == "emp_imperial_authority" then
				empire_check_civil_war(faction);
			end
		end,
		true
	);
	core:add_listener(
		"emp_ResearchCompleted",
		"ResearchCompleted",
		true,
		function(context)
			local tech = context:technology();

			if tech == "wh2_dlc13_tech_emp_elector_counts_2" then
				for i = 1, #empire_politics_factions do
					local faction_key = empire_politics_factions[i].faction;
					local faction = cm:model():world():faction_by_key(faction_key);

					if faction:is_null_interface() == false and faction:is_human() == false and faction:is_dead() == false then
						if faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
							empire_modify_elector_loyalty(empire_politics_factions[i].elector, "technology", 1);
						end
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"emp_FactionJoinsConfederation",
		"FactionJoinsConfederation",
		true,
		function(context)
			local faction = context:confederation();
			local region_list = faction:region_list();

			for i = 0, region_list:num_items() - 1 do
				local region = region_list:item_at(i);
				local region_key = region:name();
				local region_elector = EMPIRE_REGION_TO_ELECTOR_KEY[region_key];

				if region_elector ~= nil then
					if region_key == EMPIRE_ELECTOR_COUNTS[region_elector].capital and EMPIRE_ELECTOR_COUNTS[region_elector].faction ~= faction:name() then
						core:trigger_event("ScriptEventElectorCapitalTaken");
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"elector_counts_button",
		"ComponentLClickUp",
		function(context)
			return context.string == "elector_counts_button";
		end,
		function(context)
			local player_cqi = cm:get_faction(player_faction_name):command_queue_index();
			cm:apply_effect_bundle("wh2_dlc13_elector_counts_bundle_hidden", player_faction_name, 20);
			cm:faction_add_pooled_resource(player_faction_name, "emp_prestige", "events_negative", -2000);
			
			for i = 1, #EMPIRE_ELECTOR_REWARDS do
				cm:add_units_to_faction_mercenary_pool(player_cqi, EMPIRE_ELECTOR_REWARDS[i].unit, 1);
			end
		end,
		true
	);

	empire_setup_invasion_armies();
	
	if cm:is_new_game() == true then
		empire_new_game_setup();
	end

	if empire_political_debug_fire_dilemmas then
		empire_political_setup_debug_dilemmas();
	end
end

function empire_political_setup_debug_dilemmas()
	cm:add_faction_turn_start_listener_by_name(
			"ElectorDilemmaTest",
			cm:get_local_faction_name(),
			function(context)
				out("Debug-firing all Elector Dilemmas:");

				for i = 1, political_event_count do
					empire_trigger_political_dilemma(context:faction(), i);
				end

				empire_trigger_invasion_dilemma(context:faction(), "averland", "norsca", "wh3_main_combi_region_averheim");
				empire_trigger_invasion_dilemma(context:faction(), "averland", "beastmen", "wh3_main_combi_region_averheim");
				empire_trigger_invasion_dilemma(context:faction(), "averland", "greenskins", "wh3_main_combi_region_averheim");
				empire_trigger_invasion_dilemma(context:faction(), "averland", "skaven", "wh3_main_combi_region_averheim");
			end,
			false);
end

function empire_new_game_setup()
	empire_politics_events["wh2_dlc13_emp_golden_order"] = empire_politics_events["wh_main_emp_empire"];
	local potential_rivals = {};

	empire_modify_elector_loyalty("reikland", "base_fealty", 5);
	empire_modify_elector_loyalty("golden", "base_fealty", 7);
	
	local karl_franz = cm:model():world():faction_by_key("wh_main_emp_empire");

	if karl_franz:is_null_interface() == false and karl_franz:is_human() == true then
		empire_modify_elector_loyalty("averland", "base_fealty", 5);
		empire_modify_elector_loyalty("hochland", "base_fealty", 6);
		empire_modify_elector_loyalty("middenland", "base_fealty", 3);
		empire_modify_elector_loyalty("nordland", "base_fealty", 5);
		empire_modify_elector_loyalty("ostermark", "base_fealty", 4);
		empire_modify_elector_loyalty("ostland", "base_fealty", 6);
		empire_modify_elector_loyalty("stirland", "base_fealty", 5);
		empire_modify_elector_loyalty("talabecland", "base_fealty", 7);
		empire_modify_elector_loyalty("wissenland", "base_fealty", 2);
	else
		empire_modify_elector_loyalty("averland", "base_fealty", 8);
		empire_modify_elector_loyalty("hochland", "base_fealty", 6);
		empire_modify_elector_loyalty("middenland", "base_fealty", 5);
		empire_modify_elector_loyalty("nordland", "base_fealty", 5);
		empire_modify_elector_loyalty("ostermark", "base_fealty", 3);
		empire_modify_elector_loyalty("ostland", "base_fealty", 5);
		empire_modify_elector_loyalty("stirland", "base_fealty", 4);
		empire_modify_elector_loyalty("talabecland", "base_fealty", 7);
		empire_modify_elector_loyalty("wissenland", "base_fealty", 2);
	end

	for i = 1, #empire_politics_factions do
		local faction_key = empire_politics_factions[i].faction;
		local faction = cm:model():world():faction_by_key(faction_key);
		
		if not faction:is_null_interface() then
			local is_human = faction:is_human();
			empire_politics_factions[i].human = is_human;
			empire_politics_factions[i].dead = false;
			empire_politics_factions[i].free_war = false;
			empire_politics_factions[i].confederated = false;
			empire_politics_factions[i].succeeded = false;
			empire_politics_factions[i].confederation_cooldown = 0;
			empire_politics_factions[i].politics = 0;
			empire_politics_factions[i].civil_war = false;
			
			if faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
				empire_elector_rewards(faction);
			end

			if is_human == false then
				table.insert(potential_rivals, faction_key);
			else
				if faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
					empire_modify_elector_loyalty(empire_politics_factions[i].elector, "base_fealty", 5);
				end
				
				-- Make all of the Empire seen
				for region_key, value in pairs(EMPIRE_REGION_TO_ELECTOR_KEY) do
					cm:make_region_seen_in_shroud(faction_key, region_key);
				end
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_pfeildorf");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_steingart");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_fort_bergbres");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_fort_helmgart");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_fort_soll");
				
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_aarnau");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_gorssel");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_marienburg");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_castle_drakenhof");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_eschen");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_waldenhof");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_castle_templehof");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_fort_oberstyre");
				cm:make_region_seen_in_shroud(faction_key, "wh3_main_combi_region_schwartzhafen");

				-- Make diplomacy available to all Electors
				cm:make_diplomacy_available(faction_key, "wh_main_emp_averland");
				cm:make_diplomacy_available(faction_key, "wh_main_emp_hochland");
				cm:make_diplomacy_available(faction_key, "wh_main_emp_middenland");
				cm:make_diplomacy_available(faction_key, "wh_main_emp_nordland");
				cm:make_diplomacy_available(faction_key, "wh_main_emp_ostermark");
				cm:make_diplomacy_available(faction_key, "wh_main_emp_ostland");
				cm:make_diplomacy_available(faction_key, "wh_main_emp_stirland");
				cm:make_diplomacy_available(faction_key, "wh_main_emp_talabecland");
				cm:make_diplomacy_available(faction_key, "wh_main_emp_wissenland");

				cm:make_diplomacy_available(faction_key, "wh_main_vmp_schwartzhafen");
				cm:make_diplomacy_available(faction_key, "wh_main_emp_marienburg");

				if faction_key ~= "wh_main_emp_empire" then
					cm:make_diplomacy_available(faction_key, "wh_main_emp_empire");
				end
				if faction_key ~= "wh2_dlc13_emp_golden_order" then
					cm:make_diplomacy_available(faction_key, "wh2_dlc13_emp_golden_order");
				end

				-- Add State troops
				local faction_cqi = faction:command_queue_index();
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_cav_pistoliers_ror_0", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_inf_handgunners_ror_0", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_inf_swordsmen_ror_0", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_inf_halberdiers_ror_0", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_cav_empire_knights_ror_0", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_cav_empire_knights_ror_2", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_inf_crossbowmen_ror_0", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_cav_empire_knights_ror_1", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_art_mortar_ror_0", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_cav_outriders_ror_0", 1);
				cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_veh_steam_tank_ror_0", 1);

				if faction_key ~= "wh_main_emp_empire" then
					cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_inf_greatswords_ror_0", 1);
				end
				if faction_key ~= "wh2_dlc13_emp_golden_order" then
					cm:add_units_to_faction_mercenary_pool(faction_cqi, "wh2_dlc13_emp_inf_spearmen_ror_0", 1);
				end
			end
		end
	end

	-- Shuffle the rivals table
	out.design("Empire Politics: Finding Rivals");
	cm:shuffle_table(potential_rivals);
	local backup_rivals = {unpack(potential_rivals)};
	cm:shuffle_table(backup_rivals);

	for i = 1, #empire_politics_factions do
		out.design("\tElector: "..empire_politics_factions[i].faction);
		local found_rival = 0;

		for j = 1, #potential_rivals do
			-- Give them a rival that isn't themselve
			if potential_rivals[j] ~= empire_politics_factions[i].faction then
				empire_politics_factions[i].rival = potential_rivals[j];
				found_rival = j;
				break;
			end
		end

		if found_rival > 0 then
			table.remove(potential_rivals, found_rival);
		else
			-- Take a random faction
			for j = 1, #backup_rivals do
				if backup_rivals[j] ~= empire_politics_factions[i].faction then
					empire_politics_factions[i].rival = backup_rivals[j];
					found_rival = j;
					break;
				end
			end

			if found_rival > 0 then
				table.remove(backup_rivals, found_rival);
			end
		end
		out.design("\t\tRival: "..tostring(empire_politics_factions[i].rival));
	end
end

function empire_turn_start(context)
	local faction = context:faction();
	local faction_key = faction:name();

	if faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
		if faction:is_human() == true then
			if cm:is_new_game() == false then
				-- Give per region prestige
				empire_award_region_prestige(faction);

				-- Deal with the events for this faction
				empire_process_faction(faction);
				
				-- recount razed regions just in case the value is not up to date
				empire_handle_razed_regions();

				-- Imperial authority gives a chance of loyalty per turn for other Electors
				local fealty_change = 0;
				local fealty_chance = 0;
				local imp_auth = faction:pooled_resource_manager():resource("emp_imperial_authority"):value();

				if imp_auth > -10 then
					if imp_auth <= -7 then
						fealty_change = -1;
						fealty_chance = 5;
					elseif imp_auth <= -4 then
						fealty_change = -1;
						fealty_chance = 2;
					elseif imp_auth <= -2 then
						fealty_change = -1;
						fealty_chance = 1;
					elseif imp_auth > 0 then
						fealty_change = 1;
						fealty_chance = 5;
					end
				end

				if fealty_chance > 0 then
					local increase_list = {};

					for i = 1, #empire_politics_factions do
						local elector_faction = cm:model():world():faction_by_key(empire_politics_factions[i].faction);

						if elector_faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
							local fealty_value = elector_faction:pooled_resource_manager():resource("emp_loyalty"):value();

							if fealty_value == 9 or fealty_value == 1 then
								fealty_chance = 0;
							elseif fealty_value == 8 or fealty_value == 2 then
								if imp_auth > 0 then
									fealty_chance = 3;
								end
							end

							if cm:model():random_percent(fealty_chance) then
								local change = {elector = empire_politics_factions[i].elector, fealty = fealty_change};
								table.insert(increase_list, change);
							end
						end
					end

					if #increase_list > 0 then
						for i = 1, empire_max_loyalty_increase_per_turn do
							local rand = cm:random_number(#increase_list);
							empire_modify_elector_loyalty(increase_list[rand].elector, "positive_imperial_authority", increase_list[rand].fealty);
							table.remove(increase_list, rand);

							if #increase_list == 0 then
								break;
							end
						end
					end
				end
			end
			empire_disable_diplomacy(faction_key, true);
		else
			if cm:is_new_game() == false then
				empire_elector_rewards(faction);
			end

			-- Disable war for this Elector with other Empire factions
			empire_disable_diplomacy(faction_key, false);
		end
	end
end

function empire_disable_diplomacy(faction_key, is_human)
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "form confederation", false, false, false);
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "military alliance", false, false, false);
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "defensive alliance", false, false, false);
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "join war", false, false, false);
	
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "break soft military access", false, false, false);
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "break defensive alliance", false, false, false);
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "break vassal", false, false, false);
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "break client state", false, false, false);
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "break trade", false, false, false);
	cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "break alliance", false, false, false);

	if is_human == false then
		cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "war", false, false, false);
		cm:force_diplomacy("faction:"..faction_key, "subculture:wh_main_sc_emp_empire", "break non aggression pact", false, false, false);
	else
		cm:force_diplomacy("faction:"..faction_key, "faction:wh2_dlc13_emp_the_huntmarshals_expedition", "form confederation", true, true, false);
		cm:force_diplomacy("faction:"..faction_key, "faction:wh2_main_emp_sudenburg", "form confederation", true, true, false);
	end
end

function empire_award_region_prestige(faction)
	if faction:pooled_resource_manager():resource("emp_prestige"):is_null_interface() == false then
		local faction_key = faction:name();
		local region_count = faction:region_list():num_items();
		local region_prestige = region_count * empire_prestige_gain_per_region;
		cm:faction_add_pooled_resource(faction_key, "emp_prestige", "settlements_owned", region_prestige);
		core:trigger_event("ScriptEventPrestigeGained", faction);
	end
end

function empire_process_faction(faction)
	local faction_key = faction:name();
	out.design("---------- Empire Politics ----------");
	out.design("Faction: "..faction_key);

	empire_authority_update(faction);
	empire_fealty_update(faction);

	local event_triggered = false;
	
	if event_triggered == false then
		out.design("Checking for 'Region Return Dilemmas'...");
		event_triggered = empire_process_queued_dilemmas(faction);
		out.design("\tTriggered: "..tostring(event_triggered));
	end
	
	if event_triggered == false then
		out.design("Checking for 'Civil War Event'...");
		event_triggered = empire_check_civil_war(faction);
		out.design("\tTriggered: "..tostring(event_triggered));
	end

	if event_triggered == false then
		out.design("Checking for 'Fealty Succession'...");
		event_triggered = empire_attempt_successions(faction);
		out.design("\tTriggered: "..tostring(event_triggered));
	end

	if event_triggered == false then
		out.design("Checking for 'Confederation Dilemmas'...");
		event_triggered = empire_attempt_confederation_offer(faction);
		out.design("\tTriggered: "..tostring(event_triggered));
	end

	if event_triggered == false then
		local turn_number = cm:model():turn_number();
		out.design("Checking for 'Politics Events'...");

		for i = 1, #empire_politics_events[faction_key] do
			local event = empire_politics_events[faction_key][i];
			out.design("\tEvent Type: "..event.key.." (Turn Restriction: "..turn_number.." / "..event.turn_restriction..")");

			if turn_number >= event.turn_restriction then
				local chance_to_trigger = ((turn_number - event.turn_restriction) / event.turns_to_trigger) * 100;
				out.design("\tTrigger Chance: "..chance_to_trigger.."%");

				if chance_to_trigger > 0 then
					if event.key == "succession" or event.key == "civil_war" then
						if faction:at_war() == false then
							chance_to_trigger = chance_to_trigger + empire_at_peace_war_chance_boost;
							out.design("\t\tAdding "..empire_at_peace_war_chance_boost.."% due to peace");
						end
					end
				end

				if cm:model():random_percent(chance_to_trigger) then
					out.design("\t\tSuccess!");

					if event.key == "politics" then
						out.design("\tAttempting 'Political' Dilemma...");
						event_triggered = empire_trigger_political_dilemma(faction);
					elseif event.key == "invasion" then
						out.design("\tAttempting 'Invasion' Dilemma...");
						event_triggered = empire_trigger_invasion_dilemma(faction);
					elseif event.key == "civil_war" then
						out.design("\tAttempting 'Civil War' Dilemma...");
						event_triggered = empire_trigger_civil_war_dilemma(faction);
					elseif event.key == "succession" then
						out.design("\tAttempting 'Succession' Dilemma...");
						event_triggered = empire_trigger_succession_dilemma(faction);
					end

					if event_triggered == true then
						event.turn_restriction = turn_number + event.cooldown;
						event.times_triggered = (event.times_triggered or 0) + 1;
					end

					out.design("\t\tTriggered: "..tostring(event_triggered));
					break;
				else
					out.design("\t\tFailed!");
				end
			end
		end
	end
	out.design("-------------------------------------");
end

function empire_elector_rewards(faction, character)
	local faction_key = faction:name();
	local char_list = faction:character_list();
	
	for i = 1, #EMPIRE_ELECTOR_REWARDS do
		local position = EMPIRE_ELECTOR_REWARDS[i].position;
		local region_key = EMPIRE_ELECTOR_REWARDS[i].region;
		local has_position = false;
		local auto_assign = false;

		if faction:is_human() == false then
			-- AI factions only need the region
			local region = cm:model():world():region_manager():region_by_key(region_key);
			
			if region:is_null_interface() == false then
				local owner = region:owning_faction();

				if owner:is_null_interface() == false and owner:name() == faction_key then
					has_position = true;
				end
			end
		elseif position == "wh2_main_minister_emp_reikland" and faction_key == "wh_main_emp_empire" then
			-- Does the Empire have Reikland?
			local region = cm:model():world():region_manager():region_by_key("wh3_main_combi_region_altdorf");
			local owner = region:owning_faction();

			if owner:is_null_interface() == false and owner:name() == faction_key then
				has_position = true;
			end
		elseif position == "wh2_main_minister_emp_solland" and faction_key == "wh2_dlc13_emp_golden_order" then
			-- Does the Golden Order have Solland?
			local region = cm:model():world():region_manager():region_by_key("wh3_main_combi_region_pfeildorf");
			local owner = region:owning_faction();

			if owner:is_null_interface() == false and owner:name() == faction_key then
				has_position = true;
			end
		elseif character ~= nil and character:is_null_interface() == false and character:ministerial_position() == position then
			has_position = true;
			auto_assign = true;
		else
			for j = 0, char_list:num_items() - 1 do
				local current_char = char_list:item_at(j);
				local char_position = current_char:ministerial_position();
				
				if char_position == position then
					has_position = true;
					break;
				end
			end
		end

		if has_position == true then
			-- Give Reward
			out.design("Rewarding Elector: "..faction_key.." - "..position);
			if faction:is_human() == true then
				local ancillary = EMPIRE_ELECTOR_REWARDS[i].ancillary;

				if faction:ancillary_exists(ancillary) == false then
					local supress_event = false;

					if character == nil then
						if position == "wh2_main_minister_emp_reikland" and faction_key == "wh_main_emp_empire" then
							auto_assign = true;
							supress_event = true;
							character = faction:faction_leader();
							core:trigger_event("ScriptEventElectorAppointed");
						elseif position == "wh2_main_minister_emp_solland" and faction_key == "wh2_dlc13_emp_golden_order" then
							auto_assign = true;
							supress_event = true;
							character = faction:faction_leader();
							core:trigger_event("ScriptEventElectorAppointed");
						end
					end

					if auto_assign == true and character:can_equip_ancillary(ancillary) == true then
						out.design("\tForcing ancillary - "..ancillary);
						cm:force_add_ancillary(character, ancillary, true, supress_event);
					else
						out.design("\tGiving ancillary - "..ancillary);
						cm:add_ancillary_to_faction(faction, ancillary, supress_event);
					end
				end

				if faction:faction_leader():has_effect_bundle(position) == false then
					if position == "wh2_main_minister_emp_reikland" and faction_key == "wh_main_emp_empire" then
						cm:apply_effect_bundle_to_character(position, faction:faction_leader(), 0);
					elseif position == "wh2_main_minister_emp_solland" and faction_key == "wh2_dlc13_emp_golden_order" then
						cm:apply_effect_bundle_to_character(position, faction:faction_leader(), 0);
					end
				end
			end

			local unit = EMPIRE_ELECTOR_REWARDS[i].unit;
			cm:remove_event_restricted_unit_record_for_faction(unit, faction_key);
			out.design("\tUnlocking Unit: "..unit.." - "..faction_key);
		else
			-- Lock Reward
			out.design("Un-Rewarding Elector: "..faction_key.." - "..position);
			if faction:is_human() == true then
				if position == "wh2_main_minister_emp_reikland" and faction_key == "wh_main_emp_empire" then
					cm:remove_effect_bundle(position, faction_key);
				elseif position == "wh2_main_minister_emp_solland" and faction_key == "wh2_dlc13_emp_golden_order" then
					cm:remove_effect_bundle(position, faction_key);
				end
			end

			local unit = EMPIRE_ELECTOR_REWARDS[i].unit;
			cm:add_event_restricted_unit_record_for_faction(unit, faction_key, position.."_ror_lock");
			out.design("\tLocking Unit: "..unit.." - "..faction_key.." - "..position.."_ror_lock");
		end
	end
end

function empire_authority_update(faction)
	local faction_key = faction:name();

	for i = 1, #empire_politics_factions do
		if empire_politics_factions[i].human == false then
			if empire_politics_factions[i].confederated == false then
				local elector_key = empire_politics_factions[i].faction;
				local faction = cm:model():world():faction_by_key(elector_key);
				local is_dead = faction:is_dead();
				
				if empire_politics_factions[i].dead == false then
					-- They were alive, are they currently alive?
					if is_dead == true then
						out.design("Elector Died: "..elector_key);
						cm:faction_add_pooled_resource(faction_key, "emp_imperial_authority", "elector_counts_destroyed", empire_authority_elector_died);
						core:trigger_event("ScriptEventImperialAuthorityElectorKilled");
					end
				else
					-- They were dead, have they been revived?
					if is_dead == false then
						out.design("Elector Revived: "..elector_key);
						cm:faction_add_pooled_resource(faction_key, "emp_imperial_authority", "elector_counts_reinstated", empire_authority_elector_revived);
					end
				end
				empire_politics_factions[i].dead = is_dead;
			end
		end
	end
end

function empire_fealty_update(faction)
	for i = 1, #empire_politics_factions do
		local elector_key = empire_politics_factions[i].faction;
		local faction_key = faction:name();
		local elector = cm:model():world():faction_by_key(elector_key);

		if elector:is_null_interface() == false and elector:is_dead() == false and elector:is_human() == false and elector:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
			local relations = elector:diplomatic_attitude_towards(faction_key);
			local factors = elector:pooled_resource_manager():resource("emp_loyalty"):factors();
			local low_amount = 0;
			local high_amount = 0;

			for j = 0, factors:num_items() - 1 do
				local factor = factors:item_at(j);
				local min = factor:minimum_value();
				local max = factor:maximum_value();

				if min == -3 then
					low_amount = factor:value();
				elseif max == 3 then
					high_amount = factor:value();
				end
			end
			
			if relations >= 200 then
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "low_relations", -low_amount);
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "high_relations", -high_amount + 3);

			elseif relations >= 100 then
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "low_relations", -low_amount);
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "high_relations", -high_amount + 2);

			elseif relations >= 50 then
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "low_relations", -low_amount);
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "high_relations", -high_amount + 1);

			elseif relations <= -50 then
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "low_relations", -low_amount - 1);
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "high_relations", -high_amount);

			elseif relations <= -100 then
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "low_relations", -low_amount - 2);
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "high_relations", -high_amount);

			elseif relations <= -200 then
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "low_relations", -low_amount - 3);
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "high_relations", -high_amount);

			else
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "low_relations", -low_amount);
				cm:faction_add_pooled_resource(elector_key, "emp_loyalty", "high_relations", -high_amount);
			end
		end
	end
end

function empire_process_queued_dilemmas(faction)
	local faction_key = faction:name();
	local faction_cqi = faction:command_queue_index();
	local dilemma_offered = false;
	
	-- Deal with the queue demand region return dilemmas
	for i = 1, #empire_demand_return_queue do
		if empire_demand_return_queue[i].player == faction_key then
			local region_key = empire_demand_return_queue[i].region;
			local conquerer_key = empire_demand_return_queue[i].conquerer;
			local elector_faction_key = empire_demand_return_queue[i].elector_faction;
			
			empire_trigger_demand_return(faction_key, region_key, conquerer_key, elector_faction_key);
			dilemma_offered = true;
			break;
		end
	end
	return dilemma_offered;
end

function empire_check_civil_war(faction)
	if faction:pooled_resource_manager():resource("emp_imperial_authority"):is_null_interface() == false then
		local value = faction:pooled_resource_manager():resource("emp_imperial_authority"):value();

		if value <= -10 then
			local faction_key = faction:name();

			for i = 1, #empire_politics_factions do
				if empire_politics_factions[i].faction == faction_key and empire_politics_factions[i].civil_war == false then
					local war_dec = false;

					for j = 1, #empire_politics_factions do
						local elector_key = empire_politics_factions[j].faction;

						if elector_key ~= faction_key then
							local elector_faction = cm:model():world():faction_by_key(elector_key);

							if elector_faction:is_null_interface() == false and elector_faction:is_dead() == false then
								if elector_faction:is_ally_vassal_or_client_state_of(faction) == false then
									cm:force_declare_war(elector_key, faction_key, false, false);
									war_dec = true;

									if elector_faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
										empire_modify_elector_loyalty(empire_politics_factions[j].elector, "events_negative", -10);
									end
								end
							end
						end
					end
					if war_dec == true then
						cm:trigger_incident(faction_key, "wh2_dlc13_emp_elector_civil_war", true);
						empire_politics_factions[i].civil_war = true;
						return true;
					end
					break;
				end
			end
		end
	end
	return false;
end

function empire_attempt_confederation_offer(faction)
	-- Go through all electors and see if any have 10 loyalty
	-- If yes then offer the confederation dilemma
	local player_cqi = faction:command_queue_index();

	for i = 1, #empire_politics_factions do
		if empire_politics_factions[i].confederation_cooldown == 0 then
			local elector_faction = cm:model():world():faction_by_key(empire_politics_factions[i].faction);

			if elector_faction:is_null_interface() == false and elector_faction:is_dead() == false then
				if elector_faction:is_human() == false and elector_faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
					local elector_cqi = elector_faction:command_queue_index();
					local loyalty = elector_faction:pooled_resource_manager():resource("emp_loyalty"):value();

					if loyalty >= 10 then
						local elector = empire_politics_factions[i].elector;
						cm:trigger_dilemma_with_targets(player_cqi, "wh2_dlc13_emp_elector_confederate_"..elector, elector_cqi, 0, 0, 0, 0, 0);
						empire_politics_factions[i].confederation_cooldown = empire_confederation_cooldown;
						return true;
					end
				end
			end
		else
			empire_politics_factions[i].confederation_cooldown = empire_politics_factions[i].confederation_cooldown - 1;
		end
	end
	return false;
end

function empire_attempt_successions(faction)
	for i = 1, #empire_politics_factions do
		if empire_politics_factions[i].succeeded == false then
			local elector_faction = cm:model():world():faction_by_key(empire_politics_factions[i].faction);

			if elector_faction:is_null_interface() == false and elector_faction:is_dead() == false and elector_faction:is_human() == false then
				if elector_faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false and elector_faction:at_war_with(faction) == false then
					local elector_cqi = elector_faction:command_queue_index();
					local loyalty = elector_faction:pooled_resource_manager():resource("emp_loyalty"):value();

					if loyalty == 0 then
						local elector = empire_politics_factions[i].elector;
						empire_trigger_succession_dilemma(faction, elector, true);
						empire_politics_factions[i].succeeded = true;
						return true;
					end
				end
			end
		end
	end
	return false;
end

function empire_trigger_demand_return(player_key, region_key, conquerer_key, elector_faction_key)
	local player = cm:model():world():faction_by_key(player_key);
	local player_cqi = player:command_queue_index();

	local region = cm:model():world():region_manager():region_by_key(region_key);
	local region_cqi = region:cqi();
	
	local conquerer = cm:model():world():faction_by_key(conquerer_key);
	local conquerer_cqi = conquerer:command_queue_index();
	
	local elector_faction = cm:model():world():faction_by_key(elector_faction_key);
	local elector_faction_cqi = elector_faction:command_queue_index();
	
	empire_demand_return_details = {player = player_key, region = region_key, conquerer = conquerer_key, elector = elector_faction_key};
	
	if elector_faction:is_dead() == true then
		empire_remove_from_return_queue(region_key, player_key);
	else
		cm:trigger_dilemma_with_targets(player_cqi, "wh2_dlc13_demand_return_"..region_key, elector_faction_cqi, conquerer_cqi, 0, 0, region_cqi, 0);
	end
end

function empire_find_electors_with_loyalty(player, min_loyalty, max_loyalty)
	local electors = {};

	for i = 1, #empire_politics_factions do
		local faction_key = empire_politics_factions[i].faction;
		local faction = cm:model():world():faction_by_key(faction_key);

		if faction:is_null_interface() == false and faction:is_dead() == false then
			if faction:is_human() == false and faction:at_war_with(player) == false then
				if faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
					local loyalty = faction:pooled_resource_manager():resource("emp_loyalty"):value();

					if loyalty >= min_loyalty and loyalty <= max_loyalty then
						table.insert(electors, empire_politics_factions[i]);
					end
				end
			end
		end
	end
	return electors;
end

function empire_get_weighted_elector(player, electors, base_weight, fealty_weight, border_weight)
	local possible_electors = weighted_list:new();

	for i = 1, #electors do
		local weight = base_weight;

		local faction_key = electors[i].faction;
		local faction = cm:model():world():faction_by_key(faction_key);

		if fealty_weight ~= nil then
			if faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
				local fealty = faction:pooled_resource_manager():resource("emp_loyalty"):value();
				local actual_fealty_weight = 0;

				if fealty_weight >= 0 then
					actual_fealty_weight = fealty * fealty_weight;
				else
					actual_fealty_weight = (10 - fealty) * -fealty_weight;
				end
				
				weight = weight + actual_fealty_weight;
			end
		end

		if border_weight ~= nil then
			local player_regions = player:region_list();

			for j = 0, player_regions:num_items() - 1 do
				local region = player_regions:item_at(j);
				local adj_regions = region:adjacent_region_list();
				local borders = false;
				
				for k = 0, adj_regions:num_items() - 1 do
					local adj_region = adj_regions:item_at(k);
					local owner = adj_region:owning_faction();

					if owner:is_null_interface() == false and owner:name() == faction_key then
						borders = true;
						break;
					end
				end

				if borders == true then
					weight = weight + border_weight;
				end
			end
		end

		possible_electors:add_item(electors[i], weight);
	end

	out.design("Weighted Elector List:");
	for i = 1, #possible_electors.items do
		local list_item = possible_electors.items[i];
		out.design("\t"..list_item.item.faction.." - "..list_item.weight);
	end

	local elector, index = possible_electors:weighted_select();
	return electors[index];
end

function empire_trigger_political_dilemma(faction, event_override)
	local faction_key = faction:name();
	local player_cqi = faction:command_queue_index();
	local event_number = 0;

	if event_override ~= nil then
		event_number = event_override;
	else
		local possible_events = weighted_list:new();
		local average_fealty = empire_calculate_average_fealty();
		local imperial_authority = faction:pooled_resource_manager():resource("emp_imperial_authority"):value();

		for i = 1, #empire_politics_factions do
			if empire_politics_factions[i].faction == faction_key then
				local last_event = empire_politics_factions[i].politics or 0;
				local last_event_type = "";
				
				if last_event > 0 then
					last_event_type = EMPIRE_POLITICS_EVENT_TYPES[last_event];
				end

				for j = 1, #EMPIRE_POLITICS_EVENT_TYPES do
					local event_type = EMPIRE_POLITICS_EVENT_TYPES[j];

					if j ~= last_event then
						local weight = 1;

						if event_type == last_event_type then
							weight = weight - 5;
						else
							if event_type == "loyalty_swap" then
								-- Increase chance if average fealty
								if average_fealty >= 4 and average_fealty <= 6 then
									weight = weight + 10;
								end
							elseif event_type == "buy_loyalty" then
								-- Increase chance if low average fealty
								if average_fealty < 4 then
									weight = weight + 10;
								end
							elseif event_type == "save_loyalty" then
								-- Increase chance if high average fealty
								if average_fealty > 6 then
									weight = weight + 10;
								end
							elseif event_type == "buy_authority" then
								-- Increase chance if low authority
								if imperial_authority <= -8 then
									weight = weight + 40;
								elseif imperial_authority <= -4 then
									weight = weight + 30;
								elseif imperial_authority < 0 then
									weight = weight + 20;
								elseif imperial_authority < 3 then
									weight = weight + 5;
								end
							elseif event_type == "save_authority" then
								-- Increase chance if high authority
								if imperial_authority >= 3 then
									weight = weight + 10;
								end
							end
						end
						
						out("\t\tEvent Type: "..tostring(event_type).." - Weighting: "..tostring(weight));
						possible_events:add_item(j, weight);
					end
				end
				break;
			end
		end

		local event, index = possible_events:weighted_select();
		event_number = event;
		out("\t\tSelected Event Type: "..tostring(EMPIRE_POLITICS_EVENT_TYPES[event_number]));
	end
	
	if event_number > 0 then
		local possible_targets = {};
		local target_cqi_1 = 0;
		local target_cqi_2 = 0;
		local target_char = 0;

		for i = 1, #empire_politics_factions do
			local elector = cm:model():world():faction_by_key(empire_politics_factions[i].faction);

			if elector:is_null_interface() == false and elector:is_dead() == false and elector:is_human() == false then
				table.insert(possible_targets, elector);
			end
		end

		-- Generate targets based on event number
		cm:shuffle_table(possible_targets);

		if event_number >= 1 and event_number <= 4 then
			-- Loyalty Swap - 1, 2, 3, 4
			if #possible_targets >= 2 then
				target_cqi_1 = possible_targets[1]:command_queue_index();
				target_cqi_2 = possible_targets[2]:command_queue_index();
				empire_political_dilemma = {event_type = event_number, target1 = possible_targets[1]:name(), target2 = possible_targets[2]:name()};

				if event_number == 2 then
					target_char = possible_targets[2]:faction_leader():command_queue_index();
				elseif event_number == 4 then
					target_char = possible_targets[1]:faction_leader():command_queue_index();
				end
			else
				return false;
			end
		elseif event_number >= 5 and event_number <= 8 then
			-- Buy Loyalty - 5, 6, 7, 8
			if #possible_targets >= 1 then
				target_cqi_1 = possible_targets[1]:command_queue_index();
				empire_political_dilemma = {event_type = event_number, target1 = possible_targets[1]:name(), target2 = ""};

				if event_number == 6 or event_number == 7 then
					target_char = possible_targets[1]:faction_leader():command_queue_index();
				end
			else
				return false;
			end
		elseif event_number >= 9 and event_number <= 12 then
			-- Save Loyalty - 9, 10, 11, 12
			if #possible_targets >= 1 then
				target_cqi_1 = possible_targets[1]:command_queue_index();
				empire_political_dilemma = {event_type = event_number, target1 = possible_targets[1]:name(), target2 = ""};

				if event_number == 9 or event_number == 10 then
					target_char = possible_targets[1]:faction_leader():command_queue_index();
				end
			else
				return false;
			end
		elseif event_number >= 13 and event_number <= 16 then
			-- Buy Authority - 13, 14, 15, 16
			empire_political_dilemma = {event_type = event_number, target1 = "", target2 = ""};
		elseif event_number >= 17 and event_number <= political_event_count then
			-- Save Authority - 17, 18, 19, 20
			empire_political_dilemma = {event_type = event_number, target1 = "", target2 = ""};
		end
		
		cm:trigger_dilemma_with_targets(
			player_cqi,
			"wh2_dlc13_emp_elector_politics_"..event_number,
			target_cqi_1,
			target_cqi_2,
			target_char,
			0,
			0,
			0,
			function()
				out.design("Triggering Politics Event: "..event_number);
			end
		);
		return true;
	end
	return false;
end

function empire_trigger_invasion_dilemma(faction, elector_override, enemy_override, region_override)
	local faction_key = faction:name();
	local player_cqi = faction:command_queue_index();
	local electors = empire_find_electors_with_loyalty(faction, empire_political_invasion_min_loyalty, empire_political_invasion_max_loyalty);
	cm:take_shroud_snapshot();

	if #electors > 0 or elector_override ~= nil then
		local enemy = "";
		local enemy_faction = "";
		
		if enemy_override ~= nil then
			enemy = enemy_override;

			if enemy == "greenskins" then
				enemy_faction = "wh2_dlc13_grn_greenskins_invasion";
			elseif enemy == "norsca" then
				enemy_faction = "wh2_dlc13_nor_norsca_invasion";
			elseif enemy == "skaven" then
				enemy_faction = "wh2_dlc13_skv_skaven_invasion";
			elseif enemy == "beastmen" then
				enemy_faction = "wh2_dlc13_bst_beastmen_invasion";
			end
		else
			local possible_enemies = {};
			local last_enemy = empire_political_invasion.enemy_key or "";

			if last_enemy ~= "wh2_dlc13_grn_greenskins_invasion" then
				local enemy_t = {key = "greenskins", faction = "wh2_dlc13_grn_greenskins_invasion"};
				table.insert(possible_enemies, enemy_t);
			end
			if last_enemy ~= "wh2_dlc13_nor_norsca_invasion" then
				local enemy_t = {key = "norsca", faction = "wh2_dlc13_nor_norsca_invasion"};
				table.insert(possible_enemies, enemy_t);
			end
			if last_enemy ~= "wh2_dlc13_skv_skaven_invasion" then
				local enemy_t = {key = "skaven", faction = "wh2_dlc13_skv_skaven_invasion"};
				table.insert(possible_enemies, enemy_t);
			end
			if last_enemy ~= "wh2_dlc13_bst_beastmen_invasion" then
				local enemy_t = {key = "beastmen", faction = "wh2_dlc13_bst_beastmen_invasion"};
				table.insert(possible_enemies, enemy_t);
			end
			
			local enemy_rand = cm:random_number(#possible_enemies);
			local enemy_r = possible_enemies[enemy_rand];
			enemy = enemy_r.key;
			enemy_faction = enemy_r.faction;
		end
		
		local rand_elector = empire_get_weighted_elector(faction, electors, 10, 1, 2);
		local elector_key = rand_elector.faction;
		local elector_faction = cm:model():world():faction_by_key(elector_key);

		if elector_override ~= nil then
			elector_key = EMPIRE_ELECTOR_COUNTS[elector_override].faction_key;
			elector_faction = cm:model():world():faction_by_key(elector_key);
		end

		local region = empire_find_random_elector_region(elector_key, true);

		if region_override ~= nil then
			region = cm:model():world():region_manager():region_by_key(region_override);
		end

		if region ~= nil and region:is_null_interface() == false then
			local region_key = region:name();
			local region_level = region:slot_list():item_at(0):building():building_level();

			if region_level < 1 then
				region_level = 1;
			end
			
			local force_key = "electors_"..enemy.."_minor_1";

			if region:is_province_capital() == true then
				-- This is a major settlement with walls
				force_key = "electors_"..enemy.."_major_"..region_level;
			elseif region:building_exists("wh_main_emp_garrison_2") == true then
				-- This is a minor settlement that has walls
				force_key = "electors_"..enemy.."_major_"..region_level;
			else
				-- This is a minor settlement with no walls
				force_key = "electors_"..enemy.."_minor_"..region_level;
			end
			
			local unit_count = random_army_manager:mandatory_unit_count(force_key);
			local spawn_units = random_army_manager:generate_force(force_key, unit_count, false);
			local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(enemy_faction, region_key, false, true, 5);

			if pos_x > -1 then
				local mf = empire_get_garrison_force_for_region(region_key);

				if mf:is_null_interface() == true then
					return false;
				end

				local mf_cqi = mf:command_queue_index();

				empire_political_invasion.player_key = faction_key;
				empire_political_invasion.target_key = elector_key;
				empire_political_invasion.enemy_key = enemy_faction;
				empire_political_invasion.region = region_key;
				empire_political_invasion.level = region_level;
				empire_political_invasion.enemy_char = 0;

				empire_spawn_human_defender_for_invasion();
				
				cm:create_force(
					enemy_faction,
					spawn_units,
					region_key,
					pos_x,
					pos_y,
					true,
					function(char_cqi, force_cqi)
						if enemy_faction == "wh2_dlc13_skv_skaven_invasion" then
							cm:apply_effect_bundle_to_characters_force("wh2_dlc13_elector_invasion_enemy_skaven", char_cqi, 3);
						else
							cm:apply_effect_bundle_to_characters_force("wh2_dlc13_elector_invasion_enemy", char_cqi, 3);
						end
						cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
						cm:force_declare_war(enemy_faction, faction_key, false, false);
						cm:force_declare_war(enemy_faction, elector_key, false, false);
						empire_political_invasion.enemy = force_cqi;
						empire_political_invasion.enemy_char = char_cqi;
						empire_political_invasion.target = mf_cqi;
					end
				);
			end
			
			local enemy_faction = cm:model():world():faction_by_key(enemy_faction);
			local enemy_cqi = enemy_faction:command_queue_index();

			local elector_cqi = elector_faction:command_queue_index();
			local region_cqi = region:cqi();
			
			out.design("Enqueuing Invasion Event for trigger:");
			out.design("\tRegion: "..region_key.." ("..region_level..")");
			out.design("\tUnits: "..spawn_units);

			cm:trigger_dilemma_with_targets(
				player_cqi,
				"wh2_dlc13_emp_elector_invasion_"..enemy,
				elector_cqi,
				enemy_cqi,
				0,
				0,
				region_cqi,
				0,
				function()
					out.design("Triggering Invasion Event:");
					out.design("\tRegion: "..region_key.." ("..region_level..")");
					out.design("\tUnits: "..spawn_units);
				end
			);
			return true;
		end
	end
	return false;
end

function empire_spawn_human_defender_for_invasion()
	local faction_key = empire_political_invasion.player_key;
	local elector_key = empire_political_invasion.target_key;
	local enemy_key = empire_political_invasion.enemy_key;
	local region_key = empire_political_invasion.region;
	local level = empire_political_invasion.level;

	-- Spawn a friendly force
	local force_key = "electors_empire_minor_1";
	local region = cm:model():world():region_manager():region_by_key(region_key);

	if region:is_province_capital() == true then
		-- This is a major settlement with walls
		force_key = "electors_empire_major_"..level;
	elseif region:building_exists("wh_main_emp_garrison_2") == true then
		-- This is a minor settlement that has walls
		force_key = "electors_empire_major_"..level;
	else
		-- This is a minor settlement with no walls
		force_key = "electors_empire_minor_"..level;
	end

	local unit_count = random_army_manager:mandatory_unit_count(force_key);
	local spawn_units = random_army_manager:generate_force(force_key, unit_count, false);
	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 1);

	if pos_x > -1 then
		empire_political_invasion.friendly = 0;
		
		cm:set_army_trespass_disabled(true);
		
		cm:create_force(
			faction_key,
			spawn_units,
			region_key,
			pos_x,
			pos_y,
			true,
			function(char_cqi, force_cqi)
				empire_political_invasion.friendly = char_cqi;
				CampaignUI.ClearSelection();
				cm:apply_effect_bundle_to_character("wh3_main_bundle_character_restrict_experience_gain", cm:get_character_by_cqi(char_cqi), 0);
				cm:set_army_trespass_disabled(false);
			end
		);
	end
end

function empire_get_garrison_force_for_region(region_key)
	local region = cm:model():world():region_manager():region_by_key(region_key);
	local region_owner = region:owning_faction();
	local military_force_list = region_owner:military_force_list();
			
	for j = 0, military_force_list:num_items() - 1 do
		local mf = military_force_list:item_at(j);

		if mf:is_armed_citizenry() == true and mf:has_garrison_residence() == true and mf:garrison_residence():region():name() == region_key then
			return mf;
		end
	end
	return cm:null_interface();
end

function empire_find_random_elector_region(faction_key, not_sieged)
	local regions = {};
	local elector_faction = cm:model():world():faction_by_key(faction_key);
	local region_list = elector_faction:region_list();

	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i);

		if not_sieged == false or region:garrison_residence():is_under_siege() == false then
			if region:garrison_residence():has_army() == false then
				local region_key = region:name();
				local g_force = empire_get_garrison_force_for_region(region_key);

				if g_force:is_null_interface() == false then
					table.insert(regions, region);
				end
			end
		end
	end
	if #regions == 0 then
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i);
	
			if not_sieged == false or region:garrison_residence():is_under_siege() == false then
				local region_key = region:name();
				local g_force = empire_get_garrison_force_for_region(region_key);

				if g_force:is_null_interface() == false then
					table.insert(regions, region);
				end
			end
		end
	end
	if #regions > 0 then
		local rand = cm:random_number(#regions);
		return regions[rand];
	end
	return nil;
end

function empire_trigger_civil_war_dilemma(faction, elector_override)
	local faction_key = faction:name();
	local player_cqi = faction:command_queue_index();

	local actual_empire_political_civil_war_max_loyalty = empire_political_civil_war_max_loyalty;

	if faction:has_technology("wh2_dlc13_tech_emp_elector_counts_1") == true then
		actual_empire_political_civil_war_max_loyalty = actual_empire_political_civil_war_max_loyalty - 1;
	end

	local electors = empire_find_electors_with_loyalty(faction, empire_political_civil_war_min_loyalty, actual_empire_political_civil_war_max_loyalty);

	if #electors > 0 or elector_override ~= nil then
		local rand_elector = empire_get_weighted_elector(faction, electors, 10, 0, 2);
		local elector_key_1 = rand_elector.faction;

		if elector_override ~= nil then
			elector_key_1 = EMPIRE_ELECTOR_COUNTS[elector_override].faction_key;
		end

		local elector_faction_1 = cm:model():world():faction_by_key(elector_key_1);
		local elector_cqi_1 = elector_faction_1:command_queue_index();

		if elector_faction_1:is_null_interface() == true or elector_faction_1:is_dead() == true then
			return false;
		end

		local char_cqi = elector_faction_1:faction_leader():command_queue_index();
		local elector_key_2 = "";
		local elector_cqi_2 = 0;

		for i = 1, #empire_politics_factions do
			if empire_politics_factions[i].faction == elector_key_1 then
				elector_key_2 = empire_politics_factions[i].rival;
				local elector_faction_2 = cm:model():world():faction_by_key(elector_key_2);

				if elector_faction_2:is_null_interface() == true or elector_faction_2:is_dead() == true then
					return false;
				end

				if elector_faction_1:at_war_with(elector_faction_2) == true then
					return false;
				end

				elector_cqi_2 = elector_faction_2:command_queue_index();
				break;
			end
		end

		out.design("Enqueuing Civil War Event:");
		out.design("\tElector 1: "..elector_key_1);
		out.design("\tElector 2: "..elector_key_2);
		
		cm:trigger_dilemma_with_targets(
			player_cqi, 
			"wh2_dlc13_emp_elector_civil_war", 
			elector_cqi_1,
			elector_cqi_2,
			char_cqi,
			0,
			0,
			0,
			function()
				out.design("Triggering Civil War Event:");
				out.design("\tElector 1: "..elector_key_1);
				out.design("\tElector 2: "..elector_key_2);
			end
		);
		empire_political_civil_war.player_key = faction_key;
		empire_political_civil_war.elector_key_1 = elector_key_1;
		empire_political_civil_war.elector_key_2 = elector_key_2;
		return true;
	end
	return false;
end

function empire_trigger_succession_dilemma(faction, elector_override, fealty_event)
	local faction_key = faction:name();
	local player_cqi = faction:command_queue_index();

	local actual_empire_political_succession_max_loyalty = empire_political_succession_max_loyalty;

	if faction:has_technology("wh2_dlc13_tech_emp_elector_counts_1") == true then
		actual_empire_political_succession_max_loyalty = actual_empire_political_succession_max_loyalty - 1;
	end

	local electors = empire_find_electors_with_loyalty(faction, empire_political_succession_min_loyalty, actual_empire_political_succession_max_loyalty);

	if #electors > 0 or elector_override ~= nil then
		local rand_elector = empire_get_weighted_elector(faction, electors, 10, -1, 2);
		local elector_key = rand_elector.faction;

		if elector_override ~= nil then
			elector_key = EMPIRE_ELECTOR_COUNTS[elector_override].faction_key;
		end

		local elector_faction = cm:model():world():faction_by_key(elector_key);
		local elector_faction_cqi = elector_faction:command_queue_index();
		local elector_cqi = elector_faction:faction_leader():command_queue_index();
		
		out.design("Enqueuing Succession Event:");
		out.design("\tElector: "..elector_key);

		local event_key = "wh2_dlc13_emp_elector_succeeds";

		if fealty_event then
			event_key = "wh2_dlc13_emp_elector_succeeds_fealty";
		end

		cm:trigger_dilemma_with_targets(
			player_cqi, 
			event_key, 
			elector_faction_cqi,
			0,
			elector_cqi,
			0,
			0,
			0,
			function()
				out.design("Triggering Succession Event:");
				out.design("\tElector: "..elector_key);
			end
		);
		empire_political_succession.player_key = faction_key;
		empire_political_succession.elector_key = elector_key;
		return true;
	end
	return false;
end

function empire_region_occupied(context)
	local region = context:region();
	local region_key = region:name();
	local previous_faction = context:previous_faction();
	local conquerer = region:owning_faction();
	-- "normal capture", "campaign director", "unopposed capture", "bribery", "surrendered region", "diplomacy trade"
	-- "cli command", "startpos setup", "abandoned", "abandoned to rebels", "civil war", "payload", "unknown reason"
	local reason = context:reason();
	
	-- Remove any existing instance of a region return dilemma
	empire_remove_from_return_queue(region_key);

	-- Handle region razing penalties
	empire_handle_razed_regions(region);
	
	if reason ~= "abandoned" and reason ~= "abandoned to rebels" then
		-- Make sure an Empire faction took the region
		if conquerer:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
			out.design("empire_region_occupied()");
			out.design("\tReason: "..reason);
			out.design("\tRegion: "..region_key);
			
			local elector_key = EMPIRE_REGION_TO_ELECTOR_KEY[region_key];
			out.design("\tElector Key: "..tostring(elector_key));
			
			-- If this region has an associated elector key, then we know it should belong to an Elector
			if elector_key ~= nil then
				local elector_faction_key = EMPIRE_ELECTOR_COUNTS[elector_key].faction_key;
				local elector_faction = cm:model():world():faction_by_key(elector_faction_key);
				local conquerer_key = conquerer:name();
				out.design("\tElector Faction: "..elector_faction_key);
				out.design("\tConquerer Faction: "..conquerer_key);
				
				-- not going to ask for returning if:
					-- the original owner is human
					-- the faction that just got the region is the correct Elector
					-- the original owner is dead
					-- the two relevant factions are at war
				-- If the player occupied the region we can offer them the chance to give the region back
				-- If the player is an Empire faction we can ask them if they want to demand the A.I return its new region
				-- We add it to a queue so that it supports MP where multiple human Empire factions can be asked the same
				if elector_faction:is_human() == false and elector_faction_key ~= conquerer_key and elector_faction:is_dead() == false then
					if conquerer:is_human() == false and conquerer:at_war_with(elector_faction) == false then
						local human_factions = cm:get_human_factions();
						
						for i = 1, #human_factions do
							local player_key = human_factions[i];
							
							if empire_same_turn_dilemmas == true and cm:get_faction(player_key):is_factions_turn() then
								-- If its this factions turns we can ask them right away rather than waiting
								empire_trigger_demand_return(player_key, region_key, conquerer_key, elector_faction_key);
							else
								local region_return = {player = player_key, region = region_key, conquerer = conquerer_key, elector_faction = elector_faction_key};
								out.design("Preparing region return event:\n\tRegion: "..region_key);
								table.insert(empire_demand_return_queue, region_return);
							end
						end
					end
				end
			end
		end
	end
end

function empire_handle_razed_regions(cur_region)
	if cur_region == nil or (cur_region:is_province_capital() and EMPIRE_REGION_TO_ELECTOR_KEY[cur_region:name()]) then
		local razed_region_count = 0;

		for region_key, value in pairs(EMPIRE_REGION_TO_ELECTOR_KEY) do
			local region = cm:model():world():region_manager():region_by_key(region_key);

			if region:is_null_interface() == false then
				if region:is_abandoned() == true and region:is_province_capital() == true then
					razed_region_count = razed_region_count + 1;
				end
			end
		end

		for i = 1, #empire_politics_factions do
			local faction_key = empire_politics_factions[i].faction;
			local faction = cm:model():world():faction_by_key(faction_key);

			if faction:is_null_interface() == false and faction:is_human() == true and faction:pooled_resource_manager():resource("emp_imperial_authority"):is_null_interface() == false then
				local razed_imperial_authority = 0;
				local factors = faction:pooled_resource_manager():resource("emp_imperial_authority"):factors();
				local factor_count = factors:num_items();
	
				for j = 0, factor_count - 1 do
					local factor = factors:item_at(j);
					local min = factor:minimum_value();
	
					if min == -500 then
						razed_imperial_authority = factor:value();
						break;
					end
				end

				local amount_change = -razed_imperial_authority - razed_region_count;

				if amount_change ~= 0 then
					cm:faction_add_pooled_resource(faction_key, "emp_imperial_authority", "imperial_province_capitals_razed", amount_change);
				end
			end
		end
	end
end

function empire_dilemma_choice(context)
	local dilemma = context:dilemma();
	local choice = context:choice();
	local faction = context:faction();
	local faction_key = faction:name();
	out.design("empire_dilemma_choice - "..tostring(dilemma));
	
	-- POLITICS
	if dilemma:starts_with("wh2_dlc13_emp_elector_politics_") then
		local event_number = empire_political_dilemma.event_type;
		local target1 = empire_political_dilemma.target1;
		local target2 = empire_political_dilemma.target2;

		if event_number >= 1 and event_number <= 4 then
			-- Loyalty Swap
			if choice == 0 then
				empire_modify_elector_loyalty(target1, "events", 1);
				empire_modify_elector_loyalty(target2, "events_negative", -1);
			else
				empire_modify_elector_loyalty(target1, "events_negative", -1);
				empire_modify_elector_loyalty(target2, "events", 1);
			end
		elseif event_number >= 5 and event_number <= 8 then
			-- Buy Loyalty
			if choice == 0 or choice == 1 then
				empire_modify_elector_loyalty(target1, "events", 1);
			end
		elseif event_number >= 9 and event_number <= 12 then
			-- Save Loyalty
			if choice == 2 then
				empire_modify_elector_loyalty(target1, "events_negative", -1);
			end
		elseif event_number >= 13 and event_number <= 16 then
			-- Buy Authority
		elseif event_number >= 17 and event_number <= political_event_count then
			-- Save Authority
		end
	-- CONFEDERATION
	elseif dilemma:starts_with("wh2_dlc13_emp_elector_confederate_") then
		local confederation_faction_key = EMPIRE_CONFEDERATION_DILEMMAS[dilemma];
		local confederation_faction = cm:model():world():faction_by_key(confederation_faction_key);
		
		if confederation_faction:is_null_interface() == false and confederation_faction:is_dead() == false then
			if choice == 0 then
				cm:force_confederation(faction_key, confederation_faction_key);

				for i = 1, #empire_politics_factions do
					if empire_politics_factions[i].faction == confederation_faction_key then
						empire_politics_factions[i].confederated = true;
					end
				end
			end
		end
	-- RETURN REGION
	elseif dilemma:starts_with("wh2_dlc13_demand_return_") then
		out.design("Region Return Dilemma:");
		local region_key = empire_demand_return_details.region;
		local elector_key = empire_demand_return_details.elector;
		local conquerer = empire_demand_return_details.conquerer;
		local return_faction = cm:model():world():faction_by_key(elector_key);
		out.design("\tregion_key - "..region_key);
		out.design("\telector_key - "..elector_key);
		
		if return_faction:is_null_interface() == false and return_faction:is_dead() == false then
			if choice == 0 then
				out.design("Returning region to faction: "..region_key.." to "..elector_key);
				cm:transfer_region_to_faction(region_key, elector_key);
				cm:faction_add_pooled_resource(faction_key, "emp_imperial_authority", "empire_settlements_returned", empire_authority_region_returned);
				empire_modify_elector_loyalty(conquerer, "demanded_settlements", -1);
				empire_modify_elector_loyalty(elector_key, "returned_settlements", 1);
			else
				empire_modify_elector_loyalty(conquerer, "allowed_expansion", 1);
				empire_modify_elector_loyalty(elector_key, "settlements_not_returned", -1);
			end
		end
		empire_remove_from_return_queue(region_key, faction_key);
		empire_demand_return_details = {};
	-- SUCCESSION
	elseif dilemma == "wh2_dlc13_emp_elector_succeeds" or dilemma == "wh2_dlc13_emp_elector_succeeds_fealty" then
		if choice == 0 then
			empire_allow_free_war(empire_political_succession.player_key);
			cm:force_declare_war(empire_political_succession.elector_key, empire_political_succession.player_key, false, false);
		end
	-- CIVIL WAR
	elseif dilemma == "wh2_dlc13_emp_elector_civil_war" then
		if choice == 0 then
			empire_allow_free_war(empire_political_civil_war.player_key);
			cm:force_declare_war(empire_political_civil_war.player_key, empire_political_civil_war.elector_key_2, false, false);
			cm:force_declare_war(empire_political_civil_war.elector_key_1, empire_political_civil_war.elector_key_2, false, false);
			empire_modify_elector_loyalty(empire_political_civil_war.elector_key_1, "events", 1);
		elseif choice == 1 then
			empire_allow_free_war(empire_political_civil_war.player_key);
			cm:force_declare_war(empire_political_civil_war.player_key, empire_political_civil_war.elector_key_1, false, false);
			cm:force_declare_war(empire_political_civil_war.elector_key_1, empire_political_civil_war.elector_key_2, false, false);
			empire_modify_elector_loyalty(empire_political_civil_war.elector_key_2, "events", 1);
		elseif choice == 3 then
			cm:force_declare_war(empire_political_civil_war.elector_key_1, empire_political_civil_war.elector_key_2, false, false);
			empire_modify_elector_loyalty(empire_political_civil_war.elector_key_1, "events", 1);
			empire_modify_elector_loyalty(empire_political_civil_war.elector_key_2, "events_negative", -1);
		end
	-- INVASION
	elseif dilemma:starts_with("wh2_dlc13_emp_elector_invasion_") then
		local elector_key = empire_political_invasion.target_key;

		if choice == 0 or choice == 1 then
			-- Give the Elector you're defending some loyalty
			empire_modify_elector_loyalty(elector_key, "defended_settlements", 1);
		elseif choice == 2 or choice == 3 then
			empire_modify_elector_loyalty(elector_key, "declined_to_defend_settlement", -1);
			
			cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
			if empire_political_invasion.friendly ~= nil and empire_political_invasion.friendly > 0 then
				cm:kill_character(empire_political_invasion.friendly, true);
			end
			cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 0.2);

			if choice == 2 then
				cm:make_region_visible_in_shroud(empire_political_invasion.player_key, empire_political_invasion.region);
			elseif choice == 3 then
				cm:restore_shroud_from_snapshot();
			end
		end

		-- Force enemy to attack the settlement
		empire_political_invasion.active = true;
		cm:force_attack_of_opportunity(empire_political_invasion.enemy, empire_political_invasion.target, false);
	end
end

function empire_kill_invasion_armies()
	if empire_political_invasion ~= nil and empire_political_invasion.active == true then
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "");

		if empire_political_invasion.friendly ~= nil and empire_political_invasion.friendly > 0 then
			cm:kill_character(empire_political_invasion.friendly, true);
		end
		if empire_political_invasion.enemy_char ~= nil and empire_political_invasion.enemy_char > 0 then
			cm:kill_character(empire_political_invasion.enemy_char, true);
		end
		local enemy_faction = cm:get_faction(empire_political_invasion.enemy_key);
		if enemy_faction:has_home_region() then
			cm:set_region_abandoned(enemy_faction:home_region():name());
		end
		empire_political_invasion.active = false;

		cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 0.2);
	end
	
	cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.2);
end

function empire_occupation_decision(context)
	local decision = context:occupation_decision();
	local faction_key = context:character():faction():name();
	local region = context:garrison_residence():region();
	local region_key = region:name();
	
	if decision == "512551807" then
		-- REINSTATE ELECTOR
		local region_elector = EMPIRE_REGION_TO_ELECTOR_KEY[region_key];
		
		if region_elector ~= nil then
			empire_modify_elector_loyalty(region_elector, "reinstated_elector_count", 2);
			cm:faction_add_pooled_resource(faction_key, "emp_imperial_authority", "elector_counts_reinstated", empire_authority_elector_revived);
		end
		cm:callback(
			function()
				local primary_slot = region:settlement():primary_slot();
				
				if primary_slot:has_building() and primary_slot:building():building_level() == 0 then
					cm:instantly_set_settlement_primary_slot_level(region:settlement(), 1);
					cm:heal_garrison(region:cqi());
				end;
				cm:remove_effect_bundle("wh2_dlc13_emp_reinstated_elector", faction_key);
			end,
			0.2
		);
	elseif decision == "469931029" then
		-- RETURN TO ELECTOR
		local region_elector = EMPIRE_REGION_TO_ELECTOR_KEY[region_key];
		
		if region_elector ~= nil then
			empire_modify_elector_loyalty(region_elector, "returned_settlements", 1);
		end
		cm:callback(
			function()
				local primary_slot = region:settlement():primary_slot();
				
				if primary_slot:has_building() and primary_slot:building():building_level() == 0 then
					cm:instantly_set_settlement_primary_slot_level(region:settlement(), 1);
					cm:heal_garrison(region:cqi());
				end;
				cm:remove_effect_bundle("wh2_dlc13_emp_returned_region", faction_key);
			end,
			0.2
		);
	elseif decision == "662" then
		local region_elector = EMPIRE_REGION_TO_ELECTOR_KEY[region_key];

		if region_elector ~= nil then
			if region_key == EMPIRE_ELECTOR_COUNTS[region_elector].capital then
				core:trigger_event("ScriptEventElectorCapitalTaken");
			end
		end
	end
end

function empire_building_created(context)
	local building = context:building();
	local faction = building:faction();

	if faction:is_null_interface() == false and faction:pooled_resource_manager():resource("emp_prestige"):is_null_interface() == false then
		local building_level = building:building_level();

		if building_level > 0 then
			local faction_key = faction:name();
			local prestige_reward = (building_level + 1) * empire_prestige_gain_per_building_level;
			cm:faction_add_pooled_resource(faction_key, "emp_prestige", "buildings", prestige_reward);
			core:trigger_event("ScriptEventPrestigeGained", faction);
		end
	end
end

function empire_war_declared(context)
	if context:is_war() == true then
		local proposer = context:proposer();
		local recipient = context:recipient();

		if proposer:is_human() == true and proposer:subculture() == "wh_main_sc_emp_empire" and proposer:pooled_resource_manager():resource("emp_imperial_authority"):is_null_interface() == false then
			if recipient:subculture() == "wh_main_sc_emp_empire" and recipient:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
				local player = proposer:name();

				for i = 1, #empire_politics_factions do
					if empire_politics_factions[i].faction == player then
						if empire_politics_factions[i].free_war == false then
							cm:faction_add_pooled_resource(player, "emp_imperial_authority", "declared_war_on_elector_counts", empire_authority_elector_war);
						else
							empire_politics_factions[i].free_war = false;
						end
						break;
					end
				end

				local elector = recipient:name();
				empire_modify_elector_loyalty(elector, "declared_war_on_elector_counts", empire_loyalty_war_loss);
				core:trigger_event("ScriptEventImperialAuthorityWarDeclaredOnElector")
			end
		end
	end
end

function empire_prestige_battle_reward(context)
	if cm:model():pending_battle():has_been_fought() == true then
		local attacker_result = cm:model():pending_battle():attacker_battle_result();
		local defender_result = cm:model():pending_battle():defender_battle_result();
		local attacker_won = (attacker_result == "heroic_victory") or (attacker_result == "decisive_victory") or (attacker_result == "close_victory") or (attacker_result == "pyrrhic_victory");
		local defender_won = (defender_result == "heroic_victory") or (defender_result == "decisive_victory") or (defender_result == "close_victory") or (defender_result == "pyrrhic_victory");
		local attacker_value = cm:pending_battle_cache_attacker_value();
		local defender_value = cm:pending_battle_cache_defender_value();
		local already_awarded = {};
		
		-- Give any attackers who won their Prestige
		if attacker_won == true then
			local attacker_multiplier = defender_value / attacker_value;
			attacker_multiplier = math.clamp(attacker_multiplier, 0.5, 1.5);
			local attacker_prestige = (defender_value * empire_prestige_kill_value_mod) * attacker_multiplier;
			local kill_ratio = cm:model():pending_battle():percentage_of_defender_killed();
			attacker_prestige = attacker_prestige * kill_ratio;
			
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i);
				
				if already_awarded[attacker_name] == nil then
					local attacker = cm:model():world():faction_by_key(attacker_name);
			
					if attacker:is_null_interface() == false and attacker:pooled_resource_manager():resource("emp_prestige"):is_null_interface() == false then
						local prestige_reward = attacker_prestige * empire_prestige_kill_income_mod;
						if prestige_reward > empire_prestige_kill_income_cap then
							prestige_reward = empire_prestige_kill_income_cap;
						end
						prestige_reward = math.ceilTo(prestige_reward, 10);
						cm:faction_add_pooled_resource(attacker_name, "emp_prestige", "battles_won", prestige_reward);
						core:trigger_event("ScriptEventPrestigeGained", attacker);
						already_awarded[attacker_name] = true;
						PrestigePrintBattle(attacker_name, attacker_prestige, attacker_value, defender_value, attacker_multiplier, kill_ratio);
					end
				end
			end
		-- Give any defenders who won their Prestige
		elseif defender_won == true then
			local defender_multiplier = attacker_value / defender_value;
			defender_multiplier = math.clamp(defender_multiplier, 0.5, 1.5);
			local defender_prestige = (attacker_value * empire_prestige_kill_value_mod) * defender_multiplier;
			local kill_ratio = cm:model():pending_battle():percentage_of_attacker_killed();
			defender_prestige = defender_prestige * kill_ratio;
			
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i);
				
				if already_awarded[defender_name] == nil then
					local defender = cm:model():world():faction_by_key(defender_name);
			
					if defender:is_null_interface() == false and defender:pooled_resource_manager():resource("emp_prestige"):is_null_interface() == false then
						local prestige_reward = defender_prestige * empire_prestige_kill_income_mod;
						if prestige_reward > empire_prestige_kill_income_cap then
							prestige_reward = empire_prestige_kill_income_cap;
						end
						prestige_reward = math.ceilTo(prestige_reward, 10);
						cm:faction_add_pooled_resource(defender_name, "emp_prestige", "battles_won", prestige_reward);
						core:trigger_event("ScriptEventPrestigeGained", defender);
						already_awarded[defender_name] = true;
						PrestigePrintBattle(defender_name, defender_prestige, attacker_value, defender_value, defender_multiplier, kill_ratio);
					end
				end
			end
		end
	end
end

function PrestigePrintBattle(faction, prestige_amount, aval, dval, bonus_mult, kill_ratio)
	prestige_amount = tonumber(string.format("%.0f", prestige_amount));
	out.design("--------------------------------------------");
	out.design("Prestige Battle Fought");
	out.design("\tWinner: "..faction);
	out.design("\tPrestige: "..prestige_amount);
	out.design("\t\tAttacker Value: "..aval);
	out.design("\t\tDefender Value: "..dval);
	out.design("\t\tValue Modifier: "..empire_prestige_kill_value_mod);
	out.design("\t\tStrength Ratio: "..bonus_mult);
	out.design("\t\tKill Ratio: "..kill_ratio);
	out.design("\t\tKill Modifier: "..empire_prestige_kill_income_mod);
	out.design("\t\tReward Cap: "..empire_prestige_kill_income_cap);
	out.design("--------------------------------------------");
end

function empire_remove_from_return_queue(region_key, faction_key)
	local index = 1;
	local size = #empire_demand_return_queue;
	
	while index <= size do
		if empire_demand_return_queue[index].region == region_key and (faction_key == nil or empire_demand_return_queue[index].player == faction_key) then
			out.design("Removing from region return queue : "..region_key);
			empire_demand_return_queue[index] = empire_demand_return_queue[size];
			empire_demand_return_queue[size] = nil;
			size = size - 1;
		else
			index = index + 1;
		end
	end
end

function empire_modify_elector_loyalty(elector_count, factor, value)
	if elector_count ~= nil then
		local faction_key = elector_count;

		if EMPIRE_ELECTOR_COUNTS[elector_count] ~= nil then
			faction_key = EMPIRE_ELECTOR_COUNTS[elector_count].faction_key;
			cm:faction_add_pooled_resource(faction_key, "emp_loyalty", factor, value);
		else
			local faction = cm:model():world():faction_by_key(faction_key);

			if faction:is_null_interface() == false and faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
				cm:faction_add_pooled_resource(faction_key, "emp_loyalty", factor, value);
				local loyalty = faction:pooled_resource_manager():resource("emp_loyalty"):value();
				out.design("Elector Fealty : "..faction_key.." : "..loyalty.." : "..factor);
			end
		end

		if value >= 1 then
			if factor ~= "positive_imperial_authority" and factor ~= "negative_imperial_authority" then
				if factor ~= "high_relations" and factor ~= "low_relations" then
					for i = 1, #empire_politics_factions do
						if empire_politics_factions[i].human == true then
							local player_key = empire_politics_factions[i].faction;
							cm:apply_dilemma_diplomatic_bonus(faction_key, player_key, 2);
						end
					end
				end
			end
		end
	end
end

function empire_allow_free_war(elector)
	for i = 1, #empire_politics_factions do
		if empire_politics_factions[i].faction == elector then
			empire_politics_factions[i].free_war = true;
			return true;
		end
	end
	return false;
end

function empire_calculate_average_fealty()
	local total_electors = 0;
	local total_fealty = 0;

	for i = 1, #empire_politics_factions do
		local faction_key = empire_politics_factions[i].faction;
		local faction = cm:model():world():faction_by_key(faction_key);

		if faction:is_null_interface() == false and faction:is_dead() == false and faction:is_human() == false and faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
			total_electors = total_electors + 1;
			total_fealty = total_fealty + faction:pooled_resource_manager():resource("emp_loyalty"):value();
		end
	end
	if total_electors > 0 and total_fealty > 0 then
		local avg = total_fealty / total_electors;
		return avg;
	end
	return 0;
end

function empire_setup_invasion_armies()
	-- EMPIRE
	random_army_manager:new_force("electors_empire_minor_1");
	random_army_manager:add_mandatory_unit("electors_empire_minor_1", "wh_main_emp_inf_swordsmen", 2);
	random_army_manager:add_mandatory_unit("electors_empire_minor_1", "wh_main_emp_inf_handgunners", 1);
	random_army_manager:add_mandatory_unit("electors_empire_minor_1", "wh_main_emp_cav_empire_knights", 1);

	random_army_manager:new_force("electors_empire_minor_2");
	random_army_manager:add_mandatory_unit("electors_empire_minor_2", "wh_main_emp_inf_swordsmen", 2);
	random_army_manager:add_mandatory_unit("electors_empire_minor_2", "wh_main_emp_inf_handgunners", 1);
	random_army_manager:add_mandatory_unit("electors_empire_minor_2", "wh_main_emp_cav_empire_knights", 1);
	
	random_army_manager:new_force("electors_empire_minor_3");
	random_army_manager:add_mandatory_unit("electors_empire_minor_3", "wh_main_emp_inf_swordsmen", 2);
	random_army_manager:add_mandatory_unit("electors_empire_minor_3", "wh_main_emp_inf_handgunners", 1);
	random_army_manager:add_mandatory_unit("electors_empire_minor_3", "wh_main_emp_cav_empire_knights", 2);

	random_army_manager:new_force("electors_empire_major_1");
	random_army_manager:add_mandatory_unit("electors_empire_major_1", "wh_main_emp_inf_swordsmen", 2);
	random_army_manager:add_mandatory_unit("electors_empire_major_1", "wh_main_emp_inf_spearmen_0", 1);
	random_army_manager:add_mandatory_unit("electors_empire_major_1", "wh_main_emp_inf_handgunners", 1);

	random_army_manager:new_force("electors_empire_major_2");
	random_army_manager:add_mandatory_unit("electors_empire_major_2", "wh_main_emp_inf_swordsmen", 2);
	random_army_manager:add_mandatory_unit("electors_empire_major_2", "wh_main_emp_inf_spearmen_1", 1);
	random_army_manager:add_mandatory_unit("electors_empire_major_2", "wh_main_emp_inf_handgunners", 1);

	random_army_manager:new_force("electors_empire_major_3");
	random_army_manager:add_mandatory_unit("electors_empire_major_3", "wh_main_emp_inf_swordsmen", 2);
	random_army_manager:add_mandatory_unit("electors_empire_major_3", "wh_main_emp_inf_spearmen_1", 2);
	random_army_manager:add_mandatory_unit("electors_empire_major_3", "wh_main_emp_inf_handgunners", 2);

	random_army_manager:new_force("electors_empire_major_4");
	random_army_manager:add_mandatory_unit("electors_empire_major_4", "wh_main_emp_inf_greatswords", 1);
	random_army_manager:add_mandatory_unit("electors_empire_major_4", "wh_main_emp_inf_swordsmen", 2);
	random_army_manager:add_mandatory_unit("electors_empire_major_4", "wh_main_emp_inf_halberdiers", 2);
	random_army_manager:add_mandatory_unit("electors_empire_major_4", "wh_main_emp_inf_handgunners", 2);

	random_army_manager:new_force("electors_empire_major_5");
	random_army_manager:add_mandatory_unit("electors_empire_major_5", "wh_main_emp_inf_greatswords", 2);
	random_army_manager:add_mandatory_unit("electors_empire_major_5", "wh_main_emp_inf_swordsmen", 2);
	random_army_manager:add_mandatory_unit("electors_empire_major_5", "wh_main_emp_inf_halberdiers", 2);
	random_army_manager:add_mandatory_unit("electors_empire_major_5", "wh_main_emp_inf_handgunners", 2);
	
	-- BEASTMEN
	random_army_manager:new_force("electors_beastmen_minor_1");
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_1", "wh_dlc03_bst_inf_gor_herd_0", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_1", "wh_dlc03_bst_inf_ungor_spearmen_0", 3);
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_1", "wh_dlc03_bst_inf_ungor_raiders_0", 2);
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_1", "wh_dlc03_bst_inf_centigors_0", 1);

	random_army_manager:new_force("electors_beastmen_minor_2");
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_2", "wh_dlc03_bst_inf_gor_herd_1", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_2", "wh_dlc03_bst_inf_ungor_spearmen_1", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_2", "wh_dlc03_bst_inf_ungor_raiders_0", 3);
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_2", "wh_dlc03_bst_inf_centigors_0", 1);
	
	random_army_manager:new_force("electors_beastmen_minor_3");
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_3", "wh_dlc03_bst_inf_gor_herd_1", 6);
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_3", "wh_dlc03_bst_inf_bestigor_herd_0", 1);
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_3", "wh_dlc03_bst_inf_ungor_raiders_0", 3);
	random_army_manager:add_mandatory_unit("electors_beastmen_minor_3", "wh_dlc03_bst_inf_centigors_0", 2);

	random_army_manager:new_force("electors_beastmen_major_1");
	random_army_manager:add_mandatory_unit("electors_beastmen_major_1", "wh_dlc03_bst_inf_gor_herd_1", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_1", "wh_dlc03_bst_inf_ungor_spearmen_1", 5);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_1", "wh_dlc03_bst_inf_ungor_raiders_0", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_1", "wh_dlc03_bst_inf_minotaurs_0", 2);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_1", "wh_dlc03_bst_inf_cygor_0", 1);
	
	random_army_manager:new_force("electors_beastmen_major_2");
	random_army_manager:add_mandatory_unit("electors_beastmen_major_2", "wh_dlc03_bst_inf_gor_herd_1", 5);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_2", "wh_dlc03_bst_inf_ungor_spearmen_1", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_2", "wh_dlc03_bst_inf_ungor_raiders_0", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_2", "wh_dlc03_bst_inf_minotaurs_0", 2);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_2", "wh_dlc03_bst_inf_cygor_0", 1);
	
	random_army_manager:new_force("electors_beastmen_major_3");
	random_army_manager:add_mandatory_unit("electors_beastmen_major_3", "wh_dlc03_bst_inf_gor_herd_1", 5);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_3", "wh_dlc03_bst_inf_ungor_spearmen_1", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_3", "wh_dlc03_bst_inf_ungor_raiders_0", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_3", "wh_dlc03_bst_inf_minotaurs_0", 2);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_3", "wh_dlc03_bst_inf_cygor_0", 1);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_3", "wh_dlc03_bst_mon_giant_0", 1);
	
	random_army_manager:new_force("electors_beastmen_major_4");
	random_army_manager:add_mandatory_unit("electors_beastmen_major_4", "wh_dlc03_bst_inf_bestigor_herd_0", 2);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_4", "wh_dlc03_bst_inf_gor_herd_1", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_4", "wh_dlc03_bst_inf_ungor_spearmen_1", 5);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_4", "wh_dlc03_bst_inf_ungor_raiders_0", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_4", "wh_dlc03_bst_inf_minotaurs_0", 2);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_4", "wh_dlc03_bst_inf_cygor_0", 1);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_4", "wh_dlc03_bst_mon_giant_0", 1);

	random_army_manager:new_force("electors_beastmen_major_5");
	random_army_manager:add_mandatory_unit("electors_beastmen_major_5", "wh_dlc03_bst_inf_bestigor_herd_0", 3);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_5", "wh_dlc03_bst_inf_gor_herd_1", 5);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_5", "wh_dlc03_bst_inf_ungor_spearmen_1", 3);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_5", "wh_dlc03_bst_inf_ungor_raiders_0", 4);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_5", "wh_dlc03_bst_inf_minotaurs_0", 2);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_5", "wh_dlc03_bst_inf_cygor_0", 1);
	random_army_manager:add_mandatory_unit("electors_beastmen_major_5", "wh_dlc03_bst_mon_giant_0", 1);

	-- NORSCA
	random_army_manager:new_force("electors_norsca_minor_1");
	random_army_manager:add_mandatory_unit("electors_norsca_minor_1", "wh_main_nor_inf_chaos_marauders_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_minor_1", "wh_dlc08_nor_inf_marauder_spearman_0", 3);
	random_army_manager:add_mandatory_unit("electors_norsca_minor_1", "wh_dlc08_nor_inf_marauder_hunters_0", 2);
	random_army_manager:add_mandatory_unit("electors_norsca_minor_1", "wh_dlc08_nor_mon_skinwolves_0", 1);
	
	random_army_manager:new_force("electors_norsca_minor_2");
	random_army_manager:add_mandatory_unit("electors_norsca_minor_2", "wh_main_nor_inf_chaos_marauders_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_minor_2", "wh_dlc08_nor_inf_marauder_spearman_0", 3);
	random_army_manager:add_mandatory_unit("electors_norsca_minor_2", "wh_dlc08_nor_inf_marauder_hunters_0", 3);
	random_army_manager:add_mandatory_unit("electors_norsca_minor_2", "wh_dlc08_nor_mon_skinwolves_0", 1);
	
	random_army_manager:new_force("electors_norsca_minor_3");
	random_army_manager:add_mandatory_unit("electors_norsca_minor_3", "wh_main_nor_inf_chaos_marauders_0", 6);
	random_army_manager:add_mandatory_unit("electors_norsca_minor_3", "wh_dlc08_nor_inf_marauder_champions_0", 1);
	random_army_manager:add_mandatory_unit("electors_norsca_minor_3", "wh_dlc08_nor_inf_marauder_hunters_0", 3);
	random_army_manager:add_mandatory_unit("electors_norsca_minor_3", "wh_dlc08_nor_mon_skinwolves_0", 2);
	
	random_army_manager:new_force("electors_norsca_major_1");
	random_army_manager:add_mandatory_unit("electors_norsca_major_1", "wh_main_nor_inf_chaos_marauders_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_major_1", "wh_dlc08_nor_inf_marauder_spearman_0", 5);
	random_army_manager:add_mandatory_unit("electors_norsca_major_1", "wh_dlc08_nor_inf_marauder_hunters_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_major_1", "wh_main_nor_mon_chaos_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_norsca_major_1", "wh_dlc08_nor_mon_war_mammoth_0", 1);
	
	random_army_manager:new_force("electors_norsca_major_2");
	random_army_manager:add_mandatory_unit("electors_norsca_major_2", "wh_main_nor_inf_chaos_marauders_0", 5);
	random_army_manager:add_mandatory_unit("electors_norsca_major_2", "wh_dlc08_nor_inf_marauder_spearman_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_major_2", "wh_dlc08_nor_inf_marauder_hunters_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_major_2", "wh_main_nor_mon_chaos_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_norsca_major_2", "wh_dlc08_nor_mon_war_mammoth_0", 1);
	
	random_army_manager:new_force("electors_norsca_major_3");
	random_army_manager:add_mandatory_unit("electors_norsca_major_3", "wh_main_nor_inf_chaos_marauders_0", 5);
	random_army_manager:add_mandatory_unit("electors_norsca_major_3", "wh_dlc08_nor_inf_marauder_spearman_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_major_3", "wh_dlc08_nor_inf_marauder_hunters_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_major_3", "wh_main_nor_mon_chaos_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_norsca_major_3", "wh_dlc08_nor_mon_war_mammoth_0", 2);
	
	random_army_manager:new_force("electors_norsca_major_4");
	random_army_manager:add_mandatory_unit("electors_norsca_major_4", "wh_dlc08_nor_inf_marauder_champions_0", 2);
	random_army_manager:add_mandatory_unit("electors_norsca_major_4", "wh_main_nor_inf_chaos_marauders_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_major_4", "wh_dlc08_nor_inf_marauder_spearman_0", 5);
	random_army_manager:add_mandatory_unit("electors_norsca_major_4", "wh_dlc08_nor_inf_marauder_hunters_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_major_4", "wh_main_nor_mon_chaos_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_norsca_major_4", "wh_dlc08_nor_mon_war_mammoth_0", 2);
	
	random_army_manager:new_force("electors_norsca_major_5");
	random_army_manager:add_mandatory_unit("electors_norsca_major_5", "wh_dlc08_nor_inf_marauder_champions_0", 3);
	random_army_manager:add_mandatory_unit("electors_norsca_major_5", "wh_main_nor_inf_chaos_marauders_0", 5);
	random_army_manager:add_mandatory_unit("electors_norsca_major_5", "wh_dlc08_nor_inf_marauder_spearman_0", 3);
	random_army_manager:add_mandatory_unit("electors_norsca_major_5", "wh_dlc08_nor_inf_marauder_hunters_0", 4);
	random_army_manager:add_mandatory_unit("electors_norsca_major_5", "wh_main_nor_mon_chaos_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_norsca_major_5", "wh_dlc08_nor_mon_war_mammoth_0", 2);

	-- SKAVEN
	random_army_manager:new_force("electors_skaven_minor_1");
	random_army_manager:add_mandatory_unit("electors_skaven_minor_1", "wh2_main_skv_inf_clanrats_0", 4);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_1", "wh2_main_skv_inf_clanrat_spearmen_0", 3);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_1", "wh2_main_skv_inf_night_runners_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_1", "wh2_dlc12_skv_inf_ratling_gun_0", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_1", "wh2_main_skv_inf_skavenslaves_0", 1);
	
	random_army_manager:new_force("electors_skaven_minor_2");
	random_army_manager:add_mandatory_unit("electors_skaven_minor_2", "wh2_main_skv_inf_clanrats_0", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_2", "wh2_main_skv_inf_clanrats_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_2", "wh2_main_skv_inf_clanrat_spearmen_1", 3);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_2", "wh2_main_skv_inf_night_runners_1", 3);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_2", "wh2_dlc12_skv_inf_ratling_gun_0", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_2", "wh2_main_skv_inf_skavenslaves_0", 1);
	
	random_army_manager:new_force("electors_skaven_minor_3");
	random_army_manager:add_mandatory_unit("electors_skaven_minor_3", "wh2_main_skv_inf_clanrats_0", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_3", "wh2_main_skv_inf_clanrats_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_3", "wh2_main_skv_inf_stormvermin_1", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_3", "wh2_main_skv_inf_night_runners_1", 3);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_3", "wh2_dlc12_skv_inf_ratling_gun_0", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_3", "wh2_main_skv_inf_warpfire_thrower", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_3", "wh2_main_skv_inf_clanrat_spearmen_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_minor_3", "wh2_main_skv_inf_skavenslaves_0", 1);
	
	random_army_manager:new_force("electors_skaven_major_1");
	random_army_manager:add_mandatory_unit("electors_skaven_major_1", "wh2_main_skv_inf_clanrats_1", 6);
	random_army_manager:add_mandatory_unit("electors_skaven_major_1", "wh2_main_skv_inf_clanrat_spearmen_1", 5);
	random_army_manager:add_mandatory_unit("electors_skaven_major_1", "wh2_main_skv_inf_night_runners_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_1", "wh2_main_skv_mon_rat_ogres", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_1", "wh2_main_skv_mon_hell_pit_abomination", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_major_1", "wh2_main_skv_art_plagueclaw_catapult", 1);
	
	random_army_manager:new_force("electors_skaven_major_2");
	random_army_manager:add_mandatory_unit("electors_skaven_major_2", "wh2_main_skv_inf_clanrats_1", 7);
	random_army_manager:add_mandatory_unit("electors_skaven_major_2", "wh2_main_skv_inf_clanrat_spearmen_1", 3);
	random_army_manager:add_mandatory_unit("electors_skaven_major_2", "wh2_main_skv_inf_stormvermin_0", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_major_2", "wh2_main_skv_inf_night_runners_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_2", "wh2_main_skv_mon_rat_ogres", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_2", "wh2_main_skv_mon_hell_pit_abomination", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_major_2", "wh2_main_skv_art_plagueclaw_catapult", 1);
	
	random_army_manager:new_force("electors_skaven_major_3");
	random_army_manager:add_mandatory_unit("electors_skaven_major_3", "wh2_main_skv_inf_stormvermin_1", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_major_3", "wh2_main_skv_inf_clanrats_1", 6);
	random_army_manager:add_mandatory_unit("electors_skaven_major_3", "wh2_main_skv_inf_clanrat_spearmen_1", 3);
	random_army_manager:add_mandatory_unit("electors_skaven_major_3", "wh2_main_skv_inf_stormvermin_0", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_major_3", "wh2_main_skv_inf_night_runners_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_3", "wh2_main_skv_mon_rat_ogres", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_3", "wh2_main_skv_mon_hell_pit_abomination", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_major_3", "wh2_main_skv_art_plagueclaw_catapult", 2);
	
	random_army_manager:new_force("electors_skaven_major_4");
	random_army_manager:add_mandatory_unit("electors_skaven_major_4", "wh2_main_skv_inf_stormvermin_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_4", "wh2_main_skv_inf_clanrats_1", 5);
	random_army_manager:add_mandatory_unit("electors_skaven_major_4", "wh2_main_skv_inf_clanrat_spearmen_1", 3);
	random_army_manager:add_mandatory_unit("electors_skaven_major_4", "wh2_main_skv_inf_stormvermin_0", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_4", "wh2_main_skv_inf_night_runners_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_4", "wh2_main_skv_mon_rat_ogres", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_4", "wh2_main_skv_mon_hell_pit_abomination", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_major_4", "wh2_main_skv_art_plagueclaw_catapult", 2);
	
	random_army_manager:new_force("electors_skaven_major_5");
	random_army_manager:add_mandatory_unit("electors_skaven_major_5", "wh2_main_skv_inf_stormvermin_1", 3);
	random_army_manager:add_mandatory_unit("electors_skaven_major_5", "wh2_main_skv_inf_clanrats_1", 5);
	random_army_manager:add_mandatory_unit("electors_skaven_major_5", "wh2_main_skv_inf_clanrat_spearmen_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_5", "wh2_main_skv_inf_stormvermin_0", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_5", "wh2_main_skv_inf_night_runners_1", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_5", "wh2_main_skv_mon_rat_ogres", 2);
	random_army_manager:add_mandatory_unit("electors_skaven_major_5", "wh2_main_skv_mon_hell_pit_abomination", 1);
	random_army_manager:add_mandatory_unit("electors_skaven_major_5", "wh2_main_skv_art_plagueclaw_catapult", 2);

	-- GREENSKINS
	random_army_manager:new_force("electors_greenskins_minor_1");
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_1", "wh_main_grn_inf_orc_boyz", 4);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_1", "wh_main_grn_inf_goblin_spearmen", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_1", "wh_main_grn_inf_orc_arrer_boyz", 2);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_1", "wh_main_grn_cav_orc_boar_boyz", 1);

	random_army_manager:new_force("electors_greenskins_minor_2");
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_2", "wh_main_grn_inf_orc_boyz", 4);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_2", "wh_main_grn_inf_goblin_spearmen", 4);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_2", "wh_main_grn_inf_orc_arrer_boyz", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_2", "wh_main_grn_cav_orc_boar_boyz", 1);

	random_army_manager:new_force("electors_greenskins_minor_3");
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_3", "wh_main_grn_inf_orc_boyz", 4);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_3", "wh_main_grn_inf_black_orcs", 1);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_3", "wh_main_grn_inf_goblin_spearmen", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_3", "wh_main_grn_inf_orc_arrer_boyz", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_minor_3", "wh_main_grn_cav_orc_boar_boyz", 2);
	
	random_army_manager:new_force("electors_greenskins_major_1");
	random_army_manager:add_mandatory_unit("electors_greenskins_major_1", "wh_main_grn_inf_orc_boyz", 4);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_1", "wh_main_grn_inf_goblin_spearmen", 5);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_1", "wh_main_grn_inf_orc_arrer_boyz", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_1", "wh_main_grn_mon_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_1", "wh_main_grn_mon_giant", 1);
	
	random_army_manager:new_force("electors_greenskins_major_2");
	random_army_manager:add_mandatory_unit("electors_greenskins_major_2", "wh_main_grn_inf_orc_boyz", 5);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_2", "wh_main_grn_inf_goblin_spearmen", 4);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_2", "wh_main_grn_inf_orc_arrer_boyz", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_2", "wh_main_grn_mon_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_2", "wh_main_grn_mon_giant", 1);
	
	random_army_manager:new_force("electors_greenskins_major_3");
	random_army_manager:add_mandatory_unit("electors_greenskins_major_3", "wh_main_grn_inf_orc_boyz", 5);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_3", "wh_main_grn_inf_goblin_spearmen", 4);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_3", "wh_main_grn_inf_orc_arrer_boyz", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_3", "wh_main_grn_mon_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_3", "wh_main_grn_mon_giant", 1);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_3", "wh_main_grn_mon_arachnarok_spider_0", 1);
	
	random_army_manager:new_force("electors_greenskins_major_4");
	random_army_manager:add_mandatory_unit("electors_greenskins_major_4", "wh_main_grn_inf_black_orcs", 2);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_4", "wh_main_grn_inf_orc_boyz", 4);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_4", "wh_main_grn_inf_goblin_spearmen", 5);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_4", "wh_main_grn_inf_orc_arrer_boyz", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_4", "wh_main_grn_mon_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_4", "wh_main_grn_mon_giant", 1);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_4", "wh_main_grn_mon_arachnarok_spider_0", 1);
	
	random_army_manager:new_force("electors_greenskins_major_5");
	random_army_manager:add_mandatory_unit("electors_greenskins_major_5", "wh_main_grn_inf_black_orcs", 4);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_5", "wh_main_grn_inf_orc_boyz", 5);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_5", "wh_main_grn_inf_goblin_spearmen", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_5", "wh_main_grn_inf_orc_arrer_boyz", 3);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_5", "wh_main_grn_mon_trolls", 2);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_5", "wh_main_grn_mon_giant", 1);
	random_army_manager:add_mandatory_unit("electors_greenskins_major_5", "wh_main_grn_mon_arachnarok_spider_0", 1);
end

-- DEBUGGING
function empire_event(event_type, event_data_1, event_data_2, event_data_3)
	local faction = cm:whose_turn_is_it_single();

	if event_type == "politics" then
		local result = empire_trigger_political_dilemma(faction, event_data_1);
		return result;
	elseif event_type == "invasion" then
		local result = empire_trigger_invasion_dilemma(faction, event_data_1, event_data_2, event_data_3);
		return result;
	elseif event_type == "civil_war" then
		local result = empire_trigger_civil_war_dilemma(faction, event_data_1);
		return result;
	elseif event_type == "succession" then
		local result = empire_trigger_succession_dilemma(faction, event_data_1);
		return result;
	end
	return false;
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("empire_politics_factions", empire_politics_factions, context);
		cm:save_named_value("empire_politics_events", empire_politics_events, context);
		cm:save_named_value("empire_political_dilemma", empire_political_dilemma, context);
		cm:save_named_value("empire_political_invasion", empire_political_invasion, context);
		cm:save_named_value("empire_political_succession", empire_political_succession, context);
		cm:save_named_value("empire_political_civil_war", empire_political_civil_war, context);
		cm:save_named_value("empire_demand_return_queue", empire_demand_return_queue, context);
		cm:save_named_value("empire_demand_return_details", empire_demand_return_details, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			empire_politics_factions = cm:load_named_value("empire_politics_factions", empire_politics_factions, context);
			empire_politics_events = cm:load_named_value("empire_politics_events", empire_politics_events, context);
			empire_political_dilemma = cm:load_named_value("empire_political_dilemma", empire_political_dilemma, context);
			empire_political_invasion = cm:load_named_value("empire_political_invasion", empire_political_invasion, context);
			empire_political_succession = cm:load_named_value("empire_political_succession", empire_political_succession, context);
			empire_political_civil_war = cm:load_named_value("empire_political_civil_war", empire_political_civil_war, context);
			empire_demand_return_queue = cm:load_named_value("empire_demand_return_queue", empire_demand_return_queue, context);
			empire_demand_return_details = cm:load_named_value("empire_demand_return_details", empire_demand_return_details, context);
		end
	end
);

EMPIRE_ELECTOR_COUNTS = {
	["averland"] = {capital = "wh3_main_combi_region_averheim", faction_key = "wh_main_emp_averland"},
	["reikland"] = {capital = "wh3_main_combi_region_altdorf", faction_key = "wh_main_emp_empire"},
	["hochland"] = {capital = "wh3_main_combi_region_hergig", faction_key = "wh_main_emp_hochland"},
	["middenland"] = {capital = "wh3_main_combi_region_middenheim", faction_key = "wh_main_emp_middenland"},
	["nordland"] = {capital = "wh3_main_combi_region_salzenmund", faction_key = "wh_main_emp_nordland"},
	["ostermark"] = {capital = "wh3_main_combi_region_bechafen", faction_key = "wh_main_emp_ostermark"},
	["ostland"] = {capital = "wh3_main_combi_region_wolfenburg", faction_key = "wh_main_emp_ostland"},
	["stirland"] = {capital = "wh3_main_combi_region_wurtbad", faction_key = "wh_main_emp_stirland"},
	["talabecland"] = {capital = "wh3_main_combi_region_talabheim", faction_key = "wh_main_emp_talabecland"},
	["wissenland"] = {capital = "wh3_main_combi_region_nuln", faction_key = "wh_main_emp_wissenland"},
	["solland"] = {capital = "wh3_main_combi_region_pfeildorf", faction_key = ""},
	["sylvania"] = {capital = "wh3_main_combi_region_castle_drakenhof", faction_key = ""},
	["marienburg"] = {capital = "wh3_main_combi_region_marienburg", faction_key = ""},
	["golden"] = {capital = "", faction_key = "wh2_dlc13_emp_golden_order"}
};

EMPIRE_REGION_TO_ELECTOR_KEY = {
	["wh3_main_combi_region_averheim"] = "averland",
	["wh3_main_combi_region_grenzstadt"] = "averland",
	["wh3_main_combi_region_brass_keep"] = "hochland",
	["wh3_main_combi_region_hergig"] = "hochland",
	["wh3_main_combi_region_carroburg"] = "middenland",
	["wh3_main_combi_region_middenheim"] = "middenland",
	["wh3_main_combi_region_middenstag"] = "middenland",
	["wh3_main_combi_region_weismund"] = "middenland",
	["wh3_main_combi_region_dietershafen"] = "nordland",
	["wh3_main_combi_region_salzenmund"] = "nordland",
	["wh3_main_combi_region_bechafen"] = "ostermark",
	["wh3_main_combi_region_essen"] = "ostermark",
	["wh3_main_combi_region_mordheim"] = "ostermark",
	["wh3_main_combi_region_nagenhof"] = "ostermark",
	["wh3_main_combi_region_castle_von_rauken"] = "ostland",
	["wh3_main_combi_region_norden"] = "ostland",
	["wh3_main_combi_region_wolfenburg"] = "ostland",
	["wh3_main_combi_region_altdorf"] = "reikland",
	["wh3_main_combi_region_eilhart"] = "reikland",
	["wh3_main_combi_region_grunburg"] = "reikland",
	["wh3_main_combi_region_helmgart"] = "reikland",
	["wh3_main_combi_region_flensburg"] = "stirland",
	["wh3_main_combi_region_niedling"] = "stirland",
	["wh3_main_combi_region_wurtbad"] = "stirland",
	["wh3_main_combi_region_kappelburg"] = "talabecland",
	["wh3_main_combi_region_kemperbad"] = "talabecland",
	["wh3_main_combi_region_krugenheim"] = "talabecland",
	["wh3_main_combi_region_talabheim"] = "talabecland",
	["wh3_main_combi_region_nuln"] = "wissenland",
	["wh3_main_combi_region_pfeildorf"] = "wissenland",
	["wh3_main_combi_region_wissenburg"] = "wissenland"
};

EMPIRE_CONFEDERATION_DILEMMAS = {
	["wh2_dlc13_emp_elector_confederate_averland"] = "wh_main_emp_averland",
	["wh2_dlc13_emp_elector_confederate_reikland"] = "wh_main_emp_empire",
	["wh2_dlc13_emp_elector_confederate_hochland"] = "wh_main_emp_hochland",
	["wh2_dlc13_emp_elector_confederate_middenland"] = "wh_main_emp_middenland",
	["wh2_dlc13_emp_elector_confederate_nordland"] = "wh_main_emp_nordland",
	["wh2_dlc13_emp_elector_confederate_ostermark"] = "wh_main_emp_ostermark",
	["wh2_dlc13_emp_elector_confederate_ostland"] = "wh_main_emp_ostland",
	["wh2_dlc13_emp_elector_confederate_stirland"] = "wh_main_emp_stirland",
	["wh2_dlc13_emp_elector_confederate_talabecland"] = "wh_main_emp_talabecland",
	["wh2_dlc13_emp_elector_confederate_wissenland"] = "wh_main_emp_wissenland",
	["wh2_dlc13_emp_elector_confederate_golden"] = "wh2_dlc13_emp_golden_order"
};

EMPIRE_ELECTOR_REWARDS = {
	{position = "wh2_main_minister_emp_averland", region = "wh3_main_combi_region_averheim", unit = "wh2_dlc13_emp_cav_pistoliers_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_averland"},
	{position = "wh2_main_minister_emp_hochland", region = "wh3_main_combi_region_hergig", unit = "wh2_dlc13_emp_inf_handgunners_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_hochland"},
	{position = "wh2_main_minister_emp_middenland", region = "wh3_main_combi_region_middenheim", unit = "wh2_dlc13_emp_inf_swordsmen_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_middenland"},
	{position = "wh2_main_minister_emp_nordland", region = "wh3_main_combi_region_salzenmund", unit = "wh2_dlc13_emp_inf_halberdiers_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_nordland"},
	{position = "wh2_main_minister_emp_ostermark", region = "wh3_main_combi_region_bechafen", unit = "wh2_dlc13_emp_cav_empire_knights_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_ostermark"},
	{position = "wh2_main_minister_emp_ostland", region = "wh3_main_combi_region_wolfenburg", unit = "wh2_dlc13_emp_cav_empire_knights_ror_2", ancillary = "wh2_dlc13_anc_weapon_runefang_ostland"},
	{position = "wh2_main_minister_emp_reikland", region = "wh3_main_combi_region_altdorf", unit = "wh2_dlc13_emp_inf_greatswords_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_reikland"},
	{position = "wh2_main_minister_emp_solland", region = "wh3_main_combi_region_pfeildorf", unit = "wh2_dlc13_emp_inf_spearmen_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_solland"},
	{position = "wh2_main_minister_emp_stirland", region = "wh3_main_combi_region_wurtbad", unit = "wh2_dlc13_emp_inf_crossbowmen_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_stirland"},
	{position = "wh2_main_minister_emp_sylvania", region = "wh3_main_combi_region_castle_drakenhof", unit = "wh2_dlc13_emp_cav_empire_knights_ror_1", ancillary = "wh2_dlc13_anc_talisman_sylvania_journal"},
	{position = "wh2_main_minister_emp_talabecland", region = "wh3_main_combi_region_talabheim", unit = "wh2_dlc13_emp_art_mortar_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_talabecland"},
	{position = "wh2_main_minister_emp_wasteland", region = "wh3_main_combi_region_marienburg", unit = "wh2_dlc13_emp_cav_outriders_ror_0", ancillary = "wh2_dlc13_anc_talisman_stadsraad_key"},
	{position = "wh2_main_minister_emp_wissenland", region = "wh3_main_combi_region_nuln", unit = "wh2_dlc13_emp_veh_steam_tank_ror_0", ancillary = "wh2_dlc13_anc_weapon_runefang_wissenland"}
};

EMPIRE_POLITICS_EVENT_TYPES = {
	"loyalty_swap",
	"loyalty_swap",
	"loyalty_swap",
	"loyalty_swap",
	"buy_loyalty",
	"buy_loyalty",
	"buy_loyalty",
	"buy_loyalty",
	"save_loyalty",
	"save_loyalty",
	"save_loyalty",
	"save_loyalty",
	"buy_authority",
	"buy_authority",
	"buy_authority",
	"buy_authority",
	"save_authority",
	"save_authority",
	"save_authority",
	"save_authority"
};