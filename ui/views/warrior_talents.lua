local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

local CLASS_COLOR = { 0.78, 0.61, 0.43 } -- Warrior tan

--- Create a section header for a talent build
---@param parent Frame Parent frame
---@param text string Header text
---@param yOffset number Y offset from parent top
---@return Frame, number The header frame and new Y offset
local function CreateBuildHeader(parent, text, yOffset)
    local Colors = Utils:GetColors()
    
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(32)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset)
    frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, yOffset)
    
    -- Background
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.6)
    
    -- Title text
    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetFont("Fonts\\FRIZQT__.TTF", 13, "")
    frame.title:SetPoint("LEFT", frame, "LEFT", 12, 0)
    frame.title:SetText(text)
    frame.title:SetTextColor(CLASS_COLOR[1], CLASS_COLOR[2], CLASS_COLOR[3], 1)
    
    return frame, yOffset - 32
end

--- Create a description text
---@param parent Frame Parent frame
---@param text string Description text
---@param yOffset number Y offset
---@return FontString, number The text and new Y offset
local function CreateDescription(parent, text, yOffset)
    local Colors = Utils:GetColors()
    
    local desc = parent:CreateFontString(nil, "OVERLAY")
    desc:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    desc:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, yOffset - 8)
    desc:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -12, yOffset - 8)
    desc:SetJustifyH("LEFT")
    desc:SetText(text)
    desc:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    local textHeight = desc:GetStringHeight() or 14
    return desc, yOffset - 8 - textHeight - 8
end

--- Create a placeholder for the talent tree image
---@param parent Frame Parent frame
---@param imagePath string|nil Path to image texture
---@param yOffset number Y offset
---@return Frame, number The image frame and new Y offset
local function CreateTalentImage(parent, imagePath, yOffset)
    local Colors = Utils:GetColors()
    
    local IMAGE_WIDTH = 350
    local IMAGE_HEIGHT = 220
    
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(IMAGE_WIDTH, IMAGE_HEIGHT)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, yOffset)
    
    -- Border
    frame.border = frame:CreateTexture(nil, "BORDER")
    frame.border:SetPoint("TOPLEFT", -1, 1)
    frame.border:SetPoint("BOTTOMRIGHT", 1, -1)
    frame.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
    
    -- Background / image
    frame.bg = frame:CreateTexture(nil, "ARTWORK")
    frame.bg:SetAllPoints()
    
    if imagePath then
        frame.bg:SetTexture(imagePath)
    else
        -- Placeholder - dark background with text
        frame.bg:SetColorTexture(0.1, 0.1, 0.12, 1)
        
        frame.placeholder = frame:CreateFontString(nil, "OVERLAY")
        frame.placeholder:SetFont("Fonts\\FRIZQT__.TTF", 11, "")
        frame.placeholder:SetPoint("CENTER", frame, "CENTER", 0, 0)
        frame.placeholder:SetText("Talent Tree\n(Image Placeholder)")
        frame.placeholder:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.6)
        frame.placeholder:SetJustifyH("CENTER")
    end
    
    return frame, yOffset - IMAGE_HEIGHT - 12
end

--- Create the progression list
---@param parent Frame Parent frame
---@param progression table Array of progression strings
---@param yOffset number Y offset
---@param xOffset number X offset for positioning next to image
---@return Frame, number The container and new Y offset
local function CreateProgression(parent, progression, yOffset, xOffset)
    local Colors = Utils:GetColors()
    
    local container = CreateFrame("Frame", nil, parent)
    container:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, yOffset)
    container:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -12, yOffset)
    container:SetHeight(400) -- Will be adjusted
    
    -- Header
    local header = container:CreateFontString(nil, "OVERLAY")
    header:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    header:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    header:SetText("Progression")
    header:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    -- Progression lines
    local lineY = -18
    local LINE_HEIGHT = 14
    
    for i, line in ipairs(progression) do
        local text = container:CreateFontString(nil, "OVERLAY")
        text:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
        text:SetPoint("TOPLEFT", container, "TOPLEFT", 0, lineY)
        text:SetPoint("TOPRIGHT", container, "TOPRIGHT", 0, lineY)
        text:SetJustifyH("LEFT")
        text:SetText(line)
        text:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        
        lineY = lineY - LINE_HEIGHT
    end
    
    local totalHeight = 18 + (#progression * LINE_HEIGHT)
    container:SetHeight(totalHeight)
    
    return container, totalHeight
end

--- Create the notes section
---@param parent Frame Parent frame
---@param notes string Notes text
---@param yOffset number Y offset
---@return FontString, number The notes text and new Y offset
local function CreateNotes(parent, notes, yOffset)
    local Colors = Utils:GetColors()
    
    -- Label
    local label = parent:CreateFontString(nil, "OVERLAY")
    label:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, yOffset)
    label:SetText("Notes")
    label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    -- Notes text
    local text = parent:CreateFontString(nil, "OVERLAY")
    text:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    text:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -6)
    text:SetPoint("RIGHT", parent, "RIGHT", -12, 0)
    text:SetJustifyH("LEFT")
    text:SetText(notes)
    text:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    local textHeight = text:GetStringHeight() or 14
    return text, yOffset - 18 - textHeight - 16
end

--- Create a single talent build section
---@param parent Frame Scroll child frame
---@param build table Build data
---@param yOffset number Y offset
---@return number New Y offset after this build
local function CreateBuildSection(parent, build, yOffset)
    local Colors = Utils:GetColors()
    
    -- Build header
    local header, newY = CreateBuildHeader(parent, build.name, yOffset)
    yOffset = newY
    
    -- Description
    local desc, newY2 = CreateDescription(parent, build.description, yOffset)
    yOffset = newY2
    
    -- Image and progression side by side
    local IMAGE_WIDTH = 350
    local imageFrame, imageBottomY = CreateTalentImage(parent, build.image, yOffset)
    
    -- Progression to the right of image
    local progContainer, progHeight = CreateProgression(parent, build.progression, yOffset, IMAGE_WIDTH + 16)
    
    -- Use the lower of image bottom or progression bottom
    local progressionBottomY = yOffset - progHeight - 12
    yOffset = math.min(imageBottomY, progressionBottomY)
    
    -- Notes below both
    local notes, newY3 = CreateNotes(parent, build.notes, yOffset)
    yOffset = newY3
    
    -- Separator between builds
    local sep = parent:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, yOffset)
    sep:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -12, yOffset)
    sep:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.3)
    
    return yOffset - 20
end

--- Warrior Talents view
Deathless.UI.Views:Register("warrior_talents", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Warrior Talents", "Recommended builds for leveling and endgame", CLASS_COLOR)
    
    -- Enhanced scroll frame with auto-hiding scrollbar
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, -70, 24)
    
    -- Populate builds
    local builds = Deathless.Data.Talents and Deathless.Data.Talents.Warrior or {}
    local yOffset = 0
    
    for _, build in ipairs(builds) do
        yOffset = CreateBuildSection(scrollChild, build, yOffset)
    end
    
    scrollChild:SetHeight(math.abs(yOffset) + 20)
    
    return {
        title = title,
        subtitle = subtitle,
        scrollFrame = scrollFrame,
        scrollChild = scrollChild,
    }
end)

