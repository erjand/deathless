local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Options view content
Deathless.UI.Views:Register("options", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Options", "Addon settings and preferences")
    
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont("Fonts\\ARIALN.TTF", 12, "")
    content:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -12)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Configure Deathless addon settings here.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end)

