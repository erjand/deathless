-- TODO: Add decent specs and images for each

local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

--- Rogue talent builds for leveling and endgame
Deathless.Data.Talents.Rogue = {
    {
        name = "Combat Swords",
        description = "Reliable leveling and dungeon DPS with sword spec.",
        image = nil,
        progression = {
            "10-11: Imp. Sinister Strike 2/2",
            "12-14: Lightning Reflexes 3/5",
            "15-16: Lightning Reflexes 5/5",
            "17-19: Precision 3/5",
            "20: Riposte 1/1",
            "21-22: Precision 5/5",
            "23-24: Endurance 2/2",
            "25-29: Dual Wield Spec 5/5",
            "30: Blade Flurry 1/1",
            "31-35: Sword Spec 5/5",
            "36-38: Aggression 3/3",
            "39-40: Adrenaline Rush 1/1",
            "41-45: Malice 5/5",
            "46-48: Ruthlessness 3/3",
            "49-50: Murder 2/2",
            "51-55: Lethality 5/5",
            "56-58: Imp. SnD 3/3",
            "59-60: Relentless Strikes 1/1",
        },
        notes = "Keep Slice and Dice up. Use Blade Flurry for multi-target. Evasion and Sprint are your defensives - use them early.",
    },
    {
        name = "Combat Daggers",
        description = "Backstab-focused build for high burst damage.",
        image = nil,
        progression = {
            "10-12: Imp. Backstab 3/3",
            "13-14: Lightning Reflexes 2/5",
            "15-17: Lightning Reflexes 5/5",
            "18-19: Precision 2/5",
            "20: Riposte 1/1",
            "21-23: Precision 5/5",
            "24: Endurance 1/2",
            "25-29: Dual Wield Spec 5/5",
            "30: Blade Flurry 1/1",
            "31-35: Dagger Spec 5/5",
            "36-38: Aggression 3/3",
            "39-40: Adrenaline Rush 1/1",
            "41-45: Malice 5/5",
            "46-48: Ruthlessness 3/3",
            "49-50: Murder 2/2",
            "51-55: Lethality 5/5",
            "56-60: Opportunity 5/5",
        },
        notes = "Open from stealth with Ambush or Cheap Shot. Position behind target for Backstab. Higher skill cap but big crits.",
    },
}

