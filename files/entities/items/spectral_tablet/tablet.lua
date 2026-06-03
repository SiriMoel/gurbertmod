dofile_once("mods/gurbertmod/files/scripts/utils.lua")

dofile("data/scripts/gun/gun.lua")

-- stolen from kuu

local distance_full = 96
local float_range = 50
local float_force = 3
local float_sensor_sector = math.pi * 0.3

local this = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( this )

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
		PhysicsApplyForce(this, dir_x, dir_y)
	end
end

-- no longer stolen from kuu

local targets = EntityGetInRadiusWithTag(x, y, 12, "gurbert_tablet") or {}
local valid_count = 0

if #targets > 0 then
	for i=1,#targets do
		local target = targets[i]
		if EntityGetRootEntity(target) == target then
			valid_count = valid_count + 1
		end
	end
end

if valid_count >= 2 then
	local comp_last_recall = EntityGetFirstComponentIncludingDisabled(this, "VariableStorageComponent", "gurbert_frame_last_recall") or 0
	if comp_last_recall ~= 0 then
		local frame_last = ComponentGetValue2(comp_last_recall, "value_int")
		local frame_now = GameGetFrameNum()
		if frame_now - frame_last > 45 then

			ComponentSetValue2(comp_last_recall, "value_int", frame_now)

			-- what do i want this to do?
		end
	end
end