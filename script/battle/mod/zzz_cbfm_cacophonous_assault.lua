local function fire_cacophonous()
	if bm:is_conflict_phase() then
		for _, alliance in model_pairs(bm:alliances()) do
			for _, army in model_pairs(alliance:armies()) do
				if army:subculture_key() == "wh_dlc03_sc_bst_beastmen" then
					army:use_special_ability("wh2_dlc17_army_abilities_cacophonous_assault",v(0,0,0))
					army:use_special_ability("wh2_dlc17_army_abilities_cacophonous_assault_upgraded",v(0,0,0))
				end
			end
		end
		bm:remove_callback("cacophonous_callback")
	end
end

bm:repeat_callback(fire_cacophonous,50,"cacophonous_callback")