local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.String = {}

-- Capitalize first letter
function Deathless.Utils.String.Capitalize(str)
    return str:gsub("^%l", string.upper)
end

-- Trim whitespace
function Deathless.Utils.String.Trim(str)
    return str:match("^%s*(.-)%s*$")
end

