local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

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
    
    local title, subtitle = Utils:CreateHeader(container, "Summary", "")
    
    -- Scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", container, "TOPLEFT", 8, -60)
    scrollFrame:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -28, 24)
    
    local scrollBar = scrollFrame.ScrollBar
    if scrollBar then
        scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 4, -16)
        scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 4, 16)
    end
    
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)
    
    -- Mouse wheel scrolling
    local targetScroll = 0
    local SCROLL_SPEED = 1.2
    local SCROLL_STEP = 40
    
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local maxScroll = scrollChild:GetHeight() - scrollFrame:GetHeight()
        if maxScroll < 0 then maxScroll = 0 end
        targetScroll = targetScroll - (delta * SCROLL_STEP)
        targetScroll = math.max(0, math.min(targetScroll, maxScroll))
    end)
    
    scrollFrame:SetScript("OnUpdate", function(self, elapsed)
        local current = self:GetVerticalScroll()
        if math.abs(current - targetScroll) > 0.5 then
            local newScroll = current + (targetScroll - current) * SCROLL_SPEED
            self:SetVerticalScroll(newScroll)
        elseif current ~= targetScroll then
            self:SetVerticalScroll(targetScroll)
        end
    end)
    
    -- Section collapse state
    local sectionState = { warnings = true, abilities = true }
    
    -- Element pooling
    local pools = {
        section = {},
        subheader = {},
        row = {},
        text = {}
    }
    local poolIndexes = {
        section = 0,
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
                frame = CreateFrame("Button", nil, scrollChild)
                frame:SetHeight(28)
                
                frame.bg = frame:CreateTexture(nil, "BACKGROUND")
                frame.bg:SetAllPoints()
                frame.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.4)
                
                frame.icon = frame:CreateFontString(nil, "OVERLAY")
                frame.icon:SetFont("Fonts\\ARIALN.TTF", 12, "")
                frame.icon:SetPoint("LEFT", frame, "LEFT", 8, 0)
                
                frame.label = frame:CreateFontString(nil, "OVERLAY")
                frame.label:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
                frame.label:SetPoint("LEFT", frame.icon, "RIGHT", 6, 0)
                
                frame.count = frame:CreateFontString(nil, "OVERLAY")
                frame.count:SetFont("Fonts\\ARIALN.TTF", 11, "")
                frame.count:SetPoint("LEFT", frame.label, "RIGHT", 8, 0)
                frame.count:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                
                frame:SetScript("OnEnter", function(self)
                    self.bg:SetColorTexture(Colors.bgLight[1] + 0.05, Colors.bgLight[2] + 0.05, Colors.bgLight[3] + 0.05, 0.6)
                end)
                frame:SetScript("OnLeave", function(self)
                    self.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.4)
                end)
            elseif frameType == "subheader" then
                frame = scrollChild:CreateFontString(nil, "OVERLAY")
                frame:SetFont("Fonts\\ARIALN.TTF", 12, "BOLD")
            elseif frameType == "row" then
                frame = CreateFrame("Frame", nil, scrollChild)
                frame:SetHeight(24)
                
                frame.icon = frame:CreateTexture(nil, "ARTWORK")
                frame.icon:SetSize(16, 16)
                frame.icon:SetPoint("LEFT", frame, "LEFT", 0, 0)
                frame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                
                frame.name = frame:CreateFontString(nil, "OVERLAY")
                frame.name:SetFont("Fonts\\ARIALN.TTF", 12, "")
                frame.name:SetPoint("LEFT", frame.icon, "RIGHT", 8, 0)
                
                frame.level = frame:CreateFontString(nil, "OVERLAY")
                frame.level:SetFont("Fonts\\ARIALN.TTF", 11, "")
                frame.level:SetPoint("RIGHT", frame, "RIGHT", -100, 0)
                
                frame.cost = frame:CreateFontString(nil, "OVERLAY")
                frame.cost:SetFont("Fonts\\ARIALN.TTF", 11, "")
                frame.cost:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
                
                frame:EnableMouse(true)
                frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
            elseif frameType == "text" then
                frame = scrollChild:CreateFontString(nil, "OVERLAY")
                frame:SetFont("Fonts\\ARIALN.TTF", 12, "")
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
        
        local isExpanded = sectionState[sectionKey]
        section.icon:SetText(isExpanded and "▼" or "►")
        section.icon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        section.label:SetText(label)
        section.label:SetTextColor(color[1], color[2], color[3], 1)
        
        if count then
            section.count:SetText("(" .. count .. ")")
            section.count:Show()
        else
            section.count:SetText("")
            section.count:Hide()
        end
        
        section.sectionKey = sectionKey
        section:SetScript("OnClick", function(self)
            sectionState[self.sectionKey] = not sectionState[self.sectionKey]
            Refresh()
        end)
        
        return yOffset - SECTION_HEIGHT
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
        
        -- Warnings Section
        
        -- Get First Aid skill level for bandage check
        local firstAidSkill = 0
        for i = 1, GetNumSkillLines() do
            local skillName, _, _, skillRank = GetSkillLineInfo(i)
            if skillName == "First Aid" then
                firstAidSkill = skillRank or 0
                break
            end
        end
        
        -- Tiered item tables (highest tier first)
        local bandages = {
            { req = 225, id = 14530, icon = "Interface\\Icons\\INV_Misc_Bandage_12" }, -- Heavy Runecloth Bandage
            { req = 200, id = 14529, icon = "Interface\\Icons\\INV_Misc_Bandage_11" }, -- Runecloth Bandage
            { req = 175, id = 8545,  icon = "Interface\\Icons\\INV_Misc_Bandage_20" }, -- Heavy Mageweave Bandage
            { req = 150, id = 8544,  icon = "Interface\\Icons\\INV_Misc_Bandage_19" }, -- Mageweave Bandage
            { req = 125, id = 6451,  icon = "Interface\\Icons\\INV_Misc_Bandage_02" }, -- Heavy Silk Bandage
            { req = 100, id = 6450,  icon = "Interface\\Icons\\INV_Misc_Bandage_01" }, -- Silk Bandage
            { req = 75,  id = 3531,  icon = "Interface\\Icons\\INV_Misc_Bandage_17" }, -- Heavy Wool Bandage
            { req = 50,  id = 3530,  icon = "Interface\\Icons\\INV_Misc_Bandage_14" }, -- Wool Bandage
            { req = 20,  id = 2581,  icon = "Interface\\Icons\\INV_Misc_Bandage_18" }, -- Heavy Linen Bandage
            { req = 1,   id = 1251,  icon = "Interface\\Icons\\INV_Misc_Bandage_15" }, -- Linen Bandage
        }
        
        local healthPotions = {
            { req = 45, id = 13446, icon = "Interface\\Icons\\INV_Potion_54" }, -- Major Healing Potion
            { req = 35, id = 3928,  icon = "Interface\\Icons\\INV_Potion_53" }, -- Superior Healing Potion
            { req = 21, id = 1710,  icon = "Interface\\Icons\\INV_Potion_52" }, -- Greater Healing Potion
            { req = 12, id = 929,   icon = "Interface\\Icons\\INV_Potion_51" }, -- Healing Potion
            { req = 3,  id = 858,   icon = "Interface\\Icons\\INV_Potion_50" }, -- Lesser Healing Potion
            { req = 1,  id = 118,   icon = "Interface\\Icons\\INV_Potion_49" }, -- Minor Healing Potion
        }
        
        local manaPotions = {
            { req = 49, id = 13444, icon = "Interface\\Icons\\INV_Potion_76" }, -- Major Mana Potion
            { req = 41, id = 13443, icon = "Interface\\Icons\\INV_Potion_74" }, -- Superior Mana Potion
            { req = 31, id = 6149,  icon = "Interface\\Icons\\INV_Potion_73" }, -- Greater Mana Potion
            { req = 22, id = 3827,  icon = "Interface\\Icons\\INV_Potion_72" }, -- Mana Potion
            { req = 14, id = 3385,  icon = "Interface\\Icons\\INV_Potion_71" }, -- Lesser Mana Potion
            { req = 1,  id = 2455,  icon = "Interface\\Icons\\INV_Potion_70" }, -- Minor Mana Potion
        }
        
        -- Helper to find best tiered item
        local function GetBestTiered(tiers, value)
            for _, tier in ipairs(tiers) do
                if value >= tier.req then
                    return tier.id, tier.icon
                end
            end
            return nil, nil
        end
        
        local bestBandageId, bestBandageIcon = GetBestTiered(bandages, firstAidSkill)
        local bestHealthId, bestHealthIcon = GetBestTiered(healthPotions, playerLevel)
        local bestManaId, bestManaIcon = GetBestTiered(manaPotions, playerLevel)
        
        -- Warning check definitions: { text, itemId, minCount, icon, condition }
        local warningChecks = {
            {
                text = "Not carrying Bandages for your First Aid skill level",
                itemId = bestBandageId,
                icon = bestBandageIcon,
                condition = firstAidSkill > 0 and bestBandageId
            },
            {
                text = "Not carrying Blinding Powder for Blind",
                itemId = 5530,
                icon = "Interface\\Icons\\INV_Misc_Dust_01",
                condition = classId == "ROGUE" and playerLevel >= 34
            },
            {
                text = "Not carrying Flash Powder for Vanish",
                itemId = 5140,
                icon = "Interface\\Icons\\INV_Misc_Powder_Black",
                condition = classId == "ROGUE" and playerLevel >= 22
            },
            {
                text = "Not carrying Flasks of Petrification (2 or more)",
                itemId = 13506,
                minCount = 2,
                icon = "Interface\\Icons\\INV_Potion_26",
                condition = playerLevel >= 50
            },
            {
                text = "Not carrying Healing Potions for your level",
                itemId = bestHealthId,
                icon = bestHealthIcon,
                condition = bestHealthId ~= nil
            },
            {
                text = "Not carrying Hearthstone",
                itemId = 6948,
                icon = "Interface\\Icons\\INV_Misc_Rune_01",
                condition = true
            },
            {
                text = "Not carrying Holy Candles",
                itemId = 17028,
                icon = "Interface\\Icons\\INV_Misc_Candle_01",
                condition = classId == "PRIEST" and playerLevel >= 48 and playerLevel < 60
            },
            {
                text = "Not carrying Light Feathers for Levitate",
                itemId = 17056,
                icon = "Interface\\Icons\\INV_Feather_02",
                condition = classId == "PRIEST" and playerLevel >= 34
            },
            {
                text = "Not carrying Light Feathers for Slow Fall",
                itemId = 17056,
                icon = "Interface\\Icons\\INV_Feather_02",
                condition = classId == "MAGE" and playerLevel >= 12
            },
            {
                text = "Not carrying Limited Invulnerability Potions",
                itemId = 3387,
                icon = "Interface\\Icons\\INV_Potion_62",
                condition = playerLevel >= 45
            },
            {
                text = "Not carrying Mana Potions for your level",
                itemId = bestManaId,
                icon = bestManaIcon,
                condition = powerType == 0 and bestManaId ~= nil
            },
            {
                text = "Not carrying Rune of Portals",
                itemId = 17032,
                icon = "Interface\\Icons\\INV_Misc_Rune_06",
                condition = classId == "MAGE" and playerLevel >= 40
            },
            {
                text = "Not carrying Rune of Teleportation",
                itemId = 17031,
                icon = "Interface\\Icons\\INV_Misc_Rune_07",
                condition = classId == "MAGE" and playerLevel >= 20
            },
            {
                text = "Not carrying Sacred Candles",
                itemId = 17029,
                icon = "Interface\\Icons\\INV_Misc_Candle_02",
                condition = classId == "PRIEST" and playerLevel >= 56
            },
            {
                text = "Not carrying Soul Shards",
                itemId = 6265,
                icon = "Interface\\Icons\\INV_Misc_Gem_Amethyst_02",
                condition = classId == "WARLOCK" and playerLevel >= 10
            },
            {
                text = "Not carrying Swiftness Potions",
                itemId = 2459,
                icon = "Interface\\Icons\\INV_Potion_95",
                condition = playerLevel >= 5
            },
            {
                text = "Not carrying Symbol of Kings",
                itemId = 21177,
                icon = "Interface\\Icons\\INV_Jewelry_TrinketPVP_01",
                condition = classId == "PALADIN" and playerLevel >= 52
            },
        }
        
        -- Collect applicable warnings
        local activeWarnings = {}
        for _, check in ipairs(warningChecks) do
            if check.condition and check.itemId then
                local count = GetItemCount(check.itemId)
                local minCount = check.minCount or 1
                if count < minCount then
                    table.insert(activeWarnings, check)
                end
            end
        end
        
        -- Sort alphabetically by text (case-insensitive)
        table.sort(activeWarnings, function(a, b)
            return a.text:lower() < b.text:lower()
        end)
        
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
                        row.icon:SetTexture(warning.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
                        row.icon:SetDesaturated(false)
                        row.icon:SetAlpha(1)
                    end
                    
                    row.name:SetText(warning.text)
                    row.name:SetTextColor(1, 0.8, 0.2, 1)
                    row.level:SetText("")
                    row.cost:SetText("")
                    
                    local itemId = warning.itemId
                    row:SetScript("OnEnter", function(self)
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                        GameTooltip:SetItemByID(itemId)
                        GameTooltip:Show()
                    end)
                    
                    yOffset = yOffset - 34
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
                
                local sub = GetFrame("subheader")
                sub:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                sub:SetText("Available Now")
                sub:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                
                local costText = GetFrame("text")
                costText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 120, yOffset)
                costText:SetText("Total: " .. FormatMoneyColored(availableCost))
                costText:SetTextColor(1, 1, 1, 1)
                yOffset = yOffset - 20
                
                for _, ability in ipairs(available) do
                    local row = GetFrame("row")
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                    row:SetPoint("RIGHT", scrollChild, "RIGHT", -12, yOffset)
                    
                    row.icon:SetTexture("Interface\\Icons\\" .. (ability.icon or "INV_Misc_QuestionMark"))
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
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                            GameTooltip:SetSpellByID(ability.spellId)
                            GameTooltip:Show()
                        end
                    end)
                    
                    yOffset = yOffset - 24
                end
                yOffset = yOffset - 10
            end
            
            if #nextAvailable > 0 then
                local nextCost = 0
                for _, ability in ipairs(nextAvailable) do
                    nextCost = nextCost + (ability.base_cost or 0)
                end
                
                local sub = GetFrame("subheader")
                sub:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                sub:SetText("Next Available")
                sub:SetTextColor(0.5, 0.7, 0.9, 1)
                
                local costText = GetFrame("text")
                costText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 120, yOffset)
                costText:SetText("Total: " .. FormatMoneyColored(nextCost))
                costText:SetTextColor(1, 1, 1, 1)
                yOffset = yOffset - 20
                
                for _, ability in ipairs(nextAvailable) do
                    local row = GetFrame("row")
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                    row:SetPoint("RIGHT", scrollChild, "RIGHT", -12, yOffset)
                    
                    row.icon:SetTexture("Interface\\Icons\\" .. (ability.icon or "INV_Misc_QuestionMark"))
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
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                            GameTooltip:SetSpellByID(ability.spellId)
                            GameTooltip:Show()
                        end
                    end)
                    
                    yOffset = yOffset - 24
                end
            end
        end
        
        scrollChild:SetHeight(math.abs(yOffset) + 20)
    end
    
    -- Refresh when shown
    container:SetScript("OnShow", Refresh)
    
    -- Initial render
    Refresh()
    
    return { title = title, subtitle = subtitle, scrollFrame = scrollFrame }
end)
