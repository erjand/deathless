local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

local CLASS_COLOR = { 0.41, 0.80, 0.94 } -- Mage blue

--- Create a section header for a talent build
---@param parent Frame Parent frame
---@param text string Header text
---@param yOffset number Y offset from parent top
---@return Frame, number The header frame and new Y offset
local function CreateBuildHeader(parent, text, yOffset)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetHeight(32)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset)
    frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, yOffset)
    
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.6)
    
    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetFont(Fonts.family, Fonts.header, "")
    frame.title:SetPoint("LEFT", frame, "LEFT", 12, 0)
    frame.title:SetText(text)
    frame.title:SetTextColor(CLASS_COLOR[1], CLASS_COLOR[2], CLASS_COLOR[3], 1)
    
    return frame, yOffset - 32
end

--- Create a description text
local function CreateDescription(parent, text, yOffset)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local desc = parent:CreateFontString(nil, "OVERLAY")
    desc:SetFont(Fonts.family, Fonts.body, "")
    desc:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, yOffset - 8)
    desc:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -12, yOffset - 8)
    desc:SetJustifyH("LEFT")
    desc:SetText(text)
    desc:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    local textHeight = desc:GetStringHeight() or 14
    return desc, yOffset - 8 - textHeight - 8
end

--- Create a placeholder for the talent tree image
local function CreateTalentImage(parent, imagePath, yOffset)
    local Colors = Utils:GetColors()
    local IMAGE_WIDTH, IMAGE_HEIGHT = 350, 220
    
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(IMAGE_WIDTH, IMAGE_HEIGHT)
    frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, yOffset)
    
    frame.border = frame:CreateTexture(nil, "BORDER")
    frame.border:SetPoint("TOPLEFT", -1, 1)
    frame.border:SetPoint("BOTTOMRIGHT", 1, -1)
    frame.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
    
    frame.bg = frame:CreateTexture(nil, "ARTWORK")
    frame.bg:SetAllPoints()
    
    if imagePath then
        frame.bg:SetTexture(imagePath)
    else
        frame.bg:SetColorTexture(0.1, 0.1, 0.12, 1)
        local Fonts = Deathless.UI.Fonts
        frame.placeholder = frame:CreateFontString(nil, "OVERLAY")
        frame.placeholder:SetFont(Fonts.family, Fonts.subtitle, "")
        frame.placeholder:SetPoint("CENTER", frame, "CENTER", 0, 0)
        frame.placeholder:SetText("Talent Tree\n(Image Placeholder)")
        frame.placeholder:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.6)
        frame.placeholder:SetJustifyH("CENTER")
    end
    
    return frame, yOffset - IMAGE_HEIGHT - 12
end

--- Create the progression list
local function CreateProgression(parent, progression, yOffset, xOffset)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    local LINE_HEIGHT = 14
    
    local container = CreateFrame("Frame", nil, parent)
    container:SetPoint("TOPLEFT", parent, "TOPLEFT", xOffset, yOffset)
    container:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -12, yOffset)
    container:SetHeight(400)
    
    local header = container:CreateFontString(nil, "OVERLAY")
    header:SetFont(Fonts.family, Fonts.body, "")
    header:SetPoint("TOPLEFT", container, "TOPLEFT", 0, 0)
    header:SetText("Progression")
    header:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    local lineY = -18
    for _, line in ipairs(progression) do
        local text = container:CreateFontString(nil, "OVERLAY")
        text:SetFont(Fonts.family, Fonts.small, "")
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
local function CreateNotes(parent, notes, yOffset)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local label = parent:CreateFontString(nil, "OVERLAY")
    label:SetFont(Fonts.family, Fonts.body, "")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, yOffset)
    label:SetText("Notes")
    label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    local text = parent:CreateFontString(nil, "OVERLAY")
    text:SetFont(Fonts.family, Fonts.body, "")
    text:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -6)
    text:SetPoint("RIGHT", parent, "RIGHT", -12, 0)
    text:SetJustifyH("LEFT")
    text:SetText(notes)
    text:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    local textHeight = text:GetStringHeight() or 14
    return text, yOffset - 18 - textHeight - 16
end

--- Create a single talent build section
local function CreateBuildSection(parent, build, yOffset)
    local Colors = Utils:GetColors()
    local IMAGE_WIDTH = 350
    
    local header, newY = CreateBuildHeader(parent, build.name, yOffset)
    yOffset = newY
    
    local desc, newY2 = CreateDescription(parent, build.description, yOffset)
    yOffset = newY2
    
    local imageFrame, imageBottomY = CreateTalentImage(parent, build.image, yOffset)
    local progContainer, progHeight = CreateProgression(parent, build.progression, yOffset, IMAGE_WIDTH + 16)
    
    local progressionBottomY = yOffset - progHeight - 12
    yOffset = math.min(imageBottomY, progressionBottomY)
    
    local notes, newY3 = CreateNotes(parent, build.notes, yOffset)
    yOffset = newY3
    
    local sep = parent:CreateTexture(nil, "ARTWORK")
    sep:SetHeight(1)
    sep:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, yOffset)
    sep:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -12, yOffset)
    sep:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.3)
    
    return yOffset - 20
end

--- Mage Talents view
Deathless.UI.Views:Register("mage_talents", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Mage Talents", "Recommended builds for leveling and endgame", CLASS_COLOR)
    
    -- Enhanced scroll frame with auto-hiding scrollbar
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, -70, 24)
    
    local builds = Deathless.Data.Talents and Deathless.Data.Talents.Mage or {}
    local yOffset = 0
    
    for _, build in ipairs(builds) do
        yOffset = CreateBuildSection(scrollChild, build, yOffset)
    end
    
    scrollChild:SetHeight(math.abs(yOffset) + 20)
    
    return { title = title, subtitle = subtitle, scrollFrame = scrollFrame, scrollChild = scrollChild }
end)

