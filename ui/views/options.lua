local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Options view content
Deathless.UI.Views:Register("options", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Options", "Addon settings and preferences")
    
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
            return Utils:CreateCollapsibleSection(container)
        end)
        
        section:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, yOffset)
        section:SetPoint("TOPRIGHT", separator, "BOTTOMRIGHT", 0, yOffset)
        
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
            return Utils:CreateCollapsibleSubSection(container)
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
    local function GetCheckbox(label, icon, onClick)
        local frame = GetPooledElement("checkbox", function()
            local f = CreateFrame("Frame", nil, container)
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
            f.label = f:CreateFontString(nil, "OVERLAY")
            f.label:SetFont("Fonts\\ARIALN.TTF", 11, "")
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
            end)
            
            f:SetScript("OnLeave", function(self)
                self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                if not self.checked then
                    self.btn.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
                end
            end)
            
            return f
        end)
        
        -- Configure icon
        if icon then
            frame.icon:SetTexture(icon)
            frame.icon:Show()
            frame.label:SetPoint("LEFT", frame.icon, "RIGHT", 4, 0)
        else
            frame.icon:Hide()
            frame.label:SetPoint("LEFT", frame.btn, "RIGHT", 6, 0)
        end
        
        frame.label:SetText(label)
        
        -- Set click handler on entire frame for larger hit area
        frame:SetScript("OnMouseDown", function(self)
            self:SetChecked(not self.checked)
            if onClick then onClick(self.checked) end
        end)
        
        return frame
    end
    
    -- Class icons lookup
    local CLASS_ICONS = {
        Druid = "Interface\\Icons\\ClassIcon_Druid",
        Hunter = "Interface\\Icons\\ClassIcon_Hunter",
        Mage = "Interface\\Icons\\ClassIcon_Mage",
        Paladin = "Interface\\Icons\\ClassIcon_Paladin",
        Priest = "Interface\\Icons\\ClassIcon_Priest",
        Rogue = "Interface\\Icons\\ClassIcon_Rogue",
        Shaman = "Interface\\Icons\\ClassIcon_Shaman",
        Warlock = "Interface\\Icons\\ClassIcon_Warlock",
        Warrior = "Interface\\Icons\\ClassIcon_Warrior",
    }
    
    -- Warning category definitions
    local WARNING_CATEGORIES = {
        { key = "bandages", label = "Bandages", icon = "Interface\\Icons\\INV_Misc_Bandage_12" },
        { key = "classReagents", label = "Class Reagents", icon = "Interface\\Icons\\INV_Misc_Rune_06" },
        { key = "engineering", label = "Engineering Items", icon = "Interface\\Icons\\INV_Misc_Bomb_08" },
        { key = "flasks", label = "Flasks of Petrification", icon = "Interface\\Icons\\INV_Potion_26" },
        { key = "healthPotions", label = "Health Potions", icon = "Interface\\Icons\\INV_Potion_54" },
        { key = "hearthstone", label = "Hearthstone", icon = "Interface\\Icons\\INV_Misc_Rune_01" },
        { key = "lip", label = "LIP", icon = "Interface\\Icons\\INV_Potion_62" },
        { key = "mageConjures", label = "Mage Consumables", icon = "Interface\\Icons\\INV_Misc_Gem_Ruby_01" },
        { key = "manaPotions", label = "Mana Potions", icon = "Interface\\Icons\\INV_Potion_76" },
        { key = "swiftnessPotions", label = "Swiftness Potions", icon = "Interface\\Icons\\INV_Potion_95" },
        { key = "talents", label = "Unspent Talents", icon = "Interface\\Icons\\INV_Misc_Book_11" },
    }
    
    -- Ability section definitions
    local ABILITY_SECTIONS = {
        { key = "showLearned", label = "Show Learned" },
        { key = "showAvailable", label = "Show Available" },
        { key = "showNextAvailable", label = "Show Next Available" },
        { key = "showUnavailable", label = "Show Unavailable" },
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
                end)
                
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
            local warningsHeader, warningsYOffset = GetSubSectionHeader("warnings", "Warnings", summarySection, -8, { 1, 0.8, 0.2 })
            
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
                    end)
                    
                    checkbox:SetPoint("TOPLEFT", warningsHeader, "BOTTOMLEFT", col * COL_WIDTH, -8 - (row * ROW_HEIGHT))
                    
                    local isChecked = Deathless.config.warnings[category.key]
                    if isChecked == nil then isChecked = true end
                    checkbox:SetChecked(isChecked)
                end
            end
            
            -- Calculate warnings section height for next anchor
            local warningsContentHeight = sectionState.warnings and (math.ceil(#WARNING_CATEGORIES / WARNING_ROWS) * ROW_HEIGHT + 28) or 0
            local abilitiesYOffset = -8 - SUBSECTION_HEIGHT - warningsContentHeight - 8
            
            -- Abilities sub-section header
            local abilitiesHeader = GetSubSectionHeader("abilities", "Abilities", summarySection, abilitiesYOffset, { 0.5, 0.8, 1.0 })
            
            if sectionState.abilities then
                -- Ensure abilities config exists
                Deathless.config.abilities = Deathless.config.abilities or {}
                
                for i, section in ipairs(ABILITY_SECTIONS) do
                    local row = i - 1
                    
                    local checkbox = GetCheckbox(section.label, nil, function(checked)
                        Deathless.config.abilities[section.key] = checked
                        Deathless:SaveConfig()
                        Deathless.Utils.Warnings:TriggerRefresh()
                    end)
                    
                    checkbox:SetPoint("TOPLEFT", abilitiesHeader, "BOTTOMLEFT", 0, -8 - (row * ROW_HEIGHT))
                    
                    local isChecked = Deathless.config.abilities[section.key]
                    if isChecked == nil then isChecked = true end
                    checkbox:SetChecked(isChecked)
                end
            end
        end
    end
    
    -- Initial render
    Refresh()
    
    return { 
        title = title, 
        subtitle = subtitle,
        Refresh = Refresh
    }
end)
