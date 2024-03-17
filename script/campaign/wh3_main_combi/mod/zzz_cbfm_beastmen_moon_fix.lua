local function init()
	-- CBFM: fixing the saving/loading of selected_moon_type value
	function beastmen_moon:update_moon_phase(context)
		-- Get phases 1 to 8, inclusive. Phases 1-7 have associated dark-moon effects, while 8 is the 'full moon' and does a special event.
		self.moon_phase = 1 + ((cm:turn_number() - 1) % self.moon_max_phase);
		self.previous_moon_effect = self.current_moon_effect;

		if self.moon_phase < self.moon_max_phase then
			-- Apply the current Moon Phase effect
			self.current_moon_effect = self.moon_effect_prefix..self.moon_phase;
		else
			if cm:model():turn_number() <= self.moon_max_phase then
				-- THIS WILL ALWAYS BE THE FIRST MOON
				self.selected_moon_type = "solar_eclipse";
			else
				self.selected_moon_type = self:select_item_by_chance(self.moon_dilemma_settings);
			end
			
			cm:set_saved_value("cbfm_selected_moon_type",self.selected_moon_type) -- CBFM fix: save this to our own saved value since the saving/loading is broken for this value in the original script

			self.current_moon_effect = self.moon_dilemma_settings[self.selected_moon_type].effect;
		end
	end
	
	-- CBFM: fixing this function to look for the appropriate moon type for "full moon" and to load the value for selected_moon_type from our saved value in case it comes up nil after campaign load
	function Bloodgrounds:grant_ritual_of_ruin_rewards(bloodground)
		local bloodground_owner = cm:get_region(bloodground.herdstone_region):owning_faction()
		local bloodground_owner_key = bloodground_owner:name()
		local moon_multiplier = 1
		local ruination_incident_suffix = ""
		
		if not beastmen_moon.selected_moon_type then
			beastmen_moon.selected_moon_type = cm:get_saved_value("cbfm_selected_moon_type") -- CBFM fix: if this value is coming up nil, that means the game was just loaded (no turns have gone by); load our backup saved value so the modifier still works
		end

		if beastmen_moon.moon_phase == beastmen_moon.moon_max_phase then
			if beastmen_moon.selected_moon_type == "full_moon" then -- CBFM fix: "preparations_full_moon" (not a real thing) to "full_moon" (real thing)
				moon_multiplier = self.moon_multipliers.full_moon
				ruination_incident_suffix = "_full_moon"
			elseif beastmen_moon.selected_moon_type == "lunar_eclipse" then
				moon_multiplier = self.moon_multipliers.lunar_eclipse
				ruination_incident_suffix = "_lunar_eclipse"
			elseif beastmen_moon.selected_moon_type == "solar_eclipse" then
				moon_multiplier = self.moon_multipliers.solar_eclipse
				ruination_incident_suffix = "_solar_eclipse"
			end
		end

		local marks_to_gain = math.floor(bloodground.devastation*moon_multiplier + 0.5)
		
		local payload_string = "payload{faction_pooled_resource_transaction{resource "..self.ruination_key..";factor "..self.ruination_factor..";amount "..tostring(marks_to_gain)..";context absolute;}}"
		
		cm:trigger_custom_incident(bloodground_owner_key,self.ruination_incident..ruination_incident_suffix,true,payload_string)

		self:grant_herdstone_shards(bloodground_owner_key, 1)
		
		Ruination:update_beastmen_progress(bloodground_owner_key, marks_to_gain)
	end
end

cm:add_post_first_tick_callback(init)