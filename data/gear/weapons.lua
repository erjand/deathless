local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Gear = Deathless.Data.Gear or {}

-- Every item must have a `classes` field listing which class gear pages it appears on
-- Source format: "{Dungeon} - {Boss}", "Quest - {Name}", "{Profession} ({Detail})", "Reputation - {Faction} ({Level})", "World Drop", "Vendor"

Deathless.Data.Gear.Weapons = {
    { name = "Smite's Mighty Hammer",  type = "2H Mace",    levelReq = 18, source = "Deadmines - Mr. Smite",            rarity = "rare",      itemId = 7230,  classes = { "Warrior", "Paladin", "Shaman" } },
    { name = "Crescent Staff",         type = "2H Staff",   levelReq = 17, source = "Quest - Leaders of the Fang",      rarity = "uncommon",  itemId = 6505,  classes = { "Warrior", "Druid", "Shaman" }, faction = "Horde" },
    { name = "Taskmaster Axe",         type = "1H Axe",     levelReq = 20, source = "Quest - The Stockade Riots",       rarity = "uncommon",  itemId = 3400,  classes = { "Warrior", "Paladin", "Rogue" }, faction = "Alliance" },
    { name = "Sword of Serenity",      type = "1H Sword",   levelReq = 22, source = "Quest - In the Name of the Light", rarity = "rare",      itemId = 6829,  classes = { "Warrior", "Paladin", "Rogue" }, faction = "Alliance" },
    { name = "Corpsemaker",            type = "2H Axe",     levelReq = 25, source = "RFK - Overlord Ramtusk",           rarity = "rare",      itemId = 6687,  classes = { "Warrior", "Paladin", "Shaman" } },
    { name = "Bonebiter",              type = "2H Axe",     levelReq = 26, source = "Quest - Beren's Peril",            rarity = "uncommon",  itemId = 2299,  classes = { "Warrior", "Paladin" }, faction = "Alliance" },
    { name = "Whirlwind Axe",          type = "2H Axe",     levelReq = 30, source = "Quest - Whirlwind Weapon",         rarity = "rare",      itemId = 6975,  classes = { "Warrior" } },
    { name = "Ravager",                type = "2H Polearm", levelReq = 33, source = "SM Armory - Herod",                rarity = "rare",      itemId = 7717,  classes = { "Warrior", "Paladin" } },
    { name = "Mograine's Might",       type = "2H Mace",    levelReq = 34, source = "SM Cathedral - Mograine",          rarity = "rare",      itemId = 7723,  classes = { "Warrior", "Paladin", "Shaman" } },
    { name = "Gatorbite Axe",          type = "2H Axe",     levelReq = 40, source = "Zul'Farrak - Gahz'rilla",         rarity = "rare",      itemId = 9459,  classes = { "Warrior", "Paladin", "Shaman" } },
    { name = "Executioner's Cleaver",  type = "2H Axe",     levelReq = 41, source = "RFD - Ragglesnout",                rarity = "rare",      itemId = 13018, classes = { "Warrior", "Paladin" } },
    { name = "Princess Theradras",     type = "2H Mace",    levelReq = 44, source = "Maraudon - Princess Theradras",    rarity = "rare",      itemId = 17766, classes = { "Warrior", "Paladin", "Shaman" } },
    { name = "Ice Barbed Spear",       type = "2H Polearm", levelReq = 51, source = "Reputation - AV (Exalted)",        rarity = "rare",      itemId = 19106, classes = { "Warrior", "Paladin", "Hunter" } },
    { name = "Dreadforge Retaliator",  type = "2H Sword",   levelReq = 52, source = "BRD - General Angerforge",         rarity = "rare",      itemId = 11931, classes = { "Warrior", "Paladin" } },
    { name = "Mirah's Song",           type = "1H Sword",   levelReq = 55, source = "Quest - Kirtonos the Herald",      rarity = "rare",      itemId = 15806, classes = { "Warrior", "Rogue" } },
    { name = "Thrash Blade",           type = "1H Sword",   levelReq = 55, source = "Quest - The Prince's Legacy",      rarity = "rare",      itemId = 17705, classes = { "Warrior", "Rogue" } },
    { name = "Barbarous Blade",        type = "2H Sword",   levelReq = 57, source = "Dire Maul - King Gordok",          rarity = "rare",      itemId = 18520, classes = { "Warrior", "Paladin" } },
}
