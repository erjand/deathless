local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

-- Hunter talent builds for Hardcore leveling
Deathless.Data.Talents.Hunter = {
    {
        name = "Beast Mastery / Marksmanship (31/20/0)",
        description = "Safe BM leveling build with Marksmanship subspec for damage.",
        progression = {
            { 
                levels = "10-14", talent = "Endurance Training", points = "5/5", spellId = 19587,
                ranks = {
                    { level = 10, spellId = 19583 },
                    { level = 11, spellId = 19584 },
                    { level = 12, spellId = 19585 },
                    { level = 13, spellId = 19586 },
                    { level = 14, spellId = 19587 },
                }
            },
            { 
                levels = "15-17", talent = "Thick Hide", points = "3/3", spellId = 19612,
                ranks = {
                    { level = 15, spellId = 19609 },
                    { level = 16, spellId = 19610 },
                    { level = 17, spellId = 19612 },
                }
            },
            { 
                levels = "18-19", talent = "Imp. Revive Pet", points = "2/2", spellId = 19575,
                ranks = {
                    { level = 18, spellId = 24443 },
                    { level = 19, spellId = 19575 },
                }
            },
            { levels = "20", talent = "Bestial Swiftness", points = "1/1", spellId = 19596 },
            { 
                levels = "21-25", talent = "Unleashed Fury", points = "5/5", spellId = 19620,
                ranks = {
                    { level = 21, spellId = 19616 },
                    { level = 22, spellId = 19617 },
                    { level = 23, spellId = 19618 },
                    { level = 24, spellId = 19619 },
                    { level = 25, spellId = 19620 },
                }
            },
            { 
                levels = "26-27", talent = "Pathfinding", points = "2/2", spellId = 19560,
                ranks = {
                    { level = 26, spellId = 19559 },
                    { level = 27, spellId = 19560 },
                }
            },
            { 
                levels = "28-32", talent = "Ferocity", points = "5/5", spellId = 19602,
                ranks = {
                    { level = 28, spellId = 19598 },
                    { level = 29, spellId = 19599 },
                    { level = 30, spellId = 19600 },
                    { level = 31, spellId = 19601 },
                    { level = 32, spellId = 19602 },
                }
            },
            { levels = "33", talent = "Intimidation", points = "1/1", spellId = 19577 },
            { levels = "34", talent = "Spirit Bond", points = "1/2", spellId = 19578 },
            { 
                levels = "35-39", talent = "Frenzy", points = "5/5", spellId = 19625,
                ranks = {
                    { level = 35, spellId = 19621 },
                    { level = 36, spellId = 19622 },
                    { level = 37, spellId = 19623 },
                    { level = 38, spellId = 19624 },
                    { level = 39, spellId = 19625 },
                }
            },
            { levels = "40", talent = "Bestial Wrath", points = "1/1", spellId = 19574 },
            { 
                levels = "41-45", talent = "Efficiency", points = "5/5", spellId = 19420,
                ranks = {
                    { level = 41, spellId = 19416 },
                    { level = 42, spellId = 19417 },
                    { level = 43, spellId = 19418 },
                    { level = 44, spellId = 19419 },
                    { level = 45, spellId = 19420 },
                }
            },
            { 
                levels = "46-50", talent = "Lethal Shots", points = "5/5", spellId = 19431,
                ranks = {
                    { level = 46, spellId = 19426 },
                    { level = 47, spellId = 19427 },
                    { level = 48, spellId = 19429 },
                    { level = 49, spellId = 19430 },
                    { level = 50, spellId = 19431 },
                }
            },
            { 
                levels = "51-55", talent = "Imp. Hunter's Mark", points = "5/5", spellId = 19425,
                ranks = {
                    { level = 51, spellId = 19421 },
                    { level = 52, spellId = 19422 },
                    { level = 53, spellId = 19423 },
                    { level = 54, spellId = 19424 },
                    { level = 55, spellId = 19425 },
                }
            },
            { 
                levels = "56-58", talent = "Hawk Eye", points = "3/3", spellId = 19500,
                ranks = {
                    { level = 56, spellId = 19498 },
                    { level = 57, spellId = 19499 },
                    { level = 58, spellId = 19500 },
                }
            },
            { levels = "59", talent = "Aimed Shot", points = "1/1", spellId = 19434 },
            { levels = "60", talent = "Mortal Shots", points = "1/5", spellId = 19485 },
        }
    },
}
