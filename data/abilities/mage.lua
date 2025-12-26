local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- Cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
Deathless.Data.Abilities["Mage"] = {
    { name = "Fireball", level = 1, rank = 1, cost = 10, icon = "Spell_Fire_FlameBolt" },
    { name = "Frost Armor", level = 1, rank = 1, cost = 10, icon = "Spell_Frost_FrostArmor" },
    { name = "Frostbolt", level = 4, rank = 1, cost = 100, icon = "Spell_Frost_FrostBolt02" },
    { name = "Conjure Water", level = 4, rank = 1, cost = 100, icon = "INV_Drink_07" },
    { name = "Fire Blast", level = 6, rank = 1, cost = 100, icon = "Spell_Fire_Fireball" },
}

