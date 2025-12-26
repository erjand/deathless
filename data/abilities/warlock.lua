local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- Cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
Deathless.Data.Abilities["Warlock"] = {
    { name = "Shadow Bolt", level = 1, rank = 1, cost = 10, icon = "Spell_Shadow_ShadowBolt" },
    { name = "Demon Skin", level = 1, rank = 1, cost = 10, icon = "Spell_Shadow_RagingScream" },
    { name = "Corruption", level = 4, rank = 1, cost = 100, icon = "Spell_Shadow_AbominationExplosion" },
    { name = "Curse of Weakness", level = 4, rank = 1, cost = 100, icon = "Spell_Shadow_CurseOfMannoroth" },
    { name = "Immolate", level = 1, rank = 1, cost = 10, icon = "Spell_Fire_Immolation" },
}

