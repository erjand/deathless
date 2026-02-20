local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

-- Command definitions with descriptions
local COMMANDS = {
    { command = "/deathless", alias = "/dls", description = "Toggle the main Deathless window" },
    { command = "/deathless class", alias = "/dls c", description = "Open the Class view" },
    { command = "/deathless dungeons", alias = "/dls d", description = "Open the Dungeons view" },
    { command = "/deathless mini", alias = "/dls m", description = "Toggle the mini summary overlay" },
    { command = "/deathless options", alias = "/dls o", description = "Open the Options view" },
    
}

--- Commands view content
Deathless.UI.Views:Register("commands", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Commands", "Available slash commands")
    
    -- Create command list
    local yOffset = -80
    
    for _, cmd in ipairs(COMMANDS) do
        -- Command text
        local cmdText = container:CreateFontString(nil, "OVERLAY")
        cmdText:SetFont(Fonts.family, Fonts.subtitle, "")
        cmdText:SetPoint("TOPLEFT", container, "TOPLEFT", 20, yOffset)
        cmdText:SetText(cmd.command)
        cmdText:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
        
        -- Alias text (if exists)
        if cmd.alias then
            local aliasText = container:CreateFontString(nil, "OVERLAY")
            aliasText:SetFont(Fonts.family, Fonts.body, "")
            aliasText:SetPoint("LEFT", cmdText, "RIGHT", 8, 0)
            aliasText:SetText("(" .. cmd.alias .. ")")
            aliasText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        end
        
        -- Description
        local descText = container:CreateFontString(nil, "OVERLAY")
        descText:SetFont(Fonts.family, Fonts.body, "")
        descText:SetPoint("TOPLEFT", cmdText, "BOTTOMLEFT", 0, -4)
        descText:SetText(cmd.description)
        descText:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        
        yOffset = yOffset - 48
    end
    
    return { title = title, subtitle = subtitle }
end)
