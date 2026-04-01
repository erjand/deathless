local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Stats = Deathless.Data.Stats or {}

-- See https://www.wowhead.com/classic/guide/classic-wow-stats-and-attributes-overview
Deathless.Data.Stats.Hunter = {
    primary = {
        {
            stat = "Agility",
            bonus = "2 Ranged AP / 1 Melee AP per 1 Agility, 2 Armor per 1 Agility, 1% critical strike chance per 53 Agility, and 1% dodge per 26.5 Agility.",
            priority = "High",
            note = "Best stat for Hunters; provides ranged AP, crit, and dodge.",
        },
        {
            stat = "Intellect",
            bonus = "15 Mana per 1 Intellect.",
            priority = "Medium",
            note = "Expands mana pool for Arcane Shot, Aspect cycling, and traps.",
        },
        {
            stat = "Spirit",
            bonus = "Increases out-of-combat health and mana regeneration (Spirit / 5 + 15) per 5 seconds between pulls.",
            priority = "Low",
            note = "Minor quality-of-life; pet and Aspect of the Viper (if available) handle sustain better.",
        },
        {
            stat = "Stamina",
            bonus = "10 health per 1 Stamina.",
            priority = "Medium",
            note = "Important survivability stat, especially for Hardcore.",
        },
        {
            stat = "Strength",
            bonus = "1 melee AP per 1 Strength.",
            priority = "Very Low",
            note = "Only affects melee damage.",
        },
    },
    secondary = {
        {
            stat = "Armor",
            bonus = "Mitigates a % of incoming physical damage.",
            priority = "Medium",
            note = "Helpful survivability stat since Hunters wear mail (at 40+) or leather.",
        },
        {
            stat = "Crit %",
            bonus = "Increases % chance for a ranged or melee attack to crit.",
            priority = "High",
            note = "Strong DPS stat.",
        },
        {
            stat = "Hit %",
            bonus = "Increases % chance for a ranged or melee attack to hit.",
            priority = "High (until cap)",
            note = "Essential for consistent ranged damage in level 60 content; 9% needed against bosses.",
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
            priority = "High (if raiding)",
            note = "Going above 300 is a large DPS boost against raid bosses.",
        },
    },
}
