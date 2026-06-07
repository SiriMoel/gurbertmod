gurbert_actions = {
    {
        id = "gate_tele",
        name = "Teleport to Frog Gate",
        desc = "",
        setup = function(gurbert) 
            EntityAddComponent2(gurbert, "VariableStorageComponent", {
                _tags = "action_gate_tele_frame_last_used",
                name = "action_gate_tele_frame_last_used",
                value_int = 0,
            })
        end,
        check_unlocked = function(gurbert) 
            return true
        end,
        check_available = function(gurbert, respond)
            respond = respond or false
            local cooldown = GetFPS() * 10
            local comp_frame_last_used = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "action_gate_tele_frame_last_used")
            if comp_frame_last_used ~= nil then
                local frame_last_used = ComponentGetValue2(comp_frame_last_used, "value_int")
                local frame_now = GameGetFrameNum()
                if frame_now > frame_last_used + cooldown then
                    return true
                elseif respond then
                    GamePrint("On cooldown...")
                end
            end
            return false
        end,
        dont_draw_unavailable = true,
        draw_action_menu = function(gurbert, x, y, frames)
            GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/gate_tele.png", x, y, true, 0, 0, frames, 0)
            local cooldown = GetFPS() * 10
            local comp_frame_last_used = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "action_gate_tele_frame_last_used")
            if comp_frame_last_used ~= nil then
                local frame_last_used = ComponentGetValue2(comp_frame_last_used, "value_int")
                local frame_now = GameGetFrameNum()
                if frame_now < frame_last_used + cooldown then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/_unavailable.png", x, y, true, 0, 0, frames, 0)
                end
                if frame_now > frame_last_used + cooldown then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/100.png", x, y, true, 0, 0, frames, 0)
                elseif frame_now > frame_last_used + cooldown * 0.8 then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/80.png", x, y, true, 0, 0, frames, 0)
                elseif frame_now > frame_last_used + cooldown * 0.6 then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/60.png", x, y, true, 0, 0, frames, 0)
                elseif frame_now > frame_last_used + cooldown * 0.4 then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/40.png", x, y, true, 0, 0, frames, 0)
                elseif frame_now > frame_last_used + cooldown * 0.2 then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/20.png", x, y, true, 0, 0, frames, 0)
                else
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/0.png", x, y, true, 0, 0, frames, 0)
                end
            end
        end,
        action = function(gurbert) 
            local comp_frame_last_used = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "action_gate_tele_frame_last_used")
            if comp_frame_last_used ~= nil then
                local frame_now = GameGetFrameNum()
                ComponentSetValue2(comp_frame_last_used, "value_int", frame_now)
            end
            local exit_id = GetFrogGateExit() --tonumber(GlobalsGetValue("gurbert_frog_gate_exit_id", "-1"))
            if exit_id ~= -1 and EntityGetIsAlive(exit_id) then
                local exit_x, exit_y = EntityGetTransform(exit_id)
                exit_y = exit_y - 50
                local x, y = EntityGetTransform(gurbert)
                local entity_portal = EntityLoad("mods/gurbertmod/files/entities/misc/gurbert_action_portal.xml", x, y-44)
                local comp_tele = EntityGetFirstComponentIncludingDisabled(entity_portal, "TeleportComponent")
                if comp_tele ~= nil then
                    ComponentSetValue2(comp_tele, "target", exit_x, exit_y)
                end
                GamePrintImportant("Portal!", "Gurbert!", "mods/gurbertmod/files/ui_gfx/gurbert_decoration.png")
                GamePlayAnimation(gurbert, "attack", 11)
            else
                GamePrintImportant("No exit?", "Gurbert couldn't find an active exit :(", "mods/gurbertmod/files/ui_gfx/gurbert_decoration.png")
            end
        end,
    },
    {
        id = "attack",
        name = "Attack",
        desc = "",
        setup = function(gurbert) 
            EntityAddComponent2(gurbert, "VariableStorageComponent", {
                _tags = "action_attack_frame_last_used",
                name = "action_attack_frame_last_used",
                value_int = 0,
            })
            EntityAddComponent2(gurbert, "VariableStorageComponent", {
                _tags = "action_attack_enabled",
                name = "action_attack_enabled",
                value_bool = false,
            })
        end,
        check_unlocked = function(gurbert)
            if GurbertGetStatus(gurbert, "warm") == 2 then
                return true
            end
            return false
        end,
        check_available = function(gurbert)
            local cooldown = GetFPS() * (6 - GurbertGetCompletionNumber(gurbert) / 2)
            local comp_frame_last_used = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "action_attack_frame_last_used")
            if comp_frame_last_used ~= nil then
                local frame_last_used = ComponentGetValue2(comp_frame_last_used, "value_int")
                local frame_now = GameGetFrameNum()
                if frame_now > frame_last_used + cooldown then
                    return true
                end
            end
            return false
        end,
        dont_draw_unavailable = true,
        draw_action_menu = function(gurbert, x, y, frames)
            GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/attack.png", x, y, true, 0, 0, frames, 0)
            local comp_enabled = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "action_attack_enabled")
            if comp_enabled ~= nil then
                local is_enabled = ComponentGetValue2(comp_enabled, "value_bool")
                if is_enabled then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/attack_enabled.png", x, y, true, 0, 0, frames, 0)
                else
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/attack_disabled.png", x, y, true, 0, 0, frames, 0)
                end
            end
            local cooldown = GetFPS() * (6 - GurbertGetCompletionNumber(gurbert) / 2)
            local comp_frame_last_used = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "action_attack_frame_last_used")
            if comp_frame_last_used ~= nil then
                local frame_last_used = ComponentGetValue2(comp_frame_last_used, "value_int")
                local frame_now = GameGetFrameNum()
                --[[if frame_now < frame_last_used + cooldown then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/_unavailable.png", x, y, true, 0, 0, frames, 0)
                end]]
                if frame_now > frame_last_used + cooldown then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/100.png", x, y, true, 0, 0, frames, 0)
                elseif frame_now > frame_last_used + cooldown * 0.8 then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/80.png", x, y, true, 0, 0, frames, 0)
                elseif frame_now > frame_last_used + cooldown * 0.6 then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/60.png", x, y, true, 0, 0, frames, 0)
                elseif frame_now > frame_last_used + cooldown * 0.4 then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/40.png", x, y, true, 0, 0, frames, 0)
                elseif frame_now > frame_last_used + cooldown * 0.2 then
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/20.png", x, y, true, 0, 0, frames, 0)
                else
                    GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/cooldowns/0.png", x, y, true, 0, 0, frames, 0)
                end
            end
        end,
        always_useable = true,
        action = function(gurbert)
            local comp_enabled = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "action_attack_enabled")
            if comp_enabled ~= nil then
                local is_enabled = ComponentGetValue2(comp_enabled, "value_bool")
                if is_enabled then
                    GamePrint("Gurbert will not attack.")
                else
                    GamePrint("Gurbert will attack!")
                end
                ComponentSetValue2(comp_enabled, "value_bool", not is_enabled)
            end
        end,
    },
    --[[{
        id = "seek",
        name = "Seek",
        desc = "",
        setup = function(gurbert) 
            EntityAddComponent2(gurbert, "VariableStorageComponent", {
                _tags = "action_seek_frame_last_used",
                name = "action_seek_frame_last_used",
                value_int = 0,
            })
        end,
        check_unlocked = function(gurbert)
            if GurbertGetStatus(gurbert, "temperate") == 2 then
                return true
            end
            return false
        end,
        check_available = function(gurbert) 
            return false
        end,
        draw_action_menu = function(gurbert, x, y, frames)
            GameCreateSpriteForXFrames("mods/gurbertmod/files/ui_gfx/gurbert_actions/seek.png", x, y, true, 0, 0, frames, 0)
        end,
        action = function(gurbert) 
        
        end,
    },]]
}