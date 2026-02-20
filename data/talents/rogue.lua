local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

-- Rogue talent builds for Hardcore leveling
Deathless.Data.Talents.Rogue = {
    {
        name = "Combat (10-29) (2/18/0)",
        description = "Early leveling build with Remorseless Attacks for crit openers.",
        progression = {
            { 
                levels = "10-11", talent = "Remorseless Attacks", points = "2/2", spellId = 14148,
                ranks = {
                    { level = 10, spellId = 14144 },
                    { level = 11, spellId = 14148 },
                }
            },
            { 
                levels = "12-13", talent = "Imp. Sinister Strike", points = "2/2", spellId = 13863,
                ranks = {
                    { level = 12, spellId = 13732 },
                    { level = 13, spellId = 13863 },
                }
            },
            { 
                levels = "14-16", talent = "Imp. Gouge", points = "3/3", spellId = 13792,
                ranks = {
                    { level = 14, spellId = 13741 },
                    { level = 15, spellId = 13793 },
                    { level = 16, spellId = 13792 },
                }
            },
            { 
                levels = "17-21", talent = "Deflection", points = "5/5", spellId = 13856,
                ranks = {
                    { level = 17, spellId = 13713 },
                    { level = 18, spellId = 13853 },
                    { level = 19, spellId = 13854 },
                    { level = 20, spellId = 13855 },
                    { level = 21, spellId = 13856 },
                }
            },
            { levels = "22", talent = "Riposte", points = "1/1", spellId = 14251 },
            { 
                levels = "23-27", talent = "Precision", points = "5/5", spellId = 13845,
                ranks = {
                    { level = 23, spellId = 13705 },
                    { level = 24, spellId = 13832 },
                    { level = 25, spellId = 13843 },
                    { level = 26, spellId = 13844 },
                    { level = 27, spellId = 13845 },
                }
            },
            { 
                levels = "28-29", talent = "Lightning Reflexes", points = "2/5", spellId = 13788,
                ranks = {
                    { level = 28, spellId = 13712 },
                    { level = 29, spellId = 13788 },
                }
            },
        }
    },
    {
        name = "Combat (30-60) (19/32/0)",
        description = "Respec at 30 for Blade Flurry and Adrenaline Rush.",
        progression = {
            { 
                levels = "10-12", talent = "Imp. Gouge", points = "3/3", spellId = 13792,
                ranks = {
                    { level = 10, spellId = 13741 },
                    { level = 11, spellId = 13793 },
                    { level = 12, spellId = 13792 },
                }
            },
            { 
                levels = "13-14", talent = "Imp. Sinister Strike", points = "2/2", spellId = 13863,
                ranks = {
                    { level = 13, spellId = 13732 },
                    { level = 14, spellId = 13863 },
                }
            },
            { 
                levels = "15-19", talent = "Lightning Reflexes", points = "5/5", spellId = 13791,
                ranks = {
                    { level = 15, spellId = 13712 },
                    { level = 16, spellId = 13788 },
                    { level = 17, spellId = 13789 },
                    { level = 18, spellId = 13790 },
                    { level = 19, spellId = 13791 },
                }
            },
            { 
                levels = "20-24", talent = "Deflection", points = "5/5", spellId = 13856,
                ranks = {
                    { level = 20, spellId = 13713 },
                    { level = 21, spellId = 13853 },
                    { level = 22, spellId = 13854 },
                    { level = 23, spellId = 13855 },
                    { level = 24, spellId = 13856 },
                }
            },
            { 
                levels = "25-29", talent = "Precision", points = "5/5", spellId = 13845,
                ranks = {
                    { level = 25, spellId = 13705 },
                    { level = 26, spellId = 13832 },
                    { level = 27, spellId = 13843 },
                    { level = 28, spellId = 13844 },
                    { level = 29, spellId = 13845 },
                }
            },
            { levels = "30", talent = "Blade Flurry", points = "1/1", spellId = 13877 },
            { levels = "31", talent = "Riposte", points = "1/1", spellId = 14251 },
            { 
                levels = "32-33", talent = "Endurance", points = "2/2", spellId = 13872,
                ranks = {
                    { level = 32, spellId = 13742 },
                    { level = 33, spellId = 13872 },
                }
            },
            { 
                levels = "34-37", talent = "Dual Wield Spec", points = "4/5", spellId = 13851,
                ranks = {
                    { level = 34, spellId = 13715 },
                    { level = 35, spellId = 13848 },
                    { level = 36, spellId = 13849 },
                    { level = 37, spellId = 13851 },
                }
            },
            { 
                levels = "38-39", talent = "Weapon Expertise", points = "2/2", spellId = 30920,
                ranks = {
                    { level = 38, spellId = 30919 },
                    { level = 39, spellId = 30920 },
                }
            },
            { levels = "40", talent = "Adrenaline Rush", points = "1/1", spellId = 13750 },
            { 
                levels = "41-45", talent = "Malice", points = "5/5", spellId = 14142,
                ranks = {
                    { level = 41, spellId = 14138 },
                    { level = 42, spellId = 14139 },
                    { level = 43, spellId = 14140 },
                    { level = 44, spellId = 14141 },
                    { level = 45, spellId = 14142 },
                }
            },
            { 
                levels = "46-48", talent = "Ruthlessness", points = "3/3", spellId = 14161,
                ranks = {
                    { level = 46, spellId = 14156 },
                    { level = 47, spellId = 14160 },
                    { level = 48, spellId = 14161 },
                }
            },
            { 
                levels = "49-51", talent = "Imp. Slice and Dice", points = "3/3", spellId = 14167,
                ranks = {
                    { level = 49, spellId = 14165 },
                    { level = 50, spellId = 14166 },
                    { level = 51, spellId = 14167 },
                }
            },
            { levels = "52", talent = "Relentless Strikes", points = "1/1", spellId = 14179 },
            { 
                levels = "53-56", talent = "Lethality", points = "4/5", spellId = 14136,
                ranks = {
                    { level = 53, spellId = 14128 },
                    { level = 54, spellId = 14132 },
                    { level = 55, spellId = 14135 },
                    { level = 56, spellId = 14136 },
                }
            },
            { levels = "57", talent = "Dual Wield Spec", points = "5/5", spellId = 13852 },
            { 
                levels = "58-59", talent = "Murder", points = "2/2", spellId = 14159,
                ranks = {
                    { level = 58, spellId = 14158 },
                    { level = 59, spellId = 14159 },
                }
            },
            { levels = "60", talent = "Lethality", points = "5/5", spellId = 14137 },
        }
    },
}
