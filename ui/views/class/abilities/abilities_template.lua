local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local Icons = Deathless.Utils.Icons

-- Store template for reuse
Deathless.UI.Views.AbilitiesTemplate = {}

local AbilityUtils = Deathless.Utils.Abilities
local UIUtils = Deathless.Utils.UI
local FormatMoneyColored = AbilityUtils.FormatMoneyColored
local IsSpellKnown = AbilityUtils.IsSpellKnown
local ColorCodes = Deathless.Constants.Colors.Codes
local TableLayout = Deathless.Constants.Colors.UI.TableLayouts.Abilities
local ViewOffsets = Deathless.Constants.Colors.UI.ViewOffsets

--- Create an abilities view for a specific class
---@param config table Configuration: { viewName, className, classId, classColor }
function Deathless.UI.Views.AbilitiesTemplate:Create(config)
    local viewName = config.viewName       -- e.g., "warrior_abilities"
    local className = config.className     -- e.g., "Warrior"
    local classId = config.classId         -- e.g., "WARRIOR"
    local classColor = config.classColor   -- e.g., { 0.78, 0.61, 0.43 }
    
    Deathless.UI.Views:Register(viewName, function(container, options)
        local Colors = Utils:GetColors()
        local Fonts = Deathless.UI.Fonts
        local Layout = Utils.Layout
        local Col = TableLayout.columns
        local Row = TableLayout.row
        local embedded = options and options.embedded
        local CONTENT_LEFT = 12
        local CONTENT_RIGHT = -12
        local TableComp = Deathless.UI.Components.Table
        
        local title, subtitle
        if not embedded then
            title, subtitle = Utils:CreateHeader(container, className .. " Abilities", "", classColor)
        end
        
        local searchBoxY = embedded and ViewOffsets.classSearch.searchYEmbedded or ViewOffsets.classSearch.searchYFull
        local sortHeaderY = embedded and ViewOffsets.classSearch.sortHeaderYEmbedded or ViewOffsets.classSearch.sortHeaderYFull
        local scrollTopOffset = embedded and ViewOffsets.classSearch.scrollTopEmbedded or ViewOffsets.classSearch.scrollTopFull
        
        -- Search state
        local searchState = { term = "" }
        local filterState = {}
        local FILTER_ORDER = { "learned", "available", "nextAvailable", "unavailable" }
        local FILTER_LABELS = {
            learned = "Learned",
            available = "Available",
            nextAvailable = "Next Available",
            unavailable = "Unavailable",
        }
        
        -- Create search bar
        local searchBox, searchLabel, clearBtn = Utils:CreateSearchControl(container, {
            x = 24,
            y = searchBoxY,
            label = "Search",
        })

        -- Ability filter controls
        Deathless.config.abilities = Deathless.config.abilities or {}
        Deathless.config.abilities.filters = Deathless.config.abilities.filters or {}
        for _, key in ipairs(FILTER_ORDER) do
            filterState[key] = Deathless.config.abilities.filters[key] ~= false
        end

        local function SaveFilterState()
            Deathless.config.abilities = Deathless.config.abilities or {}
            Deathless.config.abilities.filters = Deathless.config.abilities.filters or {}
            for _, key in ipairs(FILTER_ORDER) do
                Deathless.config.abilities.filters[key] = filterState[key] ~= false
            end
            Deathless:SaveConfig()
        end

        local function UpdateFilterCheckboxVisual(button, checked)
            Utils:SetFilterCheckboxVisual(button, checked)
        end

        local PopulateRows
        local filterCheckboxes = {}

        local function CreateFilterCheckbox(filterKey, xOffset, width)
            local button = Utils:CreateFilterCheckboxControl(container, {
                width = width,
                xOffset = xOffset,
                relativeTo = searchBox,
                label = FILTER_LABELS[filterKey],
            })

            button.filterKey = filterKey
            UpdateFilterCheckboxVisual(button, filterState[filterKey] == true)

            button:SetScript("OnEnter", function(self)
                self.border:SetColorTexture(Colors.accent[1] * 0.8, Colors.accent[2] * 0.8, Colors.accent[3] * 0.8, 1)
                self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            end)
            button:SetScript("OnLeave", function(self)
                self.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
                UpdateFilterCheckboxVisual(self, filterState[self.filterKey] == true)
            end)
            button:SetScript("OnClick", function(self)
                local key = self.filterKey
                filterState[key] = not filterState[key]
                for _, cb in ipairs(filterCheckboxes) do
                    UpdateFilterCheckboxVisual(cb, filterState[cb.filterKey] == true)
                end
                SaveFilterState()
                if PopulateRows then
                    PopulateRows()
                end
            end)

            return button
        end

        table.insert(filterCheckboxes, CreateFilterCheckbox("learned", 16, 78))
        table.insert(filterCheckboxes, CreateFilterCheckbox("available", 102, 84))
        table.insert(filterCheckboxes, CreateFilterCheckbox("nextAvailable", 194, 108))
        table.insert(filterCheckboxes, CreateFilterCheckbox("unavailable", 310, 96))
        
        -- Enhanced scroll frame with auto-hiding scrollbar
        local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, scrollTopOffset, ViewOffsets.defaultScrollBottom)
        
        -- Sort state
        local sortState = { sortKey = "level", sortAsc = true }
        
        -- Section collapse state
        local sectionState = { learned = false, available = true, nextAvailable = true, unavailable = false }
        
        -- Get raw abilities data
        local rawAbilities = Deathless.Data.Abilities and Deathless.Data.Abilities[className] or {}
        
        -- Element pools
        local rowPool = {}
        local sectionPool = {}
        local poolIndex = 0
        local sectionIndex = 0
        
        local function ClearElements()
            for _, row in ipairs(rowPool) do
                row:Hide()
                row:ClearAllPoints()
            end
            for _, section in ipairs(sectionPool) do
                section:Hide()
                section:ClearAllPoints()
            end
            poolIndex = 0
            sectionIndex = 0
        end
        
        local function GetSectionHeader()
            sectionIndex = sectionIndex + 1
            local section = sectionPool[sectionIndex]
            if not section then
                section = Utils:CreateCollapsibleSection(scrollChild)
                sectionPool[sectionIndex] = section
            end
            return section
        end
        
        local function GetAbilityRow()
            poolIndex = poolIndex + 1
            local row = rowPool[poolIndex]
            if not row then
                row = CreateFrame("Button", nil, scrollChild)
                
                row.icon = row:CreateTexture(nil, "ARTWORK")
                row.icon:SetSize(Row.iconSize, Row.iconSize)
                row.icon:SetPoint("LEFT", row, "LEFT", Row.iconX, 0)
                row.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                
                row.name = row:CreateFontString(nil, "OVERLAY")
                row.name:SetFont(Fonts.family, Fonts.body, "")
                row.name:SetPoint("LEFT", row.icon, "RIGHT", 8, 0)
                row.name:SetWidth(Row.nameWidth)
                row.name:SetJustifyH("LEFT")
                
                row.level = row:CreateFontString(nil, "OVERLAY")
                row.level:SetFont(Fonts.family, Fonts.body, "")
                row.level:SetPoint("LEFT", row, "LEFT", Col.level.x, 0)
                row.level:SetWidth(Col.level.w)
                row.level:SetJustifyH("CENTER")
                
                row.cost = row:CreateFontString(nil, "OVERLAY")
                row.cost:SetFont(Fonts.family, Fonts.body, "")
                row.cost:SetPoint("LEFT", row, "LEFT", Col.cost.x, 0)
                row.cost:SetWidth(Col.cost.w)
                row.cost:SetJustifyH("RIGHT")
                
                row.source = row:CreateFontString(nil, "OVERLAY")
                row.source:SetFont(Fonts.family, Fonts.body, "")
                row.source:SetPoint("LEFT", row, "LEFT", Col.source.x, 0)
                row.source:SetWidth(Col.source.w)
                row.source:SetJustifyH("LEFT")
                
                row.train = row:CreateFontString(nil, "OVERLAY")
                row.train:SetFont(Fonts.family, Fonts.body, "")
                row.train:SetPoint("LEFT", row, "LEFT", Col.train.x, 0)
                row.train:SetWidth(Col.train.w)
                row.train:SetJustifyH("CENTER")
                
                TableComp:ApplyRowHover(row)
                rowPool[poolIndex] = row
            end
            return row
        end
        
        local function SortAbilities(abilities)
            local sorted = {}
            for _, ability in ipairs(abilities) do
                table.insert(sorted, ability)
            end
            
            local key = sortState.sortKey
            local asc = sortState.sortAsc
            
            table.sort(sorted, function(a, b)
                local valA, valB
                
                if key == "name" then
                    if a.name == b.name then
                        valA, valB = a.rank or 1, b.rank or 1
                    else
                        valA, valB = a.name, b.name
                    end
                elseif key == "level" then
                    valA, valB = a.level, b.level
                elseif key == "cost" then
                    valA, valB = a.base_cost, b.base_cost
                elseif key == "source" then
                    valA, valB = a.source, b.source
                elseif key == "train" then
                    -- Sort order: yes < maybe < no (priority order)
                    local trainOrder = { yes = 1, maybe = 2, no = 3 }
                    valA = trainOrder[a.train or "yes"] or 2
                    valB = trainOrder[b.train or "yes"] or 2
                else
                    valA, valB = a.level, b.level
                end
                
                if asc then
                    return valA < valB
                else
                    return valA > valB
                end
            end)
            
            return sorted
        end
        
        local function CreateAbilityRowAt(ability, yOffset, rowNum, dimmed)
            local row = GetAbilityRow()
            local ROW_HEIGHT = TableLayout.rowHeight
            
            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
            row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
            row:SetHeight(ROW_HEIGHT)
            row:Show()
            
            row:SetScript("OnEnter", function(self)
                if ability.spellId then
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 8, 0)
                    GameTooltip:SetSpellByID(ability.spellId)
                    GameTooltip:Show()
                end
            end)
            row:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
            
            UIUtils.ApplyStripedRowBackground(row, Colors, rowNum)
            
            row.icon:SetTexture(Icons:GetIconPath(ability.icon))
            UIUtils.ApplyIconStyle(row.icon, dimmed and "faded" or "normal")
            
            local nameText = ability.name
            if ability.rank and ability.rank > 1 then
                nameText = nameText .. " (Rank " .. ability.rank .. ")"
            end
            row.name:SetText(nameText)
            if dimmed then
                row.name:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.6)
            else
                row.name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            end
            
            row.level:SetText("Lv " .. ability.level)
            if dimmed then
                row.level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.6)
            else
                row.level:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            end
            
            if ability.base_cost == 0 then
                row.cost:SetText("Free")
                row.cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], dimmed and 0.6 or 1)
            else
                row.cost:SetText(FormatMoneyColored(ability.base_cost))
                row.cost:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], dimmed and 0.6 or 1)
            end
            
            local sourceText = ability.source:sub(1, 1):upper() .. ability.source:sub(2)
            row.source:SetText(sourceText)
            row.source:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], dimmed and 0.6 or 1)
            
            local trainValue = ability.train or "yes"
            local trainText = trainValue:sub(1, 1):upper() .. trainValue:sub(2)
            row.train:SetText(trainText)
            local alpha = dimmed and 0.6 or 1
            if trainValue == "yes" then
                row.train:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], alpha)
            elseif trainValue == "no" then
                row.train:SetTextColor(Colors.red[1], Colors.red[2], Colors.red[3], alpha)
            else
                row.train:SetTextColor(Colors.yellow[1], Colors.yellow[2], Colors.yellow[3], alpha)
            end
            
            return yOffset - ROW_HEIGHT
        end
        
        local function CreateSectionHeaderAt(sectionKey, label, count, yOffset, color, costCopper, costLabel)
            local section = GetSectionHeader()
            local SECTION_HEIGHT = Layout.sectionHeight
            
            section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
            section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
            section:Show()
            
            -- Format cost text if provided
            local costText = nil
            if costCopper then
                local prefix = costLabel or "Total"
                costText = prefix .. ": " .. FormatMoneyColored(costCopper)
            end
            
            Utils:ConfigureSection(section, sectionState[sectionKey], label, color, count, costText)
            
            section.sectionKey = sectionKey
            section:SetScript("OnClick", function(self)
                sectionState[self.sectionKey] = not sectionState[self.sectionKey]
                PopulateRows()
            end)
            
            return yOffset - SECTION_HEIGHT
        end
        
        local IsRaceMatch = AbilityUtils.IsRaceMatch
        local IsFactionMatch = AbilityUtils.IsFactionMatch
        
        local function IsTalentKnown(spellName)
            return IsSpellKnown(spellName, 1)
        end
        
        PopulateRows = function()
            ClearElements()
            
            local playerLevel = UnitLevel("player") or 60
            local _, playerClass = UnitClass("player")
            local playerRace = UnitRace("player") or ""
            local playerFaction = UnitFactionGroup("player") or ""
            local isCorrectClass = (playerClass == classId)
            
            local nextLevelCap = AbilityUtils.NextLevelCap(rawAbilities, playerLevel, function(ability)
                return AbilityUtils.IsMatch(ability, playerRace, playerFaction)
            end)
            
            -- Search filter
            local searchTerm = searchState.term:lower()
            local hasSearch = searchTerm ~= ""
            
            local learned = {}
            local available = {}
            local nextAvailable = {}
            local unavailable = {}
            
            for _, ability in ipairs(rawAbilities) do
                -- Apply search filter
                if hasSearch and not ability.name:lower():find(searchTerm, 1, true) then
                    -- Skip abilities that don't match search
                -- Skip abilities for other races/factions
                elseif not IsRaceMatch(ability, playerRace) or not IsFactionMatch(ability, playerFaction) then
                    -- Skip this ability entirely
                elseif ability.source == "talent" then
                    local hasTalent = IsTalentKnown(ability.name)
                    if hasTalent then
                        local isKnown = IsSpellKnown(ability.name, ability.rank)
                        if isKnown then
                            table.insert(learned, ability)
                        elseif isCorrectClass and ability.level <= playerLevel then
                            table.insert(available, ability)
                        elseif isCorrectClass and ability.level <= nextLevelCap then
                            table.insert(nextAvailable, ability)
                        else
                            table.insert(unavailable, ability)
                        end
                    end
                else
                    local isKnown = IsSpellKnown(ability.name, ability.rank)
                    if isKnown then
                        table.insert(learned, ability)
                    elseif isCorrectClass and ability.level <= playerLevel then
                        table.insert(available, ability)
                    elseif isCorrectClass and ability.level <= nextLevelCap then
                        table.insert(nextAvailable, ability)
                    else
                        table.insert(unavailable, ability)
                    end
                end
            end
            
            learned = SortAbilities(learned)
            available = SortAbilities(available)
            nextAvailable = SortAbilities(nextAvailable)
            unavailable = SortAbilities(unavailable)
            
            local yOffset = 0
            local rowNum = 0
            
            local learnedColor = Deathless.Constants.Colors.AbilitySection.learned
            local availableColor = Colors.accent
            local nextAvailableColor = Deathless.Constants.Colors.AbilitySection.nextAvailable
            local unavailableColor = Deathless.Constants.Colors.AbilitySection.unavailable
            
            if filterState.learned and #learned > 0 then
                local learnedCost = 0
                for _, ability in ipairs(learned) do
                    learnedCost = learnedCost + (ability.base_cost or 0)
                end
                yOffset = CreateSectionHeaderAt("learned", "Learned", #learned, yOffset, learnedColor, learnedCost, "Spent")
                if sectionState.learned then
                    for _, ability in ipairs(learned) do
                        rowNum = rowNum + 1
                        yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, true)
                    end
                end
            end
            
            if filterState.available and #available > 0 then
                local availableCost = 0
                for _, ability in ipairs(available) do
                    availableCost = availableCost + (ability.base_cost or 0)
                end
                yOffset = CreateSectionHeaderAt("available", "Available", #available, yOffset, availableColor, availableCost)
                if sectionState.available then
                    for _, ability in ipairs(available) do
                        rowNum = rowNum + 1
                        yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, false)
                    end
                end
            end
            
            if filterState.nextAvailable and #nextAvailable > 0 then
                local totalCost = 0
                for _, ability in ipairs(nextAvailable) do
                    totalCost = totalCost + (ability.base_cost or 0)
                end
                yOffset = CreateSectionHeaderAt("nextAvailable", "Next Available", #nextAvailable, yOffset, nextAvailableColor, totalCost)
                if sectionState.nextAvailable then
                    for _, ability in ipairs(nextAvailable) do
                        rowNum = rowNum + 1
                        yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, false)
                    end
                end
            end
            
            if filterState.unavailable and #unavailable > 0 then
                local unavailableCost = 0
                for _, ability in ipairs(unavailable) do
                    unavailableCost = unavailableCost + (ability.base_cost or 0)
                end
                yOffset = CreateSectionHeaderAt("unavailable", "Unavailable", #unavailable, yOffset, unavailableColor, unavailableCost)
                if sectionState.unavailable then
                    for _, ability in ipairs(unavailable) do
                        rowNum = rowNum + 1
                        yOffset = CreateAbilityRowAt(ability, yOffset, rowNum, true)
                    end
                end
            end
            
            scrollChild:SetHeight(math.abs(yOffset) + 10)
            
            -- Update scrollbar visibility after content changes
            C_Timer.After(0, function()
                if scrollFrame.UpdateScrollbar then
                    scrollFrame.UpdateScrollbar()
                end
            end)
        end
        
        -- Wire up search box events
        searchBox:SetScript("OnTextChanged", function(self)
            local text = self:GetText()
            searchState.term = text
            if text ~= "" then
                clearBtn:Show()
            else
                clearBtn:Hide()
            end
            PopulateRows()
        end)
        
        searchBox:SetScript("OnEscapePressed", function(self)
            self:SetText("")
            self:ClearFocus()
        end)
        
        searchBox:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()
        end)
        
        -- Create headers
        local headers = {}
        
        local function OnSort()
            for _, header in pairs(headers) do
                if sortState.sortKey == header.sortKey then
                    header.label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                else
                    header.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                end
                header.UpdateLabel()
            end
            PopulateRows()
        end
        
        local function abilitiesHeaderLayout(col)
            return { x = col.x + CONTENT_LEFT, width = col.w, y = sortHeaderY }
        end

        headers.name = Utils:CreateSortableHeader(container, "ABILITY", "name", sortState, OnSort, abilitiesHeaderLayout(Col.name))
        headers.level = Utils:CreateSortableHeader(container, "LEVEL", "level", sortState, OnSort, abilitiesHeaderLayout(Col.level))
        headers.cost = Utils:CreateSortableHeader(container, "COST", "cost", sortState, OnSort, abilitiesHeaderLayout(Col.cost))
        headers.source = Utils:CreateSortableHeader(container, "SOURCE", "source", sortState, OnSort, abilitiesHeaderLayout(Col.source))
        headers.train = Utils:CreateSortableHeader(container, "TRAIN (?)", "train", sortState, OnSort, abilitiesHeaderLayout(Col.train), {
            title = "Training Priority",
            ColorCodes.safe .. "Yes|r - Train when available",
            ColorCodes.warning .. "Wait|r - Marginal upgrade",
            ColorCodes.enemy .. "No|r - Not useful for Hardcore",
        })
        
        OnSort()
        
        -- Register for automatic refresh when config changes
        Deathless.Utils.Warnings:RegisterRefresh(viewName, PopulateRows)
        
        return { 
            title = title, 
            subtitle = subtitle, 
            scrollFrame = scrollFrame, 
            scrollChild = scrollChild,
            headers = headers,
            searchBox = searchBox,
            Refresh = PopulateRows
        }
    end)
end

