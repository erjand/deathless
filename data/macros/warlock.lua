local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Macros = Deathless.Data.Macros or {}

Deathless.Data.Macros.Warlock = {
    {
        title = "Demon Abilities",
        description = "Use demon abilities directly.",
        code = "#showtooltip Sacrifice\n/cast Sacrifice",
    },
    {
        title = "Demon Attack + Corruption",
        description = "Attack with your demon and cast Corruption with one button.",
        code = "#showtooltip Corruption\n/petattack\n/cast Corruption",
    },
    {
        title = "Demon Follow + Passive",
        description = "Pull your demon back quickly.",
        code = "#showtooltip\n/petpassive\n/petfollow",
    },
    {
        title = "Fear with Stopcasting",
        description = "Interrupt your current spell and immediately cast Fear.",
        code = "#showtooltip Fear\n/stopcasting\n/cast Fear",
    },
    {
        title = "Spell Downranking",
        description = "Combine multiple ranks of the same spell into a single button with a modifier (shift, alt, or ctrl).",
        code = "#showtooltip\n/cast [mod:shift] Drain Soul(Rank 1); Drain Soul",
    },
    {
        title = "Wand with Stopcasting",
        description = "Immediately interrupt your current spell to begin wanding.",
        code = "#showtooltip Shoot\n/stopcasting\n/cast Shoot",
    },
}
