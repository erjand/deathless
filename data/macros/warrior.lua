local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Macros = Deathless.Data.Macros or {}

Deathless.Data.Macros.Warrior = {
    {
        title = "Startattack with Ability",
        description = "Turn on auto-attack whenever you use an ability.",
        code = "#showtooltip\n/startattack\n/cast SomeAbility",
    },
    {
        title = "Stance Swap",
        description = "Change stance as needed for a specific ability.",
        code = "#showtooltip\n/cast Defensive Stance\n/cast SomeAbility",
    },
}
