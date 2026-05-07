dofile_once("mods/gurbertmod/files/scripts/utils.lua")

local gate = GetUpdatedEntityID()
local x, y = EntityGetTransform(gate)

LoadPixelScene("mods/gurbertmod/files/travel_gates/scene.png", "", x-128, y-128, "", true)

local il = EntityLoad("mods/gurbertmod/files/travel_gates/interactable_left.xml", x-40, y-20)
EntityAddChild(gate, il)

local ir = EntityLoad("mods/gurbertmod/files/travel_gates/interactable_right.xml", x+40, y-20)
EntityAddChild(gate, ir)