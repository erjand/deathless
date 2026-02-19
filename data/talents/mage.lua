local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

-- Mage talent builds for Hardcore leveling
Deathless.Data.Talents.Mage = {
    {
        name = "Frost AoE (10/0/41)",
        description = "Multi-purpose Frost build for leveling and AoE.",
        progression = {
            { 
                levels = "10-14", talent = "Imp. Frostbolt", points = "5/5", spellId = 16766,
                ranks = {
                    { level = 10, spellId = 11070 },
                    { level = 11, spellId = 12473 },
                    { level = 12, spellId = 16763 },
                    { level = 13, spellId = 16765 },
                    { level = 14, spellId = 16766 },
                }
            },
            { 
                levels = "15-16", talent = "Elemental Precision", points = "2/3", spellId = 29439,
                ranks = {
                    { level = 15, spellId = 29438 },
                    { level = 16, spellId = 29439 },
                }
            },
            { 
                levels = "17-18", talent = "Imp. Frost Nova", points = "2/2", spellId = 12475,
                ranks = {
                    { level = 17, spellId = 11165 },
                    { level = 18, spellId = 12475 },
                }
            },
            { levels = "19", talent = "Permafrost", points = "1/3", spellId = 11175 },
            { 
                levels = "20-22", talent = "Imp. Blizzard", points = "3/3", spellId = 12488,
                ranks = {
                    { level = 20, spellId = 11185 },
                    { level = 21, spellId = 12487 },
                    { level = 22, spellId = 12488 },
                }
            },
            { levels = "23", talent = "Cold Snap", points = "1/1", spellId = 12472 },
            { 
                levels = "24-25", talent = "Permafrost", points = "3/3", spellId = 12571,
                ranks = {
                    { level = 24, spellId = 12569 },
                    { level = 25, spellId = 12571 },
                }
            },
            { 
                levels = "26-27", talent = "Arctic Reach", points = "2/2", spellId = 16758,
                ranks = {
                    { level = 26, spellId = 16757 },
                    { level = 27, spellId = 16758 },
                }
            },
            { 
                levels = "28-29", talent = "Frost Channeling", points = "2/3", spellId = 12518,
                ranks = {
                    { level = 28, spellId = 11160 },
                    { level = 29, spellId = 12518 },
                }
            },
            { levels = "30", talent = "Ice Block", points = "1/1", spellId = 11958 },
            { levels = "31", talent = "Frost Channeling", points = "3/3", spellId = 12519 },
            { 
                levels = "32-34", talent = "Imp. Cone of Cold", points = "3/3", spellId = 12490,
                ranks = {
                    { level = 32, spellId = 11190 },
                    { level = 33, spellId = 12489 },
                    { level = 34, spellId = 12490 },
                }
            },
            { 
                levels = "35-37", talent = "Piercing Ice", points = "3/3", spellId = 12953,
                ranks = {
                    { level = 35, spellId = 11151 },
                    { level = 36, spellId = 12952 },
                    { level = 37, spellId = 12953 },
                }
            },
            { 
                levels = "38-39", talent = "Ice Shards", points = "2/5", spellId = 12672,
                ranks = {
                    { level = 38, spellId = 11207 },
                    { level = 39, spellId = 12672 },
                }
            },
            { levels = "40", talent = "Ice Barrier", points = "1/1", spellId = 11426 },
            { 
                levels = "41-42", talent = "Arcane Subtlety", points = "2/2", spellId = 12592,
                ranks = {
                    { level = 41, spellId = 11210 },
                    { level = 42, spellId = 12592 },
                }
            },
            { 
                levels = "43-45", talent = "Arcane Focus", points = "3/5", spellId = 12840,
                ranks = {
                    { level = 43, spellId = 11222 },
                    { level = 44, spellId = 12839 },
                    { level = 45, spellId = 12840 },
                }
            },
            { 
                levels = "46-50", talent = "Arcane Concentration", points = "5/5", spellId = 12577,
                ranks = {
                    { level = 46, spellId = 11213 },
                    { level = 47, spellId = 12574 },
                    { level = 48, spellId = 12575 },
                    { level = 49, spellId = 12576 },
                    { level = 50, spellId = 12577 },
                }
            },
            { 
                levels = "51-53", talent = "Ice Shards", points = "5/5", spellId = 15053,
                ranks = {
                    { level = 51, spellId = 15047 },
                    { level = 52, spellId = 15052 },
                    { level = 53, spellId = 15053 },
                }
            },
            { 
                levels = "54-58", talent = "Shatter", points = "5/5", spellId = 12985,
                ranks = {
                    { level = 54, spellId = 11170 },
                    { level = 55, spellId = 12982 },
                    { level = 56, spellId = 12983 },
                    { level = 57, spellId = 12984 },
                    { level = 58, spellId = 12985 },
                }
            },
            { 
                levels = "59-60", talent = "Frost Warding", points = "2/2", spellId = 28332,
                ranks = {
                    { level = 59, spellId = 11189 },
                    { level = 60, spellId = 28332 },
                }
            },
        }
    },
    {
        name = "Single Target Frost Shatter (10/0/41)",
        description = "Safe single-target leveling build with deep frost survivability.",
        progression = {
            { 
                levels = "10-11", talent = "Elemental Precision", points = "2/3", spellId = 29439,
                ranks = {
                    { level = 10, spellId = 29438 },
                    { level = 11, spellId = 29439 },
                }
            },
            { 
                levels = "12-14", talent = "Imp. Frostbolt", points = "3/5", spellId = 16763,
                ranks = {
                    { level = 12, spellId = 11070 },
                    { level = 13, spellId = 12473 },
                    { level = 14, spellId = 16763 },
                }
            },
            { 
                levels = "15-16", talent = "Imp. Frost Nova", points = "2/2", spellId = 12475,
                ranks = {
                    { level = 15, spellId = 11165 },
                    { level = 16, spellId = 12475 },
                }
            },
            { 
                levels = "17-19", talent = "Frostbite", points = "3/3", spellId = 12497,
                ranks = {
                    { level = 17, spellId = 11071 },
                    { level = 18, spellId = 12496 },
                    { level = 19, spellId = 12497 },
                }
            },
            { levels = "20", talent = "Cold Snap", points = "1/1", spellId = 12472 },
            { 
                levels = "21-22", talent = "Imp. Frostbolt", points = "5/5", spellId = 16766,
                ranks = {
                    { level = 21, spellId = 16765 },
                    { level = 22, spellId = 16766 },
                }
            },
            { 
                levels = "23-24", talent = "Ice Shards", points = "2/5", spellId = 12672,
                ranks = {
                    { level = 23, spellId = 11207 },
                    { level = 24, spellId = 12672 },
                }
            },
            { 
                levels = "25-29", talent = "Shatter", points = "5/5", spellId = 12985,
                ranks = {
                    { level = 25, spellId = 11170 },
                    { level = 26, spellId = 12982 },
                    { level = 27, spellId = 12983 },
                    { level = 28, spellId = 12984 },
                    { level = 29, spellId = 12985 },
                }
            },
            { levels = "30", talent = "Ice Block", points = "1/1", spellId = 11958 },
            { 
                levels = "31-33", talent = "Ice Shards", points = "5/5", spellId = 15053,
                ranks = {
                    { level = 31, spellId = 15047 },
                    { level = 32, spellId = 15052 },
                    { level = 33, spellId = 15053 },
                }
            },
            { 
                levels = "34-36", talent = "Piercing Ice", points = "3/3", spellId = 12953,
                ranks = {
                    { level = 34, spellId = 11151 },
                    { level = 35, spellId = 12952 },
                    { level = 36, spellId = 12953 },
                }
            },
            { 
                levels = "37-38", talent = "Arctic Reach", points = "2/2", spellId = 16758,
                ranks = {
                    { level = 37, spellId = 16757 },
                    { level = 38, spellId = 16758 },
                }
            },
            { levels = "39", talent = "Frost Channeling", points = "1/3", spellId = 11160 },
            { levels = "40", talent = "Ice Barrier", points = "1/1", spellId = 11426 },
            { 
                levels = "41-42", talent = "Arcane Subtlety", points = "2/2", spellId = 12592,
                ranks = {
                    { level = 41, spellId = 11210 },
                    { level = 42, spellId = 12592 },
                }
            },
            { 
                levels = "43-45", talent = "Arcane Focus", points = "3/5", spellId = 12840,
                ranks = {
                    { level = 43, spellId = 11222 },
                    { level = 44, spellId = 12839 },
                    { level = 45, spellId = 12840 },
                }
            },
            { 
                levels = "46-50", talent = "Arcane Concentration", points = "5/5", spellId = 12577,
                ranks = {
                    { level = 46, spellId = 11213 },
                    { level = 47, spellId = 12574 },
                    { level = 48, spellId = 12575 },
                    { level = 49, spellId = 12576 },
                    { level = 50, spellId = 12577 },
                }
            },
            { 
                levels = "51-52", talent = "Frost Channeling", points = "3/3", spellId = 12519,
                ranks = {
                    { level = 51, spellId = 12518 },
                    { level = 52, spellId = 12519 },
                }
            },
            { 
                levels = "53-55", talent = "Permafrost", points = "3/3", spellId = 12571,
                ranks = {
                    { level = 53, spellId = 11175 },
                    { level = 54, spellId = 12569 },
                    { level = 55, spellId = 12571 },
                }
            },
            { 
                levels = "56-60", talent = "Winter's Chill", points = "5/5", spellId = 28595,
                ranks = {
                    { level = 56, spellId = 11180 },
                    { level = 57, spellId = 28592 },
                    { level = 58, spellId = 28593 },
                    { level = 59, spellId = 28594 },
                    { level = 60, spellId = 28595 },
                }
            },
        }
    }
}
