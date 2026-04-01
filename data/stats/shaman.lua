local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Stats = Deathless.Data.Stats or {}

-- See https://www.wowhead.com/classic/guide/classic-wow-stats-and-attributes-overview
Deathless.Data.Stats.Shaman = {
    primary = {
        {
            stat = "Agility",
            bonus = "1% critical strike chance per 20 Agility, 2 Armor per 1 Agility, 1% dodge per 20 Agility.",
            priority = "Low (Enhance)",
            note = "Minor crit and armor; Strength and Stamina are preferred for melee.",
        },
        {
            stat = "Intellect",
            bonus = "15 Mana per 1 Intellect, and 1% spell critical strike chance per 59.5 Intellect.",
            priority = "High",
            note = "Important for all specs; expands mana pool for heals, shocks, and totems.",
        },
        {
            stat = "Spirit",
            bonus = "Increases mana regeneration while not casting spells by (Spirit / 5 + 17) per 5 seconds.",
            priority = "Medium (Caster / Healer)",
            note = "Decent regen stat, but Mp5 is generally preferred for Shamans.",
        },
        {
            stat = "Stamina",
            bonus = "10 health per 1 Stamina.",
            priority = "High",
            note = "Primary Hardcore survivability stat.",
        },
        {
            stat = "Strength",
            bonus = "2 melee Attack Power per 1 Strength.",
            priority = "High (Enhance)",
            note = "Core melee DPS stat for Enhancement; no use for Elemental or Restoration.",
        },
    },
    secondary = {
        {
            stat = "Crit %",
            bonus = "Increases % chance for a melee attack to crit.",
            priority = "High (Enhance)",
            note = "Strong for Enhancement burst with Windfury procs and Flurry uptime.",
        },
        {
            stat = "Healing Power",
            bonus = "Increase the amount of healing done by your spells.",
            priority = "High (Healer)",
            note = "Core throughput stat for Restoration Shamans.",
        },
        {
            stat = "Hit %",
            bonus = "Increases % chance for a melee attack to hit.",
            priority = "High (Enhance)",
            note = "Critical for landing Windfury procs and consistent melee damage.",
        },
        {
            stat = "Mana / 5 Seconds",
            bonus = "Mana restored every 5 seconds, including while casting (stacks with other regen).",
            priority = "High (Healer / Elemental)",
            note = "Primary sustain stat; preferred over Spirit for all caster Shaman specs.",
        },
        {
            stat = "Movement Speed",
            bonus = "Improves character run and walk speed.",
            priority = "Medium",
            note = "Great for quality-of-life and survivability while leveling.",
        },
        {
            stat = "Spell Critical Strike Chance",
            bonus = "Increases the chance for your spells to critically hit.",
            priority = "High (Elemental / Healer)",
            note = "Powers Elemental burst damage and Tidal Mastery healing crits.",
        },
        {
            stat = "Spell Hit Chance",
            bonus = "Reduces the chance for enemies to resist your spells or for your spells to miss.",
            priority = "High (Elemental; until cap)",
            note = "Essential for Elemental DPS to reach hit cap in level 60 content.",
        },
        {
            stat = "Spell Power (Damage)",
            bonus = "Increase the amount of damage dealt by your spells.",
            priority = "High (Elemental)",
            note = "Primary throughput stat for Elemental Shamans.",
        },
        {
            stat = "Weapon Skill",
            bonus = "Each point increases your chance to hit or crit an enemy by 0.04%, and reduces enemy chance to dodge, parry, or block your attack by 0.04%.",
            priority = "Medium (Enhance)",
            note = "Useful for consistent melee damage and Windfury proc reliability.",
        },
    },
}
