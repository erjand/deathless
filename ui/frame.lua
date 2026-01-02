local Deathless = Deathless

Deathless.UI.Frame = Deathless.UI.Frame or {}

-- Color palette
local Colors = {
    bg = { 0.08, 0.08, 0.10, 0.95 },         -- Dark background
    bgLight = { 0.12, 0.12, 0.14, 1 },       -- Slightly lighter bg
    border = { 0.3, 0.3, 0.35, 1 },          -- Border color
    borderLight = { 0.4, 0.4, 0.45, 1 },     -- Hover border
    accent = { 0.4, 0.8, 0.4, 1 },           -- Green accent (matches print color)
    text = { 0.9, 0.9, 0.9, 1 },             -- Main text
    textDim = { 0.6, 0.6, 0.6, 1 },          -- Dimmed text
}

-- Helper: Create a pixel border around a frame
local function CreatePixelBorder(parent, thickness, r, g, b, a)
    thickness = thickness or 1
    r, g, b, a = r or 0.3, g or 0.3, b or 0.35, a or 1
    
    local borders = {}
    
    -- Top
    borders.top = parent:CreateTexture(nil, "BORDER")
    borders.top:SetColorTexture(r, g, b, a)
    borders.top:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    borders.top:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
    borders.top:SetHeight(thickness)
    
    -- Bottom
    borders.bottom = parent:CreateTexture(nil, "BORDER")
    borders.bottom:SetColorTexture(r, g, b, a)
    borders.bottom:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 0, 0)
    borders.bottom:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
    borders.bottom:SetHeight(thickness)
    
    -- Left
    borders.left = parent:CreateTexture(nil, "BORDER")
    borders.left:SetColorTexture(r, g, b, a)
    borders.left:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    borders.left:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", 0, 0)
    borders.left:SetWidth(thickness)
    
    -- Right
    borders.right = parent:CreateTexture(nil, "BORDER")
    borders.right:SetColorTexture(r, g, b, a)
    borders.right:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, 0)
    borders.right:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
    borders.right:SetWidth(thickness)
    
    return borders
end

-- Helper: Create a simple pixel button
local function CreatePixelButton(parent, width, height, text)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(width, height)
    
    -- Background
    btn.bg = btn:CreateTexture(nil, "BACKGROUND")
    btn.bg:SetAllPoints()
    btn.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], Colors.bgLight[4])
    
    -- Border
    btn.border = CreatePixelBorder(btn, 1, Colors.border[1], Colors.border[2], Colors.border[3], Colors.border[4])
    
    -- Text
    btn.text = btn:CreateFontString(nil, "OVERLAY")
    btn.text:SetFont("Fonts\\ARIALN.TTF", 12, "")
    btn.text:SetPoint("CENTER", 0, 0)
    btn.text:SetText(text or "")
    btn.text:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], Colors.text[4])
    
    -- Hover effects
    btn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.18, 0.18, 0.20, 1)
        self.text:SetTextColor(1, 1, 1, 1)
    end)
    
    btn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], Colors.bgLight[4])
        self.text:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], Colors.text[4])
    end)
    
    return btn
end

function Deathless.UI.Frame:Create()
    if self.mainFrame then
        return self.mainFrame
    end
    
    local PinUtils = Deathless.Utils.UI
    
    -- Create main frame
    local frame = CreateFrame("Frame", "DeathlessMainFrame", UIParent)
    frame:SetSize(800, 600)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetResizable(true)
    frame:SetResizeBounds(800, 400, 1200, 800)
    frame:RegisterForDrag("LeftButton")
    frame:SetFrameStrata("HIGH")
    
    -- Main background
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(Colors.bg[1], Colors.bg[2], Colors.bg[3], Colors.bg[4])
    
    -- Outer border
    frame.border = CreatePixelBorder(frame, 2, Colors.border[1], Colors.border[2], Colors.border[3], Colors.border[4])
    
    -- Title bar background
    local titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
    titleBar:SetHeight(30)
    
    titleBar.bg = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBar.bg:SetAllPoints()
    titleBar.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], Colors.bgLight[4])
    
    -- Title bar bottom border
    local titleBorder = titleBar:CreateTexture(nil, "BORDER")
    titleBorder:SetPoint("BOTTOMLEFT", titleBar, "BOTTOMLEFT", 0, 0)
    titleBorder:SetPoint("BOTTOMRIGHT", titleBar, "BOTTOMRIGHT", 0, 0)
    titleBorder:SetHeight(1)
    titleBorder:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], Colors.border[4])
    
    -- Title text
    local title = titleBar:CreateFontString(nil, "OVERLAY")
    title:SetFont("Fonts\\ARIALN.TTF", 14, "")
    title:SetPoint("LEFT", titleBar, "LEFT", 10, 0)
    title:SetText("DEATHLESS")
    title:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], Colors.accent[4])
    
    -- Pin button (using shared utility)
    local pinBtn = PinUtils.CreatePinButton(frame, titleBar, "mainPinned", { offsetX = -28, Colors = Colors })
    
    -- Close button
    local closeBtn = CreatePixelButton(titleBar, 20, 20, "x")
    closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", -4, 0)
    closeBtn:SetScript("OnClick", function()
        self:Hide()
    end)
    
    -- Create navigation sidebar
    local navigation = Deathless.UI.Navigation:Create(frame)
    
    -- Create content panel (positioned to the right of nav)
    local navWidth = Deathless.UI.Navigation:GetWidth()
    local content = Deathless.UI.Content:Create(frame, navWidth)
    
    -- Select home by default
    C_Timer.After(0, function()
        Deathless.UI.Navigation:Select("home")
    end)
    
    -- Resize grip (bottom-right corner, auto-hiding)
    local resizeGrip = CreateFrame("Button", nil, frame)
    resizeGrip:SetSize(16, 16)
    resizeGrip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
    resizeGrip:SetFrameLevel(frame:GetFrameLevel() + 10)
    resizeGrip:EnableMouse(true)
    resizeGrip:SetAlpha(0)
    
    -- Grip texture (diagonal lines)
    local gripTexture = resizeGrip:CreateTexture(nil, "OVERLAY")
    gripTexture:SetSize(12, 12)
    gripTexture:SetPoint("CENTER", 0, 0)
    gripTexture:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.6)
    
    -- Create diagonal grip lines
    for i = 1, 3 do
        local line = resizeGrip:CreateTexture(nil, "OVERLAY")
        line:SetColorTexture(Colors.borderLight[1], Colors.borderLight[2], Colors.borderLight[3], 0.8)
        line:SetSize(2, 2)
        line:SetPoint("BOTTOMRIGHT", resizeGrip, "BOTTOMRIGHT", -2 - (i * 3), 2 + (i * 3))
    end
    
    frame.resizeGrip = resizeGrip
    local isFrameHovered = false
    local isGripHovered = false
    frame.isGripHovered = function() return isGripHovered end
    frame.setGripHovered = function(val) isGripHovered = val end
    
    -- Setup pinnable resize behavior
    PinUtils.SetupPinnableResize(frame, resizeGrip, gripTexture, Colors)
    
    -- Setup pinnable drag behavior
    PinUtils.SetupPinnableDrag(frame)
    
    -- Setup grip alpha updater using shared utility
    local UpdateGripAlpha, getGripTargetAlpha = PinUtils.CreateGripAlphaUpdater(
        frame, resizeGrip,
        function() return isFrameHovered end,
        frame.isGripHovered
    )
    
    -- Smooth fade animation via OnUpdate
    frame:SetScript("OnUpdate", function(self, elapsed)
        local wasHovered = isFrameHovered
        isFrameHovered = self:IsMouseOver()
        if isFrameHovered ~= wasHovered then
            UpdateGripAlpha()
        end
        
        local gripTargetAlpha = getGripTargetAlpha()
        local current = resizeGrip:GetAlpha()
        if math.abs(current - gripTargetAlpha) > 0.01 then
            local speed = 5 * elapsed
            resizeGrip:SetAlpha(current + (gripTargetAlpha - current) * math.min(speed, 1))
        elseif current ~= gripTargetAlpha then
            resizeGrip:SetAlpha(gripTargetAlpha)
        end
    end)
    
    -- Store references
    frame.titleBar = titleBar
    frame.title = title
    frame.pinBtn = pinBtn
    frame.navigation = navigation
    frame.content = content
    
    -- Hide by default
    frame:Hide()
    
    -- ESC to close
    tinsert(UISpecialFrames, "DeathlessMainFrame")
    
    self.mainFrame = frame
    return frame
end

function Deathless.UI.Frame:Show()
    if not self.mainFrame then
        self:Create()
    end
    self.mainFrame:Show()
end

function Deathless.UI.Frame:Hide()
    if self.mainFrame then
        self.mainFrame:Hide()
    end
end

-- Export helpers for other UI components
Deathless.UI.Colors = Colors
Deathless.UI.CreatePixelBorder = CreatePixelBorder
Deathless.UI.CreatePixelButton = CreatePixelButton
