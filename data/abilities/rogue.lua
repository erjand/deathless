local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- Cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
Deathless.Data.Abilities["Rogue"] = {
    { name = "Sinister Strike", level = 1, rank = 1, cost = 10, icon = "Spell_Shadow_RitualOfSacrifice" },
    { name = "Eviscerate", level = 1, rank = 1, cost = 10, icon = "Ability_Rogue_Eviscerate" },
    { name = "Stealth", level = 1, rank = 1, cost = 10, icon = "Ability_Stealth" },
    { name = "Backstab", level = 4, rank = 1, cost = 100, icon = "Ability_BackStab" },
    { name = "Gouge", level = 6, rank = 1, cost = 100, icon = "Ability_Gouge" },
}

