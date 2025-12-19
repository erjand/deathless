local Deathless = Deathless
local SkillModule = {}

function SkillModule:Initialize()
    Deathless:Print("Skills module initialized")
end

Deathless:RegisterModule("Skills", SkillModule)

