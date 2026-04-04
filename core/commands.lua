local Deathless = Deathless
local NavIds = Deathless.Constants.NavigationIds
local Strings = Deathless.Constants.Strings

-- Slash command handler
local function SlashCommandHandler(msg)
    local cmd = msg and strtrim(msg:lower()) or ""

    --- Open the player's class view and select a class tab.
    ---@param suffix string Tab suffix (`NavigationIds.ABILITIES`, `.TALENTS`, `.STATS`, …)
    local function OpenCurrentClassTab(suffix)
        if Deathless.UI and Deathless.UI.Navigation and Deathless.UI.Navigation.OpenPlayerClassTab then
            Deathless.UI.Navigation:OpenPlayerClassTab(suffix, { notifyMissingTab = true })
        else
            Deathless.Utils.Chat.Print(Strings.UI_NOT_INITIALIZED)
        end
    end

    local function PrintHelp()
        Deathless.Utils.Chat.Print("Available commands:")
        Deathless.Utils.Chat.Print("/deathless (/dls) - Toggle the main window")
        Deathless.Utils.Chat.Print("/deathless help (/dls h) - Show this help")
        Deathless.Utils.Chat.Print("/deathless abilities (/dls a) - Open your class Abilities tab")
        Deathless.Utils.Chat.Print("/deathless class (/dls c) - Open the class view")
        Deathless.Utils.Chat.Print("/deathless dungeons (/dls d) - Open the Dungeons view")
        Deathless.Utils.Chat.Print("/deathless mini (/dls m) - Toggle the mini summary")
        Deathless.Utils.Chat.Print("/deathless options (/dls o) - Open the Options view")
        Deathless.Utils.Chat.Print("/deathless stats (/dls s) - Open your class Stats tab")
        Deathless.Utils.Chat.Print("/deathless talents (/dls t) - Open your class Talents tab")
    end
    
    -- /deathless mini - toggle mini summary
    if cmd == "mini" or cmd == "m" then
        if Deathless.UI and Deathless.UI.MiniSummary then
            Deathless.UI.MiniSummary:Toggle()
        else
            Deathless.Utils.Chat.Print(Strings.MINI_SUMMARY_NOT_INITIALIZED)
        end
        return
    end

    -- /deathless help - print command help to chat
    if cmd == "help" or cmd == "h" then
        PrintHelp()
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
            Deathless.Utils.Chat.Print(Strings.UI_NOT_INITIALIZED)
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
            Deathless.Utils.Chat.Print(Strings.UI_NOT_INITIALIZED)
        end
        return
    end

    -- /deathless abilities - open main UI to the player's class abilities tab
    if cmd == "abilities" or cmd == "ability" or cmd == "a" then
        OpenCurrentClassTab(NavIds.ABILITIES)
        return
    end

    -- /deathless stats - open main UI to the player's class stats tab
    if cmd == "stats" or cmd == "stat" or cmd == "s" then
        OpenCurrentClassTab(NavIds.STATS)
        return
    end

    -- /deathless talents - open main UI to the player's class talents tab
    if cmd == "talents" or cmd == "talent" or cmd == "t" then
        OpenCurrentClassTab(NavIds.TALENTS)
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
            Deathless.Utils.Chat.Print(Strings.UI_NOT_INITIALIZED)
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
        Deathless.Utils.Chat.Print(Strings.UI_NOT_INITIALIZED)
    end
end

SLASH_DEATHLESS1 = "/deathless"
SLASH_DEATHLESS2 = "/dls"
SlashCmdList["DEATHLESS"] = SlashCommandHandler
