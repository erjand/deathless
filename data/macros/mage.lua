local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Macros = Deathless.Data.Macros or {}

Deathless.Data.Macros.Mage = {
    {
        title = "Counterspell with Stopcasting",
        description = "Interrupt your current spell and immediately cast Counterspell.",
        code = "#showtooltip Counterspell\n/stopcasting\n/cast Counterspell",
    },
    {
        title = "Spell Downranking",
        description = "Combine multiple ranks of the same spell into a single button with a modifier (shift, alt, or ctrl).",
        code = "#showtooltip\n/cast [mod:shift] Blizzard(Rank 1); Blizzard",
    },
    {
        title = "Wand with Stopcasting",
        description = "Immediately interrupt your current spell to begin wanding.",
        code = "#showtooltip Shoot\n/stopcasting\n/cast Shoot",
    },
}
