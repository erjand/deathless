-- A re-usable UI component that pops up a frame with a title, a hint, and an edit box.

local Deathless = Deathless

Deathless.UI.Components = Deathless.UI.Components or {}
Deathless.UI.Components.CopyPopup = Deathless.UI.Components.CopyPopup or {}

local CopyPopup = Deathless.UI.Components.CopyPopup

--- Create (or return) the shared copy popup frame.
function CopyPopup:Create()
    if self.frame then
        return self.frame
    end

    local Colors = Deathless.UI.Colors
    local Fonts = Deathless.UI.Fonts
    local CreateCloseButton = Deathless.UI.CreateCloseButton

    local frame = CreateFrame("Frame", "DeathlessCopyPopupFrame", UIParent, "BackdropTemplate")
    frame:SetSize(660, 185)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(Colors.bg[1], Colors.bg[2], Colors.bg[3], 0.98)

    frame.borderTop = frame:CreateTexture(nil, "BORDER")
    frame.borderTop:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.borderTop:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    frame.borderTop:SetHeight(1)
    frame.borderTop:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)

    frame.borderBottom = frame:CreateTexture(nil, "BORDER")
    frame.borderBottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    frame.borderBottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    frame.borderBottom:SetHeight(1)
    frame.borderBottom:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)

    frame.borderLeft = frame:CreateTexture(nil, "BORDER")
    frame.borderLeft:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.borderLeft:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    frame.borderLeft:SetWidth(1)
    frame.borderLeft:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)

    frame.borderRight = frame:CreateTexture(nil, "BORDER")
    frame.borderRight:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    frame.borderRight:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    frame.borderRight:SetWidth(1)
    frame.borderRight:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)

    local titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    titleBar:SetHeight(20)

    titleBar.bg = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBar.bg:SetAllPoints()
    titleBar.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)

    local titleBorder = titleBar:CreateTexture(nil, "BORDER")
    titleBorder:SetPoint("BOTTOMLEFT", titleBar, "BOTTOMLEFT", 0, 0)
    titleBorder:SetPoint("BOTTOMRIGHT", titleBar, "BOTTOMRIGHT", 0, 0)
    titleBorder:SetHeight(1)
    titleBorder:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)

    frame.title = titleBar:CreateFontString(nil, "OVERLAY")
    frame.title:SetFont(Fonts.family, Fonts.subtitle, "")
    frame.title:SetPoint("LEFT", titleBar, "LEFT", 8, 0)
    frame.title:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    frame.title:SetText("Copy")

    frame.hint = frame:CreateFontString(nil, "OVERLAY")
    frame.hint:SetFont(Fonts.family, Fonts.body, "")
    frame.hint:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 8, -6)
    frame.hint:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -28, -26)
    frame.hint:SetJustifyH("LEFT")
    frame.hint:SetText("Press Ctrl+C to copy. Press Esc to close.")
    frame.hint:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

    CreateCloseButton(titleBar, {
        size = 14,
        fontSize = Fonts.small,
        offsetX = -3,
        onClick = function()
            frame:Hide()
        end
    })

    local editBackground = frame:CreateTexture(nil, "ARTWORK")
    editBackground:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -52)
    editBackground:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
    editBackground:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)

    local editBox = CreateFrame("EditBox", nil, frame)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetFont(Fonts.code, Fonts.body + 1, "")
    editBox:SetPoint("TOPLEFT", editBackground, "TOPLEFT", 6, -6)
    editBox:SetPoint("BOTTOMRIGHT", editBackground, "BOTTOMRIGHT", -6, 6)
    editBox:SetMaxLetters(0)
    editBox:SetJustifyH("LEFT")
    editBox:SetJustifyV("TOP")
    editBox:SetTextInsets(4, 4, 4, 4)
    editBox:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    editBox:SetScript("OnEscapePressed", function()
        frame:Hide()
    end)
    editBox:SetScript("OnEditFocusGained", function(self)
        self:HighlightText()
    end)

    frame.editBox = editBox
    self.title = frame.title
    self.editBox = frame.editBox
    self.frame = frame
    return frame
end

--- Show the shared copy popup with the provided title and text.
---@param title string
---@param text string
function CopyPopup:Show(title, text)
    local frame = self:Create()
    self.title:SetText(title or "Copy")
    self.editBox:SetText(text or "")
    frame:Show()
    self.editBox:SetFocus()
    self.editBox:HighlightText()
end

function CopyPopup:Hide()
    if self.frame then
        self.frame:Hide()
    end
end
