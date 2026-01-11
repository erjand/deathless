local Deathless = Deathless

Deathless.UI.Components = Deathless.UI.Components or {}
Deathless.UI.Components.Text = {}

function Deathless.UI.Components.Text:Create(parent, text, size)
    local Fonts = Deathless.UI.Fonts
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(Fonts.family, size or Fonts.subtitle)
    fs:SetText(text or "")
    return fs
end

