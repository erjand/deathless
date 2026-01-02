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

--- Create a standard view header with title, subtitle, and separator
---@param container Frame The container frame
---@param title string The title text
---@param subtitle string The subtitle text
---@param titleColor table|nil Optional color override for title {r, g, b}
---@return FontString, FontString, Texture The title, subtitle, and separator
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
    
    -- Horizontal separator below subtitle
    local separator = container:CreateTexture(nil, "ARTWORK")
    separator:SetHeight(1)
    separator:SetPoint("TOPLEFT", subtitleText, "BOTTOMLEFT", 0, -10)
    separator:SetPoint("RIGHT", container, "RIGHT", -20, 0)
    separator:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
    
    return titleText, subtitleText, separator
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

--- Create an enhanced scroll frame with auto-hiding thin scrollbar
---@param parent Frame The parent container
---@param topOffset number Offset from top (negative)
---@param bottomOffset number Offset from bottom
---@return ScrollFrame, Frame The scroll frame and scroll child
function Deathless.UI.Views.Utils:CreateScrollFrame(parent, topOffset, bottomOffset)
    local Colors = self:GetColors()
    
    -- Create scroll frame (no template - custom indicator)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent)
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, topOffset)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -8, bottomOffset)
    
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)
    
    -- Custom scroll indicator (thin bar on right side)
    local scrollIndicator = CreateFrame("Frame", nil, parent)
    scrollIndicator:SetWidth(3)
    scrollIndicator:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -4, topOffset - 4)
    scrollIndicator:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -4, bottomOffset + 4)
    scrollIndicator:SetFrameLevel(parent:GetFrameLevel() + 5)
    scrollIndicator:SetAlpha(0)
    
    local scrollThumb = scrollIndicator:CreateTexture(nil, "OVERLAY")
    scrollThumb:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.7)
    scrollThumb:SetPoint("TOP", scrollIndicator, "TOP", 0, 0)
    scrollThumb:SetWidth(3)
    scrollThumb:SetHeight(20)
    
    -- Scrollbar auto-hide state
    local isHovered = false
    local isScrollable = false
    local hideTimer = nil
    local targetAlpha = 0
    
    local function UpdateScrollbarAlpha()
        if isScrollable and isHovered then
            targetAlpha = 1
            if hideTimer then hideTimer:Cancel() hideTimer = nil end
        else
            if not hideTimer then
                hideTimer = C_Timer.NewTimer(1.0, function()
                    targetAlpha = 0
                    hideTimer = nil
                end)
            end
        end
    end
    
    local function UpdateScrollThumb()
        local contentHeight = scrollChild:GetHeight()
        local viewHeight = scrollFrame:GetHeight()
        local maxScroll = contentHeight - viewHeight
        
        isScrollable = maxScroll > 1
        
        if isScrollable then
            local trackHeight = scrollIndicator:GetHeight()
            local thumbRatio = viewHeight / contentHeight
            local thumbHeight = math.max(12, trackHeight * thumbRatio)
            scrollThumb:SetHeight(thumbHeight)
            
            local scrollPos = scrollFrame:GetVerticalScroll()
            local thumbOffset = (scrollPos / maxScroll) * (trackHeight - thumbHeight)
            scrollThumb:ClearAllPoints()
            scrollThumb:SetPoint("TOP", scrollIndicator, "TOP", 0, -thumbOffset)
        end
        
        UpdateScrollbarAlpha()
    end
    
    -- Store reference for external updates
    scrollFrame.UpdateScrollbar = UpdateScrollThumb
    
    -- Smooth scroll tracking
    local targetScroll = 0
    local SCROLL_SPEED = 0.25
    local SCROLL_STEP = 40
    
    -- Combined OnUpdate: hover detection + smooth fade + scroll animation
    scrollFrame:SetScript("OnUpdate", function(self, elapsed)
        -- Check hover state
        local wasHovered = isHovered
        isHovered = parent:IsMouseOver()
        if isHovered ~= wasHovered then
            UpdateScrollbarAlpha()
        end
        
        -- Smooth fade animation for scroll indicator
        local current = scrollIndicator:GetAlpha()
        if math.abs(current - targetAlpha) > 0.01 then
            local speed = 5 * elapsed
            scrollIndicator:SetAlpha(current + (targetAlpha - current) * math.min(speed, 1))
        elseif current ~= targetAlpha then
            scrollIndicator:SetAlpha(targetAlpha)
        end
        
        -- Smooth scroll animation
        local currentScroll = self:GetVerticalScroll()
        if math.abs(currentScroll - targetScroll) > 0.5 then
            local newScroll = currentScroll + (targetScroll - currentScroll) * SCROLL_SPEED
            self:SetVerticalScroll(newScroll)
            UpdateScrollThumb()
        elseif currentScroll ~= targetScroll then
            self:SetVerticalScroll(targetScroll)
            UpdateScrollThumb()
        end
    end)
    
    -- Mouse wheel handling
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local maxScroll = scrollChild:GetHeight() - scrollFrame:GetHeight()
        if maxScroll < 0 then maxScroll = 0 end
        targetScroll = targetScroll - (delta * SCROLL_STEP)
        targetScroll = math.max(0, math.min(targetScroll, maxScroll))
        
        -- Flash scrollbar on wheel
        if isScrollable then
            targetAlpha = 1
            if hideTimer then hideTimer:Cancel() end
            hideTimer = C_Timer.NewTimer(1.0, function()
                if not isHovered then targetAlpha = 0 end
                hideTimer = nil
            end)
        end
    end)
    
    -- Method to reset scroll position
    scrollFrame.ResetScroll = function()
        targetScroll = 0
        scrollFrame:SetVerticalScroll(0)
        UpdateScrollThumb()
    end
    
    return scrollFrame, scrollChild
end

