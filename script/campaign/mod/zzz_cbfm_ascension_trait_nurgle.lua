-- fix for nur lord to daemon
CUS.subtype_to_bonus_traits["wh3_dlc25_chs_lord_mnur"] = {
                default = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
                }
-- fix for chs lord straight to nur daemon
CUS.subtype_to_bonus_traits["wh_main_chs_lord"] = {
                default = "wh3_dlc20_legacy_trait_lord_undivided_to_marked", 
                wh3_dlc20_chs_daemon_prince_undivided = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
                wh3_dlc20_chs_daemon_prince_nurgle = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
                }