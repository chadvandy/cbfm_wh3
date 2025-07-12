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

		-- CBFM: Adding condition to ensure this actually only applies to AI, not the player. h/t CatholicAlcoholic
		if not model:is_multiplayer() and not faction_is_human then 
		-- END CBFM EDITS
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

