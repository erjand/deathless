local Deathless = Deathless

Deathless.UI.Navigation = Deathless.UI.Navigation or {}

local Colors = nil -- Set after frame.lua loads
local CreatePixelBorder = nil

-- Sub-items for Warrior class
local WARRIOR_ITEMS = {
    { id = "warrior_abilities", label = "Abilities", icon = "Interface\\Icons\\Ability_Warrior_BattleShout" },
}

-- Classic WoW classes in alphabetical order (with icons and optional children)
local CLASS_ITEMS = {
    { id = "class_druid", label = "Druid", icon = "Interface\\Icons\\ClassIcon_Druid" },
    { id = "class_hunter", label = "Hunter", icon = "Interface\\Icons\\ClassIcon_Hunter" },
    { id = "class_mage", label = "Mage", icon = "Interface\\Icons\\ClassIcon_Mage" },
    { id = "class_paladin", label = "Paladin", icon = "Interface\\Icons\\ClassIcon_Paladin" },
    { id = "class_priest", label = "Priest", icon = "Interface\\Icons\\ClassIcon_Priest" },
    { id = "class_rogue", label = "Rogue", icon = "Interface\\Icons\\ClassIcon_Rogue" },
    { id = "class_shaman", label = "Shaman", icon = "Interface\\Icons\\ClassIcon_Shaman" },
    { id = "class_warlock", label = "Warlock", icon = "Interface\\Icons\\ClassIcon_Warlock" },
    { id = "class_warrior", label = "Warrior", icon = "Interface\\Icons\\ClassIcon_Warrior", children = WARRIOR_ITEMS },
}

-- Navigation items configuration (with optional children)
local NAV_ITEMS = {
    { id = "home", label = "Home" },
    { divider = true },
    { id = "classes", label = "Classes", children = CLASS_ITEMS },
    { id = "zones", label = "Zones" },
    { divider = true },
    { id = "options", label = "Options" },
    { id = "support", label = "Support" },
}

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
    btn.bg:SetColorTexture(0, 0, 0, 0)
    
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
    local fontSize = depth == 0 and 12 or (depth == 1 and 11 or 10)
    btn.label = btn:CreateFontString(nil, "OVERLAY")
    btn.label:SetFont("Fonts\\ARIALN.TTF", fontSize, "")
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
            self.bg:SetColorTexture(0, 0, 0, 0)
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
        btn.bg:SetColorTexture(0, 0, 0, 0)
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

--- Add expand/collapse indicator to a button
---@param btn Button The nav button
local function AddExpandIcon(btn)
    btn.expandIcon = btn:CreateFontString(nil, "OVERLAY")
    btn.expandIcon:SetFont("Fonts\\ARIALN.TTF", 12, "")
    btn.expandIcon:SetPoint("RIGHT", btn, "RIGHT", -4, 0)
    btn.expandIcon:SetText("+")
    btn.expandIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
end

--- Recursively create buttons for an item and its children
---@param nav Frame The navigation frame
---@param item table The navigation item
---@param depth number Current nesting depth
local function CreateButtonsRecursive(nav, item, depth)
    -- Skip dividers (they're created on-demand in positioning)
    if item.divider then return end
    
    local btn = CreateNavButton(nav, item, depth)
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
            CreateButtonsRecursive(nav, child, depth + 1)
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
---@param items table Array of nav items
---@param yOffset number Current Y offset
---@param depth number Current depth
---@param parentExpanded boolean Whether parent is expanded
---@return number New Y offset after positioning
local function PositionButtonsRecursive(nav, items, yOffset, depth, parentExpanded)
    local height = depth == 0 and BUTTON_HEIGHT or (depth == 1 and SUB_BUTTON_HEIGHT or SUB_SUB_BUTTON_HEIGHT)
    local indent = depth * 16
    
    for i, item in ipairs(items) do
        -- Handle dividers
        if item.divider then
            if parentExpanded then
                local divider = nav.dividers[i]
                if not divider then
                    divider = CreateDivider(nav)
                    nav.dividers[i] = divider
                end
                divider:ClearAllPoints()
                divider:SetPoint("TOPLEFT", nav, "TOPLEFT", 12, yOffset - (DIVIDER_HEIGHT / 2) + 1)
                divider:Show()
                yOffset = yOffset - DIVIDER_HEIGHT
            end
        else
            local btn = nav.buttons[item.id]
            -- Check if class items should be filtered
            local shouldShow = IsClassIncluded(item)
            
            if btn then
                if parentExpanded and shouldShow then
                    btn:ClearAllPoints()
                    btn:SetPoint("TOPLEFT", nav, "TOPLEFT", 4 + indent, yOffset)
                    btn:Show()
                    yOffset = yOffset - height - BUTTON_SPACING
                    
                    -- Position children if this item is expanded
                    if item.children then
                        local isExpanded = nav.expandedSections[item.id]
                        SetButtonExpanded(btn, isExpanded)
                        yOffset = PositionButtonsRecursive(nav, item.children, yOffset, depth + 1, isExpanded)
                    end
                else
                    btn:Hide()
                    -- Recursively hide children when parent is collapsed or filtered
                    if item.children then
                        PositionButtonsRecursive(nav, item.children, yOffset, depth + 1, false)
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
    PositionButtonsRecursive(self.frame, NAV_ITEMS, -4, 0, true)
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
    
    -- Track expanded sections
    nav.expandedSections = {}
    nav.buttons = {}
    nav.dividers = {}
    
    -- Create all nav buttons recursively
    for _, item in ipairs(NAV_ITEMS) do
        CreateButtonsRecursive(nav, item, 0)
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
