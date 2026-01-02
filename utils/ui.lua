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
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(font or "Fonts\\FRIZQT__.TTF", size or 12, outline or "")
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
    
    pinBtn.text = pinBtn:CreateFontString(nil, "OVERLAY")
    pinBtn.text:SetFont("Fonts\\ARIALN.TTF", 10, "")
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
-- @param frame The frame to setup drag handlers for
function Deathless.Utils.UI.SetupPinnableDrag(frame)
    frame:SetScript("OnDragStart", function(self)
        if not self.IsPinned or not self.IsPinned() then
            self:StartMoving()
        end
    end)
    frame:SetScript("OnDragStop", function(self)
        if not self.IsPinned or not self.IsPinned() then
            self:StopMovingOrSizing()
            -- Re-anchor to TOPLEFT after dragging to prevent resize jump
            local left, top = self:GetLeft(), self:GetTop()
            self:ClearAllPoints()
            self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
        end
    end)
end

--- Setup resize grip that respects pinned state
-- @param frame The frame with resize grip
-- @param resizeGrip The resize grip button
-- @param gripTexture The grip texture for hover effects
-- @param Colors Color palette
function Deathless.Utils.UI.SetupPinnableResize(frame, resizeGrip, gripTexture, Colors)
    resizeGrip:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and (not frame.IsPinned or not frame.IsPinned()) then
            local left, top = frame:GetLeft(), frame:GetTop()
            frame:ClearAllPoints()
            frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
            frame:StartSizing("BOTTOMRIGHT")
        end
    end)
    
    resizeGrip:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
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

