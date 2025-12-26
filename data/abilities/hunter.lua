local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- Cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
Deathless.Data.Abilities["Hunter"] = {
    { name = "Auto Shot", level = 1, rank = 1, cost = 0, icon = "Ability_Whirlwind" },
    { name = "Raptor Strike", level = 1, rank = 1, cost = 10, icon = "Ability_MeleeDamage" },
    { name = "Serpent Sting", level = 4, rank = 1, cost = 100, icon = "Ability_Hunter_Quickshot" },
    { name = "Arcane Shot", level = 6, rank = 1, cost = 100, icon = "Ability_ImpalingBolt" },
    { name = "Hunter's Mark", level = 6, rank = 1, cost = 100, icon = "Ability_Hunter_SniperShot" },
}

