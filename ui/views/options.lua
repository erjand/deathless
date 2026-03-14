local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils
local Icons = Deathless.Utils.Icons
local UIUtils = Deathless.Utils.UI
local ViewOffsets = Deathless.Constants.Colors.UI.ViewOffsets
local WarningCategories = (Deathless.Constants and Deathless.Constants.WarningCategories) or {
    AMMO = "ammo",
    BANDAGES = "bandages",
    CLASS_REAGENTS = "classReagents",
    ENGINEERING = "engineering",
    FLASKS = "flasks",
    HEALTH_POTIONS = "healthPotions",
    HEARTHSTONE = "hearthstone",
    LIP = "lip",
    MAGE_CONJURES = "mageConjures",
    MANA_POTIONS = "manaPotions",
    QUESTS = "quests",
    SWIFTNESS_POTIONS = "swiftnessPotions",
    TALENTS = "talents",
}
local AmmoConstants = (Deathless.Constants and Deathless.Constants.Ammo) or {
    LOW_THRESHOLD_MELEE = 20,
    WARNING_MIN_LEVEL = 10,
    WARNING_MIN_LEVEL_MELEE = 10,
}
local MiniSections = (Deathless.Constants and Deathless.Constants.MiniSections) or {
    WARNINGS = "warnings",
    XP_PROGRESS = "xpProgress",
    AVAILABLE = "available",
    NEXT_AVAILABLE = "nextAvailable",
}

--- Options view content
Deathless.UI.Views:Register("options", function(container)
    local Colors = Utils:GetColors()
    local Layout = Utils.Layout
    local IconStyle = Deathless.Constants.Colors.UI.Icon
    local CONTENT_LEFT = 12
    local CONTENT_RIGHT = -12
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Options", "Addon settings and preferences")
    
    -- Enhanced scroll frame with auto-hiding scrollbar
    local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, ViewOffsets.simple.scrollTop, ViewOffsets.defaultScrollBottom)
    
    -- Layout constants
    local COL_WIDTH = 150
    local COL_GAP = 24
    local ROW_HEIGHT = 24
    local SECTION_HEIGHT = Layout.sectionHeight
    local WARNING_COLUMNS = 3
    local MINI_COLUMNS = 2
    local CLASS_ROWS = 3
    
    -- Section collapse state
    local sectionState = { classes = true, mini = true, warnings = true }
    
    -- Element pools
    local pools = { section = {}, checkbox = {} }
    local poolIndexes = { section = 0, checkbox = 0 }
    
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
        
        section:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", CONTENT_LEFT, yOffset)
        section:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", CONTENT_RIGHT, yOffset)
        
        Utils:ConfigureSection(section, sectionState[sectionKey], label, Colors.accent)
        
        section.sectionKey = sectionKey
        section:SetScript("OnClick", function(self)
            sectionState[self.sectionKey] = not sectionState[self.sectionKey]
            Refresh()
        end)
        
        return section, yOffset - SECTION_HEIGHT
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
            f.icon:SetSize(IconStyle.sizeSmall, IconStyle.sizeSmall)
            f.icon:SetPoint("LEFT", f.btn, "RIGHT", 6, 0)
            f.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            
            -- Label
            local Fonts = Deathless.UI.Fonts
            f.label = f:CreateFontString(nil, "OVERLAY")
            f.label:SetFont(Fonts.family, Fonts.body, "")
            f.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            
            f.checked = false
            f.enabled = true

            local function ApplyVisualState(self)
                if not self.enabled then
                    self:SetAlpha(IconStyle.alphaDisabled)
                    self.hoverBg:Hide()
                    self.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                    self.btn.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
                    self.btn.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
                    return
                end

                self:SetAlpha(1)
                self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                self.btn.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
                self.btn.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
            end
            
            function f:SetChecked(checked)
                self.checked = checked
                if checked then
                    self.btn.check:Show()
                else
                    self.btn.check:Hide()
                end
                ApplyVisualState(self)
            end

            function f:SetEnabled(enabled)
                self.enabled = enabled ~= false
                ApplyVisualState(self)
            end
            
            -- Frame background for hover effect
            f.hoverBg = f:CreateTexture(nil, "BACKGROUND")
            f.hoverBg:SetAllPoints()
            f.hoverBg:SetColorTexture(Colors.accent[1] * 0.15, Colors.accent[2] * 0.15, Colors.accent[3] * 0.15, 0.3)
            f.hoverBg:Hide()
            
            -- Make entire frame clickable
            f:EnableMouse(true)
            f:SetScript("OnEnter", function(self)
                if not self.enabled then
                    return
                end
                self.label:SetTextColor(Colors.white[1], Colors.white[2], Colors.white[3], Colors.white[4])
                self.hoverBg:Show()
                if not self.checked then
                    self.btn.bg:SetColorTexture(Colors.bgLight[1] + 0.25, Colors.bgLight[2] + 0.25, Colors.bgLight[3] + 0.25, 1)
                    self.btn.border:SetColorTexture(Colors.accent[1] * 0.6, Colors.accent[2] * 0.6, Colors.accent[3] * 0.6, 1)
                else
                    self.btn.border:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
                end
                
                -- Show tooltip if provided
                if self.tooltip then
                    Deathless.UI.Tooltip:Show(self, "ANCHOR_RIGHT", self.tooltipLabel or label, self.tooltip, self.tooltipIcon)
                end
            end)
            
            f:SetScript("OnLeave", function(self)
                if not self.enabled then
                    self.hoverBg:Hide()
                    Deathless.UI.Tooltip:Hide()
                    return
                end
                self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
                self.hoverBg:Hide()
                if not self.checked then
                    self.btn.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
                    self.btn.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
                else
                    self.btn.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
                end
                Deathless.UI.Tooltip:Hide()
            end)
            
            return f
        end)
        
        -- Configure icon
        if icon then
            frame.icon:SetTexture(icon)
            frame.icon:Show()
            UIUtils.ApplyIconStyle(frame.icon, "normal")
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
            if not self.enabled then
                return
            end
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
        { key = WarningCategories.AMMO, label = "Ammo", icon = Icons.WARNING_MISSING_EQUIPPED_AMMO, tooltip = "Show warnings for low throwing weapons" },
        { key = WarningCategories.BANDAGES, label = "Bandages", icon = Icons.WARNING_BANDAGES, tooltip = "Show warnings for bandages" },
        { key = WarningCategories.CLASS_REAGENTS, label = "Class Reagents", icon = Icons.WARNING_CLASS_REAGENTS, tooltip = "Show warnings for class reagents" },
        { key = WarningCategories.ENGINEERING, label = "Engineering Items", icon = Icons.WARNING_ENGINEERING, tooltip = "Show warnings for engineering items" },
        { key = WarningCategories.FLASKS, label = "Flasks of Petrification", icon = Icons.WARNING_FLASKS, tooltip = "Show warnings for Flasks of Petrification" },
        { key = WarningCategories.HEALTH_POTIONS, label = "Health Potions", icon = Icons.WARNING_HEALTH_POTIONS, tooltip = "Show warnings for health potions" },
        { key = WarningCategories.HEARTHSTONE, label = "Hearthstone", icon = Icons.WARNING_HEARTHSTONE, tooltip = "Show warnings for Hearthstone" },
        { key = WarningCategories.LIP, label = "LIP", icon = Icons.WARNING_LIP, tooltip = "Show warnings for Limited Invulnerability Potions" },
        { key = WarningCategories.MAGE_CONJURES, label = "Mage Consumables", icon = Icons.WARNING_MAGE_CONJURES, tooltip = "Show warnings for mage consumables" },
        { key = WarningCategories.MANA_POTIONS, label = "Mana Potions", icon = Icons.WARNING_MANA_POTIONS, tooltip = "Show warnings for mana potions" },
        { key = WarningCategories.QUESTS, label = "Quests", icon = Icons.WARNING_QUESTS, tooltip = "Show warnings for key quest completion" },
        { key = WarningCategories.SWIFTNESS_POTIONS, label = "Swiftness Potions", icon = Icons.WARNING_SWIFTNESS_POTIONS, tooltip = "Show warnings for swiftness potions" },
        { key = WarningCategories.TALENTS, label = "Unspent Talents", icon = Icons.WARNING_TALENTS, tooltip = "Show warnings for unspent talent points" },
    }

    local MINI_OPTIONS = {
        { key = MiniSections.WARNINGS, label = "Warnings", tooltip = "Toggle visibility of Warnings in the Mini window" },
        { key = MiniSections.XP_PROGRESS, label = "XP Progress", tooltip = "Toggle visibility of XP Progress in the Mini window" },
        { key = MiniSections.AVAILABLE, label = "Available", tooltip = "Toggle visibility of Available Abilities in the Mini window" },
        { key = MiniSections.NEXT_AVAILABLE, label = "Next Available", tooltip = "Toggle visibility of Next Available Abilities in the Mini window" },
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
                
                checkbox:SetPoint("TOPLEFT", classSection, "BOTTOMLEFT", 8 + (col * (COL_WIDTH + COL_GAP)), -8 - (row * ROW_HEIGHT))
                checkbox:SetChecked(Deathless.config.includedClasses[className] == true)
            end
            
            yOffset = yOffset - (CLASS_ROWS * ROW_HEIGHT) - 16
        end

        -- === Mini Section ===
        local miniSection
        miniSection, yOffset = GetSectionHeader("mini", "Mini", yOffset)

        if sectionState.mini then
            Deathless.config.mini = Deathless.config.mini or {}
            local miniRows = math.ceil(#MINI_OPTIONS / MINI_COLUMNS)
            local layout = Deathless.config.layout and Deathless.config.layout.mini
            local showMiniWindow = layout and layout.shown == true

            local showMiniCheckbox = GetCheckbox("Show Mini window", nil, function(checked)
                if Deathless.UI and Deathless.UI.MiniSummary then
                    if checked then
                        Deathless.UI.MiniSummary:Show()
                    else
                        Deathless.UI.MiniSummary:Hide()
                    end
                else
                    Deathless.config.layout = Deathless.config.layout or {}
                    Deathless.config.layout.mini = Deathless.config.layout.mini or {}
                    Deathless.config.layout.mini.shown = checked
                    Deathless:SaveConfig()
                end
                Refresh()
            end, "Toggle visibility of the Mini window")
            showMiniCheckbox:SetPoint("TOPLEFT", miniSection, "BOTTOMLEFT", 8, -8)
            showMiniCheckbox:SetChecked(showMiniWindow)
            showMiniCheckbox:SetEnabled(true)

            for i, option in ipairs(MINI_OPTIONS) do
                local col = math.floor((i - 1) / miniRows)
                local row = (i - 1) % miniRows

                local checkbox = GetCheckbox(option.label, nil, function(checked)
                    Deathless.config.mini[option.key] = checked
                    Deathless:SaveConfig()
                    if Deathless.UI and Deathless.UI.MiniSummary and Deathless.UI.MiniSummary.Refresh then
                        Deathless.UI.MiniSummary:Refresh()
                    end
                end, option.tooltip)

                checkbox:SetPoint("TOPLEFT", miniSection, "BOTTOMLEFT", 20 + (col * (COL_WIDTH + COL_GAP)), -8 - ROW_HEIGHT - (row * ROW_HEIGHT))
                checkbox:SetChecked(Deathless.config.mini[option.key] ~= false)
                checkbox:SetEnabled(showMiniWindow)
            end

            yOffset = yOffset - 8 - ROW_HEIGHT - (miniRows * ROW_HEIGHT) - 8
        end
        
        -- === Warnings Section ===
        local warningsSection
        warningsSection, yOffset = GetSectionHeader("warnings", "Warnings", yOffset)

        if sectionState.warnings then
            -- Ensure warnings config exists
            Deathless.config.warnings = Deathless.config.warnings or {}
            local warningRows = math.ceil(#WARNING_CATEGORIES / WARNING_COLUMNS)

            for i, category in ipairs(WARNING_CATEGORIES) do
                local col = math.floor((i - 1) / warningRows)
                local row = (i - 1) % warningRows

                local checkbox = GetCheckbox(category.label, category.icon, function(checked)
                    Deathless.config.warnings[category.key] = checked
                    Deathless:SaveConfig()
                    Deathless.Utils.Warnings:TriggerRefresh()
                end, category.tooltip)

                checkbox:SetPoint("TOPLEFT", warningsSection, "BOTTOMLEFT", 8 + (col * (COL_WIDTH + COL_GAP)), -8 - (row * ROW_HEIGHT))
                checkbox:SetChecked(Deathless.config.warnings[category.key] ~= false)
            end

            yOffset = yOffset - 8 - (warningRows * ROW_HEIGHT) - 8
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
