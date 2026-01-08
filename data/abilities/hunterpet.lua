-- TODO: WIP / draft

local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.PetAbilities = Deathless.Data.PetAbilities or {}

-- Pet abilities are learned by taming beasts that know the ability, then teaching it to your pet
-- Training cost is in training points, not copper
-- Pet level indicates the minimum pet level required to learn the ability
-- Source types:
--   tame    - Learned by taming a beast with this ability
--   innate  - All pets have this ability automatically
-- Train values:
--   yes   - Important for survival/damage
--   wait  - Situational or lower priority
--   no    - Generally not useful for Hardcore
-- Sorted alphabetically by name, then by rank
-- See https://www.wowhead.com/classic/hunter-pets for source data

Deathless.Data.PetAbilities["HunterPet"] = {
    -- Bite (learned from: boars, bears, wolves, hyenas, crocolisks, gorillas, etc.)
    { name = "Bite", level = 1, rank = 1, training_cost = 1, icon = "Ability_Druid_FerociousBite", source = "tame", train = "yes", spellId = 17253 },
    { name = "Bite", level = 8, rank = 2, training_cost = 4, icon = "Ability_Druid_FerociousBite", source = "tame", train = "yes", spellId = 17255 },
    { name = "Bite", level = 16, rank = 3, training_cost = 7, icon = "Ability_Druid_FerociousBite", source = "tame", train = "yes", spellId = 17256 },
    { name = "Bite", level = 24, rank = 4, training_cost = 10, icon = "Ability_Druid_FerociousBite", source = "tame", train = "yes", spellId = 17257 },
    { name = "Bite", level = 32, rank = 5, training_cost = 13, icon = "Ability_Druid_FerociousBite", source = "tame", train = "yes", spellId = 17258 },
    { name = "Bite", level = 40, rank = 6, training_cost = 16, icon = "Ability_Druid_FerociousBite", source = "tame", train = "yes", spellId = 17259 },
    { name = "Bite", level = 48, rank = 7, training_cost = 19, icon = "Ability_Druid_FerociousBite", source = "tame", train = "yes", spellId = 17260 },
    { name = "Bite", level = 56, rank = 8, training_cost = 22, icon = "Ability_Druid_FerociousBite", source = "tame", train = "yes", spellId = 17261 },

    -- Charge (learned from: boars)
    { name = "Charge", level = 1, rank = 1, training_cost = 5, icon = "Ability_Warrior_Charge", source = "tame", train = "yes", spellId = 7371 },
    { name = "Charge", level = 12, rank = 2, training_cost = 10, icon = "Ability_Warrior_Charge", source = "tame", train = "yes", spellId = 26177 },
    { name = "Charge", level = 24, rank = 3, training_cost = 15, icon = "Ability_Warrior_Charge", source = "tame", train = "yes", spellId = 26178 },
    { name = "Charge", level = 36, rank = 4, training_cost = 20, icon = "Ability_Warrior_Charge", source = "tame", train = "yes", spellId = 26179 },
    { name = "Charge", level = 48, rank = 5, training_cost = 25, icon = "Ability_Warrior_Charge", source = "tame", train = "yes", spellId = 26201 },
    { name = "Charge", level = 60, rank = 6, training_cost = 30, icon = "Ability_Warrior_Charge", source = "tame", train = "yes", spellId = 26202 },

    -- Claw (learned from: cats, bears, raptors, scorpids, owls, carrion birds, etc.)
    { name = "Claw", level = 1, rank = 1, training_cost = 1, icon = "Ability_Druid_Rake", source = "tame", train = "yes", spellId = 16827 },
    { name = "Claw", level = 8, rank = 2, training_cost = 4, icon = "Ability_Druid_Rake", source = "tame", train = "yes", spellId = 16828 },
    { name = "Claw", level = 16, rank = 3, training_cost = 7, icon = "Ability_Druid_Rake", source = "tame", train = "yes", spellId = 16829 },
    { name = "Claw", level = 24, rank = 4, training_cost = 10, icon = "Ability_Druid_Rake", source = "tame", train = "yes", spellId = 16830 },
    { name = "Claw", level = 32, rank = 5, training_cost = 13, icon = "Ability_Druid_Rake", source = "tame", train = "yes", spellId = 16831 },
    { name = "Claw", level = 40, rank = 6, training_cost = 16, icon = "Ability_Druid_Rake", source = "tame", train = "yes", spellId = 16832 },
    { name = "Claw", level = 48, rank = 7, training_cost = 19, icon = "Ability_Druid_Rake", source = "tame", train = "yes", spellId = 3009 },
    { name = "Claw", level = 56, rank = 8, training_cost = 22, icon = "Ability_Druid_Rake", source = "tame", train = "yes", spellId = 3010 },

    -- Cower (all pets can learn)
    { name = "Cower", level = 5, rank = 1, training_cost = 10, icon = "Ability_Druid_Cower", source = "tame", train = "wait", spellId = 4187 },
    { name = "Cower", level = 15, rank = 2, training_cost = 15, icon = "Ability_Druid_Cower", source = "tame", train = "wait", spellId = 4188 },
    { name = "Cower", level = 25, rank = 3, training_cost = 20, icon = "Ability_Druid_Cower", source = "tame", train = "wait", spellId = 4189 },
    { name = "Cower", level = 35, rank = 4, training_cost = 25, icon = "Ability_Druid_Cower", source = "tame", train = "wait", spellId = 4190 },
    { name = "Cower", level = 45, rank = 5, training_cost = 30, icon = "Ability_Druid_Cower", source = "tame", train = "wait", spellId = 4191 },
    { name = "Cower", level = 55, rank = 6, training_cost = 35, icon = "Ability_Druid_Cower", source = "tame", train = "wait", spellId = 4192 },

    -- Dash (learned from: cats, wolves, boars)
    { name = "Dash", level = 20, rank = 1, training_cost = 15, icon = "Ability_Hunter_Pet_Cat", source = "tame", train = "yes", spellId = 23099 },
    { name = "Dash", level = 40, rank = 2, training_cost = 20, icon = "Ability_Hunter_Pet_Cat", source = "tame", train = "yes", spellId = 23109 },
    { name = "Dash", level = 60, rank = 3, training_cost = 25, icon = "Ability_Hunter_Pet_Cat", source = "tame", train = "yes", spellId = 23110 },

    -- Dive (learned from: bats, owls, carrion birds, wind serpents)
    { name = "Dive", level = 20, rank = 1, training_cost = 15, icon = "Spell_Shadow_BurningSpirit", source = "tame", train = "yes", spellId = 23145 },
    { name = "Dive", level = 40, rank = 2, training_cost = 20, icon = "Spell_Shadow_BurningSpirit", source = "tame", train = "yes", spellId = 23147 },
    { name = "Dive", level = 60, rank = 3, training_cost = 25, icon = "Spell_Shadow_BurningSpirit", source = "tame", train = "yes", spellId = 23148 },

    -- Furious Howl (learned from: wolves)
    { name = "Furious Howl", level = 10, rank = 1, training_cost = 10, icon = "Ability_Hunter_Pet_Wolf", source = "tame", train = "yes", spellId = 24604 },
    { name = "Furious Howl", level = 24, rank = 2, training_cost = 15, icon = "Ability_Hunter_Pet_Wolf", source = "tame", train = "yes", spellId = 24605 },
    { name = "Furious Howl", level = 40, rank = 3, training_cost = 20, icon = "Ability_Hunter_Pet_Wolf", source = "tame", train = "yes", spellId = 24603 },
    { name = "Furious Howl", level = 56, rank = 4, training_cost = 25, icon = "Ability_Hunter_Pet_Wolf", source = "tame", train = "yes", spellId = 24597 },

    -- Growl (all pets have - innate taunt ability)
    { name = "Growl", level = 1, rank = 1, training_cost = 0, icon = "Ability_Physical_Taunt", source = "innate", train = "yes", spellId = 2649 },
    { name = "Growl", level = 10, rank = 2, training_cost = 5, icon = "Ability_Physical_Taunt", source = "tame", train = "yes", spellId = 14916 },
    { name = "Growl", level = 20, rank = 3, training_cost = 10, icon = "Ability_Physical_Taunt", source = "tame", train = "yes", spellId = 14917 },
    { name = "Growl", level = 30, rank = 4, training_cost = 15, icon = "Ability_Physical_Taunt", source = "tame", train = "yes", spellId = 14918 },
    { name = "Growl", level = 40, rank = 5, training_cost = 20, icon = "Ability_Physical_Taunt", source = "tame", train = "yes", spellId = 14919 },
    { name = "Growl", level = 50, rank = 6, training_cost = 25, icon = "Ability_Physical_Taunt", source = "tame", train = "yes", spellId = 14920 },
    { name = "Growl", level = 60, rank = 7, training_cost = 30, icon = "Ability_Physical_Taunt", source = "tame", train = "yes", spellId = 14921 },

    -- Lightning Breath (learned from: wind serpents)
    { name = "Lightning Breath", level = 1, rank = 1, training_cost = 10, icon = "Spell_Nature_Lightning", source = "tame", train = "yes", spellId = 24844 },
    { name = "Lightning Breath", level = 12, rank = 2, training_cost = 15, icon = "Spell_Nature_Lightning", source = "tame", train = "yes", spellId = 25008 },
    { name = "Lightning Breath", level = 24, rank = 3, training_cost = 20, icon = "Spell_Nature_Lightning", source = "tame", train = "yes", spellId = 25009 },
    { name = "Lightning Breath", level = 36, rank = 4, training_cost = 25, icon = "Spell_Nature_Lightning", source = "tame", train = "yes", spellId = 25010 },
    { name = "Lightning Breath", level = 48, rank = 5, training_cost = 30, icon = "Spell_Nature_Lightning", source = "tame", train = "yes", spellId = 25011 },
    { name = "Lightning Breath", level = 60, rank = 6, training_cost = 35, icon = "Spell_Nature_Lightning", source = "tame", train = "yes", spellId = 25012 },

    -- Prowl (learned from: cats)
    { name = "Prowl", level = 30, rank = 1, training_cost = 15, icon = "Ability_Ambush", source = "tame", train = "wait", spellId = 24450 },
    { name = "Prowl", level = 40, rank = 2, training_cost = 20, icon = "Ability_Ambush", source = "tame", train = "wait", spellId = 24452 },
    { name = "Prowl", level = 50, rank = 3, training_cost = 25, icon = "Ability_Ambush", source = "tame", train = "wait", spellId = 24453 },

    -- Scorpid Poison (learned from: scorpids)
    { name = "Scorpid Poison", level = 8, rank = 1, training_cost = 10, icon = "Ability_PoisonSting", source = "tame", train = "yes", spellId = 24583 },
    { name = "Scorpid Poison", level = 16, rank = 2, training_cost = 15, icon = "Ability_PoisonSting", source = "tame", train = "yes", spellId = 24586 },
    { name = "Scorpid Poison", level = 24, rank = 3, training_cost = 20, icon = "Ability_PoisonSting", source = "tame", train = "yes", spellId = 24587 },
    { name = "Scorpid Poison", level = 32, rank = 4, training_cost = 25, icon = "Ability_PoisonSting", source = "tame", train = "yes", spellId = 24588 },
    { name = "Scorpid Poison", level = 40, rank = 5, training_cost = 30, icon = "Ability_PoisonSting", source = "tame", train = "yes", spellId = 24589 },

    -- Screech (learned from: bats, carrion birds, owls)
    { name = "Screech", level = 8, rank = 1, training_cost = 5, icon = "Spell_Shadow_Cripple", source = "tame", train = "yes", spellId = 24580 },
    { name = "Screech", level = 16, rank = 2, training_cost = 10, icon = "Spell_Shadow_Cripple", source = "tame", train = "yes", spellId = 24581 },
    { name = "Screech", level = 24, rank = 3, training_cost = 15, icon = "Spell_Shadow_Cripple", source = "tame", train = "yes", spellId = 24578 },
    { name = "Screech", level = 32, rank = 4, training_cost = 20, icon = "Spell_Shadow_Cripple", source = "tame", train = "yes", spellId = 24579 },

    -- Shell Shield (learned from: turtles)
    { name = "Shell Shield", level = 20, rank = 1, training_cost = 10, icon = "Ability_Defend", source = "tame", train = "yes", spellId = 26064 },

    -- Thunderstomp (learned from: gorillas)
    { name = "Thunderstomp", level = 30, rank = 1, training_cost = 10, icon = "Spell_Nature_ThunderClap", source = "tame", train = "yes", spellId = 26090 },
    { name = "Thunderstomp", level = 40, rank = 2, training_cost = 15, icon = "Spell_Nature_ThunderClap", source = "tame", train = "yes", spellId = 26094 },
    { name = "Thunderstomp", level = 50, rank = 3, training_cost = 20, icon = "Spell_Nature_ThunderClap", source = "tame", train = "yes", spellId = 26188 },
}

-- Also store the spell ID lookup for quick reference
Deathless.Data.PetAbilityIds = {}
for _, ability in ipairs(Deathless.Data.PetAbilities["HunterPet"]) do
    Deathless.Data.PetAbilityIds[ability.spellId] = true
end
