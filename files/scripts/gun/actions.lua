dofile_once("mods/gurbertmod/files/scripts/utils.lua")

local new_actions = {
	{
		id          = "REMEMBER",
		name 		= "remember",
		description = "remember desc",
		sprite 		= "mods/gurbertmod/files/ui_gfx/gun_actions/remember.png",
		--sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		--spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,5,6,10",
		spawn_probability                 = "0.2,0.3,0.2,1",
		price = 200,
		mana = 35,
		action = function()

			--if reflecting then return end

			--print("hand: " .. #hand)
			if #deck > 0 then

				gurbertbrain = {}

				local how_many = 0

				for i,v in ipairs(deck) do

					if --[[v.id == "GURBERT_RECALL" or]] v.type == ACTION_TYPE_OTHER then
						break
					elseif v.from_gurbertbrain ~= true then
						--print(v.id or "couldn't find action id :(")
						how_many = how_many + 1
						table.insert(gurbertbrain, v)
					end
				end

				local str = "brain: "
				for i=1,#gurbertbrain do
					str = str .. gurbertbrain[i].id .. " "
				end
				GamePrint(str)

				for i=1,how_many do
					local data = deck[1]
					table.insert(discarded, data)
					table.remove(deck, 1)
				end

				draw_actions(1, false)
			end

		end,
	},
	{
		id          = "RECALL",
		name 		= "recall",
		description = "recall desc",
		sprite 		= "mods/gurbertmod/files/ui_gfx/gun_actions/recall.png",
		--sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		--spawn_requires_flag = "card_unlocked_musicbox",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "3,5,6,10",
		spawn_probability                 = "0.2,0.3,0.2,1",
		price = 200,
		mana = 35,
		action = function()

			--if reflecting then return end

			--print("brain: " .. #gurbertbrain)

			if #gurbertbrain > 0 then

				local str = "recalled: "

				for i,v in ipairs(gurbertbrain) do
					--print(v.id or "couldn't find action id :(")
					v.from_gurbertbrain = true
					str = str .. v.id .. " "
					table.insert(hand, v)
				end

				GamePrint(str)

				local hand_str = "hand: "
				for i=1,#hand do
					hand_str = hand_str .. hand[i].id .. " "
				end
				GamePrint(hand_str)

				draw_actions(#hand, true)
				
				--gurbertbrain = {}
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