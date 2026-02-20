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
    
    -- /deathless options - open main UI to options view
    if cmd == "options" or cmd == "o" then
        if Deathless.UI and Deathless.UI.Frame then
            Deathless.UI.Frame:Show()
            if Deathless.UI.Navigation and Deathless.UI.Navigation.Select then
                Deathless.UI.Navigation:Select("options")
            end
        else
            Deathless.Utils.Chat.Print("UI not initialized.")
        end
        return
    end

    -- /deathless class - open main UI to class view
    if cmd == "class" or cmd == "c" then
        if Deathless.UI and Deathless.UI.Frame then
            Deathless.UI.Frame:Show()
            if Deathless.UI.Navigation and Deathless.UI.Navigation.Select then
                local navId = "classes"
                local included = Deathless.config and Deathless.config.includedClasses
                if included then
                    local count, singleId = 0, nil
                    for className, enabled in pairs(included) do
                        if enabled then
                            count = count + 1
                            singleId = "class_" .. className:lower()
                        end
                    end
                    if count == 1 and singleId then
                        navId = singleId
                    end
                end
                Deathless.UI.Navigation:Select(navId)
            end
        else
            Deathless.Utils.Chat.Print("UI not initialized.")
        end
        return
    end

    -- /deathless dungeons - open main UI to dungeons view
    if cmd == "dungeons" or cmd == "d" then
        if Deathless.UI and Deathless.UI.Frame then
            Deathless.UI.Frame:Show()
            if Deathless.UI.Navigation and Deathless.UI.Navigation.Select then
                Deathless.UI.Navigation:Select("dungeons")
            end
        else
            Deathless.Utils.Chat.Print("UI not initialized.")
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
