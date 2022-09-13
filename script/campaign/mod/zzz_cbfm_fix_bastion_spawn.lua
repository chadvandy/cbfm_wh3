--[[
Fix for the bastion script failing to spawn armies on IME.

After some testing, all these position fail to spawn even a single army when they're supposed to attack the bastion.
    [out] <110.8s>   Frodo: Bastion Spawn X 1156.
    [out] <110.8s>   Frodo: Bastion Spawn Y 670.

    [out] <111.1s>   Frodo: Bastion Spawn X 1185.
    [out] <111.1s>   Frodo: Bastion Spawn Y 676.

    [out] <111.1s>   Frodo: Bastion Spawn X 1170.
    [out] <111.1s>   Frodo: Bastion Spawn Y 691.

    [out] <112.0s>   Frodo: Bastion Spawn X 1243.
    [out] <112.0s>   Frodo: Bastion Spawn Y 695.

    [out] <112.3s>   Frodo: Bastion Spawn X 1235.
    [out] <112.3s>   Frodo: Bastion Spawn Y 694.

    [out] <113.6s>   Frodo: Bastion Spawn X 1199.
    [out] <113.6s>   Frodo: Bastion Spawn Y 695.

    [out] <113.7s>   Frodo: Bastion Spawn X 1292.
    [out] <113.7s>   Frodo: Bastion Spawn Y 679.

This fix replaces the broken coordinates with nearby working ones.
]]--


Bastion.spawn_locations_by_gate_combi_fixed = {
    {
        gate_key = "wh3_main_combi_region_snake_gate",
        spawn_locations = {
            {1164, 685},
            {1158, 700},--{1156, 670},
            {1167, 697},
            {1185, 684},--{1185, 676},
            {1177, 691}--{1170, 691}
        }
    },
    {
        gate_key = "wh3_main_combi_region_turtle_gate",
        spawn_locations = {
            {1264, 668},
            {1228, 675},
            {1266, 669},
            {1252, 702},--{1243, 695},
            {1241, 680},
            {1224, 697},--{1235, 694}
        }
    },
    {
        gate_key = "wh3_main_combi_region_dragon_gate",
        spawn_locations = {
            {1212, 686},
            {1211, 690},
            {1210, 699},
            {1223, 675},
            {1208, 695},--{1199, 695},
            {1192, 679}--{1292, 679} Pretty sure this one's a typo, 1292 is far from the gate.
        }
    }
}

-- If we're on the IME map, replace the spawn positions for the bastion attackers with the fixed ones from here.
cm:add_first_tick_callback(
    function()
        if cm:get_campaign_name() == "main_warhammer" then
            out("Frodo45127: Fixing spawn points for Great Bastion.")
            Bastion.spawn_locations_by_gate = Bastion.spawn_locations_by_gate_combi_fixed
        end
    end
);
