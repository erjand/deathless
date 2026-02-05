local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

local CLASS_COLOR = { 0.96, 0.55, 0.73 } -- Paladin pink

Deathless.UI.Views:Register("paladin_talents", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local title, subtitle = Utils:CreateHeader(container, "Paladin Talents", "Recommended builds for Hardcore leveling", CLASS_COLOR)
    
    local message = container:CreateFontString(nil, "OVERLAY")
    message:SetFont(Fonts.family, Fonts.subtitle, "")
    message:SetPoint("CENTER", container, "CENTER", 0, 0)
    message:SetText("Paladin talents coming soon.")
    message:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    return { title = title, subtitle = subtitle }
end)
