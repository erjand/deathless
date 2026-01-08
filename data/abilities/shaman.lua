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
--   yes   - Train when available
--   wait  - Marginal upgrade
--   no    - Not useful for Hardcore
-- Sorted alphabetically by name, then by rank
-- See https://www.wowhead.com/classic/spells/abilities/shaman for source data
-- See https://www.wowhead.com/classic/npc=3173/seer-raikkun for training costs
Deathless.Data.Abilities["Shaman"] = {
    -- Ancestral Spirit
    { name = "Ancestral Spirit", level = 12, rank = 1, base_cost = 800, icon = "Spell_Nature_Regenerate", source = "trainer", train = "no", spellId = 2008 },
    { name = "Ancestral Spirit", level = 24, rank = 2, base_cost = 3500, icon = "Spell_Nature_Regenerate", source = "trainer", train = "no", spellId = 20609 },
    { name = "Ancestral Spirit", level = 36, rank = 3, base_cost = 10000, icon = "Spell_Nature_Regenerate", source = "trainer", train = "no", spellId = 20610 },
    { name = "Ancestral Spirit", level = 48, rank = 4, base_cost = 22000, icon = "Spell_Nature_Regenerate", source = "trainer", train = "no", spellId = 20776 },
    { name = "Ancestral Spirit", level = 60, rank = 5, base_cost = 34000, icon = "Spell_Nature_Regenerate", source = "trainer", train = "no", spellId = 20777 },

    -- Astral Recall
    { name = "Astral Recall", level = 30, rank = 1, base_cost = 7000, icon = "Spell_Nature_AstralRecal", source = "trainer", train = "yes", spellId = 556 },

    -- Chain Heal
    { name = "Chain Heal", level = 40, rank = 1, base_cost = 12000, icon = "Spell_Nature_HealingWaveGreater", source = "trainer", train = "yes", spellId = 1064 },
    { name = "Chain Heal", level = 46, rank = 2, base_cost = 20000, icon = "Spell_Nature_HealingWaveGreater", source = "trainer", train = "yes", spellId = 10622 },
    { name = "Chain Heal", level = 54, rank = 3, base_cost = 29000, icon = "Spell_Nature_HealingWaveGreater", source = "trainer", train = "yes", spellId = 10623 },

    -- Chain Lightning
    { name = "Chain Lightning", level = 32, rank = 1, base_cost = 8000, icon = "Spell_Nature_ChainLightning", source = "trainer", train = "yes", spellId = 421 },
    { name = "Chain Lightning", level = 40, rank = 2, base_cost = 12000, icon = "Spell_Nature_ChainLightning", source = "trainer", train = "yes", spellId = 930 },
    { name = "Chain Lightning", level = 48, rank = 3, base_cost = 22000, icon = "Spell_Nature_ChainLightning", source = "trainer", train = "yes", spellId = 2860 },
    { name = "Chain Lightning", level = 56, rank = 4, base_cost = 30000, icon = "Spell_Nature_ChainLightning", source = "trainer", train = "yes", spellId = 10605 },

    -- Cure Disease
    { name = "Cure Disease", level = 22, rank = 1, base_cost = 3000, icon = "Spell_Nature_RemoveDisease", source = "trainer", train = "yes", spellId = 2870 },

    -- Cure Poison
    { name = "Cure Poison", level = 16, rank = 1, base_cost = 1800, icon = "Spell_Nature_NullifyPoison", source = "trainer", train = "yes", spellId = 526 },

    -- Disease Cleansing Totem
    { name = "Disease Cleansing Totem", level = 38, rank = 1, base_cost = 11000, icon = "Spell_Nature_DiseaseCleansingTotem", source = "trainer", train = "yes", spellId = 8170 },

    -- Earth Shock
    { name = "Earth Shock", level = 4, rank = 1, base_cost = 100, icon = "Spell_Nature_EarthShock", source = "trainer", train = "yes", spellId = 8042 },
    { name = "Earth Shock", level = 8, rank = 2, base_cost = 100, icon = "Spell_Nature_EarthShock", source = "trainer", train = "yes", spellId = 8044 },
    { name = "Earth Shock", level = 14, rank = 3, base_cost = 900, icon = "Spell_Nature_EarthShock", source = "trainer", train = "yes", spellId = 8045 },
    { name = "Earth Shock", level = 24, rank = 4, base_cost = 3500, icon = "Spell_Nature_EarthShock", source = "trainer", train = "yes", spellId = 8046 },
    { name = "Earth Shock", level = 36, rank = 5, base_cost = 10000, icon = "Spell_Nature_EarthShock", source = "trainer", train = "yes", spellId = 10412 },
    { name = "Earth Shock", level = 48, rank = 6, base_cost = 22000, icon = "Spell_Nature_EarthShock", source = "trainer", train = "yes", spellId = 10413 },
    { name = "Earth Shock", level = 60, rank = 7, base_cost = 34000, icon = "Spell_Nature_EarthShock", source = "trainer", train = "yes", spellId = 10414 },

    -- Earthbind Totem
    { name = "Earthbind Totem", level = 6, rank = 1, base_cost = 100, icon = "Spell_Nature_StrengthOfEarthTotem02", source = "trainer", train = "yes", spellId = 2484 },

    -- Far Sight
    { name = "Far Sight", level = 26, rank = 1, base_cost = 4000, icon = "Spell_Nature_FarSight", source = "trainer", train = "maybe", spellId = 6196 },

    -- Fire Nova Totem
    { name = "Fire Nova Totem", level = 12, rank = 1, base_cost = 800, icon = "Spell_Fire_SealOfFire", source = "trainer", train = "yes", spellId = 1535 },
    { name = "Fire Nova Totem", level = 22, rank = 2, base_cost = 3000, icon = "Spell_Fire_SealOfFire", source = "trainer", train = "yes", spellId = 8498 },
    { name = "Fire Nova Totem", level = 32, rank = 3, base_cost = 8000, icon = "Spell_Fire_SealOfFire", source = "trainer", train = "yes", spellId = 8499 },
    { name = "Fire Nova Totem", level = 42, rank = 4, base_cost = 16000, icon = "Spell_Fire_SealOfFire", source = "trainer", train = "yes", spellId = 11314 },
    { name = "Fire Nova Totem", level = 52, rank = 5, base_cost = 27000, icon = "Spell_Fire_SealOfFire", source = "trainer", train = "yes", spellId = 11315 },

    -- Fire Resistance Totem
    { name = "Fire Resistance Totem", level = 28, rank = 1, base_cost = 6000, icon = "Spell_FireResistanceTotem_01", source = "trainer", train = "yes", spellId = 8184 },
    { name = "Fire Resistance Totem", level = 42, rank = 2, base_cost = 16000, icon = "Spell_FireResistanceTotem_01", source = "trainer", train = "yes", spellId = 10537 },
    { name = "Fire Resistance Totem", level = 58, rank = 3, base_cost = 32000, icon = "Spell_FireResistanceTotem_01", source = "trainer", train = "yes", spellId = 10538 },

    -- Flame Shock
    { name = "Flame Shock", level = 10, rank = 1, base_cost = 400, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 8050 },
    { name = "Flame Shock", level = 18, rank = 2, base_cost = 2000, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 8052 },
    { name = "Flame Shock", level = 28, rank = 3, base_cost = 6000, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 8053 },
    { name = "Flame Shock", level = 40, rank = 4, base_cost = 12000, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 10447 },
    { name = "Flame Shock", level = 52, rank = 5, base_cost = 27000, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 10448 },
    { name = "Flame Shock", level = 60, rank = 6, base_cost = 0, icon = "Spell_Fire_FlameShock", source = "book", train = "yes", spellId = 29228 },

    -- Flametongue Totem
    { name = "Flametongue Totem", level = 28, rank = 1, base_cost = 6000, icon = "Spell_Nature_GuardianWard", source = "trainer", train = "yes", spellId = 8227 },
    { name = "Flametongue Totem", level = 38, rank = 2, base_cost = 11000, icon = "Spell_Nature_GuardianWard", source = "trainer", train = "yes", spellId = 8249 },
    { name = "Flametongue Totem", level = 48, rank = 3, base_cost = 22000, icon = "Spell_Nature_GuardianWard", source = "trainer", train = "yes", spellId = 10526 },
    { name = "Flametongue Totem", level = 58, rank = 4, base_cost = 32000, icon = "Spell_Nature_GuardianWard", source = "trainer", train = "yes", spellId = 16387 },

    -- Flametongue Weapon
    { name = "Flametongue Weapon", level = 10, rank = 1, base_cost = 400, icon = "Spell_Fire_FlameTounge", source = "trainer", train = "yes", spellId = 8024 },
    { name = "Flametongue Weapon", level = 18, rank = 2, base_cost = 2000, icon = "Spell_Fire_FlameTounge", source = "trainer", train = "yes", spellId = 8027 },
    { name = "Flametongue Weapon", level = 26, rank = 3, base_cost = 4000, icon = "Spell_Fire_FlameTounge", source = "trainer", train = "yes", spellId = 8030 },
    { name = "Flametongue Weapon", level = 36, rank = 4, base_cost = 10000, icon = "Spell_Fire_FlameTounge", source = "trainer", train = "yes", spellId = 16339 },
    { name = "Flametongue Weapon", level = 46, rank = 5, base_cost = 20000, icon = "Spell_Fire_FlameTounge", source = "trainer", train = "yes", spellId = 16341 },
    { name = "Flametongue Weapon", level = 56, rank = 6, base_cost = 30000, icon = "Spell_Fire_FlameTounge", source = "trainer", train = "yes", spellId = 16342 },

    -- Frost Resistance Totem
    { name = "Frost Resistance Totem", level = 24, rank = 1, base_cost = 3500, icon = "Spell_FrostResistanceTotem_01", source = "trainer", train = "yes", spellId = 8181 },
    { name = "Frost Resistance Totem", level = 38, rank = 2, base_cost = 11000, icon = "Spell_FrostResistanceTotem_01", source = "trainer", train = "yes", spellId = 10478 },
    { name = "Frost Resistance Totem", level = 54, rank = 3, base_cost = 29000, icon = "Spell_FrostResistanceTotem_01", source = "trainer", train = "yes", spellId = 10479 },

    -- Frost Shock
    { name = "Frost Shock", level = 20, rank = 1, base_cost = 2200, icon = "Spell_Frost_FrostShock", source = "trainer", train = "yes", spellId = 8056 },
    { name = "Frost Shock", level = 34, rank = 2, base_cost = 9000, icon = "Spell_Frost_FrostShock", source = "trainer", train = "yes", spellId = 8058 },
    { name = "Frost Shock", level = 46, rank = 3, base_cost = 20000, icon = "Spell_Frost_FrostShock", source = "trainer", train = "yes", spellId = 10472 },
    { name = "Frost Shock", level = 58, rank = 4, base_cost = 32000, icon = "Spell_Frost_FrostShock", source = "trainer", train = "yes", spellId = 10473 },

    -- Frostbrand Weapon
    { name = "Frostbrand Weapon", level = 20, rank = 1, base_cost = 2200, icon = "Spell_Frost_FrostBrand", source = "trainer", train = "yes", spellId = 8033 },
    { name = "Frostbrand Weapon", level = 28, rank = 2, base_cost = 6000, icon = "Spell_Frost_FrostBrand", source = "trainer", train = "yes", spellId = 8038 },
    { name = "Frostbrand Weapon", level = 38, rank = 3, base_cost = 11000, icon = "Spell_Frost_FrostBrand", source = "trainer", train = "yes", spellId = 10456 },
    { name = "Frostbrand Weapon", level = 48, rank = 4, base_cost = 22000, icon = "Spell_Frost_FrostBrand", source = "trainer", train = "yes", spellId = 16355 },
    { name = "Frostbrand Weapon", level = 58, rank = 5, base_cost = 32000, icon = "Spell_Frost_FrostBrand", source = "trainer", train = "yes", spellId = 16356 },

    -- Ghost Wolf
    { name = "Ghost Wolf", level = 20, rank = 1, base_cost = 2200, icon = "Spell_Nature_SpiritWolf", source = "trainer", train = "yes", spellId = 2645 },

    -- Grace of Air Totem
    { name = "Grace of Air Totem", level = 42, rank = 1, base_cost = 16000, icon = "Spell_Nature_InvisibilityTotem", source = "trainer", train = "yes", spellId = 8835 },
    { name = "Grace of Air Totem", level = 56, rank = 2, base_cost = 30000, icon = "Spell_Nature_InvisibilityTotem", source = "trainer", train = "yes", spellId = 10627 },
    { name = "Grace of Air Totem", level = 60, rank = 3, base_cost = 0, icon = "Spell_Nature_InvisibilityTotem", source = "book", train = "yes", spellId = 25359 },

    -- Grounding Totem
    { name = "Grounding Totem", level = 30, rank = 1, base_cost = 7000, icon = "Spell_Nature_GroundingTotem", source = "trainer", train = "yes", spellId = 8177 },

    -- Healing Stream Totem
    { name = "Healing Stream Totem", level = 20, rank = 1, base_cost = 0, icon = "INV_Spear_04", source = "quest", train = "yes", spellId = 5394 },
    { name = "Healing Stream Totem", level = 30, rank = 2, base_cost = 7000, icon = "INV_Spear_04", source = "trainer", train = "yes", spellId = 6375 },
    { name = "Healing Stream Totem", level = 40, rank = 3, base_cost = 12000, icon = "INV_Spear_04", source = "trainer", train = "yes", spellId = 6377 },
    { name = "Healing Stream Totem", level = 50, rank = 4, base_cost = 24000, icon = "INV_Spear_04", source = "trainer", train = "yes", spellId = 10462 },
    { name = "Healing Stream Totem", level = 60, rank = 5, base_cost = 34000, icon = "INV_Spear_04", source = "trainer", train = "yes", spellId = 10463 },

    -- Healing Wave
    { name = "Healing Wave", level = 1, rank = 1, base_cost = 0, icon = "Spell_Nature_MagicImmunity", source = "class", train = "yes", spellId = 331 },
    { name = "Healing Wave", level = 6, rank = 2, base_cost = 100, icon = "Spell_Nature_MagicImmunity", source = "trainer", train = "yes", spellId = 332 },
    { name = "Healing Wave", level = 12, rank = 3, base_cost = 800, icon = "Spell_Nature_MagicImmunity", source = "trainer", train = "yes", spellId = 547 },
    { name = "Healing Wave", level = 18, rank = 4, base_cost = 2000, icon = "Spell_Nature_MagicImmunity", source = "trainer", train = "yes", spellId = 913 },
    { name = "Healing Wave", level = 24, rank = 5, base_cost = 3500, icon = "Spell_Nature_MagicImmunity", source = "trainer", train = "yes", spellId = 939 },
    { name = "Healing Wave", level = 32, rank = 6, base_cost = 8000, icon = "Spell_Nature_MagicImmunity", source = "trainer", train = "yes", spellId = 959 },
    { name = "Healing Wave", level = 40, rank = 7, base_cost = 12000, icon = "Spell_Nature_MagicImmunity", source = "trainer", train = "yes", spellId = 8005 },
    { name = "Healing Wave", level = 48, rank = 8, base_cost = 22000, icon = "Spell_Nature_MagicImmunity", source = "trainer", train = "yes", spellId = 10395 },
    { name = "Healing Wave", level = 56, rank = 9, base_cost = 30000, icon = "Spell_Nature_MagicImmunity", source = "trainer", train = "yes", spellId = 10396 },
    { name = "Healing Wave", level = 60, rank = 10, base_cost = 0, icon = "Spell_Nature_MagicImmunity", source = "book", train = "yes", spellId = 25357 },

    -- Lesser Healing Wave
    { name = "Lesser Healing Wave", level = 20, rank = 1, base_cost = 2200, icon = "Spell_Nature_HealingWaveLesser", source = "trainer", train = "yes", spellId = 8004 },
    { name = "Lesser Healing Wave", level = 28, rank = 2, base_cost = 6000, icon = "Spell_Nature_HealingWaveLesser", source = "trainer", train = "yes", spellId = 8008 },
    { name = "Lesser Healing Wave", level = 36, rank = 3, base_cost = 10000, icon = "Spell_Nature_HealingWaveLesser", source = "trainer", train = "yes", spellId = 8010 },
    { name = "Lesser Healing Wave", level = 44, rank = 4, base_cost = 18000, icon = "Spell_Nature_HealingWaveLesser", source = "trainer", train = "yes", spellId = 10466 },
    { name = "Lesser Healing Wave", level = 52, rank = 5, base_cost = 27000, icon = "Spell_Nature_HealingWaveLesser", source = "trainer", train = "yes", spellId = 10467 },
    { name = "Lesser Healing Wave", level = 60, rank = 6, base_cost = 34000, icon = "Spell_Nature_HealingWaveLesser", source = "trainer", train = "yes", spellId = 10468 },

    -- Lightning Bolt
    { name = "Lightning Bolt", level = 1, rank = 1, base_cost = 0, icon = "Spell_Nature_Lightning", source = "class", train = "yes", spellId = 403 },
    { name = "Lightning Bolt", level = 8, rank = 2, base_cost = 100, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 529 },
    { name = "Lightning Bolt", level = 14, rank = 3, base_cost = 900, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 548 },
    { name = "Lightning Bolt", level = 20, rank = 4, base_cost = 2200, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 915 },
    { name = "Lightning Bolt", level = 26, rank = 5, base_cost = 4000, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 943 },
    { name = "Lightning Bolt", level = 32, rank = 6, base_cost = 8000, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 6041 },
    { name = "Lightning Bolt", level = 38, rank = 7, base_cost = 11000, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 10391 },
    { name = "Lightning Bolt", level = 44, rank = 8, base_cost = 18000, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 10392 },
    { name = "Lightning Bolt", level = 50, rank = 9, base_cost = 24000, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 15207 },
    { name = "Lightning Bolt", level = 56, rank = 10, base_cost = 30000, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 15208 },

    -- Lightning Shield
    { name = "Lightning Shield", level = 8, rank = 1, base_cost = 100, icon = "Spell_Nature_LightningShield", source = "trainer", train = "yes", spellId = 324 },
    { name = "Lightning Shield", level = 16, rank = 2, base_cost = 1800, icon = "Spell_Nature_LightningShield", source = "trainer", train = "yes", spellId = 325 },
    { name = "Lightning Shield", level = 24, rank = 3, base_cost = 3500, icon = "Spell_Nature_LightningShield", source = "trainer", train = "yes", spellId = 905 },
    { name = "Lightning Shield", level = 32, rank = 4, base_cost = 8000, icon = "Spell_Nature_LightningShield", source = "trainer", train = "yes", spellId = 945 },
    { name = "Lightning Shield", level = 40, rank = 5, base_cost = 12000, icon = "Spell_Nature_LightningShield", source = "trainer", train = "yes", spellId = 8134 },
    { name = "Lightning Shield", level = 48, rank = 6, base_cost = 22000, icon = "Spell_Nature_LightningShield", source = "trainer", train = "yes", spellId = 10431 },
    { name = "Lightning Shield", level = 56, rank = 7, base_cost = 30000, icon = "Spell_Nature_LightningShield", source = "trainer", train = "yes", spellId = 10432 },

    -- Magma Totem
    { name = "Magma Totem", level = 26, rank = 1, base_cost = 4000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 8190 },
    { name = "Magma Totem", level = 36, rank = 2, base_cost = 10000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 10585 },
    { name = "Magma Totem", level = 46, rank = 3, base_cost = 20000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 10586 },
    { name = "Magma Totem", level = 56, rank = 4, base_cost = 30000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 10587 },

    -- Mail (armor proficiency)
    { name = "Mail", level = 40, rank = 1, base_cost = 12000, icon = "INV_Chest_Chain_05", source = "trainer", train = "yes", spellId = 8737 },

    -- Mana Spring Totem
    { name = "Mana Spring Totem", level = 26, rank = 1, base_cost = 4000, icon = "Spell_Nature_ManaRegenTotem", source = "trainer", train = "yes", spellId = 5675 },
    { name = "Mana Spring Totem", level = 36, rank = 2, base_cost = 10000, icon = "Spell_Nature_ManaRegenTotem", source = "trainer", train = "yes", spellId = 10495 },
    { name = "Mana Spring Totem", level = 46, rank = 3, base_cost = 20000, icon = "Spell_Nature_ManaRegenTotem", source = "trainer", train = "yes", spellId = 10496 },
    { name = "Mana Spring Totem", level = 56, rank = 4, base_cost = 30000, icon = "Spell_Nature_ManaRegenTotem", source = "trainer", train = "yes", spellId = 10497 },

    -- Mana Tide Totem (Restoration 31-point talent)
    { name = "Mana Tide Totem", level = 40, rank = 1, base_cost = 0, icon = "Spell_Frost_SummonWaterElemental", source = "talent", train = "yes", spellId = 16190 },
    { name = "Mana Tide Totem", level = 48, rank = 2, base_cost = 1100, icon = "Spell_Frost_SummonWaterElemental", source = "talent", train = "yes", spellId = 17354 },
    { name = "Mana Tide Totem", level = 58, rank = 3, base_cost = 1600, icon = "Spell_Frost_SummonWaterElemental", source = "talent", train = "yes", spellId = 17359 },

    -- Nature Resistance Totem
    { name = "Nature Resistance Totem", level = 30, rank = 1, base_cost = 7000, icon = "Spell_Nature_NatureResistanceTotem", source = "trainer", train = "yes", spellId = 10595 },
    { name = "Nature Resistance Totem", level = 44, rank = 2, base_cost = 18000, icon = "Spell_Nature_NatureResistanceTotem", source = "trainer", train = "yes", spellId = 10600 },
    { name = "Nature Resistance Totem", level = 60, rank = 3, base_cost = 34000, icon = "Spell_Nature_NatureResistanceTotem", source = "trainer", train = "yes", spellId = 10601 },

    -- Poison Cleansing Totem
    { name = "Poison Cleansing Totem", level = 22, rank = 1, base_cost = 3000, icon = "Spell_Nature_PoisonCleansingTotem", source = "trainer", train = "yes", spellId = 8166 },

    -- Purge
    { name = "Purge", level = 12, rank = 1, base_cost = 800, icon = "Spell_Nature_Purge", source = "trainer", train = "yes", spellId = 370 },
    { name = "Purge", level = 32, rank = 2, base_cost = 8000, icon = "Spell_Nature_Purge", source = "trainer", train = "yes", spellId = 8012 },

    -- Reincarnation
    { name = "Reincarnation", level = 30, rank = 1, base_cost = 7000, icon = "Spell_Nature_Reincarnation", source = "trainer", train = "no", spellId = 20608 },

    -- Rockbiter Weapon
    { name = "Rockbiter Weapon", level = 1, rank = 1, base_cost = 10, icon = "Spell_Nature_RockBiter", source = "trainer", train = "yes", spellId = 8017 },
    { name = "Rockbiter Weapon", level = 8, rank = 2, base_cost = 100, icon = "Spell_Nature_RockBiter", source = "trainer", train = "yes", spellId = 8018 },
    { name = "Rockbiter Weapon", level = 16, rank = 3, base_cost = 1800, icon = "Spell_Nature_RockBiter", source = "trainer", train = "yes", spellId = 8019 },
    { name = "Rockbiter Weapon", level = 24, rank = 4, base_cost = 3500, icon = "Spell_Nature_RockBiter", source = "trainer", train = "yes", spellId = 10399 },
    { name = "Rockbiter Weapon", level = 34, rank = 5, base_cost = 9000, icon = "Spell_Nature_RockBiter", source = "trainer", train = "yes", spellId = 16314 },
    { name = "Rockbiter Weapon", level = 44, rank = 6, base_cost = 18000, icon = "Spell_Nature_RockBiter", source = "trainer", train = "yes", spellId = 16315 },
    { name = "Rockbiter Weapon", level = 54, rank = 7, base_cost = 29000, icon = "Spell_Nature_RockBiter", source = "trainer", train = "yes", spellId = 16316 },

    -- Searing Totem
    { name = "Searing Totem", level = 10, rank = 1, base_cost = 0, icon = "Spell_Fire_SearingTotem", source = "quest", train = "yes", spellId = 3599 },
    { name = "Searing Totem", level = 20, rank = 2, base_cost = 2200, icon = "Spell_Fire_SearingTotem", source = "trainer", train = "yes", spellId = 6363 },
    { name = "Searing Totem", level = 30, rank = 3, base_cost = 7000, icon = "Spell_Fire_SearingTotem", source = "trainer", train = "yes", spellId = 6364 },
    { name = "Searing Totem", level = 40, rank = 4, base_cost = 12000, icon = "Spell_Fire_SearingTotem", source = "trainer", train = "yes", spellId = 6365 },
    { name = "Searing Totem", level = 50, rank = 5, base_cost = 24000, icon = "Spell_Fire_SearingTotem", source = "trainer", train = "yes", spellId = 10437 },
    { name = "Searing Totem", level = 60, rank = 6, base_cost = 34000, icon = "Spell_Fire_SearingTotem", source = "trainer", train = "yes", spellId = 10438 },

    -- Sentry Totem
    { name = "Sentry Totem", level = 34, rank = 1, base_cost = 9000, icon = "Spell_Nature_RemoveCurse", source = "trainer", train = "maybe", spellId = 6495 },

    -- Stoneclaw Totem
    { name = "Stoneclaw Totem", level = 8, rank = 1, base_cost = 100, icon = "Spell_Nature_StoneClawTotem", source = "trainer", train = "yes", spellId = 5730 },
    { name = "Stoneclaw Totem", level = 18, rank = 2, base_cost = 2000, icon = "Spell_Nature_StoneClawTotem", source = "trainer", train = "yes", spellId = 6390 },
    { name = "Stoneclaw Totem", level = 28, rank = 3, base_cost = 6000, icon = "Spell_Nature_StoneClawTotem", source = "trainer", train = "yes", spellId = 6391 },
    { name = "Stoneclaw Totem", level = 38, rank = 4, base_cost = 11000, icon = "Spell_Nature_StoneClawTotem", source = "trainer", train = "yes", spellId = 6392 },
    { name = "Stoneclaw Totem", level = 48, rank = 5, base_cost = 22000, icon = "Spell_Nature_StoneClawTotem", source = "trainer", train = "yes", spellId = 10427 },
    { name = "Stoneclaw Totem", level = 58, rank = 6, base_cost = 32000, icon = "Spell_Nature_StoneClawTotem", source = "trainer", train = "yes", spellId = 10428 },

    -- Stoneskin Totem
    { name = "Stoneskin Totem", level = 4, rank = 1, base_cost = 0, icon = "Spell_Nature_StoneSkinTotem", source = "quest", train = "yes", spellId = 8071 },
    { name = "Stoneskin Totem", level = 14, rank = 2, base_cost = 900, icon = "Spell_Nature_StoneSkinTotem", source = "trainer", train = "yes", spellId = 8154 },
    { name = "Stoneskin Totem", level = 24, rank = 3, base_cost = 3500, icon = "Spell_Nature_StoneSkinTotem", source = "trainer", train = "yes", spellId = 8155 },
    { name = "Stoneskin Totem", level = 34, rank = 4, base_cost = 9000, icon = "Spell_Nature_StoneSkinTotem", source = "trainer", train = "yes", spellId = 10406 },
    { name = "Stoneskin Totem", level = 44, rank = 5, base_cost = 18000, icon = "Spell_Nature_StoneSkinTotem", source = "trainer", train = "yes", spellId = 10407 },
    { name = "Stoneskin Totem", level = 54, rank = 6, base_cost = 29000, icon = "Spell_Nature_StoneSkinTotem", source = "trainer", train = "yes", spellId = 10408 },

    -- Strength of Earth Totem
    { name = "Strength of Earth Totem", level = 10, rank = 1, base_cost = 400, icon = "Spell_Nature_EarthBindTotem", source = "trainer", train = "yes", spellId = 8075 },
    { name = "Strength of Earth Totem", level = 24, rank = 2, base_cost = 3500, icon = "Spell_Nature_EarthBindTotem", source = "trainer", train = "yes", spellId = 8160 },
    { name = "Strength of Earth Totem", level = 38, rank = 3, base_cost = 11000, icon = "Spell_Nature_EarthBindTotem", source = "trainer", train = "yes", spellId = 8161 },
    { name = "Strength of Earth Totem", level = 52, rank = 4, base_cost = 27000, icon = "Spell_Nature_EarthBindTotem", source = "trainer", train = "yes", spellId = 10442 },
    { name = "Strength of Earth Totem", level = 60, rank = 5, base_cost = 0, icon = "Spell_Nature_EarthBindTotem", source = "book", train = "yes", spellId = 25361 },

    -- Tranquil Air Totem
    { name = "Tranquil Air Totem", level = 50, rank = 1, base_cost = 24000, icon = "Spell_Nature_Brilliance", source = "trainer", train = "yes", spellId = 25908 },

    -- Tremor Totem
    { name = "Tremor Totem", level = 18, rank = 1, base_cost = 2000, icon = "Spell_Nature_TremorTotem", source = "trainer", train = "yes", spellId = 8143 },

    -- Water Breathing
    { name = "Water Breathing", level = 22, rank = 1, base_cost = 3000, icon = "Spell_Shadow_DemonBreath", source = "trainer", train = "yes", spellId = 131 },

    -- Water Walking
    { name = "Water Walking", level = 28, rank = 1, base_cost = 6000, icon = "Spell_Frost_WindWalkOn", source = "trainer", train = "yes", spellId = 546 },

    -- Windfury Totem
    { name = "Windfury Totem", level = 32, rank = 1, base_cost = 8000, icon = "Spell_Nature_Windfury", source = "trainer", train = "yes", spellId = 8512 },
    { name = "Windfury Totem", level = 42, rank = 2, base_cost = 16000, icon = "Spell_Nature_Windfury", source = "trainer", train = "yes", spellId = 10613 },
    { name = "Windfury Totem", level = 52, rank = 3, base_cost = 27000, icon = "Spell_Nature_Windfury", source = "trainer", train = "yes", spellId = 10614 },

    -- Windfury Weapon
    { name = "Windfury Weapon", level = 30, rank = 1, base_cost = 7000, icon = "Spell_Nature_Cyclone", source = "trainer", train = "yes", spellId = 8232 },
    { name = "Windfury Weapon", level = 40, rank = 2, base_cost = 12000, icon = "Spell_Nature_Cyclone", source = "trainer", train = "yes", spellId = 8235 },
    { name = "Windfury Weapon", level = 50, rank = 3, base_cost = 24000, icon = "Spell_Nature_Cyclone", source = "trainer", train = "yes", spellId = 10486 },
    { name = "Windfury Weapon", level = 60, rank = 4, base_cost = 34000, icon = "Spell_Nature_Cyclone", source = "trainer", train = "yes", spellId = 16362 },

    -- Windwall Totem
    { name = "Windwall Totem", level = 36, rank = 1, base_cost = 10000, icon = "Spell_Nature_EarthBind", source = "trainer", train = "yes", spellId = 15107 },
    { name = "Windwall Totem", level = 46, rank = 2, base_cost = 20000, icon = "Spell_Nature_EarthBind", source = "trainer", train = "yes", spellId = 15111 },
    { name = "Windwall Totem", level = 56, rank = 3, base_cost = 30000, icon = "Spell_Nature_EarthBind", source = "trainer", train = "yes", spellId = 15112 },
}
