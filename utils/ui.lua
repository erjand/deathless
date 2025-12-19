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

