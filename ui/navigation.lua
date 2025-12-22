local Deathless = Deathless

Deathless.UI.Navigation = Deathless.UI.Navigation or {}

local Colors = nil -- Set after frame.lua loads
local CreatePixelBorder = nil

-- Navigation items configuration
local NAV_ITEMS = {
    { id = "home", label = "Home", icon = nil },
    { id = "classes", label = "Classes", icon = nil },
    { id = "zones", label = "Zones", icon = nil },
}

-- Width of the navigation sidebar
local NAV_WIDTH = 140

--- Create a single navigation button
---@param parent Frame Parent frame for the button
---@param item table Navigation item config { id, label, icon }
---@param index number Button index (1-based, for positioning)
---@return Button The created nav button
local function CreateNavButton(parent, item, index)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(NAV_WIDTH - 8, 32)
    btn:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -4 - ((index - 1) * 36))
    
    -- Background (transparent by default, visible when selected/hovered)
    btn.bg = btn:CreateTexture(nil, "BACKGROUND")
    btn.bg:SetAllPoints()
    btn.bg:SetColorTexture(0, 0, 0, 0)
    
    -- Selection indicator (left accent bar)
    btn.indicator = btn:CreateTexture(nil, "ARTWORK")
    btn.indicator:SetSize(3, 24)
    btn.indicator:SetPoint("LEFT", btn, "LEFT", 0, 0)
    btn.indicator:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    btn.indicator:Hide()
    
    -- Label text
    btn.label = btn:CreateFontString(nil, "OVERLAY")
    btn.label:SetFont("Fonts\\ARIALN.TTF", 12, "")
    btn.label:SetPoint("LEFT", btn, "LEFT", 12, 0)
    btn.label:SetText(item.label)
    btn.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    -- Store the nav item data
    btn.navId = item.id
    btn.isSelected = false
    
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
    
    -- Create nav buttons
    nav.buttons = {}
    for i, item in ipairs(NAV_ITEMS) do
        local btn = CreateNavButton(nav, item, i)
        nav.buttons[item.id] = btn
        
        -- Click handler
        btn:SetScript("OnClick", function(self)
            Deathless.UI.Navigation:Select(self.navId)
        end)
    end
    
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
