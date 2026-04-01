local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Stats = Deathless.Data.Stats or {}

-- See https://www.wowhead.com/classic/guide/classic-wow-stats-and-attributes-overview
Deathless.Data.Stats.Mage = {
    primary = {
        {
            stat = "Agility",
            bonus = "None.",
            priority = "None",
            note = "Not used for Mages.",
        },
        {
            stat = "Intellect",
            bonus = "15 Mana per 1 Intellect, and 1% spell critical strike chance per 59.5 Intellect.",
            priority = "High",
            note = "Primary stat for Mage mana pool, spell crit, and sustainability.",
        },
        {
            stat = "Spirit",
            bonus = "Increases mana regeneration while not casting spells by (Spirit / 4 + 12.5) per 5 seconds.",
            priority = "High",
            note = "Core regeneration stat; Mage Armor allows 30% of regen to continue while casting.",
        },
        {
            stat = "Stamina",
            bonus = "10 health per 1 Stamina.",
            priority = "Medium",
            note = "Important survivability stat, especially for Hardcore.",
        },
        {
            stat = "Strength",
            bonus = "1 melee Attack Power per 1 Strength.",
            priority = "None",
            note = "No practical use case for Mages.",
        },
    },
    secondary = {
        {
            stat = "Mana / 5 Seconds",
            bonus = "Mana restored every 5 seconds, including while casting (stacks with other regen).",
            priority = "Low",
            note = "Less important due to Evocation and conjured water, but still helpful for long fights.",
        },
        {
            stat = "Spell Critical Strike Chance",
            bonus = "Increases the chance for your spells to critically hit.",
            priority = "High",
            note = "Core DPS stat; synergizes with Shatter (Frost) and Ignite (Fire) talents.",
        },
        {
            stat = "Spell Hit Chance",
            bonus = "Reduces the chance for enemies to resist your spells or for your spells to miss.",
            priority = "High (until cap)",
            note = "Essential to reach hit cap for reliable damage in level 60 content.",
        },
        {
            stat = "Spell Power (Damage)",
            bonus = "Increase the amount of damage dealt by your spells.",
            priority = "High",
            note = "Primary throughput stat for all Mage DPS.",
        },
    },
}
