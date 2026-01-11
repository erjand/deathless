local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Support view content
Deathless.UI.Views:Register("support", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Support", "Help support addon development")
    
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
    content:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -12)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("If you find Deathless helpful in your hardcore journey, please consider supporting its continued development. Your support helps keep the addon updated and adds new features!")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end)

