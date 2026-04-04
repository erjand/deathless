local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local UIUtils = Deathless.Utils.UI
local ColorizeText = UIUtils.ColorizeText

Deathless.UI.Views.StatsTemplate = {}

local StatsLayout = Deathless.Constants.Colors.UI.TableLayouts.Stats
local ViewOffsets = Deathless.Constants.Colors.UI.ViewOffsets
local STATS_COL = StatsLayout.primary
local HEADER_X_SHIFT = StatsLayout.headerXShift
local STAT_ROW_HEIGHT = StatsLayout.statRowHeight

local function SortByStat(rows)
    local sorted = {}
    for _, row in ipairs(rows or {}) do
        table.insert(sorted, row)
    end
    table.sort(sorted, function(a, b)
        return (a.stat or ""):lower() < (b.stat or ""):lower()
    end)
    return sorted
end

function Deathless.UI.Views.StatsTemplate:Create(config)
    local viewName = config.viewName
    local className = config.className
    local classColor = config.classColor

    Deathless.UI.Views:Register(viewName, function(container, options)
        local Colors = Utils:GetColors()
        local Fonts = Deathless.UI.Fonts
        local Layout = Utils.Layout
        local embedded = options and options.embedded

        local title, subtitle
        if not embedded then
            title, subtitle = Utils:CreateHeader(container, className .. " Stats", "Hardcore-focused stat guidance", classColor)
        end

        local scrollTopOffset = embedded and ViewOffsets.classSimple.scrollTopEmbedded or ViewOffsets.classSimple.scrollTopFull
        local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, scrollTopOffset, ViewOffsets.defaultScrollBottom)

        local sectionState = {
            primary = true,
            secondary = false,
        }

        local TableComp = Deathless.UI.Components.Table

        local sectionPool = {}
        local textPool = {}
        local rowPool = {}
        local texPool = {}
        local sectionIndex = 0
        local textIndex = 0
        local rowIndex = 0
        local texIndex = 0

        local PopulateContent

        local function ClearElements()
            for _, section in ipairs(sectionPool) do
                section:Hide()
                section:ClearAllPoints()
            end
            for _, text in ipairs(textPool) do
                text:Hide()
                text:ClearAllPoints()
            end
            for _, row in ipairs(rowPool) do
                row:Hide()
                row:ClearAllPoints()
            end
            for _, tex in ipairs(texPool) do
                tex:Hide()
                tex:ClearAllPoints()
            end
            sectionIndex = 0
            textIndex = 0
            rowIndex = 0
            texIndex = 0
        end

        local function GetSectionHeader()
            sectionIndex = sectionIndex + 1
            local section = sectionPool[sectionIndex]
            if not section then
                section = Utils:CreateCollapsibleSection(scrollChild)
                sectionPool[sectionIndex] = section
            end
            return section
        end

        local function GetText()
            textIndex = textIndex + 1
            local text = textPool[textIndex]
            if not text then
                text = scrollChild:CreateFontString(nil, "OVERLAY")
                textPool[textIndex] = text
            end
            text:SetJustifyH("LEFT")
            text:SetJustifyV("TOP")
            return text
        end

        local function GetRow(height)
            rowIndex = rowIndex + 1
            local row = rowPool[rowIndex]
            if not row then
                row = CreateFrame("Button", nil, scrollChild)
                row.bg = row:CreateTexture(nil, "BACKGROUND")
                row.bg:SetAllPoints()
                row.cells = {}
                for i = 1, 8 do
                    local fs = row:CreateFontString(nil, "OVERLAY")
                    fs:SetFont(Fonts.family, Fonts.body, "")
                    fs:SetJustifyH("LEFT")
                    fs:SetJustifyV("TOP")
                    fs:SetWordWrap(true)
                    row.cells[i] = fs
                end
                rowPool[rowIndex] = row
            end
            row:SetHeight(height)
            TableComp:ApplyRowHover(row)
            return row
        end

        local RowStyle = Deathless.Constants.Colors.UI.Row

        local function GetTex()
            texIndex = texIndex + 1
            local tex = texPool[texIndex]
            if not tex then
                tex = scrollChild:CreateTexture(nil, "ARTWORK")
                texPool[texIndex] = tex
            end
            return tex
        end

        local TABLE_LEFT = 24
        local TABLE_RIGHT = -24

        local function PlaceHeaders(yOffset, cols, defs)
            yOffset = yOffset - 8
            local tableTop = yOffset

            -- Header background bar
            local bg = GetTex()
            bg:SetDrawLayer("BACKGROUND")
            bg:SetHeight(20)
            bg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", TABLE_LEFT, yOffset)
            bg:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", TABLE_RIGHT, yOffset)
            bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.3)
            bg:Show()

            -- Header labels
            for _, def in ipairs(defs) do
                local header = GetText()
                header:SetFont(Fonts.icons, Fonts.small, "")
                header:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", TABLE_LEFT + cols[def.key].x + HEADER_X_SHIFT, yOffset - 5)
                header:SetText(def.label)
                header:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                header:Show()
            end

            -- Column dividers (10px left of each column start)
            for i = 2, #defs do
                local currCol = cols[defs[i].key]
                local div = GetTex()
                div:SetDrawLayer("ARTWORK")
                div:SetWidth(1)
                div:SetHeight(14)
                div:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", TABLE_LEFT + currCol.x - 10, yOffset - 3)
                div:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], RowStyle.columnDividerAlpha)
                div:Show()
            end

            yOffset = yOffset - 20

            -- Border line under header
            local border = GetTex()
            border:SetDrawLayer("ARTWORK")
            border:SetHeight(1)
            border:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", TABLE_LEFT, yOffset)
            border:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", TABLE_RIGHT, yOffset)
            border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], RowStyle.headerBorderAlpha)
            border:Show()

            return yOffset - 2, tableTop
        end

        local function AddSection(sectionKey, label, yOffset)
            local section = GetSectionHeader()
            section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
            section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -12, yOffset)
            local sectionColor = Colors.accent
            if sectionKey == "secondary" then
                sectionColor = Colors.yellow
            end
            Utils:ConfigureSection(section, sectionState[sectionKey], label, sectionColor)
            section:SetScript("OnClick", function()
                sectionState[sectionKey] = not sectionState[sectionKey]
                PopulateContent()
            end)
            section:Show()
            return yOffset - Layout.sectionHeight
        end

        local function RenderStatsRows(rows, yOffset)
            if #rows == 0 then
                local empty = GetText()
                empty:SetFont(Fonts.family, Fonts.body, "")
                empty:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", TABLE_LEFT + 4, yOffset - 2)
                empty:SetText("No entries yet.")
                empty:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                empty:Show()
                return yOffset - 20
            end

            for i, data in ipairs(rows) do
                local row = GetRow(STAT_ROW_HEIGHT)
                row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", TABLE_LEFT, yOffset)
                row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", TABLE_RIGHT, yOffset)
                UIUtils.ApplyStripedRowBackground(row, Colors, i)
                row:Show()

                local values = { data.stat, data.bonus, data.priority, data.note }
                local keys = { "stat", "bonus", "priority", "note" }
                for idx, key in ipairs(keys) do
                    local fs = row.cells[idx]
                    fs:ClearAllPoints()
                    fs:SetPoint("TOPLEFT", row, "TOPLEFT", STATS_COL[key].x, -6)
                    fs:SetWidth(STATS_COL[key].w)
                    fs:SetHeight(STAT_ROW_HEIGHT - 10)
                    fs:SetText(values[idx] or "")
                    if idx == 1 or idx == 3 then
                        fs:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                    else
                        fs:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                    end
                    fs:Show()
                end
                for idx = 5, 8 do
                    row.cells[idx]:Hide()
                end

                yOffset = yOffset - STAT_ROW_HEIGHT
            end

            return yOffset
        end

        PopulateContent = function()
            ClearElements()

            local statsData = Deathless.Data and Deathless.Data.Stats
            local classStats = (statsData and statsData[className]) or {}
            local primaryRows = SortByStat(classStats.primary or classStats.statBonuses)
            local secondaryRows = SortByStat(classStats.secondary)
            local intro = GetText()
            intro:SetFont(Fonts.family, Fonts.body, "")
            intro:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, -4)
            intro:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -12, -4)
            intro:SetText("General stat guidance for " .. ColorizeText(classColor, className) .. " in Hardcore.")
            intro:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            intro:Show()

            local yOffset = -(intro:GetStringHeight() or 14) - Layout.introSectionGap

            yOffset = AddSection("primary", "Primary", yOffset)
            if sectionState.primary then
                local tableTop
                yOffset, tableTop = PlaceHeaders(yOffset, STATS_COL, {
                    { key = "stat", label = "STAT" },
                    { key = "bonus", label = "BONUS PER POINT" },
                    { key = "priority", label = "PRIORITY" },
                    { key = "note", label = "NOTE" },
                })
                yOffset = RenderStatsRows(primaryRows, yOffset)
                local borders = TableComp:CreateBorderGroup(scrollChild, { createTex = GetTex })
                TableComp:PositionBorders(borders, scrollChild, tableTop, yOffset, TABLE_LEFT, TABLE_RIGHT)
                yOffset = yOffset - 10
            else
                yOffset = yOffset - 8
            end

            yOffset = AddSection("secondary", "Secondary", yOffset)
            if sectionState.secondary then
                local tableTop
                yOffset, tableTop = PlaceHeaders(yOffset, STATS_COL, {
                    { key = "stat", label = "STAT" },
                    { key = "bonus", label = "BONUS" },
                    { key = "priority", label = "PRIORITY" },
                    { key = "note", label = "NOTE" },
                })
                yOffset = RenderStatsRows(secondaryRows, yOffset)
                local borders = TableComp:CreateBorderGroup(scrollChild, { createTex = GetTex })
                TableComp:PositionBorders(borders, scrollChild, tableTop, yOffset, TABLE_LEFT, TABLE_RIGHT)
            else
                yOffset = yOffset - 8
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

local CLASS_STATS_CONFIGS = {
    { viewName = "druid_stats", className = "Druid", classColor = Deathless.Constants.Colors.Class.druid },
    { viewName = "hunter_stats", className = "Hunter", classColor = Deathless.Constants.Colors.Class.hunter },
    { viewName = "mage_stats", className = "Mage", classColor = Deathless.Constants.Colors.Class.mage },
    { viewName = "paladin_stats", className = "Paladin", classColor = Deathless.Constants.Colors.Class.paladin },
    { viewName = "priest_stats", className = "Priest", classColor = Deathless.Constants.Colors.Class.priest },
    { viewName = "rogue_stats", className = "Rogue", classColor = Deathless.Constants.Colors.Class.rogue },
    { viewName = "shaman_stats", className = "Shaman", classColor = Deathless.Constants.Colors.Class.shaman },
    { viewName = "warlock_stats", className = "Warlock", classColor = Deathless.Constants.Colors.Class.warlock },
    { viewName = "warrior_stats", className = "Warrior", classColor = Deathless.Constants.Colors.Class.warrior },
}

for _, cfg in ipairs(CLASS_STATS_CONFIGS) do
    Deathless.UI.Views.StatsTemplate:Create(cfg)
end