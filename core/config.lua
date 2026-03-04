local Deathless = Deathless
local GearTiers = (Deathless.Constants and Deathless.Constants.GearTiers) or {
    LEVELING = "Leveling",
    PRE_BIS = "Pre-BiS",
}

Deathless.config = Deathless.config or {
    -- UI settings
    ui = {
        scale = 1.0,
        locked = false,
    },
    -- Window layout (persisted positions/sizes)
    layout = {
        mini = { shown = false },
        main = {},
    },
    -- Module settings
    modules = {
        classes = { enabled = true },
        zones = { enabled = true },
        dungeons = { enabled = true },
        professions = { enabled = true },
        skills = { enabled = true },
        selffound = { enabled = true },
    },
    -- Included classes (nil = use player class only on first load)
    includedClasses = nil,
    -- Warning toggles
    warnings = {
        bandages = true,
        healthPotions = true,
        manaPotions = true,
        swiftnessPotions = true,
        lip = true,
        quests = true,
        flasks = true,
        classReagents = true,
        engineering = true,
        hearthstone = true,
        talents = true,
    },
    -- Gear view filter settings
    gear = {
        tierFilters = {
            [GearTiers.LEVELING] = true,
            [GearTiers.PRE_BIS] = false,
        },
    },
}

-- Class list in alphabetical order
Deathless.CLASS_LIST = {
    "Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"
}

-- Initialize included classes based on player class
local function InitIncludedClasses()
    if Deathless.config.includedClasses == nil then
        Deathless.config.includedClasses = {}
        -- Get player class
        local _, playerClass = UnitClass("player")
        if playerClass then
            -- Format: WARRIOR -> Warrior
            local formatted = playerClass:sub(1, 1) .. playerClass:sub(2):lower()
            Deathless.config.includedClasses[formatted] = true
        end
    end
end

-- Load saved variables
local function LoadConfig()
    if DeathlessDB then
        -- Merge saved config with defaults
        for key, value in pairs(DeathlessDB) do
            Deathless.config[key] = value
        end
    end
    -- Initialize class filter if needed
    InitIncludedClasses()

    -- Ensure gear filter defaults exist for older saved variables
    Deathless.config.gear = Deathless.config.gear or {}
    Deathless.config.gear.tierFilters = Deathless.config.gear.tierFilters or {}
    if Deathless.config.gear.tierFilters[GearTiers.LEVELING] == nil then
        Deathless.config.gear.tierFilters[GearTiers.LEVELING] = true
    end
    if Deathless.config.gear.tierFilters[GearTiers.PRE_BIS] == nil then
        Deathless.config.gear.tierFilters[GearTiers.PRE_BIS] = false
    end
    -- Remove deprecated raid tier filter from older saved variables.
    Deathless.config.gear.tierFilters.Raid = nil
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

