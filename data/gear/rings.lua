local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Gear = Deathless.Data.Gear or {}

-- Every item must have a `classes` field listing which class gear pages it appears on
-- Source format: "{Dungeon} - {Boss}", "Quest - {Name}", "{Profession} ({Detail})", "Reputation - {Faction} ({Level})", "World Drop", "Vendor"

Deathless.Data.Gear.Rings = {
    { name = "Ring of Iron Will",          slot = "Ring",  type = "Ring",  levelReq = 15, source = "Quest - Howling in the Hills",              rarity = "uncommon",  itemId = 1319,  classes = { "Warrior", "Paladin", "Rogue", "Hunter", "Druid", "Mage", "Warlock", "Priest" }, faction = "Alliance" },
    { name = "Seal of Wrynn",              slot = "Ring",  type = "Ring",  levelReq = 16, source = "Quest - An Audience with the King",         rarity = "rare",      itemId = 2933,  classes = { "Warrior", "Paladin", "Rogue", "Hunter", "Druid" }, faction = "Alliance" },
    { name = "Lavishly Jeweled Ring",      slot = "Ring",  type = "Ring",  levelReq = 17, source = "Deadmines - Gilnid",                       rarity = "rare",      itemId = 1156,  classes = { "Hunter", "Druid", "Shaman", "Mage", "Warlock", "Priest" } },
    { name = "Ring of Pure Silver",        slot = "Ring",  type = "Ring",  levelReq = 18, source = "Quest - Raene's Cleansing",                rarity = "uncommon",  itemId = 1116,  classes = { "Paladin", "Druid", "Mage", "Warlock", "Priest" }, faction = "Alliance" },
    { name = "Seal of Sylvanas",           slot = "Ring",  type = "Ring",  levelReq = 18, source = "Quest - Arugal Must Die",                  rarity = "rare",      itemId = 6414,  classes = { "Warrior", "Rogue", "Hunter", "Shaman", "Druid" }, faction = "Horde" },
    { name = "Sustaining Ring",            slot = "Ring",  type = "Ring",  levelReq = 19, source = "Quest - Knowledge in the Deeps",           rarity = "uncommon",  itemId = 6743,  classes = { "Paladin", "Druid", "Mage", "Warlock", "Priest" }, faction = "Alliance" },
    { name = "Silverlaine's Family Seal",  slot = "Ring",  type = "Ring",  levelReq = 21, source = "SFK - Baron Silverlaine",                  rarity = "rare",      itemId = 6321,  classes = { "Warrior", "Paladin", "Rogue", "Shaman", "Druid" } },
    { name = "Deep Fathom Ring",           slot = "Ring",  type = "Ring",  levelReq = 21, source = "WC - Mutanus the Devourer",                rarity = "rare",      itemId = 6463,  classes = { "Paladin", "Shaman", "Druid", "Mage", "Warlock", "Priest" } },
    { name = "Band of Allegiance",         slot = "Ring",  type = "Ring",  levelReq = 30, source = "Quest - Service to the Horde",             rarity = "rare",      itemId = 18585, classes = { "Warrior", "Rogue", "Hunter", "Shaman", "Druid" }, faction = "Horde" },
    { name = "Lonetree's Circle",          slot = "Ring",  type = "Ring",  levelReq = 30, source = "Quest - Service to the Horde",             rarity = "rare",      itemId = 18586, classes = { "Druid", "Hunter", "Mage", "Priest", "Shaman", "Warlock" }, faction = "Horde" },
    { name = "Archaedic Stone",            slot = "Ring",  type = "Ring",  levelReq = 42, source = "Uldaman - Archaedas",                      rarity = "rare",      itemId = 11118, classes = { "Warrior", "Paladin", "Rogue", "Hunter", "Shaman", "Druid" } },
    { name = "Blackstone Ring",            slot = "Ring",  type = "Ring",  levelReq = 49, source = "Maraudon - Princess Theradras",             rarity = "rare",      itemId = 17713, classes = { "Warrior", "Paladin", "Rogue", "Hunter", "Shaman", "Druid" } },
    { name = "Magni's Will",               slot = "Ring",  type = "Ring",  levelReq = 52, source = "Quest - The Princess's Surprise",           rarity = "rare",      itemId = 12548, classes = { "Warrior", "Paladin", "Rogue", "Hunter", "Druid" }, faction = "Alliance" },
    { name = "Band of Flesh",              slot = "Ring",  type = "Ring",  levelReq = 55, source = "Stratholme - Ramstein",                    rarity = "rare",      itemId = 13373, classes = { "Warrior", "Paladin", "Rogue", "Hunter", "Shaman", "Druid" } },
    { name = "Tarnished Elven Ring",       slot = "Ring",  type = "Ring",  levelReq = 56, source = "DM North - Tribute",                       rarity = "rare",      itemId = 18500, classes = { "Warrior", "Paladin", "Rogue", "Hunter", "Shaman", "Druid" } },
}
