dofile_once("mods/gurbertmod/files/scripts/utils.lua")
dofile_once("mods/gurbertmod/files/scripts/gurbert.lua")

local gurbert = GetUpdatedEntityID()

local pos_x, pos_y, rot, scale_x, scale_y = EntityGetTransform(gurbert)

local comp_vel = EntityGetFirstComponentIncludingDisabled(gurbert, "VelocityComponent")
if comp_vel ~= nil then
    local vel_x, vel_y = GameGetVelocityCompVelocity(gurbert) --ComponentGetValue2(comp_vel, "mVelocity")

    local player = EntityGetInRadiusWithTag(pos_x, pos_y, 300, "player_unit")[1]

    if player ~= nil then
        local player_x, player_y = EntityGetTransform(player)

        local dist_x, dist_y = pos_x - player_x, pos_y - player_y

        local dist = math.sqrt(dist_x ^ 2 + dist_y ^ 2) 

        local looking = math.atan(dist_y / dist_x)

        local max_angle = 3.14/16
        local clamped_looking = math.max(math.min(looking, max_angle), -max_angle)

        if dist_x > 0 then
            EntitySetTransform(gurbert, pos_x, pos_y, 3.14 + clamped_looking, scale_x, -1)
        else
            EntitySetTransform(gurbert, pos_x, pos_y, 0 + clamped_looking, scale_x, 1)
        end

        if math.abs(vel_x) + math.abs(vel_y) <= 1 and dist > 40 then            
            vel_x = math.min(math.abs(dist_x) + 4, 60) * (dist_x / math.abs(dist_x)) * -2
            vel_y = math.min(math.abs(dist_y) + 16, 170) * -3
        end

        if math.abs(vel_y) > 5 then
            if vel_y > 0 then
                GamePlayAnimation(gurbert, "jump_fall", 10)
            else
                GamePlayAnimation(gurbert, "jump_up", 10)
            end
        else
            GamePlayAnimation(gurbert, "stand", 10)
        end
    end

    ComponentSetValue2(comp_vel, "mVelocity", vel_x, vel_y)
end

local comp_attack_enabled = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "action_attack_enabled")
if comp_attack_enabled ~= nil then
    local attacking_enabled = ComponentGetValue2(comp_attack_enabled, "value_bool")
    if attacking_enabled then
        local comp_frame_last_attack = EntityGetFirstComponentIncludingDisabled(gurbert, "VariableStorageComponent", "action_attack_frame_last_used")
        if comp_frame_last_attack ~= nil then
            local attack_available = false
            for i,v in ipairs(gurbert_actions) do
                if v.id == "attack" then
                    if v.check_available(gurbert) == true then
                        attack_available = true
                    end
                    break
                end
            end
            if attack_available then
                local targets = EntityGetInRadiusWithTag(pos_x, pos_y, 90, "homing_target")
                if #targets > 0 then
                    GamePrint("Pow! Found " .. #targets .. " targets.")
                    ComponentSetValue2(comp_frame_last_attack, "value_int", GameGetFrameNum())
                    GamePlayAnimation(gurbert, "attack", 11)
                end
            end
        end
    end
end