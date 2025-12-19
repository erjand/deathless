local Deathless = Deathless

Deathless.UI.Components = Deathless.UI.Components or {}
Deathless.UI.Components.Button = {}

function Deathless.UI.Components.Button:Create(name, parent, text)
    local button = CreateFrame("Button", name, parent)
    -- Button setup
    return button
end

