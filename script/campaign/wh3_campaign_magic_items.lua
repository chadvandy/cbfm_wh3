local ancillary_list = {
	["armour"] = {
		["common"] = {},
		["uncommon"] = {},
		["rare"] = {}
	},
		
	["enchanted_item"] = {
		["common"] = {},
		["uncommon"] = {},
		["rare"] = {}
	},
	
	["general"] = {
		["common"] = {},
		["uncommon"] = {},
		["rare"] = {}
	},
	
	["talisman"] = {
		["common"]	= {},
		["uncommon"] = {},
		["rare"] = {}
	},
	
	["weapon"] = {
		["common"] = {},
		["uncommon"] = {},
		["rare"] = {}
	},
	
	["arcane_item"] = {
		["common"] = {},
		["uncommon"] = {},
		["rare"] = {}
	}
};

local valid_ancillary_categories = {};
local valid_ancillary_rarities = {};

do
	local rarities_parsed = false;
	for category, category_data in pairs(ancillary_list) do
		table.insert(valid_ancillary_categories, category);
		if not rarities_parsed then
			for rarity in pairs(category_data) do
				table.insert(valid_ancillary_rarities, rarity);
			end;
			rarities_parsed = true;
		end;
	end;
end;

-- build the table containing all ancillaries that can be randomly dropped
cm:add_first_tick_callback(
	function()
		local db_ancillary_list = cco("CcoCampaignRoot", ""):Call("DefaultDatabaseRecord(\"CcoAncillaryRecord\")")
		
		for i = 1, #valid_ancillary_categories do
			local current_category = valid_ancillary_categories[i]
			
			for j = 1, #valid_ancillary_rarities do
				local current_rarity = valid_ancillary_rarities[j]
				local filtered_ancillary_list = db_ancillary_list:Call("RecordList.Filter(RandomlyDropped == true && RarityState == \"" .. current_rarity .. "\" && CategoryContext.Key == \"" .. current_category .. "\")")
				
				for k = 1, #filtered_ancillary_list do
					table.insert(ancillary_list[current_category][current_rarity], filtered_ancillary_list[k]:Call("Key"))
				end
			end
		end
	end
)

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
		local faction_is_human = faction:is_human();
		local faction_name = faction:name();
		
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
			new_ancillary_list = ancillary_list.general;
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
		elseif faction_is_human then							-- player
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
		
		chance = math.min(chance + victory_type_mod, 100)
		
		-- tomb kings chance is cut in half due to mortuary cult
		if faction:culture() == "wh2_dlc09_tmb_tomb_kings" then
			chance = chance * 0.5;
		end;
		
		local roll = cm:random_number(100);
		
		if core:is_tweaker_set("FORCE_ANCILLARY_DROP_POST_BATTLE") then
			roll = 1;
		end;
		
		out.traits("Rolled a " .. roll .. " to assign an ancillary with a chance of " .. chance .. " for a character belonging to the faction " .. faction_name);
		
		if roll <= chance then
			new_ancillary_list = cm:random_sort_copy(new_ancillary_list)
			
			for i = 1, #new_ancillary_list do
				local current_ancillary_key = new_ancillary_list[i]
				
				if ancillary_is_available_to_faction(current_ancillary_key, faction_name) then
					common.ancillary(current_ancillary_key, 100, context)
					break
				end
			end
		end;

		if faction_is_human then
			common.dev_ui_log_drop_chance(roll, chance, bv_chance, campaign_difficulty_mod, victory_type_mod);
		end;
	end;
end;


function ancillary_is_available_to_faction(ancillary, faction)
	return cco("CcoAncillaryRecord", ancillary):Call("CanFactionUseAncillary(DatabaseRecordContext(\"CcoFactionRecord\", \"" .. faction .. "\"))")
end



function get_random_ancillary_key_for_faction(faction_key, specified_category, rarity)
	if not validate.is_string(faction_key) then
		return false;
	end;

	local faction = cm:get_faction(faction_key);
	if not faction then
		script_error("ERROR: get_random_ancillary_key_for_faction() called but no faction with supplied key [" .. faction_key .. "] could be found");
		return;
	end;

	if not faction:has_faction_leader() then
		script_error("ERROR: get_random_ancillary_key_for_faction() called but faction with supplied key [" .. faction_key .. "] has no faction leader - how can this be?");
		return;
	end;
	
	if specified_category == "banner" then specified_category = "general" end
	
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
	
	if not rarity then
		rarity = valid_ancillary_rarities[cm:random_number(#valid_ancillary_rarities)];
	elseif not validate.is_string(rarity) then
		return false;
	end;

	if not ancillary_list[category][rarity] then
		script_error("ERROR: get_random_ancillary_key_for_faction() called with rarity [" .. rarity .. "], but this is not a valid ancillary rarity. Valid rarities are " .. table.concat(valid_ancillary_rarities, ", "));
		return;
	end;

	-- if we're looking for an arcane item, try and find a caster in the faction (otherwise they can't equip arcane items)
	local character = faction:faction_leader();
	local faction_has_caster = character:is_caster()
	if category == "arcane_item" and not faction_has_caster then
		for _, character in model_pairs(faction:character_list()) do
			if character:is_caster() and not character:character_type("colonel") then
				faction_has_caster = true
				break;
			end;
		end;
	end;
	
	-- we still haven't found a caster in the faction, and the random category selected was arcane item - so change the random category to something else, otherwise we'll never find an equippable arcane item
	if category == "arcane_item" and specified_category ~= "arcane_item" and not faction_has_caster then
		table.remove(valid_ancillary_categories, 6);

		category = valid_ancillary_categories[cm:random_number(#valid_ancillary_categories)];
	end;

	local ancillary_list_for_category_for_faction = cm:random_sort(ancillary_list[category][rarity]);
	ancillary_list[category][rarity] = ancillary_list_for_category_for_faction;

	for i = 1, #ancillary_list_for_category_for_faction do
		local current_ancillary_key = ancillary_list_for_category_for_faction[i];
		if ancillary_is_available_to_faction(current_ancillary_key, faction_key) then
			return current_ancillary_key;
		end;
	end;

	script_error("ERROR: get_random_ancillary_key_for_faction() called with category [" .. category .. "] and rarity [" .. rarity .. "] for faction [" .. faction_key .. "] but no equippable ancillaries could be found. Will return one at random.");
	return ancillary_list_for_category_for_faction[1];
end;