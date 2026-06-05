function GurbertCreate(x, y)
    local gurbert = EntityLoad("mods/gurbertmod/files/entities/gurbert/gurbert.xml", x, y)
    
    local statuses = {
        "warm",
        "temperate",
        "cold",
    }

    for i=1,#statuses do
        EntityAddComponent2(gurbert, "VariableStorageComponent", {
            _tags = "gurbert_status_" .. statuses[i],
            name = "gurbert_status_" .. statuses[i],
            value_int = 0, -- 0 is inactive, 1 is in progress, 2 is complete
        })
    end

    EntityAddComponent2(gurbert, "VariableStorageComponent", {
        _tags = "gurbert_colour",
        name = "gurbert_colour",
        value_string = "pale",
    })

    return gurbert
end

function GurbertGetStatus(gurbert, status)
    local comp_status = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "gurbert_status_" .. status)
    if comp_status ~= nil then
        return ComponentGetValue2(comp_status, "value_int")
    end
    return 0
end

function GurbertSetStatus(gurbert, status, num)
    local comp_status = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "gurbert_status_" .. status)
    if comp_status ~= nil then
        ComponentSetValue2(comp_status, "value_int", num)
    end

    --GurbertUpdate(gurbert)
end

function GurbertUpdate(gurbert)
    local num_warm = GurbertGetStatus(gurbert, "warm")
    local num_temperate = GurbertGetStatus(gurbert, "temperate")
    local num_cold = GurbertGetStatus(gurbert, "cold")

    local cols = {
        {"pale", {
            {0, 0, 0},
        }, "Pale"},

        {"pale_red", {
            {1, 0, 0}, {1, 2, 0}, {1, 0, 2}, {1, 2, 2},
        }, "Pale Red"},
        {"red", {
            {2, 0, 0},
        }, "Red"},

        {"pale_blue", {
            {0, 1, 0}, {2, 1, 0}, {0, 1, 2}, {2, 1, 2},
        }, "Pale Blue"},
        {"blue", {
            {0, 2, 0},
        }, "Blue"},

        {"grey", {
            {0, 0, 1}, {2, 0, 1}, {0, 2, 1}, {2, 2, 1},
        }, "grey"},
        {"white", {
            {0, 0, 2},
        }, "White"},

        {"purple", {
            {2, 2, 0},
        }, "Purple"},
        {"pink", {
            {2, 0, 2},
        }, "Pink"},
        {"sky", {
            {0, 2, 2},
        }, "Sky"},

        {"green", {
            {2, 2, 2}, -- 222
        }, "Green"},
    }

    local status_nums = {num_warm, num_temperate, num_cold}

    local col_text = "pale"
    local name = "Confused"

    for _,v in ipairs(cols) do
        for _,c in ipairs(v[2]) do
            if c[1] == status_nums[1] and c[2] == status_nums[2] and c[3] == status_nums[3] then
                col_text, name = v[1], v[3]
                break
            end
        end
    end

    if col_text == "grey" or col_text == "white" or col_text == "green" then
        name = "Gurbert the " .. name
    else
        name = name .. " Gurbert"
    end

    EntitySetName(gurbert, name)

    local comp_col = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "gurbert_colour")
    if comp_col ~= nil then
        ComponentSetValue2(comp_col, "value_string", col_text)
    end

    local comp_ui_info = EntityGetFirstComponentIncludingDisabled(gurbert, "UIInfoComponent")
    if comp_ui_info ~= nil then
        ComponentSetValue2(comp_ui_info, "name", name)
    end

    local comp_item = EntityGetFirstComponentIncludingDisabled(gurbert, "ItemComponent")
    if comp_item ~= nil then
        ComponentSetValue2(comp_item, "item_name", name)
        ComponentSetValue2(comp_item, "ui_sprite", "mods/gurbertmod/files/entities/gurbert/sprites/" .. col_text .. "/sprite_ui.png")
        ComponentSetValue2(comp_item, "ui_description", "NYI")
    end

    local comp_ability = EntityGetFirstComponentIncludingDisabled(gurbert, "AbilityComponent")
    if comp_ability ~= nil then
        ComponentSetValue2(comp_ability, "ui_name", name)
    end

    local comp_sprite_inhand = EntityGetFirstComponentIncludingDisabled(gurbert, "SpriteComponent", "enabled_in_hand")
    if comp_sprite_inhand ~= nil then
        ComponentSetValue2(comp_sprite_inhand, "image_file", "mods/gurbertmod/files/entities/gurbert/sprites/" .. col_text .. "/sprite_inhand.png")
        EntityRefreshSprite(gurbert, comp_sprite_inhand)
    end

    local comp_sprite_frog_big = EntityGetFirstComponentIncludingDisabled(gurbert, "SpriteComponent", "frog_big")
    if comp_sprite_frog_big ~= nil then
        ComponentSetValue2(comp_sprite_frog_big, "image_file", "mods/gurbertmod/files/entities/gurbert/sprites/" .. col_text .. "/frog_big.xml")
        EntityRefreshSprite(gurbert, comp_sprite_frog_big)
    end
end

function GurbertCheckCompletion(gurbert) -- when would this be called? in a script on gurbert?
    local x, y = EntityGetTransform(gurbert)
    
    local num_warm = GurbertGetStatus(gurbert, "warm")
    local num_temperate = GurbertGetStatus(gurbert, "temperate")
    local num_cold = GurbertGetStatus(gurbert, "cold")

    -- check to see if completion conditions are fulfilled

    local change = false

    if num_warm == 1 then
        if false then
            num_warm = 2
            GurbertSetStatus(gurbert, "warm", 2)
            change = true
            -- warm fx
        end
    end
    
    if num_temperate == 1 then
        if false then
            num_temperate = 2
            GurbertSetStatus(gurbert, "temperate", 2)
            change = true
            -- temperate fx
        end
    end

    if num_cold == 1 then
        if false then
            num_cold = 2
            GurbertSetStatus(gurbert, "cold", 2)
            change = true
            -- cold fx
        end
    end

    local climate_nums = {num_warm, num_temperate, num_cold}

    local num_complete = 0
    for i=1,#climate_nums do
        if climate_nums[i] == 2 then
            num_complete = num_complete + 1
        end
    end

    -- update gurbert & award

    if change == true then

        if num_complete == 1 then
            GamePrintImportant("title", "description", "mods/gurbertmod/files/ui_gfx/gurbert_decoration.png")

            CreateItemActionEntity("GURBERT_SPECTRALISE_TABLETS", x - 16, y - 6)
            CreateItemActionEntity("GURBERT_CURE_TABLETS", x + 16, y - 6)

            -- fx
        end

        if num_complete == 2 then
            -- idk
        end

        if num_complete == 3 then
            -- idk
        end

        GurbertUpdate(gurbert)
    end
end