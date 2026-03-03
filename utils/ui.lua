local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.UI = {}

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

---
-- Pin system for locking frame position/size
---

--- Create a pin button for a frame
-- @param frame The frame to add pin functionality to
-- @param titleBar The title bar to place the pin button in
-- @param configKey The key in Deathless.config to store pin state (e.g. "miniPinned")
-- @param options Optional table: { offsetX, Colors }
-- @return pinBtn The created pin button
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
    pinBtn.bg:SetColorTexture(0, 0, 0, 0)
    
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
        self.bg:SetColorTexture(0.18, 0.18, 0.20, 1)
        if isPinned then
            self.text:SetTextColor(Colors.accent[1] + 0.2, Colors.accent[2] + 0.1, Colors.accent[3] + 0.2, 1)
        else
            self.text:SetTextColor(1, 1, 1, 1)
        end
    end)
    
    pinBtn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(0, 0, 0, 0)
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

--- Setup drag handlers that respect pinned state
--- Uses custom drag handling for instant response (no dead zone lag)
-- @param frame The frame to setup drag handlers for
-- @param layoutKey Optional key in config.layout to save position (e.g. "mini" or "main")
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
-- @param frame The frame with resize grip
-- @param resizeGrip The resize grip button
-- @param gripTexture The grip texture for hover effects
-- @param Colors Color palette
-- @param layoutKey Optional key in config.layout to save size (e.g. "mini" or "main")
-- @param resizePoint Optional resize anchor point for StartSizing (default "BOTTOMRIGHT")
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
-- @param frame The parent frame
-- @param Colors Color palette
-- @param options Optional table: { point, relativePoint, offsetX, offsetY, style }
-- @return resizeGrip button, gripTexture texture
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

--- Create UpdateGripAlpha function that respects pinned state
-- @param frame The frame
-- @param resizeGrip The resize grip
-- @param getIsHovered Function to check if frame is hovered
-- @param getIsGripHovered Function to check if grip is hovered
-- @return UpdateGripAlpha function, gripTargetAlpha getter
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

