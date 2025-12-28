local Deathless = Deathless

Deathless.UI.Content = Deathless.UI.Content or {}

local Colors = nil

--- Create the main content panel
---@param parent Frame The main frame to attach to
---@param navWidth number Width of the navigation sidebar
---@return Frame The content frame
function Deathless.UI.Content:Create(parent, navWidth)
    Colors = Deathless.UI.Colors
    
    local content = CreateFrame("Frame", nil, parent)
    content:SetPoint("TOPLEFT", parent, "TOPLEFT", navWidth + 3, -32)
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
    
    -- Look up creator in the Views registry
    local creator = Deathless.UI.Views[viewId]
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

--- Register a custom view creator (convenience wrapper)
---@param viewId string The view identifier
---@param creator function Function that creates view content (receives container frame)
function Deathless.UI.Content:RegisterView(viewId, creator)
    Deathless.UI.Views:Register(viewId, creator)
end
