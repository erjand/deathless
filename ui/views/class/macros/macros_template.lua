local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local ViewOffsets = Deathless.Constants.Colors.UI.ViewOffsets

Deathless.UI.Views.MacrosTemplate = {}

local function ColorizeText(color, text)
    local r = math.floor((color[1] or 1) * 255 + 0.5)
    local g = math.floor((color[2] or 1) * 255 + 0.5)
    local b = math.floor((color[3] or 1) * 255 + 0.5)
    return string.format("|cff%02x%02x%02x%s|r", r, g, b, text)
end

local function SortMacrosCopy(macros)
    local sorted = {}
    for _, macro in ipairs(macros or {}) do
        table.insert(sorted, macro)
    end
    table.sort(sorted, function(a, b)
        local aTitle = (a.title or ""):lower()
        local bTitle = (b.title or ""):lower()
        return aTitle < bTitle
    end)
    return sorted
end

--- Create a class macros view with copyable macro blocks
---@param config table { viewName, className, classColor }
function Deathless.UI.Views.MacrosTemplate:Create(config)
    local viewName = config.viewName
    local className = config.className
    local classColor = config.classColor

    Deathless.UI.Views:Register(viewName, function(container, options)
        local Colors = Utils:GetColors()
        local Fonts = Deathless.UI.Fonts
        local embedded = options and options.embedded

        local title, subtitle
        if not embedded then
            title, subtitle = Utils:CreateHeader(container, className .. " Macros", "Class macro snippets for Hardcore", classColor)
        end

        local scrollTopOffset = embedded and ViewOffsets.classSimple.scrollTopEmbedded or ViewOffsets.classSimple.scrollTopFull
        local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, scrollTopOffset, ViewOffsets.defaultScrollBottom)

        local elementPool = {}
        local elementIndex = 0

        local function ClearElements()
            for _, element in ipairs(elementPool) do
                if element.Hide then
                    element:Hide()
                end
            end
            elementIndex = 0
        end

        local function GetElement(createFn)
            elementIndex = elementIndex + 1
            local element = elementPool[elementIndex]
            if not element then
                element = createFn()
                elementPool[elementIndex] = element
            end
            return element
        end

        local PopulateContent

        PopulateContent = function()
            ClearElements()

            local macrosData = Deathless.Data and Deathless.Data.Macros
            local macros = SortMacrosCopy((macrosData and macrosData[className]) or {})

            local yOffset = 0
            local codeLineHeight = Fonts.body + 4

            local introText = GetElement(function()
                local fs = scrollChild:CreateFontString(nil, "OVERLAY")
                fs:SetFont(Fonts.family, Fonts.body, "")
                fs:SetJustifyH("LEFT")
                return fs
            end)
            introText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset - 4)
            introText:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -12, yOffset - 4)
            introText:SetText("Generally recommended HC macros for " .. ColorizeText(classColor, className) .. " - adjust as desired")
            introText:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            introText:Show()
            yOffset = yOffset - (introText:GetStringHeight() or 14) - 24

            if #macros == 0 then
                local emptyText = GetElement(function()
                    local fs = scrollChild:CreateFontString(nil, "OVERLAY")
                    fs:SetFont(Fonts.family, Fonts.body, "")
                    fs:SetJustifyH("LEFT")
                    return fs
                end)
                emptyText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                emptyText:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
                emptyText:SetText("No class macros added yet.")
                emptyText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                emptyText:Show()
                yOffset = yOffset - 28
            end

            for _, macro in ipairs(macros) do
                local macroTitle = GetElement(function()
                    local fs = scrollChild:CreateFontString(nil, "OVERLAY")
                    fs:SetFont(Fonts.family, Fonts.subtitle, "")
                    fs:SetJustifyH("LEFT")
                    return fs
                end)
                macroTitle:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                macroTitle:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
                macroTitle:SetText(macro.title or "Untitled Macro")
                macroTitle:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                macroTitle:Show()

                local macroDesc
                local descHeight = 0
                if macro.description and macro.description ~= "" then
                    macroDesc = GetElement(function()
                        local fs = scrollChild:CreateFontString(nil, "OVERLAY")
                        fs:SetFont(Fonts.family, Fonts.body, "")
                        fs:SetJustifyH("LEFT")
                        return fs
                    end)
                    macroDesc:SetPoint("TOPLEFT", macroTitle, "BOTTOMLEFT", 0, -4)
                    macroDesc:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
                    macroDesc:SetText(macro.description)
                    macroDesc:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                    macroDesc:Show()
                    descHeight = macroDesc:GetStringHeight() or 0
                end

                local code = macro.code or ""
                local codeLineCount = 0
                for _ in code:gmatch("[^\n]+") do
                    codeLineCount = codeLineCount + 1
                end
                if codeLineCount == 0 then
                    codeLineCount = 1
                end
                local codeBlockHeight = (codeLineCount * codeLineHeight) + 10

                local codeBg = GetElement(function()
                    local tex = scrollChild:CreateTexture(nil, "ARTWORK")
                    return tex
                end)
                if macroDesc then
                    codeBg:SetPoint("TOPLEFT", macroDesc, "BOTTOMLEFT", 0, -8)
                else
                    codeBg:SetPoint("TOPLEFT", macroTitle, "BOTTOMLEFT", 0, -6)
                end
                codeBg:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
                codeBg:SetHeight(codeBlockHeight)
                codeBg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
                codeBg:Show()

                local codeButton = GetElement(function()
                    return CreateFrame("Button", nil, scrollChild)
                end)
                if macroDesc then
                    codeButton:SetPoint("TOPLEFT", macroDesc, "BOTTOMLEFT", 0, -8)
                else
                    codeButton:SetPoint("TOPLEFT", macroTitle, "BOTTOMLEFT", 0, -6)
                end
                codeButton:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
                codeButton:SetHeight(codeBlockHeight)
                codeButton:Show()
                codeButton:SetScript("OnMouseUp", function()
                    Deathless.UI.Components.CopyPopup:Show("Copy Macro: " .. (macro.title or "Macro"), code)
                end)
                codeButton:SetScript("OnEnter", function()
                    codeBg:SetColorTexture(Colors.hover[1], Colors.hover[2], Colors.hover[3], 1)
                end)
                codeButton:SetScript("OnLeave", function()
                    codeBg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
                end)

                local codeText = GetElement(function()
                    local fs = scrollChild:CreateFontString(nil, "OVERLAY")
                    fs:SetFont(Fonts.code, Fonts.body + 1, "")
                    fs:SetJustifyH("LEFT")
                    fs:SetJustifyV("TOP")
                    return fs
                end)
                codeText:SetPoint("TOPLEFT", codeBg, "TOPLEFT", 8, -6)
                codeText:SetPoint("TOPRIGHT", codeBg, "TOPRIGHT", -8, -6)
                codeText:SetText(code)
                codeText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                codeText:Show()

                yOffset = yOffset - 22 - descHeight - 8 - codeBlockHeight - 14
            end

            scrollChild:SetHeight(math.abs(yOffset) + 10)
            C_Timer.After(0, function()
                if scrollFrame.UpdateScrollbar then
                    scrollFrame.UpdateScrollbar()
                end
            end)
        end

        PopulateContent()

        return {
            title = title,
            subtitle = subtitle,
            scrollFrame = scrollFrame,
            scrollChild = scrollChild,
            Refresh = PopulateContent,
        }
    end)
end

local CLASS_MACRO_CONFIGS = {
    { viewName = "druid_macros", className = "Druid", classColor = Deathless.Constants.Colors.Class.druid },
    { viewName = "hunter_macros", className = "Hunter", classColor = Deathless.Constants.Colors.Class.hunter },
    { viewName = "mage_macros", className = "Mage", classColor = Deathless.Constants.Colors.Class.mage },
    { viewName = "paladin_macros", className = "Paladin", classColor = Deathless.Constants.Colors.Class.paladin },
    { viewName = "priest_macros", className = "Priest", classColor = Deathless.Constants.Colors.Class.priest },
    { viewName = "rogue_macros", className = "Rogue", classColor = Deathless.Constants.Colors.Class.rogue },
    { viewName = "shaman_macros", className = "Shaman", classColor = Deathless.Constants.Colors.Class.shaman },
    { viewName = "warlock_macros", className = "Warlock", classColor = Deathless.Constants.Colors.Class.warlock },
    { viewName = "warrior_macros", className = "Warrior", classColor = Deathless.Constants.Colors.Class.warrior },
}

for _, cfg in ipairs(CLASS_MACRO_CONFIGS) do
    Deathless.UI.Views.MacrosTemplate:Create(cfg)
end
