local Deathless = Deathless
local ClassModule = {}

function ClassModule:Initialize()
    -- Module initialization
    Deathless:Print("Classes module initialized")
end

-- Register with core
Deathless:RegisterModule("Classes", ClassModule)

