local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Macros = Deathless.Data.Macros or {}

Deathless.Data.Macros.Hunter = {
    {
        title = "Aspect Swap",
        description = "Use one button to swap between Aspects.",
        code = "#showtooltip\n/cast [mod:shift] Aspect of the Cheetah; Aspect of the Hawk",
    },
    {
        title = "Feign Death with Stopcasting",
        description = "Interrupt your current spell and cast Feign Death.",
        code = "#showtooltip Feign Death\n/stopcasting\n/cast Feign Death",
    },
    {
        title = "Pet Follow + Passive",
        description = "Pull your pet back quickly.",
        code = "#showtooltip\n/petpassive\n/petfollow",
    },
    {
        title = "Pull + Pet Attack",
        description = "Apply Hunter's Mark, start auto-shot, and send in your pet.",
        code = "#showtooltip Hunter's Mark\n/cast Hunter's Mark\n/startattack\n/petattack",
    },
    {
        title = "Wing Clip with Startattack",
        description = "Start auto-attack and apply Wing Clip on targets in melee range.",
        code = "#showtooltip Wing Clip\n/startattack\n/cast Wing Clip",
    },
}
