local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.Warnings = {}

-- Tiered item definitions (highest tier first)
local BANDAGES = {
    { req = 225, id = 14530, icon = "Interface\\Icons\\INV_Misc_Bandage_12" }, -- Heavy Runecloth
    { req = 200, id = 14529, icon = "Interface\\Icons\\INV_Misc_Bandage_11" }, -- Runecloth
    { req = 175, id = 8545,  icon = "Interface\\Icons\\INV_Misc_Bandage_20" }, -- Heavy Mageweave
    { req = 150, id = 8544,  icon = "Interface\\Icons\\INV_Misc_Bandage_19" }, -- Mageweave
    { req = 125, id = 6451,  icon = "Interface\\Icons\\INV_Misc_Bandage_02" }, -- Heavy Silk
    { req = 100, id = 6450,  icon = "Interface\\Icons\\INV_Misc_Bandage_01" }, -- Silk
    { req = 75,  id = 3531,  icon = "Interface\\Icons\\INV_Misc_Bandage_17" }, -- Heavy Wool
    { req = 50,  id = 3530,  icon = "Interface\\Icons\\INV_Misc_Bandage_14" }, -- Wool
    { req = 20,  id = 2581,  icon = "Interface\\Icons\\INV_Misc_Bandage_18" }, -- Heavy Linen
    { req = 1,   id = 1251,  icon = "Interface\\Icons\\INV_Misc_Bandage_15" }, -- Linen
}

local HEALTH_POTIONS = {
    { req = 45, id = 13446, icon = "Interface\\Icons\\INV_Potion_54" }, -- Major
    { req = 35, id = 3928,  icon = "Interface\\Icons\\INV_Potion_53" }, -- Superior
    { req = 21, id = 1710,  icon = "Interface\\Icons\\INV_Potion_52" }, -- Greater
    { req = 12, id = 929,   icon = "Interface\\Icons\\INV_Potion_51" }, -- Healing
    { req = 3,  id = 858,   icon = "Interface\\Icons\\INV_Potion_50" }, -- Lesser
    { req = 1,  id = 118,   icon = "Interface\\Icons\\INV_Potion_49" }, -- Minor
}

local MANA_POTIONS = {
    { req = 49, id = 13444, icon = "Interface\\Icons\\INV_Potion_76" }, -- Major
    { req = 41, id = 13443, icon = "Interface\\Icons\\INV_Potion_74" }, -- Superior
    { req = 31, id = 6149,  icon = "Interface\\Icons\\INV_Potion_73" }, -- Greater
    { req = 22, id = 3827,  icon = "Interface\\Icons\\INV_Potion_72" }, -- Mana
    { req = 14, id = 3385,  icon = "Interface\\Icons\\INV_Potion_71" }, -- Lesser
    { req = 1,  id = 2455,  icon = "Interface\\Icons\\INV_Potion_70" }, -- Minor
}

-- Mage conjured water (by spell learn level, icons from data/abilities/mage.lua)
local MAGE_WATER = {
    { req = 60, id = 8079,  icon = "Interface\\Icons\\INV_Drink_18" },      -- Conjured Crystal Water
    { req = 50, id = 8078,  icon = "Interface\\Icons\\INV_Drink_11" },      -- Conjured Sparkling Water
    { req = 40, id = 8077,  icon = "Interface\\Icons\\INV_Drink_09" },      -- Conjured Mineral Water
    { req = 30, id = 3772,  icon = "Interface\\Icons\\INV_Drink_10" },      -- Conjured Spring Water
    { req = 20, id = 2136,  icon = "Interface\\Icons\\INV_Drink_Milk_02" }, -- Conjured Purified Water
    { req = 10, id = 2288,  icon = "Interface\\Icons\\INV_Drink_07" },      -- Conjured Fresh Water
    { req = 4,  id = 5350,  icon = "Interface\\Icons\\INV_Drink_06" },      -- Conjured Water
}

-- Mage conjured food (by spell learn level, icons from data/abilities/mage.lua)
local MAGE_FOOD = {
    { req = 60, id = 22895, icon = "Interface\\Icons\\INV_Misc_Food_73cinnamonroll" }, -- Conjured Cinnamon Roll
    { req = 52, id = 8076,  icon = "Interface\\Icons\\INV_Misc_Food_33" }, -- Conjured Sweet Roll
    { req = 42, id = 8075,  icon = "Interface\\Icons\\INV_Misc_Food_11" }, -- Conjured Sourdough
    { req = 32, id = 1487,  icon = "Interface\\Icons\\INV_Misc_Food_08" }, -- Conjured Pumpernickel
    { req = 22, id = 1114,  icon = "Interface\\Icons\\INV_Misc_Food_12" }, -- Conjured Rye
    { req = 12, id = 1113,  icon = "Interface\\Icons\\INV_Misc_Food_09" }, -- Conjured Bread
    { req = 6,  id = 5349,  icon = "Interface\\Icons\\INV_Misc_Food_10" }, -- Conjured Muffin
}

-- Mage mana gems (by spell learn level, icons from data/abilities/mage.lua)
local MAGE_MANA_GEMS = {
    { req = 58, id = 8008, icon = "Interface\\Icons\\INV_Misc_Gem_Ruby_01" },    -- Mana Ruby
    { req = 48, id = 8007, icon = "Interface\\Icons\\INV_Misc_Gem_Opal_01" },    -- Mana Citrine
    { req = 38, id = 5513, icon = "Interface\\Icons\\INV_Misc_Gem_Emerald_02" }, -- Mana Jade
    { req = 28, id = 5514, icon = "Interface\\Icons\\INV_Misc_Gem_Emerald_01" }, -- Mana Agate
}

--- Get the best tiered item for a given value
local function GetBestTiered(tiers, value)
    for _, tier in ipairs(tiers) do
        if value >= tier.req then
            return tier.id, tier.icon
        end
    end
    return nil, nil
end

--- Get player skill levels for First Aid and Engineering
local function GetSkillLevels()
    local firstAid, engineering = 0, 0
    for i = 1, GetNumSkillLines() do
        local skillName, _, _, skillRank = GetSkillLineInfo(i)
        if skillName == "First Aid" then
            firstAid = skillRank or 0
        elseif skillName == "Engineering" then
            engineering = skillRank or 0
        end
    end
    return firstAid, engineering
end

--- Build warning check definitions based on player state
--- @return table[] Array of warning check definitions
function Deathless.Utils.Warnings:GetChecks()
    local _, classId = UnitClass("player")
    local playerLevel = UnitLevel("player") or 1
    local powerType = UnitPowerType("player")
    
    local firstAidSkill, engineeringSkill = GetSkillLevels()
    
    local bestBandageId, bestBandageIcon = GetBestTiered(BANDAGES, firstAidSkill)
    local bestHealthId, bestHealthIcon = GetBestTiered(HEALTH_POTIONS, playerLevel)
    local bestManaId, bestManaIcon = GetBestTiered(MANA_POTIONS, playerLevel)
    local bestMageWaterId, bestMageWaterIcon = GetBestTiered(MAGE_WATER, playerLevel)
    local bestMageFoodId, bestMageFoodIcon = GetBestTiered(MAGE_FOOD, playerLevel)
    local bestManaGemId, bestManaGemIcon = GetBestTiered(MAGE_MANA_GEMS, playerLevel)
    
    local isMage = classId == "MAGE"
    
    return {
        { text = "Not carrying best Bandages", itemId = bestBandageId, icon = bestBandageIcon, condition = firstAidSkill > 0 and bestBandageId, category = "bandages" },
        { text = "Not carrying Blinding Powder", itemId = 5530, icon = "Interface\\Icons\\INV_Misc_Dust_01", condition = classId == "ROGUE" and playerLevel >= 34, category = "classReagents" },
        { text = "Not carrying Flash Powder", itemId = 5140, icon = "Interface\\Icons\\INV_Misc_Powder_Black", condition = classId == "ROGUE" and playerLevel >= 22, category = "classReagents" },
        { text = "Not carrying Flasks of Petrification", itemId = 13506, minCount = 2, icon = "Interface\\Icons\\INV_Potion_26", condition = playerLevel >= 50, category = "flasks" },
        { text = "Not carrying Iron Grenades", itemId = 4390, icon = "Interface\\Icons\\INV_Misc_Bomb_08", condition = engineeringSkill >= 175 and engineeringSkill < 260, category = "engineering" },
        { text = "Not carrying Thorium Grenades", itemId = 15993, icon = "Interface\\Icons\\INV_Misc_Bomb_08", condition = engineeringSkill >= 260, category = "engineering" },
        { text = "Not carrying Target Dummy", itemId = 4366, icon = "Interface\\Icons\\INV_Crate_06", condition = engineeringSkill >= 85 and engineeringSkill < 185, category = "engineering" },
        { text = "Not carrying Advanced Target Dummy", itemId = 4392, icon = "Interface\\Icons\\INV_Crate_05", condition = engineeringSkill >= 185 and engineeringSkill < 275, category = "engineering" },
        { text = "Not carrying Masterwork Target Dummy", itemId = 16023, icon = "Interface\\Icons\\INV_Crate_02", condition = engineeringSkill >= 275, category = "engineering" },
        { text = "Not carrying best Healing Potions", itemId = bestHealthId, icon = bestHealthIcon, condition = bestHealthId ~= nil, category = "healthPotions" },
        { text = "Not carrying Hearthstone", itemId = 6948, icon = "Interface\\Icons\\INV_Misc_Rune_01", condition = true, category = "hearthstone" },
        { text = "Not carrying Holy Candles", itemId = 17028, icon = "Interface\\Icons\\INV_Misc_Candle_01", condition = classId == "PRIEST" and playerLevel >= 48 and playerLevel < 60, category = "classReagents" },
        { text = "Not carrying Light Feathers (Levitate)", itemId = 17056, icon = "Interface\\Icons\\INV_Feather_02", condition = classId == "PRIEST" and playerLevel >= 34, category = "classReagents" },
        { text = "Not carrying Light Feathers (Slow Fall)", itemId = 17056, icon = "Interface\\Icons\\INV_Feather_02", condition = classId == "MAGE" and playerLevel >= 12, category = "classReagents" },
        { text = "Not carrying best Conjured Food", itemId = bestMageFoodId, icon = bestMageFoodIcon, condition = isMage and bestMageFoodId, category = "mageConjures" },
        { text = "Not carrying best Conjured Water", itemId = bestMageWaterId, icon = bestMageWaterIcon, condition = isMage and bestMageWaterId, category = "mageConjures" },
        { text = "Not carrying best Mana Gem", itemId = bestManaGemId, icon = bestManaGemIcon, condition = isMage and bestManaGemId, category = "mageConjures" },
        { text = "Not carrying LIP", itemId = 3387, icon = "Interface\\Icons\\INV_Potion_62", condition = playerLevel >= 45, category = "lip" },
        { text = "Not carrying best Mana Potions", itemId = bestManaId, icon = bestManaIcon, condition = powerType == 0 and bestManaId ~= nil, category = "manaPotions" },
        { text = "Not carrying Rune of Portals", itemId = 17032, icon = "Interface\\Icons\\INV_Misc_Rune_06", condition = classId == "MAGE" and playerLevel >= 40, category = "classReagents" },
        { text = "Not carrying Rune of Teleportation", itemId = 17031, icon = "Interface\\Icons\\INV_Misc_Rune_07", condition = classId == "MAGE" and playerLevel >= 20, category = "classReagents" },
        { text = "Not carrying Sacred Candles", itemId = 17029, icon = "Interface\\Icons\\INV_Misc_Candle_02", condition = classId == "PRIEST" and playerLevel >= 56, category = "classReagents" },
        { text = "Not carrying Soul Shards", itemId = 6265, icon = "Interface\\Icons\\INV_Misc_Gem_Amethyst_02", condition = classId == "WARLOCK" and playerLevel >= 10, category = "classReagents" },
        { text = "Not carrying Swiftness Potions", itemId = 2459, icon = "Interface\\Icons\\INV_Potion_95", condition = playerLevel >= 5, category = "swiftnessPotions" },
        { text = "Not carrying Symbol of Kings", itemId = 21177, icon = "Interface\\Icons\\INV_Jewelry_TrinketPVP_01", condition = classId == "PALADIN" and playerLevel >= 52, category = "classReagents" },
    }
end

--- Check if a warning category is enabled in config
--- @param category string The category key
--- @return boolean
local function IsCategoryEnabled(category)
    local warnings = Deathless.config and Deathless.config.warnings
    if not warnings then return true end
    return warnings[category] ~= false
end

--- Get non-item warnings (talent points, etc.)
--- @return table[] Array of special warning definitions
function Deathless.Utils.Warnings:GetSpecialChecks()
    local playerLevel = UnitLevel("player") or 1
    local unspentTalents = UnitCharacterPoints("player") or 0
    
    return {
        {
            text = "Unspent Talent Points (" .. unspentTalents .. ")",
            icon = "Interface\\Icons\\INV_Misc_Book_11",
            condition = playerLevel >= 10 and unspentTalents > 0,
            category = "talents",
            isActive = unspentTalents > 0,
        },
    }
end

--- Get active warnings (items the player is missing + special checks)
--- @return table[] Array of active warnings with text, itemId, icon
function Deathless.Utils.Warnings:GetActive()
    local checks = self:GetChecks()
    local active = {}
    
    -- Check item-based warnings
    for _, check in ipairs(checks) do
        if check.condition and check.itemId and IsCategoryEnabled(check.category) then
            local count = GetItemCount(check.itemId)
            local minCount = check.minCount or 1
            if count < minCount then
                table.insert(active, check)
            end
        end
    end
    
    -- Check special (non-item) warnings
    local specialChecks = self:GetSpecialChecks()
    for _, check in ipairs(specialChecks) do
        if check.condition and check.isActive and IsCategoryEnabled(check.category) then
            table.insert(active, check)
        end
    end
    
    -- Sort alphabetically
    table.sort(active, function(a, b)
        return a.text:lower() < b.text:lower()
    end)
    
    return active
end

--- Get count of active warnings
--- @return number
function Deathless.Utils.Warnings:GetCount()
    return #self:GetActive()
end

-- ========================================
-- EVENT-BASED REFRESH SYSTEM
-- ========================================

-- Registered callbacks for when warnings/state changes
local refreshCallbacks = {}
local pendingRefresh = false
local DEBOUNCE_DELAY = 0.3

--- Register a callback to be called when warnings might have changed
--- @param key string Unique key for this callback
--- @param callback function Function to call on refresh
function Deathless.Utils.Warnings:RegisterRefresh(key, callback)
    refreshCallbacks[key] = callback
end

--- Unregister a refresh callback
--- @param key string The key used when registering
function Deathless.Utils.Warnings:UnregisterRefresh(key)
    refreshCallbacks[key] = nil
end

--- Trigger a debounced refresh of all registered callbacks
local function TriggerRefresh()
    if pendingRefresh then return end
    pendingRefresh = true
    
    C_Timer.After(DEBOUNCE_DELAY, function()
        pendingRefresh = false
        for _, callback in pairs(refreshCallbacks) do
            callback()
        end
    end)
end

--- Public method to trigger refresh (e.g., when config changes)
function Deathless.Utils.Warnings:TriggerRefresh()
    TriggerRefresh()
end

-- Create event frame for watching state changes
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:RegisterEvent("CHARACTER_POINTS_CHANGED")
eventFrame:RegisterEvent("SKILL_LINES_CHANGED")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("LEARNED_SPELL_IN_TAB")

eventFrame:SetScript("OnEvent", function(self, event)
    TriggerRefresh()
end)

