local Deathless = Deathless

Deathless.Utils = Deathless.Utils or {}
Deathless.Utils.Abilities = {}

local Abilities = Deathless.Utils.Abilities
local ColorCodes = Deathless.Constants.Colors.Codes

--- Format copper amount with colored g/s/c letters
---@param copper number Amount in copper
---@return string Formatted string with color codes
function Abilities.FormatMoneyColored(copper)
    if copper == 0 then return "0" .. ColorCodes.moneyCopper .. "c|r" end

    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local cop = copper % 100

    local parts = {}
    if gold > 0 then table.insert(parts, gold .. ColorCodes.moneyGold .. "g|r") end
    if silver > 0 then table.insert(parts, silver .. ColorCodes.moneySilver .. "s|r") end
    if cop > 0 then table.insert(parts, cop .. ColorCodes.moneyCopper .. "c|r") end

    return table.concat(parts, " ")
end

--- Check if a spell is known by searching the spellbook
---@param spellName string The spell name to check
---@param spellRank number|nil Optional rank to match
---@return boolean Whether the spell is known
function Abilities.IsSpellKnown(spellName, spellRank)
    local i = 1
    while true do
        local name, rank = GetSpellBookItemName(i, BOOKTYPE_SPELL)
        if not name then break end

        if name == spellName then
            if not spellRank or spellRank == 1 then
                return true
            end
            local rankNum = rank and tonumber(rank:match("%d+"))
            if rankNum and rankNum >= spellRank then
                return true
            end
        end
        i = i + 1
    end
    return false
end

--- Check if player's race matches ability's race requirement
---@param ability table The ability to check
---@param playerRace string The player's race
---@return boolean Whether ability is available for this race
function Abilities.IsRaceMatch(ability, playerRace)
    if not ability.race then return true end
    for _, race in ipairs(ability.race) do
        if race == playerRace then return true end
    end
    return false
end

--- Check if player's faction matches ability's faction requirement
---@param ability table The ability to check
---@param playerFaction string The player's faction ("Alliance" or "Horde")
---@return boolean Whether ability is available for this faction
function Abilities.IsFactionMatch(ability, playerFaction)
    if not ability.faction then return true end
    return ability.faction == playerFaction
end

--- Check if an ability matches the player's race and faction
---@param ability table The ability to check
---@param playerRace string The player's race
---@param playerFaction string The player's faction
---@return boolean Whether ability is available
function Abilities.IsMatch(ability, playerRace, playerFaction)
    return Abilities.IsRaceMatch(ability, playerRace) and Abilities.IsFactionMatch(ability, playerFaction)
end

--- Compute the "next available" level cap, ensuring it always includes at least the next level breakpoint
---@param rawAbilities table Array of ability data
---@param playerLevel number Current player level
---@param matchFn function|nil Optional filter: function(ability) -> boolean
---@return number The level cap for "next available" abilities
function Abilities.NextLevelCap(rawAbilities, playerLevel, matchFn)
    local cap = playerLevel + 2
    local minNextLevel
    for _, ability in ipairs(rawAbilities) do
        if ability.source ~= "talent" and ability.level > playerLevel then
            if not matchFn or matchFn(ability) then
                if not minNextLevel or ability.level < minNextLevel then
                    minNextLevel = ability.level
                end
            end
        end
    end
    if minNextLevel and minNextLevel > cap then
        cap = minNextLevel
    end
    return cap
end

--- Sort abilities by level ascending, then name ascending
---@param t table Array of abilities to sort in-place
---@return table The same table, sorted
function Abilities.Sort(t)
    table.sort(t, function(a, b)
        if a.level == b.level then return a.name < b.name end
        return a.level < b.level
    end)
    return t
end
