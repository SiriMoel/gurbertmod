dofile_once("mods/gurbertmod/files/scripts/utils.lua")

gurbertbrain = {}

local move_hand_to_discarded_old = move_hand_to_discarded

function move_hand_to_discarded()
    --gurbertbrain = {}
    move_hand_to_discarded_old()
end