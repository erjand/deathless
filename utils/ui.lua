local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.UI = {}

--- Shared UI helpers: colorized text, striped rows, scroll indicator, frame chrome (pin, drag, resize).

--- Wrap text in a WoW color escape sequence.
---@param color table {r, g, b} floats 0–1
---@param text string
---@return string
function Deathless.Utils.UI.ColorizeText(color, text)
    local r = math.floor((color[1] or 1) * 255 + 0.5)
    local g = math.floor((color[2] or 1) * 255 + 0.5)
    local b = math.floor((color[3] or 1) * 255 + 0.5)
    return string.format("|cff%02x%02x%02x%s|r", r, g, b, text)
end

-- Create a simple frame
function Deathless.Utils.UI.CreateFrame(name, parent, template)
    local frame = CreateFrame("Frame", name, parent, template)
    return frame
end

-- Create a font string
function Deathless.Utils.UI.CreateFontString(parent, font, size, outline)
    local Fonts = Deathless.UI.Fonts
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(font or Fonts.family, size or Fonts.sectionHeader, outline or "")
    return fs
end

local function GetUIStyle()
    local ui = Deathless.Constants.Colors.UI
    return ui.Row, ui.Icon
end

local RowBackgroundCache = setmetatable({}, { __mode = "k" })

--- Apply standard striped row background styling.
---@param row Frame
---@param colors table
---@param rowNum number
---@param isExpanded boolean|nil
function Deathless.Utils.UI.ApplyStripedRowBackground(row, colors, rowNum, isExpanded)
    local rowStyle = GetUIStyle()
    local style = rowStyle
    local bg = RowBackgroundCache[row]
    if not bg then
        bg = row:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        RowBackgroundCache[row] = bg
    end
    row._rowBg = bg ---@diagnostic disable-line: inject-field

    if isExpanded then
        bg:SetColorTexture(colors.bgLight[1], colors.bgLight[2], colors.bgLight[3], style.expandedAlpha)
        bg:Show()
    elseif rowNum and rowNum % 2 == 0 then
        bg:SetColorTexture(colors.bgLight[1], colors.bgLight[2], colors.bgLight[3], style.stripeAlpha)
        bg:Show()
    else
        bg:Hide()
    end
end

--- Apply standard icon desaturation/alpha mode.
---@param icon Texture
---@param mode string|nil normal|muted|dimmed|faded|disabled
function Deathless.Utils.UI.ApplyIconStyle(icon, mode)
    local _, iconStyle = GetUIStyle()
    local preset = mode or "normal"

    if preset == "muted" then
        icon:SetDesaturated(true)
        icon:SetAlpha(iconStyle.alphaMuted)
    elseif preset == "dimmed" then
        icon:SetDesaturated(true)
        icon:SetAlpha(iconStyle.alphaDimmed)
    elseif preset == "faded" then
        icon:SetDesaturated(true)
        icon:SetAlpha(iconStyle.alphaFaded)
    elseif preset == "disabled" then
        icon:SetDesaturated(true)
        icon:SetAlpha(iconStyle.alphaDisabled)
    else
        icon:SetDesaturated(false)
        icon:SetAlpha(iconStyle.alphaNormal)
    end
end

--- Create a thin auto-hiding scroll indicator for a scroll frame.
---@param scrollFrame ScrollFrame
---@param scrollChild Frame
---@param options table { parent, hoverFrame, topRight, bottomRight, frameLevelParent, updateFrame, smoothScroll, wheelStep }
---@return table controller { UpdateScrollThumb, ResetScroll, indicator }
function Deathless.Utils.UI.CreateAutoHideScrollIndicator(scrollFrame, scrollChild, options)
    options = options or {}

    local Colors = Deathless.UI.Colors
    local cfg = (
        Deathless.Constants
        and Deathless.Constants.Colors
        and Deathless.Constants.Colors.UI
        and Deathless.Constants.Colors.UI.ScrollIndicator
    ) or {
        fadeDelay = 1.0,
        fadeSpeed = 5,
        thumbAlpha = 0.7,
        thumbDefaultHeight = 20,
        thumbMinHeight = 12,
        trackWidth = 3,
        wheelStep = 40,
        smoothSpeed = 0.25,
        smoothThreshold = 0.5,
    }
    local parent = options.parent
    local hoverFrame = options.hoverFrame or parent
    local frameLevelParent = options.frameLevelParent or parent
    local updateFrame = options.updateFrame or scrollFrame
    local smoothScroll = options.smoothScroll ~= false
    local wheelStep = options.wheelStep or cfg.wheelStep

    local topRight = options.topRight or { -4, -4 }
    local bottomRight = options.bottomRight or { -4, 4 }

    local scrollIndicator = CreateFrame("Frame", nil, parent)
    scrollIndicator:SetWidth(cfg.trackWidth)
    scrollIndicator:SetPoint("TOPRIGHT", parent, "TOPRIGHT", topRight[1], topRight[2])
    scrollIndicator:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", bottomRight[1], bottomRight[2])
    scrollIndicator:SetFrameLevel(frameLevelParent:GetFrameLevel() + 5)
    scrollIndicator:SetAlpha(0)

    local scrollThumb = scrollIndicator:CreateTexture(nil, "OVERLAY")
    scrollThumb:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], cfg.thumbAlpha)
    scrollThumb:SetPoint("TOP", scrollIndicator, "TOP", 0, 0)
    scrollThumb:SetWidth(cfg.trackWidth)
    scrollThumb:SetHeight(cfg.thumbDefaultHeight)

    local isHovered = false
    local isScrollable = false
    local hideTimer = nil
    local targetAlpha = 0
    local targetScroll = 0

    local function UpdateScrollbarAlpha()
        if isScrollable and isHovered then
            targetAlpha = 1
            if hideTimer then
                hideTimer:Cancel()
                hideTimer = nil
            end
        else
            if not hideTimer then
                hideTimer = C_Timer.NewTimer(cfg.fadeDelay, function()
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
            local thumbHeight = math.max(cfg.thumbMinHeight, trackHeight * thumbRatio)
            scrollThumb:SetHeight(thumbHeight)

            local scrollPos = scrollFrame:GetVerticalScroll()
            local thumbOffset = (scrollPos / maxScroll) * (trackHeight - thumbHeight)
            scrollThumb:ClearAllPoints()
            scrollThumb:SetPoint("TOP", scrollIndicator, "TOP", 0, -thumbOffset)
        end

        UpdateScrollbarAlpha()
    end

    local function FlashScrollbar()
        if isScrollable then
            targetAlpha = 1
            if hideTimer then
                hideTimer:Cancel()
            end
            hideTimer = C_Timer.NewTimer(cfg.fadeDelay, function()
                if not isHovered then
                    targetAlpha = 0
                end
                hideTimer = nil
            end)
        end
    end

    updateFrame:HookScript("OnUpdate", function(_, elapsed)
        local wasHovered = isHovered
        isHovered = hoverFrame:IsMouseOver()
        if isHovered ~= wasHovered then
            UpdateScrollbarAlpha()
        end

        local currentAlpha = scrollIndicator:GetAlpha()
        if math.abs(currentAlpha - targetAlpha) > 0.01 then
            local speed = cfg.fadeSpeed * elapsed
            scrollIndicator:SetAlpha(currentAlpha + (targetAlpha - currentAlpha) * math.min(speed, 1))
        elseif currentAlpha ~= targetAlpha then
            scrollIndicator:SetAlpha(targetAlpha)
        end

        if smoothScroll then
            local currentScroll = scrollFrame:GetVerticalScroll()
            if math.abs(currentScroll - targetScroll) > cfg.smoothThreshold then
                local newScroll = currentScroll + (targetScroll - currentScroll) * cfg.smoothSpeed
                scrollFrame:SetVerticalScroll(newScroll)
                UpdateScrollThumb()
            elseif currentScroll ~= targetScroll then
                scrollFrame:SetVerticalScroll(targetScroll)
                UpdateScrollThumb()
            end
        end
    end)

    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local maxScroll = scrollChild:GetHeight() - scrollFrame:GetHeight()
        if maxScroll < 0 then
            maxScroll = 0
        end

        if smoothScroll then
            targetScroll = targetScroll - (delta * wheelStep)
            targetScroll = math.max(0, math.min(targetScroll, maxScroll))
        else
            local currentScroll = self:GetVerticalScroll()
            local newScroll = currentScroll - (delta * wheelStep)
            targetScroll = math.max(0, math.min(newScroll, maxScroll))
            self:SetVerticalScroll(targetScroll)
            UpdateScrollThumb()
        end

        FlashScrollbar()
    end)

    local function ResetScroll()
        targetScroll = 0
        scrollFrame:SetVerticalScroll(0)
        UpdateScrollThumb()
    end

    return {
        UpdateScrollThumb = UpdateScrollThumb,
        ResetScroll = ResetScroll,
        indicator = scrollIndicator,
    }
end

--- Pin system for locking frame position/size

--- Create a pin button for a frame
---@param frame Frame
---@param titleBar Frame
---@param configKey string
---@param options table|nil { offsetX, Colors }
---@return Frame pinBtn
function Deathless.Utils.UI.CreatePinButton(frame, titleBar, configKey, options)
    options = options or {}
    local Colors = options.Colors or Deathless.UI.Colors
    local offsetX = options.offsetX or -20
    
    -- Track pinned state
    local isPinned = Deathless.config[configKey] or false
    
    -- Create pin button
    local pinBtn = CreateFrame("Button", nil, titleBar)
    pinBtn:SetSize(14, 14)
    pinBtn:SetPoint("RIGHT", titleBar, "RIGHT", offsetX, 0)
    
    pinBtn.bg = pinBtn:CreateTexture(nil, "BACKGROUND")
    pinBtn.bg:SetAllPoints()
    pinBtn.bg:SetColorTexture(Colors.transparent[1], Colors.transparent[2], Colors.transparent[3], Colors.transparent[4])
    
    local Fonts = Deathless.UI.Fonts
    pinBtn.text = pinBtn:CreateFontString(nil, "OVERLAY")
    pinBtn.text:SetFont(Fonts.icons, Fonts.body, "")
    pinBtn.text:SetPoint("CENTER", 0, 0)
    
    -- Update visual state and frame properties
    local function UpdatePinState()
        if isPinned then
            pinBtn.text:SetText("P")
            pinBtn.text:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
            frame:SetMovable(false)
            frame:SetResizable(false)
            frame:RegisterForDrag()
            -- Immediately hide resize grip when pinned
            if frame.resizeGrip then
                frame.resizeGrip:SetAlpha(0)
            end
        else
            pinBtn.text:SetText("p")
            pinBtn.text:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            frame:SetMovable(true)
            frame:SetResizable(true)
            frame:RegisterForDrag("LeftButton")
        end
        -- Update grip visibility
        if frame.UpdateGripAlpha then
            frame.UpdateGripAlpha()
        end
    end
    
    UpdatePinState()
    
    pinBtn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(Colors.hover[1], Colors.hover[2], Colors.hover[3], Colors.hover[4])
        if isPinned then
            self.text:SetTextColor(Colors.accent[1] + 0.2, Colors.accent[2] + 0.1, Colors.accent[3] + 0.2, 1)
        else
            self.text:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], Colors.white[4])
        end
    end)
    
    pinBtn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(Colors.transparent[1], Colors.transparent[2], Colors.transparent[3], Colors.transparent[4])
        UpdatePinState()
    end)
    
    pinBtn:SetScript("OnClick", function()
        isPinned = not isPinned
        Deathless.config[configKey] = isPinned
        Deathless:SaveConfig()
        UpdatePinState()
    end)
    
    -- Expose state check for other code
    pinBtn.IsPinned = function() return isPinned end
    pinBtn.UpdatePinState = UpdatePinState
    
    -- Store on frame for easy access
    frame.pinBtn = pinBtn
    frame.IsPinned = pinBtn.IsPinned
    
    return pinBtn
end

--- Setup drag handlers that respect pinned state (instant response, no dead zone lag).
---@param frame Frame
---@param layoutKey string|nil Key in `config.layout` for saved position (e.g. `"mini"`, `"main"`).
function Deathless.Utils.UI.SetupPinnableDrag(frame, layoutKey)
    local isDragging = false
    local dragOffsetX, dragOffsetY = 0, 0
    
    -- Track mouse position relative to frame on mouse down
    frame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and (not self.IsPinned or not self.IsPinned()) then
            local scale = self:GetEffectiveScale()
            local cursorX, cursorY = GetCursorPosition()
            cursorX, cursorY = cursorX / scale, cursorY / scale
            
            dragOffsetX = cursorX - self:GetLeft()
            dragOffsetY = cursorY - self:GetTop()
            isDragging = true
        end
    end)
    
    frame:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and isDragging then
            isDragging = false
            
            -- Save position if layout key provided
            if layoutKey and Deathless.config.layout then
                local left, top = self:GetLeft(), self:GetTop()
                Deathless.config.layout[layoutKey] = Deathless.config.layout[layoutKey] or {}
                Deathless.config.layout[layoutKey].point = "TOPLEFT"
                Deathless.config.layout[layoutKey].x = left
                Deathless.config.layout[layoutKey].y = top
                Deathless:SaveConfig()
            end
        end
    end)
    
    -- Store drag update function for OnUpdate handler
    frame.UpdateDrag = function(self)
        if isDragging then
            -- Stop dragging if mouse button released (handles release outside frame)
            if not IsMouseButtonDown("LeftButton") then
                isDragging = false
                
                -- Save position if layout key provided
                if layoutKey and Deathless.config.layout then
                    local left, top = self:GetLeft(), self:GetTop()
                    Deathless.config.layout[layoutKey] = Deathless.config.layout[layoutKey] or {}
                    Deathless.config.layout[layoutKey].point = "TOPLEFT"
                    Deathless.config.layout[layoutKey].x = left
                    Deathless.config.layout[layoutKey].y = top
                    Deathless:SaveConfig()
                end
                return
            end
            
            local scale = self:GetEffectiveScale()
            local cursorX, cursorY = GetCursorPosition()
            cursorX, cursorY = cursorX / scale, cursorY / scale
            
            local newLeft = cursorX - dragOffsetX
            local newTop = cursorY - dragOffsetY
            
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", newLeft, newTop)
        end
    end
    
    -- Also clear drag state when hiding
    frame:HookScript("OnHide", function()
        isDragging = false
    end)
end

--- Setup resize grip that respects pinned state
---@param frame Frame
---@param resizeGrip Button
---@param gripTexture Texture
---@param Colors table
---@param layoutKey string|nil
---@param resizePoint string|nil Resize anchor for `StartSizing` (default `"BOTTOMRIGHT"`).
function Deathless.Utils.UI.SetupPinnableResize(frame, resizeGrip, gripTexture, Colors, layoutKey, resizePoint)
    local startSizingPoint = resizePoint or "BOTTOMRIGHT"

    resizeGrip:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and (not frame.IsPinned or not frame.IsPinned()) then
            -- Only re-anchor if not already anchored to TOPLEFT to prevent jump
            local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint(1)
            if point ~= "TOPLEFT" or relativeTo ~= UIParent or relativePoint ~= "BOTTOMLEFT" then
                local left, top = frame:GetLeft(), frame:GetTop()
                frame:ClearAllPoints()
                frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
            end
            frame:StartSizing(startSizingPoint)
        end
    end)
    
    resizeGrip:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
        
        -- Save size if layout key provided
        if layoutKey and Deathless.config.layout then
            Deathless.config.layout[layoutKey] = Deathless.config.layout[layoutKey] or {}
            Deathless.config.layout[layoutKey].width = frame:GetWidth()
            Deathless.config.layout[layoutKey].height = frame:GetHeight()
            Deathless:SaveConfig()
        end
    end)
    
    resizeGrip:SetScript("OnEnter", function(self)
        if frame.setGripHovered then frame.setGripHovered(true) end
        gripTexture:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.5)
    end)
    
    resizeGrip:SetScript("OnLeave", function(self)
        if frame.setGripHovered then frame.setGripHovered(false) end
        gripTexture:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
    end)
end

--- Create a resize grip for a frame
---@param frame Frame
---@param Colors table
---@param options table|nil { point, relativePoint, offsetX, offsetY, style }
---@return Button resizeGrip, Texture gripTexture
function Deathless.Utils.UI.CreateResizeGrip(frame, Colors, options)
    options = options or {}
    local point = options.point or "BOTTOMRIGHT"
    local relativePoint = options.relativePoint or point
    local offsetX = options.offsetX
    local offsetY = options.offsetY
    local style = options.style or "corner"

    if offsetX == nil then
        offsetX = point == "BOTTOMRIGHT" and -2 or 0
    end
    if offsetY == nil then
        offsetY = point == "BOTTOMRIGHT" and 2 or 2
    end

    local resizeGrip = CreateFrame("Button", nil, frame)
    if style == "bottom" then
        resizeGrip:SetSize(24, 12)
    else
        resizeGrip:SetSize(16, 16)
    end
    resizeGrip:SetPoint(point, frame, relativePoint, offsetX, offsetY)
    resizeGrip:SetFrameLevel(frame:GetFrameLevel() + 10)
    resizeGrip:EnableMouse(true)
    resizeGrip:SetAlpha(0)
    
    -- Grip texture
    local gripTexture = resizeGrip:CreateTexture(nil, "OVERLAY")
    if style == "bottom" then
        gripTexture:SetSize(16, 4)
    else
        gripTexture:SetSize(12, 12)
    end
    gripTexture:SetPoint("CENTER", 0, 0)
    gripTexture:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.6)
    
    -- Create resize hint lines
    if style == "bottom" then
        for i = 1, 3 do
            local line = resizeGrip:CreateTexture(nil, "OVERLAY")
            line:SetColorTexture(Colors.borderLight[1], Colors.borderLight[2], Colors.borderLight[3], 0.85)
            line:SetSize(14, 1)
            line:SetPoint("CENTER", resizeGrip, "CENTER", 0, i - 2)
        end
    else
        for i = 1, 3 do
            local line = resizeGrip:CreateTexture(nil, "OVERLAY")
            line:SetColorTexture(Colors.borderLight[1], Colors.borderLight[2], Colors.borderLight[3], 0.8)
            line:SetSize(2, 2)
            line:SetPoint("BOTTOMRIGHT", resizeGrip, "BOTTOMRIGHT", -2 - (i * 3), 2 + (i * 3))
        end
    end
    
    -- Store on frame for easy access
    frame.resizeGrip = resizeGrip
    
    -- Setup grip hover state tracking
    local isGripHovered = false
    frame.isGripHovered = function() return isGripHovered end
    frame.setGripHovered = function(val) isGripHovered = val end
    
    return resizeGrip, gripTexture
end

--- Create a grip alpha updater that respects pinned state
---@param frame Frame
---@param resizeGrip Button
---@param getIsHovered fun(): boolean
---@param getIsGripHovered fun(): boolean
---@return function UpdateGripAlpha, function gripTargetAlphaGetter
function Deathless.Utils.UI.CreateGripAlphaUpdater(frame, resizeGrip, getIsHovered, getIsGripHovered)
    local gripTargetAlpha = 0
    local gripHideTimer = nil
    
    local function UpdateGripAlpha()
        -- Always hide grip when pinned
        if frame.IsPinned and frame.IsPinned() then
            gripTargetAlpha = 0
            if gripHideTimer then gripHideTimer:Cancel() gripHideTimer = nil end
        elseif getIsHovered() or getIsGripHovered() then
            gripTargetAlpha = 1
            if gripHideTimer then gripHideTimer:Cancel() gripHideTimer = nil end
        else
            if not gripHideTimer then
                gripHideTimer = C_Timer.NewTimer(1.0, function()
                    gripTargetAlpha = 0
                    gripHideTimer = nil
                end)
            end
        end
    end
    
    frame.UpdateGripAlpha = UpdateGripAlpha
    
    return UpdateGripAlpha, function() return gripTargetAlpha end
end

