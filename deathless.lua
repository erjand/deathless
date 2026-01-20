-- Deathless: A Hardcore Classic WoW companion addon
Deathless = Deathless or {}
Deathless.version = "0.1.0"
Deathless.modules = {}

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
