local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

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
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, -95)

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

--- Convert RGB floats (0-1) to a WoW color escape string
---@param r number
---@param g number
---@param b number
---@return string Color escape like "|cffRRGGBB"
local function RGBToEscape(r, g, b)
    return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
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

-- Zone territory: "Horde", "Alliance", or "Contested"
local ZONE_TERRITORY = {
    ["Orgrimmar"]            = "Horde",
    ["The Barrens"]          = "Horde",
    ["Silverpine Forest"]    = "Horde",
    ["Tirisfal Glades"]      = "Horde",
    ["Westfall"]             = "Alliance",
    ["Stormwind City"]       = "Alliance",
    ["Dun Morogh"]           = "Alliance",
    ["Ashenvale"]            = "Contested",
    ["Badlands"]             = "Contested",
    ["Tanaris"]              = "Contested",
    ["Desolace"]             = "Contested",
    ["Swamp of Sorrows"]     = "Contested",
    ["Blackrock Mountain"]   = "Contested",
    ["Feralas"]              = "Contested",
    ["Eastern Plaguelands"]  = "Contested",
    ["Western Plaguelands"]  = "Contested",
}

--- Dungeons view - sortable/searchable dungeon list with expandable details
Deathless.UI.Views:Register("dungeons", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts

    local title, subtitle = Utils:CreateHeader(container, "Dungeons")

    -- Search state
    local searchState = { term = "" }

    -- Search bar
    local searchBox = CreateFrame("EditBox", nil, container, "InputBoxTemplate")
    searchBox:SetSize(180, 20)
    searchBox:SetPoint("TOPLEFT", container, "TOPLEFT", 24, -52)
    searchBox:SetFont(Fonts.family, Fonts.body, "")
    searchBox:SetAutoFocus(false)
    searchBox:SetMaxLetters(50)
    searchBox:SetTextInsets(4, 20, 0, 0)

    local searchLabel = container:CreateFontString(nil, "OVERLAY")
    searchLabel:SetFont(Fonts.family, Fonts.small, "")
    searchLabel:SetPoint("BOTTOMLEFT", searchBox, "TOPLEFT", 2, 2)
    searchLabel:SetText("Search")
    searchLabel:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

    -- Clear button (X)
    local clearBtn = CreateFrame("Button", nil, searchBox)
    clearBtn:SetSize(16, 16)
    clearBtn:SetPoint("RIGHT", searchBox, "RIGHT", -2, 0)
    clearBtn.text = clearBtn:CreateFontString(nil, "OVERLAY")
    clearBtn.text:SetFont(Fonts.family, Fonts.body, "")
    clearBtn.text:SetPoint("CENTER")
    clearBtn.text:SetText("×")
    clearBtn.text:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    clearBtn:Hide()
    clearBtn:SetScript("OnClick", function()
        searchBox:SetText("")
        searchBox:ClearFocus()
    end)
    clearBtn:SetScript("OnEnter", function(self)
        self.text:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    end)
    clearBtn:SetScript("OnLeave", function(self)
        self.text:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    end)

    -- Scroll frame
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, -115, 24)

    -- Sort state (default: sort by min level ascending)
    local sortState = { sortKey = "level", sortAsc = true }

    -- Raw data
    local rawDungeons = Deathless.Data.Dungeons or {}

    -- Expand state: which dungeon is expanded (only one at a time)
    local expandedId = nil

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

    local PopulateRows
    local QUEST_COLOR = { 0.5, 0.7, 0.9 }
    local QUEST_ROW_HEIGHT = 20

    local MAX_REWARD_ICONS = 5
    local ICON_SIZE = 18
    local ICON_SPACING = 2

    -- Quest sub-table column layout
    local QC = {
        nameX = 28,   nameW = 210,
        lvX   = 243,  lvW   = 30,
        startX = 278, startW = 110,
        preX  = 393,  preW  = 45,
        rewX  = 445,
    }
    local QUEST_HEADER_HEIGHT = 16

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
        local SECTION_HEIGHT = 28
        local contentWidth = scrollChild:GetWidth() - 48

        local state = sectionState[dungeon.id]
        if not state then
            state = { warnings = true, quests = true }
            sectionState[dungeon.id] = state
        end

        -- Warnings
        if dungeon.warnings and #dungeon.warnings > 0 then
            local warningLines = {}
            for _, w in ipairs(dungeon.warnings) do
                table.insert(warningLines, "•  " .. w)
            end

            local sec = GetSection()
            sec:ClearAllPoints()
            sec:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
            sec:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -16, yOffset)
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
                    fs:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 32, yOffset)
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
                if not q.side or q.side == playerFaction then
                    table.insert(sortedQuests, q)
                end
            end
            table.sort(sortedQuests, function(a, b) return a.name < b.name end)
        end

        if #sortedQuests > 0 then
            local sec = GetSection()
            sec:ClearAllPoints()
            sec:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
            sec:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -16, yOffset)
            Utils:ConfigureSection(sec, state.quests, "Quests", QUEST_COLOR, #sortedQuests)
            sec:SetScript("OnClick", function()
                state.quests = not state.quests
                PopulateRows()
            end)
            sec:Show()
            yOffset = yOffset - SECTION_HEIGHT

            if state.quests then
                yOffset = yOffset - 4
                -- Column headers
                local headers = { "NAME", "LVL", "STARTS", "PREREQ", "REWARDS" }
                local headerX = { QC.nameX, QC.lvX, QC.startX, QC.preX, QC.rewX }
                local headerW = { QC.nameW, QC.lvW, QC.startW, QC.preW, 80 }
                local headerJ = { "LEFT", "CENTER", "LEFT", "CENTER", "LEFT" }
                for i, h in ipairs(headers) do
                    local hdr = GetText(Fonts.family, Fonts.small)
                    hdr:ClearAllPoints()
                    hdr:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", headerX[i], yOffset)
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
                    qr:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
                    qr:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
                    qr:Show()

                    local nameDisplay = q.name
                    if q.chainStep and q.chainTotal then
                        local dimColor = RGBToEscape(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3])
                        nameDisplay = nameDisplay .. " " .. dimColor .. "(" .. q.chainStep .. "/" .. q.chainTotal .. ")|r"
                    end
                    qr.nameText:SetText(nameDisplay)
                    qr.nameText:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)

                    -- Quest tooltip on name hover
                    local questId = q.questId
                    local questLevel = q.level
                    if questId then
                        qr.nameBtn:SetScript("OnEnter", function(self)
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 4, 0)
                            GameTooltip:SetHyperlink("quest:" .. questId .. ":" .. questLevel)
                            GameTooltip:Show()
                        end)
                        qr.nameBtn:SetScript("OnLeave", function()
                            GameTooltip:Hide()
                        end)
                    else
                        qr.nameBtn:SetScript("OnEnter", nil)
                        qr.nameBtn:SetScript("OnLeave", nil)
                    end

                    -- Level
                    qr.levelText:SetText("Lv " .. q.level)
                    qr.levelText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

                    -- Starts (NPC name with tooltip)
                    if q.startNpc then
                        qr.startsText:SetText(q.startNpc)
                        qr.startsText:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                        local startTip = q.startLoc or ""
                        if q.startCoords then
                            startTip = startTip .. " (" .. q.startCoords .. ")"
                        end
                        qr.startsBtn:SetScript("OnEnter", function(self)
                            Deathless.UI.Tooltip:Show(self, "ANCHOR_RIGHT", startTip)
                        end)
                        qr.startsBtn:SetScript("OnLeave", function()
                            Deathless.UI.Tooltip:Hide()
                        end)
                    else
                        qr.startsText:SetText("")
                        qr.startsBtn:SetScript("OnEnter", nil)
                        qr.startsBtn:SetScript("OnLeave", nil)
                    end

                    -- Prereq
                    if q.prereq then
                        qr.prereqText:SetText(q.prereq)
                        qr.prereqText:SetTextColor(Colors.yellow[1], Colors.yellow[2], Colors.yellow[3], 1)
                    else
                        qr.prereqText:SetText("-")
                        qr.prereqText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                    end

                    -- Rewards: item icons or money
                    for i = 1, MAX_REWARD_ICONS do
                        qr.rewardIcons[i]:Hide()
                    end
                    qr.moneyText:SetText("")
                    qr.moneyText:Hide()

                    if q.rewards and #q.rewards > 0 then
                        for i, r in ipairs(q.rewards) do
                            if i > MAX_REWARD_ICONS then break end
                            local icon = qr.rewardIcons[i]
                            local itemId = r.itemId

                            icon.tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

                            local item = Item:CreateFromItemID(itemId)
                            item:ContinueOnItemLoad(function()
                                local _, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(itemId)
                                if itemTexture then
                                    icon.tex:SetTexture(itemTexture)
                                end
                            end)

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
                    elseif q.money and q.money > 0 then
                        local FormatMoney = Deathless.Utils.Abilities.FormatMoneyColored
                        qr.moneyText:SetText(FormatMoney(q.money))
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
        local ROW_HEIGHT = 26
        local isExpanded = (expandedId == dungeon.id)

        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
        row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
        row:SetHeight(ROW_HEIGHT)
        row:Show()

        -- Alternating row background
        if not row.bg then
            row.bg = row:CreateTexture(nil, "BACKGROUND")
            row.bg:SetAllPoints()
        end
        if isExpanded then
            row.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.4)
            row.bg:Show()
        elseif rowNum % 2 == 0 then
            row.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.2)
            row.bg:Show()
        else
            row.bg:Hide()
        end

        -- Hover highlight
        if not row.highlight then
            row.highlight = row:CreateTexture(nil, "HIGHLIGHT")
            row.highlight:SetAllPoints()
            row.highlight:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.08)
        end

        -- Expand indicator
        local expandIcon = row:CreateFontString(nil, "OVERLAY")
        expandIcon:SetFont(Fonts.icons, Fonts.small, "")
        expandIcon:SetPoint("LEFT", row, "LEFT", 4, 0)
        expandIcon:SetText(isExpanded and "▼" or "►")
        expandIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        row.elements.expandIcon = expandIcon

        -- Level Range (each number colored by difficulty)
        local playerLevel = UnitLevel("player") or 60
        local minC = GetDifficultyColor(dungeon.levelMin, playerLevel)
        local maxC = GetDifficultyColor(dungeon.levelMax, playerLevel)
        local dashColor = RGBToEscape(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3])
        local levelText = RGBToEscape(minC[1], minC[2], minC[3]) .. dungeon.levelMin .. "|r"
            .. dashColor .. "-|r"
            .. RGBToEscape(maxC[1], maxC[2], maxC[3]) .. dungeon.levelMax .. "|r"

        local level = row:CreateFontString(nil, "OVERLAY")
        level:SetFont(Fonts.family, Fonts.body, "")
        level:SetPoint("LEFT", row, "LEFT", 16, 0)
        level:SetWidth(50)
        level:SetJustifyH("CENTER")
        level:SetText(levelText)
        row.elements.level = level

        -- Name
        local name = row:CreateFontString(nil, "OVERLAY")
        name:SetFont(Fonts.family, Fonts.body, "")
        name:SetPoint("LEFT", row, "LEFT", 75, 0)
        name:SetWidth(170)
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
        zone:SetPoint("LEFT", row, "LEFT", 250, 0)
        zone:SetWidth(130)
        zone:SetJustifyH("LEFT")
        zone:SetText(dungeon.zone)
        local playerFac = UnitFactionGroup("player") or ""
        local territory = ZONE_TERRITORY[dungeon.zone] or "Contested"
        local zoneColor
        if territory == playerFac then
            zoneColor = Colors.accent
        elseif territory == "Contested" then
            zoneColor = Colors.yellow
        else
            zoneColor = Colors.red
        end
        zone:SetTextColor(zoneColor[1], zoneColor[2], zoneColor[3], 1)
        row.elements.zone = zone

        -- End Boss (Name + level), colored by difficulty
        local bossC = GetDifficultyColor(dungeon.bossLevel, playerLevel)
        local boss = row:CreateFontString(nil, "OVERLAY")
        boss:SetFont(Fonts.family, Fonts.body, "")
        boss:SetPoint("LEFT", row, "LEFT", 390, 0)
        boss:SetWidth(190)
        boss:SetJustifyH("LEFT")
        boss:SetText(dungeon.endBoss .. " (" .. dungeon.bossLevel .. ")")
        boss:SetTextColor(bossC[1], bossC[2], bossC[3], 1)
        row.elements.boss = boss

        -- Click toggles expand
        row:SetScript("OnClick", function()
            if expandedId == dungeon.id then
                expandedId = nil
            else
                expandedId = dungeon.id
            end
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
        for _, dungeon in ipairs(rawDungeons) do
            if not hasSearch
                or dungeon.name:lower():find(searchTerm, 1, true)
                or dungeon.zone:lower():find(searchTerm, 1, true)
                or dungeon.endBoss:lower():find(searchTerm, 1, true) then
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

    headers.level = CreateSortableHeader(container, "LEVEL (?)",        16,  50,  "level", sortState, OnSort, {
        title = "Dungeon Level Range",
        "Level range where a player can",
        "receive XP from some of the mobs.",
    })
    headers.name  = CreateSortableHeader(container, "NAME",         75,  170, "name",  sortState, OnSort)
    headers.zone  = CreateSortableHeader(container, "ZONE (?)",         250, 130, "zone",  sortState, OnSort, {
        title = "Zone Territory",
        "|cff66cc66Green|r - Friendly territory",
        "|cffffcc33Yellow|r - Contested territory",
        "|cffcc4d4dRed|r - Enemy territory",
    })
    headers.boss  = CreateSortableHeader(container, "END BOSS (?)", 390, 190, "boss",  sortState, OnSort, {
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
        Refresh = PopulateRows,
    }
end)
