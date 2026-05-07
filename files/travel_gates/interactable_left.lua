dofile_once("mods/gurbertmod/files/scripts/utils.lua")

function interacting(entity_who_interacted, entity_interacted, interactable_name)
  
    local this = GetUpdatedEntityID()
    local x, y = EntityGetTransform(this)

    local gate = EntityGetParent(this)

    local comp_open = EntityGetFirstComponentIncludingDisabled(gate, "VariableStorageComponent", "frog_gate_open")

    local exit_id = tonumber(GlobalsGetValue("gurbert_frog_gate_exit_id", "-1"))

    if comp_open ~= nil then
        if exit_id ~= -1 then
            if exit_id ~= gate then
                local open = ComponentGetValue2(comp_open, "value_bool")
                if not open then
                    -- cost?
                    ComponentSetValue2(comp_open, "value_bool", true)
                    GamePrint("opened!")
                end
            else
                GamePrint("this is the exit")
            end
        else
            GamePrint("there is no exit")
        end
    else
        GamePrint("couldnt find the component")
    end
    
    GamePrint("left interacted with")
end