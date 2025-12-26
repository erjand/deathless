local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- Cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
Deathless.Data.Abilities["Druid"] = {
    { name = "Wrath", level = 1, rank = 1, cost = 10, icon = "Spell_Nature_AbolishMagic" },
    { name = "Healing Touch", level = 1, rank = 1, cost = 10, icon = "Spell_Nature_HealingTouch" },
    { name = "Mark of the Wild", level = 1, rank = 1, cost = 10, icon = "Spell_Nature_Regeneration" },
    { name = "Moonfire", level = 4, rank = 1, cost = 100, icon = "Spell_Nature_StarFall" },
    { name = "Rejuvenation", level = 4, rank = 1, cost = 100, icon = "Spell_Nature_Rejuvenation" },
}

