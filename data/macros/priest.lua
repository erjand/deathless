local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Macros = Deathless.Data.Macros or {}

Deathless.Data.Macros.Priest = {
    {
        title = "Dispel with Mouseover",
        description = "Cast Dispel Magic on a mouseover target without retargeting.",
        code = "#showtooltip Dispel Magic\n/cast [target=mouseover,help,nodead][] Dispel Magic",
    },
    {
        title = "Power Word: Shield on Yourself",
        description = "Stop your current spell and cast Power Word: Shield on yourself.",
        code = "#showtooltip Power Word: Shield\n/stopcasting\n/cast [target=player] Power Word: Shield",
    },
    {
        title = "Psychic Scream with Stopcasting",
        description = "Interrupt your current spell and immediately cast Psychic Scream.",
        code = "#showtooltip Psychic Scream\n/stopcasting\n/cast Psychic Scream",
    },
    {
        title = "Spell Downranking",
        description = "Combine multiple ranks of the same spell into a single button with a modifier (shift, alt, or ctrl).",
        code = "#showtooltip\n/cast [mod:shift] Heal(Rank 2); Heal",
    },
    {
        title = "Wand with Stopcasting",
        description = "Immediately interrupt your current spell to begin wanding.",
        code = "#showtooltip Shoot\n/stopcasting\n/cast Shoot",
    },
}
