local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source types:
--   trainer - Learned from class trainer
--   talent  - Requires 31-point talent (only shown if base talent is learned)
--   class   - Innate class ability (learned automatically)
--   book    - Learned from a drop/item
--   quest   - Learned from completing a quest
--   racial  - Racial ability
-- Sorted alphabetically by name, then by rank
Deathless.Data.Abilities["Warrior"] = {
    -- Battle Shout
    { name = "Battle Shout", level = 1, rank = 1, base_cost = 10, icon = "Ability_Warrior_BattleShout", source = "trainer" },
    { name = "Battle Shout", level = 12, rank = 2, base_cost = 1000, icon = "Ability_Warrior_BattleShout", source = "trainer" },
    { name = "Battle Shout", level = 22, rank = 3, base_cost = 6000, icon = "Ability_Warrior_BattleShout", source = "trainer" },
    { name = "Battle Shout", level = 32, rank = 4, base_cost = 14000, icon = "Ability_Warrior_BattleShout", source = "trainer" },
    { name = "Battle Shout", level = 42, rank = 5, base_cost = 32000, icon = "Ability_Warrior_BattleShout", source = "trainer" },
    { name = "Battle Shout", level = 52, rank = 6, base_cost = 54000, icon = "Ability_Warrior_BattleShout", source = "trainer" },
    { name = "Battle Shout", level = 60, rank = 7, base_cost = 0, icon = "Ability_Warrior_BattleShout", source = "book" },

    -- Battle Stance (innate)
    { name = "Battle Stance", level = 1, rank = 1, base_cost = 0, icon = "Ability_Warrior_OffensiveStance", source = "class" },

    -- Berserker Rage
    { name = "Berserker Rage", level = 32, rank = 1, base_cost = 14000, icon = "Spell_Nature_AncestralGuardian", source = "trainer" },

    -- Berserker Stance (quest at level 30)
    { name = "Berserker Stance", level = 30, rank = 1, base_cost = 0, icon = "Ability_Racial_Avatar", source = "quest" },

    -- Bloodrage
    { name = "Bloodrage", level = 10, rank = 1, base_cost = 600, icon = "Ability_Racial_BloodRage", source = "trainer" },

    -- Bloodthirst (Fury 31-point talent, requires talent to be learned)
    { name = "Bloodthirst", level = 40, rank = 1, base_cost = 0, icon = "Spell_Nature_BloodLust", source = "talent" },
    { name = "Bloodthirst", level = 48, rank = 2, base_cost = 2000, icon = "Spell_Nature_BloodLust", source = "talent" },
    { name = "Bloodthirst", level = 54, rank = 3, base_cost = 2800, icon = "Spell_Nature_BloodLust", source = "talent" },
    { name = "Bloodthirst", level = 60, rank = 4, base_cost = 3100, icon = "Spell_Nature_BloodLust", source = "talent" },

    -- Challenging Shout
    { name = "Challenging Shout", level = 26, rank = 1, base_cost = 10000, icon = "Ability_BullRush", source = "trainer" },

    -- Charge
    { name = "Charge", level = 4, rank = 1, base_cost = 100, icon = "Ability_Warrior_Charge", source = "trainer" },
    { name = "Charge", level = 26, rank = 2, base_cost = 10000, icon = "Ability_Warrior_Charge", source = "trainer" },
    { name = "Charge", level = 46, rank = 3, base_cost = 36000, icon = "Ability_Warrior_Charge", source = "trainer" },

    -- Cleave
    { name = "Cleave", level = 20, rank = 1, base_cost = 4600, icon = "Ability_Warrior_Cleave", source = "trainer" },
    { name = "Cleave", level = 30, rank = 2, base_cost = 12000, icon = "Ability_Warrior_Cleave", source = "trainer" },
    { name = "Cleave", level = 40, rank = 3, base_cost = 22000, icon = "Ability_Warrior_Cleave", source = "trainer" },
    { name = "Cleave", level = 50, rank = 4, base_cost = 42000, icon = "Ability_Warrior_Cleave", source = "trainer" },
    { name = "Cleave", level = 60, rank = 5, base_cost = 62000, icon = "Ability_Warrior_Cleave", source = "trainer" },

    -- Defensive Stance (quest at level 10)
    { name = "Defensive Stance", level = 10, rank = 1, base_cost = 0, icon = "Ability_Warrior_DefensiveStance", source = "quest" },

    -- Demoralizing Shout
    { name = "Demoralizing Shout", level = 14, rank = 1, base_cost = 1500, icon = "Ability_Warrior_WarCry", source = "trainer" },
    { name = "Demoralizing Shout", level = 24, rank = 2, base_cost = 8000, icon = "Ability_Warrior_WarCry", source = "trainer" },
    { name = "Demoralizing Shout", level = 34, rank = 3, base_cost = 16000, icon = "Ability_Warrior_WarCry", source = "trainer" },
    { name = "Demoralizing Shout", level = 44, rank = 4, base_cost = 34000, icon = "Ability_Warrior_WarCry", source = "trainer" },
    { name = "Demoralizing Shout", level = 54, rank = 5, base_cost = 56000, icon = "Ability_Warrior_WarCry", source = "trainer" },

    -- Disarm
    { name = "Disarm", level = 18, rank = 1, base_cost = 3000, icon = "Ability_Warrior_Disarm", source = "trainer" },

    -- Execute
    { name = "Execute", level = 24, rank = 1, base_cost = 8000, icon = "INV_Sword_48", source = "trainer" },
    { name = "Execute", level = 32, rank = 2, base_cost = 14000, icon = "INV_Sword_48", source = "trainer" },
    { name = "Execute", level = 40, rank = 3, base_cost = 22000, icon = "INV_Sword_48", source = "trainer" },
    { name = "Execute", level = 48, rank = 4, base_cost = 40000, icon = "INV_Sword_48", source = "trainer" },
    { name = "Execute", level = 56, rank = 5, base_cost = 58000, icon = "INV_Sword_48", source = "trainer" },

    -- Hamstring
    { name = "Hamstring", level = 8, rank = 1, base_cost = 2000, icon = "Ability_ShockWave", source = "trainer" },
    { name = "Hamstring", level = 32, rank = 2, base_cost = 14000, icon = "Ability_ShockWave", source = "trainer" },
    { name = "Hamstring", level = 54, rank = 3, base_cost = 56000, icon = "Ability_ShockWave", source = "trainer" },

    -- Heroic Strike
    { name = "Heroic Strike", level = 1, rank = 1, base_cost = 10, icon = "Ability_Rogue_Ambush", source = "trainer" },
    { name = "Heroic Strike", level = 8, rank = 2, base_cost = 200, icon = "Ability_Rogue_Ambush", source = "trainer" },
    { name = "Heroic Strike", level = 16, rank = 3, base_cost = 1200, icon = "Ability_Rogue_Ambush", source = "trainer" },
    { name = "Heroic Strike", level = 24, rank = 4, base_cost = 2400, icon = "Ability_Rogue_Ambush", source = "trainer" },
    { name = "Heroic Strike", level = 32, rank = 5, base_cost = 6000, icon = "Ability_Rogue_Ambush", source = "trainer" },
    { name = "Heroic Strike", level = 40, rank = 6, base_cost = 12000, icon = "Ability_Rogue_Ambush", source = "trainer" },
    { name = "Heroic Strike", level = 48, rank = 7, base_cost = 22000, icon = "Ability_Rogue_Ambush", source = "trainer" },
    { name = "Heroic Strike", level = 56, rank = 8, base_cost = 32000, icon = "Ability_Rogue_Ambush", source = "trainer" },

    -- Intercept
    { name = "Intercept", level = 30, rank = 1, base_cost = 0, icon = "Ability_Rogue_Sprint", source = "quest" },
    { name = "Intercept", level = 42, rank = 2, base_cost = 32000, icon = "Ability_Rogue_Sprint", source = "trainer" },
    { name = "Intercept", level = 52, rank = 3, base_cost = 54000, icon = "Ability_Rogue_Sprint", source = "trainer" },

    -- Intimidating Shout
    { name = "Intimidating Shout", level = 22, rank = 1, base_cost = 6000, icon = "Ability_GolemThunderClap", source = "trainer" },

    -- Mocking Blow
    { name = "Mocking Blow", level = 16, rank = 1, base_cost = 2000, icon = "Ability_Warrior_PunishingBlow", source = "trainer" },
    { name = "Mocking Blow", level = 26, rank = 2, base_cost = 10000, icon = "Ability_Warrior_PunishingBlow", source = "trainer" },
    { name = "Mocking Blow", level = 36, rank = 3, base_cost = 18000, icon = "Ability_Warrior_PunishingBlow", source = "trainer" },
    { name = "Mocking Blow", level = 46, rank = 4, base_cost = 36000, icon = "Ability_Warrior_PunishingBlow", source = "trainer" },
    { name = "Mocking Blow", level = 56, rank = 5, base_cost = 58000, icon = "Ability_Warrior_PunishingBlow", source = "trainer" },

    -- Mortal Strike (Arms 31-point talent, requires talent to be learned)
    { name = "Mortal Strike", level = 40, rank = 1, base_cost = 0, icon = "Ability_Warrior_SavageBlow", source = "talent" },
    { name = "Mortal Strike", level = 48, rank = 2, base_cost = 2000, icon = "Ability_Warrior_SavageBlow", source = "talent" },
    { name = "Mortal Strike", level = 54, rank = 3, base_cost = 2800, icon = "Ability_Warrior_SavageBlow", source = "talent" },
    { name = "Mortal Strike", level = 60, rank = 4, base_cost = 3100, icon = "Ability_Warrior_SavageBlow", source = "talent" },

    -- Overpower
    { name = "Overpower", level = 12, rank = 1, base_cost = 1000, icon = "Ability_MeleeDamage", source = "trainer" },
    { name = "Overpower", level = 28, rank = 2, base_cost = 11000, icon = "Ability_MeleeDamage", source = "trainer" },
    { name = "Overpower", level = 44, rank = 3, base_cost = 34000, icon = "Ability_MeleeDamage", source = "trainer" },
    { name = "Overpower", level = 60, rank = 4, base_cost = 62000, icon = "Ability_MeleeDamage", source = "trainer" },

    -- Pummel
    { name = "Pummel", level = 38, rank = 1, base_cost = 20000, icon = "INV_Gauntlets_04", source = "trainer" },
    { name = "Pummel", level = 58, rank = 2, base_cost = 60000, icon = "INV_Gauntlets_04", source = "trainer" },

    -- Recklessness
    { name = "Recklessness", level = 50, rank = 1, base_cost = 42000, icon = "Ability_CriticalStrike", source = "trainer" },

    -- Rend
    { name = "Rend", level = 4, rank = 1, base_cost = 100, icon = "Ability_Gouge", source = "trainer" },
    { name = "Rend", level = 10, rank = 2, base_cost = 600, icon = "Ability_Gouge", source = "trainer" },
    { name = "Rend", level = 20, rank = 3, base_cost = 4000, icon = "Ability_Gouge", source = "trainer" },
    { name = "Rend", level = 30, rank = 4, base_cost = 12000, icon = "Ability_Gouge", source = "trainer" },
    { name = "Rend", level = 40, rank = 5, base_cost = 22000, icon = "Ability_Gouge", source = "trainer" },
    { name = "Rend", level = 50, rank = 6, base_cost = 42000, icon = "Ability_Gouge", source = "trainer" },
    { name = "Rend", level = 60, rank = 7, base_cost = 62000, icon = "Ability_Gouge", source = "trainer" },

    -- Retaliation
    { name = "Retaliation", level = 20, rank = 1, base_cost = 4000, icon = "Ability_Warrior_Challange", source = "trainer" },

    -- Revenge
    { name = "Revenge", level = 14, rank = 1, base_cost = 1500, icon = "Ability_Warrior_Revenge", source = "trainer" },
    { name = "Revenge", level = 24, rank = 2, base_cost = 8000, icon = "Ability_Warrior_Revenge", source = "trainer" },
    { name = "Revenge", level = 34, rank = 3, base_cost = 16000, icon = "Ability_Warrior_Revenge", source = "trainer" },
    { name = "Revenge", level = 44, rank = 4, base_cost = 34000, icon = "Ability_Warrior_Revenge", source = "trainer" },
    { name = "Revenge", level = 54, rank = 5, base_cost = 56000, icon = "Ability_Warrior_Revenge", source = "trainer" },

    -- Shield Bash
    { name = "Shield Bash", level = 12, rank = 1, base_cost = 1000, icon = "Ability_Warrior_ShieldBash", source = "trainer" },
    { name = "Shield Bash", level = 32, rank = 2, base_cost = 14000, icon = "Ability_Warrior_ShieldBash", source = "trainer" },
    { name = "Shield Bash", level = 52, rank = 3, base_cost = 54000, icon = "Ability_Warrior_ShieldBash", source = "trainer" },

    -- Shield Block
    { name = "Shield Block", level = 16, rank = 1, base_cost = 2000, icon = "Ability_Defend", source = "trainer" },

    -- Shield Slam (Protection 31-point talent, requires talent to be learned)
    { name = "Shield Slam", level = 40, rank = 1, base_cost = 0, icon = "INV_Shield_05", source = "talent" },
    { name = "Shield Slam", level = 48, rank = 2, base_cost = 2000, icon = "INV_Shield_05", source = "talent" },
    { name = "Shield Slam", level = 54, rank = 3, base_cost = 2800, icon = "INV_Shield_05", source = "talent" },
    { name = "Shield Slam", level = 60, rank = 4, base_cost = 3100, icon = "INV_Shield_05", source = "talent" },

    -- Shield Wall
    { name = "Shield Wall", level = 28, rank = 1, base_cost = 11000, icon = "Ability_Warrior_ShieldWall", source = "trainer" },

    -- Slam
    { name = "Slam", level = 30, rank = 1, base_cost = 12000, icon = "Ability_Warrior_DecisiveStrike", source = "trainer" },
    { name = "Slam", level = 38, rank = 2, base_cost = 20000, icon = "Ability_Warrior_DecisiveStrike", source = "trainer" },
    { name = "Slam", level = 46, rank = 3, base_cost = 36000, icon = "Ability_Warrior_DecisiveStrike", source = "trainer" },
    { name = "Slam", level = 54, rank = 4, base_cost = 56000, icon = "Ability_Warrior_DecisiveStrike", source = "trainer" },

    -- Sunder Armor
    { name = "Sunder Armor", level = 10, rank = 1, base_cost = 0, icon = "Ability_Warrior_Sunder", source = "quest" },
    { name = "Sunder Armor", level = 22, rank = 2, base_cost = 6000, icon = "Ability_Warrior_Sunder", source = "trainer" },
    { name = "Sunder Armor", level = 34, rank = 3, base_cost = 16000, icon = "Ability_Warrior_Sunder", source = "trainer" },
    { name = "Sunder Armor", level = 46, rank = 4, base_cost = 36000, icon = "Ability_Warrior_Sunder", source = "trainer" },
    { name = "Sunder Armor", level = 58, rank = 5, base_cost = 60000, icon = "Ability_Warrior_Sunder", source = "trainer" },

    -- Taunt
    { name = "Taunt", level = 10, rank = 1, base_cost = 0, icon = "Spell_Nature_Reincarnation", source = "quest" },

    -- Thunder Clap
    { name = "Thunder Clap", level = 6, rank = 1, base_cost = 100, icon = "Spell_Nature_ThunderClap", source = "trainer" },
    { name = "Thunder Clap", level = 18, rank = 2, base_cost = 3000, icon = "Spell_Nature_ThunderClap", source = "trainer" },
    { name = "Thunder Clap", level = 28, rank = 3, base_cost = 11000, icon = "Spell_Nature_ThunderClap", source = "trainer" },
    { name = "Thunder Clap", level = 38, rank = 4, base_cost = 20000, icon = "Spell_Nature_ThunderClap", source = "trainer" },
    { name = "Thunder Clap", level = 48, rank = 5, base_cost = 40000, icon = "Spell_Nature_ThunderClap", source = "trainer" },
    { name = "Thunder Clap", level = 58, rank = 6, base_cost = 60000, icon = "Spell_Nature_ThunderClap", source = "trainer" },

    -- Whirlwind
    { name = "Whirlwind", level = 36, rank = 1, base_cost = 18000, icon = "Ability_Whirlwind", source = "trainer" },
}
