-- CBFM: Rewriting this function so that it works as designed. As of 7.0.3, the default version of this function returns false whenever a single Tier 1 objective is complete (or if on any Tier beyond 1), resulting in duplicated missions

function gunnery_school:are_initial_missions_triggered()
	local faction = cm:get_faction(self.faction_key)
	if is_nil(faction) or faction:is_null_interface() then
		-- CBFM: changing this to true from false: If the faction doesn't exist, we can always assume the initial missions were already triggered
		return true
	end
	for _, key in ipairs(self.progression_unlocks[1].mission_keys) do
		-- CBFM: instead of returning false whenever a T1 mission is NOT active, which results in false as soon as one objective is complete, we return true whenever any T1 mission IS active, which results in true as long as there are T1 missions left
		if cm:mission_is_active_for_faction(faction, key) then
			return true
		end
	end
	-- CBFM: further handling added for progressing beyond T1: If the current stage is 2 or higher, then we always assume that initial missions were previously triggered
	if self.current_stage >= 2 then
		return true
	else
	-- CBFM: we only return false if A. The Nuln/Weissenland faction exists, B. There isn't a single active T1 mission, and C. We have not progressed to T2 or beyond
		return false
	end
end