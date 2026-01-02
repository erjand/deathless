local Deathless = Deathless

-- Slash command handler
local function SlashCommandHandler(msg)
    local cmd = msg and msg:lower():trim() or ""
    
    -- /deathless mini - toggle mini summary
    if cmd == "mini" or cmd == "m" then
        if Deathless.UI and Deathless.UI.MiniSummary then
            Deathless.UI.MiniSummary:Toggle()
        else
            Deathless.Utils.Chat.Print("Mini summary not initialized.")
        end
        return
    end
    
    -- /deathless (no args) - toggle main UI
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
SLASH_DEATHLESS2 = "/dls"
SlashCmdList["DEATHLESS"] = SlashCommandHandler
