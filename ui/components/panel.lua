local Deathless = Deathless

Deathless.UI.Components = Deathless.UI.Components or {}
Deathless.UI.Components.Panel = {}

function Deathless.UI.Components.Panel:Create(name, parent)
    local panel = CreateFrame("Frame", name, parent)
    -- Panel setup
    return panel
end

