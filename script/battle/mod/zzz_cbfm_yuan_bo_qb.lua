if common.get_context_value("CcoBattleRoot", "", "QuestKey") == "wh3_dlc24_ie_qb_cth_yuan_bo_dragons_fang" then
    function new_sound(soundfile, _is_cinematic, _is_vo)
        return new_sfx(soundfile, _is_cinematic, _is_vo)
    end
end