local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.Table = {}

-- Deep copy
function Deathless.Utils.Table.DeepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = Deathless.Utils.Table.DeepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

-- Merge tables
function Deathless.Utils.Table.Merge(target, source)
    for key, value in pairs(source) do
        if type(value) == "table" and type(target[key]) == "table" then
            Deathless.Utils.Table.Merge(target[key], value)
        else
            target[key] = value
        end
    end
    return target
end

