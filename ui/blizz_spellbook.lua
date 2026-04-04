local Deathless = Deathless
local NavIds = Deathless.Constants.NavigationIds
local Strings = Deathless.Constants.Strings

Deathless.UI.Spellbook = Deathless.UI.Spellbook or {}

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
    tabButton.tooltip = Strings.BLIZZ_TAB_TOOLTIP_ABILITY
    
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
    
    if Deathless.UI.Navigation and Deathless.UI.Navigation.OpenPlayerClassTab then
        Deathless.UI.Navigation:OpenPlayerClassTab(NavIds.ABILITIES, { notifyMissingTab = true })
    else
        Deathless.Utils.Chat.Print(Strings.UI_NOT_INITIALIZED)
    end
end

-- Initialize when UI is ready
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == Deathless.addonName then
        C_Timer.After(0.2, function()
            Deathless.UI.Spellbook:Initialize()
        end)
    end
end)

