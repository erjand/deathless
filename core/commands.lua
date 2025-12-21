local Deathless = Deathless

-- Slash command handler
local function SlashCommandHandler(msg)
    msg = msg or ""
    msg = string.lower(msg)
    msg = string.gsub(msg, "^%s+", "")
    msg = string.gsub(msg, "%s+$", "")
    
    if msg == "" or msg == "toggle" then
        -- Toggle UI visibility
        if Deathless.UI and Deathless.UI.Frame then
            if Deathless.UI.Frame.mainFrame and Deathless.UI.Frame.mainFrame:IsShown() then
                Deathless.UI.Frame:Hide()
            else
                Deathless.UI.Frame:Show()
            end
        else
            Deathless.Utils.Chat.Print("UI not initialized.")
        end
    elseif msg == "show" or msg == "open" then
        if Deathless.UI and Deathless.UI.Frame then
            Deathless.UI.Frame:Show()
        end
    elseif msg == "hide" or msg == "close" then
        if Deathless.UI and Deathless.UI.Frame then
            Deathless.UI.Frame:Hide()
        end
    else
        Deathless.Utils.Chat.Print("Usage: /deathless [show|hide|toggle]")
    end
end

SLASH_DEATHLESS1 = "/deathless"
SlashCmdList["DEATHLESS"] = SlashCommandHandler
