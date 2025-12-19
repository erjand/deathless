-- Deathless: A Hardcore Classic WoW companion addon
Deathless = Deathless or {}
Deathless.version = "1.0.0"
Deathless.modules = {}
Deathless.config = {}

-- Module registration system
function Deathless:RegisterModule(name, module)
    self.modules[name] = module
    if module.Initialize then
        module:Initialize()
    end
end

-- Get a registered module
function Deathless:GetModule(name)
    return self.modules[name]
end

-- Print helper
function Deathless:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00Deathless:|r " .. tostring(msg))
end

