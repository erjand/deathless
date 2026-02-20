local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

-- Shaman talent builds for Hardcore leveling
Deathless.Data.Talents.Shaman = {
    {
        name = "Enhancement / Resto (0/31/20)",
        description = "Enhancement leveling with Resto subspec for safety and hit chance.",
        progression = {
            { 
                levels = "10-14", talent = "Shield Specialization", points = "5/5", spellId = 16301,
                ranks = {
                    { level = 10, spellId = 16253 },
                    { level = 11, spellId = 16298 },
                    { level = 12, spellId = 16299 },
                    { level = 13, spellId = 16300 },
                    { level = 14, spellId = 16301 },
                }
            },
            { 
                levels = "15-17", talent = "Imp. Lightning Shield", points = "3/3", spellId = 16291,
                ranks = {
                    { level = 15, spellId = 16261 },
                    { level = 16, spellId = 16290 },
                    { level = 17, spellId = 16291 },
                }
            },
            { levels = "18", talent = "Thundering Strikes", points = "1/5", spellId = 16255 },
            { 
                levels = "19-20", talent = "Imp. Ghost Wolf", points = "2/2", spellId = 16287,
                ranks = {
                    { level = 19, spellId = 16262 },
                    { level = 20, spellId = 16287 },
                }
            },
            { levels = "21", talent = "Two-Handed Axes and Maces", points = "1/1", spellId = 16269 },
            { 
                levels = "22-25", talent = "Thundering Strikes", points = "5/5", spellId = 16305,
                ranks = {
                    { level = 22, spellId = 16302 },
                    { level = 23, spellId = 16303 },
                    { level = 24, spellId = 16304 },
                    { level = 25, spellId = 16305 },
                }
            },
            { 
                levels = "26-30", talent = "Flurry", points = "5/5", spellId = 16280,
                ranks = {
                    { level = 26, spellId = 16256 },
                    { level = 27, spellId = 16277 },
                    { level = 28, spellId = 16278 },
                    { level = 29, spellId = 16279 },
                    { level = 30, spellId = 16280 },
                }
            },
            { levels = "31", talent = "Parry", points = "1/1", spellId = 16268 },
            { 
                levels = "32-34", talent = "Elemental Weapons", points = "3/3", spellId = 29080,
                ranks = {
                    { level = 32, spellId = 16266 },
                    { level = 33, spellId = 29079 },
                    { level = 34, spellId = 29080 },
                }
            },
            { 
                levels = "35-39", talent = "Weapon Mastery", points = "5/5", spellId = 29088,
                ranks = {
                    { level = 35, spellId = 29082 },
                    { level = 36, spellId = 29084 },
                    { level = 37, spellId = 29086 },
                    { level = 38, spellId = 29087 },
                    { level = 39, spellId = 29088 },
                }
            },
            { levels = "40", talent = "Stormstrike", points = "1/1", spellId = 17364 },
            { 
                levels = "41-45", talent = "Imp. Healing Wave", points = "5/5", spellId = 16229,
                ranks = {
                    { level = 41, spellId = 16182 },
                    { level = 42, spellId = 16226 },
                    { level = 43, spellId = 16227 },
                    { level = 44, spellId = 16228 },
                    { level = 45, spellId = 16229 },
                }
            },
            { 
                levels = "46-50", talent = "Tidal Focus", points = "5/5", spellId = 16217,
                ranks = {
                    { level = 46, spellId = 16179 },
                    { level = 47, spellId = 16214 },
                    { level = 48, spellId = 16215 },
                    { level = 49, spellId = 16216 },
                    { level = 50, spellId = 16217 },
                }
            },
            { 
                levels = "51-53", talent = "Ancestral Healing", points = "3/3", spellId = 16240,
                ranks = {
                    { level = 51, spellId = 16176 },
                    { level = 52, spellId = 16235 },
                    { level = 53, spellId = 16240 },
                }
            },
            { 
                levels = "54-56", talent = "Nature's Guidance", points = "3/3", spellId = 16198,
                ranks = {
                    { level = 54, spellId = 16180 },
                    { level = 55, spellId = 16196 },
                    { level = 56, spellId = 16198 },
                }
            },
            { 
                levels = "57-60", talent = "Healing Focus", points = "4/5", spellId = 16233,
                ranks = {
                    { level = 57, spellId = 16181 },
                    { level = 58, spellId = 16230 },
                    { level = 59, spellId = 16232 },
                    { level = 60, spellId = 16233 },
                }
            },
        }
    },
}
