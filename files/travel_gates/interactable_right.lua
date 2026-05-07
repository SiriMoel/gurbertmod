dofile_once("mods/gurbertmod/files/scripts/utils.lua")

function interacting(entity_who_interacted, entity_interacted, interactable_name)
  
    local this = GetUpdatedEntityID()
    local x, y = EntityGetTransform(this)

    local gate = EntityGetParent(this)

    local comp_open = EntityGetFirstComponentIncludingDisabled(gate, "VariableStorageComponent", "frog_gate_open")

    if comp_open ~= nil then
        local open = ComponentGetValue2(comp_open, "value_bool")
        if open then
            ComponentSetValue2(comp_open, "value_bool", false)
            GamePrint("closed!")
        end
        GlobalsSetValue("gurbert_frog_gate_exit_id", tostring(gate))
    else
        GamePrint("couldnt find the component")
    end
    
    GamePrint("right interacted with")
end