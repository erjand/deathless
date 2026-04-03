local Deathless = Deathless

-- Initialize core systems
local function Initialize()
    -- Load configuration
    Deathless.config = Deathless.config or {}
    
    -- Initialize event system
    -- Modules will be initialized via their RegisterModule calls
end

-- Event frame for addon loading
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == Deathless.addonName then
        Initialize()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

