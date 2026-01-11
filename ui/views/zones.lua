local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Zones view content
Deathless.UI.Views:Register("zones", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Zones (WIP)", "Zone guides and danger warnings")
    
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont(Fonts.family, Fonts.subtitle, "")
    content:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -12)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Browse zones by level range to find safe leveling paths and avoid dangerous areas.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end)

