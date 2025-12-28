-- TODO: Add decent specs and images for each

local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

--- Priest talent builds for leveling and endgame
Deathless.Data.Talents.Priest = {
    {
        name = "Shadow Leveling",
        description = "Spirit Tap wanding build for efficient solo leveling.",
        image = nil,
        progression = {
            "10-14: Spirit Tap 5/5",
            "15-17: Imp. Shadow Word: Pain 2/2",
            "18-19: Shadow Focus 2/5",
            "20-22: Shadow Focus 5/5",
            "23-24: Imp. Psychic Scream 2/2",
            "25-29: Shadow Weaving 5/5",
            "30: Vampiric Embrace 1/1",
            "31-33: Imp. Vampiric Embrace 2/2",
            "34-35: Darkness 2/5",
            "36-39: Darkness 5/5",
            "40: Shadowform 1/1",
            "41-45: Wand Spec 5/5",
            "46-50: Meditation 5/5",
            "51-55: Mental Agility 5/5",
            "56-60: Mental Strength 5/5",
        },
        notes = "DoT, wand, collect Spirit Tap mana. Shadowform at 40 is a huge power spike. Keep PW:S for emergencies only.",
    },
    {
        name = "Holy Healer",
        description = "Dungeon and raid healing build.",
        image = nil,
        progression = {
            "10-11: Healing Focus 2/2",
            "12-14: Imp. Renew 3/3",
            "15-19: Holy Specialization 5/5",
            "20-24: Divine Fury 5/5",
            "25-27: Inspiration 3/3",
            "28-29: Spiritual Healing 2/5",
            "30: Spiritual Guidance 1/1",
            "31-33: Spiritual Healing 5/5",
            "34-35: Searing Light 2/2",
            "36-37: Imp. Heal 2/2",
            "38-40: Spirit of Redemption 1/1",
            "41-45: Meditation 5/5",
            "46-50: Mental Agility 5/5",
            "51-55: Mental Strength 5/5",
            "56-60: Wand Spec 5/5",
        },
        notes = "Flash Heal for emergencies, Heal for efficiency. Keep Renew rolling on tank. Downrank spells to save mana.",
    },
}

