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
    
    local title, subtitle = Utils:CreateHeader(container, "Summary", "Your adventure at a glance")
    
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
    local frames = {}
    local frameIndex = 0
    
    local function GetFrame(frameType)
        frameIndex = frameIndex + 1
        local frame = frames[frameIndex]
        
        if not frame then
            if frameType == "header" then
                frame = scrollChild:CreateFontString(nil, "OVERLAY")
                frame:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
                frame.line = scrollChild:CreateTexture(nil, "ARTWORK")
                frame.line:SetHeight(1)
                frame.line:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -4)
                frame.line:SetPoint("RIGHT", scrollChild, "RIGHT", -12, 0)
                frame.line:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.3)
                frame.type = "header"
            elseif frameType == "subheader" then
                frame = scrollChild:CreateFontString(nil, "OVERLAY")
                frame:SetFont("Fonts\\ARIALN.TTF", 12, "BOLD")
                frame.type = "subheader"
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
                
                frame.type = "row"
                frame:EnableMouse(true)
                frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
            elseif frameType == "text" then
                frame = scrollChild:CreateFontString(nil, "OVERLAY")
                frame:SetFont("Fonts\\ARIALN.TTF", 12, "")
                frame:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                frame.type = "text"
            end
            frames[frameIndex] = frame
        end
        
        -- Reset common properties
        frame:ClearAllPoints()
        frame:Show()
        if frame.type == "header" then frame.line:Show() end
        
        return frame
    end
    
    local function ClearFrames()
        for i = 1, #frames do
            frames[i]:Hide()
            frames[i]:ClearAllPoints()
            if frames[i].type == "header" then frames[i].line:Hide() end
        end
        frameIndex = 0
    end
    
    local function Refresh()
        ClearFrames()
        
        local _, classId = UnitClass("player")
        local className = classId:sub(1,1):upper() .. classId:sub(2):lower()
        local playerLevel = UnitLevel("player") or 1
        
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
            local sub = GetFrame("subheader")
            sub:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
            sub:SetText("Available Now")
            sub:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
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
            local sub = GetFrame("subheader")
            sub:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
            sub:SetText("Next Available")
            sub:SetTextColor(0.5, 0.7, 0.9, 1)
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
