dofile_once("mods/gurbertmod/files/scripts/utils.lua")

local new_actions = {
	{
		id          = "REMEMBER",
		name 		= "$action_gurbert_remember",
		description = "$actiondesc_gurbert_remember",
		sprite 		= "mods/gurbertmod/files/ui_gfx/gun_actions/remember.png",
		--sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		--spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,5,6,10",
		spawn_probability                 = "0.2,0.3,0.2,1",
		price = 200,
		mana = 10,
		action = function()

			local data = {}
			
			local how_many = 1
			
			if #deck > 0 then
				data = deck[1]
			else
				data = nil
			end

			if data ~= nil then
				gurbertbrain = {}

				while (#deck >= how_many) and ((data.type == ACTION_TYPE_PROJECTILE) or (data.type == ACTION_TYPE_MODIFIER) or (data.type == ACTION_TYPE_STATIC_PROJECTILE) --[[or (data.type == ACTION_TYPE_DRAW_MANY)]] or (data.type == ACTION_TYPE_OTHER)) do
					table.insert(gurbertbrain, data)
					how_many = how_many + 1
					data = deck[how_many]
				end

				for i=1,how_many do
					data = deck[1]
					table.insert(discarded, data)
					table.remove(deck, 1)
				end
			end
		end,
	},
	{
		id          = "RECALL",
		name 		= "$action_gurbert_recall",
		description = "$actiondesc_gurbert_recall",
		sprite 		= "mods/gurbertmod/files/ui_gfx/gun_actions/recall.png",
		--sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		--spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		recursive = true,
		spawn_level                       = "3,5,6,10",
		spawn_probability                 = "0.2,0.3,0.2,1",
		price = 200,
		mana = 70,
		action = function(recursion_level, iteration)

			local data = {}

			local how_many = 1

			if #gurbertbrain > 0 then
				data = gurbertbrain[1]
			else
				data = nil
			end

			if data ~= nil then
				while (#gurbertbrain >= how_many) do
					--dont_draw_actions = true

					local rec = check_recursion(data, recursion_level)
					if rec > -1 then
						data.action(rec)
					end

					--dont_draw_actions = false

					how_many = how_many + 1
					data = gurbertbrain[how_many]
				end
			else
				GamePrint("No thoughts.")
			end

		end,
	},
}

--[[local actions_to_insert = {}

local action_ids_in_order = {
    "REMEMBER",
	"RECALL",
}

for i,id in ipairs(action_ids_in_order) do
	for ii=1,#new_actions do
		local action = new_actions[ii]
		if action.id == id then
			table.insert(actions_to_insert, action)
		end
	end
end]]

for i,action in ipairs(new_actions) do
	action.id = "GURBERT_" .. action.id
	table.insert(actions, action)
end