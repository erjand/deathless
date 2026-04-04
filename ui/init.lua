local Deathless = Deathless

Deathless.UI = Deathless.UI or {}

function Deathless.UI:Initialize()
    -- Create the main frame
    if Deathless.UI.Frame then
        Deathless.UI.Frame:Create()
    end
    
    -- Create and show the mini summary by default
    if Deathless.UI.MiniSummary then
        Deathless.UI.MiniSummary:Create()
        Deathless.UI.MiniSummary:Show()
    end

    -- Register minimap button via LibDBIcon
    if Deathless.UI.InitializeMinimapButton then
        Deathless.UI:InitializeMinimapButton()
    end
end

-- Initialize UI after core is ready
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == Deathless.addonName then
        C_Timer.After(0.1, function()
            Deathless.UI:Initialize()
        end)
    end
end)

