local Deathless = Deathless

-- MacroFrame is a WoW global loaded on demand with Blizzard_MacroUI

Deathless.UI.Macros = Deathless.UI.Macros or {}

--- Create the Deathless tab button on the macro frame
function Deathless.UI.Macros:Initialize()
    if self.initialized then return end

    -- Wait for MacroFrame to exist (loaded on demand)
    if not MacroFrame then
        return
    end

    self:SetupTab()
    self.initialized = true
end

--- Setup our tab on the macro frame
function Deathless.UI.Macros:SetupTab()
    local macroFrame = MacroFrame
    if not macroFrame then return end

    local tabButton = CreateFrame("CheckButton", "DeathlessMacroTab", macroFrame, "SpellBookSkillLineTabTemplate")
    self.tabButton = tabButton

    tabButton:SetNormalTexture(Deathless.Utils.Icons.ADDON)
    tabButton.tooltip = "Deathless - Macro Guide"
    tabButton:SetChecked(false)

    tabButton:SetScript("OnClick", function(button)
        button:SetChecked(false)
        Deathless.UI.Macros:ToggleClassMacros()
    end)

    self:UpdateTabPosition()
    tabButton:Show()
end

--- Find buttons on the right edge and position below the lowest one
function Deathless.UI.Macros:UpdateTabPosition()
    local tabButton = self.tabButton
    local macroFrame = MacroFrame
    if not tabButton or not macroFrame then return end

    local lowestButton = nil
    local lowestY = 0

    -- Scan children for right-edge buttons
    for _, child in pairs({ macroFrame:GetChildren() }) do
        if child ~= tabButton and child:IsShown() and child:GetObjectType() == "CheckButton" then
            local numPoints = child:GetNumPoints()
            for i = 1, numPoints do
                local point, relativeTo, relativePoint = child:GetPoint(i)
                if relativeTo == macroFrame and (relativePoint == "TOPRIGHT" or point == "TOPLEFT" and relativePoint == "TOPRIGHT") then
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
        tabButton:SetPoint("TOPLEFT", macroFrame, "TOPRIGHT", 0, -36)
    end
end

--- Toggle Deathless UI visibility, navigating to class macros when opening
function Deathless.UI.Macros:ToggleClassMacros()
    local mainFrame = Deathless.UI.Frame and Deathless.UI.Frame.mainFrame

    -- If visible, just hide it
    if mainFrame and mainFrame:IsShown() then
        Deathless.UI.Frame:Hide()
        return
    end

    if Deathless.UI.Navigation and Deathless.UI.Navigation.OpenPlayerClassTab then
        Deathless.UI.Navigation:OpenPlayerClassTab("macros")
    else
        Deathless.Utils.Chat.Print("UI not initialized.")
    end
end

-- Initialize when macro frame loads (it is loaded on demand)
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, _, addonName)
    if addonName == "Blizzard_MacroUI" then
        C_Timer.After(0.1, function()
            Deathless.UI.Macros:Initialize()
        end)
    end
end)
