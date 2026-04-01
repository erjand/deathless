local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Stats = Deathless.Data.Stats or {}

-- See https://www.wowhead.com/classic/guide/classic-wow-stats-and-attributes-overview
Deathless.Data.Stats.Rogue = {
    primary = {
        {
            stat = "Agility",
            bonus = "1% critical strike chance per 29 Agility, 2 Armor per 1 Agility, 1 Ranged / Melee AP per 1 Agility, and 1% dodge per 14.5 Agility.",
            priority = "High",
            note = "Core stat for Rogue DPS.",
        },
        {
            stat = "Intellect",
            bonus = "Slightly improves the rate at which you gain weapon skill.",
            priority = "Very Low",
            note = "Helps level weapon skills faster, but otherwise not used.",
        },
        {
            stat = "Spirit",
            bonus = "Increases out-of-combat health regeneration between pulls.",
            priority = "Low",
            note = "Minor quality-of-life for reducing downtime between pulls.",
        },
        {
            stat = "Stamina",
            bonus = "10 health per 1 Stamina.",
            priority = "Medium",
            note = "Primary Hardcore survivability stat.",
        },
        {
            stat = "Strength",
            bonus = "1 melee AP per 1 Strength.",
            priority = "Medium",
            note = "Contributes to AP, but Agility provides more value per point.",
        },
    },
    secondary = {
        {
            stat = "Crit %",
            bonus = "Increases % chance for a melee attack to crit.",
            priority = "High",
            note = "Strong for DPS and combo point generation.",
        },
        {
            stat = "Hit %",
            bonus = "Increases % chance for a melee attack to hit.",
            priority = "High",
            note = "Essential for dual-wielding; off-hand has a base 19% miss penalty against same-level targets.",
        },
        {
            stat = "Movement Speed",
            bonus = "Improves character run and walk speed.",
            priority = "Medium",
            note = "Great for quality-of-life and survivability while leveling.",
        },
        {
            stat = "Weapon Skill",
            bonus = "Each point increases your chance to hit or crit an enemy by 0.04%, and reduces enemy chance to dodge, parry, or block your attack by 0.04%.",
            priority = "High",
            note = "Very strong for consistent damage output and combo point generation.",
        },
    },
}
