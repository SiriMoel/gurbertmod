dofile_once("mods/gurbertmod/files/scripts/utils.lua")
--dofile_once("mods/gurbertmod/files/scripts/gurbert.lua")

local gurbert = GetUpdatedEntityID()

local pos_x, pos_y, rot, scale_x, scale_y = EntityGetTransform(gurbert)

local comp_vel = EntityGetFirstComponentIncludingDisabled(gurbert, "VelocityComponent")
if comp_vel ~= nil then
    local vel_x, vel_y = GameGetVelocityCompVelocity(gurbert) --ComponentGetValue2(comp_vel, "mVelocity")

    local player = EntityGetInRadiusWithTag(pos_x, pos_y, 250, "player_unit")[1]

    if player ~= nil then
        local player_x, player_y = EntityGetTransform(player)

        local dist_x, dist_y = pos_x - player_x, pos_y - player_y

        local dist = math.sqrt(dist_x ^ 2 + dist_y ^ 2) 

        local looking = math.atan(dist_y / dist_x)

        local max_angle = 3.14/12
        local clamped_looking = math.max(math.min(looking, max_angle), -max_angle)

        if dist_x > 0 then
            EntitySetTransform(gurbert, pos_x, pos_y, 3.14 + clamped_looking, scale_x, -1)
        else
            EntitySetTransform(gurbert, pos_x, pos_y, 0 + clamped_looking, scale_x, 1)
        end

        if math.abs(vel_x) + math.abs(vel_y) <= 1 and dist > 40 then            
            vel_x = math.min(math.abs(dist_x) + 4, 60) * (dist_x / math.abs(dist_x)) * -2
            vel_y = math.min(math.abs(dist_y) + 16, 130) * -3
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