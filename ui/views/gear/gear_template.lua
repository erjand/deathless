local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

Deathless.UI.Views.GearTemplate = {}

-- WoW item rarity colors
local RARITY_COLORS = {
    poor      = { 0.62, 0.62, 0.62 },
    common    = { 1.00, 1.00, 1.00 },
    uncommon  = { 0.12, 1.00, 0.00 },
    rare      = { 0.00, 0.44, 0.87 },
    epic      = { 0.64, 0.21, 0.93 },
    legendary = { 1.00, 0.50, 0.00 },
}

-- Empty equipment slot textures (match character panel grey icons)
local SLOT_ICONS = {
    Weapon    = "Interface\\PaperDoll\\UI-PaperDoll-Slot-MainHand",
    Shield    = "Interface\\PaperDoll\\UI-PaperDoll-Slot-SecondaryHand",
    Ranged    = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Ranged",
    Armor     = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest",
    Misc      = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket",
    Head      = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Head",
    Shoulders = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Shoulder",
    Chest     = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest",
    Wrist     = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Wrists",
    Hands     = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Hands",
    Waist     = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Waist",
    Legs      = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Legs",
    Feet      = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Feet",
    Neck      = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Neck",
    Ring      = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Finger",
    Trinket   = "Interface\\PaperDoll\\UI-PaperDoll-Slot-Trinket",
}

-- Column layout
local COL = {
    name   = { x = 16,  w = 190 },
    type   = { x = 210, w = 65 },
    lvl    = { x = 280, w = 36 },
    source = { x = 322, w = 210 },
}

--- Create a sortable column header button
local function CreateSortableHeader(parent, label, col, sortKey, state, onSort, headerY)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts

    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(col.w, 18)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", col.x, headerY)

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
    end)
    btn:SetScript("OnLeave", function(self)
        if state.sortKey == sortKey then
            self.label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
        else
            self.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        end
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

--- Add a slot icon texture to a frame, repositioning the arrow and label
local function AttachSlotIcon(frame, iconKey)
    if not frame.slotIcon then
        frame.slotIcon = frame:CreateTexture(nil, "ARTWORK")
        frame.slotIcon:SetSize(16, 16)
    end

    local texture = SLOT_ICONS[iconKey]
    if texture then
        frame.slotIcon:SetTexture(texture)
        frame.slotIcon:SetDesaturated(true)
        frame.slotIcon:SetAlpha(0.8)
        frame.slotIcon:Show()
    else
        frame.slotIcon:Hide()
    end
end

--- Create a gear view for a specific class
---@param config table { viewName, className, classId, classColor }
function Deathless.UI.Views.GearTemplate:Create(config)
    local viewName = config.viewName
    local className = config.className
    local classColor = config.classColor

    Deathless.UI.Views:Register(viewName, function(container, options)
        local Colors = Utils:GetColors()
        local Fonts = Deathless.UI.Fonts
        local embedded = options and options.embedded

        local title, subtitle
        if not embedded then
            title, subtitle = Utils:CreateHeader(container, className .. " Gear", "Equipment progression for Hardcore", classColor)
        end

        local searchBoxY = embedded and -16 or -52
        local sortHeaderY = embedded and -59 or -95
        local scrollTopOffset = embedded and -79 or -115

        -- Search state
        local searchState = { term = "" }

        -- Search bar
        local searchBox = CreateFrame("EditBox", nil, container, "InputBoxTemplate")
        searchBox:SetSize(180, 20)
        searchBox:SetPoint("TOPLEFT", container, "TOPLEFT", 24, searchBoxY)
        searchBox:SetFont(Fonts.family, Fonts.body, "")
        searchBox:SetAutoFocus(false)
        searchBox:SetMaxLetters(50)
        searchBox:SetTextInsets(4, 20, 0, 0)

        local searchLabel = container:CreateFontString(nil, "OVERLAY")
        searchLabel:SetFont(Fonts.family, Fonts.small, "")
        searchLabel:SetPoint("BOTTOMLEFT", searchBox, "TOPLEFT", 2, 2)
        searchLabel:SetText("Search")
        searchLabel:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

        local clearBtn = CreateFrame("Button", nil, searchBox)
        clearBtn:SetSize(16, 16)
        clearBtn:SetPoint("RIGHT", searchBox, "RIGHT", -2, 0)
        clearBtn:SetNormalFontObject("GameFontNormalSmall")
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
        local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, scrollTopOffset, 24)

        -- Sort state
        local sortState = { sortKey = "lvl", sortAsc = true }

        -- Section collapse state (all collapsed by default)
        local sectionState = { weapons = false, shields = false, ranged = false, armor = false, misc = false }

        -- Build gear data by filtering shared item pools for this class
        local SECTION_DATA = {
            weapons = Deathless.Data.Gear.Weapons,
            shields = Deathless.Data.Gear.Shields,
            ranged  = Deathless.Data.Gear.Ranged,
            armor   = Deathless.Data.Gear.Armor,
            misc    = Deathless.Data.Gear.Misc,
        }

        local gearData = {}
        for key, items in pairs(SECTION_DATA) do
            gearData[key] = {}
            if items then
                for _, item in ipairs(items) do
                    if item.classes and tContains(item.classes, className) then
                        table.insert(gearData[key], item)
                    end
                end
            end
        end

        -- Element pools
        local rowPool = {}
        local sectionPool = {}
        local subSectionPool = {}
        local poolIndex = 0
        local sectionIndex = 0
        local subSectionIndex = 0

        -- Sub-section collapse state (collapsed by default)
        local subSectionState = {}

        local function ClearElements()
            for _, row in ipairs(rowPool) do
                row:Hide()
                row:ClearAllPoints()
            end
            for _, section in ipairs(sectionPool) do
                section:Hide()
                section:ClearAllPoints()
            end
            for _, sub in ipairs(subSectionPool) do
                sub:Hide()
                sub:ClearAllPoints()
            end
            poolIndex = 0
            sectionIndex = 0
            subSectionIndex = 0
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

        local function GetSubSectionHeader()
            subSectionIndex = subSectionIndex + 1
            local sub = subSectionPool[subSectionIndex]
            if not sub then
                sub = Utils:CreateCollapsibleSubSection(scrollChild)
                subSectionPool[subSectionIndex] = sub
            end
            return sub
        end

        local function GetRow()
            poolIndex = poolIndex + 1
            local row = rowPool[poolIndex]
            if not row then
                row = CreateFrame("Frame", nil, scrollChild)
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

        local function SortItems(items)
            local sorted = {}
            for _, item in ipairs(items) do
                table.insert(sorted, item)
            end

            local key = sortState.sortKey
            local asc = sortState.sortAsc

            table.sort(sorted, function(a, b)
                local valA, valB

                if key == "name" then
                    valA, valB = a.name, b.name
                elseif key == "type" then
                    valA, valB = a.type, b.type
                elseif key == "lvl" then
                    valA, valB = a.levelReq or 0, b.levelReq or 0
                elseif key == "source" then
                    valA, valB = a.source, b.source
                else
                    valA, valB = a.levelReq or 0, b.levelReq or 0
                end

                if asc then return valA < valB else return valA > valB end
            end)

            return sorted
        end

        local playerFaction = UnitFactionGroup("player") or ""

        local function FilterItems(items)
            local searchTerm = searchState.term:lower()
            local filtered = {}
            for _, item in ipairs(items) do
                -- Faction filter
                if item.faction and item.faction ~= playerFaction then
                    -- skip
                elseif searchTerm == "" then
                    table.insert(filtered, item)
                elseif item.name:lower():find(searchTerm, 1, true)
                    or item.type:lower():find(searchTerm, 1, true)
                    or item.source:lower():find(searchTerm, 1, true)
                    or (item.slot and item.slot:lower():find(searchTerm, 1, true)) then
                    table.insert(filtered, item)
                end
            end
            return filtered
        end

        local function CreateItemRowAt(item, yOffset, rowNum, indent)
            local row = GetRow()
            local ROW_HEIGHT = 26
            indent = indent or 0

            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
            row:SetHeight(ROW_HEIGHT)
            row:Show()

            -- Item tooltip on hover
            row:EnableMouse(true)
            row:SetScript("OnEnter", function(self)
                if item.itemId then
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 8, 0)
                    GameTooltip:SetItemByID(item.itemId)
                    GameTooltip:Show()
                end
            end)
            row:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)

            -- Alternating row bg
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

            -- Name (rarity colored)
            local rarityColor = RARITY_COLORS[item.rarity] or RARITY_COLORS.common
            local name = row:CreateFontString(nil, "OVERLAY")
            name:SetFont(Fonts.family, Fonts.body, "")
            name:SetPoint("LEFT", row, "LEFT", COL.name.x + indent, 0)
            name:SetWidth(COL.name.w - indent)
            name:SetJustifyH("LEFT")
            name:SetText(item.name)
            name:SetTextColor(rarityColor[1], rarityColor[2], rarityColor[3], 1)
            row.elements.name = name

            -- Type
            local itemType = row:CreateFontString(nil, "OVERLAY")
            itemType:SetFont(Fonts.family, Fonts.body, "")
            itemType:SetPoint("LEFT", row, "LEFT", COL.type.x + indent, 0)
            itemType:SetWidth(COL.type.w)
            itemType:SetJustifyH("LEFT")
            itemType:SetText(item.type)
            itemType:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            row.elements.itemType = itemType

            -- Level req
            local lvl = row:CreateFontString(nil, "OVERLAY")
            lvl:SetFont(Fonts.family, Fonts.body, "")
            lvl:SetPoint("LEFT", row, "LEFT", COL.lvl.x + indent, 0)
            lvl:SetWidth(COL.lvl.w)
            lvl:SetJustifyH("CENTER")
            lvl:SetText(item.levelReq or "-")
            lvl:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            row.elements.lvl = lvl

            -- Source
            local source = row:CreateFontString(nil, "OVERLAY")
            source:SetFont(Fonts.family, Fonts.body, "")
            source:SetPoint("LEFT", row, "LEFT", COL.source.x + indent, 0)
            source:SetWidth(COL.source.w - indent)
            source:SetJustifyH("LEFT")
            source:SetText(item.source or "-")
            source:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            row.elements.source = source

            return yOffset - ROW_HEIGHT
        end

        local PopulateRows

        local function CreateSectionHeaderAt(sectionKey, label, yOffset, color, iconKey)
            local section = GetSectionHeader()
            local SECTION_HEIGHT = 28

            section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
            section:Show()

            -- Slot icon on the section header
            AttachSlotIcon(section, iconKey or label)
            section.slotIcon:ClearAllPoints()
            section.slotIcon:SetPoint("LEFT", section, "LEFT", 8, 0)
            -- Shift the arrow right to make room for the icon
            section.icon:ClearAllPoints()
            section.icon:SetPoint("LEFT", section.slotIcon, "RIGHT", 4, 0)

            Utils:ConfigureSection(section, sectionState[sectionKey], label, color)

            section.sectionKey = sectionKey
            section:SetScript("OnClick", function(self)
                sectionState[self.sectionKey] = not sectionState[self.sectionKey]
                PopulateRows()
            end)

            return yOffset - SECTION_HEIGHT
        end

        local SECTION_DEFS = {
            { key = "weapons", label = "Weapon",  color = { 0.90, 0.65, 0.35 }, grouped = false },
            { key = "shields", label = "Shield",  color = { 0.65, 0.75, 0.85 }, grouped = false },
            { key = "ranged",  label = "Ranged",  color = { 0.70, 0.80, 0.60 }, grouped = false },
            { key = "armor",   label = "Armor",   color = { 0.50, 0.70, 0.90 }, grouped = true, groupBy = "slot",
              groupOrder = { "Head", "Shoulders", "Chest", "Wrist", "Hands", "Waist", "Legs", "Feet" } },
            { key = "misc",    label = "Misc",    color = { 0.75, 0.60, 0.85 }, grouped = true, groupBy = "slot",
              groupOrder = { "Neck", "Ring", "Trinket" } },
        }

        --- Group items by a field, ordered by a predefined list
        local function GroupByField(items, field, order)
            local groups = {}
            for _, item in ipairs(items) do
                local key = item[field] or "Other"
                if not groups[key] then
                    groups[key] = {}
                end
                table.insert(groups[key], item)
            end

            -- Build ordered list: predefined order first, then any extras
            local finalOrder = {}
            local seen = {}
            if order then
                for _, key in ipairs(order) do
                    if groups[key] then
                        table.insert(finalOrder, key)
                        seen[key] = true
                    end
                end
            end
            for key in pairs(groups) do
                if not seen[key] then
                    table.insert(finalOrder, key)
                end
            end

            return groups, finalOrder
        end

        local function CreateSubSectionAt(stateKey, label, yOffset, color)
            local sub = GetSubSectionHeader()
            local SUB_HEIGHT = 22

            sub:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 20, yOffset)
            sub:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
            sub:Show()

            -- Slot icon on the sub-section header
            AttachSlotIcon(sub, label)
            sub.slotIcon:ClearAllPoints()
            sub.slotIcon:SetPoint("LEFT", sub, "LEFT", 0, 0)
            sub.slotIcon:SetSize(14, 14)
            -- Shift the arrow right to make room
            sub.icon:ClearAllPoints()
            sub.icon:SetPoint("LEFT", sub.slotIcon, "RIGHT", 3, 0)

            if subSectionState[stateKey] == nil then
                subSectionState[stateKey] = false
            end

            local expanded = subSectionState[stateKey]
            Utils:ConfigureSubSection(sub, expanded, label, color)

            sub.stateKey = stateKey
            sub:SetScript("OnClick", function(self)
                subSectionState[self.stateKey] = not subSectionState[self.stateKey]
                PopulateRows()
            end)

            return yOffset - SUB_HEIGHT
        end

        PopulateRows = function()
            ClearElements()

            local yOffset = 0
            local rowNum = 0

            for _, def in ipairs(SECTION_DEFS) do
                local raw = gearData[def.key] or {}
                local items = FilterItems(raw)

                if #items > 0 then
                    items = SortItems(items)
                    yOffset = CreateSectionHeaderAt(def.key, def.label, yOffset, def.color)

                    if sectionState[def.key] then
                        if def.grouped then
                            local groups, order = GroupByField(items, def.groupBy, def.groupOrder)
                            for _, groupName in ipairs(order) do
                                local groupItems = groups[groupName]
                                local stateKey = def.key .. ":" .. groupName
                                yOffset = CreateSubSectionAt(stateKey, groupName, yOffset, def.color)

                                if subSectionState[stateKey] then
                                    for _, item in ipairs(groupItems) do
                                        rowNum = rowNum + 1
                                        yOffset = CreateItemRowAt(item, yOffset, rowNum, 16)
                                    end
                                end
                            end
                        else
                            for _, item in ipairs(items) do
                                rowNum = rowNum + 1
                                yOffset = CreateItemRowAt(item, yOffset, rowNum)
                            end
                        end
                    end
                end
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
        searchBox:SetScript("OnEscapePressed", function(self)
            self:SetText("")
            self:ClearFocus()
        end)
        searchBox:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()
        end)

        -- Create sortable column headers
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

        headers.name   = CreateSortableHeader(container, "NAME",   COL.name,   "name",   sortState, OnSort, sortHeaderY)
        headers.type   = CreateSortableHeader(container, "TYPE",   COL.type,   "type",   sortState, OnSort, sortHeaderY)
        headers.lvl    = CreateSortableHeader(container, "LVL",    COL.lvl,    "lvl",    sortState, OnSort, sortHeaderY)
        headers.source = CreateSortableHeader(container, "SOURCE", COL.source, "source", sortState, OnSort, sortHeaderY)

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
end

-- Auto-register gear views for all classes
local CLASS_GEAR_CONFIGS = {
    { viewName = "druid_gear",   className = "Druid",   classColor = { 1.00, 0.49, 0.04 } },
    { viewName = "hunter_gear",  className = "Hunter",  classColor = { 0.67, 0.83, 0.45 } },
    { viewName = "mage_gear",    className = "Mage",    classColor = { 0.25, 0.78, 0.92 } },
    { viewName = "paladin_gear", className = "Paladin", classColor = { 0.96, 0.55, 0.73 } },
    { viewName = "priest_gear",  className = "Priest",  classColor = { 1.00, 1.00, 1.00 } },
    { viewName = "rogue_gear",   className = "Rogue",   classColor = { 1.00, 0.96, 0.41 } },
    { viewName = "shaman_gear",  className = "Shaman",  classColor = { 0.00, 0.44, 0.87 } },
    { viewName = "warlock_gear", className = "Warlock", classColor = { 0.53, 0.53, 0.93 } },
    { viewName = "warrior_gear", className = "Warrior", classColor = { 0.78, 0.61, 0.43 } },
}

for _, cfg in ipairs(CLASS_GEAR_CONFIGS) do
    Deathless.UI.Views.GearTemplate:Create(cfg)
end
