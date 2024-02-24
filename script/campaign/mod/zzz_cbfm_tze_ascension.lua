-- fix for tze lord to daemon
CUS.subtype_to_bonus_traits["wh3_dlc24_chs_lord_mtze"] = {
                default = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
                }
-- fix for chs lord straight to tze daemon
CUS.subtype_to_bonus_traits["wh_main_chs_lord"] = {
                default = "wh3_dlc20_legacy_trait_lord_undivided_to_marked", 
                wh3_dlc20_chs_daemon_prince_undivided = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
                wh3_dlc20_chs_daemon_prince_tzeentch = "wh3_dlc20_legacy_trait_lord_to_daemon_prince",
                }