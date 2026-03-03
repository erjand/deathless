local Deathless = Deathless

Deathless.Data = Deathless.Data or {}
Deathless.Data.Gear = Deathless.Data.Gear or {}

-- Every item must have a `classes` field listing which class gear pages it appears on
-- Source format: "{Dungeon} - {Boss}", "Quest - {Name}", "{Profession} ({Detail})", "Reputation - {Faction} ({Level})", "World Drop", "Vendor"

Deathless.Data.Gear.Trinkets = {
    { name = "Placeholder",           slot = "Trinket", type = "Trinket", levelReq = 16, source = "Quest - An Audience with the King",     rarity = "rare",      itemId = 2933,  classes = { "Warrior", "Paladin", "Rogue", "Hunter", "Druid" }, faction = "Alliance" },
}
