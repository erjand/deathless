local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Talents = Deathless.Data.Talents or {}

-- Warlock talent builds for Hardcore leveling
Deathless.Data.Talents.Warlock = {
    {
        name = "Demonology / Affliction (1-39)",
        description = "Safe leveling build with strong pet and survivability.",
        progression = {
            { 
                levels = "10-14", talent = "Imp. Corruption", points = "5/5", spellId = 17814,
                ranks = {
                    { level = 10, spellId = 17810 },
                    { level = 11, spellId = 17811 },
                    { level = 12, spellId = 17812 },
                    { level = 13, spellId = 17813 },
                    { level = 14, spellId = 17814 },
                }
            },
            { 
                levels = "15-19", talent = "Demonic Embrace", points = "5/5", spellId = 18701,
                ranks = {
                    { level = 15, spellId = 18697 },
                    { level = 16, spellId = 18698 },
                    { level = 17, spellId = 18699 },
                    { level = 18, spellId = 18700 },
                    { level = 19, spellId = 18701 },
                }
            },
            { 
                levels = "20-22", talent = "Imp. Voidwalker", points = "3/3", spellId = 18707,
                ranks = {
                    { level = 20, spellId = 18705 },
                    { level = 21, spellId = 18706 },
                    { level = 22, spellId = 18707 },
                }
            },
            { 
                levels = "23-24", talent = "Imp. Healthstone", points = "2/2", spellId = 18693,
                ranks = {
                    { level = 23, spellId = 18692 },
                    { level = 24, spellId = 18693 },
                }
            },
            { levels = "25", talent = "Fel Domination", points = "1/1", spellId = 18708 },
            { 
                levels = "26-29", talent = "Fel Stamina", points = "4/5", spellId = 18751,
                ranks = {
                    { level = 26, spellId = 18748 },
                    { level = 27, spellId = 18749 },
                    { level = 28, spellId = 18750 },
                    { level = 29, spellId = 18751 },
                }
            },
            { 
                levels = "30-31", talent = "Master Summoner", points = "2/2", spellId = 18710,
                ranks = {
                    { level = 30, spellId = 18709 },
                    { level = 31, spellId = 18710 },
                }
            },
            { levels = "32", talent = "Fel Stamina", points = "5/5", spellId = 18752 },
            { 
                levels = "33-34", talent = "Unholy Power", points = "2/5", spellId = 18770,
                ranks = {
                    { level = 33, spellId = 18769 },
                    { level = 34, spellId = 18770 },
                }
            },
            { levels = "35", talent = "Demonic Sacrifice", points = "1/1", spellId = 18788 },
            { 
                levels = "36-37", talent = "Suppression", points = "2/5", spellId = 18175,
                ranks = {
                    { level = 36, spellId = 18174 },
                    { level = 37, spellId = 18175 },
                }
            },
            { 
                levels = "38-39", talent = "Imp. Life Tap", points = "2/2", spellId = 18183,
                ranks = {
                    { level = 38, spellId = 18182 },
                    { level = 39, spellId = 18183 },
                }
            },
        }
    },
    {
        name = "Soul Link Demonology (40-60)",
        description = "Respec at 40 for Soul Link survivability.",
        progression = {
            { 
                levels = "10-14", talent = "Demonic Embrace", points = "5/5", spellId = 18701,
                ranks = {
                    { level = 10, spellId = 18697 },
                    { level = 11, spellId = 18698 },
                    { level = 12, spellId = 18699 },
                    { level = 13, spellId = 18700 },
                    { level = 14, spellId = 18701 },
                }
            },
            { 
                levels = "15-16", talent = "Imp. Healthstone", points = "2/2", spellId = 18693,
                ranks = {
                    { level = 15, spellId = 18692 },
                    { level = 16, spellId = 18693 },
                }
            },
            { 
                levels = "17-19", talent = "Imp. Voidwalker", points = "3/3", spellId = 18707,
                ranks = {
                    { level = 17, spellId = 18705 },
                    { level = 18, spellId = 18706 },
                    { level = 19, spellId = 18707 },
                }
            },
            { levels = "20", talent = "Fel Domination", points = "1/1", spellId = 18708 },
            { 
                levels = "21-24", talent = "Fel Stamina", points = "4/5", spellId = 18751,
                ranks = {
                    { level = 21, spellId = 18748 },
                    { level = 22, spellId = 18749 },
                    { level = 23, spellId = 18750 },
                    { level = 24, spellId = 18751 },
                }
            },
            { 
                levels = "25-26", talent = "Master Summoner", points = "2/2", spellId = 18710,
                ranks = {
                    { level = 25, spellId = 18709 },
                    { level = 26, spellId = 18710 },
                }
            },
            { 
                levels = "27-31", talent = "Unholy Power", points = "5/5", spellId = 18773,
                ranks = {
                    { level = 27, spellId = 18769 },
                    { level = 28, spellId = 18770 },
                    { level = 29, spellId = 18771 },
                    { level = 30, spellId = 18772 },
                    { level = 31, spellId = 18773 },
                }
            },
            { levels = "32", talent = "Demonic Sacrifice", points = "1/1", spellId = 18788 },
            { levels = "33", talent = "Fel Stamina", points = "5/5", spellId = 18752 },
            { levels = "34", talent = "Fel Intellect", points = "1/5", spellId = 18753 },
            { 
                levels = "35-39", talent = "Master Demonologist", points = "5/5", spellId = 23825,
                ranks = {
                    { level = 35, spellId = 23785 },
                    { level = 36, spellId = 23822 },
                    { level = 37, spellId = 23823 },
                    { level = 38, spellId = 23824 },
                    { level = 39, spellId = 23825 },
                }
            },
            { levels = "40", talent = "Soul Link", points = "1/1", spellId = 19028 },
            { 
                levels = "41-45", talent = "Imp. Corruption", points = "5/5", spellId = 17814,
                ranks = {
                    { level = 41, spellId = 17810 },
                    { level = 42, spellId = 17811 },
                    { level = 43, spellId = 17812 },
                    { level = 44, spellId = 17813 },
                    { level = 45, spellId = 17814 },
                }
            },
            { 
                levels = "46-48", talent = "Suppression", points = "3/5", spellId = 18176,
                ranks = {
                    { level = 46, spellId = 18174 },
                    { level = 47, spellId = 18175 },
                    { level = 48, spellId = 18176 },
                }
            },
            { 
                levels = "49-50", talent = "Imp. Life Tap", points = "2/2", spellId = 18183,
                ranks = {
                    { level = 49, spellId = 18182 },
                    { level = 50, spellId = 18183 },
                }
            },
            { levels = "51", talent = "Amplify Curse", points = "1/1", spellId = 18288 },
            { 
                levels = "52-54", talent = "Imp. Curse of Agony", points = "3/3", spellId = 18830,
                ranks = {
                    { level = 52, spellId = 18827 },
                    { level = 53, spellId = 18829 },
                    { level = 54, spellId = 18830 },
                }
            },
            { levels = "55", talent = "Suppression", points = "4/5", spellId = 18177 },
            { 
                levels = "56-57", talent = "Nightfall", points = "2/2", spellId = 18095,
                ranks = {
                    { level = 56, spellId = 18094 },
                    { level = 57, spellId = 18095 },
                }
            },
            { 
                levels = "58-59", talent = "Grim Reach", points = "2/2", spellId = 18219,
                ranks = {
                    { level = 58, spellId = 18218 },
                    { level = 59, spellId = 18219 },
                }
            },
        }
    },
}
