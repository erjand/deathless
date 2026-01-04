local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source types:
--   trainer - Learned from class trainer
--   talent  - Requires talent points (only shown if base talent is learned)
--   class   - Innate class ability (learned automatically)
--   book    - Learned from a drop/item
--   quest   - Learned from completing a quest
-- Train values:
--   yes   - Important ability, train all ranks
--   wait  - Can wait, not urgent
--   no    - Skip training (save gold)
--   maybe - Situational, depends on spec/playstyle
-- Sorted alphabetically by name, then by rank
-- See https://www.wowhead.com/classic/spells/abilities/rogue for source data
-- See https://www.wowhead.com/classic/npc=4215/anishar for training costs
Deathless.Data.Abilities["Rogue"] = {

    -- Ambush
    { name = "Ambush", level = 18, rank = 1, base_cost = 2900, icon = "Ability_Rogue_Ambush", source = "trainer", train = "yes", spellId = 8676 },
    { name = "Ambush", level = 26, rank = 2, base_cost = 6000, icon = "Ability_Rogue_Ambush", source = "trainer", train = "yes", spellId = 8724 },
    { name = "Ambush", level = 34, rank = 3, base_cost = 14000, icon = "Ability_Rogue_Ambush", source = "trainer", train = "yes", spellId = 8725 },
    { name = "Ambush", level = 42, rank = 4, base_cost = 27000, icon = "Ability_Rogue_Ambush", source = "trainer", train = "yes", spellId = 11267 },
    { name = "Ambush", level = 50, rank = 5, base_cost = 35000, icon = "Ability_Rogue_Ambush", source = "trainer", train = "yes", spellId = 11268 },
    { name = "Ambush", level = 58, rank = 6, base_cost = 52000, icon = "Ability_Rogue_Ambush", source = "trainer", train = "yes", spellId = 11269 },

    -- Backstab
    { name = "Backstab", level = 4, rank = 1, base_cost = 100, icon = "Ability_BackStab", source = "trainer", train = "yes", spellId = 53 },
    { name = "Backstab", level = 12, rank = 2, base_cost = 800, icon = "Ability_BackStab", source = "trainer", train = "yes", spellId = 2589 },
    { name = "Backstab", level = 20, rank = 3, base_cost = 3000, icon = "Ability_BackStab", source = "trainer", train = "yes", spellId = 2590 },
    { name = "Backstab", level = 28, rank = 4, base_cost = 8000, icon = "Ability_BackStab", source = "trainer", train = "yes", spellId = 2591 },
    { name = "Backstab", level = 36, rank = 5, base_cost = 16000, icon = "Ability_BackStab", source = "trainer", train = "yes", spellId = 8721 },
    { name = "Backstab", level = 44, rank = 6, base_cost = 29000, icon = "Ability_BackStab", source = "trainer", train = "yes", spellId = 11279 },
    { name = "Backstab", level = 52, rank = 7, base_cost = 46000, icon = "Ability_BackStab", source = "trainer", train = "yes", spellId = 11280 },
    { name = "Backstab", level = 60, rank = 8, base_cost = 54000, icon = "Ability_BackStab", source = "trainer", train = "yes", spellId = 11281 },
    { name = "Backstab", level = 60, rank = 9, base_cost = 0, icon = "Ability_BackStab", source = "book", train = "yes", spellId = 25300 },

    -- Blind
    { name = "Blind", level = 34, rank = 1, base_cost = 14000, icon = "Spell_Shadow_MindSteal", source = "trainer", train = "yes", spellId = 2094 },

    -- Cheap Shot
    { name = "Cheap Shot", level = 26, rank = 1, base_cost = 6000, icon = "Ability_CheapShot", source = "trainer", train = "yes", spellId = 1833 },

    -- Crippling Poison
    { name = "Crippling Poison", level = 20, rank = 1, base_cost = 3000, icon = "Ability_PoisonSting", source = "trainer", train = "yes", spellId = 3420 },
    { name = "Crippling Poison", level = 50, rank = 2, base_cost = 35000, icon = "Ability_PoisonSting", source = "trainer", train = "yes", spellId = 3421 },

    -- Deadly Poison
    { name = "Deadly Poison", level = 30, rank = 1, base_cost = 10000, icon = "Ability_Rogue_DualWeild", source = "trainer", train = "yes", spellId = 2835 },
    { name = "Deadly Poison", level = 38, rank = 2, base_cost = 18000, icon = "Ability_Rogue_DualWeild", source = "trainer", train = "yes", spellId = 2837 },
    { name = "Deadly Poison", level = 46, rank = 3, base_cost = 31000, icon = "Ability_Rogue_DualWeild", source = "trainer", train = "yes", spellId = 11357 },
    { name = "Deadly Poison", level = 54, rank = 4, base_cost = 48000, icon = "Ability_Rogue_DualWeild", source = "trainer", train = "yes", spellId = 11358 },
    { name = "Deadly Poison", level = 60, rank = 5, base_cost = 0, icon = "Ability_Rogue_DualWeild", source = "book", train = "yes", spellId = 25347 },

    -- Detect Traps
    { name = "Detect Traps", level = 24, rank = 1, base_cost = 5000, icon = "Ability_Spy", source = "trainer", train = "maybe", spellId = 2836 },

    -- Disarm Trap
    { name = "Disarm Trap", level = 30, rank = 1, base_cost = 10000, icon = "Spell_Shadow_GrimWard", source = "trainer", train = "maybe", spellId = 1842 },

    -- Distract
    { name = "Distract", level = 22, rank = 1, base_cost = 4000, icon = "Ability_Rogue_Distract", source = "trainer", train = "yes", spellId = 1725 },

    -- Dual Wield (passive)
    -- TODO: Not sure on the cost; is it free? https://www.wowhead.com/classic/npc=4215/anishar#teaches-other
    { name = "Dual Wield", level = 10, rank = 1, base_cost = 300, icon = "Ability_DualWield", source = "trainer", train = "yes", spellId = 674 },

    -- Evasion
    { name = "Evasion", level = 8, rank = 1, base_cost = 200, icon = "Spell_Shadow_ShadowWard", source = "trainer", train = "yes", spellId = 5277 },

    -- Eviscerate
    { name = "Eviscerate", level = 1, rank = 1, base_cost = 0, icon = "Ability_Rogue_Eviscerate", source = "class", train = "yes", spellId = 2098 },
    { name = "Eviscerate", level = 8, rank = 2, base_cost = 200, icon = "Ability_Rogue_Eviscerate", source = "trainer", train = "yes", spellId = 6760 },
    { name = "Eviscerate", level = 16, rank = 3, base_cost = 1800, icon = "Ability_Rogue_Eviscerate", source = "trainer", train = "yes", spellId = 6761 },
    { name = "Eviscerate", level = 24, rank = 4, base_cost = 5000, icon = "Ability_Rogue_Eviscerate", source = "trainer", train = "yes", spellId = 6762 },
    { name = "Eviscerate", level = 32, rank = 5, base_cost = 12000, icon = "Ability_Rogue_Eviscerate", source = "trainer", train = "yes", spellId = 8623 },
    { name = "Eviscerate", level = 40, rank = 6, base_cost = 20000, icon = "Ability_Rogue_Eviscerate", source = "trainer", train = "yes", spellId = 8624 },
    { name = "Eviscerate", level = 48, rank = 7, base_cost = 33000, icon = "Ability_Rogue_Eviscerate", source = "trainer", train = "yes", spellId = 11299 },
    { name = "Eviscerate", level = 56, rank = 8, base_cost = 50000, icon = "Ability_Rogue_Eviscerate", source = "trainer", train = "yes", spellId = 11300 },
    { name = "Eviscerate", level = 60, rank = 9, base_cost = 0, icon = "Ability_Rogue_Eviscerate", source = "book", train = "yes", spellId = 31016 },

    -- Expose Armor
    { name = "Expose Armor", level = 14, rank = 1, base_cost = 1200, icon = "Ability_Warrior_Riposte", source = "trainer", train = "yes", spellId = 8647 },
    { name = "Expose Armor", level = 26, rank = 2, base_cost = 6000, icon = "Ability_Warrior_Riposte", source = "trainer", train = "yes", spellId = 8649 },
    { name = "Expose Armor", level = 36, rank = 3, base_cost = 16000, icon = "Ability_Warrior_Riposte", source = "trainer", train = "yes", spellId = 8650 },
    { name = "Expose Armor", level = 46, rank = 4, base_cost = 31000, icon = "Ability_Warrior_Riposte", source = "trainer", train = "yes", spellId = 11197 },
    { name = "Expose Armor", level = 56, rank = 5, base_cost = 50000, icon = "Ability_Warrior_Riposte", source = "trainer", train = "yes", spellId = 11198 },

    -- Feint
    { name = "Feint", level = 16, rank = 1, base_cost = 1800, icon = "Ability_Rogue_Feint", source = "trainer", train = "yes", spellId = 1966 },
    { name = "Feint", level = 28, rank = 2, base_cost = 8000, icon = "Ability_Rogue_Feint", source = "trainer", train = "yes", spellId = 6768 },
    { name = "Feint", level = 40, rank = 3, base_cost = 20000, icon = "Ability_Rogue_Feint", source = "trainer", train = "yes", spellId = 8637 },
    { name = "Feint", level = 52, rank = 4, base_cost = 46000, icon = "Ability_Rogue_Feint", source = "trainer", train = "yes", spellId = 11303 },
    { name = "Feint", level = 60, rank = 5, base_cost = 0, icon = "Ability_Rogue_Feint", source = "book", train = "yes", spellId = 25302 },

    -- Garrote
    { name = "Garrote", level = 14, rank = 1, base_cost = 1200, icon = "Ability_Rogue_Garrote", source = "trainer", train = "yes", spellId = 703 },
    { name = "Garrote", level = 22, rank = 2, base_cost = 4000, icon = "Ability_Rogue_Garrote", source = "trainer", train = "yes", spellId = 8631 },
    { name = "Garrote", level = 30, rank = 3, base_cost = 10000, icon = "Ability_Rogue_Garrote", source = "trainer", train = "yes", spellId = 8632 },
    { name = "Garrote", level = 38, rank = 4, base_cost = 18000, icon = "Ability_Rogue_Garrote", source = "trainer", train = "yes", spellId = 8633 },
    { name = "Garrote", level = 46, rank = 5, base_cost = 31000, icon = "Ability_Rogue_Garrote", source = "trainer", train = "yes", spellId = 11289 },
    { name = "Garrote", level = 54, rank = 6, base_cost = 48000, icon = "Ability_Rogue_Garrote", source = "trainer", train = "yes", spellId = 11290 },

    -- Gouge
    { name = "Gouge", level = 6, rank = 1, base_cost = 100, icon = "Ability_Gouge", source = "trainer", train = "yes", spellId = 1776 },
    { name = "Gouge", level = 18, rank = 2, base_cost = 2900, icon = "Ability_Gouge", source = "trainer", train = "yes", spellId = 1777 },
    { name = "Gouge", level = 32, rank = 3, base_cost = 12000, icon = "Ability_Gouge", source = "trainer", train = "yes", spellId = 8629 },
    { name = "Gouge", level = 46, rank = 4, base_cost = 31000, icon = "Ability_Gouge", source = "trainer", train = "yes", spellId = 11285 },
    { name = "Gouge", level = 60, rank = 5, base_cost = 54000, icon = "Ability_Gouge", source = "trainer", train = "yes", spellId = 11286 },

    -- Hemorrhage (Subtlety 21-point talent)
    { name = "Hemorrhage", level = 30, rank = 1, base_cost = 0, icon = "Spell_Shadow_LifeDrain", source = "talent", train = "yes", spellId = 16511 },
    { name = "Hemorrhage", level = 46, rank = 2, base_cost = 7750, icon = "Spell_Shadow_LifeDrain", source = "talent", train = "yes", spellId = 17347 },
    { name = "Hemorrhage", level = 58, rank = 3, base_cost = 13000, icon = "Spell_Shadow_LifeDrain", source = "talent", train = "yes", spellId = 17348 },

    -- Instant Poison
    { name = "Instant Poison", level = 20, rank = 1, base_cost = 3000, icon = "Ability_Poisons", source = "trainer", train = "yes", spellId = 8681 },
    { name = "Instant Poison", level = 28, rank = 2, base_cost = 8000, icon = "Ability_Poisons", source = "trainer", train = "yes", spellId = 8687 },
    { name = "Instant Poison", level = 36, rank = 3, base_cost = 16000, icon = "Ability_Poisons", source = "trainer", train = "yes", spellId = 8691 },
    { name = "Instant Poison", level = 44, rank = 4, base_cost = 29000, icon = "Ability_Poisons", source = "trainer", train = "yes", spellId = 11341 },
    { name = "Instant Poison", level = 52, rank = 5, base_cost = 46000, icon = "Ability_Poisons", source = "trainer", train = "yes", spellId = 11342 },
    { name = "Instant Poison", level = 60, rank = 6, base_cost = 54000, icon = "Ability_Poisons", source = "trainer", train = "yes", spellId = 11343 },

    -- Kick
    { name = "Kick", level = 12, rank = 1, base_cost = 800, icon = "Ability_Kick", source = "trainer", train = "yes", spellId = 1766 },
    { name = "Kick", level = 26, rank = 2, base_cost = 6000, icon = "Ability_Kick", source = "trainer", train = "yes", spellId = 1767 },
    { name = "Kick", level = 42, rank = 3, base_cost = 27000, icon = "Ability_Kick", source = "trainer", train = "yes", spellId = 1768 },
    { name = "Kick", level = 58, rank = 4, base_cost = 52000, icon = "Ability_Kick", source = "trainer", train = "yes", spellId = 1769 },

    -- Kidney Shot
    { name = "Kidney Shot", level = 30, rank = 1, base_cost = 10000, icon = "Ability_Rogue_KidneyShot", source = "trainer", train = "yes", spellId = 408 },
    { name = "Kidney Shot", level = 50, rank = 2, base_cost = 35000, icon = "Ability_Rogue_KidneyShot", source = "trainer", train = "yes", spellId = 8643 },

    -- Mind-numbing Poison
    { name = "Mind-numbing Poison", level = 24, rank = 1, base_cost = 5000, icon = "Spell_Nature_NullifyDisease", source = "trainer", train = "yes", spellId = 5763 },
    { name = "Mind-numbing Poison", level = 38, rank = 2, base_cost = 18000, icon = "Spell_Nature_NullifyDisease", source = "trainer", train = "yes", spellId = 8694 },
    { name = "Mind-numbing Poison", level = 52, rank = 3, base_cost = 46000, icon = "Spell_Nature_NullifyDisease", source = "trainer", train = "yes", spellId = 11400 },

    -- Pick Lock
    { name = "Pick Lock", level = 16, rank = 1, base_cost = 1800, icon = "Spell_Nature_MoonKey", source = "trainer", train = "yes", spellId = 1804 },

    -- Pick Pocket
    { name = "Pick Pocket", level = 4, rank = 1, base_cost = 100, icon = "INV_Misc_Bag_11", source = "trainer", train = "yes", spellId = 921 },

    -- Poisons (skill)
    { name = "Poisons", level = 20, rank = 1, base_cost = 0, icon = "Trade_BrewPoison", source = "quest", train = "yes", spellId = 2842 },

    -- Rupture
    { name = "Rupture", level = 20, rank = 1, base_cost = 3000, icon = "Ability_Rogue_Rupture", source = "trainer", train = "yes", spellId = 1943 },
    { name = "Rupture", level = 28, rank = 2, base_cost = 8000, icon = "Ability_Rogue_Rupture", source = "trainer", train = "yes", spellId = 8639 },
    { name = "Rupture", level = 36, rank = 3, base_cost = 16000, icon = "Ability_Rogue_Rupture", source = "trainer", train = "yes", spellId = 8640 },
    { name = "Rupture", level = 44, rank = 4, base_cost = 29000, icon = "Ability_Rogue_Rupture", source = "trainer", train = "yes", spellId = 11273 },
    { name = "Rupture", level = 52, rank = 5, base_cost = 46000, icon = "Ability_Rogue_Rupture", source = "trainer", train = "yes", spellId = 11274 },
    { name = "Rupture", level = 60, rank = 6, base_cost = 54000, icon = "Ability_Rogue_Rupture", source = "trainer", train = "yes", spellId = 11275 },

    -- Safe Fall (passive)
    { name = "Safe Fall", level = 40, rank = 1, base_cost = 20000, icon = "INV_Feather_01", source = "trainer", train = "yes", spellId = 1860 },

    -- Sap
    { name = "Sap", level = 10, rank = 1, base_cost = 300, icon = "Ability_Sap", source = "trainer", train = "yes", spellId = 6770 },
    { name = "Sap", level = 28, rank = 2, base_cost = 8000, icon = "Ability_Sap", source = "trainer", train = "yes", spellId = 2070 },
    { name = "Sap", level = 48, rank = 3, base_cost = 33000, icon = "Ability_Sap", source = "trainer", train = "yes", spellId = 11297 },

    -- Sinister Strike
    { name = "Sinister Strike", level = 1, rank = 1, base_cost = 0, icon = "Spell_Shadow_RitualOfSacrifice", source = "class", train = "yes", spellId = 1752 },
    { name = "Sinister Strike", level = 6, rank = 2, base_cost = 100, icon = "Spell_Shadow_RitualOfSacrifice", source = "trainer", train = "yes", spellId = 1757 },
    { name = "Sinister Strike", level = 14, rank = 3, base_cost = 1200, icon = "Spell_Shadow_RitualOfSacrifice", source = "trainer", train = "yes", spellId = 1758 },
    { name = "Sinister Strike", level = 22, rank = 4, base_cost = 4000, icon = "Spell_Shadow_RitualOfSacrifice", source = "trainer", train = "yes", spellId = 1759 },
    { name = "Sinister Strike", level = 30, rank = 5, base_cost = 10000, icon = "Spell_Shadow_RitualOfSacrifice", source = "trainer", train = "yes", spellId = 1760 },
    { name = "Sinister Strike", level = 38, rank = 6, base_cost = 18000, icon = "Spell_Shadow_RitualOfSacrifice", source = "trainer", train = "yes", spellId = 8621 },
    { name = "Sinister Strike", level = 46, rank = 7, base_cost = 31000, icon = "Spell_Shadow_RitualOfSacrifice", source = "trainer", train = "yes", spellId = 11293 },
    { name = "Sinister Strike", level = 54, rank = 8, base_cost = 48000, icon = "Spell_Shadow_RitualOfSacrifice", source = "trainer", train = "yes", spellId = 11294 },

    -- Slice and Dice
    { name = "Slice and Dice", level = 10, rank = 1, base_cost = 300, icon = "Ability_Rogue_SliceDice", source = "trainer", train = "yes", spellId = 5171 },
    { name = "Slice and Dice", level = 42, rank = 2, base_cost = 27000, icon = "Ability_Rogue_SliceDice", source = "trainer", train = "yes", spellId = 6774 },

    -- Sprint
    { name = "Sprint", level = 10, rank = 1, base_cost = 300, icon = "Ability_Rogue_Sprint", source = "trainer", train = "yes", spellId = 2983 },
    { name = "Sprint", level = 34, rank = 2, base_cost = 14000, icon = "Ability_Rogue_Sprint", source = "trainer", train = "yes", spellId = 8696 },
    { name = "Sprint", level = 58, rank = 3, base_cost = 52000, icon = "Ability_Rogue_Sprint", source = "trainer", train = "yes", spellId = 11305 },

    -- Stealth
    { name = "Stealth", level = 1, rank = 1, base_cost = 10, icon = "Ability_Stealth", source = "trainer", train = "yes", spellId = 1784 },
    { name = "Stealth", level = 20, rank = 2, base_cost = 3000, icon = "Ability_Stealth", source = "trainer", train = "yes", spellId = 1785 },
    { name = "Stealth", level = 40, rank = 3, base_cost = 20000, icon = "Ability_Stealth", source = "trainer", train = "yes", spellId = 1786 },
    { name = "Stealth", level = 60, rank = 4, base_cost = 54000, icon = "Ability_Stealth", source = "trainer", train = "yes", spellId = 1787 },

    -- Vanish
    { name = "Vanish", level = 22, rank = 1, base_cost = 4000, icon = "Ability_Vanish", source = "trainer", train = "yes", spellId = 1856 },
    { name = "Vanish", level = 42, rank = 2, base_cost = 27000, icon = "Ability_Vanish", source = "trainer", train = "yes", spellId = 1857 },

    -- Wound Poison
    { name = "Wound Poison", level = 32, rank = 1, base_cost = 12000, icon = "INV_Misc_Herb_16", source = "trainer", train = "yes", spellId = 13220 },
    { name = "Wound Poison", level = 40, rank = 2, base_cost = 20000, icon = "INV_Misc_Herb_16", source = "trainer", train = "yes", spellId = 13228 },
    { name = "Wound Poison", level = 48, rank = 3, base_cost = 33000, icon = "INV_Misc_Herb_16", source = "trainer", train = "yes", spellId = 13229 },
    { name = "Wound Poison", level = 56, rank = 4, base_cost = 50000, icon = "INV_Misc_Herb_16", source = "trainer", train = "yes", spellId = 13230 },
}
