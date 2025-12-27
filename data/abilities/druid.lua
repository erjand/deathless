local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source: trainer, talent, class, book, quest, racial
Deathless.Data.Abilities["Druid"] = {
    { name = "Healing Touch", level = 1, rank = 1, base_cost = 10, icon = "Spell_Nature_HealingTouch", source = "trainer" },
    { name = "Mark of the Wild", level = 1, rank = 1, base_cost = 10, icon = "Spell_Nature_Regeneration", source = "trainer" },
    { name = "Moonfire", level = 4, rank = 1, base_cost = 100, icon = "Spell_Nature_StarFall", source = "trainer" },
    { name = "Rejuvenation", level = 4, rank = 1, base_cost = 100, icon = "Spell_Nature_Rejuvenation", source = "trainer" },
    { name = "Wrath", level = 1, rank = 1, base_cost = 10, icon = "Spell_Nature_AbolishMagic", source = "trainer" },
}
