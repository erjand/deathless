local Deathless = Deathless

Deathless.UI.MiniSummary = Deathless.UI.MiniSummary or {}
local Icons = Deathless.Utils.Icons

local AbilityUtils = Deathless.Utils.Abilities
local FormatMoneyColored = AbilityUtils.FormatMoneyColored
local IsSpellKnown = AbilityUtils.IsSpellKnown

local MINI_DEFAULT_WIDTH = 300
local MINI_DEFAULT_HEIGHT = 200
local MINI_MIN_WIDTH = 300
local MINI_MAX_WIDTH = 300
local MINI_MIN_HEIGHT = 120
local MINI_MAX_HEIGHT = 500

function Deathless.UI.MiniSummary:Create()
    if self.frame then
        return self.frame
    end
    
    local Colors = Deathless.UI.Colors
    local CreatePixelBorder = Deathless.UI.CreatePixelBorder
    local PinUtils = Deathless.Utils.UI
    
    -- Create main frame
    local frame = CreateFrame("Frame", "DeathlessMiniSummary", UIParent, "BackdropTemplate")
    
    -- Restore saved layout (always use TOPLEFT->BOTTOMLEFT for absolute positioning)
    local layout = Deathless.config.layout and Deathless.config.layout.mini or {}
    frame:SetSize(MINI_DEFAULT_WIDTH, layout.height or MINI_DEFAULT_HEIGHT)
    if layout.x and layout.y then
        frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", layout.x, layout.y)
    else
        frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 32, 300)
    end
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetResizable(true)
    frame:SetResizeBounds(MINI_MIN_WIDTH, MINI_MIN_HEIGHT, MINI_MAX_WIDTH, MINI_MAX_HEIGHT)
    frame:RegisterForDrag("LeftButton")
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
    local Fonts = Deathless.UI.Fonts
    local title = titleBar:CreateFontString(nil, "OVERLAY")
    title:SetFont(Fonts.family, Fonts.body, "")
    title:SetPoint("LEFT", titleBar, "LEFT", 6, 0)
    title:SetText("DEATHLESS")
    title:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    -- Pin button (using shared utility)
    local pinBtn = PinUtils.CreatePinButton(frame, titleBar, "miniPinned", { Colors = Colors })
    
    -- Close button
    local CreateCloseButton = Deathless.UI.CreateCloseButton
    local closeBtn = CreateCloseButton(titleBar, {
        onClick = function() Deathless.UI.MiniSummary:Hide() end
    })
    
    -- Resize grip (using shared component)
    local resizeGrip, gripTexture = PinUtils.CreateResizeGrip(frame, Colors, {
        point = "BOTTOM",
        relativePoint = "BOTTOM",
        offsetX = 0,
        offsetY = 2,
        style = "bottom",
    })
    
    -- Setup pinnable resize behavior (with layout saving)
    PinUtils.SetupPinnableResize(frame, resizeGrip, gripTexture, Colors, "mini", "BOTTOM")
    
    -- Setup pinnable drag behavior (with layout saving)
    PinUtils.SetupPinnableDrag(frame, "mini")
    
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
    
    -- Setup grip alpha updater using shared utility
    local UpdateGripAlpha, getGripTargetAlpha = PinUtils.CreateGripAlphaUpdater(
        frame, resizeGrip,
        function() return isHovered end,
        frame.isGripHovered
    )
    
    frame:SetScript("OnUpdate", function(self, elapsed)
        -- Custom drag handling (instant, no dead zone)
        if self.UpdateDrag then self:UpdateDrag() end
        
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
        local gripTargetAlpha = getGripTargetAlpha()
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
    local Fonts = Deathless.UI.Fonts
    
    -- Section collapse state
    local sectionState = { warnings = true, xp = true, available = true, nextAvailable = true }
    
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
        
        -- Check if class is enabled in options
        local classEnabled = Deathless.config.includedClasses and Deathless.config.includedClasses[className]
        local rawAbilities = classEnabled and Deathless.Data.Abilities and Deathless.Data.Abilities[className] or {}
        
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
        
        -- Get warnings from shared module
        local activeWarnings = Deathless.Utils.Warnings:GetActive()
        local warningCount = #activeWarnings
        
        -- Check abilities config for section visibility
        local abilitiesConfig = Deathless.config.abilities or {}
        local showAvailable = abilitiesConfig.showAvailable ~= false
        local showNextAvailable = abilitiesConfig.showNextAvailable ~= false
        
        local yOffset = -4
        
        -- Collapsible warnings section (only if there are warnings)
        if warningCount > 0 then
            local warningsHeader = CreateFrame("Button", nil, scrollChild)
            warningsHeader:SetHeight(18)
            warningsHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            warningsHeader:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
            
            local isExpanded = sectionState.warnings
            
            local icon = warningsHeader:CreateFontString(nil, "OVERLAY")
            icon:SetFont(Fonts.icons, Fonts.small, "")
            icon:SetPoint("LEFT", warningsHeader, "LEFT", 4, 0)
            icon:SetText(isExpanded and "▼" or "►")
            icon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local label = warningsHeader:CreateFontString(nil, "OVERLAY")
            label:SetFont(Fonts.family, Fonts.body, "")
            label:SetPoint("LEFT", icon, "RIGHT", 4, 0)
            label:SetText("Warnings (" .. warningCount .. ")")
            label:SetTextColor(Colors.yellow[1], Colors.yellow[2], Colors.yellow[3], 1)
            
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
                for _, warning in ipairs(activeWarnings) do
                    local row = CreateFrame("Frame", nil, scrollChild)
                    row:SetSize(scrollChild:GetWidth() - 16, 18)
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
                    
                    local rowIcon = row:CreateTexture(nil, "ARTWORK")
                    rowIcon:SetSize(14, 14)
                    rowIcon:SetPoint("LEFT", row, "LEFT", 0, 0)
                    rowIcon:SetTexture(warning.icon or Icons.DEFAULT)
                    rowIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    
                    local rowText = row:CreateFontString(nil, "OVERLAY")
                    rowText:SetFont(Fonts.family, Fonts.small, "")
                    rowText:SetPoint("LEFT", rowIcon, "RIGHT", 4, 0)
                    rowText:SetPoint("RIGHT", row, "RIGHT", 0, 0)
                    rowText:SetText(warning.text)
                    rowText:SetTextColor(1, 0.8, 0.2, 1)
                    rowText:SetJustifyH("LEFT")
                    
                    row:EnableMouse(true)
                    local itemId = warning.itemId
                    if itemId then
                        row:SetScript("OnEnter", function(self)
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 2, 0)
                            GameTooltip:SetItemByID(itemId)
                            GameTooltip:Show()
                        end)
                        row:SetScript("OnLeave", function() GameTooltip:Hide() end)
                    end
                    
                    yOffset = yOffset - 18
                end
            end
            
            yOffset = yOffset - 4
        end
        
        -- XP Progress Section (compact for mini view)
        local xpData = Deathless.Utils.XP:GetData()
        local showXP = Deathless.config.showXPProgress ~= false
        if showXP and not xpData.isMaxLevel then
            local xpHeader = CreateFrame("Button", nil, scrollChild)
            xpHeader:SetHeight(18)
            xpHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            xpHeader:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
            
            local isExpanded = sectionState.xp
            
            local xpIcon = xpHeader:CreateFontString(nil, "OVERLAY")
            xpIcon:SetFont(Fonts.icons, Fonts.small, "")
            xpIcon:SetPoint("LEFT", xpHeader, "LEFT", 4, 0)
            xpIcon:SetText(isExpanded and "▼" or "►")
            xpIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local xpLabel = xpHeader:CreateFontString(nil, "OVERLAY")
            xpLabel:SetFont(Fonts.family, Fonts.body, "")
            xpLabel:SetPoint("LEFT", xpIcon, "RIGHT", 4, 0)
            xpLabel:SetText("XP Progress")
            xpLabel:SetTextColor(0.4, 0.8, 1.0, 1)
            
            xpHeader:SetScript("OnClick", function()
                sectionState.xp = not sectionState.xp
                Refresh()
            end)
            xpHeader:SetScript("OnEnter", function()
                xpLabel:SetTextColor(0.5, 0.9, 1.0, 1)
            end)
            xpHeader:SetScript("OnLeave", function()
                xpLabel:SetTextColor(0.4, 0.8, 1.0, 1)
            end)
            
            yOffset = yOffset - 18
            
            if isExpanded then
                -- XP Bar (compact)
                local barRow = CreateFrame("Frame", nil, scrollChild)
                barRow:SetSize(scrollChild:GetWidth() - 24, 12)
                barRow:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
                
                local barBg = barRow:CreateTexture(nil, "BACKGROUND")
                barBg:SetAllPoints()
                barBg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
                
                -- Rested XP fill (behind normal bar, extends past current XP)
                if xpData.restedXP > 0 and xpData.maxXP > 0 then
                    local restedEnd = math.min(xpData.currentXP + xpData.restedXP, xpData.maxXP)
                    local restedPct = restedEnd / xpData.maxXP
                    local restedFill = barRow:CreateTexture(nil, "ARTWORK", nil, 0)
                    restedFill:SetPoint("TOPLEFT", barRow, "TOPLEFT", 1, -1)
                    restedFill:SetPoint("BOTTOMLEFT", barRow, "BOTTOMLEFT", 1, 1)
                    restedFill:SetWidth(math.max(1, (barRow:GetWidth() - 2) * restedPct))
                    restedFill:SetColorTexture(0.0, 0.39, 0.88, 0.8)
                end
                
                local barFill = barRow:CreateTexture(nil, "ARTWORK", nil, 1)
                barFill:SetPoint("TOPLEFT", barRow, "TOPLEFT", 1, -1)
                barFill:SetPoint("BOTTOMLEFT", barRow, "BOTTOMLEFT", 1, 1)
                barFill:SetWidth(math.max(1, (barRow:GetWidth() - 2) * (xpData.percent / 100)))
                barFill:SetColorTexture(0.58, 0.0, 0.55, 0.8)
                
                local barText = barRow:CreateFontString(nil, "OVERLAY")
                barText:SetFont(Fonts.family, Fonts.small - 1, "")
                barText:SetPoint("CENTER", barRow, "CENTER", 0, 0)
                barText:SetText(string.format("%s / %s (%.1f%%)", 
                    Deathless.Utils.XP:FormatNumber(xpData.currentXP),
                    Deathless.Utils.XP:FormatNumber(xpData.maxXP),
                    xpData.percent))
                barText:SetTextColor(1, 1, 1, 1)
                
                yOffset = yOffset - 14
                
                -- Stats row
                local statsRow = CreateFrame("Frame", nil, scrollChild)
                statsRow:SetSize(scrollChild:GetWidth() - 24, 16)
                statsRow:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
                
                local sessionText = statsRow:CreateFontString(nil, "OVERLAY")
                sessionText:SetFont(Fonts.family, Fonts.small, "")
                sessionText:SetPoint("LEFT", statsRow, "LEFT", 0, 0)
                sessionText:SetText("+" .. Deathless.Utils.XP:FormatNumber(xpData.xpThisSession) .. " XP")
                sessionText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                
                local ttlText = statsRow:CreateFontString(nil, "OVERLAY")
                ttlText:SetFont(Fonts.family, Fonts.small, "")
                ttlText:SetPoint("RIGHT", statsRow, "RIGHT", -8, 0)
                ttlText:SetText("Next: " .. Deathless.Utils.XP:FormatTime(xpData.timeToLevel))
                ttlText:SetTextColor(0.4, 0.8, 1.0, 1)

                local rateText = statsRow:CreateFontString(nil, "OVERLAY")
                rateText:SetFont(Fonts.family, Fonts.small, "")
                rateText:SetPoint("LEFT", sessionText, "RIGHT", 16, 0)
                rateText:SetText(Deathless.Utils.XP:FormatNumber(xpData.xpPerHour) .. " XP/hr")
                rateText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                
                yOffset = yOffset - 18
            end
            
            yOffset = yOffset - 4
        end
        
        -- Available abilities (collapsible)
        if showAvailable and #available > 0 then
            local totalCost = 0
            for _, ab in ipairs(available) do totalCost = totalCost + (ab.base_cost or 0) end
            
            local availableHeader = CreateFrame("Button", nil, scrollChild)
            availableHeader:SetHeight(18)
            availableHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            availableHeader:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
            
            local isExpanded = sectionState.available
            
            local availIcon = availableHeader:CreateFontString(nil, "OVERLAY")
            availIcon:SetFont(Fonts.icons, Fonts.small, "")
            availIcon:SetPoint("LEFT", availableHeader, "LEFT", 4, 0)
            availIcon:SetText(isExpanded and "▼" or "►")
            availIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local availLabel = availableHeader:CreateFontString(nil, "OVERLAY")
            availLabel:SetFont(Fonts.family, Fonts.body, "")
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
                    row:SetSize(scrollChild:GetWidth() - 24, 18)
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
                    
                    local icon = row:CreateTexture(nil, "ARTWORK")
                    icon:SetSize(14, 14)
                    icon:SetPoint("LEFT", row, "LEFT", 0, 0)
                    icon:SetTexture(Icons:GetIconPath(ability.icon))
                    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    
                    local nameText = ability.name
                    if ability.rank and ability.rank > 1 then
                        nameText = nameText .. " (R" .. ability.rank .. ")"
                    end
                    
                    local name = row:CreateFontString(nil, "OVERLAY")
                    name:SetFont(Fonts.family, Fonts.small, "")
                    name:SetPoint("LEFT", icon, "RIGHT", 4, 0)
                    name:SetText(nameText)
                    name:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                    
                    local cost = row:CreateFontString(nil, "OVERLAY")
                    cost:SetFont(Fonts.family, Fonts.small, "")
                    cost:SetPoint("RIGHT", row, "RIGHT", -8, 0)
                    if ability.base_cost == 0 then
                        cost:SetText("Free")
                        cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                    else
                        cost:SetText(FormatMoneyColored(ability.base_cost))
                    end
                    
                    row:EnableMouse(true)
                    row:SetScript("OnEnter", function(self)
                        if ability.spellId then
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 2, 0)
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
        if showNextAvailable and #nextAvailable > 0 then
            local nextCost = 0
            for _, ab in ipairs(nextAvailable) do nextCost = nextCost + (ab.base_cost or 0) end
            
            local nextHeader = CreateFrame("Button", nil, scrollChild)
            nextHeader:SetHeight(18)
            nextHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            nextHeader:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)
            
            local isExpanded = sectionState.nextAvailable
            
            local nextIcon = nextHeader:CreateFontString(nil, "OVERLAY")
            nextIcon:SetFont(Fonts.icons, Fonts.small, "")
            nextIcon:SetPoint("LEFT", nextHeader, "LEFT", 4, 0)
            nextIcon:SetText(isExpanded and "▼" or "►")
            nextIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local nextLabel = nextHeader:CreateFontString(nil, "OVERLAY")
            nextLabel:SetFont(Fonts.family, Fonts.body, "")
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
                    row:SetSize(scrollChild:GetWidth() - 24, 18)
                    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset)
                    
                    local icon = row:CreateTexture(nil, "ARTWORK")
                    icon:SetSize(14, 14)
                    icon:SetPoint("LEFT", row, "LEFT", 0, 0)
                    icon:SetTexture(Icons:GetIconPath(ability.icon))
                    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                    icon:SetDesaturated(true)
                    icon:SetAlpha(0.6)
                    
                    local nameText = ability.name
                    if ability.rank and ability.rank > 1 then
                        nameText = nameText .. " (R" .. ability.rank .. ")"
                    end
                    
                    local name = row:CreateFontString(nil, "OVERLAY")
                    name:SetFont(Fonts.family, Fonts.small, "")
                    name:SetPoint("LEFT", icon, "RIGHT", 4, 0)
                    name:SetText("Lvl " .. ability.level .. " - " .. nameText)
                    name:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                    
                    local cost = row:CreateFontString(nil, "OVERLAY")
                    cost:SetFont(Fonts.family, Fonts.small, "")
                    cost:SetPoint("RIGHT", row, "RIGHT", -8, 0)
                    if ability.base_cost == 0 then
                        cost:SetText("Free")
                        cost:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.6)
                    else
                        cost:SetText(FormatMoneyColored(ability.base_cost))
                    end
                    
                    row:EnableMouse(true)
                    row:SetScript("OnEnter", function(self)
                        if ability.spellId then
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 2, 0)
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
        
        -- No abilities message (only if class is enabled and sections are shown)
        local showingAbilities = showAvailable or showNextAvailable
        if classEnabled and showingAbilities and #available == 0 and #nextAvailable == 0 then
            local msg = scrollChild:CreateFontString(nil, "OVERLAY")
            msg:SetFont(Fonts.family, Fonts.small, "")
            msg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 4, yOffset)
            msg:SetText("All available abilities learned!")
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
    
    -- Register for automatic refresh when warnings/state changes
    Deathless.Utils.Warnings:RegisterRefresh("mini", function()
        if frame:IsVisible() then
            Refresh()
        end
    end)
    
    -- Register for XP changes
    Deathless.Utils.XP:RegisterRefresh("mini", function()
        if frame:IsVisible() then
            Refresh()
        end
    end)
end

function Deathless.UI.MiniSummary:Show()
    if not self.frame then
        self:Create()
    end
    self.frame:Show()
    if self.Refresh then
        self.Refresh()
    end
    -- Save visibility state
    if Deathless.config.layout then
        Deathless.config.layout.mini = Deathless.config.layout.mini or {}
        Deathless.config.layout.mini.shown = true
        Deathless:SaveConfig()
    end
end

function Deathless.UI.MiniSummary:Hide()
    if self.frame then
        self.frame:Hide()
    end
    -- Save visibility state
    if Deathless.config.layout then
        Deathless.config.layout.mini = Deathless.config.layout.mini or {}
        Deathless.config.layout.mini.shown = false
        Deathless:SaveConfig()
    end
end

function Deathless.UI.MiniSummary:Toggle()
    if self.frame and self.frame:IsShown() then
        self:Hide()
    else
        self:Show()
    end
end

-- Restore mini window state on login
local restoreFrame = CreateFrame("Frame")
restoreFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
restoreFrame:SetScript("OnEvent", function(self, event)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    -- Check if mini window should be shown
    local layout = Deathless.config.layout and Deathless.config.layout.mini
    if layout and layout.shown then
        Deathless.UI.MiniSummary:Show()
    end
end)

