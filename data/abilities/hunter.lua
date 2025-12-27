local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source: trainer, talent, class, book, quest, racial
Deathless.Data.Abilities["Hunter"] = {
    { name = "Arcane Shot", level = 6, rank = 1, base_cost = 100, icon = "Ability_ImpalingBolt", source = "trainer" },
    { name = "Auto Shot", level = 1, rank = 1, base_cost = 0, icon = "Ability_Whirlwind", source = "class" },
    { name = "Hunter's Mark", level = 6, rank = 1, base_cost = 100, icon = "Ability_Hunter_SniperShot", source = "trainer" },
    { name = "Raptor Strike", level = 1, rank = 1, base_cost = 10, icon = "Ability_MeleeDamage", source = "trainer" },
    { name = "Serpent Sting", level = 4, rank = 1, base_cost = 100, icon = "Ability_Hunter_Quickshot", source = "trainer" },
}
