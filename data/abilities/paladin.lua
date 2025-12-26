local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- Cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
Deathless.Data.Abilities["Paladin"] = {
    { name = "Holy Light", level = 1, rank = 1, cost = 10, icon = "Spell_Holy_HolyBolt" },
    { name = "Seal of Righteousness", level = 1, rank = 1, cost = 10, icon = "Ability_ThunderBolt" },
    { name = "Blessing of Might", level = 4, rank = 1, cost = 100, icon = "Spell_Holy_FistOfJustice" },
    { name = "Judgement", level = 4, rank = 1, cost = 100, icon = "Spell_Holy_RighteousFury" },
    { name = "Divine Protection", level = 6, rank = 1, cost = 100, icon = "Spell_Holy_Restoration" },
}

