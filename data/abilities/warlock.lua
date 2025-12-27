local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source: trainer, talent, class, book, quest, racial
Deathless.Data.Abilities["Warlock"] = {
    { name = "Corruption", level = 4, rank = 1, base_cost = 100, icon = "Spell_Shadow_AbominationExplosion", source = "trainer" },
    { name = "Curse of Weakness", level = 4, rank = 1, base_cost = 100, icon = "Spell_Shadow_CurseOfMannoroth", source = "trainer" },
    { name = "Demon Skin", level = 1, rank = 1, base_cost = 10, icon = "Spell_Shadow_RagingScream", source = "trainer" },
    { name = "Immolate", level = 1, rank = 1, base_cost = 10, icon = "Spell_Fire_Immolation", source = "trainer" },
    { name = "Shadow Bolt", level = 1, rank = 1, base_cost = 10, icon = "Spell_Shadow_ShadowBolt", source = "trainer" },
}
