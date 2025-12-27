local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source: trainer, talent, class, book, quest, racial
Deathless.Data.Abilities["Shaman"] = {
    { name = "Earth Shock", level = 4, rank = 1, base_cost = 100, icon = "Spell_Nature_EarthShock", source = "trainer" },
    { name = "Healing Wave", level = 1, rank = 1, base_cost = 10, icon = "Spell_Nature_MagicImmunity", source = "trainer" },
    { name = "Lightning Bolt", level = 1, rank = 1, base_cost = 10, icon = "Spell_Nature_Lightning", source = "trainer" },
    { name = "Rockbiter Weapon", level = 1, rank = 1, base_cost = 10, icon = "Spell_Nature_RockBiter", source = "trainer" },
    { name = "Stoneskin Totem", level = 4, rank = 1, base_cost = 100, icon = "Spell_Nature_StoneSkinTotem", source = "trainer" },
}
