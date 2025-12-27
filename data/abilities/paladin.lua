local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source: trainer, talent, class, book, quest, racial
Deathless.Data.Abilities["Paladin"] = {
    { name = "Blessing of Might", level = 4, rank = 1, base_cost = 100, icon = "Spell_Holy_FistOfJustice", source = "trainer" },
    { name = "Divine Protection", level = 6, rank = 1, base_cost = 100, icon = "Spell_Holy_Restoration", source = "trainer" },
    { name = "Holy Light", level = 1, rank = 1, base_cost = 10, icon = "Spell_Holy_HolyBolt", source = "trainer" },
    { name = "Judgement", level = 4, rank = 1, base_cost = 100, icon = "Spell_Holy_RighteousFury", source = "trainer" },
    { name = "Seal of Righteousness", level = 1, rank = 1, base_cost = 10, icon = "Ability_ThunderBolt", source = "trainer" },
}
