dofile_once("mods/gurbertmod/files/scripts/utils.lua")

local gate = GetUpdatedEntityID()

local exit_id = tonumber(GlobalsGetValue("gurbert_frog_gate_exit_id", "-1"))

if exit_id ~= -1 then
    local exit_x, exit_y = EntityGetTransform(exit_id)
    exit_y = exit_y - 50
    local comp_open = EntityGetFirstComponentIncludingDisabled(gate, "VariableStorageComponent", "frog_gate_open")
    if comp_open ~= nil then
        local open = ComponentGetValue2(comp_open, "value_bool")
        local portal = EntityGetAllChildren(gate, "frog_gate_portal")[1] or nil
        if open == true then
            if portal == nil then
                local x, y = EntityGetTransform(gate)
                local entity_portal = EntityLoad("mods/gurbertmod/files/travel_gates/portal.xml", x, y-50)
                local comp_tele = EntityGetFirstComponentIncludingDisabled(entity_portal, "TeleportComponent")
                if comp_tele ~= nil then
                    ComponentSetValue2(comp_tele, "target", exit_x, exit_y)
                end
                EntityAddChild(gate, entity_portal)
            else
                local comp_tele = EntityGetFirstComponentIncludingDisabled(portal, "TeleportComponent")
                if comp_tele ~= nil then
                    ComponentSetValue2(comp_tele, "target", exit_x, exit_y)
                end
            end
        else
            if portal ~= nil then
                EntityKill(portal)
            end
        end
    end
end

local pos_x, pos_y = EntityGetTransform(gate)
local targets = EntityGetInRadiusWithTag(pos_x, pos_y, 60, "gurbert_item_first")
if #targets > 0 then
    local comp_type = EntityGetFirstComponentIncludingDisabled(gate, VariableStorageComponent, "frog_gate_type")
    if comp_type ~= nil then
        local gate_type = ComponentGetValue2(comp_type, "value_string")

        local t_x, t_y = EntityGetTransform(targets[1])

        -- create gurbert
        local gurbert = GurbertCreate(t_x, t_y)

        local gate_types = {
            ["meat"] = "warm",
            ["fun"] = "temperate",
            ["snow"] = "cold",
        }
        
        GurbertSetStatus(gurbert, gate_types[gate_type], 1)
        GurbertUpdate(gurbert)

        EntityKill(targets[1])
    end
end