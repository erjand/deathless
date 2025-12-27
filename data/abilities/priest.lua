local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source: trainer, talent, class, book, quest, racial
Deathless.Data.Abilities["Priest"] = {
    { name = "Lesser Heal", level = 1, rank = 1, base_cost = 10, icon = "Spell_Holy_LesserHeal", source = "trainer" },
    { name = "Power Word: Fortitude", level = 1, rank = 1, base_cost = 10, icon = "Spell_Holy_WordFortitude", source = "trainer" },
    { name = "Renew", level = 8, rank = 1, base_cost = 200, icon = "Spell_Holy_Renew", source = "trainer" },
    { name = "Shadow Word: Pain", level = 4, rank = 1, base_cost = 100, icon = "Spell_Shadow_ShadowWordPain", source = "trainer" },
    { name = "Smite", level = 1, rank = 1, base_cost = 10, icon = "Spell_Holy_HolySmite", source = "trainer" },
}
