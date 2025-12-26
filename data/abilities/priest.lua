local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- Cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
Deathless.Data.Abilities["Priest"] = {
    { name = "Smite", level = 1, rank = 1, cost = 10, icon = "Spell_Holy_HolySmite" },
    { name = "Lesser Heal", level = 1, rank = 1, cost = 10, icon = "Spell_Holy_LesserHeal" },
    { name = "Power Word: Fortitude", level = 1, rank = 1, cost = 10, icon = "Spell_Holy_WordFortitude" },
    { name = "Shadow Word: Pain", level = 4, rank = 1, cost = 100, icon = "Spell_Shadow_ShadowWordPain" },
    { name = "Renew", level = 8, rank = 1, cost = 200, icon = "Spell_Holy_Renew" },
}

