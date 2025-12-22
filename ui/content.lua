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
