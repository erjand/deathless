local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Macros = Deathless.Data.Macros or {}

Deathless.Data.Macros.Shaman = {
    {
        title = "Earth Shock with Stopcasting",
        description = "Interrupt your current spell and immediately cast Earth Shock.",
        code = "#showtooltip Earth Shock\n/stopcasting\n/cast Earth Shock",
    },
    {
        title = "Nature's Swiftness + Healing Wave",
        description = "Cast Nature's Swiftness and Healing Wave with one button.",
        code = "#showtooltip Nature's Swiftness\n/cast Nature's Swiftness\n/cast Healing Wave",
    },
    {
        title = "Spell Downranking",
        description = "Combine multiple ranks of the same spell into a single button with a modifier (shift, alt, or ctrl).",
        code = "#showtooltip\n/cast [mod:shift] Healing Wave(Rank 1); Healing Wave",
    },
    {
        title = "Weapon Imbue Swap",
        description = "Swap your weapon buff with a modifier (shift, alt, or ctrl).",
        code = "#showtooltip\n/cast [mod:shift] Frostbrand Weapon; Windfury Weapon",
    },
    {
        title = "Cure Poison on Yourself",
        description = "Remove poison effects from yourself without retargeting.",
        code = "#showtooltip Cure Poison\n/cast [target=player] Cure Poison",
    },
}
