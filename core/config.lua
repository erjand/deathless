local Deathless = Deathless

Deathless.config = Deathless.config or {
    -- UI settings
    ui = {
        scale = 1.0,
        locked = false,
    },
    -- Module settings
    modules = {
        classes = { enabled = true },
        zones = { enabled = true },
        dungeons = { enabled = true },
        professions = { enabled = true },
        skills = { enabled = true },
        selffound = { enabled = true },
    }
}

-- Load saved variables
local function LoadConfig()
    if DeathlessDB then
        -- Merge saved config with defaults
        for key, value in pairs(DeathlessDB) do
            Deathless.config[key] = value
        end
    end
end

-- Save configuration
function Deathless:SaveConfig()
    DeathlessDB = DeathlessDB or {}
    for key, value in pairs(self.config) do
        DeathlessDB[key] = value
    end
end

-- Initialize on load
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "deathless" then
        LoadConfig()
    end
end)

