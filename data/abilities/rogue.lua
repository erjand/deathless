local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source: trainer, talent, class, book, quest, racial
Deathless.Data.Abilities["Rogue"] = {
    { name = "Backstab", level = 4, rank = 1, base_cost = 100, icon = "Ability_BackStab", source = "trainer" },
    { name = "Eviscerate", level = 1, rank = 1, base_cost = 10, icon = "Ability_Rogue_Eviscerate", source = "trainer" },
    { name = "Gouge", level = 6, rank = 1, base_cost = 100, icon = "Ability_Gouge", source = "trainer" },
    { name = "Sinister Strike", level = 1, rank = 1, base_cost = 10, icon = "Spell_Shadow_RitualOfSacrifice", source = "trainer" },
    { name = "Stealth", level = 1, rank = 1, base_cost = 10, icon = "Ability_Stealth", source = "trainer" },
}
