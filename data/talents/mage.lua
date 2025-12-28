-- TODO: Add decent specs and images for each

local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

--- Mage talent builds for leveling and endgame
Deathless.Data.Talents.Mage = {
    {
        name = "Frost Leveling",
        description = "Safe leveling build with slows, roots, and shatter combos.",
        image = nil,
        progression = {
            "10-14: Imp. Frostbolt 5/5",
            "15-17: Frostbite 3/3",
            "18-19: Imp. Frost Nova 2/2",
            "20: Cold Snap 1/1",
            "21-23: Shatter 3/3",
            "24: Ice Block 1/1",
            "25-27: Piercing Ice 3/3",
            "28-29: Arctic Reach 2/2",
            "30: Ice Barrier 1/1",
            "31-34: Frost Channeling 4/5",
            "35-39: Winter's Chill 5/5",
            "40: Frost Channeling 5/5",
            "41-45: Arcane Focus 5/5",
            "46-50: Arcane Concentration 5/5",
            "51-55: Arcane Meditation 5/5",
            "56-60: Arcane Mind 5/5",
        },
        notes = "Frostbolt is your main nuke. Use Frost Nova + Blink to kite. Shatter combos for burst damage. Very safe for hardcore.",
    },
    {
        name = "AoE Frost",
        description = "Dungeon AoE grinding build for fast clears.",
        image = nil,
        progression = {
            "10-14: Imp. Frostbolt 5/5",
            "15-19: Ice Shards 5/5",
            "20-22: Shatter 3/3",
            "23-25: Permafrost 3/3",
            "26-28: Improved Blizzard 3/3",
            "29-30: Cold Snap 1/1",
            "31-32: Arctic Reach 2/2",
            "33-35: Frost Channeling 3/5",
            "36: Ice Barrier 1/1",
            "37-40: Ice Block 1/1",
            "41-45: Arcane Focus 5/5",
            "46-50: Arcane Concentration 5/5",
            "51-53: Imp. Arcane Explosion 3/3",
            "54-58: Arcane Meditation 5/5",
            "59-60: Arcane Mind 2/5",
        },
        notes = "Pull large packs, Frost Nova, Blizzard. Use Ice Block and Cold Snap as emergency buttons. Mana management is key.",
    },
}

