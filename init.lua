dofile_once("mods/gurbertmod/files/scripts/utils.lua")
dofile_once("mods/gurbertmod/files/scripts/gurbert.lua")

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

	--EntityLoad("mods/gurbertmod/files/entities/items/frozen_gurbert/item.xml", x, y-20)
	
	local gurbert = GurbertCreate(x, y)
	GurbertSetStatus(gurbert, "warm", 2)
	GurbertSetStatus(gurbert, "temperate", 2)
	GurbertSetStatus(gurbert, "cold", 2)
	GurbertUpdate(gurbert)

	GlobalsSetValue("gurbert_frog_gate_exit_id", "-1")
end

function OnModPreInit()
	-- create gurbert sprites

	print("Creating Gurbert...")

	local cols = {
		"pale", 
		"pale_red", "red", 
		"pale_blue", "blue", 
		"grey", "white",
		"purple", "pink", "sky",
        "green",
	}

	local sprites = {
		{"mods/gurbertmod/files/entities/gurbert/sprites/frog_big.png", "frog_big", 192, 64},
		{"mods/gurbertmod/files/entities/gurbert/sprites/sprite_inhand.png", "sprite_inhand", 12, 12},
		{"mods/gurbertmod/files/entities/gurbert/sprites/sprite_ui.png", "sprite_ui", 16, 16},
	}

	for col_i,col_v in ipairs(cols) do
		local colt = ModImageMakeEditable("mods/gurbertmod/files/entities/gurbert/sprites/templates/" .. col_v .. ".png", 6, 2)
		for sprite_i, sprite_v in ipairs(sprites) do
			local template, w, h = ModImageMakeEditable(sprite_v[1], sprite_v[3], sprite_v[4])
			local image = ModImageMakeEditable("mods/gurbertmod/files/entities/gurbert/sprites/" .. col_v .. "/" .. sprite_v[2] .. ".png", w, h)
			for x=0,w-1 do
				for y=0,h-1 do
					local t_col = ModImageGetPixel(template, x, y)
					local c_col = t_col
					for c_x=0,4 do
						local ct_col = ModImageGetPixel(colt, c_x, 0)
						if t_col == ct_col then
							c_col = ModImageGetPixel(colt, c_x, 1)
							break
						end
					end
					ModImageSetPixel(image, x, y, c_col)
				end
			end
			if sprite_v[2] == "frog_big" then
				--local file = ModTextFileGetContent("mods/gurbertmod/files/entities/gurbert/sprites/" .. col_v .. "/frog_big.xml")
				local content = "<Sprite filename=\"mods/gurbertmod/files/entities/gurbert/sprites/" .. col_v .. "/frog_big.png\" offset_x=\"8\" offset_y=\"11\" default_animation=\"stand\" > <RectAnimation name=\"stand\" pos_x=\"0\" pos_y=\"0\" frame_count=\"6\" frame_width=\"16\" frame_height=\"16\" frame_wait=\"0.16\" frames_per_row=\"12\" loop=\"1\"   > </RectAnimation> <RectAnimation name=\"jump_up\" pos_x=\"0\" pos_y=\"16\" frame_count=\"1\" frame_width=\"16\" frame_height=\"16\" frame_wait=\"0.082\" frames_per_row=\"12\" loop=\"0\" > </RectAnimation> <RectAnimation name=\"jump_fall\" pos_x=\"0\" pos_y=\"32\" frame_count=\"1\" frame_width=\"16\" frame_height=\"16\" frame_wait=\"0.082\" frames_per_row=\"12\" loop=\"0\"   > </RectAnimation> <RectAnimation name=\"attack_ranged\" pos_x=\"0\" pos_y=\"48\" frame_count=\"12\" frame_width=\"16\" frame_height=\"16\" frame_wait=\"0.07\" frames_per_row=\"12\" loop=\"1\"   > </RectAnimation> </Sprite>"
				ModTextFileSetContent("mods/gurbertmod/files/entities/gurbert/sprites/" .. col_v .. "/frog_big.xml", tostring(content))
			end
		end
	end
end