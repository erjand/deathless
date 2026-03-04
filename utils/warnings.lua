local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.Warnings = {}
local Icons = Deathless.Utils.Icons
local QUEST_ID_MAGE_SUMMONER = 1017
local QUEST_ID_THIS_IS_GOING_TO_BE_HARD = 778
local QUEST_ID_A_NEW_PLAGUE = 368
local QUEST_ID_A_SOLVENT_SPIRIT = 818
local QUEST_ID_NOGGENFOGGER_ELIXIR = 2662
local QUEST_ID_SELLING_FISH = 127
local QUEST_ID_GOLD_DUST_EXCHANGE = 47
local LEVEL_MAGE_SUMMONER_WARNING = 25
local LEVEL_THIS_IS_GOING_TO_BE_HARD_WARNING = 42
local LEVEL_A_NEW_PLAGUE_WARNING = 11
local LEVEL_A_SOLVENT_SPIRIT_WARNING = 7
local LEVEL_NOGGENFOGGER_ELIXIR_WARNING = 49
local LEVEL_SELLING_FISH_WARNING = 21
local LEVEL_GOLD_DUST_EXCHANGE_WARNING = 7
local FACTION_ALLIANCE = "Alliance"
local FACTION_HORDE = "Horde"
local ITEM_LIGHT_OF_ELUNE = 5816
local ITEM_NIFTY_STOPWATCH = 2820
local ITEM_SLUMBER_SAND = 3434
local ITEM_REALLY_STICKY_GLUE = 4941
local ITEM_NOGGENFOGGER_ELIXIR = 8529
local ITEM_FISHLIVER_OIL = 1322
local ITEM_BAG_OF_MARBLES = 1191

-- Tiered item definitions (highest tier first)
-- Bandages have skill requirements (req), level requirements (lvl), and spell names
local BANDAGES = {
    { req = 225, lvl = 40, spell = "Heavy Runecloth Bandage", id = 14530, icon = Icons.ITEM_BANDAGE_12 },
    { req = 200, lvl = 35, spell = "Runecloth Bandage",       id = 14529, icon = Icons.ITEM_BANDAGE_11 },
    { req = 175, lvl = 30, spell = "Heavy Mageweave Bandage", id = 8545,  icon = Icons.ITEM_BANDAGE_20 },
    { req = 150, lvl = 25, spell = "Mageweave Bandage",       id = 8544,  icon = Icons.ITEM_BANDAGE_19 },
    { req = 125, lvl = 20, spell = "Heavy Silk Bandage",      id = 6451,  icon = Icons.ITEM_BANDAGE_02 },
    { req = 100, lvl = 15, spell = "Silk Bandage",            id = 6450,  icon = Icons.ITEM_BANDAGE_01 },
    { req = 75,  lvl = 10, spell = "Heavy Wool Bandage",      id = 3531,  icon = Icons.ITEM_BANDAGE_17 },
    { req = 50,  lvl = 5,  spell = "Wool Bandage",            id = 3530,  icon = Icons.ITEM_BANDAGE_14 },
    { req = 20,  lvl = 1,  spell = "Heavy Linen Bandage",     id = 2581,  icon = Icons.ITEM_BANDAGE_18 },
    { req = 1,   lvl = 1,  spell = "Linen Bandage",           id = 1251,  icon = Icons.ITEM_BANDAGE_15 },
}

local HEALTH_POTIONS = {
    { req = 45, id = 13446, icon = Icons.ITEM_POTION_54 }, -- Major
    { req = 35, id = 3928,  icon = Icons.ITEM_POTION_53 }, -- Superior
    { req = 21, id = 1710,  icon = Icons.ITEM_POTION_52 }, -- Greater
    { req = 12, id = 929,   icon = Icons.ITEM_POTION_51 }, -- Healing
    { req = 3,  id = 858,   icon = Icons.ITEM_POTION_50 }, -- Lesser
    { req = 1,  id = 118,   icon = Icons.ITEM_POTION_49 }, -- Minor
}

local MANA_POTIONS = {
    { req = 49, id = 13444, icon = Icons.ITEM_POTION_76 }, -- Major
    { req = 41, id = 13443, icon = Icons.ITEM_POTION_74 }, -- Superior
    { req = 31, id = 6149,  icon = Icons.ITEM_POTION_73 }, -- Greater
    { req = 22, id = 3827,  icon = Icons.ITEM_POTION_72 }, -- Mana
    { req = 14, id = 3385,  icon = Icons.ITEM_POTION_71 }, -- Lesser
    { req = 1,  id = 2455,  icon = Icons.ITEM_POTION_70 }, -- Minor
}

-- Mage conjured water (by spell learn level, icons from data/abilities/mage.lua)
local MAGE_WATER = {
    { req = 60, id = 8079,  icon = Icons.ITEM_DRINK_18 },      -- Conjured Crystal Water
    { req = 50, id = 8078,  icon = Icons.ITEM_DRINK_11 },      -- Conjured Sparkling Water
    { req = 40, id = 8077,  icon = Icons.ITEM_DRINK_09 },      -- Conjured Mineral Water
    { req = 30, id = 3772,  icon = Icons.ITEM_DRINK_10 },      -- Conjured Spring Water
    { req = 20, id = 2136,  icon = Icons.ITEM_DRINK_MILK_02 }, -- Conjured Purified Water
    { req = 10, id = 2288,  icon = Icons.ITEM_DRINK_07 },      -- Conjured Fresh Water
    { req = 4,  id = 5350,  icon = Icons.ITEM_DRINK_06 },      -- Conjured Water
}

-- Mage conjured food (by spell learn level, icons from data/abilities/mage.lua)
local MAGE_FOOD = {
    { req = 60, id = 22895, icon = Icons.ITEM_FOOD_73CINNAMONROLL }, -- Conjured Cinnamon Roll
    { req = 52, id = 8076,  icon = Icons.ITEM_FOOD_33 }, -- Conjured Sweet Roll
    { req = 42, id = 8075,  icon = Icons.ITEM_FOOD_11 }, -- Conjured Sourdough
    { req = 32, id = 1487,  icon = Icons.ITEM_FOOD_08 }, -- Conjured Pumpernickel
    { req = 22, id = 1114,  icon = Icons.ITEM_FOOD_12 }, -- Conjured Rye
    { req = 12, id = 1113,  icon = Icons.ITEM_FOOD_09 }, -- Conjured Bread
    { req = 6,  id = 5349,  icon = Icons.ITEM_FOOD_10 }, -- Conjured Muffin
}

-- Mage mana gems (by spell learn level, icons from data/abilities/mage.lua)
local MAGE_MANA_GEMS = {
    { req = 58, id = 8008, icon = Icons.ITEM_GEM_RUBY_01 },    -- Mana Ruby
    { req = 48, id = 8007, icon = Icons.ITEM_GEM_OPAL_01 },    -- Mana Citrine
    { req = 38, id = 5513, icon = Icons.ITEM_GEM_EMERALD_02 }, -- Mana Jade
    { req = 28, id = 5514, icon = Icons.ITEM_GEM_EMERALD_01 }, -- Mana Agate
}

--- Check quest completion status safely
--- @param questId number
--- @return boolean
local function IsQuestCompleted(questId)
    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        return C_QuestLog.IsQuestFlaggedCompleted(questId)
    end
    return false
end

--- Get icon texture for an item with optional fallback
--- @param itemId number
--- @param fallbackIcon string|nil
--- @return string|number
local function GetItemIconTexture(itemId, fallbackIcon)
    local icon = itemId and GetItemIcon(itemId)
    return icon or fallbackIcon or Icons.DEFAULT
end

--- Return true for classes that do not use mana in Classic
--- @param classId string
--- @return boolean
local function IsNonCasterClass(classId)
    return classId == "WARRIOR" or classId == "ROGUE"
end

--- Get the best tiered item for a given value
local function GetBestTiered(tiers, value)
    for _, tier in ipairs(tiers) do
        if value >= tier.req then
            return tier.id, tier.icon
        end
    end
    return nil, nil
end

--- Check if a spell is known by searching the spellbook
local function IsRecipeKnown(spellName)
    local i = 1
    while true do
        local name = GetSpellBookItemName(i, BOOKTYPE_SPELL)
        if not name then break end
        if name == spellName then
            return true
        end
        i = i + 1
    end
    return false
end

--- Get the best bandage considering skill, level, and known recipe
local function GetBestBandage(skillLevel, playerLevel)
    for _, tier in ipairs(BANDAGES) do
        if skillLevel >= tier.req and playerLevel >= tier.lvl and IsRecipeKnown(tier.spell) then
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
    
    local bestBandageId, bestBandageIcon = GetBestBandage(firstAidSkill, playerLevel)
    local bestHealthId, bestHealthIcon = GetBestTiered(HEALTH_POTIONS, playerLevel)
    local bestManaId, bestManaIcon = GetBestTiered(MANA_POTIONS, playerLevel)
    local bestMageWaterId, bestMageWaterIcon = GetBestTiered(MAGE_WATER, playerLevel)
    local bestMageFoodId, bestMageFoodIcon = GetBestTiered(MAGE_FOOD, playerLevel)
    local bestManaGemId, bestManaGemIcon = GetBestTiered(MAGE_MANA_GEMS, playerLevel)
    
    local isMage = classId == "MAGE"
    
    return {
        { text = "Not carrying best Bandages", itemId = bestBandageId, icon = bestBandageIcon, condition = firstAidSkill > 0 and bestBandageId, category = "bandages" },
        { text = "Not carrying Blinding Powder", itemId = 5530, icon = Icons.ITEM_DUST_01, condition = classId == "ROGUE" and playerLevel >= 34, category = "classReagents" },
        { text = "Not carrying Flash Powder", itemId = 5140, icon = Icons.ITEM_POWDER_BLACK, condition = classId == "ROGUE" and playerLevel >= 22, category = "classReagents" },
        { text = "Not carrying Flasks of Petrification", itemId = 13506, minCount = 2, icon = Icons.ITEM_POTION_26, condition = playerLevel >= 50, category = "flasks" },
        { text = "Not carrying Iron Grenades", itemId = 4390, icon = Icons.ITEM_BOMB_08, condition = engineeringSkill >= 175 and engineeringSkill < 260, category = "engineering" },
        { text = "Not carrying Thorium Grenades", itemId = 15993, icon = Icons.ITEM_BOMB_08, condition = engineeringSkill >= 260, category = "engineering" },
        { text = "Not carrying Target Dummy", itemId = 4366, icon = Icons.ITEM_CRATE_06, condition = engineeringSkill >= 85 and engineeringSkill < 185, category = "engineering" },
        { text = "Not carrying Advanced Target Dummy", itemId = 4392, icon = Icons.ITEM_CRATE_05, condition = engineeringSkill >= 185 and engineeringSkill < 275, category = "engineering" },
        { text = "Not carrying Masterwork Target Dummy", itemId = 16023, icon = Icons.ITEM_CRATE_02, condition = engineeringSkill >= 275, category = "engineering" },
        { text = "Not carrying best Healing Potions for your level", itemId = bestHealthId, icon = bestHealthIcon, condition = bestHealthId ~= nil, category = "healthPotions" },
        { text = "Not carrying Hearthstone", itemId = 6948, icon = Icons.ITEM_RUNE_01, condition = true, category = "hearthstone" },
        { text = "Not carrying Holy Candles", itemId = 17028, icon = Icons.ITEM_CANDLE_01, condition = classId == "PRIEST" and playerLevel >= 48 and playerLevel < 60, category = "classReagents" },
        { text = "Not carrying Light Feathers (Levitate)", itemId = 17056, icon = Icons.ITEM_FEATHER_02, condition = classId == "PRIEST" and playerLevel >= 34, category = "classReagents" },
        { text = "Not carrying Light Feathers (Slow Fall)", itemId = 17056, icon = Icons.ITEM_FEATHER_02, condition = classId == "MAGE" and playerLevel >= 12, category = "classReagents" },
        { text = "Not carrying best Conjured Food", itemId = bestMageFoodId, icon = bestMageFoodIcon, condition = isMage and bestMageFoodId, category = "mageConjures" },
        { text = "Not carrying best Conjured Water", itemId = bestMageWaterId, icon = bestMageWaterIcon, condition = isMage and bestMageWaterId, category = "mageConjures" },
        { text = "Not carrying best Mana Gem", itemId = bestManaGemId, icon = bestManaGemIcon, condition = isMage and bestManaGemId, category = "mageConjures" },
        { text = "Not carrying LIP", itemId = 3387, icon = Icons.ITEM_POTION_62, condition = playerLevel >= 45, category = "lip" },
        { text = "Not carrying best Mana Potions for your level", itemId = bestManaId, icon = bestManaIcon, condition = powerType == 0 and bestManaId ~= nil, category = "manaPotions" },
        { text = "Not carrying Rune of Portals", itemId = 17032, icon = Icons.ITEM_RUNE_06, condition = classId == "MAGE" and playerLevel >= 40, category = "classReagents" },
        { text = "Not carrying Rune of Teleportation", itemId = 17031, icon = Icons.ITEM_RUNE_07, condition = classId == "MAGE" and playerLevel >= 20, category = "classReagents" },
        { text = "Not carrying Sacred Candles", itemId = 17029, icon = Icons.ITEM_CANDLE_02, condition = classId == "PRIEST" and playerLevel >= 56, category = "classReagents" },
        { text = "Not carrying Soul Shards", itemId = 6265, icon = Icons.ITEM_GEM_AMETHYST_02, condition = classId == "WARLOCK" and playerLevel >= 10, category = "classReagents" },
        { text = "Not carrying Swiftness Potions", itemId = 2459, icon = Icons.ITEM_POTION_95, condition = playerLevel >= 5, category = "swiftnessPotions" },
        { text = "Not carrying Symbol of Kings", itemId = 21177, icon = Icons.ITEM_JEWELRY_TRINKETPVP_01, condition = classId == "PALADIN" and playerLevel >= 52, category = "classReagents" },
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
    local playerFaction = UnitFactionGroup("player")
    local _, classId = UnitClass("player")
    local unspentTalents = UnitCharacterPoints("player") or 0
    local hasCompletedMageSummoner = IsQuestCompleted(QUEST_ID_MAGE_SUMMONER)
    local hasCompletedThisIsGoingToBeHard = IsQuestCompleted(QUEST_ID_THIS_IS_GOING_TO_BE_HARD)
    local hasCompletedANewPlague = IsQuestCompleted(QUEST_ID_A_NEW_PLAGUE)
    local hasCompletedASolventSpirit = IsQuestCompleted(QUEST_ID_A_SOLVENT_SPIRIT)
    local hasCompletedNoggenfoggerElixir = IsQuestCompleted(QUEST_ID_NOGGENFOGGER_ELIXIR)
    local hasCompletedSellingFish = IsQuestCompleted(QUEST_ID_SELLING_FISH)
    local hasCompletedGoldDustExchange = IsQuestCompleted(QUEST_ID_GOLD_DUST_EXCHANGE)
    
    return {
        {
            text = "Unspent Talent Points (" .. unspentTalents .. ")",
            icon = Icons.WARNING_TALENTS,
            condition = playerLevel >= 10 and unspentTalents > 0,
            category = "talents",
            isActive = unspentTalents > 0,
        },
        {
            text = "Quest not completed for Light of Elune",
            icon = GetItemIconTexture(ITEM_LIGHT_OF_ELUNE, Icons.ITEM_POTION_83),
            itemId = ITEM_LIGHT_OF_ELUNE,
            condition = playerFaction == FACTION_ALLIANCE and playerLevel >= LEVEL_MAGE_SUMMONER_WARNING,
            category = "quests",
            isActive = not hasCompletedMageSummoner,
        },
        {
            text = "Quest not completed for Nifty Stopwatch",
            icon = GetItemIconTexture(ITEM_NIFTY_STOPWATCH, Icons.ITEM_MISC_POCKETWATCH_01),
            itemId = ITEM_NIFTY_STOPWATCH,
            condition = playerLevel >= LEVEL_THIS_IS_GOING_TO_BE_HARD_WARNING,
            category = "quests",
            isActive = not hasCompletedThisIsGoingToBeHard,
        },
        {
            text = "Quest not completed: A New Plague",
            icon = GetItemIconTexture(ITEM_SLUMBER_SAND),
            itemId = ITEM_SLUMBER_SAND,
            condition = playerFaction == FACTION_HORDE and playerLevel >= LEVEL_A_NEW_PLAGUE_WARNING,
            category = "quests",
            isActive = not hasCompletedANewPlague,
        },
        {
            text = "Quest not completed: A Solvent Spirit",
            icon = GetItemIconTexture(ITEM_REALLY_STICKY_GLUE),
            itemId = ITEM_REALLY_STICKY_GLUE,
            condition = playerFaction == FACTION_HORDE and playerLevel >= LEVEL_A_SOLVENT_SPIRIT_WARNING,
            category = "quests",
            isActive = not hasCompletedASolventSpirit,
        },
        {
            text = "Quest not completed: Gold Dust Exchange",
            icon = GetItemIconTexture(ITEM_BAG_OF_MARBLES),
            itemId = ITEM_BAG_OF_MARBLES,
            condition = playerFaction == FACTION_ALLIANCE and playerLevel >= LEVEL_GOLD_DUST_EXCHANGE_WARNING,
            category = "quests",
            isActive = not hasCompletedGoldDustExchange,
        },
        {
            text = "Quest not completed: Noggenfogger Elixir",
            icon = GetItemIconTexture(ITEM_NOGGENFOGGER_ELIXIR),
            itemId = ITEM_NOGGENFOGGER_ELIXIR,
            condition = playerLevel >= LEVEL_NOGGENFOGGER_ELIXIR_WARNING,
            category = "quests",
            isActive = not hasCompletedNoggenfoggerElixir,
        },
        {
            text = "Quest not completed: Selling Fish",
            icon = GetItemIconTexture(ITEM_FISHLIVER_OIL),
            itemId = ITEM_FISHLIVER_OIL,
            condition = playerFaction == FACTION_ALLIANCE and IsNonCasterClass(classId) and playerLevel >= LEVEL_SELLING_FISH_WARNING,
            category = "quests",
            isActive = not hasCompletedSellingFish,
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
    -- Also refresh the main content view
    if Deathless.UI.Content and Deathless.UI.Content.RefreshCurrentView then
        Deathless.UI.Content:RefreshCurrentView()
    end
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

