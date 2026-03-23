local Deathless = Deathless

Deathless.UI.Frame = Deathless.UI.Frame or {}

local MAIN_MIN_WIDTH = 800
local MAIN_MAX_WIDTH = 800
local MAIN_DEFAULT_HEIGHT = 600
local MAIN_MIN_HEIGHT = 400
local MAIN_MAX_HEIGHT = 800

local Colors = Deathless.Constants.Colors.UI

-- Helper: Create a pixel border around a frame
local function CreatePixelBorder(parent, thickness, r, g, b, a)
    thickness = thickness or 1
    r = r or Colors.border[1]
    g = g or Colors.border[2]
    b = b or Colors.border[3]
    a = a or Colors.border[4]
    
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

-- Helper: Create a simple close button (borderless 'x')
local function CreateCloseButton(parent, options)
    options = options or {}
    local size = options.size or 14
    local fontSize = options.fontSize or Deathless.UI.Fonts.small
    local offsetX = options.offsetX or -3
    
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(size, size)
    btn:SetPoint("RIGHT", parent, "RIGHT", offsetX, 0)
    
    btn.bg = btn:CreateTexture(nil, "BACKGROUND")
    btn.bg:SetAllPoints()
    btn.bg:SetColorTexture(Colors.transparent[1], Colors.transparent[2], Colors.transparent[3], Colors.transparent[4])
    
    local Fonts = Deathless.UI.Fonts
    btn.text = btn:CreateFontString(nil, "OVERLAY")
    btn.text:SetFont(Fonts.family, fontSize, "")
    btn.text:SetPoint("CENTER", 0, 0)
    btn.text:SetText("x")
    btn.text:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    btn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(Colors.hover[1], Colors.hover[2], Colors.hover[3], Colors.hover[4])
        self.text:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], Colors.white[4])
    end)
    btn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(Colors.transparent[1], Colors.transparent[2], Colors.transparent[3], Colors.transparent[4])
        self.text:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    end)
    
    if options.onClick then
        btn:SetScript("OnClick", options.onClick)
    end
    
    return btn
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
    local Fonts = Deathless.UI.Fonts
    btn.text = btn:CreateFontString(nil, "OVERLAY")
    btn.text:SetFont(Fonts.family, Fonts.subtitle, "")
    btn.text:SetPoint("CENTER", 0, 0)
    btn.text:SetText(text or "")
    btn.text:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], Colors.text[4])
    
    -- Hover effects
    btn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(Colors.hover[1], Colors.hover[2], Colors.hover[3], Colors.hover[4])
        self.text:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], Colors.white[4])
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
    
    -- Restore saved layout (use TOPLEFT->BOTTOMLEFT for absolute positioning if saved)
    local layout = Deathless.config.layout and Deathless.config.layout.main or {}
    frame:SetSize(MAIN_MIN_WIDTH, layout.height or MAIN_DEFAULT_HEIGHT)
    if layout.x and layout.y and layout.point == "TOPLEFT" then
        frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", layout.x, layout.y)
    else
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    end
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetResizable(true)
    frame:SetResizeBounds(MAIN_MIN_WIDTH, MAIN_MIN_HEIGHT, MAIN_MAX_WIDTH, MAIN_MAX_HEIGHT)
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
    local Fonts = Deathless.UI.Fonts
    local title = titleBar:CreateFontString(nil, "OVERLAY")
    title:SetFont(Fonts.family, Fonts.header, "")
    title:SetPoint("LEFT", titleBar, "LEFT", 10, 0)
    title:SetText("DEATHLESS")
    title:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], Colors.accent[4])
    
    local titleVersion = titleBar:CreateFontString(nil, "OVERLAY")
    titleVersion:SetFont(Fonts.family, Fonts.small, "")
    titleVersion:SetPoint("LEFT", title, "RIGHT", 4, -1)
    titleVersion:SetText("(" .. Deathless.Constants.Metadata.VERSION .. ")")
    titleVersion:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], Colors.textDim[4])
    
    -- Pin button (using shared utility)
    local pinBtn = PinUtils.CreatePinButton(frame, titleBar, "mainPinned", { offsetX = -28, Colors = Colors })
    
    -- Close button
    local closeBtn = CreateCloseButton(titleBar, {
        size = 18,
        fontSize = Fonts.body,
        offsetX = -4,
        onClick = function() self:Hide() end
    })
    
    -- Create navigation sidebar
    local navigation = Deathless.UI.Navigation:Create(frame)
    
    -- Create content panel (positioned to the right of nav)
    local navWidth = Deathless.UI.Navigation:GetWidth()
    local content = Deathless.UI.Content:Create(frame, navWidth)
    
    -- Select summary by default
    C_Timer.After(0, function()
        Deathless.UI.Navigation:Select("summary")
    end)
    
    -- Resize grip (using shared component)
    local resizeGrip, gripTexture = PinUtils.CreateResizeGrip(frame, Colors, {
        point = "BOTTOM",
        relativePoint = "BOTTOM",
        offsetX = 0,
        offsetY = 2,
        style = "bottom",
    })
    local isFrameHovered = false
    
    -- Setup pinnable resize behavior (with layout saving)
    PinUtils.SetupPinnableResize(frame, resizeGrip, gripTexture, Colors, "main", "BOTTOM")
    
    -- Setup pinnable drag behavior (with layout saving)
    PinUtils.SetupPinnableDrag(frame, "main")
    
    -- Setup grip alpha updater using shared utility
    local UpdateGripAlpha, getGripTargetAlpha = PinUtils.CreateGripAlphaUpdater(
        frame, resizeGrip,
        function() return isFrameHovered end,
        frame.isGripHovered
    )
    
    -- Smooth fade animation via OnUpdate
    frame:SetScript("OnUpdate", function(self, elapsed)
        -- Custom drag handling (instant, no dead zone)
        if self.UpdateDrag then self:UpdateDrag() end
        
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
Deathless.UI.CreateCloseButton = CreateCloseButton
