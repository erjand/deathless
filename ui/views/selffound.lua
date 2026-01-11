local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Self-Found view content
Deathless.UI.Views:Register("selffound", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Self-Found (WIP)", "Self-found mode information and guides")
    
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
    content:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -12)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Learn about self-found rules and strategies for playing without trading or auction house.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end)

