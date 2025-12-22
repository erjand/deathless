local Deathless = Deathless

Deathless.UI.Navigation = Deathless.UI.Navigation or {}

local Colors = nil -- Set after frame.lua loads
local CreatePixelBorder = nil

-- Classic WoW classes in alphabetical order (with icons)
local CLASS_ITEMS = {
    { id = "class_druid", label = "Druid", icon = "Interface\\Icons\\ClassIcon_Druid" },
    { id = "class_hunter", label = "Hunter", icon = "Interface\\Icons\\ClassIcon_Hunter" },
    { id = "class_mage", label = "Mage", icon = "Interface\\Icons\\ClassIcon_Mage" },
    { id = "class_paladin", label = "Paladin", icon = "Interface\\Icons\\ClassIcon_Paladin" },
    { id = "class_priest", label = "Priest", icon = "Interface\\Icons\\ClassIcon_Priest" },
    { id = "class_rogue", label = "Rogue", icon = "Interface\\Icons\\ClassIcon_Rogue" },
    { id = "class_shaman", label = "Shaman", icon = "Interface\\Icons\\ClassIcon_Shaman" },
    { id = "class_warlock", label = "Warlock", icon = "Interface\\Icons\\ClassIcon_Warlock" },
    { id = "class_warrior", label = "Warrior", icon = "Interface\\Icons\\ClassIcon_Warrior" },
}

-- Navigation items configuration (with optional children)
local NAV_ITEMS = {
    { id = "home", label = "Home" },
    { id = "classes", label = "Classes", children = CLASS_ITEMS },
    { id = "zones", label = "Zones" },
}

-- Width of the navigation sidebar
local NAV_WIDTH = 140

-- Height of buttons
local BUTTON_HEIGHT = 28
local SUB_BUTTON_HEIGHT = 24
local BUTTON_SPACING = 2

--- Create a single navigation button
---@param parent Frame Parent frame for the button
---@param item table Navigation item config { id, label }
---@param isSubItem boolean Whether this is a sub-menu item
---@return Button The created nav button
local function CreateNavButton(parent, item, isSubItem)
    local btn = CreateFrame("Button", nil, parent)
    local height = isSubItem and SUB_BUTTON_HEIGHT or BUTTON_HEIGHT
    local indent = isSubItem and 16 or 0
    
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
        local iconSize = isSubItem and 16 or 18
        btn.icon = btn:CreateTexture(nil, "ARTWORK")
        btn.icon:SetSize(iconSize, iconSize)
        btn.icon:SetPoint("LEFT", btn, "LEFT", 8, 0)
        btn.icon:SetTexture(item.icon)
        btn.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- Trim icon borders
        labelOffset = 8 + iconSize + 4
    end
    
    -- Label text
    btn.label = btn:CreateFontString(nil, "OVERLAY")
    btn.label:SetFont("Fonts\\ARIALN.TTF", isSubItem and 11 or 12, "")
    btn.label:SetPoint("LEFT", btn, "LEFT", labelOffset, 0)
    btn.label:SetText(item.label)
    btn.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    -- Store the nav item data
    btn.navId = item.id
    btn.isSelected = false
    btn.isSubItem = isSubItem
    
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

--- Calculate total visible height of nav items
---@param nav Frame The navigation frame
---@return number Total height needed
local function CalculateNavHeight(nav)
    local height = 4 -- Initial padding
    for _, item in ipairs(NAV_ITEMS) do
        height = height + BUTTON_HEIGHT + BUTTON_SPACING
        if item.children and nav.expandedSections[item.id] then
            height = height + (#item.children * (SUB_BUTTON_HEIGHT + BUTTON_SPACING))
        end
    end
    return height
end

--- Reposition all buttons based on current expand state
---@param nav Frame The navigation frame
local function RepositionButtons(nav)
    local yOffset = -4
    
    for _, item in ipairs(NAV_ITEMS) do
        local btn = nav.buttons[item.id]
        if btn then
            btn:ClearAllPoints()
            btn:SetPoint("TOPLEFT", nav, "TOPLEFT", 4, yOffset)
            yOffset = yOffset - BUTTON_HEIGHT - BUTTON_SPACING
            
            -- Position children if expanded
            if item.children then
                local isExpanded = nav.expandedSections[item.id]
                SetButtonExpanded(btn, isExpanded)
                
                for _, child in ipairs(item.children) do
                    local childBtn = nav.buttons[child.id]
                    if childBtn then
                        if isExpanded then
                            childBtn:ClearAllPoints()
                            childBtn:SetPoint("TOPLEFT", nav, "TOPLEFT", 4 + 16, yOffset)
                            childBtn:Show()
                            yOffset = yOffset - SUB_BUTTON_HEIGHT - BUTTON_SPACING
                        else
                            childBtn:Hide()
                        end
                    end
                end
            end
        end
    end
end

--- Toggle a section's expanded state
---@param nav Frame The navigation frame
---@param sectionId string The section to toggle
local function ToggleSection(nav, sectionId)
    nav.expandedSections[sectionId] = not nav.expandedSections[sectionId]
    RepositionButtons(nav)
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
    
    -- Create all nav buttons
    for _, item in ipairs(NAV_ITEMS) do
        local btn = CreateNavButton(nav, item, false)
        nav.buttons[item.id] = btn
        
        -- Add expand/collapse indicator for items with children
        if item.children then
            btn.expandIcon = btn:CreateFontString(nil, "OVERLAY")
            btn.expandIcon:SetFont("Fonts\\ARIALN.TTF", 14, "")
            btn.expandIcon:SetPoint("RIGHT", btn, "RIGHT", -4, 0)
            btn.expandIcon:SetText("+")
            btn.expandIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            -- Click toggles expand and selects
            btn:SetScript("OnClick", function(self)
                ToggleSection(nav, self.navId)
                Deathless.UI.Navigation:Select(self.navId)
            end)
            
            -- Create child buttons
            for _, child in ipairs(item.children) do
                local childBtn = CreateNavButton(nav, child, true)
                nav.buttons[child.id] = childBtn
                childBtn:Hide() -- Hidden by default
                
                childBtn:SetScript("OnClick", function(self)
                    Deathless.UI.Navigation:Select(self.navId)
                end)
            end
        else
            btn:SetScript("OnClick", function(self)
                Deathless.UI.Navigation:Select(self.navId)
            end)
        end
    end
    
    -- Initial positioning
    RepositionButtons(nav)
    
    -- Track current selection
    nav.currentSelection = nil
    
    self.frame = nav
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
