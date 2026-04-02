local Deathless = Deathless

Deathless.UI.Navigation = Deathless.UI.Navigation or {}

local Colors = nil -- Set after frame.lua loads
local CreatePixelBorder = nil
local Icons = Deathless.Utils.Icons

-- Classes are leaf items; abilities/talents/gear are shown via tabs inside each class view
local CLASS_ITEMS = {
    { id = "class_druid", label = "Druid", icon = Icons.CLASS_DRUID },
    { id = "class_hunter", label = "Hunter", icon = Icons.CLASS_HUNTER },
    { id = "class_mage", label = "Mage", icon = Icons.CLASS_MAGE },
    { id = "class_paladin", label = "Paladin", icon = Icons.CLASS_PALADIN },
    { id = "class_priest", label = "Priest", icon = Icons.CLASS_PRIEST },
    { id = "class_rogue", label = "Rogue", icon = Icons.CLASS_ROGUE },
    { id = "class_shaman", label = "Shaman", icon = Icons.CLASS_SHAMAN },
    { id = "class_warlock", label = "Warlock", icon = Icons.CLASS_WARLOCK },
    { id = "class_warrior", label = "Warrior", icon = Icons.CLASS_WARRIOR },
}

-- Base navigation items (classes section is inserted dynamically)
local NAV_ITEMS_TOP = {
    { id = "home", label = "Home" },
    { id = "summary", label = "Summary" },
    { divider = true },
}

local NAV_ITEMS_BOTTOM = {
    { id = "dungeons", label = "Dungeons" },
    { id = "leveling", label = "Leveling (WIP)", hidden = true },
    { id = "professions", label = "Professions (WIP)", hidden = true },
    { id = "selffound", label = "Self-Found (WIP)", hidden = true },
    { id = "zones", label = "Zones (WIP)", hidden = true },
    { divider = true },
    { id = "commands", label = "Commands" },
    { id = "macros", label = "Macros" },
    { id = "options", label = "Options" },
}

--- Get the count and single class item if only one is included
---@return number count Number of included classes
---@return table|nil singleClass The single class item if count == 1
local function GetIncludedClassInfo()
    local config = Deathless.config
    if not config or not config.includedClasses then
        return #CLASS_ITEMS, nil
    end
    
    local count = 0
    local singleClass = nil
    for _, item in ipairs(CLASS_ITEMS) do
        if config.includedClasses[item.label] then
            count = count + 1
            singleClass = item
        end
    end
    
    return count, (count == 1) and singleClass or nil
end

--- Build nav items dynamically based on config
---@return table The navigation items
local function GetNavItems()
    local items = {}
    
    -- Add top items
    for _, item in ipairs(NAV_ITEMS_TOP) do
        table.insert(items, item)
    end
    
    -- Add class section (single class promoted or full Classes menu)
    local count, singleClass = GetIncludedClassInfo()
    if singleClass then
        -- Promote single class to top level with its icon
        table.insert(items, {
            id = singleClass.id,
            label = singleClass.label,
            icon = singleClass.icon,
        })
    else
        -- Show full Classes menu
        table.insert(items, { id = "classes", label = "Classes", children = CLASS_ITEMS })
    end
    
    -- Add bottom items (skip hidden views)
    for _, item in ipairs(NAV_ITEMS_BOTTOM) do
        if not item.hidden then
            table.insert(items, item)
        end
    end
    
    return items
end

-- Width of the navigation sidebar
local NAV_WIDTH = 160

-- Height of buttons
local BUTTON_HEIGHT = 28
local SUB_BUTTON_HEIGHT = 24
local SUB_SUB_BUTTON_HEIGHT = 22
local BUTTON_SPACING = 2
local DIVIDER_HEIGHT = 12

--- Create a single navigation button
---@param parent Frame Parent frame for the button
---@param item table Navigation item config { id, label, icon }
---@param depth number Nesting depth (0 = top level, 1 = sub, 2 = sub-sub)
---@return Button The created nav button
local function CreateNavButton(parent, item, depth)
    local btn = CreateFrame("Button", nil, parent)
    local height = depth == 0 and BUTTON_HEIGHT or (depth == 1 and SUB_BUTTON_HEIGHT or SUB_SUB_BUTTON_HEIGHT)
    local indent = depth * 16
    
    btn:SetSize(NAV_WIDTH - 8 - indent, height)
    
    -- Background (transparent by default, visible when selected/hovered)
    btn.bg = btn:CreateTexture(nil, "BACKGROUND")
    btn.bg:SetAllPoints()
    btn.bg:SetColorTexture(Colors.transparent[1], Colors.transparent[2], Colors.transparent[3], Colors.transparent[4])
    
    -- Selection indicator (left accent bar)
    btn.indicator = btn:CreateTexture(nil, "ARTWORK")
    btn.indicator:SetSize(3, height - 6)
    btn.indicator:SetPoint("LEFT", btn, "LEFT", 0, 0)
    btn.indicator:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    btn.indicator:Hide()
    
    -- Icon (if provided)
    local labelOffset = 12
    if item.icon then
        local iconSize = depth == 0 and 18 or (depth == 1 and 16 or 14)
        btn.icon = btn:CreateTexture(nil, "ARTWORK")
        btn.icon:SetSize(iconSize, iconSize)
        btn.icon:SetPoint("LEFT", btn, "LEFT", 8, 0)
        btn.icon:SetTexture(item.icon)
        btn.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- Trim icon borders
        labelOffset = 8 + iconSize + 4
    end
    
    -- Label text
    local Fonts = Deathless.UI.Fonts
    local fontSize = depth == 0 and Fonts.sectionHeader or (depth == 1 and Fonts.subtitle or Fonts.body)
    btn.label = btn:CreateFontString(nil, "OVERLAY")
    btn.label:SetFont(Fonts.family, fontSize, "")
    btn.label:SetPoint("LEFT", btn, "LEFT", labelOffset, 0)
    btn.label:SetText(item.label)
    btn.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    -- Store the nav item data
    btn.navId = item.id
    btn.isSelected = false
    btn.depth = depth
    
    -- Hover effects
    btn:SetScript("OnEnter", function(self)
        if not self.isSelected then
            self.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.5)
            self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        end
    end)
    
    btn:SetScript("OnLeave", function(self)
        if not self.isSelected then
            self.bg:SetColorTexture(Colors.transparent[1], Colors.transparent[2], Colors.transparent[3], Colors.transparent[4])
            self.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        end
    end)
    
    return btn
end

--- Set a button's selected state
---@param btn Button The nav button
---@param selected boolean Whether the button is selected
local function SetButtonSelected(btn, selected)
    btn.isSelected = selected
    if selected then
        btn.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
        btn.indicator:Show()
        btn.label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    else
        btn.bg:SetColorTexture(Colors.transparent[1], Colors.transparent[2], Colors.transparent[3], Colors.transparent[4])
        btn.indicator:Hide()
        btn.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    end
end

--- Set a parent button's expanded visual state (without affecting selection)
---@param btn Button The nav button
---@param expanded boolean Whether the button's submenu is expanded
local function SetButtonExpanded(btn, expanded)
    if btn.expandIcon then
        btn.expandIcon:SetText(expanded and "−" or "+")
    end
end

--- Update button styling for current depth
---@param btn Button The nav button
---@param depth number Current depth (0 = top level)
local function UpdateButtonDepthStyle(btn, depth)
    local height = depth == 0 and BUTTON_HEIGHT or (depth == 1 and SUB_BUTTON_HEIGHT or SUB_SUB_BUTTON_HEIGHT)
    local indent = depth * 16
    local Fonts = Deathless.UI.Fonts
    local fontSize = depth == 0 and Fonts.sectionHeader or (depth == 1 and Fonts.subtitle or Fonts.body)
    local iconSize = depth == 0 and 18 or (depth == 1 and 16 or 14)
    
    btn:SetHeight(height)
    btn:SetWidth(NAV_WIDTH - 8 - indent)
    btn.label:SetFont(Fonts.family, fontSize, "")
    
    if btn.icon then
        btn.icon:SetSize(iconSize, iconSize)
        btn.label:SetPoint("LEFT", btn, "LEFT", 8 + iconSize + 4, 0)
    end
    
    if btn.indicator then
        btn.indicator:SetHeight(height - 6)
    end
    
    btn.depth = depth
end

--- Add expand/collapse indicator to a button
---@param btn Button The nav button
local function AddExpandIcon(btn)
    local Fonts = Deathless.UI.Fonts
    btn.expandIcon = btn:CreateFontString(nil, "OVERLAY")
    btn.expandIcon:SetFont(Fonts.icons, Fonts.subtitle, "")
    btn.expandIcon:SetPoint("RIGHT", btn, "RIGHT", -4, 0)
    btn.expandIcon:SetText("+")
    btn.expandIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
end

--- Recursively create buttons for an item and its children
---@param nav Frame The navigation frame
---@param scrollChild Frame The scroll child frame
---@param item table The navigation item
---@param depth number Current nesting depth
local function CreateButtonsRecursive(nav, scrollChild, item, depth)
    -- Skip dividers (they're created on-demand in positioning)
    if item.divider then return end
    
    local btn = CreateNavButton(scrollChild, item, depth)
    nav.buttons[item.id] = btn
    btn:Hide() -- Will be shown by RepositionButtons if visible
    
    if item.children then
        AddExpandIcon(btn)
        
        -- Click toggles expand and selects
        btn:SetScript("OnClick", function(self)
            nav.expandedSections[self.navId] = not nav.expandedSections[self.navId]
            Deathless.UI.Navigation:RepositionButtons()
            Deathless.UI.Navigation:Select(self.navId)
        end)
        
        -- Create children recursively
        for _, child in ipairs(item.children) do
            CreateButtonsRecursive(nav, scrollChild, child, depth + 1)
        end
    else
        btn:SetScript("OnClick", function(self)
            Deathless.UI.Navigation:Select(self.navId)
        end)
    end
end

--- Create a horizontal divider
---@param parent Frame Parent frame
---@return Frame The divider frame
local function CreateDivider(parent)
    local divider = CreateFrame("Frame", nil, parent)
    divider:SetSize(NAV_WIDTH - 24, 1)
    
    local line = divider:CreateTexture(nil, "ARTWORK")
    line:SetAllPoints()
    line:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
    
    return divider
end

--- Check if a class item should be shown based on config
---@param item table The navigation item
---@return boolean Whether the item should be shown
local function IsClassIncluded(item)
    -- Only filter items that start with "class_"
    if not item.id or not item.id:match("^class_") then
        return true
    end
    
    -- Check config
    local config = Deathless.config
    if not config or not config.includedClasses then
        return true
    end
    
    return config.includedClasses[item.label] == true
end

--- Recursively position buttons and their children
---@param nav Frame The navigation frame
---@param scrollChild Frame The scroll child frame
---@param items table Array of nav items
---@param yOffset number Current Y offset
---@param depth number Current depth
---@param parentExpanded boolean Whether parent is expanded
---@return number New Y offset after positioning
local function PositionButtonsRecursive(nav, scrollChild, items, yOffset, depth, parentExpanded)
    local height = depth == 0 and BUTTON_HEIGHT or (depth == 1 and SUB_BUTTON_HEIGHT or SUB_SUB_BUTTON_HEIGHT)
    local indent = depth * 16
    
    for i, item in ipairs(items) do
        -- Handle dividers
        if item.divider then
            if parentExpanded then
                local divider = nav.dividers[i]
                if not divider then
                    divider = CreateDivider(scrollChild)
                    nav.dividers[i] = divider
                end
                divider:ClearAllPoints()
                divider:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset - (DIVIDER_HEIGHT / 2) + 1)
                divider:Show()
                yOffset = yOffset - DIVIDER_HEIGHT
            end
        else
            local btn = nav.buttons[item.id]
            -- Check if class items should be filtered
            local shouldShow = IsClassIncluded(item)
            
            if btn then
                if parentExpanded and shouldShow then
                    UpdateButtonDepthStyle(btn, depth)
                    btn:ClearAllPoints()
                    btn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 4 + indent, yOffset)
                    btn:Show()
                    yOffset = yOffset - height - BUTTON_SPACING
                    
                    -- Position children if this item is expanded
                    if item.children then
                        local isExpanded = nav.expandedSections[item.id]
                        SetButtonExpanded(btn, isExpanded)
                        yOffset = PositionButtonsRecursive(nav, scrollChild, item.children, yOffset, depth + 1, isExpanded)
                    end
                else
                    btn:Hide()
                    -- Recursively hide children when parent is collapsed or filtered
                    if item.children then
                        PositionButtonsRecursive(nav, scrollChild, item.children, yOffset, depth + 1, false)
                    end
                end
            end
        end
    end
    
    return yOffset
end

--- Reposition all buttons based on current expand state
function Deathless.UI.Navigation:RepositionButtons()
    if not self.frame then return end
    local nav = self.frame
    local scrollChild = nav.scrollChild
    if not scrollChild then return end
    
    -- Hide all buttons first (they'll be shown by positioning if needed)
    for _, btn in pairs(nav.buttons) do
        btn:Hide()
    end
    for _, divider in pairs(nav.dividers) do
        divider:Hide()
    end
    
    local yOffset = PositionButtonsRecursive(nav, scrollChild, GetNavItems(), -4, 0, true)
    
    -- Update scroll child height and scrollbar
    scrollChild:SetHeight(math.abs(yOffset) + 10)
    C_Timer.After(0, function()
        if nav.scrollFrame and nav.scrollFrame.UpdateScrollbar then
            nav.scrollFrame.UpdateScrollbar()
        end
    end)
end

--- Create the navigation sidebar
---@param parent Frame The main frame to attach to
---@return Frame The navigation frame
function Deathless.UI.Navigation:Create(parent)
    -- Get colors from frame module
    Colors = Deathless.UI.Colors
    CreatePixelBorder = Deathless.UI.CreatePixelBorder
    
    local nav = CreateFrame("Frame", nil, parent)
    nav:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -32) -- Below title bar
    nav:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 2, 2)
    nav:SetWidth(NAV_WIDTH)
    
    -- Background
    nav.bg = nav:CreateTexture(nil, "BACKGROUND")
    nav.bg:SetAllPoints()
    nav.bg:SetColorTexture(Colors.bg[1], Colors.bg[2], Colors.bg[3], 1)
    
    -- Right border (separator from content)
    nav.rightBorder = nav:CreateTexture(nil, "BORDER")
    nav.rightBorder:SetPoint("TOPRIGHT", nav, "TOPRIGHT", 0, 0)
    nav.rightBorder:SetPoint("BOTTOMRIGHT", nav, "BOTTOMRIGHT", 0, 0)
    nav.rightBorder:SetWidth(1)
    nav.rightBorder:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
    
    -- Create scroll frame for navigation buttons
    local scrollFrame = CreateFrame("ScrollFrame", nil, nav)
    scrollFrame:SetPoint("TOPLEFT", nav, "TOPLEFT", 0, 0)
    scrollFrame:SetPoint("BOTTOMRIGHT", nav, "BOTTOMRIGHT", 0, 0)
    
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(NAV_WIDTH, 1)
    scrollFrame:SetScrollChild(scrollChild)

    local controller = Deathless.Utils.UI.CreateAutoHideScrollIndicator(scrollFrame, scrollChild, {
        parent = nav,
        hoverFrame = nav,
        topRight = { -1, 0 },
        bottomRight = { -1, 0 },
        frameLevelParent = nav,
        updateFrame = scrollFrame,
        smoothScroll = true,
    })
    scrollFrame.UpdateScrollbar = controller.UpdateScrollThumb
    
    nav.scrollFrame = scrollFrame
    nav.scrollChild = scrollChild
    nav.scrollIndicator = controller.indicator
    
    -- Track expanded sections
    nav.expandedSections = {}
    nav.buttons = {}
    nav.dividers = {}
    
    -- Create all nav buttons (for all possible structures)
    -- Top items
    for _, item in ipairs(NAV_ITEMS_TOP) do
        CreateButtonsRecursive(nav, scrollChild, item, 0)
    end
    -- Classes parent (for multi-class mode)
    CreateButtonsRecursive(nav, scrollChild, { id = "classes", label = "Classes", children = CLASS_ITEMS }, 0)
    -- Bottom items
    for _, item in ipairs(NAV_ITEMS_BOTTOM) do
        CreateButtonsRecursive(nav, scrollChild, item, 0)
    end
    
    -- Track current selection
    nav.currentSelection = nil
    
    self.frame = nav
    
    -- Initial positioning
    self:RepositionButtons()
    
    return nav
end

--- Select a navigation item by id
---@param navId string The navigation item id to select
function Deathless.UI.Navigation:Select(navId)
    if not self.frame then return end
    
    -- Deselect current
    if self.frame.currentSelection and self.frame.buttons[self.frame.currentSelection] then
        SetButtonSelected(self.frame.buttons[self.frame.currentSelection], false)
    end
    
    -- Select new
    if self.frame.buttons[navId] then
        SetButtonSelected(self.frame.buttons[navId], true)
        self.frame.currentSelection = navId
        
        -- Notify content panel to update
        if Deathless.UI.Content and Deathless.UI.Content.ShowView then
            Deathless.UI.Content:ShowView(navId)
        end
    end
end

--- Open a class view and optionally select a tab.
---@param classFile string Class token from UnitClass (e.g. "WARRIOR")
---@param tabSuffix string|nil Optional class tab suffix (e.g. "abilities")
---@param opts table|nil Optional behavior flags
---@return boolean success True when class view opened and requested tab (if any) selected
function Deathless.UI.Navigation:OpenClassTab(classFile, tabSuffix, opts)
    opts = opts or {}

    if not classFile then
        Deathless.Utils.Chat.Print("Could not determine your class.")
        return false
    end

    local classKey = classFile:lower()
    local classViewId = "class_" .. classKey
    local tabId = tabSuffix and (classKey .. "_" .. tabSuffix) or nil

    if Deathless.UI and Deathless.UI.Frame then
        Deathless.UI.Frame:Show()
    else
        Deathless.Utils.Chat.Print("UI not initialized.")
        return false
    end

    if not self.frame then
        Deathless.Utils.Chat.Print("Navigation not initialized.")
        return false
    end

    local nav = self.frame
    nav.expandedSections["classes"] = true
    nav.expandedSections[classViewId] = true
    self:RepositionButtons()
    self:Select(classViewId)

    if not tabId then
        return true
    end

    if Deathless.UI.Content and Deathless.UI.Content.frame then
        local view = Deathless.UI.Content.frame.views and Deathless.UI.Content.frame.views[classViewId]
        if view and view.elements and view.elements.tabBar and view.elements.tabBar.containers[tabId] then
            view.elements.tabBar.SelectTab(tabId)
            return true
        end
    end

    if opts.notifyMissingTab then
        local label = opts.tabLabel or tabSuffix:gsub("^%l", string.upper)
        Deathless.Utils.Chat.Print(string.format("%s tab not available for your class.", label))
    end
    return false
end

--- Open the player's class view and optionally select a tab.
---@param tabSuffix string|nil Optional class tab suffix (e.g. "abilities")
---@param opts table|nil Optional behavior flags
---@return boolean success
function Deathless.UI.Navigation:OpenPlayerClassTab(tabSuffix, opts)
    local _, classFile = UnitClass("player")
    return self:OpenClassTab(classFile, tabSuffix, opts)
end

--- Get the current selection
---@return string|nil The current selection id
function Deathless.UI.Navigation:GetSelection()
    return self.frame and self.frame.currentSelection
end

--- Get the navigation width (for layout calculations)
---@return number The navigation sidebar width
function Deathless.UI.Navigation:GetWidth()
    return NAV_WIDTH
end
