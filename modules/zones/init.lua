local Deathless = Deathless
local ZoneModule = {}

function ZoneModule:Initialize()
    Deathless:Print("Zones module initialized")
end

Deathless:RegisterModule("Zones", ZoneModule)

