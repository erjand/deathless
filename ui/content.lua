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
    local SCROLL_SPEED = 0.5
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
        sortKey = "level", -- Default sort by level
        sortAsc = true
    }
    
    -- Get raw abilities data
    local rawAbilities = Deathless.Data.Abilities and Deathless.Data.Abilities["Warrior"] or {}
    
    -- Row pool for recycling
    local rowPool = {}
    
    --- Clear all rows from scroll child
    local function ClearRows()
        for _, row in ipairs(rowPool) do
            row:Hide()
            row:ClearAllPoints()
        end
    end
    
    --- Populate rows with sorted data
    local function PopulateRows()
        ClearRows()
        
        -- Copy and sort abilities
        local sortedAbilities = {}
        for _, ability in ipairs(rawAbilities) do
            table.insert(sortedAbilities, ability)
        end
        
        local key = sortState.sortKey
        local asc = sortState.sortAsc
        
        table.sort(sortedAbilities, function(a, b)
            local valA, valB
            
            if key == "name" then
                -- Sort by name, then by rank
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
        
        -- Create/reuse rows
        local yOffset = 0
        for i, ability in ipairs(sortedAbilities) do
            local row = rowPool[i]
            if not row then
                row = CreateFrame("Frame", nil, scrollChild)
                rowPool[i] = row
            end
            
            -- Clear existing content
            if row.elements then
                for _, element in pairs(row.elements) do
                    if element.Hide then element:Hide() end
                end
            end
            row.elements = {}
            
            local ROW_HEIGHT = 28
            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
            row:SetHeight(ROW_HEIGHT)
            row:Show()
            
            -- Alternating background
            if not row.bg then
                row.bg = row:CreateTexture(nil, "BACKGROUND")
                row.bg:SetAllPoints()
            end
            if i % 2 == 0 then
                row.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.3)
                row.bg:Show()
            else
                row.bg:Hide()
            end
            
            -- Icon
            local icon = row:CreateTexture(nil, "ARTWORK")
            icon:SetSize(20, 20)
            icon:SetPoint("LEFT", row, "LEFT", 8, 0)
            icon:SetTexture("Interface\\Icons\\" .. (ability.icon or "INV_Misc_QuestionMark"))
            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            row.elements.icon = icon
            
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
            row.elements.name = name
            
            -- Level
            local level = row:CreateFontString(nil, "OVERLAY")
            level:SetFont("Fonts\\ARIALN.TTF", 11, "")
            level:SetPoint("LEFT", row, "LEFT", 250, 0)
            level:SetWidth(50)
            level:SetJustifyH("CENTER")
            level:SetText("Lv " .. ability.level)
            level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            row.elements.level = level
            
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
            row.elements.cost = cost
            
            -- Source
            local source = row:CreateFontString(nil, "OVERLAY")
            source:SetFont("Fonts\\ARIALN.TTF", 11, "")
            source:SetPoint("LEFT", row, "LEFT", 400, 0)
            source:SetWidth(60)
            source:SetJustifyH("LEFT")
            local sourceText = ability.source:sub(1, 1):upper() .. ability.source:sub(2)
            source:SetText(sourceText)
            source:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            row.elements.source = source
            
            yOffset = yOffset - ROW_HEIGHT
        end
        
        -- Hide unused rows
        for i = #sortedAbilities + 1, #rowPool do
            rowPool[i]:Hide()
        end
        
        -- Update scroll child height
        scrollChild:SetHeight(math.abs(yOffset) + 10)
        
        -- Reset scroll position
        targetScroll = 0
        scrollFrame:SetVerticalScroll(0)
    end
    
    -- Create sortable headers
    local headers = {}
    
    local function OnSort()
        -- Update all header labels
        for _, header in pairs(headers) do
            -- Reset color
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
    
    -- Initial population and header highlight
    OnSort()
    
    return { 
        title = title, 
        subtitle = subtitle, 
        scrollFrame = scrollFrame, 
        scrollChild = scrollChild,
        headers = headers
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
