local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Stats = Deathless.Data.Stats or {}

-- See https://www.wowhead.com/classic/guide/classic-wow-stats-and-attributes-overview
Deathless.Data.Stats.Paladin = {
    primary = {
        {
            stat = "Agility",
            bonus = "1% critical strike chance per 20 Agility, 2 Armor per 1 Agility, 1% dodge per 20 Agility.",
            priority = "Low",
            note = "Minor crit and armor contribution, but Strength and Stamina are preferred.",
        },
        {
            stat = "Intellect",
            bonus = "15 Mana per 1 Intellect, and 1% spell critical strike chance per 54 Intellect.",
            priority = "High (Healer) / Medium (Ret / Prot)",
            note = "Expands mana pool for heals, Judgements, and blessings; core stat for Holy.",
        },
        {
            stat = "Spirit",
            bonus = "Increases mana regeneration while not casting spells by (Spirit / 5 + 15) per 5 seconds.",
            priority = "Low",
            note = "Paladins have poor Spirit scaling; mana sustain comes from Intellect, Mp5, and Illumination procs.",
        },
        {
            stat = "Stamina",
            bonus = "10 health per 1 Stamina.",
            priority = "High",
            note = "Primary Hardcore survivability and tanking stat.",
        },
        {
            stat = "Strength",
            bonus = "2 melee AP per 1 Strength, and chance to block 1 damage per 20 Strength.",
            priority = "High (Ret / Prot)",
            note = "Core stat for melee DPS, threat, and Seal/Judgement damage.",
        },
    },
    secondary = {
        {
            stat = "Armor",
            bonus = "Mitigates a % of incoming physical damage.",
            priority = "High (Prot)",
            note = "Important tanking stat; Paladins wear plate at 40+.",
        },
        {
            stat = "Block %",
            bonus = "Increases % chance to block a melee attack.",
            priority = "Medium (Prot)",
            note = "Useful with Holy Shield and Redoubt talents for Protection Paladins.",
        },
        {
            stat = "Block Value",
            bonus = "Flat physical damage prevented on successful blocks.",
            priority = "Medium (Prot)",
            note = "Synergizes with Holy Shield and high block % for smooth damage intake.",
        },
        {
            stat = "Crit %",
            bonus = "Increases % chance for a melee attack to crit.",
            priority = "High (Ret)",
            note = "Strong for Retribution DPS and Reckoning procs.",
        },
        {
            stat = "Defense",
            bonus = "Each point gives 0.04% to dodge, parry, block, and reduces your chance to be hit or crit by 0.04%.",
            priority = "High (Prot at 60)",
            note = "Required for raid tanking and level 60 content.",
        },
        {
            stat = "Healing Power",
            bonus = "Increase the amount of healing done by your spells.",
            priority = "High (Healer)",
            note = "Core throughput stat for Holy Paladins.",
        },
        {
            stat = "Mana / 5 Seconds",
            bonus = "Mana restored every 5 seconds, including while casting (stacks with other regen).",
            priority = "High (Healer)",
            note = "Primary sustain stat for Holy Paladins since Spirit scaling is weak.",
        },
        {
            stat = "Spell Critical Strike Chance",
            bonus = "Increases the chance for your spells to critically hit.",
            priority = "High (Healer)",
            note = "Illumination refunds mana on Holy crit heals, making spell crit a sustain stat.",
        },
        {
            stat = "Weapon Skill",
            bonus = "Each point increases your chance to hit or crit an enemy by 0.04%, and reduces enemy chance to dodge, parry, or block your attack by 0.04%.",
            priority = "Medium (Ret / Prot)",
            note = "Useful for consistent melee damage and threat generation.",
        },
    },
}
