-- Fix courtesy of wachtl9 on GitHub

if not tower_of_zharr then
	ModLog("CBFM: tower_of_zharr object not found; Tower of Zharr fix will not work")
end

function tower_of_zharr:specialty_district_modifier(district_key, faction_name, modifier_is_addition)

	local specialty_seat = self.district_specialties
	local specialty_district = specialty_seat[district_key]
	if specialty_district ~= nil then
        if specialty_district.current_owner ~= faction_name  and specialty_district.current_owner ~= nil then
			local previous_counter = specialty_district.specialty_seat_counter
            specialty_district.specialty_seat_counter = previous_counter - 1
			local new_counter = specialty_district.specialty_seat_counter
			local effect_bundle_prefix = specialty_district.effect_bundle_key
            local owner = specialty_district.current_owner
			if previous_counter > 0 then
				--remove previous effect_bundle 
				cm:remove_effect_bundle(effect_bundle_prefix .. tostring(previous_counter), owner)
			end
			if new_counter > 0 then
				--apply new effect_bundle 
				cm:apply_effect_bundle(effect_bundle_prefix .. tostring(new_counter), owner,  -1)
			end
		end
		if specialty_district.current_owner == faction_name then

			local previous_counter = specialty_district.specialty_seat_counter
			--check if the modification is addition or subtraction
			if modifier_is_addition then
				specialty_district.specialty_seat_counter  = previous_counter + 1
			else
				specialty_district.specialty_seat_counter  = previous_counter - 1
			end

			local new_counter = specialty_district.specialty_seat_counter

			local effect_bundle_prefix = specialty_district.effect_bundle_key

			if previous_counter > 0 then
				--remove previous effect_bundle 
				cm:remove_effect_bundle(effect_bundle_prefix .. tostring(previous_counter), faction_name)
			end
			if new_counter > 0 then
				--apply new effect_bundle 
				cm:apply_effect_bundle(effect_bundle_prefix .. tostring(new_counter), faction_name,  -1)
			end
		end
	end
end