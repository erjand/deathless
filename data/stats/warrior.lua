local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Stats = Deathless.Data.Stats or {}

-- See https://www.wowhead.com/classic/guide/classic-wow-stats-and-attributes-overview
Deathless.Data.Stats.Warrior = {
    primary = {
        {
            stat = "Agility",
            bonus = "1% critical strike chance per 20 Agility, and 2 Armor per 1 Agility.",
            priority = "Medium",
            note = "Good for defense and threat, but usually behind Stamina and Strength.",
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
            priority = "High (early levels)",
            note = "Scales extremely well early to lower downtime before pulls, but drops off after around level 30.",
        },
        {
            stat = "Stamina",
            bonus = "10 health per 1 Stamina.",
            priority = "High",
            note = "Primary Hardcore survivability and tanking stat.",
        },
        {
            stat = "Strength",
            bonus = "2 melee Attack Power per 1 Strength, and chance to block 1 damage per 20 Strength.",
            priority = "High",
            note = "Core stat for threat, rage generation, and DPS.",
        },
    },
    secondary = {
        {
            stat = "Armor",
            bonus = "Mitigates a % of incoming physical damage.",
            priority = "High (tank)",
            note = "Very important tanking stat to smooth out damage taken, but less useful for DPS.",
        },
        {
            stat = "Block %",
            bonus = "Increases % chance to block a melee attack.",
            priority = "Medium (tank)",
            note = "Situationally useful with high block % on low damage attacks.",
        },
        {
            stat = "Block Value",
            bonus = "Flat physical damage prevented on successful blocks.",
            priority = "Medium (tank)",
            note = "Situationally useful with high block % on low damage attacks.",
        },
        {
            stat = "Crit %",
            bonus = "Increases % chance for a melee attack to crit.",
            priority = "High",
            note = "Improves DPS and threat generation.",
        },
        {
            stat = "Defense",
            bonus = "Each point gives 0.04% to dodge, parry, block, and reduces your chance to be hit or crit by 0.04%.",
            priority = "High (at level 60)",
            note = "Required for raid tanking and level 60 content, but less useful while leveling.",
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
            note = "Very strong for consistent damage output, threat generation, and rage flow.",
        },
    },
}
