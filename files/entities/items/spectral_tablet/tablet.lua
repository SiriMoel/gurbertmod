dofile_once("mods/gurbertmod/files/scripts/utils.lua")

-- stolen from kuu

local distance_full = 96
local float_range = 50
local float_force = 3
local float_sensor_sector = math.pi * 0.3

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( entity_id )

-- float by raycasting down and applying opposite physical force
do
	local dir_x = 0
	local dir_y = float_range
	dir_x, dir_y = vec_rotate(dir_x, dir_y, ProceduralRandomf(x, y + GameGetFrameNum(), -float_sensor_sector, float_sensor_sector))
	
	local did_hit,hit_x,hit_y = RaytracePlatforms( x, y, x + dir_x, y + dir_y )
	if did_hit then
		local dist = get_distance(x, y, hit_x, hit_y)
		dist = math.max(6, dist) -- tame a bit on close encounters
		dir_x = -dir_x / dist * float_force
		dir_y = -dir_y / dist * float_force
		PhysicsApplyForce(entity_id, dir_x, dir_y)
	end
end
