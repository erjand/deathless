local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.Levels = {}

local Levels = Deathless.Utils.Levels

local pendingLevelUp = nil
local suppressPlayedMsg = false
local playedSnapshot = nil   -- server-reported /played
local snapshotAt = nil       -- GetTime() when snapshot was taken

--- Format seconds as HH:MM:SS
--- @param seconds number|nil Total seconds
--- @return string Formatted time string
function Levels:FormatTimeHMS(seconds)
    if not seconds or seconds < 0 then
        return "--"
    end
    local d = math.floor(seconds / 86400)
    local h = math.floor((seconds % 86400) / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    local parts = {}
    if d > 0 then
        parts[#parts + 1] = d .. "d"
        parts[#parts + 1] = h .. "h"
    elseif h > 0 then
        parts[#parts + 1] = h .. "h"
    end
    parts[#parts + 1] = m .. "m"
    parts[#parts + 1] = s .. "s"
    return table.concat(parts, ", ")
end

local function EnsureDefaults()
    Deathless.config.levels = Deathless.config.levels or {}
    if not Deathless.config.levels[1] then
        Deathless.config.levels[1] = { played = 0 }
    end
end

--- Get stored level data keyed by level number
--- @return table Level data { [level] = { played = seconds } }
function Levels:GetData()
    EnsureDefaults()
    return Deathless.config.levels
end

--- Get total played time, extrapolated from the last server snapshot via system clock.
--- @return number|nil Total played seconds
function Levels:GetTotalPlayed()
    if playedSnapshot and snapshotAt then
        return playedSnapshot + (GetTime() - snapshotAt)
    end
    return nil
end

--- Request a fresh /played from the server (suppresses chat output)
function Levels:RequestPlayed()
    suppressPlayedMsg = true
    RequestTimePlayed()
end

-- Suppress default chat frame /played output for addon-initiated requests
if ChatFrame_DisplayTimePlayed then
    local original = ChatFrame_DisplayTimePlayed
    ChatFrame_DisplayTimePlayed = function(...)
        if suppressPlayedMsg then
            suppressPlayedMsg = false
            return
        end
        return original(...)
    end
end

-- Refresh callbacks
local refreshCallbacks = {}

--- Register a callback for level data changes
--- @param key string Unique key
--- @param callback function
function Levels:RegisterRefresh(key, callback)
    refreshCallbacks[key] = callback
end

local function TriggerRefresh()
    for _, cb in pairs(refreshCallbacks) do
        cb()
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:RegisterEvent("TIME_PLAYED_MSG")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        EnsureDefaults()
        suppressPlayedMsg = true
        RequestTimePlayed()
    elseif event == "PLAYER_LEVEL_UP" then
        local newLevel = ...
        pendingLevelUp = tonumber(newLevel)
        suppressPlayedMsg = true
        RequestTimePlayed()
    elseif event == "TIME_PLAYED_MSG" then
        local totalTimePlayed, timePlayedThisLevel = ...
        EnsureDefaults()

        playedSnapshot = totalTimePlayed
        snapshotAt = GetTime()

        if pendingLevelUp then
            -- Record /played at the moment we reached this level
            Deathless.config.levels[pendingLevelUp] = {
                played = totalTimePlayed - timePlayedThisLevel,
            }
            pendingLevelUp = nil
            Deathless:SaveConfig()
        else
            -- Seed current level on first login if not yet tracked
            local playerLevel = UnitLevel("player")
            if playerLevel and playerLevel > 1 and not Deathless.config.levels[playerLevel] then
                Deathless.config.levels[playerLevel] = {
                    played = totalTimePlayed - timePlayedThisLevel,
                }
                Deathless:SaveConfig()
            end
        end

        TriggerRefresh()
    end
end)
