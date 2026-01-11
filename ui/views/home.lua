local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Home view content
Deathless.UI.Views:Register("home", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local title, subtitle = Utils:CreateCenteredHeader(container, "Deathless", "Hardcore Classic WoW Companion")
    
    -- Description
    local desc = container:CreateFontString(nil, "OVERLAY")
    desc:SetFont(Fonts.family, Fonts.subtitle, "")
    desc:SetPoint("TOP", subtitle, "BOTTOM", 0, -24)
    desc:SetWidth(container:GetWidth() - 60)
    desc:SetJustifyH("CENTER")
    desc:SetText("Select a content area from the left to get started.")
    desc:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, desc = desc }
end)

