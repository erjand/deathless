local Deathless = Deathless

-- View creators registry - populated by individual view files
Deathless.UI.Views = Deathless.UI.Views or {}

-- Shared utilities for views
Deathless.UI.Views.Utils = {}

-- Expose Fonts globally for easier access
Deathless.UI.Fonts = Deathless.Constants.Fonts
Deathless.UI.Views.Utils.Fonts = Deathless.UI.Fonts
local SectionHeaderStyle = (Deathless.Constants and Deathless.Constants.UI and Deathless.Constants.UI.SectionHeader) or {
    bgAlpha = 0.4,
    hoverAlpha = 0.6,
    height = 28,
    iconOffsetX = 8,
    labelOffsetX = 6,
}

Deathless.UI.Views.Utils.Layout = {
    rowHeight = 26,
    subRowHeight = 22,
    sectionHeight = SectionHeaderStyle.height,
    iconSize = 18,
    iconSizeSmall = 16,
    introSectionGap = 17,
    padding = 12,
    paddingSmall = 8,
}

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
    local Fonts = Deathless.UI.Fonts
    local color = titleColor or Colors.accent
    
    local titleText = container:CreateFontString(nil, "OVERLAY")
    titleText:SetFont(Fonts.family, Fonts.title, "")
    titleText:SetPoint("TOPLEFT", container, "TOPLEFT", 20, -20)
    titleText:SetText(title)
    titleText:SetTextColor(color[1], color[2], color[3], 1)
    
    local subtitleText = container:CreateFontString(nil, "OVERLAY")
    subtitleText:SetFont(Fonts.family, Fonts.subtitle, "")
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
    local Fonts = Deathless.UI.Fonts
    
    local titleText = container:CreateFontString(nil, "OVERLAY")
    titleText:SetFont(Fonts.family, Fonts.titleLarge, "")
    titleText:SetPoint("TOP", container, "TOP", 0, -40)
    titleText:SetText(title)
    titleText:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    local subtitleText = container:CreateFontString(nil, "OVERLAY")
    subtitleText:SetFont(Fonts.family, Fonts.header, "")
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

-- ========================================
-- COLLAPSIBLE SECTION HEADERS
-- ========================================

--- Create a collapsible section header frame (for use with pooling)
--- Returns the frame with icon, label, count, cost font strings
--- @param parent Frame The parent frame
--- @return Button The section header frame
function Deathless.UI.Views.Utils:CreateCollapsibleSection(parent)
    local Colors = self:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local section = CreateFrame("Button", nil, parent)
    section:SetHeight(SectionHeaderStyle.height)
    
    section.bg = section:CreateTexture(nil, "BACKGROUND")
    section.bg:SetAllPoints()
    section.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], SectionHeaderStyle.bgAlpha)
    
    section.icon = section:CreateFontString(nil, "OVERLAY")
    section.icon:SetFont(Fonts.icons, Fonts.subtitle, "")
    section.icon:SetPoint("LEFT", section, "LEFT", SectionHeaderStyle.iconOffsetX, 0)
    
    section.label = section:CreateFontString(nil, "OVERLAY")
    section.label:SetFont(Fonts.family, Fonts.subtitle, "")
    section.label:SetPoint("LEFT", section.icon, "RIGHT", SectionHeaderStyle.labelOffsetX, 0)
    
    section.count = section:CreateFontString(nil, "OVERLAY")
    section.count:SetFont(Fonts.family, Fonts.body, "")
    section.count:SetPoint("LEFT", section.label, "RIGHT", 8, 0)
    section.count:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    section.cost = section:CreateFontString(nil, "OVERLAY")
    section.cost:SetFont(Fonts.family, Fonts.body, "")
    section.cost:SetPoint("LEFT", section.count, "RIGHT", 8, 0)
    
    section:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(Colors.bgLight[1] + 0.05, Colors.bgLight[2] + 0.05, Colors.bgLight[3] + 0.05, SectionHeaderStyle.hoverAlpha)
    end)
    section:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], SectionHeaderStyle.bgAlpha)
    end)
    
    return section
end

--- Configure a collapsible section header
--- @param section Button The section frame
--- @param isExpanded boolean Whether section is expanded
--- @param label string The label text
--- @param color table Color for label {r, g, b}
--- @param count number|nil Optional count to display
--- @param costText string|nil Optional cost text to display
function Deathless.UI.Views.Utils:ConfigureSection(section, isExpanded, label, color, count, costText)
    local Colors = self:GetColors()
    
    section.icon:SetText(isExpanded and "▼" or "►")
    section.icon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    section.label:SetText(label)
    section.label:SetTextColor(color[1], color[2], color[3], 1)
    
    if count then
        section.count:SetText("(" .. count .. ")")
        section.count:Show()
    else
        section.count:SetText("")
        section.count:Hide()
    end
    
    if costText then
        section.cost:SetText(costText)
        section.cost:Show()
    else
        section.cost:SetText("")
        section.cost:Hide()
    end
end

--- Create a collapsible sub-section header (no background, smaller)
--- @param parent Frame The parent frame
--- @return Button The sub-section header frame
function Deathless.UI.Views.Utils:CreateCollapsibleSubSection(parent)
    local Colors = self:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local header = CreateFrame("Button", nil, parent)
    header:SetHeight(22)
    
    header.icon = header:CreateFontString(nil, "OVERLAY")
    header.icon:SetFont(Fonts.icons, Fonts.subtitle, "")
    header.icon:SetPoint("LEFT", header, "LEFT", 0, 0)
    
    header.label = header:CreateFontString(nil, "OVERLAY")
    header.label:SetFont(Fonts.family, Fonts.subtitle, "")
    header.label:SetPoint("LEFT", header.icon, "RIGHT", 6, 0)
    
    header:SetScript("OnEnter", function(self)
        self.label:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], Colors.white[4])
    end)
    header:SetScript("OnLeave", function(self)
        local c = self.color or Colors.textDim
        self.label:SetTextColor(c[1], c[2], c[3], 1)
    end)
    
    return header
end

--- Configure a collapsible sub-section header
--- @param header Button The sub-section header frame
--- @param isExpanded boolean Whether section is expanded
--- @param label string The label text
--- @param color table|nil Color for label {r, g, b}
function Deathless.UI.Views.Utils:ConfigureSubSection(header, isExpanded, label, color)
    local Colors = self:GetColors()
    
    header.icon:SetText(isExpanded and "▼" or "►")
    header.icon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    header.label:SetText(label)
    header.color = color or Colors.textDim
    header.label:SetTextColor(header.color[1], header.color[2], header.color[3], 1)
end

--- Create a content section header (non-collapsible, with underline)
--- @param parent Frame The parent frame
--- @param text string The header text
--- @param color table Color for text {r, g, b}
--- @param yOffset number Y offset in parent
--- @param width number|nil Optional width for underline (default 520)
--- @return FontString, Texture, number The header text, underline, and next yOffset
function Deathless.UI.Views.Utils:CreateContentHeader(parent, text, color, yOffset, width)
    local Colors = self:GetColors()
    local Fonts = Deathless.UI.Fonts
    width = width or 520
    
    local header = parent:CreateFontString(nil, "OVERLAY")
    header:SetFont(Fonts.family, Fonts.header, "")
    header:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, yOffset)
    header:SetText(text)
    header:SetTextColor(color[1], color[2], color[3], 1)
    
    local underline = parent:CreateTexture(nil, "ARTWORK")
    underline:SetHeight(1)
    underline:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
    underline:SetWidth(width)
    underline:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
    
    return header, underline, yOffset - 28
end

--- Create an enhanced scroll frame with auto-hiding thin scrollbar
---@param parent Frame The parent container
---@param topOffset number Offset from top (negative)
---@param bottomOffset number Offset from bottom
---@return ScrollFrame, Frame The scroll frame and scroll child
function Deathless.UI.Views.Utils:CreateScrollFrame(parent, topOffset, bottomOffset)
    -- Create scroll frame (no template - custom indicator)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent)
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, topOffset)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -8, bottomOffset)
    
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)
    
    local controller = Deathless.Utils.UI.CreateAutoHideScrollIndicator(scrollFrame, scrollChild, {
        parent = parent,
        hoverFrame = parent,
        topRight = { -4, topOffset - 4 },
        bottomRight = { -4, bottomOffset + 4 },
        frameLevelParent = parent,
        updateFrame = scrollFrame,
        smoothScroll = true,
    })
    scrollFrame.UpdateScrollbar = controller.UpdateScrollThumb
    scrollFrame.ResetScroll = controller.ResetScroll
    
    -- Update scrollbar when parent size changes (window resize)
    parent:HookScript("OnSizeChanged", function()
        C_Timer.After(0, function()
            controller.UpdateScrollThumb()
        end)
    end)
    
    return scrollFrame, scrollChild
end

