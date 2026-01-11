local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

-- Priest talent builds for Hardcore leveling
Deathless.Data.Talents.Priest = {
    {
        name = "Discipline / Holy (26/19/5)",
        description = "Strong leveling and dungeon healing build.",
        progression = {
            { 
                levels = "10-14", talent = "Wand Specialization", points = "5/5", spellId = 14528,
                ranks = {
                    { level = 10, spellId = 14524 },
                    { level = 11, spellId = 14525 },
                    { level = 12, spellId = 14526 },
                    { level = 13, spellId = 14527 },
                    { level = 14, spellId = 14528 },
                }
            },
            { 
                levels = "15-19", talent = "Spirit Tap", points = "5/5", spellId = 15338,
                ranks = {
                    { level = 15, spellId = 15270 },
                    { level = 16, spellId = 15335 },
                    { level = 17, spellId = 15336 },
                    { level = 18, spellId = 15337 },
                    { level = 19, spellId = 15338 },
                }
            },
            { 
                levels = "20-22", talent = "Imp. Power Word: Shield", points = "3/3", spellId = 14769,
                ranks = {
                    { level = 20, spellId = 14748 },
                    { level = 21, spellId = 14768 },
                    { level = 22, spellId = 14769 },
                }
            },
            { 
                levels = "23-24", talent = "Imp. Power Word: Fortitude", points = "2/2", spellId = 14767,
                ranks = {
                    { level = 23, spellId = 14749 },
                    { level = 24, spellId = 14767 },
                }
            },
            { 
                levels = "25-27", talent = "Meditation", points = "3/3", spellId = 14777,
                ranks = {
                    { level = 25, spellId = 14521 },
                    { level = 26, spellId = 14776 },
                    { level = 27, spellId = 14777 },
                }
            },
            { 
                levels = "28-32", talent = "Holy Specialization", points = "5/5", spellId = 15011,
                ranks = {
                    { level = 28, spellId = 14889 },
                    { level = 29, spellId = 15008 },
                    { level = 30, spellId = 15009 },
                    { level = 31, spellId = 15010 },
                    { level = 32, spellId = 15011 },
                }
            },
            { 
                levels = "33-37", talent = "Divine Fury", points = "5/5", spellId = 18535,
                ranks = {
                    { level = 33, spellId = 18530 },
                    { level = 34, spellId = 18531 },
                    { level = 35, spellId = 18533 },
                    { level = 36, spellId = 18534 },
                    { level = 37, spellId = 18535 },
                }
            },
            { levels = "38", talent = "Inner Focus", points = "1/1", spellId = 14751 },
            { levels = "39", talent = "Unbreakable Will", points = "1/5", spellId = 14522},
            { 
                levels = "40-44", talent = "Mental Agility", points = "5/5", spellId = 14783,
                ranks = {
                    { level = 40, spellId = 14520 },
                    { level = 41, spellId = 14780 },
                    { level = 42, spellId = 14781 },
                    { level = 43, spellId = 14782 },
                    { level = 44, spellId = 14783 },
                }
            },
            { levels = "45", talent = "Divine Spirit", points = "1/1", spellId = 14752 },
            { 
                levels = "46-48", talent = "Imp. Renew", points = "3/3", spellId = 17191,
                ranks = {
                    { level = 46, spellId = 14908 },
                    { level = 47, spellId = 15020 },
                    { level = 48, spellId = 17191 },
                }
            },
            { 
                levels = "49-50", talent = "Spell Warding", points = "2/5", spellId = 27901, note = "Filler",
                ranks = {
                    { level = 49, spellId = 27900 },
                    { level = 50, spellId = 27901 },
                }
            },
            { 
                levels = "51-52", talent = "Searing Light", points = "2/2", spellId = 15017,
                ranks = {
                    { level = 51, spellId = 14909 },
                    { level = 52, spellId = 15017 },
                }
            },
            { 
                levels = "53-54", talent = "Holy Reach", points = "2/2", spellId = 27790,
                ranks = {
                    { level = 53, spellId = 27789 },
                    { level = 54, spellId = 27790 },
                }
            },
            { 
                levels = "55-59", talent = "Mental Strength", points = "5/5", spellId = 18555,
                ranks = {
                    { level = 55, spellId = 18551 },
                    { level = 56, spellId = 18552 },
                    { level = 57, spellId = 18553 },
                    { level = 58, spellId = 18554 },
                    { level = 59, spellId = 18555 },
                }
            },
        }
    },
    {
        name = "Discipline / Shadow (25/10/15)",
        description = "Strong leveling and dungeon damage build.",
        progression = {
            { 
                levels = "10-14", talent = "Wand Specialization", points = "5/5", spellId = 14528,
                ranks = {
                    { level = 10, spellId = 14524 },
                    { level = 11, spellId = 14525 },
                    { level = 12, spellId = 14526 },
                    { level = 13, spellId = 14527 },
                    { level = 14, spellId = 14528 },
                }
            },
            { 
                levels = "15-19", talent = "Spirit Tap", points = "5/5", spellId = 15338,
                ranks = {
                    { level = 15, spellId = 15270 },
                    { level = 16, spellId = 15335 },
                    { level = 17, spellId = 15336 },
                    { level = 18, spellId = 15337 },
                    { level = 19, spellId = 15338 },
                }
            },
            { 
                levels = "20-22", talent = "Imp. Power Word: Shield", points = "3/3", spellId = 14769,
                ranks = {
                    { level = 20, spellId = 14748 },
                    { level = 21, spellId = 14768 },
                    { level = 22, spellId = 14769 },
                }
            },
            { 
                levels = "23-24", talent = "Imp. Power Word: Fortitude", points = "2/2", spellId = 14767,
                ranks = {
                    { level = 23, spellId = 14749 },
                    { level = 24, spellId = 14767 },
                }
            },
            { 
                levels = "25-27", talent = "Meditation", points = "3/3", spellId = 14777,
                ranks = {
                    { level = 25, spellId = 14521 },
                    { level = 26, spellId = 14776 },
                    { level = 27, spellId = 14777 },
                }
            },
            { 
                levels = "28-32", talent = "Shadow Focus", points = "5/5", spellId = 15330,
                ranks = {
                    { level = 28, spellId = 15260 },
                    { level = 29, spellId = 15327 },
                    { level = 30, spellId = 15328 },
                    { level = 31, spellId = 15329 },
                    { level = 32, spellId = 15330 },
                }
            },
            { levels = "33", talent = "Mind Flay", points = "1/1", spellId = 15407 },
            { 
                levels = "34-38", talent = "Holy Specialization", points = "5/5", spellId = 15011,
                ranks = {
                    { level = 34, spellId = 14889 },
                    { level = 35, spellId = 15008 },
                    { level = 36, spellId = 15009 },
                    { level = 37, spellId = 15010 },
                    { level = 38, spellId = 15011 },
                }
            },
            { 
                levels = "39-43", talent = "Divine Fury", points = "5/5", spellId = 18535,
                ranks = {
                    { level = 39, spellId = 18530 },
                    { level = 40, spellId = 18531 },
                    { level = 41, spellId = 18533 },
                    { level = 42, spellId = 18534 },
                    { level = 43, spellId = 18535 },
                }
            },
            { 
                levels = "44-45", talent = "Imp. Psychic Scream", points = "2/2", spellId = 15448,
                ranks = {
                    { level = 44, spellId = 15392 },
                    { level = 45, spellId = 15448 },
                }
            },
            { 
                levels = "46-47", talent = "Imp. Mind Blast", points = "2/2", spellId = 15312,
                ranks = {
                    { level = 46, spellId = 15273 },
                    { level = 47, spellId = 15312 },
                }
            },
            { levels = "48", talent = "Inner Focus", points = "1/1", spellId = 14751 },
            { levels = "49", talent = "Unbreakable Will", points = "1/5", spellId = 14522 },
            { 
                levels = "50-54", talent = "Mental Agility", points = "5/5", spellId = 14783,
                ranks = {
                    { level = 50, spellId = 14520 },
                    { level = 51, spellId = 14780 },
                    { level = 52, spellId = 14781 },
                    { level = 53, spellId = 14782 },
                    { level = 54, spellId = 14783 },
                }
            },
            { 
                levels = "55-59", talent = "Mental Strength", points = "5/5", spellId = 18555,
                ranks = {
                    { level = 55, spellId = 18551 },
                    { level = 56, spellId = 18552 },
                    { level = 57, spellId = 18553 },
                    { level = 58, spellId = 18554 },
                    { level = 59, spellId = 18555 },
                }
            },
        }
    },
}
