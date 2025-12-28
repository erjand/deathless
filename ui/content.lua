local Deathless = Deathless

Deathless.UI.Content = Deathless.UI.Content or {}

local Colors = nil -- Set after frame.lua loads

-- View content creators (called when view is shown for the first time)
local ViewCreators = {}

--- Home view content
ViewCreators.home = function(container)
    -- Title
    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetFont("Fonts\\FRIZQT__.TTF", 24, "")
    title:SetPoint("TOP", container, "TOP", 0, -40)
    title:SetText("Deathless")
    title:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    -- Subtitle
    local subtitle = container:CreateFontString(nil, "OVERLAY")
    subtitle:SetFont("Fonts\\ARIALN.TTF", 14, "")
    subtitle:SetPoint("TOP", title, "BOTTOM", 0, -8)
    subtitle:SetText("Hardcore Classic WoW Companion")
    subtitle:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    -- Description
    local desc = container:CreateFontString(nil, "OVERLAY")
    desc:SetFont("Fonts\\ARIALN.TTF", 12, "")
    desc:SetPoint("TOP", subtitle, "BOTTOM", 0, -24)
    desc:SetWidth(container:GetWidth() - 60)
    desc:SetJustifyH("CENTER")
    desc:SetText("Track your hardcore journey with class guides, zone information, and survival tips. Stay deathless!")
    desc:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, desc = desc }
end

--- Classes view content
ViewCreators.classes = function(container)
    -- Title
    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetFont("Fonts\\FRIZQT__.TTF", 20, "")
    title:SetPoint("TOPLEFT", container, "TOPLEFT", 20, -20)
    title:SetText("Classes")
    title:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    -- Subtitle
    local subtitle = container:CreateFontString(nil, "OVERLAY")
    subtitle:SetFont("Fonts\\ARIALN.TTF", 12, "")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    subtitle:SetText("Hardcore class guides and tips")
    subtitle:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    -- Placeholder content
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont("Fonts\\ARIALN.TTF", 12, "")
    content:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -20)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Select a class from the sub-menu to view guides, talent builds, and hardcore survival strategies.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end

--- Zones view content
ViewCreators.zones = function(container)
    -- Title
    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetFont("Fonts\\FRIZQT__.TTF", 20, "")
    title:SetPoint("TOPLEFT", container, "TOPLEFT", 20, -20)
    title:SetText("Zones")
    title:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    -- Subtitle
    local subtitle = container:CreateFontString(nil, "OVERLAY")
    subtitle:SetFont("Fonts\\ARIALN.TTF", 12, "")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    subtitle:SetText("Zone guides and danger warnings")
    subtitle:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    -- Placeholder content
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont("Fonts\\ARIALN.TTF", 12, "")
    content:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -20)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Browse zones by level range to find safe leveling paths and avoid dangerous areas.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end

--- Options view content
ViewCreators.options = function(container)
    -- Title
    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetFont("Fonts\\FRIZQT__.TTF", 20, "")
    title:SetPoint("TOPLEFT", container, "TOPLEFT", 20, -20)
    title:SetText("Options")
    title:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    -- Subtitle
    local subtitle = container:CreateFontString(nil, "OVERLAY")
    subtitle:SetFont("Fonts\\ARIALN.TTF", 12, "")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    subtitle:SetText("Addon settings and preferences")
    subtitle:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    -- Placeholder content
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont("Fonts\\ARIALN.TTF", 12, "")
    content:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -20)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Configure Deathless addon settings here.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end

-- Class color definitions (matching WoW class colors)
local CLASS_COLORS = {
    druid = { 1.00, 0.49, 0.04 },    -- Orange
    hunter = { 0.67, 0.83, 0.45 },   -- Green
    mage = { 0.25, 0.78, 0.92 },     -- Light Blue
    paladin = { 0.96, 0.55, 0.73 },  -- Pink
    priest = { 1.00, 1.00, 1.00 },   -- White
    rogue = { 1.00, 0.96, 0.41 },    -- Yellow
    shaman = { 0.00, 0.44, 0.87 },   -- Blue
    warlock = { 0.53, 0.53, 0.93 },  -- Purple
    warrior = { 0.78, 0.61, 0.43 },  -- Tan
}

--- Factory function to create class view content
---@param className string The class name (lowercase)
---@param displayName string The display name for the class
---@return function View creator function
local function CreateClassViewCreator(className, displayName)
    return function(container)
        local classColor = CLASS_COLORS[className] or Colors.accent
        
        -- Title with class color
        local title = container:CreateFontString(nil, "OVERLAY")
        title:SetFont("Fonts\\FRIZQT__.TTF", 20, "")
        title:SetPoint("TOPLEFT", container, "TOPLEFT", 20, -20)
        title:SetText(displayName)
        title:SetTextColor(classColor[1], classColor[2], classColor[3], 1)
        
        -- Subtitle
        local subtitle = container:CreateFontString(nil, "OVERLAY")
        subtitle:SetFont("Fonts\\ARIALN.TTF", 12, "")
        subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
        subtitle:SetText("Hardcore " .. displayName .. " Guide")
        subtitle:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        -- Placeholder content
        local content = container:CreateFontString(nil, "OVERLAY")
        content:SetFont("Fonts\\ARIALN.TTF", 12, "")
        content:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -20)
        content:SetWidth(container:GetWidth() - 40)
        content:SetJustifyH("LEFT")
        content:SetText("Talent builds, leveling strategies, and survival tips for " .. displayName .. " in Hardcore Classic WoW.")
        content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        
        return { title = title, subtitle = subtitle, content = content }
    end
end

-- Register class view creators
ViewCreators.class_druid = CreateClassViewCreator("druid", "Druid")
ViewCreators.class_hunter = CreateClassViewCreator("hunter", "Hunter")
ViewCreators.class_mage = CreateClassViewCreator("mage", "Mage")
ViewCreators.class_paladin = CreateClassViewCreator("paladin", "Paladin")
ViewCreators.class_priest = CreateClassViewCreator("priest", "Priest")
ViewCreators.class_rogue = CreateClassViewCreator("rogue", "Rogue")
ViewCreators.class_shaman = CreateClassViewCreator("shaman", "Shaman")
ViewCreators.class_warlock = CreateClassViewCreator("warlock", "Warlock")
ViewCreators.class_warrior = CreateClassViewCreator("warrior", "Warrior")

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

--- Create a single ability row
---@param parent Frame The scroll child frame
---@param ability table The ability data
---@param yOffset number Y offset for positioning
---@return number New Y offset
local function CreateAbilityRow(parent, ability, yOffset)
    local ROW_HEIGHT = 28
    local row = CreateFrame("Frame", nil, parent)
    row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset)
    row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, yOffset)
    row:SetHeight(ROW_HEIGHT)
    
    -- Alternating row background
    local rowIndex = math.abs(yOffset / ROW_HEIGHT)
    if rowIndex % 2 == 0 then
        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints()
        row.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.3)
    end
    
    -- Icon
    local icon = row:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("LEFT", row, "LEFT", 8, 0)
    icon:SetTexture("Interface\\Icons\\" .. (ability.icon or "INV_Misc_QuestionMark"))
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    
    -- Name and Rank
    local nameText = ability.name
    if ability.rank and ability.rank > 1 then
        nameText = nameText .. " (Rank " .. ability.rank .. ")"
    end
    
    local name = row:CreateFontString(nil, "OVERLAY")
    name:SetFont("Fonts\\ARIALN.TTF", 11, "")
    name:SetPoint("LEFT", icon, "RIGHT", 8, 0)
    name:SetWidth(200)
    name:SetJustifyH("LEFT")
    name:SetText(nameText)
    name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    -- Level
    local level = row:CreateFontString(nil, "OVERLAY")
    level:SetFont("Fonts\\ARIALN.TTF", 11, "")
    level:SetPoint("LEFT", row, "LEFT", 250, 0)
    level:SetWidth(50)
    level:SetJustifyH("CENTER")
    level:SetText("Lv " .. ability.level)
    level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    -- Cost
    local cost = row:CreateFontString(nil, "OVERLAY")
    cost:SetFont("Fonts\\ARIALN.TTF", 11, "")
    cost:SetPoint("LEFT", row, "LEFT", 310, 0)
    cost:SetWidth(80)
    cost:SetJustifyH("RIGHT")
    cost:SetText(FormatMoney(ability.base_cost))
    if ability.base_cost == 0 then
        cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    else
        cost:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    end
    
    -- Source
    local source = row:CreateFontString(nil, "OVERLAY")
    source:SetFont("Fonts\\ARIALN.TTF", 11, "")
    source:SetPoint("LEFT", row, "LEFT", 400, 0)
    source:SetWidth(60)
    source:SetJustifyH("LEFT")
    local sourceText = ability.source:sub(1, 1):upper() .. ability.source:sub(2)
    source:SetText(sourceText)
    source:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    return yOffset - ROW_HEIGHT
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
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(width, 18)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, -70)
    
    btn.label = btn:CreateFontString(nil, "OVERLAY")
    btn.label:SetFont("Fonts\\ARIALN.TTF", 10, "")
    btn.label:SetPoint("LEFT", btn, "LEFT", 0, 0)
    btn.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    btn.sortKey = sortKey
    
    -- Update label with sort indicator
    local function UpdateLabel()
        local indicator = ""
        if state.sortKey == sortKey then
            indicator = state.sortAsc and " ▲" or " ▼"
        end
        btn.label:SetText(label .. indicator)
    end
    
    UpdateLabel()
    btn.UpdateLabel = UpdateLabel
    
    -- Hover effect
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
            -- Check rank from subtext
            local rankNum = rank and tonumber(rank:match("%d+"))
            if rankNum and rankNum >= spellRank then
                return true
            end
        end
        i = i + 1
    end
    return false
end

--- Warrior Abilities view
ViewCreators.warrior_abilities = function(container)
    local classColor = CLASS_COLORS.warrior
    
    -- Title
    local title = container:CreateFontString(nil, "OVERLAY")
    title:SetFont("Fonts\\FRIZQT__.TTF", 20, "")
    title:SetPoint("TOPLEFT", container, "TOPLEFT", 20, -20)
    title:SetText("Warrior Abilities")
    title:SetTextColor(classColor[1], classColor[2], classColor[3], 1)
    
    -- Subtitle
    local subtitle = container:CreateFontString(nil, "OVERLAY")
    subtitle:SetFont("Fonts\\ARIALN.TTF", 12, "")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    subtitle:SetText("All trainable abilities with costs and levels")
    subtitle:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    -- Scroll frame for abilities list
    local scrollFrame = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", container, "TOPLEFT", 8, -90)
    scrollFrame:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -28, 24)
    
    -- Style the scroll bar
    local scrollBar = scrollFrame.ScrollBar
    if scrollBar then
        scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 4, -16)
        scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 4, 16)
    end
    
    -- Scroll child (content container)
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)
    
    -- Smooth scrolling state
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
    local sortState = {
        sortKey = "level",
        sortAsc = true
    }
    
    -- Section collapse state (learned collapsed by default)
    local sectionState = {
        learned = false,    -- collapsed
        available = true,   -- expanded
        unavailable = true  -- expanded
    }
    
    -- Get raw abilities data
    local rawAbilities = Deathless.Data.Abilities and Deathless.Data.Abilities["Warrior"] or {}
    
    -- Element pools for recycling
    local rowPool = {}
    local sectionPool = {}
    local poolIndex = 0
    local sectionIndex = 0
    
    --- Clear all elements from scroll child
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
    
    --- Get or create a section header
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
    
    --- Get or create an ability row
    local function GetAbilityRow()
        poolIndex = poolIndex + 1
        local row = rowPool[poolIndex]
        if not row then
            row = CreateFrame("Frame", nil, scrollChild)
            rowPool[poolIndex] = row
        end
        
        -- Clear existing content
        if row.elements then
            for _, element in pairs(row.elements) do
                if element.Hide then element:Hide() end
            end
        end
        row.elements = {}
        return row
    end
    
    --- Sort abilities list
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
    
    --- Create an ability row at the given offset
    local function CreateAbilityRowAt(ability, yOffset, rowNum, dimmed)
        local row = GetAbilityRow()
        local ROW_HEIGHT = 26
        
        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
        row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
        row:SetHeight(ROW_HEIGHT)
        row:Show()
        
        -- Alternating background
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
        
        -- Icon
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
        
        -- Name and Rank
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
        
        -- Level
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
        
        -- Cost
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
        
        -- Source
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
    
    -- Forward declaration for PopulateRows
    local PopulateRows
    
    --- Create a section header at the given offset
    local function CreateSectionHeaderAt(sectionKey, label, count, yOffset, color)
        local section = GetSectionHeader()
        local SECTION_HEIGHT = 28
        
        section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
        section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
        section:Show()
        
        local isExpanded = sectionState[sectionKey]
        section.icon:SetText(isExpanded and "▼" or "▶")
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
    
    --- Check if base talent is known (checks if rank 1 of the spell exists in spellbook)
    ---@param spellName string The talent spell name
    ---@return boolean Whether the base talent is known
    local function IsTalentKnown(spellName)
        return IsSpellKnown(spellName, 1)
    end
    
    --- Populate rows with categorized, sorted data
    PopulateRows = function()
        ClearElements()
        
        -- Get player level
        local playerLevel = UnitLevel("player") or 60
        
        -- Categorize abilities
        local learned = {}
        local available = {}
        local unavailable = {}
        
        for _, ability in ipairs(rawAbilities) do
            -- For talent abilities, skip entirely if base talent not known
            if ability.source == "talent" then
                local hasTalent = IsTalentKnown(ability.name)
                if not hasTalent then
                    -- Skip this ability - talent not learned
                else
                    -- Talent is known, categorize normally
                    local isKnown = IsSpellKnown(ability.name, ability.rank)
                    if isKnown then
                        table.insert(learned, ability)
                    elseif ability.level <= playerLevel then
                        table.insert(available, ability)
                    else
                        table.insert(unavailable, ability)
                    end
                end
            else
                -- Normal ability
                local isKnown = IsSpellKnown(ability.name, ability.rank)
                
                if isKnown then
                    table.insert(learned, ability)
                elseif ability.level <= playerLevel then
                    table.insert(available, ability)
                else
                    table.insert(unavailable, ability)
                end
            end
        end
        
        -- Sort each category
        learned = SortAbilities(learned)
        available = SortAbilities(available)
        unavailable = SortAbilities(unavailable)
        
        local yOffset = 0
        local rowNum = 0
        
        -- Section colors
        local learnedColor = { 0.5, 0.5, 0.5 }      -- Gray for learned
        local availableColor = Colors.accent        -- Green for available
        local unavailableColor = { 0.6, 0.4, 0.4 }  -- Muted red for unavailable
        
        -- Learned section
        if #learned > 0 then
            yOffset = CreateSectionHeaderAt("learned", "Learned", #learned, yOffset, learnedColor)
            if sectionState.learned then
                for _, ability in ipairs(learned) do
                    rowNum = rowNum + 1
                    yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, true)
                end
            end
        end
        
        -- Available section
        if #available > 0 then
            yOffset = CreateSectionHeaderAt("available", "Available", #available, yOffset, availableColor)
            if sectionState.available then
                for _, ability in ipairs(available) do
                    rowNum = rowNum + 1
                    yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, false)
                end
            end
        end
        
        -- Unavailable section
        if #unavailable > 0 then
            yOffset = CreateSectionHeaderAt("unavailable", "Unavailable", #unavailable, yOffset, unavailableColor)
            if sectionState.unavailable then
                for _, ability in ipairs(unavailable) do
                    rowNum = rowNum + 1
                    yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, true)
                end
            end
        end
        
        -- Update scroll child height
        scrollChild:SetHeight(math.abs(yOffset) + 10)
    end
    
    -- Create sortable headers
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
    
    -- Initial population
    OnSort()
    
    return { 
        title = title, 
        subtitle = subtitle, 
        scrollFrame = scrollFrame, 
        scrollChild = scrollChild,
        headers = headers,
        Refresh = PopulateRows  -- Expose refresh for external updates
    }
end

--- Create the main content panel
---@param parent Frame The main frame to attach to
---@param navWidth number Width of the navigation sidebar
---@return Frame The content frame
function Deathless.UI.Content:Create(parent, navWidth)
    Colors = Deathless.UI.Colors
    
    local content = CreateFrame("Frame", nil, parent)
    content:SetPoint("TOPLEFT", parent, "TOPLEFT", navWidth + 3, -32) -- Right of nav, below title
    content:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -2, 2)
    
    -- Background
    content.bg = content:CreateTexture(nil, "BACKGROUND")
    content.bg:SetAllPoints()
    content.bg:SetColorTexture(Colors.bg[1], Colors.bg[2], Colors.bg[3], 1)
    
    -- View containers (one per view, created on demand)
    content.views = {}
    content.currentView = nil
    
    self.frame = content
    return content
end

--- Get or create a view container
---@param viewId string The view identifier
---@return Frame|nil The view container, or nil if no creator exists
local function GetOrCreateView(content, viewId)
    -- Return existing view if already created
    if content.views[viewId] then
        return content.views[viewId]
    end
    
    -- Create new view if creator exists
    local creator = ViewCreators[viewId]
    if not creator then
        return nil
    end
    
    -- Create container frame for this view
    local container = CreateFrame("Frame", nil, content)
    container:SetAllPoints()
    container:Hide()
    
    -- Call the view creator to populate content
    container.elements = creator(container)
    
    -- Store and return
    content.views[viewId] = container
    return container
end

--- Show a specific view
---@param viewId string The view identifier to show
function Deathless.UI.Content:ShowView(viewId)
    if not self.frame then return end
    
    local content = self.frame
    
    -- Hide current view
    if content.currentView and content.views[content.currentView] then
        content.views[content.currentView]:Hide()
    end
    
    -- Get or create the requested view
    local view = GetOrCreateView(content, viewId)
    if view then
        view:Show()
        content.currentView = viewId
    end
end

--- Get the current view id
---@return string|nil The current view id
function Deathless.UI.Content:GetCurrentView()
    return self.frame and self.frame.currentView
end

--- Register a custom view creator
---@param viewId string The view identifier
---@param creator function Function that creates view content (receives container frame)
function Deathless.UI.Content:RegisterView(viewId, creator)
    ViewCreators[viewId] = creator
end
