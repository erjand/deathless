local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Dungeons view content
Deathless.UI.Views:Register("dungeons", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Dungeons (WIP)", "Dungeon guides and strategies")
    
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont("Fonts\\ARIALN.TTF", 12, "")
    content:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -12)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Browse dungeons by level range to find safe group content and preparation tips.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end)

