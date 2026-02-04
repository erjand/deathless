local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local Icons = Deathless.Utils.Icons

-- Format copper amount with colored g/s/c letters
local function FormatMoneyColored(copper)
    if copper == 0 then return "0|cffb87333c|r" end
    
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local cop = copper % 100
    
    local parts = {}
    if gold > 0 then table.insert(parts, gold .. "|cffffd700g|r") end
    if silver > 0 then table.insert(parts, silver .. "|cffc0c0c0s|r") end
    if cop > 0 then table.insert(parts, cop .. "|cffb87333c|r") end
    
    return table.concat(parts, " ")
end

-- Check if a spell is known by searching the spellbook
local function IsSpellKnown(spellName, spellRank)
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

    Deathless.UI.Views:Register("summary", function(container)
        local Colors = Utils:GetColors()
        local Fonts = Deathless.UI.Fonts
    
    local title, subtitle = Utils:CreateHeader(container, "Summary", "")
    
    -- Enhanced scroll frame with auto-hiding scrollbar
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, -60, 24)
    
    -- Section collapse state
    local sectionState = { warnings = true, xp = true, abilities = true, availableNow = true, nextAvailable = true }
    
    -- Element pooling
    local pools = {
        section = {},
        subsection = {},
        subheader = {},
        row = {},
        text = {}
    }
    local poolIndexes = {
        section = 0,
        subsection = 0,
        subheader = 0,
        row = 0,
        text = 0
    }
    
    -- Forward declare Refresh for section click handlers
    local Refresh
    
    local function GetFrame(frameType)
        poolIndexes[frameType] = (poolIndexes[frameType] or 0) + 1
        local index = poolIndexes[frameType]
        local pool = pools[frameType]
        local frame = pool[index]
        
        if not frame then
            if frameType == "section" then
                frame = Utils:CreateCollapsibleSection(scrollChild)
            elseif frameType == "subsection" then
                frame = Utils:CreateCollapsibleSubSection(scrollChild)
            elseif frameType == "subheader" then
                frame = scrollChild:CreateFontString(nil, "OVERLAY")
                frame:SetFont(Fonts.family, Fonts.subtitle, "BOLD")
            elseif frameType == "row" then
                frame = CreateFrame("Frame", nil, scrollChild)
                frame:SetHeight(26)
                
                frame.icon = frame:CreateTexture(nil, "ARTWORK")
                frame.icon:SetSize(16, 16)
                frame.icon:SetPoint("LEFT", frame, "LEFT", 0, 0)
                frame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                
                frame.name = frame:CreateFontString(nil, "OVERLAY")
                frame.name:SetFont(Fonts.family, Fonts.body, "")
                frame.name:SetPoint("LEFT", frame.icon, "RIGHT", 8, 0)
                
                frame.level = frame:CreateFontString(nil, "OVERLAY")
                frame.level:SetFont(Fonts.family, Fonts.body, "")
                frame.level:SetPoint("RIGHT", frame, "RIGHT", -100, 0)
                
                frame.cost = frame:CreateFontString(nil, "OVERLAY")
                frame.cost:SetFont(Fonts.family, Fonts.body, "")
                frame.cost:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
                
                frame:EnableMouse(true)
                frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
            elseif frameType == "text" then
                frame = scrollChild:CreateFontString(nil, "OVERLAY")
                frame:SetFont(Fonts.family, Fonts.subtitle, "")
                frame:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            end
            pool[index] = frame
        end
        
        -- Reset common properties
        frame:ClearAllPoints()
        frame:Show()
        
        return frame
    end
    
    --- Create a collapsible section header
    local function CreateSectionHeader(sectionKey, label, count, yOffset, color)
        local section = GetFrame("section")
        local SECTION_HEIGHT = 28
        
        section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
        section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
        
        Utils:ConfigureSection(section, sectionState[sectionKey], label, color, count)
        
        section.sectionKey = sectionKey
        section:SetScript("OnClick", function(self)
            sectionState[self.sectionKey] = not sectionState[self.sectionKey]
            Refresh()
        end)
        
        return yOffset - SECTION_HEIGHT
    end
    
    --- Create a collapsible subsection header
    local function CreateSubSectionHeader(sectionKey, label, yOffset, color, costText)
        local subsection = GetFrame("subsection")
        local SUBSECTION_HEIGHT = 22
        
        subsection:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
        subsection:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -12, yOffset)
        
        Utils:ConfigureSubSection(subsection, sectionState[sectionKey], label, color)
        
        -- Add cost text if provided
        if costText then
            if not subsection.cost then
                subsection.cost = subsection:CreateFontString(nil, "OVERLAY")
                subsection.cost:SetFont(Fonts.family, Fonts.body, "")
                subsection.cost:SetPoint("LEFT", subsection.label, "RIGHT", 8, 0)
            end
            subsection.cost:SetText(costText)
            subsection.cost:SetTextColor(1, 1, 1, 1)
            subsection.cost:Show()
        elseif subsection.cost then
            subsection.cost:Hide()
        end
        
        subsection.sectionKey = sectionKey
        subsection:SetScript("OnClick", function(self)
            sectionState[self.sectionKey] = not sectionState[self.sectionKey]
            Refresh()
        end)
        
        return yOffset - SUBSECTION_HEIGHT
    end
    
    local function ClearFrames()
        for type, pool in pairs(pools) do
            for _, frame in ipairs(pool) do
                frame:Hide()
                frame:ClearAllPoints()
            end
            poolIndexes[type] = 0
        end
    end
    
    Refresh = function()
        ClearFrames()
        
        local _, classId = UnitClass("player")
        local className = classId:sub(1,1):upper() .. classId:sub(2):lower()
        local playerLevel = UnitLevel("player") or 1
        local powerType = UnitPowerType("player")
        
        local rawAbilities = Deathless.Data.Abilities and Deathless.Data.Abilities[className] or {}
        
        -- Helper to check race/faction
        local playerRace = UnitRace("player") or ""
        local playerFaction = UnitFactionGroup("player") or ""
        
        local function IsMatch(ability)
            if ability.race then
                local match = false
                for _, r in ipairs(ability.race) do if r == playerRace then match = true break end end
                if not match then return false end
            end
            if ability.faction and ability.faction ~= playerFaction then return false end
            return true
        end
        
        local available = {}
        local nextAvailable = {}
        local nextLevelCap = playerLevel + 2
        
        for _, ability in ipairs(rawAbilities) do
            if IsMatch(ability) then
                if ability.source == "talent" then
                    -- Skip talents for summary
                else
                    local isKnown = IsSpellKnown(ability.name, ability.rank)
                    if not isKnown then
                        if ability.level <= playerLevel then
                            table.insert(available, ability)
                        elseif ability.level <= nextLevelCap then
                            table.insert(nextAvailable, ability)
                        end
                    end
                end
            end
        end
        
        -- Sort by level then name
        local function Sort(t)
            table.sort(t, function(a, b)
                if a.level == b.level then
                    return a.name < b.name
                end
                return a.level < b.level
            end)
        end
        Sort(available)
        Sort(nextAvailable)
        
        local yOffset = -10
        
        -- Warnings Section (from shared module)
        local activeWarnings = Deathless.Utils.Warnings:GetActive()
        
        -- Display Warnings Section
        local hasWarnings = #activeWarnings > 0
        local warningsColor = hasWarnings and { 1, 0.8, 0.2 } or { 0.2, 1, 0.2 }
        yOffset = CreateSectionHeader("warnings", "Warnings", hasWarnings and #activeWarnings or nil, yOffset, warningsColor)
        
        if sectionState.warnings then
            if hasWarnings then
                for _, warning in ipairs(activeWarnings) do
                    local row = GetFrame("row")
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                    row:SetPoint("RIGHT", scrollChild, "RIGHT", -12, yOffset)
                    
                    if row.icon then
                        row.icon:SetTexture(warning.icon or Icons.DEFAULT)
                        row.icon:SetDesaturated(false)
                        row.icon:SetAlpha(1)
                    end
                    
                    row.name:SetText(warning.text)
                    row.name:SetTextColor(1, 0.8, 0.2, 1)
                    row.level:SetText("")
                    row.cost:SetText("")
                    
                    local itemId = warning.itemId
                    if itemId then
                        row:SetScript("OnEnter", function(self)
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 20, 0)
                            GameTooltip:SetItemByID(itemId)
                            GameTooltip:Show()
                        end)
                    else
                        row:SetScript("OnEnter", nil)
                    end
                    
                    yOffset = yOffset - 26
                end
            else
                local msg = GetFrame("text")
                msg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                msg:SetText("No warnings - go adventure!")
                msg:SetTextColor(0.5, 1, 0.5, 1)
                yOffset = yOffset - 24
            end
        end
        
        yOffset = yOffset - 10  -- Spacing between sections
        
        -- XP Progress Section
        local xpData = Deathless.Utils.XP:GetData()
        local showXP = Deathless.config.showXPProgress ~= false
        if showXP and not xpData.isMaxLevel then
            local xpColor = { 0.4, 0.8, 1.0 }
            yOffset = CreateSectionHeader("xp", "XP Progress", nil, yOffset, xpColor)
            
            if sectionState.xp then
                -- XP Bar
                local barFrame = GetFrame("row")
                barFrame:SetHeight(20)
                barFrame:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                barFrame:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
                
                -- Background bar
                if not barFrame.barBg then
                    barFrame.barBg = barFrame:CreateTexture(nil, "BACKGROUND")
                    barFrame.barBg:SetAllPoints()
                    barFrame.barBg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
                end
                barFrame.barBg:Show()
                
                -- Progress bar
                if not barFrame.barFill then
                    barFrame.barFill = barFrame:CreateTexture(nil, "ARTWORK")
                    barFrame.barFill:SetPoint("TOPLEFT", barFrame, "TOPLEFT", 1, -1)
                    barFrame.barFill:SetPoint("BOTTOMLEFT", barFrame, "BOTTOMLEFT", 1, 1)
                end
                barFrame.barFill:SetWidth(math.max(1, (barFrame:GetWidth() - 2) * (xpData.percent / 100)))
                barFrame.barFill:SetColorTexture(0.4, 0.8, 1.0, 0.8)
                barFrame.barFill:Show()
                
                -- XP text on bar
                barFrame.name:SetPoint("CENTER", barFrame, "CENTER", 0, 0)
                barFrame.name:SetText(string.format("%s / %s (%.1f%%)", 
                    Deathless.Utils.XP:FormatNumber(xpData.currentXP),
                    Deathless.Utils.XP:FormatNumber(xpData.maxXP),
                    xpData.percent))
                barFrame.name:SetTextColor(1, 1, 1, 1)
                barFrame.level:SetText("")
                barFrame.cost:SetText("")
                barFrame.icon:Hide()
                
                yOffset = yOffset - 24
                
                -- Session stats row
                local statsRow = GetFrame("row")
                statsRow:SetHeight(20)
                statsRow:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                statsRow:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
                statsRow.icon:Hide()
                
                statsRow.name:ClearAllPoints()
                statsRow.name:SetPoint("LEFT", statsRow, "LEFT", 0, 0)
                statsRow.name:SetText("Session: " .. Deathless.Utils.XP:FormatNumber(xpData.xpThisSession) .. " XP")
                statsRow.name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                
                statsRow.level:ClearAllPoints()
                statsRow.level:SetPoint("CENTER", statsRow, "CENTER", 0, 0)
                statsRow.level:SetText(Deathless.Utils.XP:FormatNumber(xpData.xpPerHour) .. " XP/hr")
                statsRow.level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                
                statsRow.cost:SetText("TTL: " .. Deathless.Utils.XP:FormatTime(xpData.timeToLevel))
                statsRow.cost:SetTextColor(xpColor[1], xpColor[2], xpColor[3], 1)
                
                yOffset = yOffset - 24
                
                -- Rested XP (if any)
                if xpData.restedXP > 0 then
                    local restedRow = GetFrame("text")
                    restedRow:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                    restedRow:SetText("Rested: " .. Deathless.Utils.XP:FormatNumber(xpData.restedXP) .. " XP")
                    restedRow:SetTextColor(0.4, 0.9, 0.4, 1)
                    yOffset = yOffset - 20
                end
            end
        end
        
        yOffset = yOffset - 10  -- Spacing between sections
        
        -- Abilities Section
        local abilitiesCount = #available + #nextAvailable
        yOffset = CreateSectionHeader("abilities", "Abilities", abilitiesCount > 0 and abilitiesCount or nil, yOffset, { Colors.accent[1], Colors.accent[2], Colors.accent[3] })
        
        if sectionState.abilities then
            if #available == 0 and #nextAvailable == 0 then
                local msg = GetFrame("text")
                msg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                msg:SetText("No new abilities available soon.")
                yOffset = yOffset - 20
            end
            
            if #available > 0 then
                local availableCost = 0
                for _, ability in ipairs(available) do
                    availableCost = availableCost + (ability.base_cost or 0)
                end
                
                local costText = "Total: " .. FormatMoneyColored(availableCost)
                yOffset = CreateSubSectionHeader("availableNow", "Available Now", yOffset, { Colors.accent[1], Colors.accent[2], Colors.accent[3] }, costText)
                
                if sectionState.availableNow then
                    for _, ability in ipairs(available) do
                        local row = GetFrame("row")
                        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                        row:SetPoint("RIGHT", scrollChild, "RIGHT", -12, yOffset)
                        
                        row.icon:SetTexture(Icons:GetIconPath(ability.icon))
                        row.icon:SetDesaturated(false)
                        row.icon:SetAlpha(1)
                        
                        local nameText = ability.name
                        if ability.rank and ability.rank > 1 then
                            nameText = nameText .. " (Rank " .. ability.rank .. ")"
                        end
                        
                        row.name:SetText(nameText)
                        row.name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                        
                        row.level:SetText("Lvl " .. ability.level)
                        row.level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                        
                        if ability.base_cost == 0 then
                            row.cost:SetText("Free")
                            row.cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                        else
                            row.cost:SetText(FormatMoneyColored(ability.base_cost))
                            row.cost:SetTextColor(1, 1, 1, 1)
                        end
                        
                        row:SetScript("OnEnter", function(self)
                            if ability.spellId then
                                GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 20, 0)
                                GameTooltip:SetSpellByID(ability.spellId)
                                GameTooltip:Show()
                            end
                        end)
                        
                        yOffset = yOffset - 24
                    end
                end
            end
            
            if #nextAvailable > 0 then
                local nextCost = 0
                for _, ability in ipairs(nextAvailable) do
                    nextCost = nextCost + (ability.base_cost or 0)
                end
                
                local costText = "Total: " .. FormatMoneyColored(nextCost)
                yOffset = CreateSubSectionHeader("nextAvailable", "Next Available", yOffset, { 0.5, 0.7, 0.9 }, costText)
                
                if sectionState.nextAvailable then
                    for _, ability in ipairs(nextAvailable) do
                        local row = GetFrame("row")
                        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                        row:SetPoint("RIGHT", scrollChild, "RIGHT", -12, yOffset)
                        
                        row.icon:SetTexture(Icons:GetIconPath(ability.icon))
                        row.icon:SetDesaturated(true)
                        row.icon:SetAlpha(0.6)
                        
                        local nameText = ability.name
                        if ability.rank and ability.rank > 1 then
                            nameText = nameText .. " (Rank " .. ability.rank .. ")"
                        end
                        
                        row.name:SetText(nameText)
                        row.name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 0.6)
                        
                        row.level:SetText("Lvl " .. ability.level)
                        row.level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                        
                        if ability.base_cost == 0 then
                            row.cost:SetText("Free")
                            row.cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.6)
                        else
                            row.cost:SetText(FormatMoneyColored(ability.base_cost))
                            row.cost:SetTextColor(1, 1, 1, 0.6)
                        end
                        
                        row:SetScript("OnEnter", function(self)
                            if ability.spellId then
                                GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 20, 0)
                                GameTooltip:SetSpellByID(ability.spellId)
                                GameTooltip:Show()
                            end
                        end)
                        
                        yOffset = yOffset - 24
                    end
                end
            end
        end
        
        scrollChild:SetHeight(math.abs(yOffset) + 20)
        
        -- Update scrollbar visibility after content changes
        C_Timer.After(0, function()
            if scrollFrame.UpdateScrollbar then
                scrollFrame.UpdateScrollbar()
            end
        end)
    end
    
    -- Refresh when shown
    container:SetScript("OnShow", function()
        if scrollFrame.ResetScroll then
            scrollFrame.ResetScroll()
        end
        Refresh()
    end)
    
    -- Register for automatic refresh when warnings/state changes
    Deathless.Utils.Warnings:RegisterRefresh("summary", function()
        if container:IsVisible() then
            Refresh()
        end
    end)
    
    -- Register for XP changes
    Deathless.Utils.XP:RegisterRefresh("summary", function()
        if container:IsVisible() then
            Refresh()
        end
    end)
    
    -- Initial render
    Refresh()
    
    return { title = title, subtitle = subtitle, scrollFrame = scrollFrame }
end)
