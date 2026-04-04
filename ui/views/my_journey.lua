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
local LEVEL_BRACKET_SIZE = LevelLayout.bracketSize

    Deathless.UI.Views:Register(NavIds.MY_JOURNEY, function(container)
        local Colors = Utils:GetColors()
        local Fonts = Deathless.UI.Fonts
    local Layout = Utils.Layout
    local IconStyle = Deathless.Constants.Colors.UI.Icon
    local ClassColors = Deathless.Constants.Colors.Class
    local ItemQuality = Deathless.Constants.Colors.ItemQuality
    local Colorize = UIUtils.ColorizeText
        local CONTENT_LEFT = 12
        local CONTENT_RIGHT = -12
        local SECTION_LEFT = CONTENT_LEFT + 12
    
    local title, subtitle, headerSeparator = Utils:CreateHeader(container, "", "", { 1, 1, 1 })
    subtitle:Hide()
    headerSeparator:ClearAllPoints()
    headerSeparator:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -10)
    headerSeparator:SetPoint("RIGHT", container, "RIGHT", -20, 0)
    
    local function LevelToItemQualityColor(level)
        if level >= 60 then return ItemQuality.legendary end
        if level >= 50 then return ItemQuality.epic end
        if level >= 35 then return ItemQuality.rare end
        if level >= 20 then return ItemQuality.uncommon end
        if level >= 10 then return ItemQuality.common end
        return ItemQuality.trash
    end

    local function UpdateJourneyTitle()
        local playerName = UnitName("player") or ""
        local _, classFile = UnitClass("player")
        local classKey = (classFile and classFile:lower()) or "warrior"
        local classColor = ClassColors[classKey] or Colors.accent
        local level = UnitLevel("player") or 1
        if level < 1 then level = 1 end
        local journey = Colorize(classColor, playerName .. "'s Journey")
        local levelStr = Colorize(LevelToItemQualityColor(level), "(" .. tostring(level) .. ")")
        title:SetText(journey .. " " .. levelStr)
    end
    UpdateJourneyTitle()
    
    -- Enhanced scroll frame with auto-hiding scrollbar
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, ViewOffsets.simple.scrollTop, ViewOffsets.defaultScrollBottom)
    
    -- Section collapse state
    local sectionState = { levels = true, recommendedDungeons = true, warnings = true, available = true, nextAvailable = true }
    
    -- Element pooling
    local pools = {
        dungeonRow = {},
        levelRow = {},
        section = {},
        subsection = {},
        subheader = {},
        row = {},
        text = {},
    }
    local poolIndexes = {
        dungeonRow = 0,
        levelRow = 0,
        section = 0,
        subsection = 0,
        subheader = 0,
        row = 0,
        text = 0,
    }
    
    -- Forward declare Refresh for section click handlers
    local Refresh
    local levelHeaders, levelHeaderBorder, levelHeaderBg, levelDividers, levelHeaderDefs
    local levelBorders
    local totalTimeValue = nil
    local currentLevelTimeValue = nil
    
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
            elseif frameType == "dungeonRow" then
                frame = CreateFrame("Button", nil, scrollChild)
                frame:SetHeight(22)

                frame.name = frame:CreateFontString(nil, "OVERLAY")
                frame.name:SetFont(Fonts.family, Fonts.body, "")
                frame.name:SetPoint("LEFT", frame, "LEFT", 0, 0)
                frame.name:SetJustifyH("LEFT")

                frame.boss = frame:CreateFontString(nil, "OVERLAY")
                frame.boss:SetFont(Fonts.family, Fonts.body, "")
                frame.boss:SetPoint("RIGHT", frame, "RIGHT", -4, 0)
                frame.boss:SetJustifyH("RIGHT")

                frame.name:SetPoint("RIGHT", frame.boss, "LEFT", -12, 0)

                frame:SetScript("OnEnter", function(self)
                    self.name:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                end)
                frame:SetScript("OnLeave", function(self)
                    self.name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                end)
            elseif frameType == "levelRow" then
                frame = CreateFrame("Button", nil, scrollChild)
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
    --- @param tooltip table|nil Optional { title = "...", "line1", "line2", ... }
    local function CreateSectionHeader(sectionKey, label, count, yOffset, color, costText, tooltip)
        local section = GetFrame("section")
        local SECTION_HEIGHT = Layout.sectionHeight
        
        section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
        section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
        
        local displayLabel = tooltip and (label .. " (?)") or label
        Utils:ConfigureSection(section, sectionState[sectionKey], displayLabel, color, count, costText)
        
        section.sectionKey = sectionKey
        section:SetScript("OnClick", function(self)
            sectionState[self.sectionKey] = not sectionState[self.sectionKey]
            Refresh()
        end)

        if tooltip then
            local SectionStyle = Deathless.Constants.Colors.UI.SectionHeader
            section:SetScript("OnEnter", function(self)
                self.bg:SetColorTexture(Colors.bgLight[1] + 0.05, Colors.bgLight[2] + 0.05, Colors.bgLight[3] + 0.05, SectionStyle.hoverAlpha)
                Deathless.UI.Tooltip:Show(self, "ANCHOR_TOP", tooltip.title or label, tooltip)
            end)
            section:SetScript("OnLeave", function(self)
                self.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], SectionStyle.bgAlpha)
                Deathless.UI.Tooltip:Hide()
            end)
        end
        
        return yOffset - SECTION_HEIGHT
    end
    
    --- Create a collapsible subsection header
    local function CreateSubSectionHeader(sectionKey, label, yOffset, color, costText)
        local subsection = GetFrame("subsection")
        local SUBSECTION_HEIGHT = 22
        
        subsection:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT + 20, yOffset)
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
    
    local TableComp = Deathless.UI.Components.Table

    local function ClearFrames()
        for type, pool in pairs(pools) do
            for _, frame in ipairs(pool) do
                frame:Hide()
                frame:ClearAllPoints()
            end
            poolIndexes[type] = 0
        end
        for _, h in ipairs(levelHeaders) do h:Hide() end
        levelHeaderBg:Hide()
        levelHeaderBorder:Hide()
        for _, d in ipairs(levelDividers) do d:Hide() end
        TableComp:HideBorders(levelBorders)
    end
    
    -- Level column headers, border, and dividers (persistent, repositioned each Refresh)
    levelHeaderDefs = {
        { label = "LEVEL",          x = LevelCols.level.x },
        { label = "TIME FOR LEVEL", x = LevelCols.timeForLevel.x },
        { label = "TOTAL TIME",     x = LevelCols.totalTime.x },
    }
    levelHeaders = TableComp:CreateStaticHeaders(scrollChild, levelHeaderDefs, { xBase = SECTION_LEFT })
    for _, h in ipairs(levelHeaders) do h:Hide() end

    levelHeaderBg = TableComp:CreateHeaderBackground(scrollChild, {
        xLeft = SECTION_LEFT, xRight = CONTENT_RIGHT - 12,
    })
    levelHeaderBg:Hide()

    levelHeaderBorder = TableComp:CreateHeaderBorder(scrollChild, {
        xLeft = SECTION_LEFT, xRight = CONTENT_RIGHT - 12,
    })
    levelHeaderBorder:Hide()

    levelDividers = TableComp:CreateColumnDividers(scrollChild,
        { LevelCols.timeForLevel.x - 10, LevelCols.totalTime.x - 10 },
        { xBase = SECTION_LEFT, height = 14 }
    )
    for _, d in ipairs(levelDividers) do d:Hide() end

    levelBorders = TableComp:CreateBorderGroup(scrollChild)

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
            local summaryValueX = SECTION_LEFT + LevelCols.timeForLevel.x

            local totalTimeLbl = GetFrame("text")
            totalTimeLbl:SetFont(Fonts.family, Fonts.subtitle, "")
            totalTimeLbl:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT, yOffset - 2)
            totalTimeLbl:SetText("Total Time:")
            totalTimeLbl:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)

            totalTimeValue = GetFrame("text")
            totalTimeValue:SetFont(Fonts.code, Fonts.subtitle, "")
            totalTimeValue:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", summaryValueX, yOffset - 2)
            totalTimeValue:SetText(LevelsModule:FormatTimeHMS(totalPlayed))
            totalTimeValue:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            yOffset = yOffset - 22

            local currentLevelLbl = GetFrame("text")
            currentLevelLbl:SetFont(Fonts.family, Fonts.subtitle, "")
            currentLevelLbl:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT, yOffset - 2)
            currentLevelLbl:SetText("Current Level:")
            currentLevelLbl:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)

            currentLevelTimeValue = GetFrame("text")
            currentLevelTimeValue:SetFont(Fonts.code, Fonts.subtitle, "")
            currentLevelTimeValue:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", summaryValueX, yOffset - 2)
            local currentLevelEntry = levelsData[playerLevel]
            local currentLevelTime = (totalPlayed and currentLevelEntry) and (totalPlayed - currentLevelEntry.played) or nil
            currentLevelTimeValue:SetText(LevelsModule:FormatTimeHMS(currentLevelTime))
            currentLevelTimeValue:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            yOffset = yOffset - 30

            local levelTableTop = yOffset

            -- Header background bar
            levelHeaderBg:ClearAllPoints()
            levelHeaderBg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT, yOffset)
            levelHeaderBg:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT - 12, yOffset)
            levelHeaderBg:Show()

            -- Header labels (vertically centered in the 20px bar)
            for i, h in ipairs(levelHeaders) do
                h:ClearAllPoints()
                h:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT + levelHeaderDefs[i].x, yOffset - 5)
                h:Show()
            end
            for _, d in ipairs(levelDividers) do
                d:ClearAllPoints()
                d:SetPoint("TOPLEFT", scrollChild, "TOPLEFT",
                    d._tableDivX, yOffset - 3)
                d:Show()
            end
            yOffset = yOffset - 20

            -- Border line under header bar
            levelHeaderBorder:ClearAllPoints()
            levelHeaderBorder:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT, yOffset)
            levelHeaderBorder:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT - 12, yOffset)
            levelHeaderBorder:Show()
            yOffset = yOffset - 2

            local allLevelRows = {}
            for lvl = 1, playerLevel do
                local entry = levelsData[lvl]
                local prevEntry = lvl > 1 and levelsData[lvl - 1] or nil

                local rowTotalTime = (lvl > 1 and entry) and entry.played or nil
                local timeForLevel = nil
                if lvl == 1 then
                    timeForLevel = nil
                elseif entry and prevEntry then
                    timeForLevel = entry.played - prevEntry.played
                end

                table.insert(allLevelRows, {
                    level = lvl,
                    timeForLevel = timeForLevel,
                    totalTime = rowTotalTime,
                })
            end

            -- Render level rows grouped into collapsible brackets
            local currentBracketIdx = math.floor((playerLevel - 1) / LEVEL_BRACKET_SIZE)
            for bracketIdx = currentBracketIdx, 0, -1 do
                local bracketStart = bracketIdx * LEVEL_BRACKET_SIZE + 1
                local bracketEnd = math.min(bracketStart + LEVEL_BRACKET_SIZE - 1, 60)
                local bracketKey = "levels_" .. bracketStart .. "_" .. bracketEnd

                if sectionState[bracketKey] == nil then
                    sectionState[bracketKey] = false
                end

                local bracketRows = {}
                for _, r in ipairs(allLevelRows) do
                    if r.level >= bracketStart and r.level <= bracketEnd then
                        table.insert(bracketRows, r)
                    end
                end

                yOffset = CreateSubSectionHeader(
                    bracketKey,
                    "Levels " .. bracketStart .. " - " .. bracketEnd,
                    yOffset, Colors.text
                )

                if sectionState[bracketKey] then
                    local rowNum = 0
                    for i = #bracketRows, 1, -1 do
                        local rowData = bracketRows[i]
                        rowNum = rowNum + 1
                        local row = GetFrame("levelRow")
                        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT, yOffset)
                        row:SetPoint("RIGHT", scrollChild, "RIGHT", CONTENT_RIGHT - 12, 0)
                        UIUtils.ApplyStripedRowBackground(row, Colors, rowNum)
                        TableComp:ApplyRowHover(row)

                        row.level:SetText(tostring(rowData.level))
                        row.level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

                        row.timeForLevel:SetText(LevelsModule:FormatTimeHMS(rowData.timeForLevel))
                        row.timeForLevel:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

                        row.totalTime:SetText(LevelsModule:FormatTimeHMS(rowData.totalTime))
                        row.totalTime:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

                        yOffset = yOffset - LEVEL_ROW_HEIGHT
                    end
                end
            end

            TableComp:PositionBorders(levelBorders, scrollChild, levelTableTop, yOffset, SECTION_LEFT, CONTENT_RIGHT - 12)
        end

        yOffset = yOffset - 10

        -- Recommended Dungeons Section
        local rawDungeons = Deathless.Data.Dungeons or {}
        local endgameIds = Deathless.Constants.EndgameDungeonIds
        local recommendedDungeons = {}
        for _, dungeon in ipairs(rawDungeons) do
            local inBossRange = math.abs(playerLevel - dungeon.bossLevel) <= 3
            local gatedAtMax = endgameIds[dungeon.id] and playerLevel < 60
            if inBossRange and not gatedAtMax then
                table.insert(recommendedDungeons, dungeon)
            end
        end
        table.sort(recommendedDungeons, function(a, b) return a.bossLevel < b.bossLevel end)

        local recCount = #recommendedDungeons > 0 and #recommendedDungeons or nil
        yOffset = CreateSectionHeader("recommendedDungeons", "Recommended Dungeons", recCount, yOffset, Colors.accent, nil, {
            title = "Recommended Dungeons",
            "Dungeons where the end boss is within",
            "3 levels of your character.",
        })

        if sectionState.recommendedDungeons then
            if #recommendedDungeons > 0 then
                local GetDifficultyColor = UIUtils.GetDifficultyColor
                for _, dungeon in ipairs(recommendedDungeons) do
                    local row = GetFrame("dungeonRow")
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT, yOffset)
                    row:SetPoint("RIGHT", scrollChild, "RIGHT", CONTENT_RIGHT - 12, 0)

                    row.name:SetText(dungeon.name)
                    row.name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)

                    local bossColor = GetDifficultyColor(dungeon.bossLevel, playerLevel)
                    row.boss:SetText(dungeon.endBoss .. " (" .. dungeon.bossLevel .. ")")
                    row.boss:SetTextColor(bossColor[1], bossColor[2], bossColor[3], 1)

                    local dungeonId = dungeon.id
                    row:SetScript("OnClick", function()
                        Deathless.UI.Navigation:Select("dungeons")
                        local view = Deathless.UI.Content.frame
                            and Deathless.UI.Content.frame.views["dungeons"]
                        if view and view.elements and view.elements.ExpandDungeon then
                            view.elements.ExpandDungeon(dungeonId)
                        end
                    end)

                    yOffset = yOffset - 22
                end
            else
                local msg = GetFrame("text")
                msg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", SECTION_LEFT, yOffset - 2)
                msg:SetText("No dungeons recommended for your level.")
                msg:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                yOffset = yOffset - 20
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
        local played = LevelsModule:GetTotalPlayed()
        if totalTimeValue and totalTimeValue:IsShown() then
            totalTimeValue:SetText(LevelsModule:FormatTimeHMS(played))
        end
        if currentLevelTimeValue and currentLevelTimeValue:IsShown() then
            local lvl = UnitLevel("player") or 1
            local entry = LevelsModule:GetData()[lvl]
            local currentTime = (played and entry) and (played - entry.played) or nil
            currentLevelTimeValue:SetText(LevelsModule:FormatTimeHMS(currentTime))
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
