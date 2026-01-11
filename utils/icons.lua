local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.Icons = {}

-- Base path for Interface icons
local INTERFACE_ICONS = "Interface\\Icons\\"

-- Default/Fallback icons
Deathless.Utils.Icons.DEFAULT = INTERFACE_ICONS .. "INV_Misc_QuestionMark"

-- Navigation icons
Deathless.Utils.Icons.NAV_ABILITIES = INTERFACE_ICONS .. "INV_Misc_Book_07"
Deathless.Utils.Icons.NAV_TALENTS = INTERFACE_ICONS .. "Ability_Marksmanship"
Deathless.Utils.Icons.NAV_GEAR = INTERFACE_ICONS .. "INV_Gauntlets_04"

-- Class icons
Deathless.Utils.Icons.CLASS_DRUID = INTERFACE_ICONS .. "ClassIcon_Druid"
Deathless.Utils.Icons.CLASS_HUNTER = INTERFACE_ICONS .. "ClassIcon_Hunter"
Deathless.Utils.Icons.CLASS_MAGE = INTERFACE_ICONS .. "ClassIcon_Mage"
Deathless.Utils.Icons.CLASS_PALADIN = INTERFACE_ICONS .. "ClassIcon_Paladin"
Deathless.Utils.Icons.CLASS_PRIEST = INTERFACE_ICONS .. "ClassIcon_Priest"
Deathless.Utils.Icons.CLASS_ROGUE = INTERFACE_ICONS .. "ClassIcon_Rogue"
Deathless.Utils.Icons.CLASS_SHAMAN = INTERFACE_ICONS .. "ClassIcon_Shaman"
Deathless.Utils.Icons.CLASS_WARLOCK = INTERFACE_ICONS .. "ClassIcon_Warlock"
Deathless.Utils.Icons.CLASS_WARRIOR = INTERFACE_ICONS .. "ClassIcon_Warrior"

-- Warning category icons
Deathless.Utils.Icons.WARNING_BANDAGES = INTERFACE_ICONS .. "INV_Misc_Bandage_12"
Deathless.Utils.Icons.WARNING_CLASS_REAGENTS = INTERFACE_ICONS .. "INV_Misc_Rune_06"
Deathless.Utils.Icons.WARNING_ENGINEERING = INTERFACE_ICONS .. "INV_Misc_Bomb_08"
Deathless.Utils.Icons.WARNING_FLASKS = INTERFACE_ICONS .. "INV_Potion_26"
Deathless.Utils.Icons.WARNING_HEALTH_POTIONS = INTERFACE_ICONS .. "INV_Potion_54"
Deathless.Utils.Icons.WARNING_HEARTHSTONE = INTERFACE_ICONS .. "INV_Misc_Rune_01"
Deathless.Utils.Icons.WARNING_LIP = INTERFACE_ICONS .. "INV_Potion_62"
Deathless.Utils.Icons.WARNING_MAGE_CONJURES = INTERFACE_ICONS .. "INV_Misc_Gem_Ruby_01"
Deathless.Utils.Icons.WARNING_MANA_POTIONS = INTERFACE_ICONS .. "INV_Potion_76"
Deathless.Utils.Icons.WARNING_SWIFTNESS_POTIONS = INTERFACE_ICONS .. "INV_Potion_95"
Deathless.Utils.Icons.WARNING_TALENTS = INTERFACE_ICONS .. "INV_Misc_Book_11"

-- Item icons (used in warnings)
Deathless.Utils.Icons.ITEM_BANDAGE_12 = INTERFACE_ICONS .. "INV_Misc_Bandage_12"
Deathless.Utils.Icons.ITEM_BANDAGE_11 = INTERFACE_ICONS .. "INV_Misc_Bandage_11"
Deathless.Utils.Icons.ITEM_BANDAGE_20 = INTERFACE_ICONS .. "INV_Misc_Bandage_20"
Deathless.Utils.Icons.ITEM_BANDAGE_19 = INTERFACE_ICONS .. "INV_Misc_Bandage_19"
Deathless.Utils.Icons.ITEM_BANDAGE_02 = INTERFACE_ICONS .. "INV_Misc_Bandage_02"
Deathless.Utils.Icons.ITEM_BANDAGE_01 = INTERFACE_ICONS .. "INV_Misc_Bandage_01"
Deathless.Utils.Icons.ITEM_BANDAGE_17 = INTERFACE_ICONS .. "INV_Misc_Bandage_17"
Deathless.Utils.Icons.ITEM_BANDAGE_14 = INTERFACE_ICONS .. "INV_Misc_Bandage_14"
Deathless.Utils.Icons.ITEM_BANDAGE_18 = INTERFACE_ICONS .. "INV_Misc_Bandage_18"
Deathless.Utils.Icons.ITEM_BANDAGE_15 = INTERFACE_ICONS .. "INV_Misc_Bandage_15"

Deathless.Utils.Icons.ITEM_POTION_54 = INTERFACE_ICONS .. "INV_Potion_54"
Deathless.Utils.Icons.ITEM_POTION_53 = INTERFACE_ICONS .. "INV_Potion_53"
Deathless.Utils.Icons.ITEM_POTION_52 = INTERFACE_ICONS .. "INV_Potion_52"
Deathless.Utils.Icons.ITEM_POTION_51 = INTERFACE_ICONS .. "INV_Potion_51"
Deathless.Utils.Icons.ITEM_POTION_50 = INTERFACE_ICONS .. "INV_Potion_50"
Deathless.Utils.Icons.ITEM_POTION_49 = INTERFACE_ICONS .. "INV_Potion_49"

Deathless.Utils.Icons.ITEM_POTION_76 = INTERFACE_ICONS .. "INV_Potion_76"
Deathless.Utils.Icons.ITEM_POTION_74 = INTERFACE_ICONS .. "INV_Potion_74"
Deathless.Utils.Icons.ITEM_POTION_73 = INTERFACE_ICONS .. "INV_Potion_73"
Deathless.Utils.Icons.ITEM_POTION_72 = INTERFACE_ICONS .. "INV_Potion_72"
Deathless.Utils.Icons.ITEM_POTION_71 = INTERFACE_ICONS .. "INV_Potion_71"
Deathless.Utils.Icons.ITEM_POTION_70 = INTERFACE_ICONS .. "INV_Potion_70"

Deathless.Utils.Icons.ITEM_POTION_62 = INTERFACE_ICONS .. "INV_Potion_62"
Deathless.Utils.Icons.ITEM_POTION_95 = INTERFACE_ICONS .. "INV_Potion_95"
Deathless.Utils.Icons.ITEM_POTION_26 = INTERFACE_ICONS .. "INV_Potion_26"

Deathless.Utils.Icons.ITEM_DRINK_18 = INTERFACE_ICONS .. "INV_Drink_18"
Deathless.Utils.Icons.ITEM_DRINK_11 = INTERFACE_ICONS .. "INV_Drink_11"
Deathless.Utils.Icons.ITEM_DRINK_09 = INTERFACE_ICONS .. "INV_Drink_09"
Deathless.Utils.Icons.ITEM_DRINK_10 = INTERFACE_ICONS .. "INV_Drink_10"
Deathless.Utils.Icons.ITEM_DRINK_MILK_02 = INTERFACE_ICONS .. "INV_Drink_Milk_02"
Deathless.Utils.Icons.ITEM_DRINK_07 = INTERFACE_ICONS .. "INV_Drink_07"
Deathless.Utils.Icons.ITEM_DRINK_06 = INTERFACE_ICONS .. "INV_Drink_06"

Deathless.Utils.Icons.ITEM_FOOD_73CINNAMONROLL = INTERFACE_ICONS .. "INV_Misc_Food_73cinnamonroll"
Deathless.Utils.Icons.ITEM_FOOD_33 = INTERFACE_ICONS .. "INV_Misc_Food_33"
Deathless.Utils.Icons.ITEM_FOOD_11 = INTERFACE_ICONS .. "INV_Misc_Food_11"
Deathless.Utils.Icons.ITEM_FOOD_08 = INTERFACE_ICONS .. "INV_Misc_Food_08"
Deathless.Utils.Icons.ITEM_FOOD_12 = INTERFACE_ICONS .. "INV_Misc_Food_12"
Deathless.Utils.Icons.ITEM_FOOD_09 = INTERFACE_ICONS .. "INV_Misc_Food_09"
Deathless.Utils.Icons.ITEM_FOOD_10 = INTERFACE_ICONS .. "INV_Misc_Food_10"

Deathless.Utils.Icons.ITEM_GEM_RUBY_01 = INTERFACE_ICONS .. "INV_Misc_Gem_Ruby_01"
Deathless.Utils.Icons.ITEM_GEM_OPAL_01 = INTERFACE_ICONS .. "INV_Misc_Gem_Opal_01"
Deathless.Utils.Icons.ITEM_GEM_EMERALD_02 = INTERFACE_ICONS .. "INV_Misc_Gem_Emerald_02"
Deathless.Utils.Icons.ITEM_GEM_EMERALD_01 = INTERFACE_ICONS .. "INV_Misc_Gem_Emerald_01"
Deathless.Utils.Icons.ITEM_GEM_AMETHYST_02 = INTERFACE_ICONS .. "INV_Misc_Gem_Amethyst_02"

Deathless.Utils.Icons.ITEM_DUST_01 = INTERFACE_ICONS .. "INV_Misc_Dust_01"
Deathless.Utils.Icons.ITEM_POWDER_BLACK = INTERFACE_ICONS .. "INV_Misc_Powder_Black"
Deathless.Utils.Icons.ITEM_BOMB_08 = INTERFACE_ICONS .. "INV_Misc_Bomb_08"
Deathless.Utils.Icons.ITEM_CRATE_06 = INTERFACE_ICONS .. "INV_Crate_06"
Deathless.Utils.Icons.ITEM_CRATE_05 = INTERFACE_ICONS .. "INV_Crate_05"
Deathless.Utils.Icons.ITEM_CRATE_02 = INTERFACE_ICONS .. "INV_Crate_02"
Deathless.Utils.Icons.ITEM_CANDLE_01 = INTERFACE_ICONS .. "INV_Misc_Candle_01"
Deathless.Utils.Icons.ITEM_CANDLE_02 = INTERFACE_ICONS .. "INV_Misc_Candle_02"
Deathless.Utils.Icons.ITEM_FEATHER_02 = INTERFACE_ICONS .. "INV_Feather_02"
Deathless.Utils.Icons.ITEM_RUNE_06 = INTERFACE_ICONS .. "INV_Misc_Rune_06"
Deathless.Utils.Icons.ITEM_RUNE_07 = INTERFACE_ICONS .. "INV_Misc_Rune_07"
Deathless.Utils.Icons.ITEM_RUNE_01 = INTERFACE_ICONS .. "INV_Misc_Rune_01"
Deathless.Utils.Icons.ITEM_JEWELRY_TRINKETPVP_01 = INTERFACE_ICONS .. "INV_Jewelry_TrinketPVP_01"

-- UI component icons
Deathless.Utils.Icons.SPELLBOOK_TAB = INTERFACE_ICONS .. "INV_Misc_Bone_Skull_01"

-- Helper function to get full icon path (for spell icons that may not have Interface\\Icons\\ prefix)
---@param iconName string Icon name (with or without Interface\\Icons\\ prefix)
---@return string Full icon path
function Deathless.Utils.Icons:GetIconPath(iconName)
    if not iconName then
        return self.DEFAULT
    end
    
    -- If already has full path, return as-is
    if iconName:match("^Interface\\") then
        return iconName
    end
    
    -- Otherwise prepend Interface\\Icons\\
    return INTERFACE_ICONS .. iconName
end
