local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source types:
--   trainer - Learned from class trainer
--   talent  - Requires talent point (only shown if base talent is learned)
--   class   - Innate class ability (learned automatically)
--   book    - Learned from a drop/item
--   quest   - Learned from completing a quest
--   racial  - Racial ability
-- Train values:
--   yes   - Important ability, train all ranks
--   no    - Skip training (save gold)
--   wait  - Delay training, catch up later
--   maybe - Situational, depends on spec/playstyle
-- Sorted alphabetically by name, then by rank
-- See https://www.wowhead.com/classic/spells/abilities/paladin for source data
-- See https://www.wowhead.com/classic/class=2/paladin#trainers for training costs
Deathless.Data.Abilities["Paladin"] = {
    -- Blessing of Freedom
    { name = "Blessing of Freedom", level = 18, rank = 1, base_cost = 3500, icon = "Spell_Holy_SealOfValor", source = "trainer", train = "yes", spellId = 1044 },

    -- Blessing of Light
    { name = "Blessing of Light", level = 40, rank = 1, base_cost = 20000, icon = "Spell_Holy_PrayerOfHealing02", source = "trainer", train = "yes", spellId = 19977 },
    { name = "Blessing of Light", level = 50, rank = 2, base_cost = 28000, icon = "Spell_Holy_PrayerOfHealing02", source = "trainer", train = "yes", spellId = 19978 },
    { name = "Blessing of Light", level = 60, rank = 3, base_cost = 46000, icon = "Spell_Holy_PrayerOfHealing02", source = "trainer", train = "yes", spellId = 19979 },

    -- Blessing of Might
    { name = "Blessing of Might", level = 4, rank = 1, base_cost = 100, icon = "Spell_Holy_FistOfJustice", source = "trainer", train = "yes", spellId = 19740 },
    { name = "Blessing of Might", level = 12, rank = 2, base_cost = 1000, icon = "Spell_Holy_FistOfJustice", source = "trainer", train = "yes", spellId = 19834 },
    { name = "Blessing of Might", level = 22, rank = 3, base_cost = 4000, icon = "Spell_Holy_FistOfJustice", source = "trainer", train = "yes", spellId = 19835 },
    { name = "Blessing of Might", level = 32, rank = 4, base_cost = 12000, icon = "Spell_Holy_FistOfJustice", source = "trainer", train = "yes", spellId = 19836 },
    { name = "Blessing of Might", level = 42, rank = 5, base_cost = 21000, icon = "Spell_Holy_FistOfJustice", source = "trainer", train = "yes", spellId = 19837 },
    { name = "Blessing of Might", level = 52, rank = 6, base_cost = 34000, icon = "Spell_Holy_FistOfJustice", source = "trainer", train = "yes", spellId = 19838 },
    { name = "Blessing of Might", level = 60, rank = 7, base_cost = 0, icon = "Spell_Holy_FistOfJustice", source = "book", train = "yes", spellId = 25291 },

    -- Blessing of Protection
    { name = "Blessing of Protection", level = 10, rank = 1, base_cost = 300, icon = "Spell_Holy_SealOfProtection", source = "trainer", train = "yes", spellId = 1022 },
    { name = "Blessing of Protection", level = 24, rank = 2, base_cost = 5000, icon = "Spell_Holy_SealOfProtection", source = "trainer", train = "yes", spellId = 5599 },
    { name = "Blessing of Protection", level = 38, rank = 3, base_cost = 16000, icon = "Spell_Holy_SealOfProtection", source = "trainer", train = "yes", spellId = 10278 },

    -- Blessing of Sacrifice
    { name = "Blessing of Sacrifice", level = 46, rank = 1, base_cost = 24000, icon = "Spell_Holy_SealOfSacrifice", source = "trainer", train = "yes", spellId = 6940 },
    { name = "Blessing of Sacrifice", level = 54, rank = 2, base_cost = 40000, icon = "Spell_Holy_SealOfSacrifice", source = "trainer", train = "yes", spellId = 20729 },

    -- Blessing of Salvation
    { name = "Blessing of Salvation", level = 26, rank = 1, base_cost = 6000, icon = "Spell_Holy_SealOfSalvation", source = "trainer", train = "yes", spellId = 1038 },

    -- Blessing of Sanctuary (Protection talent)
    { name = "Blessing of Sanctuary", level = 30, rank = 1, base_cost = 0, icon = "Spell_Nature_LightningShield", source = "talent", train = "yes", spellId = 20911 },
    { name = "Blessing of Sanctuary", level = 40, rank = 2, base_cost = 900, icon = "Spell_Nature_LightningShield", source = "talent", train = "yes", spellId = 20912 },
    { name = "Blessing of Sanctuary", level = 50, rank = 3, base_cost = 1260, icon = "Spell_Nature_LightningShield", source = "talent", train = "yes", spellId = 20913 },
    { name = "Blessing of Sanctuary", level = 60, rank = 4, base_cost = 2070, icon = "Spell_Nature_LightningShield", source = "talent", train = "yes", spellId = 20914 },

    -- Blessing of Wisdom
    { name = "Blessing of Wisdom", level = 14, rank = 1, base_cost = 2000, icon = "Spell_Holy_SealOfWisdom", source = "trainer", train = "yes", spellId = 19742 },
    { name = "Blessing of Wisdom", level = 24, rank = 2, base_cost = 5000, icon = "Spell_Holy_SealOfWisdom", source = "trainer", train = "yes", spellId = 19850 },
    { name = "Blessing of Wisdom", level = 34, rank = 3, base_cost = 13000, icon = "Spell_Holy_SealOfWisdom", source = "trainer", train = "yes", spellId = 19852 },
    { name = "Blessing of Wisdom", level = 44, rank = 4, base_cost = 22000, icon = "Spell_Holy_SealOfWisdom", source = "trainer", train = "yes", spellId = 19853 },
    { name = "Blessing of Wisdom", level = 54, rank = 5, base_cost = 40000, icon = "Spell_Holy_SealOfWisdom", source = "trainer", train = "yes", spellId = 19854 },
    { name = "Blessing of Wisdom", level = 60, rank = 6, base_cost = 0, icon = "Spell_Holy_SealOfWisdom", source = "book", train = "yes", spellId = 25290 },

    -- Cleanse
    { name = "Cleanse", level = 42, rank = 1, base_cost = 21000, icon = "Spell_Holy_Purify", source = "trainer", train = "yes", spellId = 4987 },

    -- Concentration Aura
    { name = "Concentration Aura", level = 22, rank = 1, base_cost = 4000, icon = "Spell_Holy_MindSooth", source = "trainer", train = "yes", spellId = 19746 },

    -- Consecration (Holy talent)
    { name = "Consecration", level = 20, rank = 1, base_cost = 0, icon = "Spell_Holy_InnerFire", source = "talent", train = "yes", spellId = 26573 },
    { name = "Consecration", level = 30, rank = 2, base_cost = 200, icon = "Spell_Holy_InnerFire", source = "talent", train = "yes", spellId = 20116 },
    { name = "Consecration", level = 40, rank = 3, base_cost = 1000, icon = "Spell_Holy_InnerFire", source = "talent", train = "yes", spellId = 20922 },
    { name = "Consecration", level = 50, rank = 4, base_cost = 1400, icon = "Spell_Holy_InnerFire", source = "talent", train = "yes", spellId = 20923 },
    { name = "Consecration", level = 60, rank = 5, base_cost = 2300, icon = "Spell_Holy_InnerFire", source = "talent", train = "yes", spellId = 20924 },

    -- Devotion Aura
    { name = "Devotion Aura", level = 1, rank = 1, base_cost = 10, icon = "Spell_Holy_DevotionAura", source = "trainer", train = "yes", spellId = 465 },
    { name = "Devotion Aura", level = 10, rank = 2, base_cost = 300, icon = "Spell_Holy_DevotionAura", source = "trainer", train = "yes", spellId = 10290 },
    { name = "Devotion Aura", level = 20, rank = 3, base_cost = 4000, icon = "Spell_Holy_DevotionAura", source = "trainer", train = "yes", spellId = 643 },
    { name = "Devotion Aura", level = 30, rank = 4, base_cost = 11000, icon = "Spell_Holy_DevotionAura", source = "trainer", train = "yes", spellId = 10291 },
    { name = "Devotion Aura", level = 40, rank = 5, base_cost = 20000, icon = "Spell_Holy_DevotionAura", source = "trainer", train = "yes", spellId = 1032 },
    { name = "Devotion Aura", level = 50, rank = 6, base_cost = 28000, icon = "Spell_Holy_DevotionAura", source = "trainer", train = "yes", spellId = 10292 },
    { name = "Devotion Aura", level = 60, rank = 7, base_cost = 46000, icon = "Spell_Holy_DevotionAura", source = "trainer", train = "yes", spellId = 10293 },

    -- Divine Intervention
    { name = "Divine Intervention", level = 30, rank = 1, base_cost = 11000, icon = "Spell_Nature_TimeStop", source = "trainer", train = "no", spellId = 19752 },

    -- Divine Protection
    { name = "Divine Protection", level = 6, rank = 1, base_cost = 100, icon = "Spell_Holy_Restoration", source = "trainer", train = "yes", spellId = 498 },
    { name = "Divine Protection", level = 18, rank = 2, base_cost = 3500, icon = "Spell_Holy_Restoration", source = "trainer", train = "yes", spellId = 5573 },

    -- Divine Shield
    { name = "Divine Shield", level = 34, rank = 1, base_cost = 13000, icon = "Spell_Holy_DivineIntervention", source = "trainer", train = "yes", spellId = 642 },
    { name = "Divine Shield", level = 50, rank = 2, base_cost = 28000, icon = "Spell_Holy_DivineIntervention", source = "trainer", train = "yes", spellId = 1020 },

    -- Exorcism
    { name = "Exorcism", level = 20, rank = 1, base_cost = 4000, icon = "Spell_Holy_Excorcism_02", source = "trainer", train = "yes", spellId = 879 },
    { name = "Exorcism", level = 28, rank = 2, base_cost = 9000, icon = "Spell_Holy_Excorcism_02", source = "trainer", train = "yes", spellId = 5614 },
    { name = "Exorcism", level = 36, rank = 3, base_cost = 14000, icon = "Spell_Holy_Excorcism_02", source = "trainer", train = "yes", spellId = 5615 },
    { name = "Exorcism", level = 44, rank = 4, base_cost = 22000, icon = "Spell_Holy_Excorcism_02", source = "trainer", train = "yes", spellId = 10312 },
    { name = "Exorcism", level = 52, rank = 5, base_cost = 34000, icon = "Spell_Holy_Excorcism_02", source = "trainer", train = "yes", spellId = 10313 },
    { name = "Exorcism", level = 60, rank = 6, base_cost = 46000, icon = "Spell_Holy_Excorcism_02", source = "trainer", train = "yes", spellId = 10314 },

    -- Fire Resistance Aura
    { name = "Fire Resistance Aura", level = 36, rank = 1, base_cost = 14000, icon = "Spell_Fire_SealOfFire", source = "trainer", train = "yes", spellId = 19891 },
    { name = "Fire Resistance Aura", level = 48, rank = 2, base_cost = 26000, icon = "Spell_Fire_SealOfFire", source = "trainer", train = "yes", spellId = 19899 },
    { name = "Fire Resistance Aura", level = 60, rank = 3, base_cost = 46000, icon = "Spell_Fire_SealOfFire", source = "trainer", train = "yes", spellId = 19900 },

    -- Flash of Light
    { name = "Flash of Light", level = 20, rank = 1, base_cost = 4000, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "yes", spellId = 19750 },
    { name = "Flash of Light", level = 26, rank = 2, base_cost = 6000, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "yes", spellId = 19939 },
    { name = "Flash of Light", level = 34, rank = 3, base_cost = 13000, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "yes", spellId = 19940 },
    { name = "Flash of Light", level = 42, rank = 4, base_cost = 21000, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "yes", spellId = 19941 },
    { name = "Flash of Light", level = 50, rank = 5, base_cost = 28000, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "yes", spellId = 19942 },
    { name = "Flash of Light", level = 58, rank = 6, base_cost = 44000, icon = "Spell_Holy_FlashHeal", source = "trainer", train = "yes", spellId = 19943 },

    -- Frost Resistance Aura
    { name = "Frost Resistance Aura", level = 32, rank = 1, base_cost = 12000, icon = "Spell_Frost_WizardMark", source = "trainer", train = "yes", spellId = 19888 },
    { name = "Frost Resistance Aura", level = 44, rank = 2, base_cost = 22000, icon = "Spell_Frost_WizardMark", source = "trainer", train = "yes", spellId = 19897 },
    { name = "Frost Resistance Aura", level = 56, rank = 3, base_cost = 42000, icon = "Spell_Frost_WizardMark", source = "trainer", train = "yes", spellId = 19898 },

    -- Greater Blessing of Kings (Protection talent)
    { name = "Greater Blessing of Kings", level = 60, rank = 1, base_cost = 2300, icon = "Spell_Magic_MageArmor", source = "talent", train = "yes", spellId = 25898 },

    -- Greater Blessing of Light
    { name = "Greater Blessing of Light", level = 60, rank = 1, base_cost = 46000, icon = "Spell_Holy_GreaterBlessingofLight", source = "trainer", train = "yes", spellId = 25890 },

    -- Greater Blessing of Might
    { name = "Greater Blessing of Might", level = 52, rank = 1, base_cost = 46000, icon = "Spell_Holy_GreaterBlessingofKings", source = "trainer", train = "yes", spellId = 25782 },
    { name = "Greater Blessing of Might", level = 60, rank = 2, base_cost = 46000, icon = "Spell_Holy_GreaterBlessingofKings", source = "trainer", train = "yes", spellId = 25916 },

    -- Greater Blessing of Salvation
    { name = "Greater Blessing of Salvation", level = 60, rank = 1, base_cost = 46000, icon = "Spell_Holy_GreaterBlessingofSalvation", source = "trainer", train = "yes", spellId = 25895 },

    -- Greater Blessing of Sanctuary (Protection talent)
    { name = "Greater Blessing of Sanctuary", level = 60, rank = 1, base_cost = 2300, icon = "Spell_Holy_GreaterBlessingofSanctuary", source = "talent", train = "yes", spellId = 25899 },

    -- Greater Blessing of Wisdom
    { name = "Greater Blessing of Wisdom", level = 54, rank = 1, base_cost = 46000, icon = "Spell_Holy_GreaterBlessingofWisdom", source = "trainer", train = "yes", spellId = 25894 },
    { name = "Greater Blessing of Wisdom", level = 60, rank = 2, base_cost = 46000, icon = "Spell_Holy_GreaterBlessingofWisdom", source = "trainer", train = "yes", spellId = 25918 },

    -- Hammer of Justice
    { name = "Hammer of Justice", level = 8, rank = 1, base_cost = 100, icon = "Spell_Holy_SealOfMight", source = "trainer", train = "yes", spellId = 853 },
    { name = "Hammer of Justice", level = 24, rank = 2, base_cost = 5000, icon = "Spell_Holy_SealOfMight", source = "trainer", train = "yes", spellId = 5588 },
    { name = "Hammer of Justice", level = 40, rank = 3, base_cost = 20000, icon = "Spell_Holy_SealOfMight", source = "trainer", train = "yes", spellId = 5589 },
    { name = "Hammer of Justice", level = 54, rank = 4, base_cost = 40000, icon = "Spell_Holy_SealOfMight", source = "trainer", train = "yes", spellId = 10308 },

    -- Hammer of Wrath
    { name = "Hammer of Wrath", level = 44, rank = 1, base_cost = 22000, icon = "Ability_ThunderClap", source = "trainer", train = "yes", spellId = 24275 },
    { name = "Hammer of Wrath", level = 52, rank = 2, base_cost = 34000, icon = "Ability_ThunderClap", source = "trainer", train = "yes", spellId = 24274 },
    { name = "Hammer of Wrath", level = 60, rank = 3, base_cost = 46000, icon = "Ability_ThunderClap", source = "trainer", train = "yes", spellId = 24239 },

    -- Holy Light
    { name = "Holy Light", level = 1, rank = 1, base_cost = 0, icon = "Spell_Holy_HolyBolt", source = "class", train = "yes", spellId = 635 },
    { name = "Holy Light", level = 6, rank = 2, base_cost = 100, icon = "Spell_Holy_HolyBolt", source = "trainer", train = "yes", spellId = 639 },
    { name = "Holy Light", level = 14, rank = 3, base_cost = 2000, icon = "Spell_Holy_HolyBolt", source = "trainer", train = "yes", spellId = 647 },
    { name = "Holy Light", level = 22, rank = 4, base_cost = 4000, icon = "Spell_Holy_HolyBolt", source = "trainer", train = "yes", spellId = 1026 },
    { name = "Holy Light", level = 30, rank = 5, base_cost = 11000, icon = "Spell_Holy_HolyBolt", source = "trainer", train = "yes", spellId = 1042 },
    { name = "Holy Light", level = 38, rank = 6, base_cost = 16000, icon = "Spell_Holy_HolyBolt", source = "trainer", train = "yes", spellId = 3472 },
    { name = "Holy Light", level = 46, rank = 7, base_cost = 24000, icon = "Spell_Holy_HolyBolt", source = "trainer", train = "yes", spellId = 10328 },
    { name = "Holy Light", level = 54, rank = 8, base_cost = 40000, icon = "Spell_Holy_HolyBolt", source = "trainer", train = "yes", spellId = 10329 },
    { name = "Holy Light", level = 60, rank = 9, base_cost = 0, icon = "Spell_Holy_HolyBolt", source = "book", train = "yes", spellId = 25292 },

    -- Holy Shield (Protection 31-point talent)
    { name = "Holy Shield", level = 40, rank = 1, base_cost = 0, icon = "Spell_Holy_BlessingOfProtection", source = "talent", train = "yes", spellId = 20925 },
    { name = "Holy Shield", level = 50, rank = 2, base_cost = 1400, icon = "Spell_Holy_BlessingOfProtection", source = "talent", train = "yes", spellId = 20927 },
    { name = "Holy Shield", level = 60, rank = 3, base_cost = 2300, icon = "Spell_Holy_BlessingOfProtection", source = "talent", train = "yes", spellId = 20928 },

    -- Holy Shock (Holy 31-point talent)
    { name = "Holy Shock", level = 40, rank = 1, base_cost = 0, icon = "Spell_Holy_SearingLight", source = "talent", train = "yes", spellId = 20473 },
    { name = "Holy Shock", level = 48, rank = 2, base_cost = 1300, icon = "Spell_Holy_SearingLight", source = "talent", train = "yes", spellId = 20929 },
    { name = "Holy Shock", level = 56, rank = 3, base_cost = 2100, icon = "Spell_Holy_SearingLight", source = "talent", train = "yes", spellId = 20930 },

    -- Holy Wrath
    { name = "Holy Wrath", level = 50, rank = 1, base_cost = 28000, icon = "Spell_Holy_Excorcism", source = "trainer", train = "yes", spellId = 2812 },
    { name = "Holy Wrath", level = 60, rank = 2, base_cost = 46000, icon = "Spell_Holy_Excorcism", source = "trainer", train = "yes", spellId = 10318 },

    -- Judgement
    { name = "Judgement", level = 4, rank = 1, base_cost = 100, icon = "Spell_Holy_RighteousFury", source = "trainer", train = "yes", spellId = 20271 },

    -- Lay on Hands
    { name = "Lay on Hands", level = 10, rank = 1, base_cost = 300, icon = "Spell_Holy_LayOnHands", source = "trainer", train = "yes", spellId = 633 },
    { name = "Lay on Hands", level = 30, rank = 2, base_cost = 11000, icon = "Spell_Holy_LayOnHands", source = "trainer", train = "yes", spellId = 2800 },
    { name = "Lay on Hands", level = 50, rank = 3, base_cost = 28000, icon = "Spell_Holy_LayOnHands", source = "trainer", train = "yes", spellId = 10310 },

    -- Parry
    -- TODO: Not sure about this one? { name = "Parry", level = 8, rank = 1, base_cost = 100, icon = "Ability_Parry", source = "trainer", train = "yes", spellId = 3127 },

    -- Purify
    { name = "Purify", level = 8, rank = 1, base_cost = 100, icon = "Spell_Holy_Purify", source = "trainer", train = "yes", spellId = 1152 },

    -- Redemption
    { name = "Redemption", level = 12, rank = 1, base_cost = 0, icon = "Spell_Holy_Resurrection", source = "quest", train = "yes", spellId = 7328 },
    { name = "Redemption", level = 24, rank = 2, base_cost = 5000, icon = "Spell_Holy_Resurrection", source = "trainer", train = "no", spellId = 10322 },
    { name = "Redemption", level = 36, rank = 3, base_cost = 14000, icon = "Spell_Holy_Resurrection", source = "trainer", train = "no", spellId = 10324 },
    { name = "Redemption", level = 48, rank = 4, base_cost = 26000, icon = "Spell_Holy_Resurrection", source = "trainer", train = "no", spellId = 20772 },
    { name = "Redemption", level = 60, rank = 5, base_cost = 46000, icon = "Spell_Holy_Resurrection", source = "trainer", train = "no", spellId = 20773 },

    -- Repentance (Retribution 31-point talent)
    { name = "Repentance", level = 40, rank = 1, base_cost = 0, icon = "Spell_Holy_PrayerOfHealing", source = "talent", train = "yes", spellId = 20066 },

    -- Retribution Aura
    { name = "Retribution Aura", level = 16, rank = 1, base_cost = 3000, icon = "Spell_Holy_AuraOfLight", source = "trainer", train = "yes", spellId = 7294 },
    { name = "Retribution Aura", level = 26, rank = 2, base_cost = 6000, icon = "Spell_Holy_AuraOfLight", source = "trainer", train = "yes", spellId = 10298 },
    { name = "Retribution Aura", level = 36, rank = 3, base_cost = 14000, icon = "Spell_Holy_AuraOfLight", source = "trainer", train = "yes", spellId = 10299 },
    { name = "Retribution Aura", level = 46, rank = 4, base_cost = 24000, icon = "Spell_Holy_AuraOfLight", source = "trainer", train = "yes", spellId = 10300 },
    { name = "Retribution Aura", level = 56, rank = 5, base_cost = 42000, icon = "Spell_Holy_AuraOfLight", source = "trainer", train = "yes", spellId = 10301 },

    -- Righteous Fury
    { name = "Righteous Fury", level = 16, rank = 1, base_cost = 3000, icon = "Spell_Holy_SealOfFury", source = "trainer", train = "yes", spellId = 25780 },

    -- Seal of Command (Retribution 11-point talent)
    { name = "Seal of Command", level = 20, rank = 1, base_cost = 0, icon = "Ability_Warrior_InnerRage", source = "talent", train = "yes", spellId = 20375 },
    { name = "Seal of Command", level = 30, rank = 2, base_cost = 550, icon = "Ability_Warrior_InnerRage", source = "talent", train = "yes", spellId = 20915 },
    { name = "Seal of Command", level = 40, rank = 3, base_cost = 1000, icon = "Ability_Warrior_InnerRage", source = "talent", train = "yes", spellId = 20918 },
    { name = "Seal of Command", level = 50, rank = 4, base_cost = 1400, icon = "Ability_Warrior_InnerRage", source = "talent", train = "yes", spellId = 20919 },
    { name = "Seal of Command", level = 60, rank = 5, base_cost = 2300, icon = "Ability_Warrior_InnerRage", source = "talent", train = "yes", spellId = 20920 },

    -- Seal of Justice
    { name = "Seal of Justice", level = 22, rank = 1, base_cost = 4000, icon = "Spell_Holy_SealOfWrath", source = "trainer", train = "yes", spellId = 20164 },

    -- Seal of Light
    { name = "Seal of Light", level = 30, rank = 1, base_cost = 11000, icon = "Spell_Holy_HealingAura", source = "trainer", train = "yes", spellId = 20165 },
    { name = "Seal of Light", level = 40, rank = 2, base_cost = 20000, icon = "Spell_Holy_HealingAura", source = "trainer", train = "yes", spellId = 20347 },
    { name = "Seal of Light", level = 50, rank = 3, base_cost = 28000, icon = "Spell_Holy_HealingAura", source = "trainer", train = "yes", spellId = 20348 },
    { name = "Seal of Light", level = 60, rank = 4, base_cost = 46000, icon = "Spell_Holy_HealingAura", source = "trainer", train = "yes", spellId = 20349 },

    -- Seal of Righteousness
    { name = "Seal of Righteousness", level = 1, rank = 1, base_cost = 0, icon = "Ability_ThunderBolt", source = "class", train = "yes", spellId = 21084 },
    { name = "Seal of Righteousness", level = 10, rank = 2, base_cost = 300, icon = "Ability_ThunderBolt", source = "trainer", train = "yes", spellId = 20287 },
    { name = "Seal of Righteousness", level = 18, rank = 3, base_cost = 3500, icon = "Ability_ThunderBolt", source = "trainer", train = "yes", spellId = 20288 },
    { name = "Seal of Righteousness", level = 26, rank = 4, base_cost = 6000, icon = "Ability_ThunderBolt", source = "trainer", train = "yes", spellId = 20289 },
    { name = "Seal of Righteousness", level = 34, rank = 5, base_cost = 13000, icon = "Ability_ThunderBolt", source = "trainer", train = "yes", spellId = 20290 },
    { name = "Seal of Righteousness", level = 42, rank = 6, base_cost = 21000, icon = "Ability_ThunderBolt", source = "trainer", train = "yes", spellId = 20291 },
    { name = "Seal of Righteousness", level = 50, rank = 7, base_cost = 28000, icon = "Ability_ThunderBolt", source = "trainer", train = "yes", spellId = 20292 },
    { name = "Seal of Righteousness", level = 58, rank = 8, base_cost = 44000, icon = "Ability_ThunderBolt", source = "trainer", train = "yes", spellId = 20293 },

    -- Seal of the Crusader
    { name = "Seal of the Crusader", level = 6, rank = 1, base_cost = 100, icon = "Spell_Holy_HolySmite", source = "trainer", train = "yes", spellId = 21082 },
    { name = "Seal of the Crusader", level = 12, rank = 2, base_cost = 1000, icon = "Spell_Holy_HolySmite", source = "trainer", train = "yes", spellId = 20162 },
    { name = "Seal of the Crusader", level = 22, rank = 3, base_cost = 4000, icon = "Spell_Holy_HolySmite", source = "trainer", train = "yes", spellId = 20305 },
    { name = "Seal of the Crusader", level = 32, rank = 4, base_cost = 12000, icon = "Spell_Holy_HolySmite", source = "trainer", train = "yes", spellId = 20306 },
    { name = "Seal of the Crusader", level = 42, rank = 5, base_cost = 21000, icon = "Spell_Holy_HolySmite", source = "trainer", train = "yes", spellId = 20307 },
    { name = "Seal of the Crusader", level = 52, rank = 6, base_cost = 34000, icon = "Spell_Holy_HolySmite", source = "trainer", train = "yes", spellId = 20308 },

    -- Seal of Wisdom
    { name = "Seal of Wisdom", level = 38, rank = 1, base_cost = 16000, icon = "Spell_Holy_RighteousnessAura", source = "trainer", train = "yes", spellId = 20166 },
    { name = "Seal of Wisdom", level = 48, rank = 2, base_cost = 26000, icon = "Spell_Holy_RighteousnessAura", source = "trainer", train = "yes", spellId = 20356 },
    { name = "Seal of Wisdom", level = 58, rank = 3, base_cost = 44000, icon = "Spell_Holy_RighteousnessAura", source = "trainer", train = "yes", spellId = 20357 },

    -- Shadow Resistance Aura
    { name = "Shadow Resistance Aura", level = 28, rank = 1, base_cost = 9000, icon = "Spell_Shadow_SealOfKings", source = "trainer", train = "yes", spellId = 19876 },
    { name = "Shadow Resistance Aura", level = 40, rank = 2, base_cost = 20000, icon = "Spell_Shadow_SealOfKings", source = "trainer", train = "yes", spellId = 19895 },
    { name = "Shadow Resistance Aura", level = 52, rank = 3, base_cost = 34000, icon = "Spell_Shadow_SealOfKings", source = "trainer", train = "yes", spellId = 19896 },

    -- Summon Charger (Epic mount quest)
    { name = "Summon Charger", level = 60, rank = 1, base_cost = 0, icon = "Ability_Mount_Charger", source = "quest", train = "yes", spellId = 23214 },

    -- Summon Warhorse
    { name = "Summon Warhorse", level = 40, rank = 1, base_cost = 0, icon = "Spell_Nature_Swiftness", source = "trainer", train = "yes", spellId = 13819 },

    -- Turn Undead
    { name = "Turn Undead", level = 24, rank = 1, base_cost = 5000, icon = "Spell_Holy_TurnUndead", source = "trainer", train = "yes", spellId = 2878 },
    { name = "Turn Undead", level = 38, rank = 2, base_cost = 16000, icon = "Spell_Holy_TurnUndead", source = "trainer", train = "yes", spellId = 5627 },
    { name = "Turn Undead", level = 52, rank = 3, base_cost = 34000, icon = "Spell_Holy_TurnUndead", source = "trainer", train = "yes", spellId = 10326 },
}
