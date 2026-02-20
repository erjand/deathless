local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

-- Druid talent builds for Hardcore leveling
Deathless.Data.Talents.Druid = {
    {
        name = "Balance Leveling (10-24) (15/0/0)",
        description = "Early leveling with Improved Wrath and Omen of Clarity before respec.",
        progression = {
            { levels = "10", talent = "Nature's Grasp", points = "1/1", spellId = 16689 },
            {
                levels = "11-15", talent = "Improved Wrath", points = "5/5", spellId = 16818,
                ranks = {
                    { level = 11, spellId = 16814 },
                    { level = 12, spellId = 16815 },
                    { level = 13, spellId = 16816 },
                    { level = 14, spellId = 16817 },
                    { level = 15, spellId = 16818 },
                }
            },
            {
                levels = "16-20", talent = "Natural Weapons", points = "5/5", spellId = 16906,
                ranks = {
                    { level = 16, spellId = 16902 },
                    { level = 17, spellId = 16903 },
                    { level = 18, spellId = 16904 },
                    { level = 19, spellId = 16905 },
                    { level = 20, spellId = 16906 },
                }
            },
            { levels = "21", talent = "Omen of Clarity", points = "1/1", spellId = 16864 },
            {
                levels = "22-24", talent = "Natural Shapeshifter", points = "3/3", spellId = 16835,
                ranks = {
                    { level = 22, spellId = 16833 },
                    { level = 23, spellId = 16834 },
                    { level = 24, spellId = 16835 },
                }
            },
        }
    },
    {
        name = "Feral Leveling (25-60) (14/32/5)",
        description = "Respec at 25 for Feral with Balance and Resto support talents.",
        progression = {
            { levels = "10", talent = "Nature's Grasp", points = "1/1", spellId = 16689 },
            {
                levels = "11-14", talent = "Imp. Nature's Grasp", points = "4/4", spellId = 17249,
                ranks = {
                    { level = 11, spellId = 17245 },
                    { level = 12, spellId = 17247 },
                    { level = 13, spellId = 17248 },
                    { level = 14, spellId = 17249 },
                }
            },
            {
                levels = "15-19", talent = "Natural Weapons", points = "5/5", spellId = 16906,
                ranks = {
                    { level = 15, spellId = 16902 },
                    { level = 16, spellId = 16903 },
                    { level = 17, spellId = 16904 },
                    { level = 18, spellId = 16905 },
                    { level = 19, spellId = 16906 },
                }
            },
            { levels = "20", talent = "Omen of Clarity", points = "1/1", spellId = 16864 },
            {
                levels = "21-23", talent = "Natural Shapeshifter", points = "3/3", spellId = 16835,
                ranks = {
                    { level = 21, spellId = 16833 },
                    { level = 22, spellId = 16834 },
                    { level = 23, spellId = 16835 },
                }
            },
            {
                levels = "24-28", talent = "Furor", points = "5/5", spellId = 17061,
                ranks = {
                    { level = 24, spellId = 17056 },
                    { level = 25, spellId = 17058 },
                    { level = 26, spellId = 17059 },
                    { level = 27, spellId = 17060 },
                    { level = 28, spellId = 17061 },
                }
            },
            {
                levels = "29-33", talent = "Ferocity", points = "5/5", spellId = 16938,
                ranks = {
                    { level = 29, spellId = 16934 },
                    { level = 30, spellId = 16935 },
                    { level = 31, spellId = 16936 },
                    { level = 32, spellId = 16937 },
                    { level = 33, spellId = 16938 },
                }
            },
            {
                levels = "34-35", talent = "Brutal Impact", points = "2/2", spellId = 16941,
                ranks = {
                    { level = 34, spellId = 16940 },
                    { level = 35, spellId = 16941 },
                }
            },
            {
                levels = "36-40", talent = "Thick Hide", points = "5/5", spellId = 16933,
                ranks = {
                    { level = 36, spellId = 16929 },
                    { level = 37, spellId = 16930 },
                    { level = 38, spellId = 16931 },
                    { level = 39, spellId = 16932 },
                    { level = 40, spellId = 16933 },
                }
            },
            { levels = "41", talent = "Feral Charge", points = "1/1", spellId = 16979 },
            {
                levels = "42-44", talent = "Sharpened Claws", points = "3/3", spellId = 16944,
                ranks = {
                    { level = 42, spellId = 16942 },
                    { level = 43, spellId = 16943 },
                    { level = 44, spellId = 16944 },
                }
            },
            {
                levels = "45-47", talent = "Predatory Strikes", points = "3/3", spellId = 16975,
                ranks = {
                    { level = 45, spellId = 16972 },
                    { level = 46, spellId = 16974 },
                    { level = 47, spellId = 16975 },
                }
            },
            {
                levels = "48-49", talent = "Savage Fury", points = "2/2", spellId = 16999,
                ranks = {
                    { level = 48, spellId = 16998 },
                    { level = 49, spellId = 16999 },
                }
            },
            { levels = "50", talent = "Feral Faerie Fire", points = "1/1", spellId = 16857 },
            {
                levels = "51-53", talent = "Feral Aggression", points = "3/5", spellId = 16860,
                ranks = {
                    { level = 51, spellId = 16858 },
                    { level = 52, spellId = 16859 },
                    { level = 53, spellId = 16860 },
                }
            },
            {
                levels = "54-58", talent = "Heart of the Wild", points = "5/5", spellId = 24894,
                ranks = {
                    { level = 54, spellId = 17003 },
                    { level = 55, spellId = 17004 },
                    { level = 56, spellId = 17005 },
                    { level = 57, spellId = 17006 },
                    { level = 58, spellId = 24894 },
                }
            },
            {
                levels = "59-60", talent = "Blood Frenzy", points = "2/2", spellId = 16954,
                ranks = {
                    { level = 59, spellId = 16952 },
                    { level = 60, spellId = 16954 },
                }
            },
        }
    },
}
