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

--- Dungeons view - sortable/searchable dungeon list
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

    -- Row pool
    local rowPool = {}
    local poolIndex = 0

    local function ClearRows()
        for _, row in ipairs(rowPool) do
            row:Hide()
            row:ClearAllPoints()
        end
        poolIndex = 0
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

    local function CreateRowAt(dungeon, yOffset, rowNum)
        local row = GetRow()
        local ROW_HEIGHT = 26

        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
        row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
        row:SetHeight(ROW_HEIGHT)
        row:Show()

        -- Alternating row background
        if not row.bg then
            row.bg = row:CreateTexture(nil, "BACKGROUND")
            row.bg:SetAllPoints()
        end
        if rowNum % 2 == 0 then
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

        -- Name (clickable feel)
        local name = row:CreateFontString(nil, "OVERLAY")
        name:SetFont(Fonts.family, Fonts.body, "")
        name:SetPoint("LEFT", row, "LEFT", 75, 0)
        name:SetWidth(170)
        name:SetJustifyH("LEFT")
        name:SetText(dungeon.name)
        name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        row.elements.name = name

        -- Zone
        local zone = row:CreateFontString(nil, "OVERLAY")
        zone:SetFont(Fonts.family, Fonts.body, "")
        zone:SetPoint("LEFT", row, "LEFT", 250, 0)
        zone:SetWidth(130)
        zone:SetJustifyH("LEFT")
        zone:SetText(dungeon.zone)
        zone:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
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

        -- Click handler (placeholder for future dungeon detail navigation)
        row:SetScript("OnClick", function()
            -- TODO: Navigate to dungeon detail view
        end)

        return yOffset - ROW_HEIGHT
    end

    local function PopulateRows()
        ClearRows()

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

    headers.level = CreateSortableHeader(container, "LEVEL",        16,  50,  "level", sortState, OnSort)
    headers.name  = CreateSortableHeader(container, "NAME",         75,  170, "name",  sortState, OnSort)
    headers.zone  = CreateSortableHeader(container, "ZONE",         250, 130, "zone",  sortState, OnSort)
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
