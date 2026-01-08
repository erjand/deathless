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
-- See https://www.wowhead.com/classic/spells/abilities/hunter for source data
-- See https://www.wowhead.com/classic/npc=3407/adele-fielder for training costs
Deathless.Data.Abilities["Hunter"] = {
    -- Aimed Shot (Marksmanship 21-point talent)
    { name = "Aimed Shot", level = 20, rank = 1, base_cost = 0, icon = "INV_Spear_07", source = "talent", train = "yes", spellId = 19434 },
    { name = "Aimed Shot", level = 28, rank = 2, base_cost = 400, icon = "INV_Spear_07", source = "talent", train = "yes", spellId = 20900 },
    { name = "Aimed Shot", level = 36, rank = 3, base_cost = 700, icon = "INV_Spear_07", source = "talent", train = "yes", spellId = 20901 },
    { name = "Aimed Shot", level = 44, rank = 4, base_cost = 1300, icon = "INV_Spear_07", source = "talent", train = "yes", spellId = 20902 },
    { name = "Aimed Shot", level = 52, rank = 5, base_cost = 2000, icon = "INV_Spear_07", source = "talent", train = "yes", spellId = 20903 },
    { name = "Aimed Shot", level = 60, rank = 6, base_cost = 2500, icon = "INV_Spear_07", source = "talent", train = "yes", spellId = 20904 },
    
    -- Arcane Shot
    { name = "Arcane Shot", level = 6, rank = 1, base_cost = 100, icon = "Ability_ImpalingBolt", source = "trainer", train = "yes", spellId = 3044 },
    { name = "Arcane Shot", level = 12, rank = 2, base_cost = 600, icon = "Ability_ImpalingBolt", source = "trainer", train = "yes", spellId = 14281 },
    { name = "Arcane Shot", level = 20, rank = 3, base_cost = 2200, icon = "Ability_ImpalingBolt", source = "trainer", train = "yes", spellId = 14282 },
    { name = "Arcane Shot", level = 28, rank = 4, base_cost = 8000, icon = "Ability_ImpalingBolt", source = "trainer", train = "yes", spellId = 14283 },
    { name = "Arcane Shot", level = 36, rank = 5, base_cost = 14000, icon = "Ability_ImpalingBolt", source = "trainer", train = "yes", spellId = 14284 },
    { name = "Arcane Shot", level = 44, rank = 6, base_cost = 26000, icon = "Ability_ImpalingBolt", source = "trainer", train = "yes", spellId = 14285 },
    { name = "Arcane Shot", level = 52, rank = 7, base_cost = 40000, icon = "Ability_ImpalingBolt", source = "trainer", train = "yes", spellId = 14286 },
    { name = "Arcane Shot", level = 60, rank = 8, base_cost = 50000, icon = "Ability_ImpalingBolt", source = "trainer", train = "yes", spellId = 14287 },

    -- Aspect of the Beast
    { name = "Aspect of the Beast", level = 30, rank = 1, base_cost = 8000, icon = "Ability_Mount_PinkTiger", source = "trainer", train = "no", spellId = 13161 },

    -- Aspect of the Cheetah
    { name = "Aspect of the Cheetah", level = 20, rank = 1, base_cost = 2200, icon = "Ability_Mount_JungleTiger", source = "trainer", train = "yes", spellId = 5118 },

    -- Aspect of the Hawk
    { name = "Aspect of the Hawk", level = 10, rank = 1, base_cost = 400, icon = "Spell_Nature_RavenForm", source = "trainer", train = "yes", spellId = 13165 },
    { name = "Aspect of the Hawk", level = 18, rank = 2, base_cost = 2000, icon = "Spell_Nature_RavenForm", source = "trainer", train = "yes", spellId = 14318 },
    { name = "Aspect of the Hawk", level = 28, rank = 3, base_cost = 8000, icon = "Spell_Nature_RavenForm", source = "trainer", train = "yes", spellId = 14319 },
    { name = "Aspect of the Hawk", level = 38, rank = 4, base_cost = 16000, icon = "Spell_Nature_RavenForm", source = "trainer", train = "yes", spellId = 14320 },
    { name = "Aspect of the Hawk", level = 48, rank = 5, base_cost = 32000, icon = "Spell_Nature_RavenForm", source = "trainer", train = "yes", spellId = 14321 },
    { name = "Aspect of the Hawk", level = 58, rank = 6, base_cost = 48000, icon = "Spell_Nature_RavenForm", source = "trainer", train = "yes", spellId = 14322 },
    { name = "Aspect of the Hawk", level = 60, rank = 7, base_cost = 0, icon = "Spell_Nature_RavenForm", source = "book", train = "yes", spellId = 25296 },

    -- Aspect of the Monkey
    { name = "Aspect of the Monkey", level = 4, rank = 1, base_cost = 100, icon = "Ability_Hunter_AspectOfTheMonkey", source = "trainer", train = "yes", spellId = 13163 },

    -- Aspect of the Pack
    { name = "Aspect of the Pack", level = 40, rank = 1, base_cost = 18000, icon = "Ability_Mount_WhiteTiger", source = "trainer", train = "yes", spellId = 13159 },

    -- Aspect of the Wild
    { name = "Aspect of the Wild", level = 46, rank = 1, base_cost = 28000, icon = "Spell_Nature_ProtectionformNature", source = "trainer", train = "yes", spellId = 20043 },
    { name = "Aspect of the Wild", level = 56, rank = 2, base_cost = 46000, icon = "Spell_Nature_ProtectionformNature", source = "trainer", train = "yes", spellId = 20190 },

    -- Auto Shot
    { name = "Auto Shot", level = 1, rank = 1, base_cost = 0, icon = "Ability_Whirlwind", source = "class", train = "yes", spellId = 75 },

    -- Beast Lore
    { name = "Beast Lore", level = 24, rank = 1, base_cost = 7000, icon = "Ability_Physical_Taunt", source = "trainer", train = "maybe", spellId = 1462 },

    -- Call Pet
    { name = "Call Pet", level = 10, rank = 1, base_cost = 0, icon = "Ability_Hunter_BeastCall", source = "quest", train = "yes", spellId = 883 },

    -- Concussive Shot
    { name = "Concussive Shot", level = 8, rank = 1, base_cost = 200, icon = "Spell_Frost_Stun", source = "trainer", train = "yes", spellId = 5116 },

    -- Counterattack (Survival 21-point talent)
    { name = "Counterattack", level = 30, rank = 1, base_cost = 0, icon = "Ability_Warrior_Challange", source = "talent", train = "yes", spellId = 19306 },
    { name = "Counterattack", level = 42, rank = 2, base_cost = 1200, icon = "Ability_Warrior_Challange", source = "talent", train = "yes", spellId = 20909 },
    { name = "Counterattack", level = 54, rank = 3, base_cost = 2100, icon = "Ability_Warrior_Challange", source = "talent", train = "yes", spellId = 20910 },

    -- Dismiss Pet
    { name = "Dismiss Pet", level = 10, rank = 1, base_cost = 0, icon = "Spell_Nature_SpiritWolf", source = "quest", train = "yes", spellId = 2641 },

    -- Disengage
    { name = "Disengage", level = 20, rank = 1, base_cost = 2200, icon = "Ability_Rogue_Feint", source = "trainer", train = "yes", spellId = 781 },
    { name = "Disengage", level = 34, rank = 2, base_cost = 12000, icon = "Ability_Rogue_Feint", source = "trainer", train = "yes", spellId = 14272 },
    { name = "Disengage", level = 48, rank = 3, base_cost = 32000, icon = "Ability_Rogue_Feint", source = "trainer", train = "yes", spellId = 14273 },

    -- Distracting Shot
    { name = "Distracting Shot", level = 12, rank = 1, base_cost = 600, icon = "Spell_Arcane_Blink", source = "trainer", train = "yes", spellId = 20736 },
    { name = "Distracting Shot", level = 20, rank = 2, base_cost = 2200, icon = "Spell_Arcane_Blink", source = "trainer", train = "yes", spellId = 14274 },
    { name = "Distracting Shot", level = 30, rank = 3, base_cost = 8000, icon = "Spell_Arcane_Blink", source = "trainer", train = "yes", spellId = 15629 },
    { name = "Distracting Shot", level = 40, rank = 4, base_cost = 18000, icon = "Spell_Arcane_Blink", source = "trainer", train = "yes", spellId = 15630 },
    { name = "Distracting Shot", level = 50, rank = 5, base_cost = 36000, icon = "Spell_Arcane_Blink", source = "trainer", train = "yes", spellId = 15631 },
    { name = "Distracting Shot", level = 60, rank = 6, base_cost = 50000, icon = "Spell_Arcane_Blink", source = "trainer", train = "yes", spellId = 15632 },

    -- TODO: Verify the training cost
    -- Dual Wield
    { name = "Dual Wield", level = 20, rank = 1, base_cost = 2200, icon = "Ability_DualWield", source = "trainer", train = "yes", spellId = 674 },

    -- Eagle Eye
    { name = "Eagle Eye", level = 14, rank = 1, base_cost = 1200, icon = "Ability_Hunter_EagleEye", source = "trainer", train = "maybe", spellId = 6197 },

    -- Explosive Trap
    { name = "Explosive Trap", level = 34, rank = 1, base_cost = 12000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 13813 },
    { name = "Explosive Trap", level = 44, rank = 2, base_cost = 26000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 14316 },
    { name = "Explosive Trap", level = 54, rank = 3, base_cost = 42000, icon = "Spell_Fire_SelfDestruct", source = "trainer", train = "yes", spellId = 14317 },

    -- Eyes of the Beast
    { name = "Eyes of the Beast", level = 14, rank = 1, base_cost = 1200, icon = "Ability_EyeOfTheOwl", source = "trainer", train = "maybe", spellId = 1002 },

    -- Feed Pet
    { name = "Feed Pet", level = 10, rank = 1, base_cost = 0, icon = "Ability_Hunter_BeastTraining", source = "quest", train = "yes", spellId = 6991 },

    -- Feign Death
    { name = "Feign Death", level = 30, rank = 1, base_cost = 8000, icon = "Ability_Rogue_FeignDeath", source = "trainer", train = "yes", spellId = 5384 },

    -- Flare
    { name = "Flare", level = 32, rank = 1, base_cost = 10000, icon = "Spell_Fire_Flare", source = "trainer", train = "yes", spellId = 1543 },

    -- Freezing Trap
    { name = "Freezing Trap", level = 20, rank = 1, base_cost = 2200, icon = "Spell_Frost_ChainsOfIce", source = "trainer", train = "yes", spellId = 1499 },
    { name = "Freezing Trap", level = 40, rank = 2, base_cost = 18000, icon = "Spell_Frost_ChainsOfIce", source = "trainer", train = "yes", spellId = 14310 },
    { name = "Freezing Trap", level = 60, rank = 3, base_cost = 50000, icon = "Spell_Frost_ChainsOfIce", source = "trainer", train = "yes", spellId = 14311 },

    -- Frost Trap
    { name = "Frost Trap", level = 28, rank = 1, base_cost = 8000, icon = "Spell_Frost_FreezingBreath", source = "trainer", train = "yes", spellId = 13809 },

    -- Hunter's Mark
    { name = "Hunter's Mark", level = 6, rank = 1, base_cost = 100, icon = "Ability_Hunter_SniperShot", source = "trainer", train = "yes", spellId = 1130 },
    { name = "Hunter's Mark", level = 22, rank = 2, base_cost = 6000, icon = "Ability_Hunter_SniperShot", source = "trainer", train = "yes", spellId = 14323 },
    { name = "Hunter's Mark", level = 40, rank = 3, base_cost = 18000, icon = "Ability_Hunter_SniperShot", source = "trainer", train = "yes", spellId = 14324 },
    { name = "Hunter's Mark", level = 58, rank = 4, base_cost = 48000, icon = "Ability_Hunter_SniperShot", source = "trainer", train = "yes", spellId = 14325 },

    -- Immolation Trap
    { name = "Immolation Trap", level = 16, rank = 1, base_cost = 1800, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 13795 },
    { name = "Immolation Trap", level = 26, rank = 2, base_cost = 7000, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 14302 },
    { name = "Immolation Trap", level = 36, rank = 3, base_cost = 14000, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 14303 },
    { name = "Immolation Trap", level = 46, rank = 4, base_cost = 28000, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 14304 },
    { name = "Immolation Trap", level = 56, rank = 5, base_cost = 46000, icon = "Spell_Fire_FlameShock", source = "trainer", train = "yes", spellId = 14305 },

    -- Intimidation (Beast Mastery 21-point talent)
    { name = "Intimidation", level = 30, rank = 1, base_cost = 0, icon = "Ability_Devour", source = "talent", train = "yes", spellId = 19577 },

    -- Mail (armor proficiency)
    { name = "Mail", level = 40, rank = 1, base_cost = 18000, icon = "INV_Chest_Chain_05", source = "trainer", train = "yes", spellId = 8737 },

    -- Mend Pet
    { name = "Mend Pet", level = 12, rank = 1, base_cost = 600, icon = "Ability_Hunter_MendPet", source = "trainer", train = "yes", spellId = 136 },
    { name = "Mend Pet", level = 20, rank = 2, base_cost = 2200, icon = "Ability_Hunter_MendPet", source = "trainer", train = "yes", spellId = 3111 },
    { name = "Mend Pet", level = 28, rank = 3, base_cost = 8000, icon = "Ability_Hunter_MendPet", source = "trainer", train = "yes", spellId = 3661 },
    { name = "Mend Pet", level = 36, rank = 4, base_cost = 14000, icon = "Ability_Hunter_MendPet", source = "trainer", train = "yes", spellId = 3662 },
    { name = "Mend Pet", level = 44, rank = 5, base_cost = 26000, icon = "Ability_Hunter_MendPet", source = "trainer", train = "yes", spellId = 13542 },
    { name = "Mend Pet", level = 52, rank = 6, base_cost = 40000, icon = "Ability_Hunter_MendPet", source = "trainer", train = "yes", spellId = 13543 },
    { name = "Mend Pet", level = 60, rank = 7, base_cost = 50000, icon = "Ability_Hunter_MendPet", source = "trainer", train = "yes", spellId = 13544 },

    -- Mongoose Bite
    { name = "Mongoose Bite", level = 16, rank = 1, base_cost = 1800, icon = "Ability_Hunter_SwiftStrike", source = "trainer", train = "yes", spellId = 1495 },
    { name = "Mongoose Bite", level = 30, rank = 2, base_cost = 8000, icon = "Ability_Hunter_SwiftStrike", source = "trainer", train = "yes", spellId = 14269 },
    { name = "Mongoose Bite", level = 44, rank = 3, base_cost = 26000, icon = "Ability_Hunter_SwiftStrike", source = "trainer", train = "yes", spellId = 14270 },
    { name = "Mongoose Bite", level = 58, rank = 4, base_cost = 48000, icon = "Ability_Hunter_SwiftStrike", source = "trainer", train = "yes", spellId = 14271 },

    -- Multi-Shot
    { name = "Multi-Shot", level = 18, rank = 1, base_cost = 2000, icon = "Ability_UpgradeMoonGlaive", source = "trainer", train = "yes", spellId = 2643 },
    { name = "Multi-Shot", level = 30, rank = 2, base_cost = 8000, icon = "Ability_UpgradeMoonGlaive", source = "trainer", train = "yes", spellId = 14288 },
    { name = "Multi-Shot", level = 42, rank = 3, base_cost = 24000, icon = "Ability_UpgradeMoonGlaive", source = "trainer", train = "yes", spellId = 14289 },
    { name = "Multi-Shot", level = 54, rank = 4, base_cost = 42000, icon = "Ability_UpgradeMoonGlaive", source = "trainer", train = "yes", spellId = 14290 },
    { name = "Multi-Shot", level = 60, rank = 5, base_cost = 0, icon = "Ability_UpgradeMoonGlaive", source = "book", train = "yes", spellId = 25294 },

    -- TODO: Verify the training cost
    -- Parry
    { name = "Parry", level = 8, rank = 1, base_cost = 200, icon = "Ability_Parry", source = "trainer", train = "yes", spellId = 3127 },

    -- Rapid Fire
    { name = "Rapid Fire", level = 26, rank = 1, base_cost = 7000, icon = "Ability_Hunter_RunningShot", source = "trainer", train = "yes", spellId = 3045 },

    -- Raptor Strike
    { name = "Raptor Strike", level = 1, rank = 1, base_cost = 0, icon = "Ability_MeleeDamage", source = "class", train = "yes", spellId = 2973 },
    { name = "Raptor Strike", level = 8, rank = 2, base_cost = 200, icon = "Ability_MeleeDamage", source = "trainer", train = "yes", spellId = 14260 },
    { name = "Raptor Strike", level = 16, rank = 3, base_cost = 1800, icon = "Ability_MeleeDamage", source = "trainer", train = "yes", spellId = 14261 },
    { name = "Raptor Strike", level = 24, rank = 4, base_cost = 7000, icon = "Ability_MeleeDamage", source = "trainer", train = "yes", spellId = 14262 },
    { name = "Raptor Strike", level = 32, rank = 5, base_cost = 10000, icon = "Ability_MeleeDamage", source = "trainer", train = "yes", spellId = 14263 },
    { name = "Raptor Strike", level = 40, rank = 6, base_cost = 18000, icon = "Ability_MeleeDamage", source = "trainer", train = "yes", spellId = 14264 },
    { name = "Raptor Strike", level = 48, rank = 7, base_cost = 32000, icon = "Ability_MeleeDamage", source = "trainer", train = "yes", spellId = 14265 },
    { name = "Raptor Strike", level = 56, rank = 8, base_cost = 46000, icon = "Ability_MeleeDamage", source = "trainer", train = "yes", spellId = 14266 },

    -- Revive Pet
    { name = "Revive Pet", level = 10, rank = 1, base_cost = 0, icon = "Ability_Hunter_BeastSoothe", source = "quest", train = "yes", spellId = 982 },

    -- Scare Beast
    { name = "Scare Beast", level = 14, rank = 1, base_cost = 1200, icon = "Ability_Druid_Cower", source = "trainer", train = "yes", spellId = 1513 },
    { name = "Scare Beast", level = 30, rank = 2, base_cost = 8000, icon = "Ability_Druid_Cower", source = "trainer", train = "yes", spellId = 14326 },
    { name = "Scare Beast", level = 46, rank = 3, base_cost = 28000, icon = "Ability_Druid_Cower", source = "trainer", train = "yes", spellId = 14327 },

    -- Scorpid Sting
    { name = "Scorpid Sting", level = 22, rank = 1, base_cost = 6000, icon = "Ability_Hunter_CriticalShot", source = "trainer", train = "yes", spellId = 3043 },
    { name = "Scorpid Sting", level = 32, rank = 2, base_cost = 10000, icon = "Ability_Hunter_CriticalShot", source = "trainer", train = "yes", spellId = 14275 },
    { name = "Scorpid Sting", level = 42, rank = 3, base_cost = 24000, icon = "Ability_Hunter_CriticalShot", source = "trainer", train = "yes", spellId = 14276 },
    { name = "Scorpid Sting", level = 52, rank = 4, base_cost = 40000, icon = "Ability_Hunter_CriticalShot", source = "trainer", train = "yes", spellId = 14277 },

    -- Serpent Sting
    { name = "Serpent Sting", level = 4, rank = 1, base_cost = 100, icon = "Ability_Hunter_Quickshot", source = "trainer", train = "yes", spellId = 1978 },
    { name = "Serpent Sting", level = 10, rank = 2, base_cost = 400, icon = "Ability_Hunter_Quickshot", source = "trainer", train = "yes", spellId = 13549 },
    { name = "Serpent Sting", level = 18, rank = 3, base_cost = 2000, icon = "Ability_Hunter_Quickshot", source = "trainer", train = "yes", spellId = 13550 },
    { name = "Serpent Sting", level = 26, rank = 4, base_cost = 7000, icon = "Ability_Hunter_Quickshot", source = "trainer", train = "yes", spellId = 13551 },
    { name = "Serpent Sting", level = 34, rank = 5, base_cost = 12000, icon = "Ability_Hunter_Quickshot", source = "trainer", train = "yes", spellId = 13552 },
    { name = "Serpent Sting", level = 42, rank = 6, base_cost = 24000, icon = "Ability_Hunter_Quickshot", source = "trainer", train = "yes", spellId = 13553 },
    { name = "Serpent Sting", level = 50, rank = 7, base_cost = 36000, icon = "Ability_Hunter_Quickshot", source = "trainer", train = "yes", spellId = 13554 },
    { name = "Serpent Sting", level = 58, rank = 8, base_cost = 48000, icon = "Ability_Hunter_Quickshot", source = "trainer", train = "yes", spellId = 13555 },
    { name = "Serpent Sting", level = 60, rank = 9, base_cost = 0, icon = "Ability_Hunter_Quickshot", source = "book", train = "yes", spellId = 25295 },

    -- Tame Beast
    { name = "Tame Beast", level = 10, rank = 1, base_cost = 0, icon = "Ability_Hunter_BeastTaming", source = "quest", train = "yes", spellId = 1515 },

    -- Tracking
    { name = "Track Beasts", level = 1, rank = 1, base_cost = 10, icon = "Ability_Tracking", source = "trainer", train = "maybe", spellId = 1494 },
    { name = "Track Demons", level = 32, rank = 1, base_cost = 10000, icon = "Spell_Shadow_SummonFelHunter", source = "trainer", train = "maybe", spellId = 19878 },
    { name = "Track Dragonkin", level = 50, rank = 1, base_cost = 36000, icon = "INV_Misc_Head_Dragon_01", source = "trainer", train = "maybe", spellId = 19879 },
    { name = "Track Elementals", level = 26, rank = 1, base_cost = 7000, icon = "Spell_Frost_SummonWaterElemental", source = "trainer", train = "maybe", spellId = 19880 },
    { name = "Track Giants", level = 40, rank = 1, base_cost = 18000, icon = "Ability_Racial_Avatar", source = "trainer", train = "maybe", spellId = 19882 },
    { name = "Track Hidden", level = 24, rank = 1, base_cost = 7000, icon = "Ability_Stealth", source = "trainer", train = "maybe", spellId = 19885 },
    { name = "Track Humanoids", level = 10, rank = 1, base_cost = 400, icon = "Ability_Tracking", source = "trainer", train = "maybe", spellId = 19883 },
    { name = "Track Undead", level = 18, rank = 1, base_cost = 2000, icon = "Spell_Shadow_DarkSummoning", source = "trainer", train = "maybe", spellId = 19884 },

    -- Trueshot Aura (Marksmanship 31-point talent)
    { name = "Trueshot Aura", level = 40, rank = 1, base_cost = 0, icon = "Ability_TrueShot", source = "talent", train = "yes", spellId = 19506 },
    { name = "Trueshot Aura", level = 50, rank = 2, base_cost = 1800, icon = "Ability_TrueShot", source = "talent", train = "yes", spellId = 20905 },
    { name = "Trueshot Aura", level = 60, rank = 3, base_cost = 2500, icon = "Ability_TrueShot", source = "talent", train = "yes", spellId = 20906 },

    -- Viper Sting
    { name = "Viper Sting", level = 36, rank = 1, base_cost = 14000, icon = "Ability_Hunter_AimedShot", source = "trainer", train = "yes", spellId = 3034 },
    { name = "Viper Sting", level = 46, rank = 2, base_cost = 28000, icon = "Ability_Hunter_AimedShot", source = "trainer", train = "yes", spellId = 14279 },
    { name = "Viper Sting", level = 56, rank = 3, base_cost = 46000, icon = "Ability_Hunter_AimedShot", source = "trainer", train = "yes", spellId = 14280 },

    -- Volley
    { name = "Volley", level = 40, rank = 1, base_cost = 18000, icon = "Ability_Marksmanship", source = "trainer", train = "yes", spellId = 1510 },
    { name = "Volley", level = 50, rank = 2, base_cost = 36000, icon = "Ability_Marksmanship", source = "trainer", train = "yes", spellId = 14294 },
    { name = "Volley", level = 58, rank = 3, base_cost = 48000, icon = "Ability_Marksmanship", source = "trainer", train = "yes", spellId = 14295 },

    -- Wing Clip
    { name = "Wing Clip", level = 12, rank = 1, base_cost = 600, icon = "Ability_Rogue_Trip", source = "trainer", train = "yes", spellId = 2974 },
    { name = "Wing Clip", level = 38, rank = 2, base_cost = 16000, icon = "Ability_Rogue_Trip", source = "trainer", train = "yes", spellId = 14267 },
    { name = "Wing Clip", level = 60, rank = 3, base_cost = 50000, icon = "Ability_Rogue_Trip", source = "trainer", train = "yes", spellId = 14268 },

    -- Wyvern Sting (Survival 31-point talent)
    { name = "Wyvern Sting", level = 40, rank = 1, base_cost = 0, icon = "INV_Spear_02", source = "talent", train = "yes", spellId = 19386 },
    { name = "Wyvern Sting", level = 50, rank = 2, base_cost = 1800, icon = "INV_Spear_02", source = "talent", train = "yes", spellId = 24132 },
    { name = "Wyvern Sting", level = 60, rank = 3, base_cost = 2500, icon = "INV_Spear_02", source = "talent", train = "yes", spellId = 24133 },
}
