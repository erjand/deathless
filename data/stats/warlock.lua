local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Stats = Deathless.Data.Stats or {}

-- See https://www.wowhead.com/classic/guide/classic-wow-stats-and-attributes-overview
Deathless.Data.Stats.Warlock = {
    primary = {
        {
            stat = "Agility",
            bonus = "2 Armor per 1 Agility, 1% dodge per 20 Agility.",
            priority = "None",
            note = "No practical use case for Warlocks.",
        },
        {
            stat = "Intellect",
            bonus = "15 Mana per 1 Intellect, and 1% spell critical strike chance per 60.6 Intellect.",
            priority = "High",
            note = "Primary stat for Warlock mana pool and spell crit.",
        },
        {
            stat = "Spirit",
            bonus = "Increases mana regeneration while not casting spells by (Spirit / 5 + 15) per 5 seconds.",
            priority = "Medium",
            note = "Useful for regen between pulls, but Warlocks primarily recover mana via Life Tap.",
        },
        {
            stat = "Stamina",
            bonus = "10 health per 1 Stamina.",
            priority = "High",
            note = "Stronger for Warlocks than other casters; fuels Life Tap and improves survivability.",
        },
        {
            stat = "Strength",
            bonus = "1 melee AP per 1 Strength.",
            priority = "None",
            note = "No practical use case for Warlocks.",
        },
    },
    secondary = {
        {
            stat = "Mana / 5 Seconds",
            bonus = "Mana restored every 5 seconds, including while casting (stacks with other regen).",
            priority = "Low",
            note = "Mostly unnecessary since Life Tap covers mana needs.",
        },
        {
            stat = "Spell Critical Strike Chance",
            bonus = "Increases the chance for your spells to critically hit.",
            priority = "Medium",
            note = "Good for burst damage with Destruction spells; less impactful for Affliction/DoT builds.",
        },
        {
            stat = "Spell Hit Chance",
            bonus = "Reduces the chance for enemies to resist your spells or for your spells to miss.",
            priority = "High (until cap)",
            note = "Essential to reach hit cap for reliable damage and debuffs in level 60 content.",
        },
        {
            stat = "Spell Power (Damage)",
            bonus = "Increase the amount of damage dealt by your spells.",
            priority = "High",
            note = "Primary throughput stat for all Warlock DPS.",
        },
    },
}
