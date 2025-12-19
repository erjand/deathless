local Deathless = Deathless

-- Event handling framework
Deathless.events = Deathless.events or CreateFrame("Frame")

-- Register an event handler
function Deathless:RegisterEvent(event, handler)
    self.events:RegisterEvent(event)
    self.events:SetScript("OnEvent", function(self, event, ...)
        if handler then
            handler(...)
        end
    end)
end

-- Fire a custom event
function Deathless:FireEvent(eventName, ...)
    -- Custom event system can be extended here
    -- For now, modules can listen to standard WoW events
end

