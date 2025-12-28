local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Zones view content
Deathless.UI.Views:Register("zones", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle = Utils:CreateHeader(container, "Zones", "Zone guides and danger warnings")
    
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont("Fonts\\ARIALN.TTF", 12, "")
    content:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -20)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Browse zones by level range to find safe leveling paths and avoid dangerous areas.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end)

