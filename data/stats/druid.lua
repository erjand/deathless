local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Stats = Deathless.Data.Stats or {}

-- See https://www.wowhead.com/classic/guide/classic-wow-stats-and-attributes-overview
Deathless.Data.Stats.Druid = {
    primary = {
        {
            stat = "Agility",
            bonus = "1% critical strike chance per 20 Agility, 2 Armor per 1 Agility, and 1% dodge per 20 Agility, 1 melee AP per Agility in Cat Form.",
            priority = "High (Feral)",
            note = "Core Feral stat for crit and dodge; also multiplied by Bear Form's armor bonus.",
        },
        {
            stat = "Intellect",
            bonus = "15 Mana per 1 Intellect, and 1% spell critical strike chance per 60 Intellect.",
            priority = "High (Caster / Healer)",
            note = "Primary stat for Balance and Restoration mana pool and spell crit.",
        },
        {
            stat = "Spirit",
            bonus = "Increases mana regeneration while not casting spells by (Spirit / 4 + 12.5) per 5 seconds.",
            priority = "High (Caster / Healer)",
            note = "Strong regen stat for caster and healer Druids; less relevant for Feral.",
        },
        {
            stat = "Stamina",
            bonus = "10 health per 1 Stamina.",
            priority = "High",
            note = "Important for all specs; especially strong in Bear Form for tanking and Hardcore survivability.",
        },
        {
            stat = "Strength",
            bonus = "2 melee AP per 1 Strength in Cat/Bear Form.",
            priority = "Medium (Feral)",
            note = "Solid Feral DPS and threat stat, but Agility generally provides more per point.",
        },
    },
    secondary = {
        {
            stat = "Armor",
            bonus = "Mitigates a % of incoming physical damage.",
            priority = "High (Bear)",
            note = "Bear Form multiplies item armor; stacking armor makes Druids very durable tanks.",
        },
        {
            stat = "Crit %",
            bonus = "Increases % chance for a melee attack to crit.",
            priority = "High (Feral)",
            note = "Strong for Cat DPS and Bear threat generation.",
        },
        {
            stat = "Healing Power",
            bonus = "Increase the amount of healing done by your spells.",
            priority = "High (Healer)",
            note = "Core throughput stat for Restoration Druids.",
        },
        {
            stat = "Hit %",
            bonus = "Increases % chance for a melee attack to hit.",
            priority = "High (Feral)",
            note = "Important for consistent Feral damage and energy efficiency.",
        },
        {
            stat = "Mana / 5 Seconds",
            bonus = "Mana restored every 5 seconds, including while casting (stacks with other regen).",
            priority = "High (Healer)",
            note = "Valuable for Restoration Druids to sustain healing through long fights.",
        },
        {
            stat = "Movement Speed",
            bonus = "Improves character run and walk speed.",
            priority = "Medium",
            note = "Great quality-of-life; stacks with Travel Form for overworld speed.",
        },
        {
            stat = "Spell Critical Strike Chance",
            bonus = "Increases the chance for your spells to critically hit.",
            priority = "Medium (Caster / Healer)",
            note = "Useful for Balance burst and healing throughput.",
        },
        {
            stat = "Spell Hit Chance",
            bonus = "Reduces the chance for enemies to resist your spells or for your spells to miss.",
            priority = "High (Balance)",
            note = "Essential for Balance DPS to reach hit cap in level 60 content.",
        },
        {
            stat = "Spell Power (Damage)",
            bonus = "Increase the amount of damage dealt by your spells.",
            priority = "High (Balance)",
            note = "Primary throughput stat for Balance Druids.",
        },
        {
            stat = "Weapon Skill",
            bonus = "None.",
            priority = "None",
            note = "Does not apply to Feral attacks; weapons are purely stat-sticks for Feral Druids.",
        },
    },
}
