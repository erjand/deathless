local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

-- Command definitions with descriptions. Keep sorted alphabetically.
local COMMANDS = {
    { command = "/deathless", alias = "/dls", description = "Toggle the main Deathless window" },
    { command = "/deathless help", alias = "/dls h", description = "Print all available commands to chat" },
    { divider = true },
    { command = "/deathless abilities", alias = "/dls a", description = "Open your class Abilities tab" },
    { command = "/deathless class", alias = "/dls c", description = "Open the class view" },
    { command = "/deathless dungeons", alias = "/dls d", description = "Open the Dungeons view" },
    { command = "/deathless gear", alias = "/dls g", description = "Open your class Gear tab" },
    { command = "/deathless mini", alias = "/dls m", description = "Toggle the mini summary overlay" },
    { command = "/deathless options", alias = "/dls o", description = "Open the Options view" },
    { command = "/deathless stats", alias = "/dls s", description = "Open your class Stats tab" },
    { command = "/deathless talents", alias = "/dls t", description = "Open your class Talents tab" },
    
}

--- Commands view content
Deathless.UI.Views:Register("commands", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Commands", "Available chat commands")
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, -60, 24)
    
    -- Create command list
    local yOffset = -16
    
    for _, cmd in ipairs(COMMANDS) do
        if cmd.divider then
            local line = scrollChild:CreateTexture(nil, "ARTWORK")
            line:SetHeight(1)
            line:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset + 8)
            line:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -12, yOffset + 8)
            line:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
            yOffset = yOffset - 14
        else
            -- Command text
            local cmdText = scrollChild:CreateFontString(nil, "OVERLAY")
            cmdText:SetFont(Fonts.family, Fonts.subtitle, "")
            cmdText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
            cmdText:SetText(cmd.command)
            cmdText:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
            
            -- Alias text (if exists)
            if cmd.alias then
                local aliasText = scrollChild:CreateFontString(nil, "OVERLAY")
                aliasText:SetFont(Fonts.family, Fonts.body, "")
                aliasText:SetPoint("LEFT", cmdText, "RIGHT", 8, 0)
                aliasText:SetText("(" .. cmd.alias .. ")")
                aliasText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            end
            
            -- Description
            local descText = scrollChild:CreateFontString(nil, "OVERLAY")
            descText:SetFont(Fonts.family, Fonts.body, "")
            descText:SetPoint("TOPLEFT", cmdText, "BOTTOMLEFT", 0, -4)
            descText:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
            descText:SetJustifyH("LEFT")
            descText:SetText(cmd.description)
            descText:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            
            yOffset = yOffset - 48
        end
    end

    scrollChild:SetHeight(math.abs(yOffset) + 10)
    C_Timer.After(0, function()
        if scrollFrame.UpdateScrollbar then
            scrollFrame.UpdateScrollbar()
        end
    end)
    
    return { title = title, subtitle = subtitle }
end)
