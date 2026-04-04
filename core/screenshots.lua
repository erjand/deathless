local Deathless = Deathless

local SCREENSHOT_DELAY = 0.5

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:SetScript("OnEvent", function(_, _, newLevel)
    if not Deathless.config.screenshots or not Deathless.config.screenshots.levelUp then
        return
    end

    C_Timer.After(SCREENSHOT_DELAY, function()
        Screenshot()
        Deathless.Utils.Chat.Print("Screenshot saved — Level " .. newLevel .. " reached!")
    end)
end)
