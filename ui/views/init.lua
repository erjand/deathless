local Deathless = Deathless

-- View creators registry - populated by individual view files
Deathless.UI.Views = Deathless.UI.Views or {}

-- Shared utilities for views
Deathless.UI.Views.Utils = {}

--- Get the Colors table (available after frame.lua loads)
---@return table Colors
function Deathless.UI.Views.Utils:GetColors()
    return Deathless.UI.Colors
end

--- Create a standard view header with title and subtitle
---@param container Frame The container frame
---@param title string The title text
---@param subtitle string The subtitle text
---@param titleColor table|nil Optional color override for title {r, g, b}
---@return FontString, FontString The title and subtitle font strings
function Deathless.UI.Views.Utils:CreateHeader(container, title, subtitle, titleColor)
    local Colors = self:GetColors()
    local color = titleColor or Colors.accent
    
    local titleText = container:CreateFontString(nil, "OVERLAY")
    titleText:SetFont("Fonts\\FRIZQT__.TTF", 20, "")
    titleText:SetPoint("TOPLEFT", container, "TOPLEFT", 20, -20)
    titleText:SetText(title)
    titleText:SetTextColor(color[1], color[2], color[3], 1)
    
    local subtitleText = container:CreateFontString(nil, "OVERLAY")
    subtitleText:SetFont("Fonts\\ARIALN.TTF", 12, "")
    subtitleText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -4)
    subtitleText:SetText(subtitle)
    subtitleText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    return titleText, subtitleText
end

--- Create a centered header (for home-style views)
---@param container Frame The container frame
---@param title string The title text
---@param subtitle string The subtitle text
---@return FontString, FontString The title and subtitle font strings
function Deathless.UI.Views.Utils:CreateCenteredHeader(container, title, subtitle)
    local Colors = self:GetColors()
    
    local titleText = container:CreateFontString(nil, "OVERLAY")
    titleText:SetFont("Fonts\\FRIZQT__.TTF", 24, "")
    titleText:SetPoint("TOP", container, "TOP", 0, -40)
    titleText:SetText(title)
    titleText:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    local subtitleText = container:CreateFontString(nil, "OVERLAY")
    subtitleText:SetFont("Fonts\\ARIALN.TTF", 14, "")
    subtitleText:SetPoint("TOP", titleText, "BOTTOM", 0, -8)
    subtitleText:SetText(subtitle)
    subtitleText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    return titleText, subtitleText
end

--- Register a view creator
---@param viewId string The view identifier
---@param creator function The view creator function
function Deathless.UI.Views:Register(viewId, creator)
    self[viewId] = creator
end

