local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.Chat = {}

-- Print a message to the default chat frame with Deathless prefix
function Deathless.Utils.Chat.Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00Deathless:|r " .. tostring(msg))
end

