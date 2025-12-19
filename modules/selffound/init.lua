local Deathless = Deathless
local SelfFoundModule = {}

function SelfFoundModule:Initialize()
    Deathless:Print("Self-Found module initialized")
end

Deathless:RegisterModule("SelfFound", SelfFoundModule)

