local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

-- Store template for reuse
Deathless.UI.Views.AbilitiesTemplate = {}

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

--- Format copper amount with colored g/s/c letters
---@param copper number Amount in copper
---@return string Formatted string with color codes
local function FormatMoneyColored(copper)
    if copper == 0 then return "" end
    
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local cop = copper % 100
    
    local parts = {}
    if gold > 0 then table.insert(parts, gold .. "|cffffd700g|r") end
    if silver > 0 then table.insert(parts, silver .. "|cffc0c0c0s|r") end
    if cop > 0 then table.insert(parts, cop .. "|cffb87333c|r") end
    
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
---@param tooltip table|nil Optional tooltip lines {title, line1, line2, ...}
---@return Button The header button
local function CreateSortableHeader(parent, label, xOffset, width, sortKey, state, onSort, tooltip)
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
        if tooltip then
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:AddLine(tooltip.title or label, 1, 1, 1)
            for _, line in ipairs(tooltip) do
                GameTooltip:AddLine(line, 0.8, 0.8, 0.8, true)
            end
            GameTooltip:Show()
        end
    end)
    
    btn:SetScript("OnLeave", function(self)
        if state.sortKey == sortKey then
            self.label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
        else
            self.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        end
        GameTooltip:Hide()
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

--- Create an abilities view for a specific class
---@param config table Configuration: { viewName, className, classId, classColor }
function Deathless.UI.Views.AbilitiesTemplate:Create(config)
    local viewName = config.viewName       -- e.g., "warrior_abilities"
    local className = config.className     -- e.g., "Warrior"
    local classId = config.classId         -- e.g., "WARRIOR"
    local classColor = config.classColor   -- e.g., { 0.78, 0.61, 0.43 }
    
    Deathless.UI.Views:Register(viewName, function(container)
        local Colors = Utils:GetColors()
        
        local title, subtitle = Utils:CreateHeader(container, className .. " Abilities", "", classColor)
        
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
        local sectionState = { learned = false, available = true, nextAvailable = true, unavailable = false }
        
        -- Get raw abilities data
        local rawAbilities = Deathless.Data.Abilities and Deathless.Data.Abilities[className] or {}
        
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
                
                section.cost = section:CreateFontString(nil, "OVERLAY")
                section.cost:SetFont("Fonts\\ARIALN.TTF", 11, "")
                section.cost:SetPoint("LEFT", section.count, "RIGHT", 8, 0)
                
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
                elseif key == "train" then
                    -- Sort order: yes < maybe < no (priority order)
                    local trainOrder = { yes = 1, maybe = 2, no = 3 }
                    valA = trainOrder[a.train or "yes"] or 2
                    valB = trainOrder[b.train or "yes"] or 2
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
            
            -- Tooltip on hover
            row:EnableMouse(true)
            row:SetScript("OnEnter", function(self)
                if ability.spellId then
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetSpellByID(ability.spellId)
                    GameTooltip:Show()
                end
            end)
            row:SetScript("OnLeave", function(self)
                GameTooltip:Hide()
            end)
            
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
            if ability.base_cost == 0 then
                cost:SetText("Free")
                cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], dimmed and 0.6 or 1)
            else
                cost:SetText(FormatMoneyColored(ability.base_cost))
                cost:SetTextColor(1, 1, 1, dimmed and 0.6 or 1)
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
            
            -- Train column
            local train = row:CreateFontString(nil, "OVERLAY")
            train:SetFont("Fonts\\ARIALN.TTF", 11, "")
            train:SetPoint("LEFT", row, "LEFT", 470, 0)
            train:SetWidth(50)
            train:SetJustifyH("CENTER")
            local trainValue = ability.train or "yes"
            local trainText = trainValue:sub(1, 1):upper() .. trainValue:sub(2)
            train:SetText(trainText)
            local alpha = dimmed and 0.6 or 1
            if trainValue == "yes" then
                train:SetTextColor(0.4, 0.8, 0.4, alpha)  -- Green
            elseif trainValue == "no" then
                train:SetTextColor(0.8, 0.4, 0.4, alpha)  -- Red
            else  -- maybe
                train:SetTextColor(0.9, 0.8, 0.3, alpha)  -- Yellow
            end
            row.elements.train = train
            
            return yOffset - ROW_HEIGHT
        end
        
        local PopulateRows
        
        local function CreateSectionHeaderAt(sectionKey, label, count, yOffset, color, costCopper)
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
            
            -- Optional cost display
            if costCopper and costCopper > 0 then
                section.cost:SetText("Total: " .. FormatMoneyColored(costCopper))
                section.cost:Show()
            else
                section.cost:SetText("")
                section.cost:Hide()
            end
            
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
            local isCorrectClass = (playerClass == classId)
            
            -- "Next available" includes abilities within next 2 levels
            local NEXT_LEVEL_RANGE = 2
            local nextLevelCap = playerLevel + NEXT_LEVEL_RANGE
            
            local learned = {}
            local available = {}
            local nextAvailable = {}
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
                        elseif isCorrectClass and ability.level <= nextLevelCap then
                            table.insert(nextAvailable, ability)
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
                    elseif isCorrectClass and ability.level <= nextLevelCap then
                        table.insert(nextAvailable, ability)
                    else
                        table.insert(unavailable, ability)
                    end
                end
            end
            
            learned = SortAbilities(learned)
            available = SortAbilities(available)
            nextAvailable = SortAbilities(nextAvailable)
            unavailable = SortAbilities(unavailable)
            
            local yOffset = 0
            local rowNum = 0
            
            local learnedColor = { 0.5, 0.5, 0.5 }
            local availableColor = Colors.accent
            local nextAvailableColor = { 0.5, 0.7, 0.9 }
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
            
            if #nextAvailable > 0 then
                local totalCost = 0
                for _, ability in ipairs(nextAvailable) do
                    totalCost = totalCost + (ability.base_cost or 0)
                end
                yOffset = CreateSectionHeaderAt("nextAvailable", "Next Available", #nextAvailable, yOffset, nextAvailableColor, totalCost)
                if sectionState.nextAvailable then
                    for _, ability in ipairs(nextAvailable) do
                        rowNum = rowNum + 1
                        yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, false)
                    end
                end
            end
            
            if #unavailable > 0 then
                local unavailableCost = 0
                for _, ability in ipairs(unavailable) do
                    unavailableCost = unavailableCost + (ability.base_cost or 0)
                end
                yOffset = CreateSectionHeaderAt("unavailable", "Unavailable", #unavailable, yOffset, unavailableColor, unavailableCost)
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
        headers.train = CreateSortableHeader(container, "TRAIN (?)", 470, 50, "train", sortState, OnSort, {
            title = "Training Priority",
            "|cff66cc66Yes|r - Train when available",
            "|cffcccc55Wait|r - Marginal upgrade",
            "|cffcc6666No|r - Not useful for Hardcore",
        })
        
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
end

