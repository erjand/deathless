local Deathless = Deathless
local GearTiers = Deathless.Constants.GearTiers
local WarningCategories = Deathless.Constants.WarningCategories
local MiniSections = Deathless.Constants.MiniSections

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
        [WarningCategories.AMMO] = true,
        [WarningCategories.BANDAGES] = true,
        [WarningCategories.HEALTH_POTIONS] = true,
        [WarningCategories.MANA_POTIONS] = true,
        [WarningCategories.SWIFTNESS_POTIONS] = true,
        [WarningCategories.LIP] = true,
        [WarningCategories.QUESTS] = true,
        [WarningCategories.FLASKS] = true,
        [WarningCategories.CLASS_REAGENTS] = true,
        [WarningCategories.ENGINEERING] = true,
        [WarningCategories.HEARTHSTONE] = true,
        [WarningCategories.TALENTS] = true,
    },
    -- Mini summary section visibility
    mini = {
        [MiniSections.WARNINGS] = true,
        [MiniSections.XP_PROGRESS] = true,
        [MiniSections.AVAILABLE] = true,
        [MiniSections.NEXT_AVAILABLE] = true,
    },
    -- Minimap button settings (consumed by LibDBIcon)
    minimap = {
        hide = false,
        minimapPos = 195,
    },
    -- Screenshot settings
    screenshots = {
        levelUp = true,
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

    -- Ensure screenshot defaults exist for older saved variables
    Deathless.config.screenshots = Deathless.config.screenshots or {}
    if Deathless.config.screenshots.levelUp == nil then
        Deathless.config.screenshots.levelUp = true
    end

    -- Ensure minimap button defaults exist for older saved variables
    Deathless.config.minimap = Deathless.config.minimap or {}
    if Deathless.config.minimap.hide == nil then
        Deathless.config.minimap.hide = false
    end

    -- Ensure mini section visibility defaults exist for older saved variables
    Deathless.config.mini = Deathless.config.mini or {}
    if Deathless.config.mini[MiniSections.WARNINGS] == nil then
        Deathless.config.mini[MiniSections.WARNINGS] = true
    end
    if Deathless.config.mini[MiniSections.XP_PROGRESS] == nil then
        Deathless.config.mini[MiniSections.XP_PROGRESS] = true
    end
    if Deathless.config.mini[MiniSections.AVAILABLE] == nil then
        Deathless.config.mini[MiniSections.AVAILABLE] = true
    end
    if Deathless.config.mini[MiniSections.NEXT_AVAILABLE] == nil then
        Deathless.config.mini[MiniSections.NEXT_AVAILABLE] = true
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
    if addonName == Deathless.addonName then
        LoadConfig()
    end
end)

