local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local UIUtils = Deathless.Utils.UI
local Factions = Deathless.Constants and Deathless.Constants.Factions or {
    ALLIANCE = "Alliance",
    HORDE = "Horde",
    BOTH = "Both",
}
local Urls = Deathless.Constants and Deathless.Constants.Urls or {
    WOWHEAD_CLASSIC_QUEST_BASE = "https://www.wowhead.com/classic/quest=",
}
local DungeonLayout = Deathless.Constants.Colors.UI.TableLayouts.Dungeons
local MAIN_COL = DungeonLayout.main
local ViewOffsets = Deathless.Constants.Colors.UI.ViewOffsets

--- Create a sortable column header button
---@param parent Frame Parent frame
---@param label string Header text
---@param xOffset number X position offset
---@param width number Button width
---@param sortKey string The key to sort by
---@param state table Shared sort state
---@param onSort function Callback when sort changes
---@param tooltip table|nil Optional tooltip lines {title, line1, ...}
---@return Button The header button
local function CreateSortableHeader(parent, label, xOffset, width, sortKey, state, onSort, tooltip)
    local Colors = Utils:GetColors()

    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(width, 18)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, ViewOffsets.dungeons.sortHeaderY)

    local Fonts = Deathless.UI.Fonts
    btn.label = btn:CreateFontString(nil, "OVERLAY")
    btn.label:SetFont(Fonts.icons, Fonts.small, "")
    btn.label:SetPoint("LEFT", btn, "LEFT", 0, 0)
    btn.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

    btn.sortKey = sortKey

    local function UpdateLabel()
        local indicator = ""
        if state.sortKey == sortKey then
            indicator = state.sortAsc and " ▲" or " ▼"
        end
        btn.label:SetText(label .. indicator)
    end

    UpdateLabel()
    btn.UpdateLabel = UpdateLabel

    btn:SetScript("OnEnter", function(self)
        self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        if tooltip then
            Deathless.UI.Tooltip:Show(self, "ANCHOR_TOP", tooltip.title or label, tooltip)
        end
    end)

    btn:SetScript("OnLeave", function(self)
        if state.sortKey == sortKey then
            self.label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
        else
            self.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        end
        Deathless.UI.Tooltip:Hide()
    end)

    btn:SetScript("OnClick", function()
        if state.sortKey == sortKey then
            state.sortAsc = not state.sortAsc
        else
            state.sortKey = sortKey
            state.sortAsc = true
        end
        onSort()
    end)

    return btn
end

--- Get the gray level threshold for a given player level
---@param playerLevel number
---@return number The level at or below which mobs are gray
local function GetGrayLevel(playerLevel)
    if playerLevel <= 5 then
        return 0
    elseif playerLevel <= 39 then
        return playerLevel - math.floor(playerLevel / 10) - 5
    elseif playerLevel <= 59 then
        return playerLevel - math.floor(playerLevel / 5) - 1
    else
        return playerLevel - 9
    end
end

--- Get difficulty color for a mob level relative to player level
---@param mobLevel number
---@param playerLevel number
---@return table RGB color {r, g, b} from Colors.diff* palette
local function GetDifficultyColor(mobLevel, playerLevel)
    local Colors = Utils:GetColors()
    local diff = mobLevel - playerLevel
    if diff >= 5 then
        return Colors.diffRed
    elseif diff >= 3 then
        return Colors.diffOrange
    elseif diff >= -2 then
        return Colors.diffYellow
    elseif mobLevel > GetGrayLevel(playerLevel) then
        return Colors.diffGreen
    else
        return Colors.diffGray
    end
end

--- Escape Lua pattern metacharacters so plain text can be safely used in gsub.
---@param text string
---@return string
local function EscapeLuaPattern(text)
    return (text:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1"))
end

local LegacyIsQuestFlaggedCompleted = rawget(_G, "IsQuestFlaggedCompleted")
local CQuestLog = rawget(_G, "C_QuestLog")

--- Check whether a quest is completed for the current character.
---@param questId number|nil
---@return boolean
local function IsQuestCompleted(questId)
    if type(questId) ~= "number" or questId <= 0 then
        return false
    end

    if type(CQuestLog) == "table" and type(CQuestLog.IsQuestFlaggedCompleted) == "function" then
        return CQuestLog.IsQuestFlaggedCompleted(questId) == true
    end

    if LegacyIsQuestFlaggedCompleted then
        return LegacyIsQuestFlaggedCompleted(questId) == true
    end

    return false
end

--- Dungeons view - sortable/searchable dungeon list with expandable details
Deathless.UI.Views:Register("dungeons", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    local Layout = Utils.Layout
    local RowStyle = Deathless.Constants.Colors.UI.Row
    local CONTENT_LEFT = 12
    local CONTENT_RIGHT = -12

    local title, subtitle = Utils:CreateHeader(container, "Dungeons")

    -- Search state
    local searchState = { term = "" }
    local filterState = { inLevelRange = false }

    -- Load persisted filter state
    Deathless.config.dungeons = Deathless.config.dungeons or {}
    filterState.inLevelRange = Deathless.config.dungeons.inLevelRange == true

    -- Search bar
    local searchBox, searchLabel, clearBtn = Utils:CreateSearchControl(container, {
        x = 24,
        y = ViewOffsets.dungeons.searchY,
        label = "Search",
    })

    local function SaveFilterState()
        Deathless.config.dungeons = Deathless.config.dungeons or {}
        Deathless.config.dungeons.inLevelRange = filterState.inLevelRange == true
        Deathless:SaveConfig()
    end

    local function UpdateFilterCheckboxVisual(button, checked)
        Utils:SetFilterCheckboxVisual(button, checked)
    end

    local PopulateRows

    local function CreateFilterCheckbox()
        local button = Utils:CreateFilterCheckboxControl(container, {
            width = 130,
            xOffset = 16,
            relativeTo = searchBox,
            label = "In Level Range",
        })

        UpdateFilterCheckboxVisual(button, filterState.inLevelRange)

        button:SetScript("OnEnter", function(self)
            self.border:SetColorTexture(Colors.accent[1] * 0.8, Colors.accent[2] * 0.8, Colors.accent[3] * 0.8, 1)
            self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        end)
        button:SetScript("OnLeave", function(self)
            self.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
            UpdateFilterCheckboxVisual(self, filterState.inLevelRange)
        end)
        button:SetScript("OnClick", function(self)
            filterState.inLevelRange = not filterState.inLevelRange
            UpdateFilterCheckboxVisual(self, filterState.inLevelRange)
            SaveFilterState()
            if PopulateRows then PopulateRows() end
        end)

        return button
    end

    local inLevelRangeCheckbox = CreateFilterCheckbox()

    -- Scroll frame
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, ViewOffsets.dungeons.scrollTop, ViewOffsets.defaultScrollBottom)

    -- Sort state (default: sort by min level ascending)
    local sortState = { sortKey = "level", sortAsc = true }

    -- Raw data
    local rawDungeons = Deathless.Data.Dungeons or {}

    -- Expand state per dungeon id (supports multiple expanded rows)
    local expandedState = {}

    -- Section collapse state per dungeon: sectionState[dungeonId][sectionKey] = bool
    local sectionState = {}

    -- Element pools
    local rowPool = {}
    local textPool = {}
    local questRowPool = {}
    local sectionPool = {}
    local poolIndex = 0
    local textIndex = 0
    local questRowIndex = 0
    local sectionIndex = 0

    local function ClearAll()
        for _, row in ipairs(rowPool) do
            row:Hide()
            row:ClearAllPoints()
        end
        for _, t in ipairs(textPool) do
            t:Hide()
            t:ClearAllPoints()
        end
        for _, qr in ipairs(questRowPool) do
            qr:Hide()
            qr:ClearAllPoints()
        end
        for _, s in ipairs(sectionPool) do
            s:Hide()
            s:ClearAllPoints()
        end
        poolIndex = 0
        textIndex = 0
        questRowIndex = 0
        sectionIndex = 0
    end

    local function GetRow()
        poolIndex = poolIndex + 1
        local row = rowPool[poolIndex]
        if not row then
            row = CreateFrame("Button", nil, scrollChild)
            rowPool[poolIndex] = row
        end
        if row.elements then
            for _, el in pairs(row.elements) do
                if el.Hide then el:Hide() end
            end
        end
        row.elements = {}
        return row
    end

    local function GetText(font, fontSize)
        textIndex = textIndex + 1
        if not textPool[textIndex] then
            textPool[textIndex] = scrollChild:CreateFontString(nil, "OVERLAY")
        end
        local fs = textPool[textIndex]
        fs:SetFont(font or Fonts.family, fontSize or Fonts.body, "")
        return fs
    end

    local function GetSection()
        sectionIndex = sectionIndex + 1
        if not sectionPool[sectionIndex] then
            sectionPool[sectionIndex] = Utils:CreateCollapsibleSection(scrollChild)
        end
        return sectionPool[sectionIndex]
    end

    local function SortDungeons(dungeons)
        local sorted = {}
        for _, d in ipairs(dungeons) do
            table.insert(sorted, d)
        end

        local key = sortState.sortKey
        local asc = sortState.sortAsc

        table.sort(sorted, function(a, b)
            local valA, valB
            if key == "name" then
                valA, valB = a.name, b.name
            elseif key == "zone" then
                valA, valB = a.zone, b.zone
            elseif key == "boss" then
                valA, valB = a.endBoss, b.endBoss
            else -- "level"
                valA, valB = a.levelMin, b.levelMin
            end
            if asc then return valA < valB else return valA > valB end
        end)

        return sorted
    end

    local QUEST_COLOR = Deathless.Constants.Colors.Dungeon.quest
    local QUEST_ROW_HEIGHT = DungeonLayout.quests.rowHeight

    local MAX_REWARD_ICONS = DungeonLayout.quests.maxRewardIcons
    local ICON_SIZE = DungeonLayout.quests.iconSize
    local ICON_SPACING = DungeonLayout.quests.iconSpacing

    -- Quest sub-table column layout
    local questCols = DungeonLayout.quests.columns
    local QC = {
        nameX = questCols.name.x,      nameW = questCols.name.w,
        lvX   = questCols.level.x,     lvW   = questCols.level.w,
        startX = questCols.startedBy.x, startW = questCols.startedBy.w,
        preX  = questCols.prereq.x,    preW  = questCols.prereq.w,
        rewX  = questCols.rewards.x,
    }
    local QUEST_HEADER_HEIGHT = DungeonLayout.quests.headerHeight

    --- Convert {r,g,b} color table to WoW color code.
    ---@param color table|nil
    ---@return string
    local function ColorCodeFromRGB(color)
        local r = math.floor(((color and color[1]) or 1) * 255 + 0.5)
        local g = math.floor(((color and color[2]) or 1) * 255 + 0.5)
        local b = math.floor(((color and color[3]) or 1) * 255 + 0.5)
        return string.format("|cff%02x%02x%02x", r, g, b)
    end

    local warningNameColorCode = ColorCodeFromRGB(Colors.xpHeader)

    --- Highlight warning names in XP blue.
    --- Supports explicit name tags in data text via [[Name Here]].
    --- Also highlights the current dungeon end boss name when present.
    ---@param dungeon table
    ---@param warning string
    ---@return string
    local function FormatWarningText(dungeon, warning)
        local result = warning or ""

        -- Explicit tagging for names authored in data/dungeons.lua.
        result = result:gsub("%[%[(.-)%]%]", function(name)
            return warningNameColorCode .. name .. "|r"
        end)

        -- Automatic boss-name highlight so this works immediately.
        if dungeon and dungeon.endBoss and dungeon.endBoss ~= "" then
            local bossPattern = EscapeLuaPattern(dungeon.endBoss)
            result = result:gsub(bossPattern, warningNameColorCode .. dungeon.endBoss .. "|r")
        end

        return result
    end

    local function GetQuestRow()
        questRowIndex = questRowIndex + 1
        local row = questRowPool[questRowIndex]
        if not row then
            row = CreateFrame("Frame", nil, scrollChild)
            row:SetHeight(QUEST_ROW_HEIGHT)

            -- Quest name (button for hover tooltip)
            row.nameBtn = CreateFrame("Button", nil, row)
            row.nameBtn:SetPoint("LEFT", row, "LEFT", QC.nameX, 0)
            row.nameBtn:SetSize(QC.nameW, QUEST_ROW_HEIGHT)

            row.nameText = row.nameBtn:CreateFontString(nil, "OVERLAY")
            row.nameText:SetFont(Fonts.family, Fonts.body, "")
            row.nameText:SetPoint("LEFT", 0, 0)
            row.nameText:SetWidth(QC.nameW)
            row.nameText:SetJustifyH("LEFT")

            -- Level
            row.levelText = row:CreateFontString(nil, "OVERLAY")
            row.levelText:SetFont(Fonts.family, Fonts.body, "")
            row.levelText:SetPoint("LEFT", row, "LEFT", QC.lvX, 0)
            row.levelText:SetWidth(QC.lvW)
            row.levelText:SetJustifyH("CENTER")

            -- Starts (NPC name, button for tooltip)
            row.startsBtn = CreateFrame("Button", nil, row)
            row.startsBtn:SetPoint("LEFT", row, "LEFT", QC.startX, 0)
            row.startsBtn:SetSize(QC.startW, QUEST_ROW_HEIGHT)

            row.startsText = row.startsBtn:CreateFontString(nil, "OVERLAY")
            row.startsText:SetFont(Fonts.family, Fonts.body, "")
            row.startsText:SetPoint("LEFT", 0, 0)
            row.startsText:SetWidth(QC.startW)
            row.startsText:SetJustifyH("LEFT")

            -- Prereq
            row.prereqText = row:CreateFontString(nil, "OVERLAY")
            row.prereqText:SetFont(Fonts.family, Fonts.body, "")
            row.prereqText:SetPoint("LEFT", row, "LEFT", QC.preX, 0)
            row.prereqText:SetWidth(QC.preW)
            row.prereqText:SetJustifyH("CENTER")

            -- Money text (for quests that reward gold instead of items)
            row.moneyText = row:CreateFontString(nil, "OVERLAY")
            row.moneyText:SetFont(Fonts.family, Fonts.body, "")
            row.moneyText:SetPoint("LEFT", row, "LEFT", QC.rewX, 0)
            row.moneyText:SetJustifyH("LEFT")

            -- Reward icon buttons (pre-create a fixed pool per row)
            row.rewardIcons = {}
            for i = 1, MAX_REWARD_ICONS do
                local icon = CreateFrame("Button", nil, row)
                icon:SetSize(ICON_SIZE, ICON_SIZE)
                icon:SetPoint("LEFT", row, "LEFT", QC.rewX + (i - 1) * (ICON_SIZE + ICON_SPACING), 0)

                icon.tex = icon:CreateTexture(nil, "ARTWORK")
                icon.tex:SetAllPoints()
                icon.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)

                icon:Hide()
                row.rewardIcons[i] = icon
            end

            questRowPool[questRowIndex] = row
        end
        return row
    end

    --- Render the detail sections for an expanded dungeon
    ---@param dungeon table The dungeon data
    ---@param yOffset number Current Y offset
    ---@return number New Y offset after detail content
    local function RenderDetail(dungeon, yOffset)
        local LINE_PADDING = 4
        local SECTION_GAP = 10
        local SECTION_HEIGHT = Layout.sectionHeight
        local contentWidth = scrollChild:GetWidth() - 60

        local state = sectionState[dungeon.id]
        if not state then
            state = { warnings = true, quests = true }
            sectionState[dungeon.id] = state
        end

        -- Warnings
        if dungeon.warnings and #dungeon.warnings > 0 then
            local warningLines = {}
            for _, w in ipairs(dungeon.warnings) do
                table.insert(warningLines, "•  " .. FormatWarningText(dungeon, w))
            end

            local sec = GetSection()
            sec:ClearAllPoints()
            sec:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 16, yOffset)
            sec:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT - 16, yOffset)
            Utils:ConfigureSection(sec, state.warnings, "Warnings", Colors.yellow, #dungeon.warnings)
            sec:SetScript("OnClick", function()
                state.warnings = not state.warnings
                PopulateRows()
            end)
            sec:Show()
            yOffset = yOffset - SECTION_HEIGHT - 4

            if state.warnings then
                for _, text in ipairs(warningLines) do
                    local fs = GetText()
                    fs:ClearAllPoints()
                    fs:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 32, yOffset)
                    fs:SetWidth(contentWidth)
                    fs:SetJustifyH("LEFT")
                    fs:SetWordWrap(true)
                    fs:SetText(text)
                    fs:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                    fs:Show()

                    local textHeight = fs:GetStringHeight() or 14
                    yOffset = yOffset - textHeight - LINE_PADDING
                end
            end

            yOffset = yOffset - SECTION_GAP
        end

        -- Quests (sorted by name, filtered by player faction)
        local playerFaction = UnitFactionGroup("player") or ""
        local sortedQuests = {}
        if dungeon.quests then
            for _, q in ipairs(dungeon.quests) do
                if not q.side or q.side == playerFaction or q.side == Factions.BOTH then
                    table.insert(sortedQuests, q)
                end
            end
            table.sort(sortedQuests, function(a, b) return a.name < b.name end)
        end

        do
            local sec = GetSection()
            sec:ClearAllPoints()
            sec:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 16, yOffset)
            sec:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT - 16, yOffset)
            Utils:ConfigureSection(sec, state.quests, "Quests", QUEST_COLOR, #sortedQuests)
            sec:SetScript("OnClick", function()
                state.quests = not state.quests
                PopulateRows()
            end)
            sec:Show()
            yOffset = yOffset - SECTION_HEIGHT

            if state.quests and #sortedQuests > 0 then
                yOffset = yOffset - 4
                -- Column headers
                local headers = { "NAME", "LVL", "STARTED BY", "PREREQ", "REWARDS" }
                local headerX = { QC.nameX, QC.lvX, QC.startX, QC.preX, QC.rewX }
                local headerW = { QC.nameW, QC.lvW, QC.startW, QC.preW, 80 }
                local headerJ = { "LEFT", "CENTER", "LEFT", "CENTER", "LEFT" }
                for i, h in ipairs(headers) do
                    local hdr = GetText(Fonts.family, Fonts.small)
                    hdr:ClearAllPoints()
                    hdr:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", headerX[i] + CONTENT_LEFT, yOffset)
                    hdr:SetWidth(headerW[i])
                    hdr:SetJustifyH(headerJ[i])
                    hdr:SetText(h)
                    hdr:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                    hdr:Show()
                end
                yOffset = yOffset - QUEST_HEADER_HEIGHT

                for _, q in ipairs(sortedQuests) do
                    local qr = GetQuestRow()
                    qr:ClearAllPoints()
                    qr:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
                    qr:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
                    qr:Show()

                    local questId = q.questId
                    local isCompleted = IsQuestCompleted(questId)
                    local questNameColor = isCompleted and Colors.textDim or Colors.text
                    local questSubtleColor = Colors.textDim
                    local prereqYesColor = isCompleted and Colors.textDim or Colors.yellow
                    local moneyTextColor = isCompleted and Colors.textDim or Colors.text

                    qr.nameText:SetText(q.name)
                    qr.nameText:SetTextColor(questNameColor[1], questNameColor[2], questNameColor[3], 1)

                    -- Quest tooltip on name hover
                    local questLevel = q.level
                    if questId then
                        qr.nameBtn:SetScript("OnEnter", function(self)
                            qr.nameText:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 4, 0)
                            GameTooltip:SetHyperlink("quest:" .. questId .. ":" .. questLevel)
                            GameTooltip:Show()
                        end)
                        qr.nameBtn:SetScript("OnLeave", function()
                            qr.nameText:SetTextColor(questNameColor[1], questNameColor[2], questNameColor[3], 1)
                            GameTooltip:Hide()
                        end)
                        qr.nameBtn:SetScript("OnMouseUp", function()
                            local questUrl = Urls.WOWHEAD_CLASSIC_QUEST_BASE .. questId
                            Deathless.UI.Components.CopyPopup:Show("Copy Quest URL: " .. q.name, questUrl)
                        end)
                    else
                        qr.nameBtn:SetScript("OnEnter", nil)
                        qr.nameBtn:SetScript("OnLeave", nil)
                        qr.nameBtn:SetScript("OnMouseUp", nil)
                    end

                    -- Level
                    qr.levelText:SetText("Lv " .. q.level)
                    qr.levelText:SetTextColor(questSubtleColor[1], questSubtleColor[2], questSubtleColor[3], 1)

                    -- Starts (NPC name with tooltip)
                    if q.startNpc then
                        qr.startsText:SetText(q.startNpc)
                        qr.startsText:SetTextColor(questNameColor[1], questNameColor[2], questNameColor[3], 1)
                        local startTip = q.startLoc or ""
                        if q.startCoords then
                            startTip = startTip .. " (" .. q.startCoords .. ")"
                        end
                        local startUrl, startCopyTitle
                        if q.startItemId then
                            startUrl = Urls.WOWHEAD_CLASSIC_ITEM_BASE .. q.startItemId
                            startCopyTitle = "Copy Start Item URL: " .. q.startNpc
                        elseif q.startNpcId then
                            startUrl = Urls.WOWHEAD_CLASSIC_NPC_BASE .. q.startNpcId
                            startCopyTitle = "Copy Start NPC URL: " .. q.startNpc
                        end
                        qr.startsBtn:SetScript("OnEnter", function(self)
                            if startUrl then
                                qr.startsText:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                            end
                            Deathless.UI.Tooltip:Show(self, "ANCHOR_RIGHT", startTip)
                        end)
                        qr.startsBtn:SetScript("OnLeave", function()
                            qr.startsText:SetTextColor(questNameColor[1], questNameColor[2], questNameColor[3], 1)
                            Deathless.UI.Tooltip:Hide()
                        end)
                        if startUrl then
                            qr.startsBtn:SetScript("OnMouseUp", function()
                                Deathless.UI.Components.CopyPopup:Show(startCopyTitle, startUrl)
                            end)
                        else
                            qr.startsBtn:SetScript("OnMouseUp", nil)
                        end
                    else
                        qr.startsText:SetText("")
                        qr.startsBtn:SetScript("OnEnter", nil)
                        qr.startsBtn:SetScript("OnLeave", nil)
                        qr.startsBtn:SetScript("OnMouseUp", nil)
                    end

                    -- Prereq
                    if q.prereq == true then
                        qr.prereqText:SetText("Yes")
                        qr.prereqText:SetTextColor(prereqYesColor[1], prereqYesColor[2], prereqYesColor[3], 1)
                    elseif q.prereq == false then
                        qr.prereqText:SetText("No")
                        qr.prereqText:SetTextColor(questSubtleColor[1], questSubtleColor[2], questSubtleColor[3], 1)
                    else
                        qr.prereqText:SetText("-")
                        qr.prereqText:SetTextColor(questSubtleColor[1], questSubtleColor[2], questSubtleColor[3], 1)
                    end

                    -- Rewards: item icons and/or money
                    for i = 1, MAX_REWARD_ICONS do
                        local rewardIcon = qr.rewardIcons[i]
                        rewardIcon:Hide()
                        rewardIcon.itemLoadToken = (rewardIcon.itemLoadToken or 0) + 1
                        rewardIcon.boundItemId = nil
                    end
                    qr.moneyText:SetText("")
                    qr.moneyText:Hide()

                    local rewardIconCount = 0
                    if q.rewards and #q.rewards > 0 then
                        local shownRewardIcons = 0
                        for _, r in ipairs(q.rewards) do
                            if shownRewardIcons >= MAX_REWARD_ICONS then break end

                            local itemId = r and r.itemId
                            if type(itemId) == "number" and itemId > 0 then
                                shownRewardIcons = shownRewardIcons + 1
                                local icon = qr.rewardIcons[shownRewardIcons]
                                rewardIconCount = shownRewardIcons

                                icon.boundItemId = itemId
                                icon.tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                                local itemTexture = C_Item.GetItemIconByID(itemId)
                                if not itemTexture and C_Item.GetItemInfoInstant then
                                    local _, _, _, _, iconFileID = C_Item.GetItemInfoInstant(itemId)
                                    itemTexture = iconFileID
                                end
                                if itemTexture then
                                    icon.tex:SetTexture(itemTexture)
                                end

                                icon:SetScript("OnEnter", function(self)
                                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 4, 0)
                                    GameTooltip:SetItemByID(itemId)
                                    GameTooltip:Show()
                                end)
                                icon:SetScript("OnLeave", function()
                                    GameTooltip:Hide()
                                end)
                                icon:Show()
                            end
                        end
                    end

                    if q.money and q.money > 0 then
                        local FormatMoney = Deathless.Utils.Abilities.FormatMoneyColored
                        local moneyX = QC.rewX
                        if rewardIconCount > 0 then
                            moneyX = QC.rewX + (rewardIconCount * (ICON_SIZE + ICON_SPACING)) + 4
                        end
                        qr.moneyText:ClearAllPoints()
                        qr.moneyText:SetPoint("LEFT", qr, "LEFT", moneyX, 0)
                        qr.moneyText:SetText(FormatMoney(q.money))
                        qr.moneyText:SetTextColor(moneyTextColor[1], moneyTextColor[2], moneyTextColor[3], 1)
                        qr.moneyText:Show()
                    end

                    yOffset = yOffset - QUEST_ROW_HEIGHT
                end
            end

            yOffset = yOffset - SECTION_GAP
        end

        return yOffset
    end

    local function CreateRowAt(dungeon, yOffset, rowNum)
        local row = GetRow()
        local ROW_HEIGHT = DungeonLayout.rowHeight
        local isExpanded = expandedState[dungeon.id] == true

        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
        row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
        row:SetHeight(ROW_HEIGHT)
        row:Show()

        -- Alternating row background
        UIUtils.ApplyStripedRowBackground(row, Colors, rowNum, isExpanded)

        -- Hover highlight
        if not row.highlight then
            row.highlight = row:CreateTexture(nil, "HIGHLIGHT")
            row.highlight:SetAllPoints()
            row.highlight:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], RowStyle.stripeAlpha * 0.4)
        end

        -- Expand indicator
        local expandIcon = row:CreateFontString(nil, "OVERLAY")
        expandIcon:SetFont(Fonts.icons, Fonts.small, "")
        expandIcon:SetPoint("LEFT", row, "LEFT", MAIN_COL.expand.x, 0)
        expandIcon:SetText(isExpanded and "▼" or "►")
        expandIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        row.elements.expandIcon = expandIcon

        -- Level Range
        local playerLevel = UnitLevel("player") or 60
        local levelText = dungeon.levelMin .. "-" .. dungeon.levelMax

        local level = row:CreateFontString(nil, "OVERLAY")
        level:SetFont(Fonts.family, Fonts.body, "")
        level:SetPoint("LEFT", row, "LEFT", MAIN_COL.level.x, 0)
        level:SetWidth(MAIN_COL.level.w)
        level:SetJustifyH("CENTER")
        level:SetText(levelText)
        level:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        row.elements.level = level

        -- Name
        local name = row:CreateFontString(nil, "OVERLAY")
        name:SetFont(Fonts.family, Fonts.body, "")
        name:SetPoint("LEFT", row, "LEFT", MAIN_COL.name.x, 0)
        name:SetWidth(MAIN_COL.name.w)
        name:SetJustifyH("LEFT")
        name:SetText(dungeon.name)
        if isExpanded then
            name:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
        else
            name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        end
        row.elements.name = name

        -- Zone
        local zone = row:CreateFontString(nil, "OVERLAY")
        zone:SetFont(Fonts.family, Fonts.body, "")
        zone:SetPoint("LEFT", row, "LEFT", MAIN_COL.zone.x, 0)
        zone:SetWidth(MAIN_COL.zone.w)
        zone:SetJustifyH("LEFT")
        zone:SetText(dungeon.zone)
        zone:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        row.elements.zone = zone

        -- End Boss (Name + level), colored by difficulty
        local bossC = GetDifficultyColor(dungeon.bossLevel, playerLevel)
        local boss = row:CreateFontString(nil, "OVERLAY")
        boss:SetFont(Fonts.family, Fonts.body, "")
        boss:SetPoint("LEFT", row, "LEFT", MAIN_COL.boss.x, 0)
        boss:SetWidth(MAIN_COL.boss.w)
        boss:SetJustifyH("LEFT")
        boss:SetText(dungeon.endBoss .. " (" .. dungeon.bossLevel .. ")")
        boss:SetTextColor(bossC[1], bossC[2], bossC[3], 1)
        row.elements.boss = boss

        -- Click toggles expand
        row:SetScript("OnClick", function()
            expandedState[dungeon.id] = not expandedState[dungeon.id]
            PopulateRows()
        end)

        yOffset = yOffset - ROW_HEIGHT

        -- Render detail sections if expanded (with padding before content)
        if isExpanded then
            yOffset = yOffset - 6
            yOffset = RenderDetail(dungeon, yOffset)
        end

        return yOffset
    end

    PopulateRows = function()
        ClearAll()

        local searchTerm = searchState.term:lower()
        local hasSearch = searchTerm ~= ""

        local filtered = {}
        local playerLevel = UnitLevel("player") or 60
        for _, dungeon in ipairs(rawDungeons) do
            local inRange = playerLevel >= dungeon.levelMin and playerLevel <= dungeon.levelMax
            local matchesLevelRange = (not filterState.inLevelRange) or inRange

            if matchesLevelRange and (
                not hasSearch
                or dungeon.name:lower():find(searchTerm, 1, true)
                or dungeon.zone:lower():find(searchTerm, 1, true)
                or dungeon.endBoss:lower():find(searchTerm, 1, true)
            ) then
                table.insert(filtered, dungeon)
            end
        end

        local sorted = SortDungeons(filtered)

        local yOffset = 0
        for i, dungeon in ipairs(sorted) do
            yOffset = CreateRowAt(dungeon, yOffset, i)
        end

        scrollChild:SetHeight(math.abs(yOffset) + 10)

        C_Timer.After(0, function()
            if scrollFrame.UpdateScrollbar then
                scrollFrame.UpdateScrollbar()
            end
        end)
    end

    -- Wire up search
    searchBox:SetScript("OnTextChanged", function(self)
        local text = self:GetText()
        searchState.term = text
        if text ~= "" then clearBtn:Show() else clearBtn:Hide() end
        PopulateRows()
    end)
    searchBox:SetScript("OnEscapePressed", function(self) self:SetText("") self:ClearFocus() end)
    searchBox:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

    -- Column headers
    local headers = {}

    local function OnSort()
        for _, header in pairs(headers) do
            if sortState.sortKey == header.sortKey then
                header.label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
            else
                header.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            end
            header.UpdateLabel()
        end
        PopulateRows()
    end

    headers.level = CreateSortableHeader(container, "LEVEL (?)",        MAIN_COL.level.x + CONTENT_LEFT,  MAIN_COL.level.w,  "level", sortState, OnSort, {
        title = "Dungeon Level Range",
        "Level range where a player can",
        "receive XP from some of the mobs.",
    })
    headers.name  = CreateSortableHeader(container, "NAME",         MAIN_COL.name.x + CONTENT_LEFT,  MAIN_COL.name.w, "name",  sortState, OnSort)
    headers.zone  = CreateSortableHeader(container, "ZONE",         MAIN_COL.zone.x + CONTENT_LEFT, MAIN_COL.zone.w, "zone",  sortState, OnSort)
    headers.boss  = CreateSortableHeader(container, "END BOSS (?)", MAIN_COL.boss.x + CONTENT_LEFT, MAIN_COL.boss.w, "boss",  sortState, OnSort, {
        title = "End Boss Level",
        "Recommend all players be within",
        "3 levels of the end boss.",
    })

    OnSort()

    return {
        title = title,
        subtitle = subtitle,
        scrollFrame = scrollFrame,
        scrollChild = scrollChild,
        headers = headers,
        searchBox = searchBox,
        inLevelRangeCheckbox = inLevelRangeCheckbox,
        Refresh = PopulateRows,
    }
end)
