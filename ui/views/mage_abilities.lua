local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

local CLASS_COLOR = { 0.41, 0.80, 0.94 } -- Mage blue

--- Format copper amount as gold/silver/copper string
---@param copper number Amount in copper
---@return string Formatted string
local function FormatMoney(copper)
    if copper == 0 then return "Free" end
    
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local cop = copper % 100
    
    local parts = {}
    if gold > 0 then table.insert(parts, gold .. "g") end
    if silver > 0 then table.insert(parts, silver .. "s") end
    if cop > 0 then table.insert(parts, cop .. "c") end
    
    return table.concat(parts, " ")
end

--- Check if a spell is known by searching the spellbook
---@param spellName string The spell name to check
---@param spellRank number|nil Optional rank to match
---@return boolean Whether the spell is known
local function IsSpellKnown(spellName, spellRank)
    local i = 1
    while true do
        local name, rank = GetSpellBookItemName(i, BOOKTYPE_SPELL)
        if not name then break end
        
        if name == spellName then
            if not spellRank or spellRank == 1 then
                return true
            end
            local rankNum = rank and tonumber(rank:match("%d+"))
            if rankNum and rankNum >= spellRank then
                return true
            end
        end
        i = i + 1
    end
    return false
end

--- Create a sortable column header button
---@param parent Frame Parent frame
---@param label string Header text
---@param xOffset number X position offset
---@param width number Button width
---@param sortKey string The key to sort by
---@param state table Shared sort state
---@param onSort function Callback when sort changes
---@return Button The header button
local function CreateSortableHeader(parent, label, xOffset, width, sortKey, state, onSort)
    local Colors = Utils:GetColors()
    
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(width, 18)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, -75)
    
    btn.label = btn:CreateFontString(nil, "OVERLAY")
    btn.label:SetFont("Fonts\\ARIALN.TTF", 10, "")
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
    
    btn:SetScript("OnClick", function(self)
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

--- Mage Abilities view
Deathless.UI.Views:Register("mage_abilities", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle = Utils:CreateHeader(container, "Mage Abilities", "All trainable abilities with costs and levels", CLASS_COLOR)
    
    -- Scroll frame for abilities list
    local scrollFrame = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", container, "TOPLEFT", 8, -95)
    scrollFrame:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -28, 24)
    
    local scrollBar = scrollFrame.ScrollBar
    if scrollBar then
        scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 4, -16)
        scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 4, 16)
    end
    
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)
    
    -- Smooth scrolling
    local targetScroll = 0
    local SCROLL_SPEED = 1.2
    local SCROLL_STEP = 40
    
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local maxScroll = scrollChild:GetHeight() - scrollFrame:GetHeight()
        if maxScroll < 0 then maxScroll = 0 end
        targetScroll = targetScroll - (delta * SCROLL_STEP)
        targetScroll = math.max(0, math.min(targetScroll, maxScroll))
    end)
    
    scrollFrame:SetScript("OnUpdate", function(self, elapsed)
        local current = self:GetVerticalScroll()
        if math.abs(current - targetScroll) > 0.5 then
            local newScroll = current + (targetScroll - current) * SCROLL_SPEED
            self:SetVerticalScroll(newScroll)
        elseif current ~= targetScroll then
            self:SetVerticalScroll(targetScroll)
        end
    end)
    
    if scrollBar then
        scrollBar:HookScript("OnValueChanged", function(self, value)
            targetScroll = value
        end)
    end
    
    -- Sort state
    local sortState = { sortKey = "level", sortAsc = true }
    
    -- Section collapse state
    local sectionState = { learned = false, available = true, unavailable = true }
    
    -- Get raw abilities data
    local rawAbilities = Deathless.Data.Abilities and Deathless.Data.Abilities["Mage"] or {}
    
    -- Element pools
    local rowPool = {}
    local sectionPool = {}
    local poolIndex = 0
    local sectionIndex = 0
    
    local function ClearElements()
        for _, row in ipairs(rowPool) do
            row:Hide()
            row:ClearAllPoints()
        end
        for _, section in ipairs(sectionPool) do
            section:Hide()
            section:ClearAllPoints()
        end
        poolIndex = 0
        sectionIndex = 0
    end
    
    local function GetSectionHeader()
        sectionIndex = sectionIndex + 1
        local section = sectionPool[sectionIndex]
        if not section then
            section = CreateFrame("Button", nil, scrollChild)
            section:SetHeight(28)
            
            section.bg = section:CreateTexture(nil, "BACKGROUND")
            section.bg:SetAllPoints()
            section.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.6)
            
            section.icon = section:CreateFontString(nil, "OVERLAY")
            section.icon:SetFont("Fonts\\ARIALN.TTF", 12, "")
            section.icon:SetPoint("LEFT", section, "LEFT", 8, 0)
            
            section.label = section:CreateFontString(nil, "OVERLAY")
            section.label:SetFont("Fonts\\ARIALN.TTF", 12, "")
            section.label:SetPoint("LEFT", section.icon, "RIGHT", 6, 0)
            
            section.count = section:CreateFontString(nil, "OVERLAY")
            section.count:SetFont("Fonts\\ARIALN.TTF", 11, "")
            section.count:SetPoint("LEFT", section.label, "RIGHT", 8, 0)
            section.count:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            section:SetScript("OnEnter", function(self)
                self.bg:SetColorTexture(Colors.bgLight[1] + 0.05, Colors.bgLight[2] + 0.05, Colors.bgLight[3] + 0.05, 0.8)
            end)
            section:SetScript("OnLeave", function(self)
                self.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.6)
            end)
            
            sectionPool[sectionIndex] = section
        end
        return section
    end
    
    local function GetAbilityRow()
        poolIndex = poolIndex + 1
        local row = rowPool[poolIndex]
        if not row then
            row = CreateFrame("Frame", nil, scrollChild)
            rowPool[poolIndex] = row
        end
        
        if row.elements then
            for _, element in pairs(row.elements) do
                if element.Hide then element:Hide() end
            end
        end
        row.elements = {}
        return row
    end
    
    local function SortAbilities(abilities)
        local sorted = {}
        for _, ability in ipairs(abilities) do
            table.insert(sorted, ability)
        end
        
        local key = sortState.sortKey
        local asc = sortState.sortAsc
        
        table.sort(sorted, function(a, b)
            local valA, valB
            
            if key == "name" then
                if a.name == b.name then
                    valA, valB = a.rank or 1, b.rank or 1
                else
                    valA, valB = a.name, b.name
                end
            elseif key == "level" then
                valA, valB = a.level, b.level
            elseif key == "cost" then
                valA, valB = a.base_cost, b.base_cost
            elseif key == "source" then
                valA, valB = a.source, b.source
            else
                valA, valB = a.level, b.level
            end
            
            if asc then
                return valA < valB
            else
                return valA > valB
            end
        end)
        
        return sorted
    end
    
    local function CreateAbilityRowAt(ability, yOffset, rowNum, dimmed)
        local row = GetAbilityRow()
        local ROW_HEIGHT = 26
        
        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
        row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
        row:SetHeight(ROW_HEIGHT)
        row:Show()
        
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
        
        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetSize(18, 18)
        icon:SetPoint("LEFT", row, "LEFT", 16, 0)
        icon:SetTexture("Interface\\Icons\\" .. (ability.icon or "INV_Misc_QuestionMark"))
        icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        if dimmed then
            icon:SetDesaturated(true)
            icon:SetAlpha(0.5)
        else
            icon:SetDesaturated(false)
            icon:SetAlpha(1)
        end
        row.elements.icon = icon
        
        local nameText = ability.name
        if ability.rank and ability.rank > 1 then
            nameText = nameText .. " (Rank " .. ability.rank .. ")"
        end
        
        local name = row:CreateFontString(nil, "OVERLAY")
        name:SetFont("Fonts\\ARIALN.TTF", 11, "")
        name:SetPoint("LEFT", icon, "RIGHT", 8, 0)
        name:SetWidth(190)
        name:SetJustifyH("LEFT")
        name:SetText(nameText)
        if dimmed then
            name:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.6)
        else
            name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        end
        row.elements.name = name
        
        local level = row:CreateFontString(nil, "OVERLAY")
        level:SetFont("Fonts\\ARIALN.TTF", 11, "")
        level:SetPoint("LEFT", row, "LEFT", 250, 0)
        level:SetWidth(50)
        level:SetJustifyH("CENTER")
        level:SetText("Lv " .. ability.level)
        if dimmed then
            level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.6)
        else
            level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        end
        row.elements.level = level
        
        local cost = row:CreateFontString(nil, "OVERLAY")
        cost:SetFont("Fonts\\ARIALN.TTF", 11, "")
        cost:SetPoint("LEFT", row, "LEFT", 310, 0)
        cost:SetWidth(80)
        cost:SetJustifyH("RIGHT")
        cost:SetText(FormatMoney(ability.base_cost))
        if ability.base_cost == 0 then
            cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], dimmed and 0.6 or 1)
        else
            cost:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], dimmed and 0.6 or 1)
        end
        row.elements.cost = cost
        
        local source = row:CreateFontString(nil, "OVERLAY")
        source:SetFont("Fonts\\ARIALN.TTF", 11, "")
        source:SetPoint("LEFT", row, "LEFT", 400, 0)
        source:SetWidth(60)
        source:SetJustifyH("LEFT")
        local sourceText = ability.source:sub(1, 1):upper() .. ability.source:sub(2)
        source:SetText(sourceText)
        source:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], dimmed and 0.6 or 1)
        row.elements.source = source
        
        return yOffset - ROW_HEIGHT
    end
    
    local PopulateRows
    
    local function CreateSectionHeaderAt(sectionKey, label, count, yOffset, color)
        local section = GetSectionHeader()
        local SECTION_HEIGHT = 28
        
        section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
        section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
        section:Show()
        
        local isExpanded = sectionState[sectionKey]
        section.icon:SetText(isExpanded and "▼" or "►")
        section.icon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        section.label:SetText(label)
        section.label:SetTextColor(color[1], color[2], color[3], 1)
        
        section.count:SetText("(" .. count .. ")")
        
        section.sectionKey = sectionKey
        section:SetScript("OnClick", function(self)
            sectionState[self.sectionKey] = not sectionState[self.sectionKey]
            PopulateRows()
        end)
        
        return yOffset - SECTION_HEIGHT
    end
    
    local function IsTalentKnown(spellName)
        return IsSpellKnown(spellName, 1)
    end
    
    PopulateRows = function()
        ClearElements()
        
        local playerLevel = UnitLevel("player") or 60
        local _, playerClass = UnitClass("player")
        local isCorrectClass = (playerClass == "MAGE")
        
        local learned = {}
        local available = {}
        local unavailable = {}
        
        for _, ability in ipairs(rawAbilities) do
            if ability.source == "talent" then
                local hasTalent = IsTalentKnown(ability.name)
                if hasTalent then
                    local isKnown = IsSpellKnown(ability.name, ability.rank)
                    if isKnown then
                        table.insert(learned, ability)
                    elseif isCorrectClass and ability.level <= playerLevel then
                        table.insert(available, ability)
                    else
                        table.insert(unavailable, ability)
                    end
                end
            else
                local isKnown = IsSpellKnown(ability.name, ability.rank)
                if isKnown then
                    table.insert(learned, ability)
                elseif isCorrectClass and ability.level <= playerLevel then
                    table.insert(available, ability)
                else
                    table.insert(unavailable, ability)
                end
            end
        end
        
        learned = SortAbilities(learned)
        available = SortAbilities(available)
        unavailable = SortAbilities(unavailable)
        
        local yOffset = 0
        local rowNum = 0
        
        local learnedColor = { 0.5, 0.5, 0.5 }
        local availableColor = Colors.accent
        local unavailableColor = { 0.6, 0.4, 0.4 }
        
        if #learned > 0 then
            yOffset = CreateSectionHeaderAt("learned", "Learned", #learned, yOffset, learnedColor)
            if sectionState.learned then
                for _, ability in ipairs(learned) do
                    rowNum = rowNum + 1
                    yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, true)
                end
            end
        end
        
        if #available > 0 then
            yOffset = CreateSectionHeaderAt("available", "Available", #available, yOffset, availableColor)
            if sectionState.available then
                for _, ability in ipairs(available) do
                    rowNum = rowNum + 1
                    yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, false)
                end
            end
        end
        
        if #unavailable > 0 then
            yOffset = CreateSectionHeaderAt("unavailable", "Unavailable", #unavailable, yOffset, unavailableColor)
            if sectionState.unavailable then
                for _, ability in ipairs(unavailable) do
                    rowNum = rowNum + 1
                    yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, true)
                end
            end
        end
        
        scrollChild:SetHeight(math.abs(yOffset) + 10)
    end
    
    -- Create headers
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
    
    headers.name = CreateSortableHeader(container, "ABILITY", 36, 200, "name", sortState, OnSort)
    headers.level = CreateSortableHeader(container, "LEVEL", 250, 50, "level", sortState, OnSort)
    headers.cost = CreateSortableHeader(container, "COST", 310, 80, "cost", sortState, OnSort)
    headers.source = CreateSortableHeader(container, "SOURCE", 400, 60, "source", sortState, OnSort)
    
    OnSort()
    
    return { 
        title = title, 
        subtitle = subtitle, 
        scrollFrame = scrollFrame, 
        scrollChild = scrollChild,
        headers = headers,
        Refresh = PopulateRows
    }
end)

