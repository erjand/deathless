local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Macros = Deathless.Data.Macros or {}

Deathless.Data.Macros.Druid = {
    {
        title = "Bear Powershift",
        description = "Drop your current form and enter Bear Form for armor and survivability.",
        code = "#showtooltip Bear Form\n/cancelform\n/cast Bear Form",
    },
    {
        title = "Cat Powershift",
        description = "Drop your current form and enter Cat Form to break slows.",
        code = "#showtooltip Cat Form\n/cancelform\n/cast Cat Form",
    },
    {
        title = "Nature's Swiftness + Healing Touch",
        description = "Cast Nature's Swiftness and Healing Touch with one button.",
        code = "#showtooltip Nature's Swiftness\n/cast Nature's Swiftness\n/cast Healing Touch",
    },
    {
        title = "Innervate on Yourself",
        description = "Cast Innervate on yourself without retargeting.",
        code = "#showtooltip Innervate\n/cast [target=player] Innervate",
    },
}
