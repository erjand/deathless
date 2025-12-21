local Deathless = Deathless

-- Slash command handler - toggles UI visibility
local function SlashCommandHandler(msg)
    if Deathless.UI and Deathless.UI.Frame then
        if Deathless.UI.Frame.mainFrame and Deathless.UI.Frame.mainFrame:IsShown() then
            Deathless.UI.Frame:Hide()
        else
            Deathless.UI.Frame:Show()
        end
    else
        Deathless.Utils.Chat.Print("UI not initialized.")
    end
end

SLASH_DEATHLESS1 = "/deathless"
SlashCmdList["DEATHLESS"] = SlashCommandHandler
