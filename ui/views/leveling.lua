local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Leveling view content
Deathless.UI.Views:Register("leveling", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Leveling (WIP)", "Leveling routes and quest guides")
    
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont("Fonts\\ARIALN.TTF", 12, "")
    content:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -12)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Find optimal leveling paths and quest recommendations for your hardcore journey.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end)

