local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Macros = Deathless.Data.Macros or {}

Deathless.Data.Macros.Paladin = {
    {
        title = "Blessing of Protection with Stopcasting",
        description = "Interrupt your current spell and immediately cast Blessing of Protection.",
        code = "#showtooltip Blessing of Protection\n/stopcasting\n/cast Blessing of Protection",
    },
    {
        title = "Cleanse with Mouseover",
        description = "Cast Cleanse on a mouseover target without retargeting.",
        code = "#showtooltip Cleanse\n/cast [target=mouseover,help,nodead][] Cleanse",
    },
    {
        title = "Flash of Light on Yourself",
        description = "Cast Flash of Light on yourself without retargeting.",
        code = "#showtooltip Flash of Light\n/cast [target=player] Flash of Light",
    },
    {
        title = "Judgement + Seal",
        description = "Judge your current seal, then reapply your main combat seal.",
        code = "#showtooltip Judgement\n/cast Judgement\n/cast Seal of Righteousness",
    },
}
