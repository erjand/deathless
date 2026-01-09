local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source types:
--   trainer - Learned from class trainer
--   talent  - Requires talent points (only shown if base talent is learned)
--   class   - Innate class ability (learned automatically)
--   book    - Learned from a drop/item (tomes - tracked separately)
--   quest   - Learned from completing a quest
-- Train values:
--   yes   - Train when available
--   wait  - Marginal upgrade
--   no    - Not useful for Hardcore
-- Sorted alphabetically by name, then by rank
-- See https://www.wowhead.com/classic/spells/abilities/warlock for source data
-- See https://www.wowhead.com/classic/npc=5173/godan for training costs

Deathless.Data.Abilities["Warlock"] = {
    -- Banish
    { name = "Banish", level = 28, rank = 1, base_cost = 5000, icon = "Spell_Shadow_Cripple", source = "trainer", train = "yes", spellId = 710 },
    { name = "Banish", level = 48, rank = 2, base_cost = 14000, icon = "Spell_Shadow_Cripple", source = "trainer", train = "yes", spellId = 18647 },

    -- Conflagrate (Destruction 31-point talent)
    { name = "Conflagrate", level = 40, rank = 1, base_cost = 0, icon = "Spell_Fire_Fireball", source = "talent", train = "yes", spellId = 17962 },
    { name = "Conflagrate", level = 48, rank = 2, base_cost = 700, icon = "Spell_Fire_Fireball", source = "talent", train = "yes", spellId = 18930 },
    { name = "Conflagrate", level = 54, rank = 3, base_cost = 1000, icon = "Spell_Fire_Fireball", source = "talent", train = "yes", spellId = 18931 },
    { name = "Conflagrate", level = 60, rank = 4, base_cost = 1300, icon = "Spell_Fire_Fireball", source = "talent", train = "yes", spellId = 18932 },

    -- Corruption
    { name = "Corruption", level = 4, rank = 1, base_cost = 100, icon = "Spell_Shadow_AbominationExplosion", source = "trainer", train = "yes", spellId = 172 },
    { name = "Corruption", level = 14, rank = 2, base_cost = 900, icon = "Spell_Shadow_AbominationExplosion", source = "trainer", train = "yes", spellId = 6222 },
    { name = "Corruption", level = 24, rank = 3, base_cost = 3000, icon = "Spell_Shadow_AbominationExplosion", source = "trainer", train = "yes", spellId = 6223 },
    { name = "Corruption", level = 34, rank = 4, base_cost = 8000, icon = "Spell_Shadow_AbominationExplosion", source = "trainer", train = "yes", spellId = 7648 },
    { name = "Corruption", level = 44, rank = 5, base_cost = 12000, icon = "Spell_Shadow_AbominationExplosion", source = "trainer", train = "yes", spellId = 11671 },
    { name = "Corruption", level = 54, rank = 6, base_cost = 20000, icon = "Spell_Shadow_AbominationExplosion", source = "trainer", train = "yes", spellId = 11672 },

    -- Create Firestone
    { name = "Create Firestone", level = 28, rank = 1, base_cost = 5000, icon = "INV_Ammo_FireTar", source = "trainer", train = "wait", spellId = 6366 },
    { name = "Create Firestone", level = 36, rank = 2, base_cost = 9000, icon = "INV_Ammo_FireTar", source = "trainer", train = "wait", spellId = 17951 },
    { name = "Create Firestone", level = 46, rank = 3, base_cost = 13000, icon = "INV_Ammo_FireTar", source = "trainer", train = "wait", spellId = 17952 },
    { name = "Create Firestone", level = 56, rank = 4, base_cost = 22000, icon = "INV_Ammo_FireTar", source = "trainer", train = "wait", spellId = 17953 },

    -- Create Healthstone
    { name = "Create Healthstone", level = 10, rank = 1, base_cost = 300, icon = "INV_Stone_04", source = "trainer", train = "yes", spellId = 6201 },
    { name = "Create Healthstone", level = 22, rank = 2, base_cost = 2500, icon = "INV_Stone_04", source = "trainer", train = "yes", spellId = 6202 },
    { name = "Create Healthstone", level = 34, rank = 3, base_cost = 8000, icon = "INV_Stone_04", source = "trainer", train = "yes", spellId = 5699 },
    { name = "Create Healthstone", level = 46, rank = 4, base_cost = 13000, icon = "INV_Stone_04", source = "trainer", train = "yes", spellId = 11729 },
    { name = "Create Healthstone", level = 58, rank = 5, base_cost = 24000, icon = "INV_Stone_04", source = "trainer", train = "yes", spellId = 11730 },

    -- Create Soulstone
    { name = "Create Soulstone", level = 18, rank = 1, base_cost = 1500, icon = "Spell_Shadow_SoulGem", source = "trainer", train = "no", spellId = 693 },
    { name = "Create Soulstone", level = 30, rank = 2, base_cost = 6000, icon = "Spell_Shadow_SoulGem", source = "trainer", train = "no", spellId = 20752 },
    { name = "Create Soulstone", level = 40, rank = 3, base_cost = 11000, icon = "Spell_Shadow_SoulGem", source = "trainer", train = "no", spellId = 20755 },
    { name = "Create Soulstone", level = 50, rank = 4, base_cost = 15000, icon = "Spell_Shadow_SoulGem", source = "trainer", train = "no", spellId = 20756 },
    { name = "Create Soulstone", level = 60, rank = 5, base_cost = 26000, icon = "Spell_Shadow_SoulGem", source = "trainer", train = "no", spellId = 20757 },

    -- Create Spellstone
    { name = "Create Spellstone", level = 36, rank = 1, base_cost = 9000, icon = "INV_Misc_Gem_Sapphire_01", source = "trainer", train = "wait", spellId = 2362 },
    { name = "Create Spellstone", level = 48, rank = 2, base_cost = 14000, icon = "INV_Misc_Gem_Sapphire_01", source = "trainer", train = "wait", spellId = 17727 },
    { name = "Create Spellstone", level = 60, rank = 3, base_cost = 26000, icon = "INV_Misc_Gem_Sapphire_01", source = "trainer", train = "wait", spellId = 17728 },

    -- Curse of Agony
    { name = "Curse of Agony", level = 8, rank = 1, base_cost = 200, icon = "Spell_Shadow_CurseOfSargeras", source = "trainer", train = "yes", spellId = 980 },
    { name = "Curse of Agony", level = 18, rank = 2, base_cost = 1500, icon = "Spell_Shadow_CurseOfSargeras", source = "trainer", train = "yes", spellId = 1014 },
    { name = "Curse of Agony", level = 28, rank = 3, base_cost = 5000, icon = "Spell_Shadow_CurseOfSargeras", source = "trainer", train = "yes", spellId = 6217 },
    { name = "Curse of Agony", level = 38, rank = 4, base_cost = 10000, icon = "Spell_Shadow_CurseOfSargeras", source = "trainer", train = "yes", spellId = 11711 },
    { name = "Curse of Agony", level = 48, rank = 5, base_cost = 14000, icon = "Spell_Shadow_CurseOfSargeras", source = "trainer", train = "yes", spellId = 11712 },
    { name = "Curse of Agony", level = 58, rank = 6, base_cost = 24000, icon = "Spell_Shadow_CurseOfSargeras", source = "trainer", train = "yes", spellId = 11713 },

    -- Curse of Doom
    { name = "Curse of Doom", level = 60, rank = 1, base_cost = 26000, icon = "Spell_Shadow_AuraOfDarkness", source = "trainer", train = "yes", spellId = 603 },

    -- Curse of Recklessness
    { name = "Curse of Recklessness", level = 14, rank = 1, base_cost = 900, icon = "Spell_Shadow_UnholyStrength", source = "trainer", train = "yes", spellId = 704 },
    { name = "Curse of Recklessness", level = 28, rank = 2, base_cost = 5000, icon = "Spell_Shadow_UnholyStrength", source = "trainer", train = "yes", spellId = 7658 },
    { name = "Curse of Recklessness", level = 42, rank = 3, base_cost = 11000, icon = "Spell_Shadow_UnholyStrength", source = "trainer", train = "yes", spellId = 7659 },
    { name = "Curse of Recklessness", level = 56, rank = 4, base_cost = 22000, icon = "Spell_Shadow_UnholyStrength", source = "trainer", train = "yes", spellId = 11717 },

    -- Curse of Shadow
    { name = "Curse of Shadow", level = 44, rank = 1, base_cost = 12000, icon = "Spell_Shadow_CurseOfAchimonde", source = "trainer", train = "yes", spellId = 17862 },
    { name = "Curse of Shadow", level = 56, rank = 2, base_cost = 22000, icon = "Spell_Shadow_CurseOfAchimonde", source = "trainer", train = "yes", spellId = 17937 },

    -- Curse of the Elements
    { name = "Curse of the Elements", level = 32, rank = 1, base_cost = 7000, icon = "Spell_Shadow_ChillTouch", source = "trainer", train = "yes", spellId = 1490 },
    { name = "Curse of the Elements", level = 46, rank = 2, base_cost = 13000, icon = "Spell_Shadow_ChillTouch", source = "trainer", train = "yes", spellId = 11721 },
    { name = "Curse of the Elements", level = 60, rank = 3, base_cost = 26000, icon = "Spell_Shadow_ChillTouch", source = "trainer", train = "yes", spellId = 11722 },

    -- Curse of Tongues
    { name = "Curse of Tongues", level = 26, rank = 1, base_cost = 4000, icon = "Spell_Shadow_CurseOfTounable", source = "trainer", train = "yes", spellId = 1714 },
    { name = "Curse of Tongues", level = 50, rank = 2, base_cost = 15000, icon = "Spell_Shadow_CurseOfTounges", source = "trainer", train = "yes", spellId = 11719 },

    -- Curse of Weakness
    { name = "Curse of Weakness", level = 4, rank = 1, base_cost = 100, icon = "Spell_Shadow_CurseOfMannoroth", source = "trainer", train = "yes", spellId = 702 },
    { name = "Curse of Weakness", level = 12, rank = 2, base_cost = 600, icon = "Spell_Shadow_CurseOfMannoroth", source = "trainer", train = "yes", spellId = 1108 },
    { name = "Curse of Weakness", level = 22, rank = 3, base_cost = 2500, icon = "Spell_Shadow_CurseOfMannoroth", source = "trainer", train = "yes", spellId = 6205 },
    { name = "Curse of Weakness", level = 32, rank = 4, base_cost = 7000, icon = "Spell_Shadow_CurseOfMannoroth", source = "trainer", train = "yes", spellId = 7646 },
    { name = "Curse of Weakness", level = 42, rank = 5, base_cost = 11000, icon = "Spell_Shadow_CurseOfMannoroth", source = "trainer", train = "yes", spellId = 11707 },
    { name = "Curse of Weakness", level = 52, rank = 6, base_cost = 18000, icon = "Spell_Shadow_CurseOfMannoroth", source = "trainer", train = "yes", spellId = 11708 },

    -- Dark Pact (Affliction 31-point talent)
    { name = "Dark Pact", level = 40, rank = 1, base_cost = 0, icon = "Spell_Shadow_DarkRitual", source = "talent", train = "yes", spellId = 18220 },
    { name = "Dark Pact", level = 50, rank = 2, base_cost = 750, icon = "Spell_Shadow_DarkRitual", source = "talent", train = "yes", spellId = 18937 },
    { name = "Dark Pact", level = 60, rank = 3, base_cost = 1300, icon = "Spell_Shadow_DarkRitual", source = "talent", train = "yes", spellId = 18938 },

    -- Death Coil
    { name = "Death Coil", level = 42, rank = 1, base_cost = 11000, icon = "Spell_Shadow_DeathCoil", source = "trainer", train = "yes", spellId = 6789 },
    { name = "Death Coil", level = 50, rank = 2, base_cost = 15000, icon = "Spell_Shadow_DeathCoil", source = "trainer", train = "yes", spellId = 17925 },
    { name = "Death Coil", level = 58, rank = 3, base_cost = 24000, icon = "Spell_Shadow_DeathCoil", source = "trainer", train = "yes", spellId = 17926 },

    -- Demon Armor
    { name = "Demon Armor", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Shadow_RagingScream", source = "trainer", train = "yes", spellId = 706 },
    { name = "Demon Armor", level = 30, rank = 2, base_cost = 6000, icon = "Spell_Shadow_RagingScream", source = "trainer", train = "yes", spellId = 1086 },
    { name = "Demon Armor", level = 40, rank = 3, base_cost = 11000, icon = "Spell_Shadow_RagingScream", source = "trainer", train = "yes", spellId = 11733 },
    { name = "Demon Armor", level = 50, rank = 4, base_cost = 15000, icon = "Spell_Shadow_RagingScream", source = "trainer", train = "yes", spellId = 11734 },
    { name = "Demon Armor", level = 60, rank = 5, base_cost = 26000, icon = "Spell_Shadow_RagingScream", source = "trainer", train = "yes", spellId = 11735 },

    -- Demon Skin
    { name = "Demon Skin", level = 1, rank = 1, base_cost = 10, icon = "Spell_Shadow_RagingScream", source = "class", train = "yes", spellId = 687 },
    { name = "Demon Skin", level = 10, rank = 2, base_cost = 300, icon = "Spell_Shadow_RagingScream", source = "trainer", train = "yes", spellId = 696 },

    -- Detect Invisibility
    { name = "Detect Letter Invisibility", level = 26, rank = 1, base_cost = 4000, icon = "Spell_Shadow_DetectLesserInvisibility", source = "trainer", train = "wait", spellId = 132 },
    { name = "Detect Invisibility", level = 38, rank = 2, base_cost = 10000, icon = "Spell_Shadow_DetectInvisibility", source = "trainer", train = "wait", spellId = 2970 },
    { name = "Detect Greater Invisibility", level = 50, rank = 3, base_cost = 15000, icon = "Spell_Shadow_DetectInvisibility", source = "trainer", train = "wait", spellId = 11743 },

    -- Drain Life
    { name = "Drain Life", level = 14, rank = 1, base_cost = 900, icon = "Spell_Shadow_LifeDrain02", source = "trainer", train = "yes", spellId = 689 },
    { name = "Drain Life", level = 22, rank = 2, base_cost = 2500, icon = "Spell_Shadow_LifeDrain02", source = "trainer", train = "yes", spellId = 699 },
    { name = "Drain Life", level = 30, rank = 3, base_cost = 6000, icon = "Spell_Shadow_LifeDrain02", source = "trainer", train = "yes", spellId = 709 },
    { name = "Drain Life", level = 38, rank = 4, base_cost = 10000, icon = "Spell_Shadow_LifeDrain02", source = "trainer", train = "yes", spellId = 7651 },
    { name = "Drain Life", level = 46, rank = 5, base_cost = 13000, icon = "Spell_Shadow_LifeDrain02", source = "trainer", train = "yes", spellId = 11699 },
    { name = "Drain Life", level = 54, rank = 6, base_cost = 20000, icon = "Spell_Shadow_LifeDrain02", source = "trainer", train = "yes", spellId = 11700 },

    -- Drain Mana
    { name = "Drain Mana", level = 24, rank = 1, base_cost = 3000, icon = "Spell_Shadow_SiphonMana", source = "trainer", train = "yes", spellId = 5138 },
    { name = "Drain Mana", level = 34, rank = 2, base_cost = 8000, icon = "Spell_Shadow_SiphonMana", source = "trainer", train = "yes", spellId = 6226 },
    { name = "Drain Mana", level = 44, rank = 3, base_cost = 12000, icon = "Spell_Shadow_SiphonMana", source = "trainer", train = "yes", spellId = 11703 },
    { name = "Drain Mana", level = 54, rank = 4, base_cost = 20000, icon = "Spell_Shadow_SiphonMana", source = "trainer", train = "yes", spellId = 11704 },

    -- Drain Soul
    { name = "Drain Soul", level = 10, rank = 1, base_cost = 300, icon = "Spell_Shadow_Haunting", source = "trainer", train = "yes", spellId = 1120 },
    { name = "Drain Soul", level = 24, rank = 2, base_cost = 3000, icon = "Spell_Shadow_Haunting", source = "trainer", train = "yes", spellId = 8288 },
    { name = "Drain Soul", level = 38, rank = 3, base_cost = 10000, icon = "Spell_Shadow_Haunting", source = "trainer", train = "yes", spellId = 8289 },
    { name = "Drain Soul", level = 52, rank = 4, base_cost = 18000, icon = "Spell_Shadow_Haunting", source = "trainer", train = "yes", spellId = 11675 },

    -- Eye of Kilrogg
    { name = "Eye of Kilrogg", level = 22, rank = 1, base_cost = 2500, icon = "Spell_Shadow_EvilEye", source = "trainer", train = "wait", spellId = 126 },

    -- Fear
    { name = "Fear", level = 8, rank = 1, base_cost = 200, icon = "Spell_Shadow_Possession", source = "trainer", train = "yes", spellId = 5782 },
    { name = "Fear", level = 32, rank = 2, base_cost = 7000, icon = "Spell_Shadow_Possession", source = "trainer", train = "yes", spellId = 6213 },
    { name = "Fear", level = 56, rank = 3, base_cost = 22000, icon = "Spell_Shadow_Possession", source = "trainer", train = "yes", spellId = 6215 },

    -- Health Funnel
    { name = "Health Funnel", level = 12, rank = 1, base_cost = 600, icon = "Spell_Shadow_LifeDrain", source = "trainer", train = "yes", spellId = 755 },
    { name = "Health Funnel", level = 20, rank = 2, base_cost = 2000, icon = "Spell_Shadow_LifeDrain", source = "trainer", train = "yes", spellId = 3698 },
    { name = "Health Funnel", level = 28, rank = 3, base_cost = 5000, icon = "Spell_Shadow_LifeDrain", source = "trainer", train = "yes", spellId = 3699 },
    { name = "Health Funnel", level = 36, rank = 4, base_cost = 9000, icon = "Spell_Shadow_LifeDrain", source = "trainer", train = "yes", spellId = 3700 },
    { name = "Health Funnel", level = 44, rank = 5, base_cost = 12000, icon = "Spell_Shadow_LifeDrain", source = "trainer", train = "yes", spellId = 11693 },
    { name = "Health Funnel", level = 52, rank = 6, base_cost = 18000, icon = "Spell_Shadow_LifeDrain", source = "trainer", train = "yes", spellId = 11694 },
    { name = "Health Funnel", level = 60, rank = 7, base_cost = 26000, icon = "Spell_Shadow_LifeDrain", source = "trainer", train = "yes", spellId = 11695 },

    -- Hellfire
    { name = "Hellfire", level = 30, rank = 1, base_cost = 6000, icon = "Spell_Fire_Incinerate", source = "trainer", train = "yes", spellId = 1949 },
    { name = "Hellfire", level = 42, rank = 2, base_cost = 11000, icon = "Spell_Fire_Incinerate", source = "trainer", train = "yes", spellId = 11683 },
    { name = "Hellfire", level = 54, rank = 3, base_cost = 20000, icon = "Spell_Fire_Incinerate", source = "trainer", train = "yes", spellId = 11684 },

    -- Howl of Terror
    { name = "Howl of Terror", level = 40, rank = 1, base_cost = 11000, icon = "Spell_Shadow_DeathScream", source = "trainer", train = "yes", spellId = 5484 },
    { name = "Howl of Terror", level = 54, rank = 2, base_cost = 20000, icon = "Spell_Shadow_DeathScream", source = "trainer", train = "yes", spellId = 17928 },

    -- Immolate
    { name = "Immolate", level = 1, rank = 1, base_cost = 10, icon = "Spell_Fire_Immolation", source = "trainer", train = "yes", spellId = 348 },
    { name = "Immolate", level = 10, rank = 2, base_cost = 300, icon = "Spell_Fire_Immolation", source = "trainer", train = "yes", spellId = 707 },
    { name = "Immolate", level = 20, rank = 3, base_cost = 2000, icon = "Spell_Fire_Immolation", source = "trainer", train = "yes", spellId = 1094 },
    { name = "Immolate", level = 30, rank = 4, base_cost = 6000, icon = "Spell_Fire_Immolation", source = "trainer", train = "yes", spellId = 2941 },
    { name = "Immolate", level = 40, rank = 5, base_cost = 11000, icon = "Spell_Fire_Immolation", source = "trainer", train = "yes", spellId = 11665 },
    { name = "Immolate", level = 50, rank = 6, base_cost = 15000, icon = "Spell_Fire_Immolation", source = "trainer", train = "yes", spellId = 11667 },
    { name = "Immolate", level = 60, rank = 7, base_cost = 26000, icon = "Spell_Fire_Immolation", source = "trainer", train = "yes", spellId = 11668 },

    -- Life Tap
    { name = "Life Tap", level = 6, rank = 1, base_cost = 100, icon = "Spell_Shadow_BurningSpirit", source = "trainer", train = "yes", spellId = 1454 },
    { name = "Life Tap", level = 16, rank = 2, base_cost = 1200, icon = "Spell_Shadow_BurningSpirit", source = "trainer", train = "yes", spellId = 1455 },
    { name = "Life Tap", level = 26, rank = 3, base_cost = 4000, icon = "Spell_Shadow_BurningSpirit", source = "trainer", train = "yes", spellId = 1456 },
    { name = "Life Tap", level = 36, rank = 4, base_cost = 9000, icon = "Spell_Shadow_BurningSpirit", source = "trainer", train = "yes", spellId = 11687 },
    { name = "Life Tap", level = 46, rank = 5, base_cost = 13000, icon = "Spell_Shadow_BurningSpirit", source = "trainer", train = "yes", spellId = 11688 },
    { name = "Life Tap", level = 56, rank = 6, base_cost = 22000, icon = "Spell_Shadow_BurningSpirit", source = "trainer", train = "yes", spellId = 11689 },

    -- Rain of Fire
    { name = "Rain of Fire", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Shadow_RainOfFire", source = "trainer", train = "yes", spellId = 5740 },
    { name = "Rain of Fire", level = 34, rank = 2, base_cost = 8000, icon = "Spell_Shadow_RainOfFire", source = "trainer", train = "yes", spellId = 6219 },
    { name = "Rain of Fire", level = 46, rank = 3, base_cost = 13000, icon = "Spell_Shadow_RainOfFire", source = "trainer", train = "yes", spellId = 11677 },
    { name = "Rain of Fire", level = 58, rank = 4, base_cost = 24000, icon = "Spell_Shadow_RainOfFire", source = "trainer", train = "yes", spellId = 11678 },

    -- Ritual of Summoning
    { name = "Ritual of Summoning", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Shadow_Twilight", source = "trainer", train = "yes", spellId = 698 },

    -- Searing Pain
    { name = "Searing Pain", level = 18, rank = 1, base_cost = 1500, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 5676 },
    { name = "Searing Pain", level = 26, rank = 2, base_cost = 4000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 17919 },
    { name = "Searing Pain", level = 34, rank = 3, base_cost = 8000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 17920 },
    { name = "Searing Pain", level = 42, rank = 4, base_cost = 11000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 17921 },
    { name = "Searing Pain", level = 50, rank = 5, base_cost = 15000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 17922 },
    { name = "Searing Pain", level = 58, rank = 6, base_cost = 24000, icon = "Spell_Fire_SoulBurn", source = "trainer", train = "yes", spellId = 17923 },

    -- Sense Demons
    { name = "Sense Demons", level = 24, rank = 1, base_cost = 3000, icon = "Spell_Shadow_Metamorphosis", source = "trainer", train = "wait", spellId = 5500 },

    -- Shadow Bolt
    { name = "Shadow Bolt", level = 1, rank = 1, base_cost = 0, icon = "Spell_Shadow_ShadowBolt", source = "class", train = "yes", spellId = 686 },
    { name = "Shadow Bolt", level = 6, rank = 2, base_cost = 100, icon = "Spell_Shadow_ShadowBolt", source = "trainer", train = "yes", spellId = 695 },
    { name = "Shadow Bolt", level = 12, rank = 3, base_cost = 600, icon = "Spell_Shadow_ShadowBolt", source = "trainer", train = "yes", spellId = 705 },
    { name = "Shadow Bolt", level = 20, rank = 4, base_cost = 2000, icon = "Spell_Shadow_ShadowBolt", source = "trainer", train = "yes", spellId = 1088 },
    { name = "Shadow Bolt", level = 28, rank = 5, base_cost = 5000, icon = "Spell_Shadow_ShadowBolt", source = "trainer", train = "yes", spellId = 1106 },
    { name = "Shadow Bolt", level = 36, rank = 6, base_cost = 9000, icon = "Spell_Shadow_ShadowBolt", source = "trainer", train = "yes", spellId = 7641 },
    { name = "Shadow Bolt", level = 44, rank = 7, base_cost = 12000, icon = "Spell_Shadow_ShadowBolt", source = "trainer", train = "yes", spellId = 11659 },
    { name = "Shadow Bolt", level = 52, rank = 8, base_cost = 18000, icon = "Spell_Shadow_ShadowBolt", source = "trainer", train = "yes", spellId = 11660 },
    { name = "Shadow Bolt", level = 60, rank = 9, base_cost = 26000, icon = "Spell_Shadow_ShadowBolt", source = "trainer", train = "yes", spellId = 11661 },

    -- Shadow Ward
    { name = "Shadow Ward", level = 32, rank = 1, base_cost = 7000, icon = "Spell_Shadow_AntiShadow", source = "trainer", train = "yes", spellId = 6229 },
    { name = "Shadow Ward", level = 42, rank = 2, base_cost = 11000, icon = "Spell_Shadow_AntiShadow", source = "trainer", train = "yes", spellId = 11739 },
    { name = "Shadow Ward", level = 52, rank = 3, base_cost = 18000, icon = "Spell_Shadow_AntiShadow", source = "trainer", train = "yes", spellId = 11740 },

    -- Shadowburn (Destruction 21-point talent)
    { name = "Shadowburn", level = 20, rank = 1, base_cost = 0, icon = "Spell_Shadow_ScourgeBuild", source = "talent", train = "yes", spellId = 17877 },
    { name = "Shadowburn", level = 24, rank = 2, base_cost = 150, icon = "Spell_Shadow_ScourgeBuild", source = "talent", train = "yes", spellId = 18867 },
    { name = "Shadowburn", level = 32, rank = 3, base_cost = 350, icon = "Spell_Shadow_ScourgeBuild", source = "talent", train = "yes", spellId = 18868 },
    { name = "Shadowburn", level = 40, rank = 4, base_cost = 550, icon = "Spell_Shadow_ScourgeBuild", source = "talent", train = "yes", spellId = 18869 },
    { name = "Shadowburn", level = 48, rank = 5, base_cost = 700, icon = "Spell_Shadow_ScourgeBuild", source = "talent", train = "yes", spellId = 18870 },
    { name = "Shadowburn", level = 56, rank = 6, base_cost = 1100, icon = "Spell_Shadow_ScourgeBuild", source = "talent", train = "yes", spellId = 18871 },

    -- Siphon Life (Affliction 21-point talent)
    { name = "Siphon Life", level = 30, rank = 1, base_cost = 0, icon = "Spell_Shadow_Requiem", source = "talent", train = "yes", spellId = 18265 },
    { name = "Siphon Life", level = 38, rank = 2, base_cost = 500, icon = "Spell_Shadow_Requiem", source = "talent", train = "yes", spellId = 18879 },
    { name = "Siphon Life", level = 48, rank = 3, base_cost = 700, icon = "Spell_Shadow_Requiem", source = "talent", train = "yes", spellId = 18880 },
    { name = "Siphon Life", level = 58, rank = 4, base_cost = 1200, icon = "Spell_Shadow_Requiem", source = "talent", train = "yes", spellId = 18881 },

    -- Soul Fire
    { name = "Soul Fire", level = 48, rank = 1, base_cost = 14000, icon = "Spell_Fire_Fireball02", source = "trainer", train = "yes", spellId = 6353 },
    { name = "Soul Fire", level = 56, rank = 2, base_cost = 22000, icon = "Spell_Fire_Fireball02", source = "trainer", train = "yes", spellId = 17924 },

    -- Subjugate Demon
    { name = "Subjugate Demon", level = 30, rank = 1, base_cost = 6000, icon = "Spell_Shadow_EnslaveDemon", source = "trainer", train = "yes", spellId = 1098 },
    { name = "Subjugate Demon", level = 44, rank = 2, base_cost = 12000, icon = "Spell_Shadow_EnslaveDemon", source = "trainer", train = "yes", spellId = 11725 },
    { name = "Subjugate Demon", level = 58, rank = 3, base_cost = 24000, icon = "Spell_Shadow_EnslaveDemon", source = "trainer", train = "yes", spellId = 11726 },
    
    -- Summon Dreadsteed
    { name = "Summon Dreadsteed", level = 60, rank = 1, base_cost = 0, icon = "Ability_Mount_Dreadsteed", source = "quest", train = "yes", spellId = 23161 },
    
    -- Summon Felhunter
    { name = "Summon Felhunter", level = 30, rank = 1, base_cost = 0, icon = "Spell_Shadow_SummonFelHunter", source = "quest", train = "yes", spellId = 691 },

    -- Summon Felsteed
    { name = "Summon Felsteed", level = 40, rank = 1, base_cost = 0, icon = "Spell_Nature_Swiftness", source = "quest", train = "yes", spellId = 5784 },

    -- Summon Imp
    { name = "Summon Imp", level = 1, rank = 1, base_cost = 0, icon = "Spell_Shadow_SummonImp", source = "quest", train = "yes", spellId = 688 },

    -- Summon Succubus
    { name = "Summon Succubus", level = 20, rank = 1, base_cost = 0, icon = "Spell_Shadow_SummonSuccubus", source = "quest", train = "yes", spellId = 712 },

    -- Summon Voidwalker
    { name = "Summon Voidwalker", level = 10, rank = 1, base_cost = 0, icon = "Spell_Shadow_SummonVoidWalker", source = "quest", train = "yes", spellId = 697 },

    -- Unending Breath
    { name = "Unending Breath", level = 16, rank = 1, base_cost = 1200, icon = "Spell_Shadow_DemonBreath", source = "trainer", train = "yes", spellId = 5697 },
}
