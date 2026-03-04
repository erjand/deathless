local Deathless = Deathless

-- PlayerTalentFrame is a WoW global loaded on demand with Blizzard_TalentUI

Deathless.UI.Talents = Deathless.UI.Talents or {}

--- Create the Deathless tab button on the talent frame
function Deathless.UI.Talents:Initialize()
    if self.initialized then return end
    
    -- Wait for PlayerTalentFrame to exist (loaded on demand)
    if not PlayerTalentFrame then
        return
    end
    
    self:SetupTab()
    self.initialized = true
end

--- Setup our tab on the talent frame
function Deathless.UI.Talents:SetupTab()
    local talentFrame = PlayerTalentFrame
    if not talentFrame then return end
    
    -- Create a tab button similar to spellbook
    local tabButton = CreateFrame("CheckButton", "DeathlessTalentTab", talentFrame, "SpellBookSkillLineTabTemplate")
    
    self.tabButton = tabButton
    
    -- Set our icon
    tabButton:SetNormalTexture(Deathless.Utils.Icons.SPELLBOOK_TAB)
    
    -- Set tooltip
    tabButton.tooltip = "Deathless - Talent Guide"
    
    -- Always keep unchecked
    tabButton:SetChecked(false)
    
    -- Override click behavior
    tabButton:SetScript("OnClick", function(self)
        self:SetChecked(false)
        Deathless.UI.Talents:ToggleClassTalents()
    end)
    
    -- Position below any existing right-side buttons
    self:UpdateTabPosition()
    tabButton:Show()
end

--- Find buttons on the right edge and position below the lowest one
function Deathless.UI.Talents:UpdateTabPosition()
    local tabButton = self.tabButton
    local talentFrame = PlayerTalentFrame
    if not tabButton or not talentFrame then return end
    
    local lowestButton = nil
    local lowestY = 0
    
    -- Scan children for right-edge buttons
    for _, child in pairs({talentFrame:GetChildren()}) do
        if child ~= tabButton and child:IsShown() and child:GetObjectType() == "CheckButton" then
            local numPoints = child:GetNumPoints()
            for i = 1, numPoints do
                local point, relativeTo, relativePoint = child:GetPoint(i)
                -- Check if anchored to top-right area
                if relativeTo == talentFrame and 
                   (relativePoint == "TOPRIGHT" or point == "TOPLEFT" and relativePoint == "TOPRIGHT") then
                    local _, _, _, _, y = child:GetPoint(i)
                    local bottom = (y or 0) - (child:GetHeight() or 0)
                    if bottom < lowestY then
                        lowestY = bottom
                        lowestButton = child
                    end
                end
            end
        end
    end
    
    tabButton:ClearAllPoints()
    if lowestButton then
        tabButton:SetPoint("TOPLEFT", lowestButton, "BOTTOMLEFT", 0, -17)
    else
        tabButton:SetPoint("TOPLEFT", talentFrame, "TOPRIGHT", 0, -36)
    end
end

--- Toggle the Deathless UI visibility, navigating to class talents when opening
function Deathless.UI.Talents:ToggleClassTalents()
    local mainFrame = Deathless.UI.Frame and Deathless.UI.Frame.mainFrame
    
    -- If visible, just hide it
    if mainFrame and mainFrame:IsShown() then
        Deathless.UI.Frame:Hide()
        return
    end
    
    -- Get player's class
    local _, classFile = UnitClass("player")
    if not classFile then
        Deathless.Utils.Chat.Print("Could not determine your class.")
        return
    end

    local classKey = classFile:lower()
    local classViewId = "class_" .. classKey
    local tabId = classKey .. "_talents"
    
    -- Show the Deathless frame
    if Deathless.UI.Frame then
        Deathless.UI.Frame:Show()
    end
    
    -- Navigate to the class view and force the Talents tab.
    if Deathless.UI.Navigation and Deathless.UI.Navigation.frame then
        local nav = Deathless.UI.Navigation.frame
        
        -- Expand classes
        nav.expandedSections["classes"] = true
        
        -- Expand the specific class section
        local classSection = "class_" .. classKey
        nav.expandedSections[classSection] = true
        
        -- Reposition and select
        Deathless.UI.Navigation:RepositionButtons()
        Deathless.UI.Navigation:Select(classViewId)

        if Deathless.UI.Content and Deathless.UI.Content.frame then
            local view = Deathless.UI.Content.frame.views and Deathless.UI.Content.frame.views[classViewId]
            if view and view.elements and view.elements.tabBar and view.elements.tabBar.containers[tabId] then
                view.elements.tabBar.SelectTab(tabId)
            end
        end
    end
end

-- Initialize when talent frame loads (it's loaded on demand)
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "Blizzard_TalentUI" then
        C_Timer.After(0.1, function()
            Deathless.UI.Talents:Initialize()
        end)
    end
end)
