local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

-- Store template for reuse
Deathless.UI.Views.GearTemplate = {}

--- Create a gear view for a specific class
---@param config table Configuration: { viewName, className, classId, classColor }
function Deathless.UI.Views.GearTemplate:Create(config)
    local viewName = config.viewName
    local className = config.className
    local classColor = config.classColor
    
    Deathless.UI.Views:Register(viewName, function(container)
        local Colors = Utils:GetColors()
        
        local title, subtitle = Utils:CreateHeader(container, className .. " Gear", "Equipment progression for Hardcore", classColor)
        
        -- Scroll frame for content
        local scrollFrame = CreateFrame("ScrollFrame", nil, container, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", container, "TOPLEFT", 8, -70)
        scrollFrame:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -28, 24)
        
        local scrollBar = scrollFrame.ScrollBar
        if scrollBar then
            scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 4, -16)
            scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 4, 16)
        end
        
        local scrollChild = CreateFrame("Frame", nil, scrollFrame)
        scrollChild:SetWidth(540)
        scrollChild:SetHeight(800)
        scrollFrame:SetScrollChild(scrollChild)
        
        -- Smooth scrolling
        local targetScroll = 0
        scrollFrame:EnableMouseWheel(true)
        scrollFrame:SetScript("OnMouseWheel", function(self, delta)
            local maxScroll = math.max(0, scrollChild:GetHeight() - scrollFrame:GetHeight())
            targetScroll = math.max(0, math.min(targetScroll - (delta * 40), maxScroll))
        end)
        scrollFrame:SetScript("OnUpdate", function(self)
            local current = self:GetVerticalScroll()
            if math.abs(current - targetScroll) > 0.5 then
                self:SetVerticalScroll(current + (targetScroll - current) * 0.3)
            end
        end)
        
        -- Get gear data
        local gearData = Deathless.Data.Gear and Deathless.Data.Gear[className] or {}
        
        local yOffset = -8
        
        -- ========================================
        -- GENERAL NOTES SECTION
        -- ========================================
        local header1 = scrollChild:CreateFontString(nil, "OVERLAY")
        header1:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
        header1:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 8, yOffset)
        header1:SetText("General Notes")
        header1:SetTextColor(classColor[1], classColor[2], classColor[3], 1)
        
        local line1 = scrollChild:CreateTexture(nil, "ARTWORK")
        line1:SetHeight(1)
        line1:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, -4)
        line1:SetWidth(520)
        line1:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
        
        yOffset = yOffset - 28
        
        local notes1 = scrollChild:CreateFontString(nil, "OVERLAY")
        notes1:SetFont("Fonts\\ARIALN.TTF", 11, "")
        notes1:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
        notes1:SetWidth(516)
        notes1:SetJustifyH("LEFT")
        notes1:SetText(gearData.generalNotes or "No general notes available.")
        notes1:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        notes1:SetSpacing(2)
        
        yOffset = yOffset - 120
        
        -- ========================================
        -- WEAPON PROGRESSION SECTION
        -- ========================================
        local header2 = scrollChild:CreateFontString(nil, "OVERLAY")
        header2:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
        header2:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 8, yOffset)
        header2:SetText("Weapon Progression")
        header2:SetTextColor(classColor[1], classColor[2], classColor[3], 1)
        
        local line2 = scrollChild:CreateTexture(nil, "ARTWORK")
        line2:SetHeight(1)
        line2:SetPoint("TOPLEFT", header2, "BOTTOMLEFT", 0, -4)
        line2:SetWidth(520)
        line2:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
        
        yOffset = yOffset - 28
        
        local notes2 = scrollChild:CreateFontString(nil, "OVERLAY")
        notes2:SetFont("Fonts\\ARIALN.TTF", 11, "")
        notes2:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
        notes2:SetWidth(516)
        notes2:SetJustifyH("LEFT")
        notes2:SetText(gearData.weaponProgression or "No weapon progression notes available.")
        notes2:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        notes2:SetSpacing(2)
        
        yOffset = yOffset - 140
        
        -- ========================================
        -- IMPORTANT GEAR TABLE
        -- ========================================
        local header3 = scrollChild:CreateFontString(nil, "OVERLAY")
        header3:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
        header3:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 8, yOffset)
        header3:SetText("Important Gear")
        header3:SetTextColor(classColor[1], classColor[2], classColor[3], 1)
        
        local line3 = scrollChild:CreateTexture(nil, "ARTWORK")
        line3:SetHeight(1)
        line3:SetPoint("TOPLEFT", header3, "BOTTOMLEFT", 0, -4)
        line3:SetWidth(520)
        line3:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)
        
        yOffset = yOffset - 28
        
        -- Table headers
        local COL_ITEM, COL_LEVEL, COL_SOURCE, COL_NOTE = 200, 50, 120, 150
        
        local thItem = scrollChild:CreateFontString(nil, "OVERLAY")
        thItem:SetFont("Fonts\\ARIALN.TTF", 10, "")
        thItem:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
        thItem:SetText("ITEM")
        thItem:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        local thLevel = scrollChild:CreateFontString(nil, "OVERLAY")
        thLevel:SetFont("Fonts\\ARIALN.TTF", 10, "")
        thLevel:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM, yOffset)
        thLevel:SetText("LEVEL")
        thLevel:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        local thSource = scrollChild:CreateFontString(nil, "OVERLAY")
        thSource:SetFont("Fonts\\ARIALN.TTF", 10, "")
        thSource:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM + COL_LEVEL, yOffset)
        thSource:SetText("SOURCE")
        thSource:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        local thNote = scrollChild:CreateFontString(nil, "OVERLAY")
        thNote:SetFont("Fonts\\ARIALN.TTF", 10, "")
        thNote:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM + COL_LEVEL + COL_SOURCE, yOffset)
        thNote:SetText("NOTE")
        thNote:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        yOffset = yOffset - 20
        
        -- Table rows
        local importantGear = gearData.importantGear or {}
        
        for i, item in ipairs(importantGear) do
            local rowY = yOffset
            
            if i % 2 == 0 then
                local rowBg = scrollChild:CreateTexture(nil, "BACKGROUND")
                rowBg:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 8, rowY + 2)
                rowBg:SetSize(520, 22)
                rowBg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], 0.2)
            end
            
            local itemName = scrollChild:CreateFontString(nil, "OVERLAY")
            itemName:SetFont("Fonts\\ARIALN.TTF", 11, "")
            itemName:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, rowY)
            itemName:SetWidth(COL_ITEM - 8)
            itemName:SetText(item.name or "Unknown")
            itemName:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            
            local levelText = scrollChild:CreateFontString(nil, "OVERLAY")
            levelText:SetFont("Fonts\\ARIALN.TTF", 11, "")
            levelText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM, rowY)
            levelText:SetText(item.level or "-")
            levelText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local sourceText = scrollChild:CreateFontString(nil, "OVERLAY")
            sourceText:SetFont("Fonts\\ARIALN.TTF", 11, "")
            sourceText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM + COL_LEVEL, rowY)
            sourceText:SetText(item.source or "-")
            sourceText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local noteText = scrollChild:CreateFontString(nil, "OVERLAY")
            noteText:SetFont("Fonts\\ARIALN.TTF", 11, "")
            noteText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM + COL_LEVEL + COL_SOURCE, rowY)
            noteText:SetWidth(COL_NOTE)
            noteText:SetText(item.note or "")
            noteText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.9)
            
            yOffset = yOffset - 22
        end
        
        if #importantGear == 0 then
            local placeholder = scrollChild:CreateFontString(nil, "OVERLAY")
            placeholder:SetFont("Fonts\\ARIALN.TTF", 11, "")
            placeholder:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
            placeholder:SetText("No gear data available yet.")
            placeholder:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.7)
        end
        
        return { title = title, subtitle = subtitle, scrollFrame = scrollFrame, scrollChild = scrollChild }
    end)
end
