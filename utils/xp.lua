local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.XP = {}

local XP = Deathless.Utils.XP

-- Session tracking
local sessionStartTime = nil
local sessionStartXP = nil
local sessionStartLevel = nil

--- Initialize session tracking
local function InitSession()
    sessionStartTime = GetTime()
    sessionStartXP = UnitXP("player")
    sessionStartLevel = UnitLevel("player")
end

--- Reset session (call when player wants to restart tracking)
function XP:ResetSession()
    InitSession()
    self:TriggerRefresh()
end

--- Get current XP data
--- @return table XP data with currentXP, xpToLevel, xpThisSession, xpPerHour, timeToLevel
function XP:GetData()
    local currentXP = UnitXP("player")
    local maxXP = UnitXPMax("player")
    local playerLevel = UnitLevel("player")
    local xpToLevel = maxXP - currentXP
    
    -- Calculate session XP (accounting for level ups)
    local xpThisSession = 0
    local sessionSeconds = 0
    
    if sessionStartTime then
        sessionSeconds = GetTime() - sessionStartTime
        
        if playerLevel == sessionStartLevel then
            -- Same level, simple calculation
            xpThisSession = currentXP - sessionStartXP
        else
            -- Leveled up during session, estimate based on current level progress
            -- This is approximate but good enough for session tracking
            xpThisSession = currentXP + ((playerLevel - sessionStartLevel) * maxXP) - sessionStartXP
        end
    end
    
    -- Calculate XP per hour
    local xpPerHour = 0
    if sessionSeconds > 60 then -- Only calculate after 1 minute
        xpPerHour = math.floor(xpThisSession * 3600 / sessionSeconds)
    end
    
    -- Calculate time to level
    local timeToLevel = nil
    if xpPerHour > 0 then
        local hoursToLevel = xpToLevel / xpPerHour
        timeToLevel = hoursToLevel * 3600 -- Convert to seconds
    end
    
    -- Rest XP
    local restedXP = GetXPExhaustion() or 0
    
    return {
        currentXP = currentXP,
        maxXP = maxXP,
        xpToLevel = xpToLevel,
        percent = maxXP > 0 and (currentXP / maxXP * 100) or 0,
        xpThisSession = xpThisSession,
        xpPerHour = xpPerHour,
        timeToLevel = timeToLevel,
        sessionSeconds = sessionSeconds,
        restedXP = restedXP,
        isMaxLevel = playerLevel >= 60,
    }
end

--- Format time duration as human readable string
--- @param seconds number Time in seconds
--- @return string Formatted time string
function XP:FormatTime(seconds)
    if not seconds or seconds <= 0 then
        return "--"
    end
    
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    
    if hours > 0 then
        return string.format("%dh %dm", hours, mins)
    else
        return string.format("%dm", mins)
    end
end

--- Format large numbers with commas
--- @param num number Number to format
--- @return string Formatted number string
function XP:FormatNumber(num)
    if not num then return "0" end
    local formatted = tostring(math.floor(num))
    local k
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
    end
    return formatted
end

-- ========================================
-- EVENT-BASED REFRESH SYSTEM
-- ========================================

local refreshCallbacks = {}
local pendingRefresh = false
local DEBOUNCE_DELAY = 0.5

--- Register a callback for XP changes
--- @param key string Unique key for this callback
--- @param callback function Function to call on refresh
function XP:RegisterRefresh(key, callback)
    refreshCallbacks[key] = callback
end

--- Unregister a refresh callback
--- @param key string The key used when registering
function XP:UnregisterRefresh(key)
    refreshCallbacks[key] = nil
end

--- Trigger a debounced refresh of all registered callbacks
local function TriggerRefresh()
    if pendingRefresh then return end
    pendingRefresh = true
    
    C_Timer.After(DEBOUNCE_DELAY, function()
        pendingRefresh = false
        for _, callback in pairs(refreshCallbacks) do
            callback()
        end
    end)
end

--- Public method to trigger refresh
function XP:TriggerRefresh()
    TriggerRefresh()
end

-- Create event frame for watching XP changes
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_XP_UPDATE")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        -- Initialize session on first login/reload
        if not sessionStartTime then
            InitSession()
        end
    end
    TriggerRefresh()
end)
