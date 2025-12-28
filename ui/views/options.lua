local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

--- Create a checkbox with label and optional icon
---@param parent Frame Parent frame
---@param label string Checkbox label
---@param icon string|nil Optional icon path
---@param onClick function Callback when clicked (receives checked state)
---@return Frame The checkbox frame
local function CreateCheckbox(parent, label, icon, onClick)
    local Colors = Utils:GetColors()
    
    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(150, 20)
    
    -- Checkbox button
    local btn = CreateFrame("Button", nil, frame)
    btn:SetSize(16, 16)
    btn:SetPoint("LEFT", frame, "LEFT", 0, 0)
    
    -- Checkbox background
    btn.bg = btn:CreateTexture(nil, "BACKGROUND")
    btn.bg:SetAllPoints()
    btn.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
    
    -- Checkbox border
    btn.border = btn:CreateTexture(nil, "BORDER")
    btn.border:SetPoint("TOPLEFT", -1, 1)
    btn.border:SetPoint("BOTTOMRIGHT", 1, -1)
    btn.border:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 1)
    
    -- Filled check indicator (green rectangle)
    btn.check = btn:CreateTexture(nil, "ARTWORK")
    btn.check:SetPoint("TOPLEFT", btn, "TOPLEFT", 2, -2)
    btn.check:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 2)
    btn.check:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    btn.check:Hide()
    
    -- Track where to anchor the label
    local labelAnchor = btn
    local labelOffset = 6
    
    -- Icon (if provided)
    if icon then
        frame.icon = frame:CreateTexture(nil, "ARTWORK")
        frame.icon:SetSize(16, 16)
        frame.icon:SetPoint("LEFT", btn, "RIGHT", 6, 0)
        frame.icon:SetTexture(icon)
        frame.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        labelAnchor = frame.icon
        labelOffset = 4
    end
    
    -- Label
    local labelText = frame:CreateFontString(nil, "OVERLAY")
    labelText:SetFont("Fonts\\ARIALN.TTF", 11, "")
    labelText:SetPoint("LEFT", labelAnchor, "RIGHT", labelOffset, 0)
    labelText:SetText(label)
    labelText:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    frame.btn = btn
    frame.label = labelText
    frame.checked = false
    
    function frame:SetChecked(checked)
        self.checked = checked
        if checked then
            self.btn.check:Show()
        else
            self.btn.check:Hide()
        end
    end
    
    function frame:IsChecked()
        return self.checked
    end
    
    btn:SetScript("OnClick", function()
        frame:SetChecked(not frame.checked)
        if onClick then onClick(frame.checked) end
    end)
    
    btn:SetScript("OnEnter", function(self)
        if not frame.checked then
            self.bg:SetColorTexture(Colors.bgLight[1] + 0.05, Colors.bgLight[2] + 0.05, Colors.bgLight[3] + 0.05, 1)
        end
    end)
    
    btn:SetScript("OnLeave", function(self)
        if not frame.checked then
            self.bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 1)
        end
    end)
    
    return frame
end

--- Create a section sub-header
---@param parent Frame Parent frame
---@param text string Header text
---@param anchor Frame Frame to anchor below
---@param yOffset number Y offset from anchor
---@return FontString The header text
local function CreateSectionHeader(parent, text, anchor, yOffset)
    local Colors = Utils:GetColors()
    
    local header = parent:CreateFontString(nil, "OVERLAY")
    header:SetFont("Fonts\\FRIZQT__.TTF", 13, "")
    header:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, yOffset)
    header:SetText(text)
    header:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
    
    return header
end

--- Initialize included classes config based on player class
local function InitIncludedClasses()
    if Deathless.config.includedClasses == nil then
        Deathless.config.includedClasses = {}
        -- Get player class
        local _, playerClass = UnitClass("player")
        if playerClass then
            -- Format: WARRIOR -> Warrior
            local formatted = playerClass:sub(1, 1) .. playerClass:sub(2):lower()
            Deathless.config.includedClasses[formatted] = true
        end
    end
end

--- Options view content
Deathless.UI.Views:Register("options", function(container)
    local Colors = Utils:GetColors()
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Options", "Addon settings and preferences")
    
    -- Initialize included classes if needed
    InitIncludedClasses()
    
    -- === Include Classes Section ===
    local classHeader = CreateSectionHeader(container, "Include Classes", separator, -16)
    
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
    
    -- Create checkboxes for each class in a 3-column grid (column-major order)
    local checkboxes = {}
    local COL_WIDTH = 150
    local ROW_HEIGHT = 24
    local COLS = 3
    local ROWS = 3
    
    for i, className in ipairs(Deathless.CLASS_LIST) do
        -- Column-major: fill columns top-to-bottom, then move right
        local col = math.floor((i - 1) / ROWS)
        local row = (i - 1) % ROWS
        
        local checkbox = CreateCheckbox(container, className, CLASS_ICONS[className], function(checked)
            Deathless.config.includedClasses[className] = checked
            Deathless:SaveConfig()
            -- Refresh navigation
            if Deathless.UI.Navigation.RepositionButtons then
                Deathless.UI.Navigation:RepositionButtons()
            end
        end)
        
        checkbox:SetPoint("TOPLEFT", classHeader, "BOTTOMLEFT", col * COL_WIDTH, -8 - (row * ROW_HEIGHT))
        checkbox:SetChecked(Deathless.config.includedClasses[className] == true)
        
        checkboxes[className] = checkbox
    end
    
    return { 
        title = title, 
        subtitle = subtitle, 
        classHeader = classHeader,
        checkboxes = checkboxes 
    }
end)
