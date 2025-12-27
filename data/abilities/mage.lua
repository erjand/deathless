local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source: trainer, talent, class, book, quest, racial
Deathless.Data.Abilities["Mage"] = {
    { name = "Conjure Water", level = 4, rank = 1, base_cost = 100, icon = "INV_Drink_07", source = "trainer" },
    { name = "Fire Blast", level = 6, rank = 1, base_cost = 100, icon = "Spell_Fire_Fireball", source = "trainer" },
    { name = "Fireball", level = 1, rank = 1, base_cost = 10, icon = "Spell_Fire_FlameBolt", source = "trainer" },
    { name = "Frost Armor", level = 1, rank = 1, base_cost = 10, icon = "Spell_Frost_FrostArmor", source = "trainer" },
    { name = "Frostbolt", level = 4, rank = 1, base_cost = 100, icon = "Spell_Frost_FrostBolt02", source = "trainer" },
}
