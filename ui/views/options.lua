local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local Icons = Deathless.Utils.Icons

--- Options view content
Deathless.UI.Views:Register("options", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Options", "Addon settings and preferences")
    
    -- Enhanced scroll frame with auto-hiding scrollbar
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, -60, 24)
    
    -- Layout constants
    local COL_WIDTH = 150
    local ROW_HEIGHT = 24
    local SECTION_HEIGHT = 28
    local SUBSECTION_HEIGHT = 22
    local WARNING_ROWS = 4
    local CLASS_ROWS = 3
    
    -- Section collapse state
    local sectionState = { classes = true, summary = true, warnings = true, abilities = true }
    
    -- Element pools
    local pools = { section = {}, subheader = {}, checkbox = {} }
    local poolIndexes = { section = 0, subheader = 0, checkbox = 0 }
    
    -- Forward declare Refresh
    local Refresh
    
    local function GetPooledElement(poolType, createFn)
        poolIndexes[poolType] = poolIndexes[poolType] + 1
        local index = poolIndexes[poolType]
        local pool = pools[poolType]
        
        if not pool[index] then
            pool[index] = createFn()
        end
        
        local element = pool[index]
        element:ClearAllPoints()
        element:Show()
        return element
    end
    
    local function ClearPools()
        for poolType, pool in pairs(pools) do
            for _, element in ipairs(pool) do
                element:Hide()
                element:ClearAllPoints()
            end
            poolIndexes[poolType] = 0
        end
    end
    
    --- Get a pooled collapsible section header
    local function GetSectionHeader(sectionKey, label, yOffset)
        local section = GetPooledElement("section", function()
            return Utils:CreateCollapsibleSection(scrollChild)
        end)
        
        section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, yOffset)
        section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
        
        Utils:ConfigureSection(section, sectionState[sectionKey], label, Colors.accent)
        
        section.sectionKey = sectionKey
        section:SetScript("OnClick", function(self)
            sectionState[self.sectionKey] = not sectionState[self.sectionKey]
            Refresh()
        end)
        
        return section, yOffset - SECTION_HEIGHT
    end
    
    --- Get a pooled collapsible sub-section header
    local function GetSubSectionHeader(sectionKey, label, anchorFrame, yOffset, color)
        local header = GetPooledElement("subheader", function()
            return Utils:CreateCollapsibleSubSection(scrollChild)
        end)
        
        header:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 8, yOffset)
        header:SetPoint("TOPRIGHT", anchorFrame, "BOTTOMRIGHT", 0, yOffset)
        
        Utils:ConfigureSubSection(header, sectionState[sectionKey], label, color)
        
        header.sectionKey = sectionKey
        header:SetScript("OnClick", function(self)
            sectionState[self.sectionKey] = not sectionState[self.sectionKey]
            Refresh()
        end)
        
        return header, yOffset - SUBSECTION_HEIGHT
    end
    
    --- Create a checkbox with label and optional icon
    ---@param label string The checkbox label
    ---@param icon string|nil Optional icon texture path
    ---@param onClick function|nil Optional click callback
    ---@param tooltip string|table|nil Optional tooltip (string or table with {title, lines...})
    local function GetCheckbox(label, icon, onClick, tooltip)
        local frame = GetPooledElement("checkbox", function()
            local f = CreateFrame("Frame", nil, scrollChild)
            f:SetSize(150, 20)
            
            -- Checkbox button (visual only, clicks pass to parent)
            f.btn = CreateFrame("Frame", nil, f)
            f.btn:SetSize(14, 14)
            f.btn:SetPoint("LEFT", f, "LEFT", 0, 0)
            f.btn:EnableMouse(false)
            
            -- Checkbox background
            f.btn.bg = f.btn:CreateTexture(nil, "BACKGROUND")
            f.btn.bg:SetAllPoints()
            f.btn.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
            
            -- Checkbox border
            f.btn.border = f.btn:CreateTexture(nil, "BORDER")
            f.btn.border:SetPoint("TOPLEFT", -1, 1)
            f.btn.border:SetPoint("BOTTOMRIGHT", 1, -1)
            f.btn.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
            
            -- Filled check indicator
            f.btn.check = f.btn:CreateTexture(nil, "ARTWORK")
            f.btn.check:SetPoint("TOPLEFT", f.btn, "TOPLEFT", 1, -1)
            f.btn.check:SetPoint("BOTTOMRIGHT", f.btn, "BOTTOMRIGHT", -1, 1)
            f.btn.check:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
            f.btn.check:Hide()
            
            -- Icon placeholder
            f.icon = f:CreateTexture(nil, "ARTWORK")
            f.icon:SetSize(16, 16)
            f.icon:SetPoint("LEFT", f.btn, "RIGHT", 6, 0)
            f.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            
            -- Label
            local Fonts = Deathless.UI.Fonts
            f.label = f:CreateFontString(nil, "OVERLAY")
            f.label:SetFont(Fonts.family, Fonts.body, "")
            f.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            
            f.checked = false
            
            function f:SetChecked(checked)
                self.checked = checked
                if checked then
                    self.btn.check:Show()
                else
                    self.btn.check:Hide()
                end
            end
            
            -- Make entire frame clickable
            f:EnableMouse(true)
            f:SetScript("OnEnter", function(self)
                self.label:SetTextColor(1, 1, 1, 1)
                if not self.checked then
                    self.btn.bg:SetColorTexture(Colors.bgLight[1] + 0.1, Colors.bgLight[2] + 0.1, Colors.bgLight[3] + 0.1, 1)
                end
                
                -- Show tooltip if provided
                if self.tooltip then
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 8, 0)
                    -- Add title (class name)
                    GameTooltip:SetText(self.tooltipLabel or label, 1, 1, 1)
                    -- Add tooltip text
                    if type(self.tooltip) == "string" then
                        GameTooltip:AddLine(self.tooltip, 0.8, 0.8, 0.8, true)
                    elseif type(self.tooltip) == "table" then
                        for _, line in ipairs(self.tooltip) do
                            if type(line) == "string" then
                                GameTooltip:AddLine(line, 0.8, 0.8, 0.8, true)
                            end
                        end
                    end
                    GameTooltip:Show()
                end
            end)
            
            f:SetScript("OnLeave", function(self)
                self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                if not self.checked then
                    self.btn.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
                end
                GameTooltip:Hide()
            end)
            
            return f
        end)
        
        -- Configure icon
        if icon then
            frame.icon:SetTexture(icon)
            frame.icon:Show()
            frame.label:SetPoint("LEFT", frame.icon, "RIGHT", 4, 0)
            frame.tooltipIcon = icon
        else
            frame.icon:Hide()
            frame.label:SetPoint("LEFT", frame.btn, "RIGHT", 6, 0)
            frame.tooltipIcon = nil
        end
        
        frame.label:SetText(label)
        frame.tooltipLabel = label
        frame.tooltip = tooltip
        
        -- Set click handler on entire frame for larger hit area
        frame:SetScript("OnMouseDown", function(self)
            self:SetChecked(not self.checked)
            if onClick then onClick(self.checked) end
        end)
        
        return frame
    end
    
    -- Class icons lookup
    local CLASS_ICONS = {
        Druid = Icons.CLASS_DRUID,
        Hunter = Icons.CLASS_HUNTER,
        Mage = Icons.CLASS_MAGE,
        Paladin = Icons.CLASS_PALADIN,
        Priest = Icons.CLASS_PRIEST,
        Rogue = Icons.CLASS_ROGUE,
        Shaman = Icons.CLASS_SHAMAN,
        Warlock = Icons.CLASS_WARLOCK,
        Warrior = Icons.CLASS_WARRIOR,
    }
    
    -- Class tooltips
    local CLASS_TOOLTIPS = {
        Druid = "Show information for the Druid",
        Hunter = "Show information for the Hunter",
        Mage = "Show information for the Mage",
        Paladin = "Show information for the Paladin",
        Priest = "Show information for the Priest",
        Rogue = "Show information for the Rogue",
        Shaman = "Show information for the Shaman",
        Warlock = "Show information for the Warlock",
        Warrior = "Show information for the Warrior",
    }
    
    -- Warning category definitions
    local WARNING_CATEGORIES = {
        { key = "bandages", label = "Bandages", icon = Icons.WARNING_BANDAGES, tooltip = "Show warnings for bandages" },
        { key = "classReagents", label = "Class Reagents", icon = Icons.WARNING_CLASS_REAGENTS, tooltip = "Show warnings for class reagents" },
        { key = "engineering", label = "Engineering Items", icon = Icons.WARNING_ENGINEERING, tooltip = "Show warnings for engineering items" },
        { key = "flasks", label = "Flasks of Petrification", icon = Icons.WARNING_FLASKS, tooltip = "Show warnings for Flasks of Petrification" },
        { key = "healthPotions", label = "Health Potions", icon = Icons.WARNING_HEALTH_POTIONS, tooltip = "Show warnings for health potions" },
        { key = "hearthstone", label = "Hearthstone", icon = Icons.WARNING_HEARTHSTONE, tooltip = "Show warnings for hearthstone" },
        { key = "lip", label = "LIP", icon = Icons.WARNING_LIP, tooltip = "Show warnings for Limited Invulnerability Potions" },
        { key = "mageConjures", label = "Mage Consumables", icon = Icons.WARNING_MAGE_CONJURES, tooltip = "Show warnings for mage consumables" },
        { key = "manaPotions", label = "Mana Potions", icon = Icons.WARNING_MANA_POTIONS, tooltip = "Show warnings for mana potions" },
        { key = "swiftnessPotions", label = "Swiftness Potions", icon = Icons.WARNING_SWIFTNESS_POTIONS, tooltip = "Show warnings for swiftness potions" },
        { key = "talents", label = "Unspent Talents", icon = Icons.WARNING_TALENTS, tooltip = "Show warnings for unspent talent points" },
    }
    
    -- Ability section definitions
    local ABILITY_SECTIONS = {
        { key = "showLearned", label = "Show Learned", tooltip = "Show abilities you have already learned" },
        { key = "showAvailable", label = "Show Available", tooltip = "Show abilities available at your current level" },
        { key = "showNextAvailable", label = "Show Next Available", tooltip = "Show abilities that will be available soon" },
        { key = "showUnavailable", label = "Show Unavailable", tooltip = "Show abilities not yet available" },
    }
    
    Refresh = function()
        ClearPools()
        
        local yOffset = -16
        
        -- === Classes Section ===
        local classSection
        classSection, yOffset = GetSectionHeader("classes", "Classes", yOffset)
        
        if sectionState.classes then
            for i, className in ipairs(Deathless.CLASS_LIST) do
                local col = math.floor((i - 1) / CLASS_ROWS)
                local row = (i - 1) % CLASS_ROWS
                
                local checkbox = GetCheckbox(className, CLASS_ICONS[className], function(checked)
                    Deathless.config.includedClasses[className] = checked
                    Deathless:SaveConfig()
                    if Deathless.UI.Navigation.RepositionButtons then
                        Deathless.UI.Navigation:RepositionButtons()
                    end
                    Deathless.Utils.Warnings:TriggerRefresh()
                end, CLASS_TOOLTIPS[className])
                
                checkbox:SetPoint("TOPLEFT", classSection, "BOTTOMLEFT", 8 + (col * COL_WIDTH), -8 - (row * ROW_HEIGHT))
                checkbox:SetChecked(Deathless.config.includedClasses[className] == true)
            end
            
            yOffset = yOffset - (CLASS_ROWS * ROW_HEIGHT) - 16
        end
        
        -- === Summary Section ===
        local summarySection
        summarySection, yOffset = GetSectionHeader("summary", "Summary", yOffset)
        
        if sectionState.summary then
            -- Warnings sub-section header
            local warningsHeader, _ = GetSubSectionHeader("warnings", "Warnings", summarySection, -8, { 1, 0.8, 0.2 })
            yOffset = yOffset - 8 - SUBSECTION_HEIGHT
            
            if sectionState.warnings then
                -- Ensure warnings config exists
                Deathless.config.warnings = Deathless.config.warnings or {}
                
                for i, category in ipairs(WARNING_CATEGORIES) do
                    local col = math.floor((i - 1) / WARNING_ROWS)
                    local row = (i - 1) % WARNING_ROWS
                    
                    local checkbox = GetCheckbox(category.label, category.icon, function(checked)
                        Deathless.config.warnings[category.key] = checked
                        Deathless:SaveConfig()
                        Deathless.Utils.Warnings:TriggerRefresh()
                    end, category.tooltip)
                    
                    checkbox:SetPoint("TOPLEFT", warningsHeader, "BOTTOMLEFT", col * COL_WIDTH, -8 - (row * ROW_HEIGHT))
                end
                
                -- Update yOffset: WARNING_ROWS is the number of rows (4), not columns
                yOffset = yOffset - 8 - (WARNING_ROWS * ROW_HEIGHT) - 8
            end
            
            -- Abilities sub-section header (anchor to scrollChild using absolute yOffset)
            local abilitiesHeader = GetPooledElement("subheader", function()
                return Utils:CreateCollapsibleSubSection(scrollChild)
            end)
            abilitiesHeader:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 8, yOffset)
            abilitiesHeader:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, yOffset)
            Utils:ConfigureSubSection(abilitiesHeader, sectionState.abilities, "Abilities", { 0.5, 0.8, 1.0 })
            abilitiesHeader.sectionKey = "abilities"
            abilitiesHeader:SetScript("OnClick", function(self)
                sectionState[self.sectionKey] = not sectionState[self.sectionKey]
                Refresh()
            end)
            yOffset = yOffset - SUBSECTION_HEIGHT
            
            if sectionState.abilities then
                -- Ensure abilities config exists
                Deathless.config.abilities = Deathless.config.abilities or {}
                
                for i, section in ipairs(ABILITY_SECTIONS) do
                    local row = i - 1
                    
                    local checkbox = GetCheckbox(section.label, nil, function(checked)
                        Deathless.config.abilities[section.key] = checked
                        Deathless:SaveConfig()
                        Deathless.Utils.Warnings:TriggerRefresh()
                    end, section.tooltip)
                    
                    checkbox:SetPoint("TOPLEFT", abilitiesHeader, "BOTTOMLEFT", 0, -8 - (row * ROW_HEIGHT))
                end
                
                -- Update yOffset for abilities content
                yOffset = yOffset - 8 - (#ABILITY_SECTIONS * ROW_HEIGHT) - 8
            end
        end
        
        -- Update scroll child height and scrollbar (match abilities_template behavior)
        scrollChild:SetHeight(math.abs(yOffset) + 10)
        
        -- Update scrollbar visibility after content changes
        C_Timer.After(0, function()
            if scrollFrame.UpdateScrollbar then
                scrollFrame.UpdateScrollbar()
            end
        end)
    end
    
    -- Initial render
    Refresh()
    
    return { 
        title = title, 
        subtitle = subtitle,
        Refresh = Refresh
    }
end)
