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
        local Fonts = Deathless.UI.Fonts
        
        local title, subtitle = Utils:CreateHeader(container, className .. " Gear", "Equipment progression for Hardcore", classColor)
        
        -- Enhanced scroll frame with auto-hiding scrollbar
        local scrollFrame, scrollChild = Utils:CreateScrollFrame(container, -70, 24)
        scrollChild:SetWidth(540)
        scrollChild:SetHeight(800)
        
        -- Get gear data
        local gearData = Deathless.Data.Gear and Deathless.Data.Gear[className] or {}
        
        local yOffset = -8
        
        -- ========================================
        -- GENERAL NOTES SECTION
        -- ========================================
        local header1, line1
        header1, line1, yOffset = Utils:CreateContentHeader(scrollChild, "General Notes", classColor, yOffset)
        
        local notes1 = scrollChild:CreateFontString(nil, "OVERLAY")
        notes1:SetFont(Fonts.family, Fonts.body, "")
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
        local header2, line2
        header2, line2, yOffset = Utils:CreateContentHeader(scrollChild, "Weapon Progression", classColor, yOffset)
        
        local notes2 = scrollChild:CreateFontString(nil, "OVERLAY")
        notes2:SetFont(Fonts.family, Fonts.body, "")
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
        local header3, line3
        header3, line3, yOffset = Utils:CreateContentHeader(scrollChild, "Important Gear", classColor, yOffset)
        
        -- Table headers
        local COL_ITEM, COL_LEVEL, COL_SOURCE, COL_NOTE = 200, 50, 120, 150
        
        local thItem = scrollChild:CreateFontString(nil, "OVERLAY")
        thItem:SetFont(Fonts.family, Fonts.small, "")
        thItem:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
        thItem:SetText("ITEM")
        thItem:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        local thLevel = scrollChild:CreateFontString(nil, "OVERLAY")
        thLevel:SetFont(Fonts.family, Fonts.small, "")
        thLevel:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM, yOffset)
        thLevel:SetText("LEVEL")
        thLevel:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        local thSource = scrollChild:CreateFontString(nil, "OVERLAY")
        thSource:SetFont(Fonts.family, Fonts.small, "")
        thSource:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM + COL_LEVEL, yOffset)
        thSource:SetText("SOURCE")
        thSource:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        
        local thNote = scrollChild:CreateFontString(nil, "OVERLAY")
        thNote:SetFont(Fonts.family, Fonts.small, "")
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
            itemName:SetFont(Fonts.family, Fonts.body, "")
            itemName:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, rowY)
            itemName:SetWidth(COL_ITEM - 8)
            itemName:SetText(item.name or "Unknown")
            itemName:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            
            local levelText = scrollChild:CreateFontString(nil, "OVERLAY")
            levelText:SetFont(Fonts.family, Fonts.body, "")
            levelText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM, rowY)
            levelText:SetText(item.level or "-")
            levelText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local sourceText = scrollChild:CreateFontString(nil, "OVERLAY")
            sourceText:SetFont(Fonts.family, Fonts.body, "")
            sourceText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM + COL_LEVEL, rowY)
            sourceText:SetText(item.source or "-")
            sourceText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            
            local noteText = scrollChild:CreateFontString(nil, "OVERLAY")
            noteText:SetFont(Fonts.family, Fonts.body, "")
            noteText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12 + COL_ITEM + COL_LEVEL + COL_SOURCE, rowY)
            noteText:SetWidth(COL_NOTE)
            noteText:SetText(item.note or "")
            noteText:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.9)
            
            yOffset = yOffset - 22
        end
        
        if #importantGear == 0 then
            local placeholder = scrollChild:CreateFontString(nil, "OVERLAY")
            placeholder:SetFont(Fonts.family, Fonts.body, "")
            placeholder:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 12, yOffset)
            placeholder:SetText("No gear data available yet.")
            placeholder:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.7)
        end
        
        return { title = title, subtitle = subtitle, scrollFrame = scrollFrame, scrollChild = scrollChild }
    end)
end
