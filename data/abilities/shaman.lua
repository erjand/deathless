local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- Cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
Deathless.Data.Abilities["Shaman"] = {
    { name = "Lightning Bolt", level = 1, rank = 1, cost = 10, icon = "Spell_Nature_Lightning" },
    { name = "Rockbiter Weapon", level = 1, rank = 1, cost = 10, icon = "Spell_Nature_RockBiter" },
    { name = "Earth Shock", level = 4, rank = 1, cost = 100, icon = "Spell_Nature_EarthShock" },
    { name = "Healing Wave", level = 1, rank = 1, cost = 10, icon = "Spell_Nature_MagicImmunity" },
    { name = "Stoneskin Totem", level = 4, rank = 1, cost = 100, icon = "Spell_Nature_StoneSkinTotem" },
}

