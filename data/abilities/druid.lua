local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Abilities = Deathless.Data.Abilities or {}

-- base_cost is stored in copper (1 silver = 100 copper, 1 gold = 10000 copper)
-- Actual cost may be reduced by reputation discounts (5% honored, 10% revered, 15% exalted)
-- Source types:
--   trainer - Learned from class trainer
--   talent  - Requires talent (only shown if base talent is learned)
--   class   - Innate class ability (learned automatically)
--   book    - Learned from a drop/item
--   quest   - Learned from completing a quest
-- Train values:
--   yes   - Important ability, train all ranks
--   wait  - Marginal upgrade, can delay
--   no    - Not useful for Hardcore
-- Sorted alphabetically by name, then by rank
-- See https://www.wowhead.com/classic/spells/abilities/druid for source data
-- See https://www.wowhead.com/classic/npc=4217/mathrengyl-bearwalker for training costs
Deathless.Data.Abilities["Druid"] = {
    -- Abolish Poison
    { name = "Abolish Poison", level = 26, rank = 1, base_cost = 4500, icon = "Spell_Nature_NullifyPoison_02", source = "trainer", train = "yes", spellId = 2893 },

    -- Aquatic Form (quest)
    { name = "Aquatic Form", level = 16, rank = 1, base_cost = 0, icon = "Ability_Druid_AquaticForm", source = "quest", train = "yes", spellId = 1066 },

    -- Barkskin
    { name = "Barkskin", level = 44, rank = 1, base_cost = 18000, icon = "Spell_Nature_StoneClawTotem", source = "trainer", train = "yes", spellId = 22812 },

    -- Bash (Bear Form)
    { name = "Bash", level = 14, rank = 1, base_cost = 900, icon = "Ability_Druid_Bash", source = "trainer", train = "yes", spellId = 5211 },
    { name = "Bash", level = 30, rank = 2, base_cost = 6000, icon = "Ability_Druid_Bash", source = "trainer", train = "yes", spellId = 6798 },
    { name = "Bash", level = 46, rank = 3, base_cost = 20000, icon = "Ability_Druid_Bash", source = "trainer", train = "yes", spellId = 8983 },

    -- Bear Form (quest at level 10)
    { name = "Bear Form", level = 10, rank = 1, base_cost = 0, icon = "Ability_Racial_BearForm", source = "quest", train = "yes", spellId = 5487 },

    -- Cat Form
    { name = "Cat Form", level = 20, rank = 1, base_cost = 2000, icon = "Ability_Druid_CatForm", source = "trainer", train = "yes", spellId = 768 },

    -- Challenging Roar (Bear Form)
    { name = "Challenging Roar", level = 28, rank = 1, base_cost = 5000, icon = "Ability_Druid_ChallangingRoar", source = "trainer", train = "yes", spellId = 5209 },

    -- Claw (Cat Form)
    { name = "Claw", level = 20, rank = 1, base_cost = 2000, icon = "Ability_Druid_Rake", source = "trainer", train = "yes", spellId = 1082 },
    { name = "Claw", level = 28, rank = 2, base_cost = 5000, icon = "Ability_Druid_Rake", source = "trainer", train = "yes", spellId = 3029 },
    { name = "Claw", level = 38, rank = 3, base_cost = 12000, icon = "Ability_Druid_Rake", source = "trainer", train = "yes", spellId = 5201 },
    { name = "Claw", level = 48, rank = 4, base_cost = 22000, icon = "Ability_Druid_Rake", source = "trainer", train = "yes", spellId = 9849 },
    { name = "Claw", level = 58, rank = 5, base_cost = 32000, icon = "Ability_Druid_Rake", source = "trainer", train = "yes", spellId = 9850 },

    -- Cower (Cat Form)
    { name = "Cower", level = 28, rank = 1, base_cost = 5000, icon = "Ability_Druid_Cower", source = "trainer", train = "yes", spellId = 8998 },
    { name = "Cower", level = 40, rank = 2, base_cost = 14000, icon = "Ability_Druid_Cower", source = "trainer", train = "yes", spellId = 9000 },
    { name = "Cower", level = 52, rank = 3, base_cost = 26000, icon = "Ability_Druid_Cower", source = "trainer", train = "yes", spellId = 9892 },

    -- Cure Poison
    { name = "Cure Poison", level = 14, rank = 1, base_cost = 0, icon = "Spell_Nature_NullifyPoison", source = "quest", train = "yes", spellId = 8946 },

    -- Dash (Cat Form)
    { name = "Dash", level = 26, rank = 1, base_cost = 4500, icon = "Ability_Druid_Dash", source = "trainer", train = "yes", spellId = 1850 },
    { name = "Dash", level = 46, rank = 2, base_cost = 20000, icon = "Ability_Druid_Dash", source = "trainer", train = "yes", spellId = 9821 },

    -- Demoralizing Roar (Bear Form)
    { name = "Demoralizing Roar", level = 10, rank = 1, base_cost = 300, icon = "Ability_Druid_DemoralizingRoar", source = "trainer", train = "yes", spellId = 99 },
    { name = "Demoralizing Roar", level = 20, rank = 2, base_cost = 2000, icon = "Ability_Druid_DemoralizingRoar", source = "trainer", train = "yes", spellId = 1735 },
    { name = "Demoralizing Roar", level = 32, rank = 3, base_cost = 8000, icon = "Ability_Druid_DemoralizingRoar", source = "trainer", train = "yes", spellId = 9490 },
    { name = "Demoralizing Roar", level = 42, rank = 4, base_cost = 16000, icon = "Ability_Druid_DemoralizingRoar", source = "trainer", train = "yes", spellId = 9747 },
    { name = "Demoralizing Roar", level = 52, rank = 5, base_cost = 26000, icon = "Ability_Druid_DemoralizingRoar", source = "trainer", train = "yes", spellId = 9898 },

    -- Dire Bear Form
    { name = "Dire Bear Form", level = 40, rank = 1, base_cost = 14000, icon = "Ability_Racial_BearForm", source = "trainer", train = "yes", spellId = 9634 },

    -- Enrage (Bear Form)
    { name = "Enrage", level = 12, rank = 1, base_cost = 800, icon = "Ability_Druid_Enrage", source = "trainer", train = "yes", spellId = 5229 },

    -- Entangling Roots
    { name = "Entangling Roots", level = 8, rank = 1, base_cost = 200, icon = "Spell_Nature_StrangleVines", source = "trainer", train = "yes", spellId = 339 },
    { name = "Entangling Roots", level = 18, rank = 2, base_cost = 1900, icon = "Spell_Nature_StrangleVines", source = "trainer", train = "yes", spellId = 1062 },
    { name = "Entangling Roots", level = 28, rank = 3, base_cost = 5000, icon = "Spell_Nature_StrangleVines", source = "trainer", train = "yes", spellId = 5195 },
    { name = "Entangling Roots", level = 38, rank = 4, base_cost = 12000, icon = "Spell_Nature_StrangleVines", source = "trainer", train = "yes", spellId = 5196 },
    { name = "Entangling Roots", level = 48, rank = 5, base_cost = 22000, icon = "Spell_Nature_StrangleVines", source = "trainer", train = "yes", spellId = 9852 },
    { name = "Entangling Roots", level = 58, rank = 6, base_cost = 32000, icon = "Spell_Nature_StrangleVines", source = "trainer", train = "yes", spellId = 9853 },

    -- Faerie Fire
    { name = "Faerie Fire", level = 18, rank = 1, base_cost = 1900, icon = "Spell_Nature_FaerieFire", source = "trainer", train = "yes", spellId = 770 },
    { name = "Faerie Fire", level = 30, rank = 2, base_cost = 6000, icon = "Spell_Nature_FaerieFire", source = "trainer", train = "yes", spellId = 778 },
    { name = "Faerie Fire", level = 42, rank = 3, base_cost = 16000, icon = "Spell_Nature_FaerieFire", source = "trainer", train = "yes", spellId = 9749 },
    { name = "Faerie Fire", level = 54, rank = 4, base_cost = 28000, icon = "Spell_Nature_FaerieFire", source = "trainer", train = "yes", spellId = 9907 },

    -- Faerie Fire (Feral) (21-point Feral talent)
    { name = "Faerie Fire (Feral)", level = 30, rank = 1, base_cost = 0, icon = "Spell_Nature_FaerieFire", source = "talent", train = "yes", spellId = 16857 },
    { name = "Faerie Fire (Feral)", level = 30, rank = 2, base_cost = 300, icon = "Spell_Nature_FaerieFire", source = "talent", train = "yes", spellId = 17390 },
    { name = "Faerie Fire (Feral)", level = 42, rank = 3, base_cost = 800, icon = "Spell_Nature_FaerieFire", source = "talent", train = "yes", spellId = 17391 },
    { name = "Faerie Fire (Feral)", level = 54, rank = 4, base_cost = 1400, icon = "Spell_Nature_FaerieFire", source = "talent", train = "yes", spellId = 17392 },

    -- Feline Grace (Cat Form)
    { name = "Feline Grace", level = 40, rank = 1, base_cost = 14000, icon = "INV_Feather_01", source = "trainer", train = "yes", spellId = 20719 },

    -- Ferocious Bite (Cat Form)
    { name = "Ferocious Bite", level = 32, rank = 1, base_cost = 8000, icon = "Ability_Druid_FerociousBite", source = "trainer", train = "yes", spellId = 22568 },
    { name = "Ferocious Bite", level = 40, rank = 2, base_cost = 14000, icon = "Ability_Druid_FerociousBite", source = "trainer", train = "yes", spellId = 22827 },
    { name = "Ferocious Bite", level = 48, rank = 3, base_cost = 22000, icon = "Ability_Druid_FerociousBite", source = "trainer", train = "yes", spellId = 22828 },
    { name = "Ferocious Bite", level = 56, rank = 4, base_cost = 30000, icon = "Ability_Druid_FerociousBite", source = "trainer", train = "yes", spellId = 22829 },
    { name = "Ferocious Bite", level = 60, rank = 5, base_cost = 0, icon = "Ability_Druid_FerociousBite", source = "book", train = "yes", spellId = 31018 },

    -- Frenzied Regeneration (Bear Form)
    { name = "Frenzied Regeneration", level = 36, rank = 1, base_cost = 11000, icon = "Ability_BullRush", source = "trainer", train = "yes", spellId = 22842 },
    { name = "Frenzied Regeneration", level = 46, rank = 2, base_cost = 20000, icon = "Ability_BullRush", source = "trainer", train = "yes", spellId = 22895 },
    { name = "Frenzied Regeneration", level = 56, rank = 3, base_cost = 30000, icon = "Ability_BullRush", source = "trainer", train = "yes", spellId = 22896 },

    -- Gift of the Wild (book)
    { name = "Gift of the Wild", level = 50, rank = 1, base_cost = 0, icon = "Spell_Nature_Regeneration", source = "book", train = "yes", spellId = 21849 },
    { name = "Gift of the Wild", level = 60, rank = 2, base_cost = 0, icon = "Spell_Nature_Regeneration", source = "book", train = "yes", spellId = 21850 },

    -- Healing Touch
    { name = "Healing Touch", level = 1, rank = 1, base_cost = 0, icon = "Spell_Nature_HealingTouch", source = "class", train = "yes", spellId = 5185 },
    { name = "Healing Touch", level = 8, rank = 2, base_cost = 200, icon = "Spell_Nature_HealingTouch", source = "trainer", train = "yes", spellId = 5186 },
    { name = "Healing Touch", level = 14, rank = 3, base_cost = 900, icon = "Spell_Nature_HealingTouch", source = "trainer", train = "yes", spellId = 5187 },
    { name = "Healing Touch", level = 20, rank = 4, base_cost = 2000, icon = "Spell_Nature_HealingTouch", source = "trainer", train = "yes", spellId = 5188 },
    { name = "Healing Touch", level = 26, rank = 5, base_cost = 4500, icon = "Spell_Nature_HealingTouch", source = "trainer", train = "yes", spellId = 5189 },
    { name = "Healing Touch", level = 32, rank = 6, base_cost = 8000, icon = "Spell_Nature_HealingTouch", source = "trainer", train = "yes", spellId = 6778 },
    { name = "Healing Touch", level = 38, rank = 7, base_cost = 12000, icon = "Spell_Nature_HealingTouch", source = "trainer", train = "yes", spellId = 8903 },
    { name = "Healing Touch", level = 44, rank = 8, base_cost = 18000, icon = "Spell_Nature_HealingTouch", source = "trainer", train = "yes", spellId = 9758 },
    { name = "Healing Touch", level = 50, rank = 9, base_cost = 23000, icon = "Spell_Nature_HealingTouch", source = "trainer", train = "yes", spellId = 9888 },
    { name = "Healing Touch", level = 56, rank = 10, base_cost = 30000, icon = "Spell_Nature_HealingTouch", source = "trainer", train = "yes", spellId = 9889 },
    { name = "Healing Touch", level = 60, rank = 11, base_cost = 0, icon = "Spell_Nature_HealingTouch", source = "book", train = "yes", spellId = 25297 },

    -- Hibernate
    { name = "Hibernate", level = 18, rank = 1, base_cost = 1900, icon = "Spell_Nature_Sleep", source = "trainer", train = "yes", spellId = 2637 },
    { name = "Hibernate", level = 38, rank = 2, base_cost = 12000, icon = "Spell_Nature_Sleep", source = "trainer", train = "yes", spellId = 18657 },
    { name = "Hibernate", level = 58, rank = 3, base_cost = 32000, icon = "Spell_Nature_Sleep", source = "trainer", train = "yes", spellId = 18658 },

    -- Hurricane
    { name = "Hurricane", level = 40, rank = 1, base_cost = 14000, icon = "Spell_Nature_Cyclone", source = "trainer", train = "yes", spellId = 16914 },
    { name = "Hurricane", level = 50, rank = 2, base_cost = 23000, icon = "Spell_Nature_Cyclone", source = "trainer", train = "yes", spellId = 17401 },
    { name = "Hurricane", level = 60, rank = 3, base_cost = 34000, icon = "Spell_Nature_Cyclone", source = "trainer", train = "yes", spellId = 17402 },

    -- Innervate
    { name = "Innervate", level = 40, rank = 1, base_cost = 14000, icon = "Spell_Nature_Lightning", source = "trainer", train = "yes", spellId = 29166 },

    -- Insect Swarm (Balance 21-point talent)
    { name = "Insect Swarm", level = 30, rank = 1, base_cost = 0, icon = "Spell_Nature_InsectSwarm", source = "talent", train = "yes", spellId = 5570 },
    { name = "Insect Swarm", level = 30, rank = 2, base_cost = 300, icon = "Spell_Nature_InsectSwarm", source = "talent", train = "yes", spellId = 24974 },
    { name = "Insect Swarm", level = 40, rank = 3, base_cost = 700, icon = "Spell_Nature_InsectSwarm", source = "talent", train = "yes", spellId = 24975 },
    { name = "Insect Swarm", level = 50, rank = 4, base_cost = 1150, icon = "Spell_Nature_InsectSwarm", source = "talent", train = "yes", spellId = 24976 },
    { name = "Insect Swarm", level = 60, rank = 5, base_cost = 1700, icon = "Spell_Nature_InsectSwarm", source = "talent", train = "yes", spellId = 24977 },

    -- Mark of the Wild
    { name = "Mark of the Wild", level = 1, rank = 1, base_cost = 10, icon = "Spell_Nature_Regeneration", source = "trainer", train = "yes", spellId = 1126 },
    { name = "Mark of the Wild", level = 10, rank = 2, base_cost = 300, icon = "Spell_Nature_Regeneration", source = "trainer", train = "yes", spellId = 5232 },
    { name = "Mark of the Wild", level = 20, rank = 3, base_cost = 2000, icon = "Spell_Nature_Regeneration", source = "trainer", train = "yes", spellId = 6756 },
    { name = "Mark of the Wild", level = 30, rank = 4, base_cost = 6000, icon = "Spell_Nature_Regeneration", source = "trainer", train = "yes", spellId = 5234 },
    { name = "Mark of the Wild", level = 40, rank = 5, base_cost = 14000, icon = "Spell_Nature_Regeneration", source = "trainer", train = "yes", spellId = 8907 },
    { name = "Mark of the Wild", level = 50, rank = 6, base_cost = 23000, icon = "Spell_Nature_Regeneration", source = "trainer", train = "yes", spellId = 9884 },
    { name = "Mark of the Wild", level = 60, rank = 7, base_cost = 34000, icon = "Spell_Nature_Regeneration", source = "trainer", train = "yes", spellId = 9885 },

    -- Maul (Bear Form)
    { name = "Maul", level = 10, rank = 1, base_cost = 0, icon = "Ability_Druid_Maul", source = "quest", train = "yes", spellId = 6807 },
    { name = "Maul", level = 18, rank = 2, base_cost = 1900, icon = "Ability_Druid_Maul", source = "trainer", train = "yes", spellId = 6808 },
    { name = "Maul", level = 26, rank = 3, base_cost = 4500, icon = "Ability_Druid_Maul", source = "trainer", train = "yes", spellId = 6809 },
    { name = "Maul", level = 34, rank = 4, base_cost = 10000, icon = "Ability_Druid_Maul", source = "trainer", train = "yes", spellId = 8972 },
    { name = "Maul", level = 42, rank = 5, base_cost = 16000, icon = "Ability_Druid_Maul", source = "trainer", train = "yes", spellId = 9745 },
    { name = "Maul", level = 50, rank = 6, base_cost = 23000, icon = "Ability_Druid_Maul", source = "trainer", train = "yes", spellId = 9880 },
    { name = "Maul", level = 58, rank = 7, base_cost = 32000, icon = "Ability_Druid_Maul", source = "trainer", train = "yes", spellId = 9881 },

    -- Moonfire
    { name = "Moonfire", level = 4, rank = 1, base_cost = 100, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 8921 },
    { name = "Moonfire", level = 10, rank = 2, base_cost = 300, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 8924 },
    { name = "Moonfire", level = 16, rank = 3, base_cost = 1800, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 8925 },
    { name = "Moonfire", level = 22, rank = 4, base_cost = 3000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 8926 },
    { name = "Moonfire", level = 28, rank = 5, base_cost = 5000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 8927 },
    { name = "Moonfire", level = 34, rank = 6, base_cost = 10000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 8928 },
    { name = "Moonfire", level = 40, rank = 7, base_cost = 14000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 8929 },
    { name = "Moonfire", level = 46, rank = 8, base_cost = 20000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 9833 },
    { name = "Moonfire", level = 52, rank = 9, base_cost = 26000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 9834 },
    { name = "Moonfire", level = 58, rank = 10, base_cost = 32000, icon = "Spell_Nature_StarFall", source = "trainer", train = "yes", spellId = 9835 },

    -- Nature's Grasp (Balance 11-point talent)
    { name = "Nature's Grasp", level = 20, rank = 1, base_cost = 0, icon = "Spell_Nature_NaturesWrath", source = "talent", train = "yes", spellId = 16689 },
    { name = "Nature's Grasp", level = 18, rank = 2, base_cost = 95, icon = "Spell_Nature_NaturesWrath", source = "talent", train = "yes", spellId = 16810 },
    { name = "Nature's Grasp", level = 28, rank = 3, base_cost = 250, icon = "Spell_Nature_NaturesWrath", source = "talent", train = "yes", spellId = 16811 },
    { name = "Nature's Grasp", level = 38, rank = 4, base_cost = 600, icon = "Spell_Nature_NaturesWrath", source = "talent", train = "yes", spellId = 16812 },
    { name = "Nature's Grasp", level = 48, rank = 5, base_cost = 1100, icon = "Spell_Nature_NaturesWrath", source = "talent", train = "yes", spellId = 16813 },
    { name = "Nature's Grasp", level = 58, rank = 6, base_cost = 1600, icon = "Spell_Nature_NaturesWrath", source = "talent", train = "yes", spellId = 17329 },

    -- Pounce (Cat Form)
    { name = "Pounce", level = 36, rank = 1, base_cost = 11000, icon = "Ability_Druid_SurpriseAttack", source = "trainer", train = "yes", spellId = 9005 },
    { name = "Pounce", level = 46, rank = 2, base_cost = 20000, icon = "Ability_Druid_SurpriseAttack", source = "trainer", train = "yes", spellId = 9823 },
    { name = "Pounce", level = 56, rank = 3, base_cost = 30000, icon = "Ability_Druid_SurpriseAttack", source = "trainer", train = "yes", spellId = 9827 },

    -- Prowl (Cat Form)
    { name = "Prowl", level = 20, rank = 1, base_cost = 2000, icon = "Ability_Druid_Prowl", source = "trainer", train = "yes", spellId = 5215 },
    { name = "Prowl", level = 40, rank = 2, base_cost = 14000, icon = "Ability_Druid_Prowl", source = "trainer", train = "yes", spellId = 6783 },
    { name = "Prowl", level = 60, rank = 3, base_cost = 34000, icon = "Ability_Druid_Prowl", source = "trainer", train = "yes", spellId = 9913 },

    -- Rake (Cat Form)
    { name = "Rake", level = 24, rank = 1, base_cost = 4000, icon = "Ability_Druid_Disembowel", source = "trainer", train = "yes", spellId = 1822 },
    { name = "Rake", level = 34, rank = 2, base_cost = 10000, icon = "Ability_Druid_Disembowel", source = "trainer", train = "yes", spellId = 1823 },
    { name = "Rake", level = 44, rank = 3, base_cost = 18000, icon = "Ability_Druid_Disembowel", source = "trainer", train = "yes", spellId = 1824 },
    { name = "Rake", level = 54, rank = 4, base_cost = 28000, icon = "Ability_Druid_Disembowel", source = "trainer", train = "yes", spellId = 9904 },

    -- Ravage (Cat Form)
    { name = "Ravage", level = 32, rank = 1, base_cost = 8000, icon = "Ability_Druid_Ravage", source = "trainer", train = "yes", spellId = 6785 },
    { name = "Ravage", level = 42, rank = 2, base_cost = 16000, icon = "Ability_Druid_Ravage", source = "trainer", train = "yes", spellId = 6787 },
    { name = "Ravage", level = 50, rank = 3, base_cost = 23000, icon = "Ability_Druid_Ravage", source = "trainer", train = "yes", spellId = 9866 },
    { name = "Ravage", level = 58, rank = 4, base_cost = 32000, icon = "Ability_Druid_Ravage", source = "trainer", train = "yes", spellId = 9867 },

    -- Rebirth
    { name = "Rebirth", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Nature_Reincarnation", source = "trainer", train = "no", spellId = 20484 },
    { name = "Rebirth", level = 30, rank = 2, base_cost = 6000, icon = "Spell_Nature_Reincarnation", source = "trainer", train = "no", spellId = 20739 },
    { name = "Rebirth", level = 40, rank = 3, base_cost = 14000, icon = "Spell_Nature_Reincarnation", source = "trainer", train = "no", spellId = 20742 },
    { name = "Rebirth", level = 50, rank = 4, base_cost = 23000, icon = "Spell_Nature_Reincarnation", source = "trainer", train = "no", spellId = 20747 },
    { name = "Rebirth", level = 60, rank = 5, base_cost = 34000, icon = "Spell_Nature_Reincarnation", source = "trainer", train = "no", spellId = 20748 },

    -- Regrowth
    { name = "Regrowth", level = 12, rank = 1, base_cost = 800, icon = "Spell_Nature_ResistNature", source = "trainer", train = "yes", spellId = 8936 },
    { name = "Regrowth", level = 18, rank = 2, base_cost = 1900, icon = "Spell_Nature_ResistNature", source = "trainer", train = "yes", spellId = 8938 },
    { name = "Regrowth", level = 24, rank = 3, base_cost = 4000, icon = "Spell_Nature_ResistNature", source = "trainer", train = "yes", spellId = 8939 },
    { name = "Regrowth", level = 30, rank = 4, base_cost = 6000, icon = "Spell_Nature_ResistNature", source = "trainer", train = "yes", spellId = 8940 },
    { name = "Regrowth", level = 36, rank = 5, base_cost = 11000, icon = "Spell_Nature_ResistNature", source = "trainer", train = "yes", spellId = 8941 },
    { name = "Regrowth", level = 42, rank = 6, base_cost = 16000, icon = "Spell_Nature_ResistNature", source = "trainer", train = "yes", spellId = 9750 },
    { name = "Regrowth", level = 48, rank = 7, base_cost = 22000, icon = "Spell_Nature_ResistNature", source = "trainer", train = "yes", spellId = 9856 },
    { name = "Regrowth", level = 54, rank = 8, base_cost = 28000, icon = "Spell_Nature_ResistNature", source = "trainer", train = "yes", spellId = 9857 },
    { name = "Regrowth", level = 60, rank = 9, base_cost = 34000, icon = "Spell_Nature_ResistNature", source = "trainer", train = "yes", spellId = 9858 },

    -- Rejuvenation
    { name = "Rejuvenation", level = 4, rank = 1, base_cost = 100, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 774 },
    { name = "Rejuvenation", level = 10, rank = 2, base_cost = 300, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 1058 },
    { name = "Rejuvenation", level = 16, rank = 3, base_cost = 1800, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 1430 },
    { name = "Rejuvenation", level = 22, rank = 4, base_cost = 3000, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 2090 },
    { name = "Rejuvenation", level = 28, rank = 5, base_cost = 5000, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 2091 },
    { name = "Rejuvenation", level = 34, rank = 6, base_cost = 10000, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 3627 },
    { name = "Rejuvenation", level = 40, rank = 7, base_cost = 14000, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 8910 },
    { name = "Rejuvenation", level = 46, rank = 8, base_cost = 20000, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 9839 },
    { name = "Rejuvenation", level = 52, rank = 9, base_cost = 26000, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 9840 },
    { name = "Rejuvenation", level = 58, rank = 10, base_cost = 32000, icon = "Spell_Nature_Rejuvenation", source = "trainer", train = "yes", spellId = 9841 },
    { name = "Rejuvenation", level = 60, rank = 11, base_cost = 0, icon = "Spell_Nature_Rejuvenation", source = "book", train = "yes", spellId = 25299 },

    -- Remove Curse
    { name = "Remove Curse", level = 24, rank = 1, base_cost = 4000, icon = "Spell_Nature_RemoveCurse", source = "trainer", train = "yes", spellId = 2782 },

    -- Rip (Cat Form)
    { name = "Rip", level = 20, rank = 1, base_cost = 2000, icon = "Ability_GhoulFrenzy", source = "trainer", train = "yes", spellId = 1079 },
    { name = "Rip", level = 28, rank = 2, base_cost = 5000, icon = "Ability_GhoulFrenzy", source = "trainer", train = "yes", spellId = 9492 },
    { name = "Rip", level = 36, rank = 3, base_cost = 11000, icon = "Ability_GhoulFrenzy", source = "trainer", train = "yes", spellId = 9493 },
    { name = "Rip", level = 44, rank = 4, base_cost = 18000, icon = "Ability_GhoulFrenzy", source = "trainer", train = "yes", spellId = 9752 },
    { name = "Rip", level = 52, rank = 5, base_cost = 26000, icon = "Ability_GhoulFrenzy", source = "trainer", train = "yes", spellId = 9894 },
    { name = "Rip", level = 60, rank = 6, base_cost = 34000, icon = "Ability_GhoulFrenzy", source = "trainer", train = "yes", spellId = 9896 },

    -- Shred (Cat Form)
    { name = "Shred", level = 22, rank = 1, base_cost = 3000, icon = "Spell_Shadow_VampiricAura", source = "trainer", train = "yes", spellId = 5221 },
    { name = "Shred", level = 30, rank = 2, base_cost = 6000, icon = "Spell_Shadow_VampiricAura", source = "trainer", train = "yes", spellId = 6800 },
    { name = "Shred", level = 38, rank = 3, base_cost = 12000, icon = "Spell_Shadow_VampiricAura", source = "trainer", train = "yes", spellId = 8992 },
    { name = "Shred", level = 46, rank = 4, base_cost = 20000, icon = "Spell_Shadow_VampiricAura", source = "trainer", train = "yes", spellId = 9829 },
    { name = "Shred", level = 54, rank = 5, base_cost = 28000, icon = "Spell_Shadow_VampiricAura", source = "trainer", train = "yes", spellId = 9830 },

    -- Soothe Animal
    { name = "Soothe Animal", level = 22, rank = 1, base_cost = 3000, icon = "Ability_Hunter_BeastSoothe", source = "trainer", train = "wait", spellId = 2908 },
    { name = "Soothe Animal", level = 38, rank = 2, base_cost = 12000, icon = "Ability_Hunter_BeastSoothe", source = "trainer", train = "wait", spellId = 8955 },
    { name = "Soothe Animal", level = 54, rank = 3, base_cost = 28000, icon = "Ability_Hunter_BeastSoothe", source = "trainer", train = "wait", spellId = 9901 },

    -- Starfire
    { name = "Starfire", level = 20, rank = 1, base_cost = 2000, icon = "Spell_Arcane_StarFire", source = "trainer", train = "yes", spellId = 2912 },
    { name = "Starfire", level = 26, rank = 2, base_cost = 4500, icon = "Spell_Arcane_StarFire", source = "trainer", train = "yes", spellId = 8949 },
    { name = "Starfire", level = 34, rank = 3, base_cost = 10000, icon = "Spell_Arcane_StarFire", source = "trainer", train = "yes", spellId = 8950 },
    { name = "Starfire", level = 42, rank = 4, base_cost = 16000, icon = "Spell_Arcane_StarFire", source = "trainer", train = "yes", spellId = 8951 },
    { name = "Starfire", level = 50, rank = 5, base_cost = 23000, icon = "Spell_Arcane_StarFire", source = "trainer", train = "yes", spellId = 9875 },
    { name = "Starfire", level = 58, rank = 6, base_cost = 32000, icon = "Spell_Arcane_StarFire", source = "trainer", train = "yes", spellId = 9876 },

    -- Swipe (Bear Form)
    { name = "Swipe", level = 16, rank = 1, base_cost = 1800, icon = "Ability_Druid_Swipe", source = "trainer", train = "yes", spellId = 779 },
    { name = "Swipe", level = 24, rank = 2, base_cost = 4000, icon = "Ability_Druid_Swipe", source = "trainer", train = "yes", spellId = 780 },
    { name = "Swipe", level = 34, rank = 3, base_cost = 10000, icon = "Ability_Druid_Swipe", source = "trainer", train = "yes", spellId = 769 },
    { name = "Swipe", level = 44, rank = 4, base_cost = 18000, icon = "Ability_Druid_Swipe", source = "trainer", train = "yes", spellId = 9754 },
    { name = "Swipe", level = 54, rank = 5, base_cost = 28000, icon = "Ability_Druid_Swipe", source = "trainer", train = "yes", spellId = 9908 },

    -- Teleport: Moonglade
    { name = "Teleport: Moonglade", level = 10, rank = 1, base_cost = 0, icon = "Spell_Arcane_TeleportMoonglade", source = "quest", train = "yes", spellId = 18960 },

    -- Thorns
    { name = "Thorns", level = 6, rank = 1, base_cost = 100, icon = "Spell_Nature_Thorns", source = "trainer", train = "yes", spellId = 467 },
    { name = "Thorns", level = 14, rank = 2, base_cost = 900, icon = "Spell_Nature_Thorns", source = "trainer", train = "yes", spellId = 782 },
    { name = "Thorns", level = 24, rank = 3, base_cost = 4000, icon = "Spell_Nature_Thorns", source = "trainer", train = "yes", spellId = 1075 },
    { name = "Thorns", level = 34, rank = 4, base_cost = 10000, icon = "Spell_Nature_Thorns", source = "trainer", train = "yes", spellId = 8914 },
    { name = "Thorns", level = 44, rank = 5, base_cost = 18000, icon = "Spell_Nature_Thorns", source = "trainer", train = "yes", spellId = 9756 },
    { name = "Thorns", level = 54, rank = 6, base_cost = 28000, icon = "Spell_Nature_Thorns", source = "trainer", train = "yes", spellId = 9910 },

    -- Tiger's Fury (Cat Form)
    { name = "Tiger's Fury", level = 24, rank = 1, base_cost = 4000, icon = "Ability_Mount_JungleTiger", source = "trainer", train = "yes", spellId = 5217 },
    { name = "Tiger's Fury", level = 36, rank = 2, base_cost = 11000, icon = "Ability_Mount_JungleTiger", source = "trainer", train = "yes", spellId = 6793 },
    { name = "Tiger's Fury", level = 48, rank = 3, base_cost = 22000, icon = "Ability_Mount_JungleTiger", source = "trainer", train = "yes", spellId = 9845 },
    { name = "Tiger's Fury", level = 60, rank = 4, base_cost = 34000, icon = "Ability_Mount_JungleTiger", source = "trainer", train = "yes", spellId = 9846 },

    -- Track Humanoids (Cat Form)
    { name = "Track Humanoids", level = 32, rank = 1, base_cost = 8000, icon = "Ability_Tracking", source = "trainer", train = "wait", spellId = 5225 },

    -- Tranquility
    { name = "Tranquility", level = 30, rank = 1, base_cost = 6000, icon = "Spell_Nature_Tranquility", source = "trainer", train = "yes", spellId = 740 },
    { name = "Tranquility", level = 40, rank = 2, base_cost = 14000, icon = "Spell_Nature_Tranquility", source = "trainer", train = "yes", spellId = 8918 },
    { name = "Tranquility", level = 50, rank = 3, base_cost = 23000, icon = "Spell_Nature_Tranquility", source = "trainer", train = "yes", spellId = 9862 },
    { name = "Tranquility", level = 60, rank = 4, base_cost = 34000, icon = "Spell_Nature_Tranquility", source = "trainer", train = "yes", spellId = 9863 },

    -- Travel Form
    { name = "Travel Form", level = 30, rank = 1, base_cost = 6000, icon = "Ability_Druid_TravelForm", source = "trainer", train = "yes", spellId = 783 },

    -- Wrath
    { name = "Wrath", level = 1, rank = 1, base_cost = 0, icon = "Spell_Nature_AbolishMagic", source = "class", train = "yes", spellId = 5176 },
    { name = "Wrath", level = 6, rank = 2, base_cost = 100, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "yes", spellId = 5177 },
    { name = "Wrath", level = 14, rank = 3, base_cost = 900, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "yes", spellId = 5178 },
    { name = "Wrath", level = 22, rank = 4, base_cost = 3000, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "yes", spellId = 5179 },
    { name = "Wrath", level = 30, rank = 5, base_cost = 6000, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "yes", spellId = 5180 },
    { name = "Wrath", level = 38, rank = 6, base_cost = 12000, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "yes", spellId = 6780 },
    { name = "Wrath", level = 46, rank = 7, base_cost = 20000, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "yes", spellId = 8905 },
    { name = "Wrath", level = 54, rank = 8, base_cost = 28000, icon = "Spell_Nature_AbolishMagic", source = "trainer", train = "yes", spellId = 9912 },
}
