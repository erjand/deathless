local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local Icons = Deathless.Utils.Icons

-- Store template for reuse
Deathless.UI.Views.TalentsTemplate = {}

--- Create a talents view for a specific class
---@param config table Configuration: { viewName, className, classColor }
function Deathless.UI.Views.TalentsTemplate:Create(config)
    local viewName = config.viewName       -- e.g., "priest_talents"
    local className = config.className     -- e.g., "Priest"
    local classColor = config.classColor   -- e.g., { 1.00, 1.00, 1.00 }
    
    Deathless.UI.Views:Register(viewName, function(container)
        local Colors = Utils:GetColors()
        local Fonts = Deathless.UI.Fonts
        local Layout = Utils.Layout
        
        local title, subtitle = Utils:CreateHeader(container, className .. " Talents", "Recommended builds for Hardcore leveling - adjust as desired.", classColor)
        
        local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, -70, 24)
        
        -- Section collapse state (keyed by build name)
        local sectionState = {}
        -- Row expand state (keyed by build:index)
        local rowExpandState = {}
        
        -- Element pools
        local sectionPool = {}
        local rowPool = {}
        local subRowPool = {}
        local elementPool = {}
        local sectionIndex = 0
        local rowIndex = 0
        local subRowIndex = 0
        local elementIndex = 0
        
        local function ClearElements()
            for _, section in ipairs(sectionPool) do
                section:Hide()
                section:ClearAllPoints()
            end
            for _, row in ipairs(rowPool) do
                row:Hide()
                row:ClearAllPoints()
            end
            for _, row in ipairs(subRowPool) do
                row:Hide()
                row:ClearAllPoints()
            end
            for _, elem in ipairs(elementPool) do
                if elem.Hide then elem:Hide() end
            end
            sectionIndex = 0
            rowIndex = 0
            subRowIndex = 0
            elementIndex = 0
        end
        
        local function GetSection()
            sectionIndex = sectionIndex + 1
            local section = sectionPool[sectionIndex]
            if not section then
                section = CreateFrame("Button", nil, scrollChild)
                section:SetHeight(32)
                
                section.bg = section:CreateTexture(nil, "BACKGROUND")
                section.bg:SetAllPoints()
                
                section.icon = section:CreateFontString(nil, "OVERLAY")
                section.icon:SetFont(Fonts.icons, Fonts.subtitle, "")
                section.icon:SetPoint("LEFT", section, "LEFT", 12, 0)
                
                section.label = section:CreateFontString(nil, "OVERLAY")
                section.label:SetFont(Fonts.family, Fonts.sectionHeader, "")
                section.label:SetPoint("LEFT", section.icon, "RIGHT", 6, 0)
                
                section.points = section:CreateFontString(nil, "OVERLAY")
                section.points:SetFont(Fonts.family, Fonts.body, "")
                section.points:SetPoint("LEFT", section.label, "RIGHT", 10, 0)
                
                section:SetScript("OnEnter", function(self)
                    self.bg:SetColorTexture(Colors.bgLight[1] + 0.05, Colors.bgLight[2] + 0.05, Colors.bgLight[3] + 0.05, 0.8)
                end)
                section:SetScript("OnLeave", function(self)
                    self.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.6)
                end)
                
                sectionPool[sectionIndex] = section
            end
            return section
        end
        
        local function GetRow()
            rowIndex = rowIndex + 1
            local row = rowPool[rowIndex]
            if not row then
                row = CreateFrame("Button", nil, scrollChild)
                row:SetHeight(Layout.rowHeight)
                row:EnableMouse(true)
                
                row.bg = row:CreateTexture(nil, "BACKGROUND")
                row.bg:SetAllPoints()
                
                row.expandIcon = row:CreateFontString(nil, "OVERLAY")
                row.expandIcon:SetFont(Fonts.icons, Fonts.small, "")
                row.expandIcon:SetPoint("LEFT", row, "LEFT", 4, 0)
                row.expandIcon:SetWidth(12)
                
                row.levelText = row:CreateFontString(nil, "OVERLAY")
                row.levelText:SetFont(Fonts.family, Fonts.body, "")
                row.levelText:SetPoint("LEFT", row, "LEFT", 16, 0)
                row.levelText:SetWidth(44)
                row.levelText:SetJustifyH("LEFT")
                
                row.talentIcon = row:CreateTexture(nil, "ARTWORK")
                row.talentIcon:SetSize(Layout.iconSize, Layout.iconSize)
                row.talentIcon:SetPoint("LEFT", row, "LEFT", 64, 0)
                row.talentIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                
                row.talentText = row:CreateFontString(nil, "OVERLAY")
                row.talentText:SetFont(Fonts.family, Fonts.body, "")
                row.talentText:SetPoint("LEFT", row.talentIcon, "RIGHT", 8, 0)
                row.talentText:SetPoint("RIGHT", row, "RIGHT", -12, 0)
                row.talentText:SetJustifyH("LEFT")
                
                rowPool[rowIndex] = row
            end
            return row
        end
        
        local function GetSubRow()
            subRowIndex = subRowIndex + 1
            local row = subRowPool[subRowIndex]
            if not row then
                row = CreateFrame("Frame", nil, scrollChild)
                row:SetHeight(Layout.subRowHeight)
                row:EnableMouse(true)
                
                row.bg = row:CreateTexture(nil, "BACKGROUND")
                row.bg:SetAllPoints()
                
                row.levelText = row:CreateFontString(nil, "OVERLAY")
                row.levelText:SetFont(Fonts.family, Fonts.small, "")
                row.levelText:SetPoint("LEFT", row, "LEFT", 32, 0)
                row.levelText:SetWidth(28)
                row.levelText:SetJustifyH("LEFT")
                
                row.talentIcon = row:CreateTexture(nil, "ARTWORK")
                row.talentIcon:SetSize(Layout.iconSizeSmall, Layout.iconSizeSmall)
                row.talentIcon:SetPoint("LEFT", row, "LEFT", 64, 0)
                row.talentIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
                
                row.rankText = row:CreateFontString(nil, "OVERLAY")
                row.rankText:SetFont(Fonts.family, Fonts.small, "")
                row.rankText:SetPoint("LEFT", row.talentIcon, "RIGHT", 8, 0)
                row.rankText:SetPoint("RIGHT", row, "RIGHT", -12, 0)
                row.rankText:SetJustifyH("LEFT")
                
                subRowPool[subRowIndex] = row
            end
            return row
        end
        
        local function GetElement(createFn)
            elementIndex = elementIndex + 1
            local elem = elementPool[elementIndex]
            if not elem then
                elem = createFn()
                elementPool[elementIndex] = elem
            end
            return elem
        end
        
        --- Get spell icon from spellId
        local function GetSpellIcon(spellId)
            if not spellId then return nil end
            local spellInfo = C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(spellId)
            if spellInfo then
                return spellInfo.iconID
            end
            -- Fallback for Classic
            local _, _, icon = GetSpellInfo(spellId)
            return icon
        end
        
        local PopulateContent
        
        local function CreateBuildSection(build, yOffset)
            local buildKey = build.name
            if sectionState[buildKey] == nil then
                sectionState[buildKey] = true  -- Default expanded
            end
            local isExpanded = sectionState[buildKey]
            
            -- Section header
            local section = GetSection()
            section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
            section:Show()
            
            section.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.6)
            section.icon:SetText(isExpanded and "▼" or "►")
            section.icon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            -- Extract and display points separately, strip from name
            local pointsMatch = build.name:match("%s*%(%d+/%d+/%d+%)%s*$")
            local displayName = build.name
            if pointsMatch then
                displayName = build.name:gsub("%s*%(%d+/%d+/%d+%)%s*$", "")
                section.points:SetText(pointsMatch)
                section.points:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                section.points:Show()
            else
                section.points:Hide()
            end
            section.label:SetText(displayName)
            section.label:SetTextColor(classColor[1], classColor[2], classColor[3], 1)
            
            section.buildKey = buildKey
            section:SetScript("OnClick", function(self)
                sectionState[self.buildKey] = not sectionState[self.buildKey]
                PopulateContent()
            end)
            
            yOffset = yOffset - 32
            
            if not isExpanded then
                return yOffset - 8
            end
            
            -- Description (includes notes if present)
            local descText = build.description or ""
            if build.notes then
                descText = descText .. " " .. build.notes
            end
            if descText ~= "" then
                local desc = GetElement(function()
                    local fs = scrollChild:CreateFontString(nil, "OVERLAY")
                    fs:SetFont(Fonts.family, Fonts.body, "")
                    return fs
                end)
                desc:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset - 4)
                desc:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", -12, yOffset - 4)
                desc:SetJustifyH("LEFT")
                desc:SetText(descText)
                desc:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                desc:Show()
                
                local descHeight = desc:GetStringHeight() or 14
                yOffset = yOffset - descHeight - 12
            end
            
            -- Column headers
            local headerBg = GetElement(function()
                local tex = scrollChild:CreateTexture(nil, "BACKGROUND")
                return tex
            end)
            headerBg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
            headerBg:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
            headerBg:SetHeight(20)
            headerBg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.3)
            headerBg:Show()
            
            local levelHeader = GetElement(function()
                local fs = scrollChild:CreateFontString(nil, "OVERLAY")
                fs:SetFont(Fonts.family, Fonts.small, "")
                return fs
            end)
            levelHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 16, yOffset - 4)
            levelHeader:SetText("LEVEL")
            levelHeader:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            levelHeader:Show()
            
            local talentHeader = GetElement(function()
                local fs = scrollChild:CreateFontString(nil, "OVERLAY")
                fs:SetFont(Fonts.family, Fonts.small, "")
                return fs
            end)
            talentHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 64, yOffset - 4)
            talentHeader:SetText("TALENT")
            talentHeader:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            talentHeader:Show()
            
            yOffset = yOffset - 20
            
            -- Progression rows
            local rowNum = 0
            for entryIndex, entry in ipairs(build.progression) do
                rowNum = rowNum + 1
                local row = GetRow()
                row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
                row:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
                row:Show()
                
                -- Alternating row background (matching abilities template)
                local isEvenRow = rowNum % 2 == 0
                if isEvenRow then
                    row.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.2)
                    row.bg:Show()
                else
                    row.bg:Hide()
                end
                
                -- Handle both old string format and new table format
                local levels, talentName, talentPoints, spellId, ranks
                if type(entry) == "string" then
                    -- Legacy format: "10-14: Wand Specialization 5/5"
                    levels, talentName = entry:match("^([%d%-]+):%s*(.+)$")
                    levels = levels or ""
                    talentName = talentName or entry
                else
                    -- New format: { levels, talent, points, spellId, ranks }
                    levels = entry.levels or ""
                    talentName = entry.talent
                    talentPoints = entry.points
                    spellId = entry.spellId
                    ranks = entry.ranks
                end
                
                -- Check if this row is expandable
                local hasRanks = ranks and #ranks > 1
                local rowKey = buildKey .. ":" .. entryIndex
                local isRowExpanded = rowExpandState[rowKey]
                
                -- Expand icon (triangles for UI consistency)
                if hasRanks then
                    row.expandIcon:SetText(isRowExpanded and "▼" or "►")
                    row.expandIcon:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                    row.expandIcon:Show()
                else
                    row.expandIcon:SetText("")
                    row.expandIcon:Hide()
                end
                
                row.levelText:SetText(levels)
                row.levelText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                
                -- Talent icon
                local icon = GetSpellIcon(spellId)
                if icon then
                    row.talentIcon:SetTexture(icon)
                    row.talentIcon:Show()
                else
                    row.talentIcon:SetTexture(Icons.DEFAULT)
                    row.talentIcon:Show()
                end
                
                -- Talent text with points
                local displayText = talentName
                if talentPoints then
                    displayText = displayText .. " " .. talentPoints
                end
                row.talentText:SetText(displayText)
                row.talentText:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                
                -- Row click handler for expandable rows
                row.rowKey = rowKey
                row.hasRanks = hasRanks
                row.spellId = spellId
                row.isEvenRow = isEvenRow
                
                row:SetScript("OnClick", function(self)
                    if self.hasRanks then
                        rowExpandState[self.rowKey] = not rowExpandState[self.rowKey]
                        PopulateContent()
                    end
                end)
                
                row:SetScript("OnEnter", function(self)
                    self.bg:SetColorTexture(Colors.bgLight[1] + 0.05, Colors.bgLight[2] + 0.05, Colors.bgLight[3] + 0.05, 0.4)
                    self.bg:Show()
                    if self.spellId then
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 8, 0)
                        GameTooltip:SetSpellByID(self.spellId)
                        GameTooltip:Show()
                    end
                end)
                row:SetScript("OnLeave", function(self)
                    if self.isEvenRow then
                        self.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.2)
                    else
                        self.bg:Hide()
                    end
                    GameTooltip:Hide()
                end)
                
                yOffset = yOffset - Layout.rowHeight
                
                -- Sub-rows for expanded talents
                if hasRanks and isRowExpanded then
                    local totalRanks = #ranks
                    for rankIndex, rankData in ipairs(ranks) do
                        local subRow = GetSubRow()
                        subRow:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
                        subRow:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
                        subRow:Show()
                        
                        -- Slightly darker background for sub-rows
                        subRow.bg:SetColorTexture(Colors.bgLight[1] - 0.02, Colors.bgLight[2] - 0.02, Colors.bgLight[3] - 0.02, 0.3)
                        subRow.bg:Show()
                        
                        subRow.levelText:SetText(tostring(rankData.level))
                        subRow.levelText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.8)
                        
                        -- Sub-row icon
                        local subIcon = GetSpellIcon(rankData.spellId)
                        if subIcon then
                            subRow.talentIcon:SetTexture(subIcon)
                        else
                            subRow.talentIcon:SetTexture(icon or Icons.DEFAULT)
                        end
                        subRow.talentIcon:Show()
                        
                        -- Show "Talent Name X/Y" format
                        subRow.rankText:SetText(talentName .. " " .. rankIndex .. "/" .. totalRanks)
                        subRow.rankText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.8)
                        
                        -- Tooltip for sub-row
                        subRow.spellId = rankData.spellId
                        subRow:SetScript("OnEnter", function(self)
                            self.bg:SetColorTexture(Colors.bgLight[1] + 0.03, Colors.bgLight[2] + 0.03, Colors.bgLight[3] + 0.03, 0.4)
                            if self.spellId then
                                GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 8, 0)
                                GameTooltip:SetSpellByID(self.spellId)
                                GameTooltip:Show()
                            end
                        end)
                        subRow:SetScript("OnLeave", function(self)
                            self.bg:SetColorTexture(Colors.bgLight[1] - 0.02, Colors.bgLight[2] - 0.02, Colors.bgLight[3] - 0.02, 0.3)
                            GameTooltip:Hide()
                        end)
                        
                        yOffset = yOffset - Layout.subRowHeight
                    end
                end
            end
            
            return yOffset - 16
        end
        
        PopulateContent = function()
            ClearElements()
            
            local builds = Deathless.Data.Talents and Deathless.Data.Talents[className] or {}
            local yOffset = 0
            
            for _, build in ipairs(builds) do
                yOffset = CreateBuildSection(build, yOffset)
            end
            
            scrollChild:SetHeight(math.abs(yOffset) + 20)
            
            C_Timer.After(0, function()
                if scrollFrame.UpdateScrollbar then
                    scrollFrame.UpdateScrollbar()
                end
            end)
        end
        
        PopulateContent()
        
        return {
            title = title,
            subtitle = subtitle,
            scrollFrame = scrollFrame,
            scrollChild = scrollChild,
            Refresh = PopulateContent
        }
    end)
end
