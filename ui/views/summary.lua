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
    
    -- Element pooling
    local pools = {
        header = {},
        subheader = {},
        row = {},
        text = {}
    }
    local poolIndexes = {
        header = 0,
        subheader = 0,
        row = 0,
        text = 0
    }
    
    local function GetFrame(frameType)
        poolIndexes[frameType] = (poolIndexes[frameType] or 0) + 1
        local index = poolIndexes[frameType]
        local pool = pools[frameType]
        local frame = pool[index]
        
        if not frame then
            if frameType == "header" then
                frame = scrollChild:CreateFontString(nil, "OVERLAY")
                frame:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
                frame.line = scrollChild:CreateTexture(nil, "ARTWORK")
                frame.line:SetHeight(1)
                frame.line:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -4)
                frame.line:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
                frame.line:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.3)
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
        if frameType == "header" then frame.line:Show() end
        
        return frame
    end
    
    local function ClearFrames()
        for type, pool in pairs(pools) do
            for _, frame in ipairs(pool) do
                frame:Hide()
                if type == "header" and frame.line then
                    frame.line:Hide()
                end
                frame:ClearAllPoints()
            end
            poolIndexes[type] = 0
        end
    end
    
    local function Refresh()
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
        local hasWarnings = false
        local function AddWarning(text, itemId, checkCount, forcedIcon)
            local count = GetItemCount(itemId)
            if count < (checkCount or 1) then
                -- Only create header for first warning
                if not hasWarnings then
                    local header = GetFrame("header")
                    header:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                    header:SetText("Warnings")
                    header:SetTextColor(1, 0.8, 0.2, 1) -- Yellow
                    yOffset = yOffset - 24
                    hasWarnings = true
                end
                
                local row = GetFrame("row")
                row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
                row:SetPoint("RIGHT", scrollChild, "RIGHT", -12, yOffset)
                
                -- Item icon
                local _, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemId)
                local texture = forcedIcon or itemIcon or "Interface\\Icons\\INV_Misc_QuestionMark"
                
                if row.icon then
                    row.icon:SetTexture(texture)
                    row.icon:SetDesaturated(false)
                    row.icon:SetAlpha(1)
                end
                
                row.name:SetText(text)
                row.name:SetTextColor(1, 0.8, 0.2, 1)
                
                row.level:SetText("")
                row.cost:SetText("")
                
                -- Tooltip
                row:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetItemByID(itemId)
                    GameTooltip:Show()
                end)
                
                yOffset = yOffset - 34
                return true
            end
            return false
        end
        
        -- Check 1: Bandages (Appropriate for First Aid skill level)
        -- Get First Aid skill level
        local firstAidSkill = 0
        for i = 1, GetNumSkillLines() do
            local skillName, _, _, skillRank = GetSkillLineInfo(i)
            if skillName == "First Aid" then
                firstAidSkill = skillRank or 0
                break
            end
        end
        
        -- Only check bandages if player has First Aid
        if firstAidSkill > 0 then
            local bandages = {
                { skill = 225, id = 14530, icon = "Interface\\Icons\\INV_Misc_Bandage_12" }, -- Heavy Runecloth Bandage
                { skill = 200, id = 14529, icon = "Interface\\Icons\\INV_Misc_Bandage_11" }, -- Runecloth Bandage
                { skill = 175, id = 8545,  icon = "Interface\\Icons\\INV_Misc_Bandage_20" }, -- Heavy Mageweave Bandage
                { skill = 150, id = 8544,  icon = "Interface\\Icons\\INV_Misc_Bandage_19" }, -- Mageweave Bandage
                { skill = 125, id = 6451,  icon = "Interface\\Icons\\INV_Misc_Bandage_02" }, -- Heavy Silk Bandage
                { skill = 100, id = 6450,  icon = "Interface\\Icons\\INV_Misc_Bandage_01" }, -- Silk Bandage
                { skill = 75,  id = 3531,  icon = "Interface\\Icons\\INV_Misc_Bandage_17" }, -- Heavy Wool Bandage
                { skill = 50,  id = 3530,  icon = "Interface\\Icons\\INV_Misc_Bandage_14" }, -- Wool Bandage
                { skill = 20,  id = 2581,  icon = "Interface\\Icons\\INV_Misc_Bandage_18" }, -- Heavy Linen Bandage
                { skill = 1,   id = 1251,  icon = "Interface\\Icons\\INV_Misc_Bandage_15" }, -- Linen Bandage
            }
            
            local bestBandageId = nil
            local bestBandageIcon = nil
            for _, bandage in ipairs(bandages) do
                if firstAidSkill >= bandage.skill then
                    bestBandageId = bandage.id
                    bestBandageIcon = bandage.icon
                    break
                end
            end
            
            if bestBandageId then
                AddWarning("Not carrying best Bandages for your First Aid skill level", bestBandageId, 1, bestBandageIcon)
            end
        end
        
        -- Check 2: Blinding Powder (Rogue 34+)
        if classId == "ROGUE" and playerLevel >= 34 then
            AddWarning("Not carrying any Blinding Powder for Blind", 5530, 1, "Interface\\Icons\\INV_Misc_Dust_01")
        end
        
        -- Check 3: Flask of Petrification
        if playerLevel >= 50 then
            AddWarning("Not carrying 2 or more Flasks of Petrification", 13506, 2, "Interface\\Icons\\INV_Potion_26")
        end
        
        -- Check 4: Flash Powder (Rogue 22+)
        if classId == "ROGUE" and playerLevel >= 22 then
            AddWarning("Not carrying any Flash Powder for Vanish", 5140, 1, "Interface\\Icons\\INV_Misc_Powder_Black")
        end
        
        -- Check 5: Health Potion (Appropriate for level)
        -- Data from: https://www.wowhead.com/classic/items/consumables/potions/name:healing
        local healthPotions = {
            { level = 45, id = 13446, icon = "Interface\\Icons\\INV_Potion_54" }, -- Major Healing Potion
            { level = 35, id = 3928,  icon = "Interface\\Icons\\INV_Potion_53" }, -- Superior Healing Potion
            { level = 21, id = 1710,  icon = "Interface\\Icons\\INV_Potion_52" }, -- Greater Healing Potion
            { level = 12, id = 929,   icon = "Interface\\Icons\\INV_Potion_51" }, -- Healing Potion
            { level = 3, id = 858,    icon = "Interface\\Icons\\INV_Potion_50" }, -- Lesser Healing Potion
            { level = 1,  id = 118,   icon = "Interface\\Icons\\INV_Potion_49" }, -- Minor Healing Potion
        }
        
        local bestPotionId = nil
        local bestPotionIcon = nil
        for _, pot in ipairs(healthPotions) do
            if playerLevel >= pot.level then
                bestPotionId = pot.id
                bestPotionIcon = pot.icon
                break
            end
        end
        
        if bestPotionId then
            AddWarning("Not carrying best Healing Potions for your level", bestPotionId, 1, bestPotionIcon)
        end
        
        -- Check 6: Hearthstone
        AddWarning("Not carrying a Hearthstone", 6948, 1, "Interface\\Icons\\INV_Misc_Rune_01")
        
        -- Check 7: Holy Candle (Priest 48-59)
        if classId == "PRIEST" and playerLevel >= 48 and playerLevel < 60 then
            AddWarning("Not carrying any Holy Candles", 17028, 1, "Interface\\Icons\\INV_Misc_Candle_01")
        end
        
        -- Check 8: Light Feather (Mage 12+ for Slow Fall)
        if classId == "MAGE" and playerLevel >= 12 then
            AddWarning("Not carrying Light Feathers for Slow Fall", 17056, 1, "Interface\\Icons\\INV_Feather_02")
        end
        
        -- Check 9: Light Feather (Priest 34+ for Levitate)
        if classId == "PRIEST" and playerLevel >= 34 then
            AddWarning("Not carrying Light Feathers for Levitate", 17056, 1, "Interface\\Icons\\INV_Feather_02")
        end
        
        -- Check 10: Limited Invulnerability Potion
        if playerLevel >= 45 then
            AddWarning("Not carrying any Limited Invulnerability Potions", 3387, 1, "Interface\\Icons\\INV_Potion_62")
        end
        
        -- Check 11: Mana Potion (Appropriate for level, if mana user)
        -- Power type 0 is Mana
        if powerType == 0 then
            local manaPotions = {
                { level = 49, id = 13444, icon = "Interface\\Icons\\INV_Potion_76" }, -- Major Mana Potion
                { level = 41, id = 13443, icon = "Interface\\Icons\\INV_Potion_74" }, -- Superior Mana Potion
                { level = 31, id = 6149,  icon = "Interface\\Icons\\INV_Potion_73" }, -- Greater Mana Potion
                { level = 22, id = 3827,  icon = "Interface\\Icons\\INV_Potion_72" }, -- Mana Potion
                { level = 14, id = 3385,  icon = "Interface\\Icons\\INV_Potion_71" }, -- Lesser Mana Potion
                { level = 1,  id = 2455,  icon = "Interface\\Icons\\INV_Potion_70" }, -- Minor Mana Potion
            }
            
            local bestManaPotionId = nil
            local bestManaPotionIcon = nil
            for _, pot in ipairs(manaPotions) do
                if playerLevel >= pot.level then
                    bestManaPotionId = pot.id
                    bestManaPotionIcon = pot.icon
                    break
                end
            end
            
            if bestManaPotionId then
                AddWarning("Not carrying best Mana Potions for your level", bestManaPotionId, 1, bestManaPotionIcon)
            end
        end
        
        -- Check 12: Rune of Portals (Mage 40+)
        if classId == "MAGE" and playerLevel >= 40 then
            AddWarning("Not carrying any Rune of Portals", 17032, 1, "Interface\\Icons\\INV_Misc_Rune_06")
        end
        
        -- Check 13: Rune of Teleportation (Mage 20+)
        if classId == "MAGE" and playerLevel >= 20 then
            AddWarning("Not carrying any Rune of Teleportation", 17031, 1, "Interface\\Icons\\INV_Misc_Rune_07")
        end
        
        -- Check 14: Sacred Candle (Priest 56+)
        if classId == "PRIEST" and playerLevel >= 56 then
            AddWarning("Not carrying any Sacred Candles", 17029, 1, "Interface\\Icons\\INV_Misc_Candle_02")
        end
        
        -- Check 15: Soul Shard (Warlock 10+)
        if classId == "WARLOCK" and playerLevel >= 10 then
            AddWarning("Not carrying any Soul Shards", 6265, 1, "Interface\\Icons\\INV_Misc_Gem_Amethyst_02")
        end
        
        -- Check 16: Swiftness Potion
        if playerLevel >= 5 then
            AddWarning("Not carrying Swiftness Potions", 2459, 1, "Interface\\Icons\\INV_Potion_95")
        end
        
        -- Check 17: Symbol of Kings (Paladin 52+)
        if classId == "PALADIN" and playerLevel >= 52 then
            AddWarning("Not carrying any Symbol of Kings", 21177, 1, "Interface\\Icons\\INV_Jewelry_TrinketPVP_01")
        end
        
        if not hasWarnings then
            local header = GetFrame("header")
            header:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
            header:SetText("Warnings")
            header:SetTextColor(0.2, 1, 0.2, 1) -- Green
            yOffset = yOffset - 24
            
            local msg = GetFrame("text")
            msg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
            msg:SetText("No warnings - go adventure!")
            msg:SetTextColor(0.5, 1, 0.5, 1)
            yOffset = yOffset - 30
        end
        
        -- Abilities Section
        local header = GetFrame("header")
        header:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
        header:SetText("Abilities")
        header:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
        yOffset = yOffset - 24
        
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
        
        scrollChild:SetHeight(math.abs(yOffset) + 20)
    end
    
    -- Refresh when shown
    container:SetScript("OnShow", Refresh)
    
    -- Initial render
    Refresh()
    
    return { title = title, subtitle = subtitle, scrollFrame = scrollFrame }
end)
