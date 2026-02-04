local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

-- Warrior talent builds for Hardcore leveling
Deathless.Data.Talents.Warrior = {
    {
        name = "Fury (10-30)",
        description = "Early leveling fury build for consistent damage.",
        progression = {
            { 
                levels = "10-14", talent = "Cruelty", points = "5/5", spellId = 12856,
                ranks = {
                    { level = 10, spellId = 12320 },
                    { level = 11, spellId = 12852 },
                    { level = 12, spellId = 12853 },
                    { level = 13, spellId = 12855 },
                    { level = 14, spellId = 12856 },
                }
            },
            { 
                levels = "15-19", talent = "Imp. Demoralizing Shout", points = "5/5", spellId = 12879,
                ranks = {
                    { level = 15, spellId = 12324 },
                    { level = 16, spellId = 12876 },
                    { level = 17, spellId = 12877 },
                    { level = 18, spellId = 12878 },
                    { level = 19, spellId = 12879 },
                }
            },
            { levels = "20", talent = "Piercing Howl", points = "1/1", spellId = 12323 },
            { 
                levels = "21-24", talent = "Imp. Battle Shout", points = "4/5", spellId = 12860,
                ranks = {
                    { level = 21, spellId = 12318 },
                    { level = 22, spellId = 12857 },
                    { level = 23, spellId = 12858 },
                    { level = 24, spellId = 12860 },
                }
            },
            { 
                levels = "25-26", talent = "Imp. Execute", points = "2/2", spellId = 20503,
                ranks = {
                    { level = 25, spellId = 20502 },
                    { level = 26, spellId = 20503 },
                }
            },
            { levels = "27", talent = "Imp. Battle Shout", points = "5/5", spellId = 12861 },
            { 
                levels = "28-29", talent = "Enrage", points = "2/5", spellId = 13045,
                ranks = {
                    { level = 28, spellId = 12317 },
                    { level = 29, spellId = 13045 },
                }
            },
            { levels = "30", talent = "Death Wish", points = "1/1", spellId = 12292 },
        }
    },
    {
        name = "Arms Sweeping Strikes (30-50)",
        description = "Respec at 30 for Sweeping Strikes and Mortal Strike.",
        progression = {
            { 
                levels = "10-11", talent = "Deflection", points = "2/5", spellId = 16463,
                ranks = {
                    { level = 10, spellId = 16462 },
                    { level = 11, spellId = 16463 },
                }
            },
            { 
                levels = "12-14", talent = "Imp. Rend", points = "3/3", spellId = 12659,
                ranks = {
                    { level = 12, spellId = 12286 },
                    { level = 13, spellId = 12658 },
                    { level = 14, spellId = 12659 },
                }
            },
            { 
                levels = "15-19", talent = "Tactical Mastery", points = "5/5", spellId = 12679,
                ranks = {
                    { level = 15, spellId = 12295 },
                    { level = 16, spellId = 12676 },
                    { level = 17, spellId = 12677 },
                    { level = 18, spellId = 12678 },
                    { level = 19, spellId = 12679 },
                }
            },
            { levels = "20", talent = "Anger Management", points = "1/1", spellId = 12296 },
            { 
                levels = "21-22", talent = "Imp. Overpower", points = "2/2", spellId = 12963,
                ranks = {
                    { level = 21, spellId = 12290 },
                    { level = 22, spellId = 12963 },
                }
            },
            { 
                levels = "23-24", talent = "Imp. Charge", points = "2/2", spellId = 12697,
                ranks = {
                    { level = 23, spellId = 12285 },
                    { level = 24, spellId = 12697 },
                }
            },
            { 
                levels = "25-27", talent = "Deep Wounds", points = "3/3", spellId = 12867,
                ranks = {
                    { level = 25, spellId = 12834 },
                    { level = 26, spellId = 12849 },
                    { level = 27, spellId = 12867 },
                }
            },
            { 
                levels = "28-29", talent = "Impale", points = "2/2", spellId = 16494,
                ranks = {
                    { level = 28, spellId = 16493 },
                    { level = 29, spellId = 16494 },
                }
            },
            { levels = "30", talent = "Sweeping Strikes", points = "1/1", spellId = 12328 },
            { 
                levels = "31-34", talent = "Axe Specialization", points = "4/5", spellId = 12784,
                ranks = {
                    { level = 31, spellId = 12700 },
                    { level = 32, spellId = 12781 },
                    { level = 33, spellId = 12783 },
                    { level = 34, spellId = 12784 },
                }
            },
            { 
                levels = "35-38", talent = "Two-Handed Weapon Spec", points = "4/5", spellId = 12713,
                ranks = {
                    { level = 35, spellId = 12163 },
                    { level = 36, spellId = 12711 },
                    { level = 37, spellId = 12712 },
                    { level = 38, spellId = 12713 },
                }
            },
            { levels = "39", talent = "Axe Specialization", points = "5/5", spellId = 12785 },
            { levels = "40", talent = "Mortal Strike", points = "1/1", spellId = 12294 },
            { 
                levels = "41-45", talent = "Cruelty", points = "5/5", spellId = 12856,
                ranks = {
                    { level = 10, spellId = 12320 },
                    { level = 11, spellId = 12852 },
                    { level = 12, spellId = 12853 },
                    { level = 13, spellId = 12855 },
                    { level = 14, spellId = 12856 },
                }
            },
            { 
                levels = "46-50", talent = "Imp. Demoralizing Shout", points = "5/5", spellId = 12879,
                ranks = {
                    { level = 46, spellId = 12324 },
                    { level = 47, spellId = 12876 },
                    { level = 48, spellId = 12877 },
                    { level = 49, spellId = 12878 },
                    { level = 50, spellId = 12879 },
                }
            },
        }
    },
    {
        name = "Fury Bloodthirst (50-60)",
        description = "Respec at 50 for Bloodthirst dual-wield build.",
        progression = {
            { 
                levels = "10-14", talent = "Cruelty", points = "5/5", spellId = 12856,
                ranks = {
                    { level = 10, spellId = 12320 },
                    { level = 11, spellId = 12852 },
                    { level = 12, spellId = 12853 },
                    { level = 13, spellId = 12855 },
                    { level = 14, spellId = 12856 },
                }
            },
            { 
                levels = "15-19", talent = "Imp. Demoralizing Shout", points = "5/5", spellId = 12879,
                ranks = {
                    { level = 15, spellId = 12324 },
                    { level = 16, spellId = 12876 },
                    { level = 17, spellId = 12877 },
                    { level = 18, spellId = 12878 },
                    { level = 19, spellId = 12879 },
                }
            },
            { 
                levels = "20-24", talent = "Imp. Battle Shout", points = "5/5", spellId = 12861,
                ranks = {
                    { level = 20, spellId = 12318 },
                    { level = 21, spellId = 12857 },
                    { level = 22, spellId = 12858 },
                    { level = 23, spellId = 12860 },
                    { level = 24, spellId = 12861 },
                }
            },
            { 
                levels = "25-26", talent = "Imp. Execute", points = "2/2", spellId = 20503,
                ranks = {
                    { level = 25, spellId = 20502 },
                    { level = 26, spellId = 20503 },
                }
            },
            { levels = "27", talent = "Piercing Howl", points = "1/1", spellId = 12323 },
            { 
                levels = "28-29", talent = "Enrage", points = "2/5", spellId = 13045,
                ranks = {
                    { level = 28, spellId = 12317 },
                    { level = 29, spellId = 13045 },
                }
            },
            { levels = "30", talent = "Death Wish", points = "1/1", spellId = 12292 },
            { 
                levels = "31-33", talent = "Enrage", points = "5/5", spellId = 13048,
                ranks = {
                    { level = 31, spellId = 13046 },
                    { level = 32, spellId = 13047 },
                    { level = 33, spellId = 13048 },
                }
            },
            { levels = "34", talent = "Dual Wield Specialization", points = "1/5", spellId = 23584 },
            { 
                levels = "35-39", talent = "Flurry", points = "5/5", spellId = 12974,
                ranks = {
                    { level = 35, spellId = 12319 },
                    { level = 36, spellId = 12971 },
                    { level = 37, spellId = 12972 },
                    { level = 38, spellId = 12973 },
                    { level = 39, spellId = 12974 },
                }
            },
            { levels = "40", talent = "Bloodthirst", points = "1/1", spellId = 23881 },
            { 
                levels = "41-45", talent = "Deflection", points = "5/5", spellId = 16466,
                ranks = {
                    { level = 41, spellId = 16462 },
                    { level = 42, spellId = 16463 },
                    { level = 43, spellId = 16464 },
                    { level = 44, spellId = 16465 },
                    { level = 45, spellId = 16466 },
                }
            },
            { 
                levels = "46-50", talent = "Tactical Mastery", points = "5/5", spellId = 12679,
                ranks = {
                    { level = 46, spellId = 12295 },
                    { level = 47, spellId = 12676 },
                    { level = 48, spellId = 12677 },
                    { level = 49, spellId = 12678 },
                    { level = 50, spellId = 12679 },
                }
            },
            { levels = "51", talent = "Anger Management", points = "1/1", spellId = 12296 },
            { 
                levels = "52-53", talent = "Imp. Berserker Rage", points = "2/2", spellId = 20501,
                ranks = {
                    { level = 52, spellId = 20500 },
                    { level = 53, spellId = 20501 },
                }
            },
            { 
                levels = "54-55", talent = "Imp. Overpower", points = "2/2", spellId = 12963,
                ranks = {
                    { level = 54, spellId = 12290 },
                    { level = 55, spellId = 12963 },
                }
            },
            { 
                levels = "56-59", talent = "Dual Wield Specialization", points = "5/5", spellId = 23588,
                ranks = {
                    { level = 56, spellId = 23585 },
                    { level = 57, spellId = 23586 },
                    { level = 58, spellId = 23587 },
                    { level = 59, spellId = 23588 },
                }
            },
        }
    },
}
