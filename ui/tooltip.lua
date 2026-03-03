local Deathless = Deathless

Deathless.UI = Deathless.UI or {}
Deathless.UI.Tooltip = {}

-- Custom tooltip with smaller fonts for addon-specific tooltips
-- Keeps title/description ratio but both are smaller

local tooltip = nil
local TOOLTIP_PADDING = 8
local TOOLTIP_MAX_WIDTH = 200

--- Create the custom tooltip frame (lazy initialization)
local function GetTooltip()
    if tooltip then return tooltip end
    
    local Fonts = Deathless.UI.Fonts
    local Colors = Deathless.UI.Colors
    
    tooltip = CreateFrame("Frame", "DeathlessTooltip", UIParent, "BackdropTemplate")
    tooltip:SetFrameStrata("TOOLTIP")
    tooltip:SetClampedToScreen(true)
    tooltip:Hide()
    
    -- Styling
    tooltip:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    tooltip:SetBackdropColor(Colors.bg[1], Colors.bg[2], Colors.bg[3], Colors.bg[4])
    tooltip:SetBackdropBorderColor(Colors.border[1], Colors.border[2], Colors.border[3], 0.8)
    
    -- Title text (smaller but still larger than description)
    tooltip.title = tooltip:CreateFontString(nil, "OVERLAY")
    tooltip.title:SetFont(Fonts.family, Fonts.small, "")  -- Was body size, now small
    tooltip.title:SetPoint("TOPLEFT", tooltip, "TOPLEFT", TOOLTIP_PADDING, -TOOLTIP_PADDING)
    tooltip.title:SetJustifyH("LEFT")
    tooltip.title:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], Colors.white[4])
    
    -- Icon (optional)
    tooltip.icon = tooltip:CreateTexture(nil, "ARTWORK")
    tooltip.icon:SetSize(14, 14)
    tooltip.icon:SetPoint("TOPLEFT", tooltip, "TOPLEFT", TOOLTIP_PADDING, -TOOLTIP_PADDING)
    tooltip.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    tooltip.icon:Hide()
    
    -- Description lines (even smaller)
    tooltip.lines = {}
    
    return tooltip
end

--- Get or create a description line
local function GetLine(index)
    local tt = GetTooltip()
    local Fonts = Deathless.UI.Fonts
    local Colors = Deathless.UI.Colors
    
    if not tt.lines[index] then
        local line = tt:CreateFontString(nil, "OVERLAY")
        line:SetFont(Fonts.family, Fonts.tiny, "")  -- Smaller than title
        line:SetJustifyH("LEFT")
        line:SetTextColor(Colors.tooltipText[1], Colors.tooltipText[2], Colors.tooltipText[3], Colors.tooltipText[4])
        line:SetWidth(TOOLTIP_MAX_WIDTH - TOOLTIP_PADDING * 2)
        line:SetWordWrap(true)
        tt.lines[index] = line
    end
    return tt.lines[index]
end

--- Show the custom tooltip
---@param owner Frame The frame to anchor to
---@param anchor string Anchor point (e.g., "ANCHOR_RIGHT")
---@param title string The title text
---@param description string|table|nil Description text (string or array of strings)
---@param icon string|nil Optional icon texture path
function Deathless.UI.Tooltip:Show(owner, anchor, title, description, icon)
    local tt = GetTooltip()
    local Fonts = Deathless.UI.Fonts
    
    -- Clear previous lines
    for _, line in ipairs(tt.lines) do
        line:Hide()
        line:ClearAllPoints()
    end
    
    -- Setup icon
    local titleOffset = TOOLTIP_PADDING
    if icon then
        tt.icon:SetTexture(icon)
        tt.icon:Show()
        tt.title:SetPoint("TOPLEFT", tt.icon, "TOPRIGHT", 4, 0)
        titleOffset = TOOLTIP_PADDING + 18  -- Icon width + spacing
    else
        tt.icon:Hide()
        tt.title:ClearAllPoints()
        tt.title:SetPoint("TOPLEFT", tt, "TOPLEFT", TOOLTIP_PADDING, -TOOLTIP_PADDING)
    end
    
    -- Set title
    tt.title:SetText(title or "")
    tt.title:SetWidth(TOOLTIP_MAX_WIDTH - titleOffset - TOOLTIP_PADDING)
    
    -- Calculate title height
    local titleHeight = tt.title:GetStringHeight() or 12
    local yOffset = -TOOLTIP_PADDING - math.max(titleHeight, icon and 14 or 0) - 4
    
    -- Add description lines
    local totalDescHeight = 0
    if description then
        local lines = type(description) == "table" and description or {description}
        for i, text in ipairs(lines) do
            local line = GetLine(i)
            line:SetText(text)
            line:SetPoint("TOPLEFT", tt, "TOPLEFT", TOOLTIP_PADDING, yOffset)
            line:Show()
            
            local lineHeight = line:GetStringHeight() or 10
            totalDescHeight = totalDescHeight + lineHeight + 2
            yOffset = yOffset - lineHeight - 2
        end
    end
    
    -- Calculate tooltip size
    local width = TOOLTIP_MAX_WIDTH
    local height = TOOLTIP_PADDING * 2 + math.max(titleHeight, icon and 14 or 0) + (totalDescHeight > 0 and (4 + totalDescHeight) or 0)
    
    tt:SetSize(width, height)
    
    -- Position tooltip
    tt:ClearAllPoints()
    if anchor == "ANCHOR_RIGHT" then
        tt:SetPoint("LEFT", owner, "RIGHT", 8, 0)
    elseif anchor == "ANCHOR_LEFT" then
        tt:SetPoint("RIGHT", owner, "LEFT", -8, 0)
    elseif anchor == "ANCHOR_TOP" then
        tt:SetPoint("BOTTOM", owner, "TOP", 0, 8)
    elseif anchor == "ANCHOR_BOTTOM" then
        tt:SetPoint("TOP", owner, "BOTTOM", 0, -8)
    else
        tt:SetPoint("BOTTOMLEFT", owner, "TOPRIGHT", 8, 0)
    end
    
    tt:Show()
end

--- Hide the custom tooltip
function Deathless.UI.Tooltip:Hide()
    if tooltip then
        tooltip:Hide()
    end
end
