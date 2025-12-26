local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- Cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
Deathless.Data.Abilities["Warrior"] = {
    { name = "Battle Shout", level = 1, rank = 1, cost = 10, icon = "Ability_Warrior_BattleShout" },
    { name = "Charge", level = 4, rank = 1, cost = 100, icon = "Ability_Warrior_Charge" },
    { name = "Rend", level = 4, rank = 1, cost = 100, icon = "Ability_Gouge" },
    { name = "Thunder Clap", level = 6, rank = 1, cost = 100, icon = "Spell_Nature_ThunderClap" },
    { name = "Hamstring", level = 8, rank = 1, cost = 200, icon = "Ability_ShockWave" },
}

