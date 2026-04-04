local Deathless = Deathless
local Metadata = Deathless.Constants.Metadata

local panel = CreateFrame("Frame", "DeathlessBlizzOptionsPanel")

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText(Metadata.ADDON_NAME)

local version = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
version:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
version:SetText("Version: " .. Metadata.VERSION)

local desc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
desc:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -12)
desc:SetText("Access options with /dls o")

local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
btn:SetSize(200, 40)
btn:SetPoint("TOP", desc, "BOTTOM", 0, -20)
btn:SetText("Open Options")
btn:SetScript("OnClick", function()
    if Deathless.UI and Deathless.UI.Frame then
        Deathless.UI.Frame:Show()
    end
    if Deathless.UI and Deathless.UI.Navigation then
        Deathless.UI.Navigation:Select("options")
    end
    HideUIPanel(SettingsPanel)
end)

local category = Settings.RegisterCanvasLayoutCategory(panel, Metadata.ADDON_NAME)
Settings.RegisterAddOnCategory(category)
