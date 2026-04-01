local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Stats = Deathless.Data.Stats or {}

-- See https://www.wowhead.com/classic/guide/classic-wow-stats-and-attributes-overview
Deathless.Data.Stats.Priest = {

    primary = {

        {
            stat = "Agility",
            bonus = "2 Armor per 1 Agility, 1% dodge per 20 Agility.",
            priority = "None",
            note = "No practical use case for Priests.",
        },

        {
            stat = "Intellect",
            bonus = "15 Mana per 1 Intellect, and 1% spell critical strike chance per 59.2 Intellect.",
            priority = "High",
            note = "Primary stat for Priest mana pool and sustainability.",
        },

        {
            stat = "Spirit",
            bonus = "Increases mana regeneration while not casting spells by (Spirit / 4 + 12.5) per 5 seconds. Further increased by Discipline Priest talents.",
            priority = "High",
            note = "Greatly increases mana regeneration and reduces downtime.",
        },

        {
            stat = "Stamina",
            bonus = "10 health per 1 Stamina.",
            priority = "Medium",
            note = "Important survivability stat.",
        },

        {
            stat = "Strength",
            bonus = "1 melee AP per 1 Strength.",
            priority = "None",
            note = "No practical use case for Priests.",
        },

    },

    secondary = {

        {
            stat = "Healing Power",
            bonus = "Increase the amount of healing done by your spells.",
            priority = "High",
            note = "Core throughput stat for Priest healing.",
        },

        {
            stat = "Mana / 5 Seconds",
            bonus = "Mana restored every 5 seconds, including while casting (stacks with other regen).",
            priority = "High",
            note = "Reduces drinking and downtime; especially valuable in long fights and dungeons.",
        },

        {
            stat = "Spell Critical Strike Chance",
            bonus = "Increases the chance for your spells to critically hit.",
            priority = "High",
            note = "Strong for burst healing and damage; synergizes with talents that proc on critical strikes.",
        },

        {
            stat = "Spell Hit Chance",
            bonus = "Reduces the chance for enemies to resist your spells or for your spells to miss.",
            priority = "Low / High",
            note = "Essential to reach hit cap for reliable damage and debuffs in level 60 content.",
        },

        {
            stat = "Spell Power (Damage)",
            bonus = "Increase the amount of damage dealt by your spells.",
            priority = "Low / High",
            note = "Primary throughput stat for Priest DPS; less relevant for pure healing builds.",
        },

    },

}

