local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local UIUtils = Deathless.Utils.UI

Deathless.UI.Views.GearTemplate = {}

-- WoW item rarity colors
local RARITY_COLORS = Deathless.Constants.Colors.ItemRarity

local function GetEmptySlotTexture(slotName, fallbackTexture)
    local _, texture = GetInventorySlotInfo(slotName)
    return texture or fallbackTexture
end

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
    Back      = GetEmptySlotTexture("BackSlot", "Interface\\PaperDoll\\UI-PaperDoll-Slot-Chest"),
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
local ICON_SIZE = Deathless.Constants.Colors.UI.Icon.sizeMedium
local ICON_PAD = 4
local COL = {
    name   = { x = 16,  w = 190 },
    type   = { x = 210, w = 65 },
    lvl    = { x = 280, w = 36 },
    source = { x = 322, w = 170 },
    prebis = { x = 496, w = 64 },
}

local GEAR_TIER = (Deathless.Constants and Deathless.Constants.GearTiers) or {
    LEVELING = "Leveling",
    PRE_BIS = "Pre-BiS",
}
local TIER_ORDER = { GEAR_TIER.LEVELING, GEAR_TIER.PRE_BIS }

--- Create a sortable column header button
local function CreateSortableHeader(parent, label, col, sortKey, state, onSort, headerY, tooltip)
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

--- Add a slot icon texture to a frame, repositioning the arrow and label
local function AttachSlotIcon(frame, iconKey)
    if not frame.slotIcon then
        frame.slotIcon = frame:CreateTexture(nil, "ARTWORK")
        local iconStyle = Deathless.Constants.Colors.UI.Icon
        frame.slotIcon:SetSize(iconStyle.sizeLarge, iconStyle.sizeLarge)
    end

    local texture = SLOT_ICONS[iconKey]
    if texture then
        frame.slotIcon:SetTexture(texture)
        UIUtils.ApplyIconStyle(frame.slotIcon, "muted")
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
        local Layout = Utils.Layout
        local IconStyle = Deathless.Constants.Colors.UI.Icon
        local embedded = options and options.embedded
        local CONTENT_LEFT = 12
        local CONTENT_RIGHT = -12

        local title, subtitle
        if not embedded then
            title, subtitle = Utils:CreateHeader(container, className .. " Gear", "Equipment progression for Hardcore", classColor)
        end

        local searchBoxY = embedded and -16 or -52
        local sortHeaderY = embedded and -59 or -95
        local scrollTopOffset = embedded and -79 or -115

        -- Search state
        local searchState = { term = "" }
        local tierFilterState = {}

        -- Load/sanitize persisted tier filters
        Deathless.config.gear = Deathless.config.gear or {}
        Deathless.config.gear.tierFilters = Deathless.config.gear.tierFilters or {}
        for _, tier in ipairs(TIER_ORDER) do
            tierFilterState[tier] = Deathless.config.gear.tierFilters[tier] == true
        end
        if not (tierFilterState[GEAR_TIER.LEVELING] or tierFilterState[GEAR_TIER.PRE_BIS]) then
            tierFilterState[GEAR_TIER.LEVELING] = true
            Deathless.config.gear.tierFilters[GEAR_TIER.LEVELING] = true
            Deathless.config.gear.tierFilters[GEAR_TIER.PRE_BIS] = false
            Deathless:SaveConfig()
        end

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

        local PopulateRows

        -- Tier filter controls
        local tierCheckboxes = {}

        local function SaveTierFilters()
            Deathless.config.gear = Deathless.config.gear or {}
            Deathless.config.gear.tierFilters = Deathless.config.gear.tierFilters or {}
            for _, tier in ipairs(TIER_ORDER) do
                Deathless.config.gear.tierFilters[tier] = tierFilterState[tier] == true
            end
            Deathless:SaveConfig()
        end

        local function UpdateTierCheckboxVisual(button, checked)
            if checked then
                button.check:Show()
                button.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            else
                button.check:Hide()
                button.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            end
        end

        local function CreateTierCheckbox(tier, displayLabel, xOffset)
            local button = CreateFrame("Button", nil, container)
            button:SetSize(108, 20)
            button:SetPoint("LEFT", searchBox, "RIGHT", xOffset, 0)

            button.box = button:CreateTexture(nil, "BACKGROUND")
            button.box:SetSize(14, 14)
            button.box:SetPoint("LEFT", button, "LEFT", 0, 0)
            button.box:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)

            button.border = button:CreateTexture(nil, "BORDER")
            button.border:SetPoint("TOPLEFT", button.box, "TOPLEFT", -1, 1)
            button.border:SetPoint("BOTTOMRIGHT", button.box, "BOTTOMRIGHT", 1, -1)
            button.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)

            button.check = button:CreateTexture(nil, "ARTWORK")
            button.check:SetPoint("TOPLEFT", button.box, "TOPLEFT", 1, -1)
            button.check:SetPoint("BOTTOMRIGHT", button.box, "BOTTOMRIGHT", -1, 1)
            button.check:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)

            button.label = button:CreateFontString(nil, "OVERLAY")
            button.label:SetFont(Fonts.family, Fonts.small, "")
            button.label:SetPoint("LEFT", button.box, "RIGHT", 6, 0)
            button.label:SetText(displayLabel)

            button.tier = tier
            UpdateTierCheckboxVisual(button, tierFilterState[tier] == true)

            button:SetScript("OnEnter", function(self)
                self.border:SetColorTexture(Colors.accent[1] * 0.8, Colors.accent[2] * 0.8, Colors.accent[3] * 0.8, 1)
                self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            end)
            button:SetScript("OnLeave", function(self)
                self.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
                UpdateTierCheckboxVisual(self, tierFilterState[self.tier] == true)
            end)
            button:SetScript("OnClick", function(self)
                tierFilterState[self.tier] = not tierFilterState[self.tier]
                for _, cb in ipairs(tierCheckboxes) do
                    UpdateTierCheckboxVisual(cb, tierFilterState[cb.tier] == true)
                end
                SaveTierFilters()
                if PopulateRows then PopulateRows() end
            end)

            return button
        end

        local levelingCB = CreateTierCheckbox(GEAR_TIER.LEVELING, GEAR_TIER.LEVELING, 16)
        local preBisCB = CreateTierCheckbox(GEAR_TIER.PRE_BIS, GEAR_TIER.PRE_BIS, 130)
        table.insert(tierCheckboxes, levelingCB)
        table.insert(tierCheckboxes, preBisCB)

        -- Scroll frame
        local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, scrollTopOffset, 24)

        -- Sort state
        local sortState = { sortKey = "lvl", sortAsc = true }

        -- Section collapse state (all collapsed by default)
        local sectionState = {}

        -- Build gear data by filtering shared item pools for this class
        local FLAT_SOURCES = {
            { key = "weapons", items = Deathless.Data.Gear.Weapons },
            { key = "shields", items = Deathless.Data.Gear.Shields },
            { key = "ranged",  items = Deathless.Data.Gear.Ranged },
        }

        local gearData = {}
        for _, src in ipairs(FLAT_SOURCES) do
            gearData[src.key] = {}
            sectionState[src.key] = false
            if src.items then
                for _, item in ipairs(src.items) do
                    if item.classes and tContains(item.classes, className) then
                        table.insert(gearData[src.key], item)
                    end
                end
            end
        end

        -- Split armor and misc items into per-slot sections
        local SLOT_SOURCES = {
            { items = Deathless.Data.Gear.ArmorHead },
            { items = Deathless.Data.Gear.ArmorShoulders },
            { items = Deathless.Data.Gear.ArmorChest },
            { items = Deathless.Data.Gear.ArmorWrist },
            { items = Deathless.Data.Gear.ArmorHands },
            { items = Deathless.Data.Gear.ArmorWaist },
            { items = Deathless.Data.Gear.ArmorLegs },
            { items = Deathless.Data.Gear.ArmorFeet },
            { items = Deathless.Data.Gear.Back },
            { items = Deathless.Data.Gear.Rings },
            { items = Deathless.Data.Gear.Trinkets },
            { items = Deathless.Data.Gear.Amulets },
        }
        for _, src in ipairs(SLOT_SOURCES) do
            if src.items then
                for _, item in ipairs(src.items) do
                    if item.classes and tContains(item.classes, className) then
                        local slot = item.slot or "Other"
                        local key = "slot:" .. slot
                        if not gearData[key] then
                            gearData[key] = {}
                            sectionState[key] = false
                        end
                        table.insert(gearData[key], item)
                    end
                end
            end
        end

        -- Element pools
        local rowPool = {}
        local sectionPool = {}
        local dividerPool = {}
        local poolIndex = 0
        local sectionIndex = 0
        local dividerIndex = 0

        local function ClearElements()
            for _, row in ipairs(rowPool) do
                row:Hide()
                row:ClearAllPoints()
            end
            for _, section in ipairs(sectionPool) do
                section:Hide()
                section:ClearAllPoints()
            end
            for _, div in ipairs(dividerPool) do
                div:Hide()
                div:ClearAllPoints()
            end
            poolIndex = 0
            sectionIndex = 0
            dividerIndex = 0
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
            if row.itemIcon then row.itemIcon:Hide() end
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
                elseif key == "prebis" then
                    local function IsPreBis(item)
                        if not item.tiers then return false end
                        for _, tier in ipairs(item.tiers) do
                            if tier == GEAR_TIER.PRE_BIS then return true end
                        end
                        return false
                    end
                    valA, valB = IsPreBis(a) and 1 or 0, IsPreBis(b) and 1 or 0
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
                else
                    local tiers = item.tiers
                    local tierMatch = false
                    if tiers and #tiers > 0 then
                        for _, tier in ipairs(tiers) do
                            if tierFilterState[tier] then
                                tierMatch = true
                                break
                            end
                        end
                    else
                        -- Backward compatibility: items without explicit tiers are leveling items.
                        tierMatch = tierFilterState[GEAR_TIER.LEVELING] == true
                    end

                    if not tierMatch then
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
            end
            return filtered
        end

        local function CreateItemRowAt(item, yOffset, rowNum, indent)
            local row = GetRow()
            local ROW_HEIGHT = 26
            indent = indent or 0

            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
            row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
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
            UIUtils.ApplyStripedRowBackground(row, Colors, rowNum)

            -- Item icon
            local iconX = COL.name.x + indent
            if item.itemId then
                if not row.itemIcon then
                    row.itemIcon = row:CreateTexture(nil, "ARTWORK")
                    row.itemIcon:SetSize(IconStyle.sizeMedium, IconStyle.sizeMedium)
                end
                row.itemIcon:ClearAllPoints()
                row.itemIcon:SetPoint("LEFT", row, "LEFT", iconX, 0)
                row.itemIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                row.itemIcon:Show()

                local iconBtn = row.itemIcon
                local itemObj = Item:CreateFromItemID(item.itemId)
                itemObj:ContinueOnItemLoad(function()
                    local _, _, _, _, _, _, _, _, _, tex = GetItemInfo(item.itemId)
                    if tex and iconBtn then
                        iconBtn:SetTexture(tex)
                    end
                end)
            elseif row.itemIcon then
                row.itemIcon:Hide()
            end

            -- Name (rarity colored)
            local nameX = item.itemId and (iconX + ICON_SIZE + ICON_PAD) or (iconX)
            local rarityColor = RARITY_COLORS[item.rarity] or RARITY_COLORS.common
            local name = row:CreateFontString(nil, "OVERLAY")
            name:SetFont(Fonts.family, Fonts.body, "")
            name:SetPoint("LEFT", row, "LEFT", nameX, 0)
            name:SetWidth(COL.name.w - indent - (item.itemId and (ICON_SIZE + ICON_PAD) or 0))
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

            -- Pre-BiS marker
            local isPreBis = false
            if item.tiers then
                for _, tier in ipairs(item.tiers) do
                    if tier == GEAR_TIER.PRE_BIS then
                        isPreBis = true
                        break
                    end
                end
            end
            local preBis = row:CreateFontString(nil, "OVERLAY")
            preBis:SetFont(Fonts.family, Fonts.body, "")
            preBis:SetPoint("LEFT", row, "LEFT", COL.prebis.x + indent, 0)
            preBis:SetWidth(COL.prebis.w)
            preBis:SetJustifyH("CENTER")
            if isPreBis then
                preBis:SetText("Yes")
                preBis:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
            else
                preBis:SetText("")
                preBis:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            end
            row.elements.preBis = preBis

            return yOffset - ROW_HEIGHT
        end

        local function CreateSectionHeaderAt(sectionKey, label, count, yOffset, color, iconKey)
            local section = GetSectionHeader()
            local SECTION_HEIGHT = Layout.sectionHeight

            section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
            section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
            section:Show()

            -- Slot icon on the section header
            AttachSlotIcon(section, iconKey or label)
            section.slotIcon:ClearAllPoints()
            section.slotIcon:SetPoint("LEFT", section, "LEFT", 8, 0)
            -- Shift the arrow right to make room for the icon
            section.icon:ClearAllPoints()
            section.icon:SetPoint("LEFT", section.slotIcon, "RIGHT", 4, 0)

            Utils:ConfigureSection(section, sectionState[sectionKey], label, color, count)

            section.sectionKey = sectionKey
            section:SetScript("OnClick", function(self)
                sectionState[self.sectionKey] = not sectionState[self.sectionKey]
                PopulateRows()
            end)

            return yOffset - SECTION_HEIGHT
        end

        local gearColors = Deathless.Constants.Colors.GearSection
        local armorColor = gearColors.armor
        local miscColor = gearColors.misc
        local SECTION_DEFS = {
            { key = "weapons",        label = "Weapon",    color = gearColors.weapons },
            { key = "shields",        label = "Shield",    color = gearColors.shields },
            { key = "ranged",         label = "Ranged",    color = gearColors.ranged },
            { key = "slot:Head",      label = "Head",      color = armorColor, dividerBefore = true, dividerKey = "armor" },
            { key = "slot:Shoulders", label = "Shoulders", color = armorColor, dividerBefore = true, dividerKey = "armor" },
            { key = "slot:Chest",     label = "Chest",     color = armorColor, dividerBefore = true, dividerKey = "armor" },
            { key = "slot:Wrist",     label = "Wrist",     color = armorColor, dividerBefore = true, dividerKey = "armor" },
            { key = "slot:Hands",     label = "Hands",     color = armorColor, dividerBefore = true, dividerKey = "armor" },
            { key = "slot:Waist",     label = "Waist",     color = armorColor, dividerBefore = true, dividerKey = "armor" },
            { key = "slot:Legs",      label = "Legs",      color = armorColor, dividerBefore = true, dividerKey = "armor" },
            { key = "slot:Feet",      label = "Feet",      color = armorColor, dividerBefore = true, dividerKey = "armor" },
            { key = "slot:Back",      label = "Back",      color = miscColor,  dividerBefore = true, dividerKey = "misc" },
            { key = "slot:Neck",      label = "Neck",      color = miscColor,  dividerBefore = true, dividerKey = "misc" },
            { key = "slot:Ring",      label = "Ring",      color = miscColor,  dividerBefore = true, dividerKey = "misc" },
            { key = "slot:Trinket",   label = "Trinket",   color = miscColor,  dividerBefore = true, dividerKey = "misc" },
        }

        local function CreateDividerAt(yOffset)
            local DIVIDER_HEIGHT = 12
            dividerIndex = dividerIndex + 1
            local div = dividerPool[dividerIndex]
            if not div then
                div = CreateFrame("Frame", nil, scrollChild)
                div.line = div:CreateTexture(nil, "ARTWORK")
                div.line:SetHeight(1)
                div.line:SetPoint("LEFT", div, "LEFT", 10, 0)
                div.line:SetPoint("RIGHT", div, "RIGHT", -10, 0)
                div.line:SetColorTexture(Colors.dividerFaint[1], Colors.dividerFaint[2], Colors.dividerFaint[3], Colors.dividerFaint[4])
                dividerPool[dividerIndex] = div
            end
            div:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
            div:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
            div:SetHeight(DIVIDER_HEIGHT)
            div:Show()
            return yOffset - DIVIDER_HEIGHT
        end

        PopulateRows = function()
            ClearElements()

            local yOffset = 0
            local rowNum = 0
            local drawnDividerKeys = {}

            for _, def in ipairs(SECTION_DEFS) do
                local raw = gearData[def.key] or {}
                local items = FilterItems(raw)

                if #items > 0 then
                    if def.dividerBefore then
                        if not def.dividerKey or not drawnDividerKeys[def.dividerKey] then
                            yOffset = CreateDividerAt(yOffset)
                            if def.dividerKey then
                                drawnDividerKeys[def.dividerKey] = true
                            end
                        end
                    end
                    items = SortItems(items)
                    yOffset = CreateSectionHeaderAt(def.key, def.label, #items, yOffset, def.color)

                    if sectionState[def.key] then
                        for _, item in ipairs(items) do
                            rowNum = rowNum + 1
                            yOffset = CreateItemRowAt(item, yOffset, rowNum)
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

        local SCROLL_INSET = 8
        local hName   = { x = COL.name.x   + SCROLL_INSET + ICON_SIZE + ICON_PAD + CONTENT_LEFT, w = COL.name.w - ICON_SIZE - ICON_PAD }
        local hType   = { x = COL.type.x   + SCROLL_INSET + CONTENT_LEFT, w = COL.type.w }
        local hLvl    = { x = COL.lvl.x    + SCROLL_INSET + CONTENT_LEFT, w = COL.lvl.w }
        local hSource = { x = COL.source.x + SCROLL_INSET + CONTENT_LEFT, w = COL.source.w }
        local hPreBis = { x = COL.prebis.x + SCROLL_INSET + CONTENT_LEFT, w = COL.prebis.w }
        headers.name   = CreateSortableHeader(container, "NAME",   hName,   "name",   sortState, OnSort, sortHeaderY)
        headers.type   = CreateSortableHeader(container, "TYPE",   hType,   "type",   sortState, OnSort, sortHeaderY)
        headers.lvl    = CreateSortableHeader(container, "LVL",    hLvl,    "lvl",    sortState, OnSort, sortHeaderY)
        headers.source = CreateSortableHeader(container, "SOURCE", hSource, "source", sortState, OnSort, sortHeaderY)
        headers.prebis = CreateSortableHeader(container, "PRE-BIS (?)", hPreBis, "prebis", sortState, OnSort, sortHeaderY, {
            title = "Pre-BiS",
            "Best-in-Slot gear at level 60 prior to raid content",
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
end

-- Auto-register gear views for all classes
local CLASS_GEAR_CONFIGS = {
    { viewName = "druid_gear",   className = "Druid",   classColor = Deathless.Constants.Colors.Class.druid },
    { viewName = "hunter_gear",  className = "Hunter",  classColor = Deathless.Constants.Colors.Class.hunter },
    { viewName = "mage_gear",    className = "Mage",    classColor = Deathless.Constants.Colors.Class.mage },
    { viewName = "paladin_gear", className = "Paladin", classColor = Deathless.Constants.Colors.Class.paladin },
    { viewName = "priest_gear",  className = "Priest",  classColor = Deathless.Constants.Colors.Class.priest },
    { viewName = "rogue_gear",   className = "Rogue",   classColor = Deathless.Constants.Colors.Class.rogue },
    { viewName = "shaman_gear",  className = "Shaman",  classColor = Deathless.Constants.Colors.Class.shaman },
    { viewName = "warlock_gear", className = "Warlock", classColor = Deathless.Constants.Colors.Class.warlock },
    { viewName = "warrior_gear", className = "Warrior", classColor = Deathless.Constants.Colors.Class.warrior },
}

for _, cfg in ipairs(CLASS_GEAR_CONFIGS) do
    Deathless.UI.Views.GearTemplate:Create(cfg)
end
