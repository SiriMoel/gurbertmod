dofile_once("mods/gurbertmod/files/scripts/utils.lua")

gurbertbrain = {}

--[[local move_hand_to_discarded_old = move_hand_to_discarded

function move_hand_to_discarded()
    --gurbertbrain = {}
    move_hand_to_discarded_old()
end]]

--[[local _draw_actions_for_shot_old = _draw_actions_for_shot

function _draw_actions_for_shot(can_reload_at_end)
    debug_print_hand()
    _draw_actions_for_shot_old(can_reload_at_end)
end]]