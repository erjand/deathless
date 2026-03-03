local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

local function ColorizeText(color, text)
    local r = math.floor((color[1] or 1) * 255 + 0.5)
    local g = math.floor((color[2] or 1) * 255 + 0.5)
    local b = math.floor((color[3] or 1) * 255 + 0.5)
    return string.format("|cff%02x%02x%02x%s|r", r, g, b, text)
end

-- Useful HC macros. Keep sorted alphabetically by title.
local MACROS = {
    {
        title = "Flask of Petrification: Log Out",
        description = "This is the standard Petri macro. It uses a Flask of Petrification, and then immediately logs out (20 second timer).",
        code = "#showtooltip Flask of Petrification\n/use Flask of Petrification\n/camp",
    },
    {
        title = "Flask of Petrification: Re-apply",
        description = "Cancel your current Flask of Petrification and immediately apply a new one. Useful if you Petri before the Leave Party timer has started.\n\nNote: Spamming this macro will continue to consume Flasks!",
        code = "#showtooltip Flask of Petrification\n/cancelaura Flask of Petrification\n/use Flask of Petrification",
    },
    {
        title = "Leave Group",
        description = "Immediately drop your current group (also works solo) in order to start the 60-second instance kick timer.",
        code = '/run InviteUnit("StayDeathless");C_Timer.After(1,function() LeaveParty() end)',
    },
    {
        title = "Light of Elune",
        description = "Uses your Light of Elune (Alliance only), and then immediately casts Hearthstone.\n\nNote: There will be a small gap between when LoE wears off and Hearthstone is cast, since both have a 10s timer.",
        code = "#showtooltip Light of Elune\n/use Light of Elune\n/use Hearthstone",
    },
}

--- Macros view content
Deathless.UI.Views:Register("macros", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts

    local title, subtitle, separator = Utils:CreateHeader(container, "Macros", "Useful Hardcore macros")
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, -60, 24)

    -- Defensive sort in case entries are appended out-of-order later.
    table.sort(MACROS, function(a, b)
        return a.title:lower() < b.title:lower()
    end)

    local yOffset = -16
    local codeLineHeight = Fonts.body + 4
    local noteToken = ColorizeText(Colors.yellow, "Note:")

    for _, macro in ipairs(MACROS) do
        local macroTitle = scrollChild:CreateFontString(nil, "OVERLAY")
        macroTitle:SetFont(Fonts.family, Fonts.subtitle, "")
        macroTitle:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
        macroTitle:SetText(macro.title)
        macroTitle:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)

        local macroDesc = scrollChild:CreateFontString(nil, "OVERLAY")
        macroDesc:SetFont(Fonts.family, Fonts.body, "")
        macroDesc:SetPoint("TOPLEFT", macroTitle, "BOTTOMLEFT", 0, -4)
        macroDesc:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
        macroDesc:SetJustifyH("LEFT")
        macroDesc:SetText((macro.description or ""):gsub("Note:", noteToken))
        macroDesc:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)

        local codeLineCount = 0
        for _ in macro.code:gmatch("[^\n]+") do
            codeLineCount = codeLineCount + 1
        end
        if codeLineCount == 0 then
            codeLineCount = 1
        end

        local codeBlockHeight = (codeLineCount * codeLineHeight) + 10
        local codeBg = scrollChild:CreateTexture(nil, "ARTWORK")
        codeBg:SetPoint("TOPLEFT", macroDesc, "BOTTOMLEFT", 0, -8)
        codeBg:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
        codeBg:SetHeight(codeBlockHeight)
        codeBg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)

        local codeButton = CreateFrame("Button", nil, scrollChild)
        codeButton:SetPoint("TOPLEFT", macroDesc, "BOTTOMLEFT", 0, -8)
        codeButton:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
        codeButton:SetHeight(codeBlockHeight)
        codeButton:SetScript("OnMouseUp", function()
            Deathless.UI.Components.CopyPopup:Show("Copy Macro: " .. macro.title, macro.code)
        end)
        codeButton:SetScript("OnEnter", function()
            codeBg:SetColorTexture(Colors.hover[1], Colors.hover[2], Colors.hover[3], 1)
        end)
        codeButton:SetScript("OnLeave", function()
            codeBg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
        end)

        local codeText = scrollChild:CreateFontString(nil, "OVERLAY")
        codeText:SetFont(Fonts.code, Fonts.body + 1, "")
        codeText:SetPoint("TOPLEFT", codeBg, "TOPLEFT", 8, -6)
        codeText:SetPoint("TOPRIGHT", codeBg, "TOPRIGHT", -8, -6)
        codeText:SetJustifyH("LEFT")
        codeText:SetJustifyV("TOP")
        codeText:SetText(macro.code)
        codeText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

        yOffset = yOffset - 22 - macroDesc:GetStringHeight() - 8 - codeBlockHeight - 18
    end

    scrollChild:SetHeight(math.abs(yOffset) + 10)
    C_Timer.After(0, function()
        if scrollFrame.UpdateScrollbar then
            scrollFrame.UpdateScrollbar()
        end
    end)

    return { title = title, subtitle = subtitle, separator = separator }
end)
