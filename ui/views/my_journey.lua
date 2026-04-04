local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local Icons = Deathless.Utils.Icons
local UIUtils = Deathless.Utils.UI
local ViewOffsets = Deathless.Constants.Colors.UI.ViewOffsets
local NavIds = Deathless.Constants.NavigationIds

local AbilityUtils = Deathless.Utils.Abilities
local FormatMoneyColored = AbilityUtils.FormatMoneyColored
local IsSpellKnown = AbilityUtils.IsSpellKnown
local LevelsModule = Deathless.Utils.Levels
local LevelLayout = Deathless.Constants.Colors.UI.TableLayouts.Levels
local LevelCols = LevelLayout.columns
local LEVEL_ROW_HEIGHT = LevelLayout.rowHeight

    Deathless.UI.Views:Register(NavIds.MY_JOURNEY, function(container)
        local Colors = Utils:GetColors()
        local Fonts = Deathless.UI.Fonts
    local Layout = Utils.Layout
    local IconStyle = Deathless.Constants.Colors.UI.Icon
    local ClassColors = Deathless.Constants.Colors.Class
    local Colorize = UIUtils.ColorizeText
        local CONTENT_LEFT = 12
        local CONTENT_RIGHT = -12
        local SECTION_LEFT = CONTENT_LEFT + 12
    
    local title, subtitle, headerSeparator = Utils:CreateHeader(container, "", "", { 1, 1, 1 })
    subtitle:Hide()
    headerSeparator:ClearAllPoints()
    headerSeparator:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    headerSeparator:SetPoint("RIGHT", container, "RIGHT", -20, 0)
    
    local function UpdateJourneyTitle()
        local playerName = UnitName("player") or ""
        local _, classFile = UnitClass("player")
        local classKey = (classFile and classFile:lower()) or "warrior"
        local classColor = ClassColors[classKey] or Colors.accent
        title:SetText(Colorize(classColor, playerName .. "'s Journey"))
    end
    UpdateJourneyTitle()
    
    -- Enhanced scroll frame with auto-hiding scrollbar
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, ViewOffsets.simple.scrollTop, ViewOffsets.defaultScrollBottom)
    
    -- Section collapse state
    local sectionState = { levels = true, warnings = true, available = true, nextAvailable = true }
    
    -- Element pooling
    local pools = {
        levelRow = {},
        section = {},
        subsection = {},
        subheader = {},
        row = {},
        text = {},
    }
    local poolIndexes = {
        levelRow = 0,
        section = 0,
        subsection = 0,
        subheader = 0,
        row = 0,
        text = 0,
    }
    
    -- Forward declare Refresh for section click handlers
    local Refresh
    local levelSortHeaders = {}
    local totalTimeLabel = nil  -- reference for live ticker
    
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
                frame.icon:SetSize(IconStyle.sizeSmall, IconStyle.sizeSmall)
                frame.icon:SetPoint("LEFT", frame, "LEFT", 0, 0)
                frame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                
                frame.name = frame:CreateFontString(nil, "OVERLAY")
                frame.name:SetFont(Fonts.family, Fonts.body, "")
                frame.name:SetPoint("LEFT", frame.icon, "RIGHT", 8, 0)
                
                frame.level = frame:CreateFontString(nil, "OVERLAY")
                frame.level:SetFont(Fonts.family, Fonts.body, "")
                frame.level:SetPoint("RIGHT", frame, "RIGHT", -96, 0)
                
                frame.cost = frame:CreateFontString(nil, "OVERLAY")
                frame.cost:SetFont(Fonts.family, Fonts.body, "")
                frame.cost:SetPoint("RIGHT", frame, "RIGHT", -4, 0)
                
                frame:EnableMouse(true)
                frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
            elseif frameType == "text" then
                frame = scrollChild:CreateFontString(nil, "OVERLAY")
                frame:SetFont(Fonts.family, Fonts.subtitle, "")
                frame:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            elseif frameType == "levelRow" then
                frame = CreateFrame("Frame", nil, scrollChild)
                frame:SetHeight(LEVEL_ROW_HEIGHT)

                frame.level = frame:CreateFontString(nil, "OVERLAY")
                frame.level:SetFont(Fonts.family, Fonts.body, "")
                frame.level:SetPoint("LEFT", frame, "LEFT", LevelCols.level.x, 0)

                frame.timeForLevel = frame:CreateFontString(nil, "OVERLAY")
                frame.timeForLevel:SetFont(Fonts.code, Fonts.body, "")
                frame.timeForLevel:SetPoint("LEFT", frame, "LEFT", LevelCols.timeForLevel.x, 0)

                frame.totalTime = frame:CreateFontString(nil, "OVERLAY")
                frame.totalTime:SetFont(Fonts.code, Fonts.body, "")
                frame.totalTime:SetPoint("LEFT", frame, "LEFT", LevelCols.totalTime.x, 0)
            end
            pool[index] = frame
        end
        
        -- Reset common properties
        frame:ClearAllPoints()
        frame:Show()
        
        return frame
    end
    
    --- Create a collapsible section header
    local function CreateSectionHeader(sectionKey, label, count, yOffset, color, costText)
        local section = GetFrame("section")
        local SECTION_HEIGHT = Layout.sectionHeight
        
        section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
        section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
        
        Utils:ConfigureSection(section, sectionState[sectionKey], label, color, count, costText)
        
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
        
        subsection:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 12, yOffset)
        subsection:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT - 12, yOffset)
        
        Utils:ConfigureSubSection(subsection, sectionState[sectionKey], label, color)
        
        -- Add cost text if provided
        if costText then
            if not subsection.cost then
                subsection.cost = subsection:CreateFontString(nil, "OVERLAY")
                subsection.cost:SetFont(Fonts.family, Fonts.body, "")
                    subsection.cost:SetPoint("RIGHT", subsection, "RIGHT", -4, 0)
            end
            subsection.cost:SetText(costText)
            subsection.cost:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], Colors.white[4])
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
        for _, h in pairs(levelSortHeaders) do
            h:Hide()
        end
    end
    
    -- Level sort headers (persistent, repositioned each Refresh)
    local levelSortState = { sortKey = "level", sortAsc = true }

    local function OnLevelSort()
        for _, h in pairs(levelSortHeaders) do
            if levelSortState.sortKey == h.sortKey then
                h.label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
            else
                h.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            end
            h.UpdateLabel()
        end
        if Refresh then Refresh() end
    end

    levelSortHeaders.level = Utils:CreateSortableHeader(
        scrollChild, "LEVEL", "level", levelSortState, OnLevelSort,
        { x = SECTION_LEFT + LevelCols.level.x, width = LevelCols.level.w, y = 0 }
    )
    levelSortHeaders.timeForLevel = Utils:CreateSortableHeader(
        scrollChild, "TIME FOR LEVEL", "timeForLevel", levelSortState, OnLevelSort,
        { x = SECTION_LEFT + LevelCols.timeForLevel.x, width = LevelCols.timeForLevel.w, y = 0 }
    )
    levelSortHeaders.totalTime = Utils:CreateSortableHeader(
        scrollChild, "TOTAL TIME", "totalTime", levelSortState, OnLevelSort,
        { x = SECTION_LEFT + LevelCols.totalTime.x, width = LevelCols.totalTime.w, y = 0 }
    )
    OnLevelSort()
    for _, h in pairs(levelSortHeaders) do h:Hide() end

    Refresh = function()
        UpdateJourneyTitle()
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
            return AbilityUtils.IsMatch(ability, playerRace, playerFaction)
        end
        
        local available = {}
        local nextAvailable = {}
        local nextLevelCap = AbilityUtils.NextLevelCap(rawAbilities, playerLevel, IsMatch)
        
        for _, ability in ipairs(rawAbilities) do
            if IsMatch(ability) and ability.source ~= "talent" then
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
        
        AbilityUtils.Sort(available)
        AbilityUtils.Sort(nextAvailable)
        
        local yOffset = -10

        -- Levels Section
        local levelsData = LevelsModule:GetData()
        local totalPlayed = LevelsModule:GetTotalPlayed()

        yOffset = CreateSectionHeader("levels", "Levels", nil, yOffset, Colors.accent)

        if sectionState.levels then
            totalTimeLabel = GetFrame("text")
            totalTimeLabel:SetFont(Fonts.code, Fonts.subtitle, "")
            totalTimeLabel:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT, yOffset - 2)
            totalTimeLabel:SetText("Total Time: " .. LevelsModule:FormatTimeHMS(totalPlayed))
            totalTimeLabel:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            yOffset = yOffset - 22

            for key, h in pairs(levelSortHeaders) do
                h:ClearAllPoints()
                h:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT + LevelCols[key].x, yOffset)
                h:Show()
            end
            yOffset = yOffset - 20

            local levelRows = {}
            for lvl = 1, playerLevel do
                local entry = levelsData[lvl]
                local prevEntry = lvl > 1 and levelsData[lvl - 1] or nil

                local rowTotalTime = entry and entry.played or nil
                local timeForLevel = nil
                if lvl == 1 then
                    timeForLevel = 0
                elseif entry and prevEntry then
                    timeForLevel = entry.played - prevEntry.played
                end

                table.insert(levelRows, {
                    level = lvl,
                    timeForLevel = timeForLevel,
                    totalTime = rowTotalTime,
                })
            end

            table.sort(levelRows, function(a, b)
                local sk = levelSortState.sortKey
                local asc = levelSortState.sortAsc
                local valA, valB
                if sk == "level" then
                    valA, valB = a.level, b.level
                elseif sk == "timeForLevel" then
                    valA, valB = a.timeForLevel, b.timeForLevel
                else
                    valA, valB = a.totalTime, b.totalTime
                end
                if valA == nil and valB == nil then return false end
                if valA == nil then return false end
                if valB == nil then return true end
                if asc then return valA < valB else return valA > valB end
            end)

            for _, rowData in ipairs(levelRows) do
                local row = GetFrame("levelRow")
                row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT, yOffset)
                row:SetPoint("RIGHT", scrollChild, "RIGHT", CONTENT_RIGHT - 12, 0)

                row.level:SetText(tostring(rowData.level))
                row.level:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)

                row.timeForLevel:SetText(LevelsModule:FormatTimeHMS(rowData.timeForLevel))
                row.timeForLevel:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

                row.totalTime:SetText(LevelsModule:FormatTimeHMS(rowData.totalTime))
                row.totalTime:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

                yOffset = yOffset - LEVEL_ROW_HEIGHT
            end
        end

        yOffset = yOffset - 10

        -- Warnings Section (from shared module)
        local activeWarnings = Deathless.Utils.Warnings:GetActive()
        
        -- Display Warnings Section
        local hasWarnings = #activeWarnings > 0
        local warningsColor = hasWarnings and Colors.yellow or Colors.accent
        yOffset = CreateSectionHeader("warnings", "Warnings", hasWarnings and #activeWarnings or nil, yOffset, warningsColor)
        
        if sectionState.warnings then
            if hasWarnings then
                for _, warning in ipairs(activeWarnings) do
                    local row = GetFrame("row")
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 12, yOffset)
                    row:SetPoint("RIGHT", scrollChild, "RIGHT", CONTENT_RIGHT - 12, yOffset)
                    
                    if row.icon then
                        row.icon:SetTexture(warning.icon or Icons.DEFAULT)
                        UIUtils.ApplyIconStyle(row.icon, "normal")
                    end
                    
                    row.name:SetText(warning.text)
                    row.name:SetTextColor(Colors.yellow[1], Colors.yellow[2], Colors.yellow[3], 1)
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
                msg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 12, yOffset - 5)
                msg:SetText("No warnings - go adventure!")
                msg:SetTextColor(Colors.success[1], Colors.success[2], Colors.success[3], Colors.success[4])
                yOffset = yOffset - 24
            end
        end
        
        yOffset = yOffset - 10  -- Spacing between sections
        
        -- Abilities sections
        if #available > 0 then
            local availableCost = 0
            for _, ability in ipairs(available) do
                availableCost = availableCost + (ability.base_cost or 0)
            end
            
            yOffset = CreateSectionHeader(
                "available",
                "Available",
                #available,
                yOffset,
                { Colors.accent[1], Colors.accent[2], Colors.accent[3] },
                "Total: " .. FormatMoneyColored(availableCost)
            )
            
            if sectionState.available then
                for _, ability in ipairs(available) do
                    local row = GetFrame("row")
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 12, yOffset)
                    row:SetPoint("RIGHT", scrollChild, "RIGHT", CONTENT_RIGHT - 12, yOffset)
                    
                    row.icon:SetTexture(Icons:GetIconPath(ability.icon))
                    UIUtils.ApplyIconStyle(row.icon, "normal")
                    row.level:Hide()
                    
                    local nameText = ability.name
                    if ability.rank and ability.rank > 1 then
                        nameText = nameText .. " (Rank " .. ability.rank .. ")"
                    end
                    
                    row.name:ClearAllPoints()
                    row.name:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
                    row.name:SetPoint("RIGHT", row.cost, "LEFT", -12, 0)
                    row.name:SetJustifyH("LEFT")
                    row.name:SetText(nameText)
                    row.name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                    
                    row.cost:ClearAllPoints()
                    row.cost:SetPoint("RIGHT", row, "RIGHT", -4, 0)
                    if ability.base_cost == 0 then
                        row.cost:SetText("Free")
                        row.cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                    else
                        row.cost:SetText(FormatMoneyColored(ability.base_cost))
                        row.cost:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], Colors.white[4])
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
            
            yOffset = CreateSectionHeader(
                "nextAvailable",
                "Next Available",
                #nextAvailable,
                yOffset,
                Colors.xpNext,
                "Total: " .. FormatMoneyColored(nextCost)
            )
            
            if sectionState.nextAvailable then
                for _, ability in ipairs(nextAvailable) do
                    local row = GetFrame("row")
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 12, yOffset)
                    row:SetPoint("RIGHT", scrollChild, "RIGHT", CONTENT_RIGHT - 12, yOffset)
                    
                    row.icon:SetTexture(Icons:GetIconPath(ability.icon))
                    UIUtils.ApplyIconStyle(row.icon, "dimmed")
                    row.level:Hide()
                    
                    local nameText = ability.name
                    if ability.rank and ability.rank > 1 then
                        nameText = nameText .. " (Rank " .. ability.rank .. ")"
                    end
                    
                    row.name:ClearAllPoints()
                    row.name:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
                    row.name:SetPoint("RIGHT", row.cost, "LEFT", -12, 0)
                    row.name:SetJustifyH("LEFT")
                    row.name:SetText(nameText)
                    row.name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 0.6)
                    
                    row.cost:ClearAllPoints()
                    row.cost:SetPoint("RIGHT", row, "RIGHT", -4, 0)
                    if ability.base_cost == 0 then
                        row.cost:SetText("Free")
                        row.cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.6)
                    else
                        row.cost:SetText(FormatMoneyColored(ability.base_cost))
                        row.cost:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], Colors.white[4])
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
        
        if #available == 0 and #nextAvailable == 0 then
            local msg = GetFrame("text")
            msg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 12, yOffset)
            msg:SetText("No new abilities available soon.")
            yOffset = yOffset - 20
        end
        
        scrollChild:SetHeight(math.abs(yOffset) + 20)
        
        -- Update scrollbar visibility after content changes
        C_Timer.After(0, function()
            if scrollFrame.UpdateScrollbar then
                scrollFrame.UpdateScrollbar()
            end
        end)
    end
    
    -- Live ticker for Total Time label (updates every second without full Refresh)
    local tickerElapsed = 0
    container:SetScript("OnUpdate", function(_, dt)
        tickerElapsed = tickerElapsed + dt
        if tickerElapsed < 1 then return end
        tickerElapsed = 0
        if totalTimeLabel and totalTimeLabel:IsShown() then
            local played = LevelsModule:GetTotalPlayed()
            totalTimeLabel:SetText("Total Time: " .. LevelsModule:FormatTimeHMS(played))
        end
    end)

    -- Refresh when shown
    container:SetScript("OnShow", function()
        if scrollFrame.ResetScroll then
            scrollFrame.ResetScroll()
        end
        LevelsModule:RequestPlayed()
        Refresh()
    end)
    
    -- Register for automatic refresh when warnings/state changes
    Deathless.Utils.Warnings:RegisterRefresh(NavIds.MY_JOURNEY, function()
        if container:IsVisible() then
            Refresh()
        end
    end)

    -- Register for level data refresh (TIME_PLAYED_MSG response)
    LevelsModule:RegisterRefresh(NavIds.MY_JOURNEY, function()
        if container:IsVisible() then
            Refresh()
        end
    end)
    
    -- Initial render
    Refresh()
    
    return { title = title, subtitle = subtitle, scrollFrame = scrollFrame }
end)
