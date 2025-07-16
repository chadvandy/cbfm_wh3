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
		return character:won_battle() and cm:char_is_general_with_army(character) and not context:character_has_stolen_ancillary() and attempt_to_award_random_magical_item(context);
	end,
	true
);

function attempt_to_award_random_magical_item(context)
	if not cm:model():campaign_name("wh3_main_prologue") then
		-- Don't award a magical item if it is a quest battle
		local a_char_cqi, a_mf_cqi, a_faction_name = cm:pending_battle_cache_get_attacker(1);
		local d_char_cqi, d_mf_cqi, d_faction_name = cm:pending_battle_cache_get_defender(1);
		local attacker = cm:get_faction(a_faction_name);
		local defender = cm:get_faction(d_faction_name);
		
		if (attacker and attacker:is_quest_battle_faction()) or (defender and defender:is_quest_battle_faction()) then
			out.traits("attempt_to_award_random_magical_item() called, but it is a quest battle. Not going to award anything.");
			return;
		end
		
		local index = 0;
		
		local character = context:character();
		local faction = character:faction();
		local faction_is_human = faction:is_human();
		local faction_name = faction:name();
		local faction_leader = character:is_faction_leader();
		
		if character:is_caster() or cm:general_has_caster_embedded_in_army(character) then
			index = cm:random_number(7); -- this will weigh slightly towards arcane items when the character is a caster (6 or higher)
		else
			index = cm:random_number(5); -- don't drop arcane items if the character involved is not a caster
		end
		
		local new_ancillary_category_list;
		local new_ancillary_list;
		
		if index == 1 then
			new_ancillary_category_list = ancillary_list.armour;
		elseif index == 2 then
			new_ancillary_category_list = ancillary_list.enchanted_item;
		elseif index == 3 then
			new_ancillary_category_list = ancillary_list.general;
		elseif index == 4 then
			new_ancillary_category_list = ancillary_list.talisman;
		elseif index == 5 then
			new_ancillary_category_list = ancillary_list.weapon;
		else
			new_ancillary_category_list = ancillary_list.arcane_item;
		end
		
		-- get the list of ancillaries based on the rarity
		local rarity_roll = cm:random_number(100);
		local faction_bv_rarity = cm:get_factions_bonus_value(character:faction(), "post_battle_ancillary_drop_rarity_mod");
		local char_bv_rarity = cm:get_characters_bonus_value(character, "post_battle_ancillary_drop_rarity_mod");
		rarity_roll = rarity_roll + faction_bv_rarity + char_bv_rarity;
		
		if rarity_roll > 90 then
			new_ancillary_list = new_ancillary_category_list.rare;
		elseif rarity_roll > 60 then
			new_ancillary_list = new_ancillary_category_list.uncommon;
		else
			new_ancillary_list = new_ancillary_category_list.common;
		end

		-- Copy the ancillary list, so that changes to it do not destroy the source data
		new_ancillary_list = table.copy(new_ancillary_list);
		
		local pb = context:pending_battle();
		local model = pb:model();
		local campaign_difficulty = model:difficulty_level();
		local chance = 10;
		local char_bv = cm:get_characters_bonus_value(character, "post_battle_ancillary_drop_chance_mod");
		local faction_bv = cm:get_factions_bonus_value(character:faction(), "post_battle_ancillary_drop_chance_mod");
		local mf_bv = cm:get_forces_bonus_value(character:military_force(), "post_battle_ancillary_drop_chance_mod");
		
		-- mod the chance based on the bonus value state
		local bv_chance = char_bv + faction_bv + mf_bv;
		chance = chance + bv_chance;
		
		if faction_leader == true then
			chance = chance + 10;
		end
		
		-- mod the AI drop chance based on campaign difficulty (only if singleplayer)
		local campaign_difficulty_mod = 0;

		if not model:is_multiplayer() then
			if campaign_difficulty == 1 then					-- easy
				campaign_difficulty_mod = -3;
			elseif campaign_difficulty == 0 then				-- normal
				campaign_difficulty_mod = 0;
			elseif campaign_difficulty == -1 then				-- hard
				campaign_difficulty_mod = 3;
			elseif campaign_difficulty == -2 then				-- very hard
				campaign_difficulty_mod = 6;
			else												-- legendary
				campaign_difficulty_mod = 9;
			end
		end

		-- CBFM EDIT: Adding a condition here so this bonus really only applies to the AI
		if not faction_is_human then
            chance = chance + campaign_difficulty_mod
		end
		-- end CBFM edits
		
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
			end
		end
		
		chance = math.min(chance + victory_type_mod, 100);

		local roll = cm:random_number(100);
		
		if core:is_tweaker_set("FORCE_ANCILLARY_DROP_POST_BATTLE") then
			roll = 1;
		end
		
		out.traits("Rolled a " .. roll .. " to assign an ancillary with a chance of " .. chance .. " for a character belonging to the faction " .. faction_name);
		
		if roll <= chance then
			new_ancillary_list = cm:random_sort(new_ancillary_list);
			
			for i = 1, #new_ancillary_list do
				local current_ancillary_key = new_ancillary_list[i];
				
				if ancillary_is_available_to_faction(current_ancillary_key, faction_name) then
					if faction_is_human then
						local drop_chance = calculate_ancillary_drop_chance(faction, current_ancillary_key);

						if cm:model():random_percent(drop_chance) then
							common.ancillary(current_ancillary_key, 100, context);
							break;
						end
					else
						common.ancillary(current_ancillary_key, 100, context);
						break;
					end
				end
			end
		end

		if faction_is_human then
			common.dev_ui_log_drop_chance(roll, chance, bv_chance, campaign_difficulty_mod, victory_type_mod);
		end
	end
end

function count_items(item_key)
	local faction = cm:get_faction(cm:get_local_faction_name(true));
	local number_of_item_owned = faction:num_ancillaries_owned(item_key);
	local number_of_item_equipped = number_of_item_equipped_in_faction(faction, item_key);
	print("Total Item Count: "..number_of_item_owned);
	print("Number Equipped: "..number_of_item_equipped);
	local drop_chance = calculate_ancillary_drop_chance(faction, item_key);
	print("Drop Chance: "..drop_chance);
end

function calculate_ancillary_drop_chance(faction, item_key)
	local number_of_item_owned = faction:num_ancillaries_owned(item_key);
	local number_of_item_equipped = number_of_item_equipped_in_faction(faction, item_key);

	local drop_chance = 100 - (number_of_item_owned * 50) + (number_of_item_equipped * 50);
	drop_chance = math.min(math.max(drop_chance, 0), 100);
	return drop_chance;
end

function number_of_item_equipped_in_faction(faction, item_key)
	if faction:ancillary_exists(item_key) == false then
		return 0;
	end

	local equipped_item_count = 0;

	for _, character in model_pairs(faction:character_list()) do
		if character:has_ancillary(item_key) then
			equipped_item_count = equipped_item_count + 1;
		end
	end
	return equipped_item_count;
end


function ancillary_is_available_to_faction(ancillary, faction_key)
	if faction_key == "rebels" then
		return false;
	end
	return cco("CcoAncillaryRecord", ancillary):Call("CanFactionUseAncillary(DatabaseRecordContext(\"CcoFactionRecord\", \"" .. faction_key .. "\"))");
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
	
	-- we still haven't found a caster in the faction and the random category selected was arcane item - so change the random category to something else, otherwise we'll never find an equippable arcane item
	-- note that dwarfs technically have casters with character runes (they are arcane items) they are not randomly dropped, so we exclude them specifically here
	if category == "arcane_item" and specified_category ~= "arcane_item" and (not faction_has_caster or faction:culture() == "wh_main_dwf_dwarfs") then
		local filtered_ancillary_categories = {}

		for i = 1, #valid_ancillary_categories do
			if valid_ancillary_categories[i] ~= "arcane_item" then
				table.insert(filtered_ancillary_categories, valid_ancillary_categories[i])
			end
		end

		category = filtered_ancillary_categories[cm:random_number(#filtered_ancillary_categories)];
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