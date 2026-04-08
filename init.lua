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

function OnPlayerSpawned(player_entity)
	local x, y = EntityGetTransform(player_entity)
	
end