local Deathless = Deathless

Deathless.UI.Spellbook = Deathless.UI.Spellbook or {}

-- Map class filenames to navigation IDs
local CLASS_NAV_IDS = {
    WARRIOR = "warrior_abilities",
    MAGE = "mage_abilities",
    PRIEST = "priest_abilities",
    ROGUE = "rogue_abilities",
    -- Add more as abilities are implemented
    DRUID = "class_druid",
    HUNTER = "class_hunter",
    PALADIN = "class_paladin",
    SHAMAN = "class_shaman",
    WARLOCK = "class_warlock",
}

-- Use one of the reserved spellbook tab slots (last available)
local DEATHLESS_TAB_INDEX = MAX_SKILLLINE_TABS

--- Create the Deathless tab button on the spellbook
function Deathless.UI.Spellbook:Initialize()
    if self.initialized then return end
    
    -- Wait for SpellBookFrame to exist
    if not SpellBookFrame then
        C_Timer.After(0.5, function()
            self:Initialize()
        end)
        return
    end
    
    self:SetupTab()
    self.initialized = true
end

--- Setup our tab by hooking into the spellbook's tab system
function Deathless.UI.Spellbook:SetupTab()
    local tabButton = _G["SpellBookSkillLineTab" .. DEATHLESS_TAB_INDEX]
    if not tabButton then
        Deathless.Utils.Chat.Print("Could not find spellbook tab slot")
        return
    end
    
    self.tabButton = tabButton
    
    -- Hook into UpdateSkillLineTabs to show our tab
    hooksecurefunc(SpellBookFrame, "UpdateSkillLineTabs", function()
        self:UpdateTab()
    end)
    
    -- Also hook the legacy function if it exists
    if SpellBookFrame_UpdateSkillLineTabs then
        hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", function()
            self:UpdateTab()
        end)
    end
    
    -- Initial update
    self:UpdateTab()
end

--- Update our tab's appearance and state
function Deathless.UI.Spellbook:UpdateTab()
    local tabButton = self.tabButton
    if not tabButton then return end
    
    -- Set our icon (gray/white skull)
    tabButton:SetNormalTexture(Deathless.Utils.Icons.ADDON)
    
    -- Set tooltip
    tabButton.tooltip = "Deathless - Ability Guide"
    
    -- Position after the last real tab
    local lastRealTab = nil
    for i = 1, DEATHLESS_TAB_INDEX - 1 do
        local tab = _G["SpellBookSkillLineTab" .. i]
        if tab and tab:IsShown() then
            lastRealTab = tab
        end
    end
    
    if lastRealTab then
        tabButton:ClearAllPoints()
        tabButton:SetPoint("TOPLEFT", lastRealTab, "BOTTOMLEFT", 0, -17)
    end
    
    -- Show the tab
    tabButton:Show()
    
    -- Always keep unchecked (we don't switch spellbook pages)
    tabButton:SetChecked(false)
    
    -- Override click behavior
    tabButton:SetScript("OnClick", function(self)
        self:SetChecked(false)
        Deathless.UI.Spellbook:ToggleClassAbilities()
    end)
end

--- Toggle the Deathless UI visibility, navigating to class abilities when opening
function Deathless.UI.Spellbook:ToggleClassAbilities()
    local mainFrame = Deathless.UI.Frame and Deathless.UI.Frame.mainFrame
    
    -- If visible, just hide it
    if mainFrame and mainFrame:IsShown() then
        Deathless.UI.Frame:Hide()
        return
    end
    
    -- Get player's class
    local _, classFile = UnitClass("player")
    local navId = CLASS_NAV_IDS[classFile]
    
    if not navId then
        Deathless.Utils.Chat.Print("Abilities guide not yet available for " .. classFile)
        return
    end
    
    -- Show the Deathless frame
    if Deathless.UI.Frame then
        Deathless.UI.Frame:Show()
    end
    
    -- Navigate to the class abilities
    -- First expand the classes section, then the specific class
    if Deathless.UI.Navigation and Deathless.UI.Navigation.frame then
        local nav = Deathless.UI.Navigation.frame
        
        -- Expand classes
        nav.expandedSections["classes"] = true
        
        -- Expand the specific class section (e.g., "class_warrior")
        local classSection = "class_" .. classFile:lower()
        nav.expandedSections[classSection] = true
        
        -- Reposition and select
        Deathless.UI.Navigation:RepositionButtons()
        Deathless.UI.Navigation:Select(navId)
    end
end

-- Initialize when UI is ready
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "deathless" then
        C_Timer.After(0.2, function()
            Deathless.UI.Spellbook:Initialize()
        end)
    end
end)

