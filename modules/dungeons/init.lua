local Deathless = Deathless
local DungeonModule = {}

function DungeonModule:Initialize()
    Deathless:Print("Dungeons module initialized")
end

Deathless:RegisterModule("Dungeons", DungeonModule)

