local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Gear = Deathless.Data.Gear or {}

Deathless.Data.Gear.Warrior = {
    generalNotes = [[
Warriors are heavily gear-dependent. Keeping your weapon and armor updated is critical for survival in Hardcore.

Key stats to prioritize:
• Stamina - Your primary survival stat, always valuable
• Armor - Reduces physical damage taken significantly
• Strength - Increases damage and block value
• Agility - Provides dodge, crit, and armor

Avoid gear with spirit or intellect. Defense and +hit become valuable at higher levels.]],

    weaponProgression = [[
Your weapon is your most important piece of gear. Upgrade it every 5-10 levels if possible.

Level 1-10: Use whatever 2H you can find, quest rewards work well
Level 10-20: Smite's Mighty Hammer (Deadmines) or a good green 2H axe/sword
Level 20-30: Corpsemaker (RFK) is the gold standard for this range
Level 30-40: Ravager (SM Armory) or Whirlwind Axe (quest)
Level 40-50: Ice Barbed Spear (AV) or dungeon drops
Level 50-60: Pre-raid BiS depends on spec, aim for high DPS slow weapons

Note: Dual-wielding is risky in HC due to increased miss chance. 2H is safer.]],

    importantGear = {
        { name = "Smite's Mighty Hammer", level = "19", source = "Deadmines", note = "Great early 2H mace" },
        { name = "Taskmaster Axe", level = "22", source = "Stockade Quest", note = "Alliance only" },
        { name = "Corpsemaker", level = "29", source = "RFK - Overlord Ramtusk", note = "Best 2H for 20s" },
        { name = "Ravager", level = "37", source = "SM Armory - Herod", note = "Proc is amazing for AoE" },
        { name = "Whirlwind Axe", level = "30", source = "Warrior Quest", note = "Requires group help" },
        { name = "Gatorbite Axe", level = "42", source = "ZF - Gahz'rilla", note = "Solid 40s upgrade" },
        { name = "Ice Barbed Spear", level = "51", source = "AV Exalted", note = "Easy to obtain, very good" },
        { name = "Blackstone Ring", level = "50", source = "Maraudon", note = "+hit is very valuable" },
        { name = "Devilsaur Set", level = "55", source = "Leatherworking", note = "+2% hit, expensive" },
        { name = "Lionheart Helm", level = "60", source = "Blacksmithing", note = "Pre-raid BiS head" },
    },
}

