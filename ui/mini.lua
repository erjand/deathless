local Deathless = Deathless

Deathless.UI.MiniSummary = Deathless.UI.MiniSummary or {}

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

function Deathless.UI.MiniSummary:Create()
    if self.frame then
        return self.frame
    end
    
    local Colors = Deathless.UI.Colors
    local CreatePixelBorder = Deathless.UI.CreatePixelBorder
    
    -- Create main frame
    local frame = CreateFrame("Frame", "DeathlessMiniSummary", UIParent, "BackdropTemplate")
    frame:SetSize(300, 200)
    frame:SetPoint("RIGHT", UIParent, "RIGHT", -50, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetResizable(true)
    frame:SetResizeBounds(200, 120, 500, 400)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        -- Re-anchor to TOPLEFT after dragging to prevent resize jump
        local left, top = self:GetLeft(), self:GetTop()
        self:ClearAllPoints()
        self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
    end)
    frame:SetFrameStrata("MEDIUM")
    frame:SetClampedToScreen(true)
    
    -- Background
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(Colors.bg[1], Colors.bg[2], Colors.bg[3], 0.92)
    
    -- Border
    frame.border = CreatePixelBorder(frame, 1, Colors.border[1], Colors.border[2], Colors.border[3], Colors.border[4])
    
    -- Title bar
    local titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
    titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1)
    titleBar:SetHeight(20)
    
    titleBar.bg = titleBar:CreateTexture(nil, "BACKGROUND")
    titleBar.bg:SetAllPoints()
    titleBar.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
    
    -- Title bar bottom border
    local titleBorder = titleBar:CreateTexture(nil, "BORDER")
    titleBorder:SetPoint("BOTTOMLEFT", titleBar, "BOTTOMLEFT", 0, 0)
    titleBorder:SetPoint("BOTTOMRIGHT", titleBar, "BOTTOMRIGHT", 0, 0)
    titleBorder:SetHeight(1)
    titleBorder:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], Colors.border[4])
    
    -- Title text
    local title = titleBar:CreateFontString(nil, "OVERLAY")
    title:SetFont("Fonts\\ARIALN.TTF", 11, "")
    title:SetPoint("LEFT", titleBar, "LEFT", 6, 0)
    title:SetText("DEATHLESS")
    title:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, titleBar)
    closeBtn:SetSize(14, 14)
    closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", -3, 0)
    
    closeBtn.bg = closeBtn:CreateTexture(nil, "BACKGROUND")
    closeBtn.bg:SetAllPoints()
    closeBtn.bg:SetColorTexture(0, 0, 0, 0)
    
    closeBtn.text = closeBtn:CreateFontString(nil, "OVERLAY")
    closeBtn.text:SetFont("Fonts\\ARIALN.TTF", 10, "")
    closeBtn.text:SetPoint("CENTER", 0, 0)
    closeBtn.text:SetText("x")
    closeBtn.text:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    
    closeBtn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.18, 0.18, 0.20, 1)
        self.text:SetTextColor(1, 1, 1, 1)
    end)
    closeBtn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(0, 0, 0, 0)
        self.text:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
    end)
    closeBtn:SetScript("OnClick", function()
        Deathless.UI.MiniSummary:Hide()
    end)
    
    -- Resize grip (higher frame level to stay above scroll frame)
    local resizeGrip = CreateFrame("Button", nil, frame)
    resizeGrip:SetSize(12, 12)
    resizeGrip:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1)
    resizeGrip:SetFrameLevel(frame:GetFrameLevel() + 10)
    resizeGrip:EnableMouse(true)
    resizeGrip:SetAlpha(0)
    
    local gripTexture = resizeGrip:CreateTexture(nil, "OVERLAY")
    gripTexture:SetSize(8, 8)
    gripTexture:SetPoint("CENTER", 0, 0)
    gripTexture:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
    
    for i = 1, 2 do
        local line = resizeGrip:CreateTexture(nil, "OVERLAY")
        line:SetColorTexture(Colors.borderLight[1], Colors.borderLight[2], Colors.borderLight[3], 0.6)
        line:SetSize(2, 2)
        line:SetPoint("BOTTOMRIGHT", resizeGrip, "BOTTOMRIGHT", -1 - (i * 3), 1 + (i * 3))
    end
    
    local isGripHovered = false
    resizeGrip:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            local left, top = frame:GetLeft(), frame:GetTop()
            frame:ClearAllPoints()
            frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
            frame:StartSizing("BOTTOMRIGHT")
        end
    end)
    resizeGrip:SetScript("OnMouseUp", function()
        frame:StopMovingOrSizing()
    end)
    resizeGrip:SetScript("OnEnter", function()
        isGripHovered = true
        gripTexture:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.5)
    end)
    resizeGrip:SetScript("OnLeave", function()
        isGripHovered = false
        gripTexture:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
    end)
    
    frame.resizeGrip = resizeGrip
    frame.isGripHovered = function() return isGripHovered end
    
    -- Content scroll frame (no template - we'll make our own indicator)
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame)
    scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -22)
    scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
    
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(scrollChild)
    
    -- Custom scroll indicator (thin bar on right side)
    local scrollIndicator = CreateFrame("Frame", nil, frame)
    scrollIndicator:SetWidth(3)
    scrollIndicator:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -24)
    scrollIndicator:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 14)
    scrollIndicator:SetFrameLevel(frame:GetFrameLevel() + 5)
    scrollIndicator:SetAlpha(0)
    
    local scrollThumb = scrollIndicator:CreateTexture(nil, "OVERLAY")
    scrollThumb:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.7)
    scrollThumb:SetPoint("TOP", scrollIndicator, "TOP", 0, 0)
    scrollThumb:SetWidth(3)
    scrollThumb:SetHeight(20)
    
    -- Scrollbar auto-hide logic
    local isHovered = false
    local isScrollable = false
    local hideTimer = nil
    local targetAlpha = 0
    
    local function UpdateScrollbarAlpha()
        if isScrollable and isHovered then
            targetAlpha = 1
            if hideTimer then hideTimer:Cancel() hideTimer = nil end
        else
            if not hideTimer then
                hideTimer = C_Timer.NewTimer(1.0, function()
                    targetAlpha = 0
                    hideTimer = nil
                end)
            end
        end
    end
    
    local function UpdateScrollThumb()
        local contentHeight = scrollChild:GetHeight()
        local viewHeight = scrollFrame:GetHeight()
        local maxScroll = contentHeight - viewHeight
        
        isScrollable = maxScroll > 1
        
        if isScrollable then
            local trackHeight = scrollIndicator:GetHeight()
            local thumbRatio = viewHeight / contentHeight
            local thumbHeight = math.max(12, trackHeight * thumbRatio)
            scrollThumb:SetHeight(thumbHeight)
            
            local scrollPos = scrollFrame:GetVerticalScroll()
            local thumbOffset = (scrollPos / maxScroll) * (trackHeight - thumbHeight)
            scrollThumb:ClearAllPoints()
            scrollThumb:SetPoint("TOP", scrollIndicator, "TOP", 0, -thumbOffset)
        end
        
        UpdateScrollbarAlpha()
    end
    frame.UpdateScrollbar = UpdateScrollThumb
    
    -- Combined OnUpdate: hover detection + smooth fade + thumb position
    local gripTargetAlpha = 0
    local gripHideTimer = nil
    
    local function UpdateGripAlpha()
        if isHovered or frame.isGripHovered() then
            gripTargetAlpha = 1
            if gripHideTimer then gripHideTimer:Cancel() gripHideTimer = nil end
        else
            if not gripHideTimer then
                gripHideTimer = C_Timer.NewTimer(1.0, function()
                    gripTargetAlpha = 0
                    gripHideTimer = nil
                end)
            end
        end
    end
    
    frame:SetScript("OnUpdate", function(self, elapsed)
        -- Check hover state
        local wasHovered = isHovered
        isHovered = self:IsMouseOver()
        if isHovered ~= wasHovered then
            UpdateScrollbarAlpha()
            UpdateGripAlpha()
        end
        
        -- Smooth fade animation for scroll indicator
        local current = scrollIndicator:GetAlpha()
        if math.abs(current - targetAlpha) > 0.01 then
            local speed = 5 * elapsed
            scrollIndicator:SetAlpha(current + (targetAlpha - current) * math.min(speed, 1))
        elseif current ~= targetAlpha then
            scrollIndicator:SetAlpha(targetAlpha)
        end
        
        -- Smooth fade animation for resize grip
        local gripCurrent = resizeGrip:GetAlpha()
        if math.abs(gripCurrent - gripTargetAlpha) > 0.01 then
            local speed = 5 * elapsed
            resizeGrip:SetAlpha(gripCurrent + (gripTargetAlpha - gripCurrent) * math.min(speed, 1))
        elseif gripCurrent ~= gripTargetAlpha then
            resizeGrip:SetAlpha(gripTargetAlpha)
        end
    end)
    
    -- Mouse wheel
    scrollFrame:EnableMouseWheel(true)
    scrollFrame:SetScript("OnMouseWheel", function(self, delta)
        local maxScroll = scrollChild:GetHeight() - scrollFrame:GetHeight()
        if maxScroll < 0 then maxScroll = 0 end
        local current = self:GetVerticalScroll()
        local newScroll = current - (delta * 20)
        newScroll = math.max(0, math.min(newScroll, maxScroll))
        self:SetVerticalScroll(newScroll)
        
        -- Update thumb position and flash scrollbar
        UpdateScrollThumb()
        if isScrollable then
            targetAlpha = 1
            if hideTimer then hideTimer:Cancel() end
            hideTimer = C_Timer.NewTimer(1.0, function()
                if not isHovered then targetAlpha = 0 end
                hideTimer = nil
            end)
        end
    end)
    
    frame.scrollFrame = scrollFrame
    frame.scrollChild = scrollChild
    frame.titleBar = titleBar
    
    frame:Hide()
    
    self.frame = frame
    self:SetupContent()
    
    return frame
end

function Deathless.UI.MiniSummary:SetupContent()
    local frame = self.frame
    local scrollChild = frame.scrollChild
    local scrollFrame = frame.scrollFrame
    local Colors = Deathless.UI.Colors
    
    -- Section collapse state
    local sectionState = { warnings = true, available = true, nextAvailable = true }
    
    local function Refresh()
        -- Clear existing content
        for _, child in ipairs({scrollChild:GetChildren()}) do
            child:Hide()
            child:SetParent(nil)
        end
        for _, region in ipairs({scrollChild:GetRegions()}) do
            region:Hide()
            region:SetParent(nil)
        end
        
        local _, classId = UnitClass("player")
        local className = classId:sub(1,1):upper() .. classId:sub(2):lower()
        local playerLevel = UnitLevel("player") or 1
        local powerType = UnitPowerType("player")
        
        local rawAbilities = Deathless.Data.Abilities and Deathless.Data.Abilities[className] or {}
        
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
                if ability.source ~= "talent" then
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
        
        table.sort(available, function(a, b)
            if a.level == b.level then return a.name < b.name end
            return a.level < b.level
        end)
        table.sort(nextAvailable, function(a, b)
            if a.level == b.level then return a.name < b.name end
            return a.level < b.level
        end)
        
        -- Build warnings
        local firstAidSkill, engineeringSkill = 0, 0
        for i = 1, GetNumSkillLines() do
            local skillName, _, _, skillRank = GetSkillLineInfo(i)
            if skillName == "First Aid" then firstAidSkill = skillRank or 0
            elseif skillName == "Engineering" then engineeringSkill = skillRank or 0 end
        end
        
        local bandages = {
            { req = 225, id = 14530, icon = "Interface\\Icons\\INV_Misc_Bandage_12" },
            { req = 200, id = 14529, icon = "Interface\\Icons\\INV_Misc_Bandage_11" },
            { req = 175, id = 8545, icon = "Interface\\Icons\\INV_Misc_Bandage_20" },
            { req = 150, id = 8544, icon = "Interface\\Icons\\INV_Misc_Bandage_19" },
            { req = 125, id = 6451, icon = "Interface\\Icons\\INV_Misc_Bandage_02" },
            { req = 100, id = 6450, icon = "Interface\\Icons\\INV_Misc_Bandage_01" },
            { req = 75, id = 3531, icon = "Interface\\Icons\\INV_Misc_Bandage_17" },
            { req = 50, id = 3530, icon = "Interface\\Icons\\INV_Misc_Bandage_14" },
            { req = 20, id = 2581, icon = "Interface\\Icons\\INV_Misc_Bandage_18" },
            { req = 1, id = 1251, icon = "Interface\\Icons\\INV_Misc_Bandage_15" },
        }
        local healthPotions = {
            { req = 45, id = 13446, icon = "Interface\\Icons\\INV_Potion_54" },
            { req = 35, id = 3928, icon = "Interface\\Icons\\INV_Potion_53" },
            { req = 21, id = 1710, icon = "Interface\\Icons\\INV_Potion_52" },
            { req = 12, id = 929, icon = "Interface\\Icons\\INV_Potion_51" },
            { req = 3, id = 858, icon = "Interface\\Icons\\INV_Potion_50" },
            { req = 1, id = 118, icon = "Interface\\Icons\\INV_Potion_49" },
        }
        local manaPotions = {
            { req = 49, id = 13444, icon = "Interface\\Icons\\INV_Potion_76" },
            { req = 41, id = 13443, icon = "Interface\\Icons\\INV_Potion_74" },
            { req = 31, id = 6149, icon = "Interface\\Icons\\INV_Potion_73" },
            { req = 22, id = 3827, icon = "Interface\\Icons\\INV_Potion_72" },
            { req = 14, id = 3385, icon = "Interface\\Icons\\INV_Potion_71" },
            { req = 1, id = 2455, icon = "Interface\\Icons\\INV_Potion_70" },
        }
        
        local function GetBestTiered(tiers, value)
            for _, tier in ipairs(tiers) do
                if value >= tier.req then return tier.id, tier.icon end
            end
        end
        
        local bestBandageId, bestBandageIcon = GetBestTiered(bandages, firstAidSkill)
        local bestHealthId, bestHealthIcon = GetBestTiered(healthPotions, playerLevel)
        local bestManaId, bestManaIcon = GetBestTiered(manaPotions, playerLevel)
        
        local warningChecks = {
            { text = "Not carrying best Bandages", itemId = bestBandageId, icon = bestBandageIcon, condition = firstAidSkill > 0 and bestBandageId },
            { text = "Not carrying Blinding Powder", itemId = 5530, icon = "Interface\\Icons\\INV_Misc_Dust_01", condition = classId == "ROGUE" and playerLevel >= 34 },
            { text = "Not carrying Flash Powder", itemId = 5140, icon = "Interface\\Icons\\INV_Misc_Powder_Black", condition = classId == "ROGUE" and playerLevel >= 22 },
            { text = "Not carrying Flasks of Petrification", itemId = 13506, minCount = 2, icon = "Interface\\Icons\\INV_Potion_26", condition = playerLevel >= 50 },
            { text = "Not carrying Iron Grenades", itemId = 4390, icon = "Interface\\Icons\\INV_Misc_Bomb_08", condition = engineeringSkill >= 175 and engineeringSkill < 260 },
            { text = "Not carrying Thorium Grenades", itemId = 15993, icon = "Interface\\Icons\\INV_Misc_Bomb_08", condition = engineeringSkill >= 260 },
            { text = "Not carrying Target Dummy", itemId = 4366, icon = "Interface\\Icons\\INV_Crate_06", condition = engineeringSkill >= 85 and engineeringSkill < 185 },
            { text = "Not carrying Advanced Target Dummy", itemId = 4392, icon = "Interface\\Icons\\INV_Crate_05", condition = engineeringSkill >= 185 and engineeringSkill < 275 },
            { text = "Not carrying Masterwork Target Dummy", itemId = 16023, icon = "Interface\\Icons\\INV_Crate_02", condition = engineeringSkill >= 275 },
            { text = "Not carrying best Healing Potions", itemId = bestHealthId, icon = bestHealthIcon, condition = bestHealthId ~= nil },
            { text = "Not carrying Hearthstone", itemId = 6948, icon = "Interface\\Icons\\INV_Misc_Rune_01", condition = true },
            { text = "Not carrying Holy Candles", itemId = 17028, icon = "Interface\\Icons\\INV_Misc_Candle_01", condition = classId == "PRIEST" and playerLevel >= 48 and playerLevel < 60 },
            { text = "Not carrying Light Feathers (Levitate)", itemId = 17056, icon = "Interface\\Icons\\INV_Feather_02", condition = classId == "PRIEST" and playerLevel >= 34 },
            { text = "Not carrying Light Feathers (Slow Fall)", itemId = 17056, icon = "Interface\\Icons\\INV_Feather_02", condition = classId == "MAGE" and playerLevel >= 12 },
            { text = "Not carrying LIP", itemId = 3387, icon = "Interface\\Icons\\INV_Potion_62", condition = playerLevel >= 45 },
            { text = "Not carrying best Mana Potions", itemId = bestManaId, icon = bestManaIcon, condition = powerType == 0 and bestManaId ~= nil },
            { text = "Not carrying Rune of Portals", itemId = 17032, icon = "Interface\\Icons\\INV_Misc_Rune_06", condition = classId == "MAGE" and playerLevel >= 40 },
            { text = "Not carrying Rune of Teleportation", itemId = 17031, icon = "Interface\\Icons\\INV_Misc_Rune_07", condition = classId == "MAGE" and playerLevel >= 20 },
            { text = "Not carrying Sacred Candles", itemId = 17029, icon = "Interface\\Icons\\INV_Misc_Candle_02", condition = classId == "PRIEST" and playerLevel >= 56 },
            { text = "Not carrying Soul Shards", itemId = 6265, icon = "Interface\\Icons\\INV_Misc_Gem_Amethyst_02", condition = classId == "WARLOCK" and playerLevel >= 10 },
            { text = "Not carrying Swiftness Potions", itemId = 2459, icon = "Interface\\Icons\\INV_Potion_95", condition = playerLevel >= 5 },
            { text = "Not carrying Symbol of Kings", itemId = 21177, icon = "Interface\\Icons\\INV_Jewelry_TrinketPVP_01", condition = classId == "PALADIN" and playerLevel >= 52 },
        }
        
        local warningCount = 0
        for _, check in ipairs(warningChecks) do
            if check.condition and check.itemId then
                local count = GetItemCount(check.itemId)
                if count < (check.minCount or 1) then
                    warningCount = warningCount + 1
                end
            end
        end
        
        local yOffset = -4
        
        -- Collapsible warnings section (only if there are warnings)
        if warningCount > 0 then
            local warningsHeader = CreateFrame("Button", nil, scrollChild)
            warningsHeader:SetHeight(18)
            warningsHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            warningsHeader:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
            
            local isExpanded = sectionState.warnings
            
            local icon = warningsHeader:CreateFontString(nil, "OVERLAY")
            icon:SetFont("Fonts\\ARIALN.TTF", 10, "")
            icon:SetPoint("LEFT", warningsHeader, "LEFT", 4, 0)
            icon:SetText(isExpanded and "▼" or "►")
            icon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local label = warningsHeader:CreateFontString(nil, "OVERLAY")
            label:SetFont("Fonts\\ARIALN.TTF", 11, "")
            label:SetPoint("LEFT", icon, "RIGHT", 4, 0)
            label:SetText("Warnings (" .. warningCount .. ")")
            label:SetTextColor(1, 0.8, 0.2, 1)
            
            warningsHeader:SetScript("OnClick", function()
                sectionState.warnings = not sectionState.warnings
                Refresh()
            end)
            warningsHeader:SetScript("OnEnter", function()
                label:SetTextColor(1, 0.9, 0.4, 1)
            end)
            warningsHeader:SetScript("OnLeave", function()
                label:SetTextColor(1, 0.8, 0.2, 1)
            end)
            
            yOffset = yOffset - 18
            
            -- Show warning items if expanded
            if isExpanded then
                for _, check in ipairs(warningChecks) do
                    if check.condition and check.itemId then
                        local count = GetItemCount(check.itemId)
                        if count < (check.minCount or 1) then
                            local row = CreateFrame("Frame", nil, scrollChild)
                            row:SetSize(scrollChild:GetWidth() - 16, 18)
                            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
                            
                            local rowIcon = row:CreateTexture(nil, "ARTWORK")
                            rowIcon:SetSize(14, 14)
                            rowIcon:SetPoint("LEFT", row, "LEFT", 0, 0)
                            rowIcon:SetTexture(check.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
                            rowIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                            
                            local rowText = row:CreateFontString(nil, "OVERLAY")
                            rowText:SetFont("Fonts\\ARIALN.TTF", 10, "")
                            rowText:SetPoint("LEFT", rowIcon, "RIGHT", 4, 0)
                            rowText:SetPoint("RIGHT", row, "RIGHT", 0, 0)
                            rowText:SetText(check.text)
                            rowText:SetTextColor(1, 0.8, 0.2, 1)
                            rowText:SetJustifyH("LEFT")
                            
                            row:EnableMouse(true)
                            local itemId = check.itemId
                            row:SetScript("OnEnter", function(self)
                                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                                GameTooltip:SetItemByID(itemId)
                                GameTooltip:Show()
                            end)
                            row:SetScript("OnLeave", function() GameTooltip:Hide() end)
                            
                            yOffset = yOffset - 18
                        end
                    end
                end
            end
            
            yOffset = yOffset - 4
        end
        
        -- Available abilities (collapsible)
        if #available > 0 then
            local totalCost = 0
            for _, ab in ipairs(available) do totalCost = totalCost + (ab.base_cost or 0) end
            
            local availableHeader = CreateFrame("Button", nil, scrollChild)
            availableHeader:SetHeight(18)
            availableHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            availableHeader:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
            
            local isExpanded = sectionState.available
            
            local availIcon = availableHeader:CreateFontString(nil, "OVERLAY")
            availIcon:SetFont("Fonts\\ARIALN.TTF", 10, "")
            availIcon:SetPoint("LEFT", availableHeader, "LEFT", 4, 0)
            availIcon:SetText(isExpanded and "▼" or "►")
            availIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local availLabel = availableHeader:CreateFontString(nil, "OVERLAY")
            availLabel:SetFont("Fonts\\ARIALN.TTF", 11, "")
            availLabel:SetPoint("LEFT", availIcon, "RIGHT", 4, 0)
            availLabel:SetText("Available (" .. #available .. ") - " .. FormatMoneyColored(totalCost))
            availLabel:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
            
            availableHeader:SetScript("OnClick", function()
                sectionState.available = not sectionState.available
                Refresh()
            end)
            availableHeader:SetScript("OnEnter", function()
                availLabel:SetTextColor(Colors.accent[1] + 0.2, Colors.accent[2] + 0.1, Colors.accent[3] + 0.2, 1)
            end)
            availableHeader:SetScript("OnLeave", function()
                availLabel:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
            end)
            
            yOffset = yOffset - 18
            
            if isExpanded then
                for _, ability in ipairs(available) do
                    local row = CreateFrame("Frame", nil, scrollChild)
                    row:SetSize(scrollChild:GetWidth() - 16, 18)
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
                    
                    local icon = row:CreateTexture(nil, "ARTWORK")
                    icon:SetSize(14, 14)
                    icon:SetPoint("LEFT", row, "LEFT", 0, 0)
                    icon:SetTexture("Interface\\Icons\\" .. (ability.icon or "INV_Misc_QuestionMark"))
                    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    
                    local nameText = ability.name
                    if ability.rank and ability.rank > 1 then
                        nameText = nameText .. " (R" .. ability.rank .. ")"
                    end
                    
                    local name = row:CreateFontString(nil, "OVERLAY")
                    name:SetFont("Fonts\\ARIALN.TTF", 10, "")
                    name:SetPoint("LEFT", icon, "RIGHT", 4, 0)
                    name:SetText(nameText)
                    name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                    
                    local cost = row:CreateFontString(nil, "OVERLAY")
                    cost:SetFont("Fonts\\ARIALN.TTF", 9, "")
                    cost:SetPoint("RIGHT", row, "RIGHT", -5, 0)
                    if ability.base_cost == 0 then
                        cost:SetText("Free")
                        cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                    else
                        cost:SetText(FormatMoneyColored(ability.base_cost))
                    end
                    
                    row:EnableMouse(true)
                    row:SetScript("OnEnter", function(self)
                        if ability.spellId then
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                            GameTooltip:SetSpellByID(ability.spellId)
                            GameTooltip:Show()
                        end
                    end)
                    row:SetScript("OnLeave", function() GameTooltip:Hide() end)
                    
                    yOffset = yOffset - 18
                end
            end
            yOffset = yOffset - 4
        end
        
        -- Next available abilities (collapsible)
        if #nextAvailable > 0 then
            local nextCost = 0
            for _, ab in ipairs(nextAvailable) do nextCost = nextCost + (ab.base_cost or 0) end
            
            local nextHeader = CreateFrame("Button", nil, scrollChild)
            nextHeader:SetHeight(18)
            nextHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            nextHeader:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
            
            local isExpanded = sectionState.nextAvailable
            
            local nextIcon = nextHeader:CreateFontString(nil, "OVERLAY")
            nextIcon:SetFont("Fonts\\ARIALN.TTF", 10, "")
            nextIcon:SetPoint("LEFT", nextHeader, "LEFT", 4, 0)
            nextIcon:SetText(isExpanded and "▼" or "►")
            nextIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local nextLabel = nextHeader:CreateFontString(nil, "OVERLAY")
            nextLabel:SetFont("Fonts\\ARIALN.TTF", 11, "")
            nextLabel:SetPoint("LEFT", nextIcon, "RIGHT", 4, 0)
            nextLabel:SetText("Next Available (" .. #nextAvailable .. ") - " .. FormatMoneyColored(nextCost))
            nextLabel:SetTextColor(0.5, 0.7, 0.9, 1)
            
            nextHeader:SetScript("OnClick", function()
                sectionState.nextAvailable = not sectionState.nextAvailable
                Refresh()
            end)
            nextHeader:SetScript("OnEnter", function()
                nextLabel:SetTextColor(0.6, 0.8, 1.0, 1)
            end)
            nextHeader:SetScript("OnLeave", function()
                nextLabel:SetTextColor(0.5, 0.7, 0.9, 1)
            end)
            
            yOffset = yOffset - 18
            
            if isExpanded then
                for _, ability in ipairs(nextAvailable) do
                    local row = CreateFrame("Frame", nil, scrollChild)
                    row:SetSize(scrollChild:GetWidth() - 16, 18)
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
                    
                    local icon = row:CreateTexture(nil, "ARTWORK")
                    icon:SetSize(14, 14)
                    icon:SetPoint("LEFT", row, "LEFT", 0, 0)
                    icon:SetTexture("Interface\\Icons\\" .. (ability.icon or "INV_Misc_QuestionMark"))
                    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    icon:SetDesaturated(true)
                    icon:SetAlpha(0.6)
                    
                    local nameText = ability.name
                    if ability.rank and ability.rank > 1 then
                        nameText = nameText .. " (R" .. ability.rank .. ")"
                    end
                    
                    local name = row:CreateFontString(nil, "OVERLAY")
                    name:SetFont("Fonts\\ARIALN.TTF", 10, "")
                    name:SetPoint("LEFT", icon, "RIGHT", 4, 0)
                    name:SetText("Lvl " .. ability.level .. " - " .. nameText)
                    name:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                    
                    local cost = row:CreateFontString(nil, "OVERLAY")
                    cost:SetFont("Fonts\\ARIALN.TTF", 9, "")
                    cost:SetPoint("RIGHT", row, "RIGHT", -5, 0)
                    if ability.base_cost == 0 then
                        cost:SetText("Free")
                        cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.6)
                    else
                        cost:SetText(FormatMoneyColored(ability.base_cost))
                    end
                    
                    row:EnableMouse(true)
                    row:SetScript("OnEnter", function(self)
                        if ability.spellId then
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                            GameTooltip:SetSpellByID(ability.spellId)
                            GameTooltip:Show()
                        end
                    end)
                    row:SetScript("OnLeave", function() GameTooltip:Hide() end)
                    
                    yOffset = yOffset - 18
                end
            end
            yOffset = yOffset - 4
        end
        
        -- No abilities message
        if #available == 0 and #nextAvailable == 0 then
            local msg = scrollChild:CreateFontString(nil, "OVERLAY")
            msg:SetFont("Fonts\\ARIALN.TTF", 10, "")
            msg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 4, yOffset)
            msg:SetText("All abilities learned!")
            msg:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            yOffset = yOffset - 16
        end
        
        scrollChild:SetHeight(math.abs(yOffset) + 8)
        
        -- Update scrollbar visibility after content changes
        C_Timer.After(0, function()
            if frame.UpdateScrollbar then
                frame.UpdateScrollbar()
            end
        end)
    end
    
    self.Refresh = Refresh
    
    frame:SetScript("OnShow", Refresh)
end

function Deathless.UI.MiniSummary:Show()
    if not self.frame then
        self:Create()
    end
    self.frame:Show()
    if self.Refresh then
        self.Refresh()
    end
end

function Deathless.UI.MiniSummary:Hide()
    if self.frame then
        self.frame:Hide()
    end
end

function Deathless.UI.MiniSummary:Toggle()
    if self.frame and self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

