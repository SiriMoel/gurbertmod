dofile_once("mods/gurbertmod/files/scripts/gurbert.lua")

local card = GetUpdatedEntityID()

local player = EntityGetWithTag("player_unit")[1]

if player ~= nil and EntityGetRootEntity(card) == player then
    local comp_controls = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")

    if ComponentGetValue2(comp_controls, "mButtonDownThrow") == true then
        local mouse_x, mouse_y = ComponentGetValue2(comp_controls, "mMousePosition") -- in world pos

        --local comp_gurbert_id = EntityGetFirstComponentIncludingDisabled(card, "VariableStorageComponent", "gurbert_id")
        --local gurbert = ComponentGetValue2(comp_gurbert_id, "value_int")
        local gurbert = EntityGetWithTag("gurbert")[1]

        if gurbert ~= nil and EntityGetIsAlive(gurbert) then
            local comp_selected_action = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "selected_action")

            local actions_unlocked = {}
            for i,v in ipairs(gurbert_actions) do
                if v.check_unlocked(gurbert) == true then
                    table.insert(actions_unlocked, v)
                end
            end

            if #actions_unlocked > 0 then
                local pos_x, pos_y = EntityGetTransform(player)

                local selected_action = ComponentGetValue2(comp_selected_action, "value_string")

                local frames = 1

                for i,v in ipairs(actions_unlocked) do
                    if v.draw_action_menu ~= nil then
                        local draw_x, draw_y = pos_x - (#actions_unlocked - 1) * 16 + (i - 1) * 32, pos_y + 30
                        v.draw_action_menu(gurbert, draw_x, draw_y, frames)

                        if v.id == selected_action then
                            GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/_selected.png", draw_x, draw_y, true, 0, 0, frames, 0)
                        end

                        if mouse_x > draw_x - 16 and mouse_x < draw_x + 16 and mouse_y > draw_y - 24 and mouse_y < draw_y + 24 then
                            GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/_hovered.png", draw_x, draw_y, true, 0, 0, frames, 0)

                            ComponentSetValue2(comp_selected_action, "value_string", v.id)
                        end

                        if v.check_available(gurbert) ~= true and not v.dont_draw_unavailable then
                            GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/_unavailable.png", draw_x, draw_y, true, 0, 0, frames, 0)
                        end
                    end
                end
            end
        end

    end
end