dofile_once("mods/gurbertmod/files/scripts/utils.lua")

-- appends

ModLuaFileAppend("data/scripts/gun/gun.lua", "mods/gurbertmod/files/scripts/gun/gun_append.lua")

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/gurbertmod/files/scripts/gun/actions.lua")

-- translations
local translations = ModTextFileGetContent("data/translations/common.csv")
if translations ~= nil then
    while translations:find("\r\n\r\n") do
        translations = translations:gsub("\r\n\r\n","\r\n")
    end
    local new_translations = ModTextFileGetContent(table.concat({"mods/gurbertmod/files/translations.csv"}))
    translations = translations .. new_translations
    ModTextFileSetContent("data/translations/common.csv", translations)
end

-- pixel scenes (from Graham, a long time ago...)
local function add_scene(table)
	local biome_path = ModIsEnabled("noitavania") and "mods/noitavania/data/biome/_pixel_scenes.xml" or "data/biome/_pixel_scenes.xml"
	local content = ModTextFileGetContent(biome_path)
	local string = "<mBufferedPixelScenes>"
	local worldsize = ModTextFileGetContent("data/compatibilitydata/worldsize.txt") or 35840
	for i = 1, #table do
		string = string .. [[<PixelScene pos_x="]] .. table[i][1] .. [[" pos_y="]] .. table[i][2] .. [[" just_load_an_entity="]] .. table[i][3] .. [["/>]]
		if table[i][4] then
			-- make things show up in first 2 parallel worlds
			-- hopefully this won't cause too much lag when starting a run
			string = string .. [[<PixelScene pos_x="]] .. table[i][1] + worldsize .. [[" pos_y="]] .. table[i][2] .. [[" just_load_an_entity="]] .. table[i][3] .. [["/>]]
			string = string .. [[<PixelScene pos_x="]] .. table[i][1] - worldsize .. [[" pos_y="]] .. table[i][2] .. [[" just_load_an_entity="]] .. table[i][3] .. [["/>]]
			string = string .. [[<PixelScene pos_x="]] .. table[i][1] + worldsize * 2 .. [[" pos_y="]] .. table[i][2] .. [[" just_load_an_entity="]] .. table[i][3] .. [["/>]]
			string = string .. [[<PixelScene pos_x="]] .. table[i][1] - worldsize * 2 .. [[" pos_y="]] .. table[i][2] .. [[" just_load_an_entity="]] .. table[i][3] .. [["/>]]
		end
	end
	content = content:gsub("<mBufferedPixelScenes>", string)
	ModTextFileSetContent(biome_path, content)
end

local scenes = {
    --{ x, y, path, spawn_in_pws? },
    { 0, -200, "mods/gurbertmod/files/travel_gates/travel_gate.xml", false },
	{ -300, -200, "mods/gurbertmod/files/travel_gates/travel_gate.xml", false },
}
add_scene(scenes)

-- player
function OnPlayerSpawned(player_entity)
	local x, y = EntityGetTransform(player_entity)

	if GameHasFlagRun("gurbert_init") then return end
	GameAddFlagRun("gurbert_init")

	GlobalsSetValue("gurbert_frog_gate_exit_id", "-1")
end