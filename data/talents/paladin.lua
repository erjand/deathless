local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

-- Paladin talent builds for Hardcore leveling
Deathless.Data.Talents.Paladin = {
    {
        name = "HC Retribution (10/10/31)",
        description = "Survivability-focused Retribution build.",
        progression = {
            { 
                levels = "10-14", talent = "Divine Intellect", points = "5/5", spellId = 20261,
                ranks = {
                    { level = 10, spellId = 20257 },
                    { level = 11, spellId = 20258 },
                    { level = 12, spellId = 20259 },
                    { level = 13, spellId = 20260 },
                    { level = 14, spellId = 20261 },
                }
            },
            { 
                levels = "15-19", talent = "Spiritual Focus", points = "5/5", spellId = 20208,
                ranks = {
                    { level = 15, spellId = 20205 },
                    { level = 16, spellId = 20206 },
                    { level = 17, spellId = 20207 },
                    { level = 18, spellId = 20209 },
                    { level = 19, spellId = 20208 },
                }
            },
            { 
                levels = "20-24", talent = "Benediction", points = "5/5", spellId = 20105,
                ranks = {
                    { level = 20, spellId = 20101 },
                    { level = 21, spellId = 20102 },
                    { level = 22, spellId = 20103 },
                    { level = 23, spellId = 20104 },
                    { level = 24, spellId = 20105 },
                }
            },
            { 
                levels = "25-29", talent = "Deflection", points = "5/5", spellId = 20064,
                ranks = {
                    { level = 25, spellId = 20060 },
                    { level = 26, spellId = 20061 },
                    { level = 27, spellId = 20062 },
                    { level = 28, spellId = 20063 },
                    { level = 29, spellId = 20064 },
                }
            },
            { levels = "30", talent = "Seal of Command", points = "1/1", spellId = 20375 },
            { 
                levels = "31-32", talent = "Pursuit of Justice", points = "2/2", spellId = 26023,
                ranks = {
                    { level = 31, spellId = 26022 },
                    { level = 32, spellId = 26023 },
                }
            },
            { 
                levels = "33-37", talent = "Conviction", points = "5/5", spellId = 20121,
                ranks = {
                    { level = 33, spellId = 20117 },
                    { level = 34, spellId = 20118 },
                    { level = 35, spellId = 20119 },
                    { level = 36, spellId = 20120 },
                    { level = 37, spellId = 20121 },
                }
            },
            { 
                levels = "38-39", talent = "Imp. Retribution Aura", points = "2/2", spellId = 20092,
                ranks = {
                    { level = 38, spellId = 20091 },
                    { level = 39, spellId = 20092 },
                }
            },
            { 
                levels = "40-42", talent = "Two-Handed Weapon Spec", points = "3/3", spellId = 20113,
                ranks = {
                    { level = 40, spellId = 20111 },
                    { level = 41, spellId = 20112 },
                    { level = 42, spellId = 20113 },
                }
            },
            { levels = "43", talent = "Sanctity Aura", points = "1/1", spellId = 20218 },
            { levels = "44", talent = "Imp. Blessing of Might", points = "1/5", spellId = 20042 },
            { 
                levels = "45-49", talent = "Vengeance", points = "5/5", spellId = 20059,
                ranks = {
                    { level = 45, spellId = 20049 },
                    { level = 46, spellId = 20056 },
                    { level = 47, spellId = 20057 },
                    { level = 48, spellId = 20058 },
                    { level = 49, spellId = 20059 },
                }
            },
            { levels = "50", talent = "Repentance", points = "1/1", spellId = 20066 },
            { 
                levels = "51-55", talent = "Redoubt", points = "5/5", spellId = 20137,
                ranks = {
                    { level = 51, spellId = 20127 },
                    { level = 52, spellId = 20130 },
                    { level = 53, spellId = 20135 },
                    { level = 54, spellId = 20136 },
                    { level = 55, spellId = 20137 },
                }
            },
            { 
                levels = "56-58", talent = "Precision", points = "3/3", spellId = 20193,
                ranks = {
                    { level = 56, spellId = 20189 },
                    { level = 57, spellId = 20192 },
                    { level = 58, spellId = 20193 },
                }
            },
            { 
                levels = "59-60", talent = "Guardian's Favor", points = "2/2", spellId = 20175,
                ranks = {
                    { level = 59, spellId = 20174 },
                    { level = 60, spellId = 20175 },
                }
            },
        }
    },
}
