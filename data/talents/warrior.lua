-- TODO: Add decent specs and images for each

local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

--- Warrior talent builds for leveling and endgame
Deathless.Data.Talents.Warrior = {
    {
        name = "Arms Leveling",
        description = "Classic arms leveling build focusing on big two-hander crits and survivability.",
        image = nil, -- Placeholder: will be "Interface\\AddOns\\Deathless\\images\\warrior_arms"
        progression = {
            "10-14: Deflection 5/5",
            "15-17: Tactical Mastery 3/3",
            "18-19: Anger Management 1/1",
            "20-22: Deep Wounds 3/3",
            "23-24: Impale 2/2",
            "25-29: 2H Weapon Spec 5/5",
            "30: Sweeping Strikes 1/1",
            "31-32: Imp. Hamstring 2/3",
            "33-35: Poleaxe Spec 3/5",
            "36-39: Axe Spec 4/5 or Sword",
            "40: Mortal Strike 1/1",
            "41-45: Cruelty 5/5",
            "46-50: Unbridled Wrath 5/5",
            "51-55: Enrage 5/5",
            "56-60: Flurry 5/5",
        },
        notes = "Use Sweeping Strikes + Whirlwind for AoE. Keep Rend up on mobs. Mortal Strike is your execute-phase finisher. Works well with big slow two-handers like Whirlwind Axe.",
    },
    {
        name = "Fury Leveling",
        description = "Dual-wield fury build for fast kills and consistent damage.",
        image = nil, -- Placeholder
        progression = {
            "10-14: Cruelty 5/5",
            "15-19: Unbridled Wrath 5/5",
            "20: Piercing Howl 1/1",
            "21-25: Enrage 5/5",
            "26-29: Flurry 4/5",
            "30: Flurry 5/5, Bloodthirst",
            "31-35: DW Spec 5/5",
            "36-40: Deflection 5/5",
            "41-43: Tactical Mastery 3/3",
            "44: Anger Management 1/1",
            "45-47: Deep Wounds 3/3",
            "48-49: Impale 2/2",
            "50-54: 2H Weapon Spec 5/5",
            "55-59: Iron Will 5/5",
            "60: Sweeping Strikes 1/1",
        },
        notes = "Bloodthirst every 6 seconds. Keep Hamstring on runners. Dual wield is gear-dependent - switch to 2H if you lack hit rating. Piercing Howl is great for escaping bad pulls.",
    },
    {
        name = "Prot Dungeon Tank",
        description = "Protection build for tanking dungeons at 60.",
        image = nil, -- Placeholder
        progression = {
            "10-14: Shield Spec 5/5",
            "15-19: Anticipation 5/5",
            "20-22: Imp. Revenge 3/3",
            "23-24: Toughness 2/5",
            "25-27: Last Stand, Imp. SB 2/3",
            "28-29: Imp. SB 3/3, Defiance 1/5",
            "30-34: Defiance 5/5",
            "35-39: 1H Weapon Spec 5/5",
            "40: Shield Slam 1/1",
            "41-45: Cruelty 5/5",
            "46-50: Unbridled Wrath 5/5",
            "51-53: Imp. Battle Shout 3/5",
            "54-58: Deflection 5/5",
            "59-60: Imp. Heroic Strike 2/3",
        },
        notes = "Shield Slam is your main threat tool. Use Revenge on cooldown. Swap to Berserker Stance for Intercept when needed. Bring plenty of consumables for harder content.",
    },
}

