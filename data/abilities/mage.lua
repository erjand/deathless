local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source types:
--   trainer - Learned from class trainer
--   talent  - Requires talent (only shown if base talent is learned)
--   class   - Innate class ability (learned automatically)
--   book    - Learned from a drop/item
--   quest   - Learned from completing a quest
-- Optional fields:
--   faction - "Alliance" or "Horde" (for faction-specific spells like teleports/portals)
-- Sorted alphabetically by name, then by rank
-- See https://www.wowhead.com/classic/spells/abilities/mage for source data
-- See https://www.wowhead.com/classic/npc=3047/archmage-shymm for training costs
Deathless.Data.Abilities["Mage"] = {
    -- Amplify Magic
    { name = "Amplify Magic", level = 18, rank = 1, base_cost = 1800, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "wait", spellId = 1008 },
    { name = "Amplify Magic", level = 30, rank = 2, base_cost = 8000, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "wait", spellId = 8455 },
    { name = "Amplify Magic", level = 42, rank = 3, base_cost = 18000, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "wait", spellId = 10169 },
    { name = "Amplify Magic", level = 54, rank = 4, base_cost = 36000, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "wait", spellId = 10170 },

    -- Arcane Brilliance (book)
    { name = "Arcane Brilliance", level = 56, rank = 1, base_cost = 0, icon = "Spell_Holy_ArcaneIntellect", source = "book", train = "yes", spellId = 23028 },

    -- Arcane Explosion
    { name = "Arcane Explosion", level = 14, rank = 1, base_cost = 900, icon = "Spell_Nature_WispSplode", source = "trainer", train = "yes", spellId = 1449 },
    { name = "Arcane Explosion", level = 22, rank = 2, base_cost = 3000, icon = "Spell_Nature_WispSplode", source = "trainer", train = "yes", spellId = 8437 },
    { name = "Arcane Explosion", level = 30, rank = 3, base_cost = 8000, icon = "Spell_Nature_WispSplode", source = "trainer", train = "yes", spellId = 8438 },
    { name = "Arcane Explosion", level = 38, rank = 4, base_cost = 14000, icon = "Spell_Nature_WispSplode", source = "trainer", train = "yes", spellId = 8439 },
    { name = "Arcane Explosion", level = 46, rank = 5, base_cost = 26000, icon = "Spell_Nature_WispSplode", source = "trainer", train = "yes", spellId = 10201 },
    { name = "Arcane Explosion", level = 54, rank = 6, base_cost = 36000, icon = "Spell_Nature_WispSplode", source = "trainer", train = "yes", spellId = 10202 },

    -- Arcane Intellect
    { name = "Arcane Intellect", level = 1, rank = 1, base_cost = 10, icon = "Spell_Holy_MagicalSentry", source = "trainer", train = "yes", spellId = 1459 },
    { name = "Arcane Intellect", level = 14, rank = 2, base_cost = 900, icon = "Spell_Holy_MagicalSentry", source = "trainer", train = "yes", spellId = 1460 },
    { name = "Arcane Intellect", level = 28, rank = 3, base_cost = 7000, icon = "Spell_Holy_MagicalSentry", source = "trainer", train = "yes", spellId = 1461 },
    { name = "Arcane Intellect", level = 42, rank = 4, base_cost = 18000, icon = "Spell_Holy_MagicalSentry", source = "trainer", train = "yes", spellId = 10156 },
    { name = "Arcane Intellect", level = 56, rank = 5, base_cost = 38000, icon = "Spell_Holy_MagicalSentry", source = "trainer", train = "yes", spellId = 10157 },

    -- Arcane Missiles
    { name = "Arcane Missiles", level = 8, rank = 1, base_cost = 200, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 5143 },
    { name = "Arcane Missiles", level = 16, rank = 2, base_cost = 1500, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 5144 },
    { name = "Arcane Missiles", level = 24, rank = 3, base_cost = 4000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 5145 },
    { name = "Arcane Missiles", level = 32, rank = 4, base_cost = 10000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 8416 },
    { name = "Arcane Missiles", level = 40, rank = 5, base_cost = 15000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 8417 },
    { name = "Arcane Missiles", level = 48, rank = 6, base_cost = 28000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 10211 },
    { name = "Arcane Missiles", level = 56, rank = 7, base_cost = 38000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 10212 },
    { name = "Arcane Missiles", level = 60, rank = 8, base_cost = 0, icon = "Spell_Nature_StarFall", source = "book", train = "yes", spellId = 25345 },

    -- Arcane Power (Arcane 31-point talent)
    { name = "Arcane Power", level = 40, rank = 1, base_cost = 0, icon = "Spell_Nature_Lightning", source = "talent", train = "yes", spellId = 12042 },

    -- Blast Wave (Fire 21-point talent)
    { name = "Blast Wave", level = 30, rank = 1, base_cost = 0, icon = "Spell_Holy_Excorcism_02", source = "talent", train = "yes", spellId = 11113 },
    { name = "Blast Wave", level = 36, rank = 2, base_cost = 650, icon = "Spell_Holy_Excorcism_02", source = "talent", train = "yes", spellId = 13018 },
    { name = "Blast Wave", level = 44, rank = 3, base_cost = 1150, icon = "Spell_Holy_Excorcism_02", source = "talent", train = "yes", spellId = 13019 },
    { name = "Blast Wave", level = 52, rank = 4, base_cost = 1750, icon = "Spell_Holy_Excorcism_02", source = "talent", train = "yes", spellId = 13020 },
    { name = "Blast Wave", level = 60, rank = 5, base_cost = 2100, icon = "Spell_Holy_Excorcism_02", source = "talent", train = "yes", spellId = 13021 },

    -- Blink
    { name = "Blink", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Arcane_Blink", source = "trainer", train = "yes", spellId = 1953 },

    -- Blizzard
    { name = "Blizzard", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Frost_IceStorm", source = "trainer", train = "yes", spellId = 10 },
    { name = "Blizzard", level = 28, rank = 2, base_cost = 7000, icon = "Spell_Frost_IceStorm", source = "trainer", train = "yes", spellId = 6141 },
    { name = "Blizzard", level = 36, rank = 3, base_cost = 13000, icon = "Spell_Frost_IceStorm", source = "trainer", train = "yes", spellId = 8427 },
    { name = "Blizzard", level = 44, rank = 4, base_cost = 23000, icon = "Spell_Frost_IceStorm", source = "trainer", train = "yes", spellId = 10185 },
    { name = "Blizzard", level = 52, rank = 5, base_cost = 35000, icon = "Spell_Frost_IceStorm", source = "trainer", train = "yes", spellId = 10186 },
    { name = "Blizzard", level = 60, rank = 6, base_cost = 42000, icon = "Spell_Frost_IceStorm", source = "trainer", train = "yes", spellId = 10187 },

    -- Cold Snap (Frost 11-point talent)
    { name = "Cold Snap", level = 20, rank = 1, base_cost = 0, icon = "Spell_Frost_WizardMark", source = "talent", train = "yes", spellId = 12472 },

    -- Combustion (Fire 31-point talent)
    { name = "Combustion", level = 40, rank = 1, base_cost = 0, icon = "Spell_Fire_SealOfFire", source = "talent", train = "yes", spellId = 11129 },

    -- Cone of Cold
    { name = "Cone of Cold", level = 26, rank = 1, base_cost = 5000, icon = "Spell_Frost_Glacier", source = "trainer", train = "yes", spellId = 120 },
    { name = "Cone of Cold", level = 34, rank = 2, base_cost = 12000, icon = "Spell_Frost_Glacier", source = "trainer", train = "yes", spellId = 8492 },
    { name = "Cone of Cold", level = 42, rank = 3, base_cost = 18000, icon = "Spell_Frost_Glacier", source = "trainer", train = "yes", spellId = 10159 },
    { name = "Cone of Cold", level = 50, rank = 4, base_cost = 32000, icon = "Spell_Frost_Glacier", source = "trainer", train = "yes", spellId = 10160 },
    { name = "Cone of Cold", level = 58, rank = 5, base_cost = 40000, icon = "Spell_Frost_Glacier", source = "trainer", train = "yes", spellId = 10161 },

    -- Conjure Food
    { name = "Conjure Food", level = 6, rank = 1, base_cost = 100, icon = "INV_Misc_Food_10", source = "trainer", train = "yes", spellId = 587 },
    { name = "Conjure Food", level = 12, rank = 2, base_cost = 600, icon = "INV_Misc_Food_09", source = "trainer", train = "yes", spellId = 597 },
    { name = "Conjure Food", level = 22, rank = 3, base_cost = 3000, icon = "INV_Misc_Food_12", source = "trainer", train = "yes", spellId = 990 },
    { name = "Conjure Food", level = 32, rank = 4, base_cost = 10000, icon = "INV_Misc_Food_08", source = "trainer", train = "yes", spellId = 6129 },
    { name = "Conjure Food", level = 42, rank = 5, base_cost = 22750, icon = "INV_Misc_Food_11", source = "trainer", train = "yes", spellId = 10144 },
    { name = "Conjure Food", level = 52, rank = 6, base_cost = 35000, icon = "INV_Misc_Food_33", source = "trainer", train = "yes", spellId = 10145 },
    { name = "Conjure Food", level = 60, rank = 7, base_cost = 0, icon = "INV_Misc_Food_73cinnamonroll", source = "book", train = "yes", spellId = 28612 },

    -- Conjure Mana Gems
    { name = "Conjure Mana Agate", level = 28, rank = 1, base_cost = 7000, icon = "INV_Misc_Gem_Emerald_01", source = "trainer", train = "yes", spellId = 759 },
    { name = "Conjure Mana Jade", level = 38, rank = 1, base_cost = 14000, icon = "INV_Misc_Gem_Emerald_02", source = "trainer", train = "yes", spellId = 3552 },
    { name = "Conjure Mana Citrine", level = 48, rank = 1, base_cost = 28000, icon = "INV_Misc_Gem_Opal_01", source = "trainer", train = "yes", spellId = 10053 },
    { name = "Conjure Mana Ruby", level = 58, rank = 1, base_cost = 40000, icon = "INV_Misc_Gem_Ruby_01", source = "trainer", train = "yes", spellId = 10054 },

    -- Conjure Water
    { name = "Conjure Water", level = 4, rank = 1, base_cost = 100, icon = "INV_Drink_06", source = "trainer", train = "yes", spellId = 5504 },
    { name = "Conjure Water", level = 10, rank = 2, base_cost = 400, icon = "INV_Drink_07", source = "trainer", train = "yes", spellId = 5505 },
    { name = "Conjure Water", level = 20, rank = 3, base_cost = 2000, icon = "INV_Drink_Milk_02", source = "trainer", train = "yes", spellId = 5506 },
    { name = "Conjure Water", level = 30, rank = 4, base_cost = 8000, icon = "INV_Drink_10", source = "trainer", train = "yes", spellId = 6127 },
    { name = "Conjure Water", level = 40, rank = 5, base_cost = 15000, icon = "INV_Drink_09", source = "trainer", train = "yes", spellId = 10138 },
    { name = "Conjure Water", level = 50, rank = 6, base_cost = 32000, icon = "INV_Drink_11", source = "trainer", train = "yes", spellId = 10139 },
    { name = "Conjure Water", level = 60, rank = 7, base_cost = 0, icon = "INV_Drink_18", source = "book", train = "yes", spellId = 10140 },

    -- Counterspell
    { name = "Counterspell", level = 24, rank = 1, base_cost = 4000, icon = "Spell_Frost_IceShock", source = "trainer", train = "yes", spellId = 2139 },

    -- Dampen Magic
    { name = "Dampen Magic", level = 12, rank = 1, base_cost = 600, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "wait", spellId = 604 },
    { name = "Dampen Magic", level = 24, rank = 2, base_cost = 4000, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "wait", spellId = 8450 },
    { name = "Dampen Magic", level = 36, rank = 3, base_cost = 13000, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "wait", spellId = 8451 },
    { name = "Dampen Magic", level = 48, rank = 4, base_cost = 28000, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "wait", spellId = 10173 },
    { name = "Dampen Magic", level = 60, rank = 5, base_cost = 42000, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "wait", spellId = 10174 },

    -- Detect Magic
    { name = "Detect Magic", level = 16, rank = 1, base_cost = 1500, icon = "Spell_Holy_Dizzy", source = "trainer", train = "wait", spellId = 2855 },

    -- Evocation
    { name = "Evocation", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Nature_Purge", source = "trainer", train = "yes", spellId = 12051 },

    -- Fire Blast
    { name = "Fire Blast", level = 6, rank = 1, base_cost = 100, icon = "Spell_Fire_Fireball", source = "trainer", train = "yes", spellId = 2136 },
    { name = "Fire Blast", level = 14, rank = 2, base_cost = 900, icon = "Spell_Fire_Fireball", source = "trainer", train = "yes", spellId = 2137 },
    { name = "Fire Blast", level = 22, rank = 3, base_cost = 3000, icon = "Spell_Fire_Fireball", source = "trainer", train = "yes", spellId = 2138 },
    { name = "Fire Blast", level = 30, rank = 4, base_cost = 8000, icon = "Spell_Fire_Fireball", source = "trainer", train = "yes", spellId = 8412 },
    { name = "Fire Blast", level = 38, rank = 5, base_cost = 14000, icon = "Spell_Fire_Fireball", source = "trainer", train = "yes", spellId = 8413 },
    { name = "Fire Blast", level = 46, rank = 6, base_cost = 26000, icon = "Spell_Fire_Fireball", source = "trainer", train = "yes", spellId = 10197 },
    { name = "Fire Blast", level = 54, rank = 7, base_cost = 36000, icon = "Spell_Fire_Fireball", source = "trainer", train = "yes", spellId = 10199 },

    -- Fire Ward
    { name = "Fire Ward", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Fire_FireArmor", source = "trainer", train = "yes", spellId = 543 },
    { name = "Fire Ward", level = 30, rank = 2, base_cost = 8000, icon = "Spell_Fire_FireArmor", source = "trainer", train = "yes", spellId = 8457 },
    { name = "Fire Ward", level = 40, rank = 3, base_cost = 15000, icon = "Spell_Fire_FireArmor", source = "trainer", train = "yes", spellId = 8458 },
    { name = "Fire Ward", level = 50, rank = 4, base_cost = 32000, icon = "Spell_Fire_FireArmor", source = "trainer", train = "yes", spellId = 10223 },
    { name = "Fire Ward", level = 60, rank = 5, base_cost = 42000, icon = "Spell_Fire_FireArmor", source = "trainer", train = "yes", spellId = 10225 },

    -- Fireball
    { name = "Fireball", level = 1, rank = 1, base_cost = 0, icon = "Spell_Fire_FlameBolt", source = "class", train = "yes", spellId = 133 },
    { name = "Fireball", level = 6, rank = 2, base_cost = 100, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 143 },
    { name = "Fireball", level = 12, rank = 3, base_cost = 600, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 145 },
    { name = "Fireball", level = 18, rank = 4, base_cost = 1800, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 3140 },
    { name = "Fireball", level = 24, rank = 5, base_cost = 4000, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 8400 },
    { name = "Fireball", level = 30, rank = 6, base_cost = 8000, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 8401 },
    { name = "Fireball", level = 36, rank = 7, base_cost = 13000, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 8402 },
    { name = "Fireball", level = 42, rank = 8, base_cost = 18000, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 10148 },
    { name = "Fireball", level = 48, rank = 9, base_cost = 28000, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 10149 },
    { name = "Fireball", level = 54, rank = 10, base_cost = 36000, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 10150 },
    { name = "Fireball", level = 60, rank = 11, base_cost = 42000, icon = "Spell_Fire_FlameBolt", source = "trainer", train = "yes", spellId = 10151 },
    { name = "Fireball", level = 60, rank = 12, base_cost = 0, icon = "Spell_Fire_FlameBolt", source = "book", train = "yes", spellId = 25306 },

    -- Flamestrike
    { name = "Flamestrike", level = 16, rank = 1, base_cost = 1500, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 2120 },
    { name = "Flamestrike", level = 24, rank = 2, base_cost = 4000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 2121 },
    { name = "Flamestrike", level = 32, rank = 3, base_cost = 10000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 8422 },
    { name = "Flamestrike", level = 40, rank = 4, base_cost = 15000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 8423 },
    { name = "Flamestrike", level = 48, rank = 5, base_cost = 28000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 10215 },
    { name = "Flamestrike", level = 56, rank = 6, base_cost = 38000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 10216 },

    -- Frost Armor
    { name = "Frost Armor", level = 1, rank = 1, base_cost = 0, icon = "Spell_Frost_FrostArmor02", source = "class", train = "yes", spellId = 168 },
    { name = "Frost Armor", level = 10, rank = 2, base_cost = 400, icon = "Spell_Frost_FrostArmor02", source = "trainer", train = "yes", spellId = 7300 },
    { name = "Frost Armor", level = 20, rank = 3, base_cost = 2000, icon = "Spell_Frost_FrostArmor02", source = "trainer", train = "yes", spellId = 7301 },

    -- Frost Nova
    { name = "Frost Nova", level = 10, rank = 1, base_cost = 400, icon = "Spell_Frost_FrostNova", source = "trainer", train = "yes", spellId = 122 },
    { name = "Frost Nova", level = 26, rank = 2, base_cost = 5000, icon = "Spell_Frost_FrostNova", source = "trainer", train = "wait", spellId = 865 },
    { name = "Frost Nova", level = 40, rank = 3, base_cost = 15000, icon = "Spell_Frost_FrostNova", source = "trainer", train = "wait", spellId = 6131 },
    { name = "Frost Nova", level = 54, rank = 4, base_cost = 36000, icon = "Spell_Frost_FrostNova", source = "trainer", train = "wait", spellId = 10230 },

    -- Frost Ward
    { name = "Frost Ward", level = 22, rank = 1, base_cost = 3000, icon = "Spell_Frost_FrostWard", source = "trainer", train = "yes", spellId = 6143 },
    { name = "Frost Ward", level = 32, rank = 2, base_cost = 10000, icon = "Spell_Frost_FrostWard", source = "trainer", train = "yes", spellId = 8461 },
    { name = "Frost Ward", level = 42, rank = 3, base_cost = 18000, icon = "Spell_Frost_FrostWard", source = "trainer", train = "yes", spellId = 8462 },
    { name = "Frost Ward", level = 52, rank = 4, base_cost = 35000, icon = "Spell_Frost_FrostWard", source = "trainer", train = "yes", spellId = 10177 },

    -- Frostbolt
    { name = "Frostbolt", level = 4, rank = 1, base_cost = 100, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 116 },
    { name = "Frostbolt", level = 8, rank = 2, base_cost = 200, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 205 },
    { name = "Frostbolt", level = 14, rank = 3, base_cost = 900, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 837 },
    { name = "Frostbolt", level = 20, rank = 4, base_cost = 2000, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 7322 },
    { name = "Frostbolt", level = 26, rank = 5, base_cost = 5000, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 8406 },
    { name = "Frostbolt", level = 32, rank = 6, base_cost = 10000, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 8407 },
    { name = "Frostbolt", level = 38, rank = 7, base_cost = 14000, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 8408 },
    { name = "Frostbolt", level = 44, rank = 8, base_cost = 23000, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 10179 },
    { name = "Frostbolt", level = 50, rank = 9, base_cost = 32000, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 10180 },
    { name = "Frostbolt", level = 56, rank = 10, base_cost = 38000, icon = "Spell_Frost_FrostBolt02", source = "trainer", train = "yes", spellId = 10181 },
    { name = "Frostbolt", level = 60, rank = 11, base_cost = 0, icon = "Spell_Frost_FrostBolt02", source = "book", train = "yes", spellId = 25304 },

    -- Ice Armor
    { name = "Ice Armor", level = 30, rank = 1, base_cost = 8000, icon = "Spell_Frost_ChillingArmor", source = "trainer", train = "yes", spellId = 7302 },
    { name = "Ice Armor", level = 40, rank = 2, base_cost = 15000, icon = "Spell_Frost_ChillingArmor", source = "trainer", train = "yes", spellId = 7320 },
    { name = "Ice Armor", level = 50, rank = 3, base_cost = 32000, icon = "Spell_Frost_ChillingArmor", source = "trainer", train = "yes", spellId = 10219 },
    { name = "Ice Armor", level = 60, rank = 4, base_cost = 42000, icon = "Spell_Frost_ChillingArmor", source = "trainer", train = "yes", spellId = 10220 },

    -- Ice Barrier (Frost 31-point talent)
    { name = "Ice Barrier", level = 40, rank = 1, base_cost = 0, icon = "Spell_Ice_Lament", source = "talent", train = "yes", spellId = 11426 },
    { name = "Ice Barrier", level = 46, rank = 2, base_cost = 1300, icon = "Spell_Ice_Lament", source = "talent", train = "yes", spellId = 13031 },
    { name = "Ice Barrier", level = 52, rank = 3, base_cost = 1750, icon = "Spell_Ice_Lament", source = "talent", train = "yes", spellId = 13032 },
    { name = "Ice Barrier", level = 58, rank = 4, base_cost = 2000, icon = "Spell_Ice_Lament", source = "talent", train = "yes", spellId = 13033 },

    -- Ice Block (Frost 21-point talent)
    { name = "Ice Block", level = 30, rank = 1, base_cost = 0, icon = "Spell_Frost_Frost", source = "talent", train = "yes", spellId = 11958 },

    -- Mage Armor
    { name = "Mage Armor", level = 34, rank = 1, base_cost = 13000, icon = "Spell_MageArmor", source = "trainer", train = "yes", spellId = 6117 },
    { name = "Mage Armor", level = 46, rank = 2, base_cost = 28000, icon = "Spell_MageArmor", source = "trainer", train = "yes", spellId = 22782 },
    { name = "Mage Armor", level = 58, rank = 3, base_cost = 40000, icon = "Spell_MageArmor", source = "trainer", train = "yes", spellId = 22783 },

    -- Mana Shield
    { name = "Mana Shield", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Shadow_DetectLesserInvisibility", source = "trainer", train = "yes", spellId = 1463 },
    { name = "Mana Shield", level = 28, rank = 2, base_cost = 7000, icon = "Spell_Shadow_DetectLesserInvisibility", source = "trainer", train = "yes", spellId = 8494 },
    { name = "Mana Shield", level = 36, rank = 3, base_cost = 13000, icon = "Spell_Shadow_DetectLesserInvisibility", source = "trainer", train = "yes", spellId = 8495 },
    { name = "Mana Shield", level = 44, rank = 4, base_cost = 23000, icon = "Spell_Shadow_DetectLesserInvisibility", source = "trainer", train = "yes", spellId = 10191 },
    { name = "Mana Shield", level = 52, rank = 5, base_cost = 35000, icon = "Spell_Shadow_DetectLesserInvisibility", source = "trainer", train = "yes", spellId = 10192 },
    { name = "Mana Shield", level = 60, rank = 6, base_cost = 42000, icon = "Spell_Shadow_DetectLesserInvisibility", source = "trainer", train = "yes", spellId = 10193 },

    -- Polymorph
    { name = "Polymorph", level = 8, rank = 1, base_cost = 200, icon = "Spell_Nature_Polymorph", source = "trainer", train = "yes", spellId = 118 },
    { name = "Polymorph", level = 20, rank = 2, base_cost = 2000, icon = "Spell_Nature_Polymorph", source = "trainer", train = "yes", spellId = 12824 },
    { name = "Polymorph", level = 40, rank = 3, base_cost = 15000, icon = "Spell_Nature_Polymorph", source = "trainer", train = "yes", spellId = 12825 },
    { name = "Polymorph", level = 60, rank = 4, base_cost = 42000, icon = "Spell_Nature_Polymorph", source = "trainer", train = "yes", spellId = 12826 },
    { name = "Polymorph: Pig", level = 60, rank = 1, base_cost = 0, icon = "Spell_Magic_PolymorphPig", source = "book", train = "yes", spellId = 28272 },
    { name = "Polymorph: Turtle", level = 60, rank = 1, base_cost = 0, icon = "Ability_Hunter_Pet_Turtle", source = "book", train = "yes", spellId = 28271 },

    -- Portal: Alliance
    { name = "Portal: Stormwind", level = 40, rank = 1, base_cost = 15000, icon = "Spell_Arcane_PortalStormWind", source = "trainer", faction = "Alliance", train = "yes", spellId = 10059 },
    { name = "Portal: Ironforge", level = 40, rank = 1, base_cost = 15000, icon = "Spell_Arcane_PortalIronforge", source = "trainer", faction = "Alliance", train = "yes", spellId = 11416 },
    { name = "Portal: Darnassus", level = 50, rank = 1, base_cost = 32000, icon = "Spell_Arcane_PortalDarnassus", source = "trainer", faction = "Alliance", train = "yes", spellId = 11419 },
    
    -- Portal: Horde
    { name = "Portal: Orgrimmar", level = 40, rank = 1, base_cost = 15000, icon = "Spell_Arcane_PortalOrgrimmar", source = "trainer", faction = "Horde", train = "yes", spellId = 11417 },
    { name = "Portal: Undercity", level = 40, rank = 1, base_cost = 15000, icon = "Spell_Arcane_PortalUnderCity", source = "trainer", faction = "Horde", train = "yes", spellId = 11418 },
    { name = "Portal: Thunder Bluff", level = 50, rank = 1, base_cost = 32000, icon = "Spell_Arcane_PortalThunderBluff", source = "trainer", faction = "Horde", train = "yes", spellId = 11420 },

    -- Presence of Mind (Arcane 21-point talent)
    { name = "Presence of Mind", level = 30, rank = 1, base_cost = 0, icon = "Spell_Nature_EnchantArmor", source = "talent", train = "yes", spellId = 12043 },

    -- Pyroblast (Fire 11-point talent)
    { name = "Pyroblast", level = 20, rank = 1, base_cost = 0, icon = "Spell_Fire_Fireball02", source = "talent", train = "yes", spellId = 11366 },
    { name = "Pyroblast", level = 24, rank = 2, base_cost = 200, icon = "Spell_Fire_Fireball02", source = "talent", train = "yes", spellId = 12505 },
    { name = "Pyroblast", level = 30, rank = 3, base_cost = 400, icon = "Spell_Fire_Fireball02", source = "talent", train = "yes", spellId = 12522 },
    { name = "Pyroblast", level = 36, rank = 4, base_cost = 650, icon = "Spell_Fire_Fireball02", source = "talent", train = "yes", spellId = 12523 },
    { name = "Pyroblast", level = 42, rank = 5, base_cost = 900, icon = "Spell_Fire_Fireball02", source = "talent", train = "yes", spellId = 12524 },
    { name = "Pyroblast", level = 48, rank = 6, base_cost = 1400, icon = "Spell_Fire_Fireball02", source = "talent", train = "yes", spellId = 12525 },
    { name = "Pyroblast", level = 54, rank = 7, base_cost = 1800, icon = "Spell_Fire_Fireball02", source = "talent", train = "yes", spellId = 12526 },
    { name = "Pyroblast", level = 60, rank = 8, base_cost = 2100, icon = "Spell_Fire_Fireball02", source = "talent", train = "yes", spellId = 18809 },

    -- Remove Lesser Curse
    { name = "Remove Lesser Curse", level = 18, rank = 1, base_cost = 1800, icon = "Spell_Nature_RemoveCurse", source = "trainer", train = "yes", spellId = 475 },

    -- Scorch
    { name = "Scorch", level = 22, rank = 1, base_cost = 3000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 2948 },
    { name = "Scorch", level = 28, rank = 2, base_cost = 7000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 8444 },
    { name = "Scorch", level = 34, rank = 3, base_cost = 12000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 8445 },
    { name = "Scorch", level = 40, rank = 4, base_cost = 15000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 8446 },
    { name = "Scorch", level = 46, rank = 5, base_cost = 26000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 10205 },
    { name = "Scorch", level = 52, rank = 6, base_cost = 35000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 10206 },
    { name = "Scorch", level = 58, rank = 7, base_cost = 40000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 10207 },

    -- Slow Fall
    { name = "Slow Fall", level = 12, rank = 1, base_cost = 600, icon = "Spell_Magic_FeatherFall", source = "trainer", train = "yes", spellId = 130 },

    -- Teleport: Alliance
    { name = "Teleport: Stormwind", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Arcane_TeleportStormWind", source = "trainer", faction = "Alliance", train = "yes", spellId = 3561 },
    { name = "Teleport: Ironforge", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Arcane_TeleportIronforge", source = "trainer", faction = "Alliance", train = "yes", spellId = 3562 },
    { name = "Teleport: Darnassus", level = 30, rank = 1, base_cost = 8000, icon = "Spell_Arcane_TeleportDarnassus", source = "trainer", faction = "Alliance", train = "yes", spellId = 3565 },
    
    -- Teleport: Horde
    { name = "Teleport: Orgrimmar", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Arcane_TeleportOrgrimmar", source = "trainer", faction = "Horde", train = "yes", spellId = 3567 },
    { name = "Teleport: Undercity", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Arcane_TeleportUnderCity", source = "trainer", faction = "Horde", train = "yes", spellId = 3563 },
    { name = "Teleport: Thunder Bluff", level = 30, rank = 1, base_cost = 8000, icon = "Spell_Arcane_TeleportThunderBluff", source = "trainer", faction = "Horde", train = "yes", spellId = 3566 },
}
