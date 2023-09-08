if not sea_lanes then
	ModLog("CBFM: sea_lanes object not found; Chorf canal incident fix will not function!")
else
	function sea_lanes:character_arrived_incident_listener()
		core:add_listener(
			"sea_lanes_character_arrived",
			"TeleportationNetworkMoveCompleted",
			function(context)
				local from_record = context:from_record()
				local key = from_record:key()

				if from_record:is_null_interface() == false then
					return key:starts_with("wh3_main_sea_lane") or key:starts_with("wh3_dlc23_sea_lane")
				end
			end,
			function(context)
				local character = context:character():character()
				local character_cqi = character:command_queue_index()
				local faction_cqi = character:faction():command_queue_index()
				cm:trigger_incident_with_targets(faction_cqi, self.incident_key, 0, 0, character_cqi, 0, 0, 0)
			end,
			true	
		);
	end
end