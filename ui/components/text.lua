local Deathless = Deathless

Deathless.UI.Components = Deathless.UI.Components or {}
Deathless.UI.Components.Text = {}

function Deathless.UI.Components.Text:Create(parent, text, size)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont("Fonts\\FRIZQT__.TTF", size or 12)
    fs:SetText(text or "")
    return fs
end

