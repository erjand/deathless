local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Gear = Deathless.Data.Gear or {}

-- Every item must have a `classes` field listing which class gear pages it appears on
-- Source format: "{Dungeon} - {Boss}", "Quest - {Name}", "{Profession} ({Detail})", "Reputation - {Faction} ({Level})", "World Drop", "Vendor"

Deathless.Data.Gear.Ranged = {
    { name = "Rough Boomstick",             type = "Gun",       levelReq =  5, source = "Engineering (50)",                      rarity = "uncommon",  itemId = 4362,  classes = { "Rogue", "Hunter" } },
    { name = "Venomstrike",                 type = "Bow",       levelReq = 19, source = "Wailing Caverns - Lord Serpentis",      rarity = "rare",      itemId = 6469,  classes = { "Warrior", "Rogue", "Hunter" } },
    { name = "\"Mage-Eye\" Blunderbuss",    type = "Gun",       levelReq = 26, source = "Quest - The Crone of the Kraul",        rarity = "uncommon",  itemId = 3041,  classes = { "Rogue", "Hunter" }, faction = "Alliance" },
    { name = "Blasting Hackbut",            type = "Gun",       levelReq = 30, source = "Quest - Questioning Reethe",            rarity = "uncommon",  itemId = 6798,  classes = { "Warrior", "Rogue", "Hunter" }, faction = "Horde" },
    { name = "Houndmaster's Rifle",         type = "Gun",       levelReq = 48, source = "BRD - Houndmaster Grebmar",             rarity = "rare",      itemId = 11629, classes = { "Warrior", "Rogue", "Hunter" } },
    { name = "Satyr's Bow",                 type = "Bow",       levelReq = 53, source = "DM East - Zevrim Thornhoof",            rarity = "rare",      itemId = 18323, classes = { "Warrior", "Rogue", "Hunter" } },
    { name = "Blackcrow",                   type = "Crossbow",  levelReq = 54, source = "LBRS - Shadow Hunter Vosh'gajin",       rarity = "rare",      itemId = 12651, classes = { "Warrior", "Rogue", "Hunter" } },
    { name = "Carapace Spine Crossbow",     type = "Crossbow",  levelReq = 56, source = "Stratholme - Nerub'enkan",              rarity = "rare",      itemId = 18738, classes = { "Warrior", "Rogue", "Hunter" } },
    { name = "Gorewood Bow",                type = "Bow",       levelReq = 56, source = "Quest - Order Must Be Restored",        rarity = "rare",      itemId = 16996, classes = { "Warrior", "Rogue", "Hunter" } },
}
