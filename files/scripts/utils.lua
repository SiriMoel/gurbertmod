dofile_once("data/scripts/lib/utilities.lua")

function flipbool(boolean) -- the AMDG of a moldos creation
    return not boolean
end

function table.contains(t, e)
    if #t > 0 then
        for i,v in ipairs(t) do
            if v == e then
                return true
            end
        end
    else
        for k,v in pairs(t) do
            if v == e then
                return true
            end
        end
    end
    return false
end