local Deathless = Deathless

Deathless.UI = Deathless.UI or {}

function Deathless.UI:Initialize()
    -- Create the main frame
    if Deathless.UI.Frame then
        Deathless.UI.Frame:Create()
    end
end

-- Initialize UI after core is ready
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "deathless" then
        C_Timer.After(0.1, function()
            Deathless.UI:Initialize()
        end)
    end
end)

