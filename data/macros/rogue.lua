local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Macros = Deathless.Data.Macros or {}

Deathless.Data.Macros.Rogue = {
    {
        title = "Kick with Stopcasting",
        description = "Interrupt your current ability to immediately Kick.",
        code = "#showtooltip Kick\n/stopcasting\n/cast Kick",
    },
    {
        title = "Startattack with Ability",
        description = "Turn on auto-attack whenever you use an ability.",
        code = "#showtooltip\n/startattack\n/cast Sinister Strike",
    },
    {
        title = "Stealth + Sap",
        description = "Enter Stealth out of combat, then Sap when already stealthed.",
        code = "#showtooltip Sap\n/cast [nostealth] Stealth\n/cast [stealth] Sap",
    },
    {
        title = "Vanish with Stopattack",
        description = "Stop your auto-attack before Vanish so you do not break stealth.",
        code = "#showtooltip Vanish\n/stopattack\n/cast Vanish",
    },
}
