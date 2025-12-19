local Deathless = Deathless
local ProfessionModule = {}

function ProfessionModule:Initialize()
    Deathless:Print("Professions module initialized")
end

Deathless:RegisterModule("Professions", ProfessionModule)

