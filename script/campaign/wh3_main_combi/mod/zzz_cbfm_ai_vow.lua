-- this fix was originally made by sm0kin for WH2. All Dux did was port it over to WH3

local knights_protection = {
    "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", 
    "wh_dlc07_trait_brt_knights_vow_order_pledge",
    "wh_dlc07_trait_brt_knights_vow_chivalry_pledge",
    "wh_dlc07_trait_brt_protection_troth_knowledge_pledge",
    "wh_dlc07_trait_brt_protection_troth_order_pledge",
    "wh_dlc07_trait_brt_protection_troth_chivalry_pledge"
} --: vector<string>

local questing_wisdom = {
    "wh_dlc07_trait_brt_questing_vow_campaign_pledge",
    "wh_dlc07_trait_brt_questing_vow_heroism_pledge",
    "wh_dlc07_trait_brt_questing_vow_protect_pledge",
    "wh_dlc07_trait_brt_wisdom_troth_campaign_pledge",
    "wh_dlc07_trait_brt_wisdom_troth_heroism_pledge",
    "wh_dlc07_trait_brt_wisdom_troth_protect_pledge"
} --: vector<string>

local grail_virtue = {
    "wh_dlc07_trait_brt_grail_vow_untaint_pledge",
    "wh_dlc07_trait_brt_grail_vow_valour_pledge",
    "wh_dlc07_trait_brt_grail_vow_destroy_pledge",
    "wh_dlc07_trait_brt_virtue_troth_untaint_pledge",
    "wh_dlc07_trait_brt_virtue_troth_valour_pledge",
    "wh_dlc07_trait_brt_virtue_troth_destroy_pledge"
} --: vector<string>

--v function(character: CA_CHAR, pledge_table: vector<string>) --> boolean
local function has_pledge(character, pledge_table)
    for i = 1, #pledge_table do
        if character:has_trait(pledge_table[i]) then 
            return true
        end
    end  
    return false
end

local function fix_ai_vow()
    core:remove_listener("character_rank_up_vows_per_level_ai")
    -- AI characters get the Vows per level
    core:add_listener(
        "character_rank_up_vows_per_level_ai",
        "CharacterRankUp",
        true,
        function(context)
            local character = context:character()
            if character:faction():is_human() == false and character:faction():culture() == "wh_main_brt_bretonnia" then
                if character:character_type("general") == true then
                    if character:rank() >= 2 then
                        if not has_pledge(character, knights_protection) then
                            for i = 1, 6 do
                                add_vow_progress(character, "wh_dlc07_trait_brt_knights_vow_knowledge_pledge", true, false)
                            end
                        end
                    end
                    if character:rank() >= 5 then
                        if not has_pledge(character, questing_wisdom) then
                            for i = 1, 6 do
                                add_vow_progress(character, "wh_dlc07_trait_brt_questing_vow_protect_pledge", true, false)
                            end
                        end
                    end
                    if character:rank() >= 10 then
                        if not has_pledge(character, grail_virtue) then
                            for i = 1, 6 do
                                add_vow_progress(character, "wh_dlc07_trait_brt_grail_vow_valour_pledge", true, false)
                            end
                        end
                    end
                end
            end
        end,
        true
    )
end

cm:add_post_first_tick_callback(fix_ai_vow)