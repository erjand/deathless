local Deathless = Deathless
local Strings = Deathless.Constants.Strings

--- Factory for Blizzard frame tab integrations (talents, macros, etc.).
--- Creates a module at Deathless.UI[config.key] with Initialize, SetupTab,
--- UpdateTabPosition, and Toggle methods, plus an ADDON_LOADED bootstrap.
---@param config table { key, globalFrame, tabGlobalName, tooltip, tabId, addonName, delay? }
---@return table module
function Deathless.UI.CreateBlizzardTabIntegration(config)
    local module = Deathless.UI[config.key] or {}
    Deathless.UI[config.key] = module

    function module:Initialize()
        if self.initialized then return end
        if not _G[config.globalFrame] then return end
        self:SetupTab()
        self.initialized = true
    end

    function module:SetupTab()
        local parentFrame = _G[config.globalFrame]
        if not parentFrame then return end

        local tabButton = CreateFrame("CheckButton", config.tabGlobalName, parentFrame, "SpellBookSkillLineTabTemplate")
        self.tabButton = tabButton

        tabButton:SetNormalTexture(Deathless.Utils.Icons.ADDON)
        tabButton.tooltip = config.tooltip
        tabButton:SetChecked(false)

        tabButton:SetScript("OnClick", function(btn)
            btn:SetChecked(false)
            module:Toggle()
        end)

        self:UpdateTabPosition()
        tabButton:Show()
    end

    --- Find CheckButtons on the right edge of the parent frame and position below the lowest one.
    function module:UpdateTabPosition()
        local tabButton = self.tabButton
        local parentFrame = _G[config.globalFrame]
        if not tabButton or not parentFrame then return end

        local lowestButton = nil
        local lowestY = 0

        for _, child in pairs({ parentFrame:GetChildren() }) do
            if child ~= tabButton and child:IsShown() and child:GetObjectType() == "CheckButton" then
                local numPoints = child:GetNumPoints()
                for i = 1, numPoints do
                    local point, relativeTo, relativePoint = child:GetPoint(i)
                    if relativeTo == parentFrame and
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
            tabButton:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", 0, -36)
        end
    end

    function module:Toggle()
        local mainFrame = Deathless.UI.Frame and Deathless.UI.Frame.mainFrame
        if mainFrame and mainFrame:IsShown() then
            Deathless.UI.Frame:Hide()
            return
        end

        if Deathless.UI.Navigation and Deathless.UI.Navigation.OpenPlayerClassTab then
            Deathless.UI.Navigation:OpenPlayerClassTab(config.tabId)
        else
            Deathless.Utils.Chat.Print(Strings.UI_NOT_INITIALIZED)
        end
    end

    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(_, _, addonName)
        if addonName == config.addonName then
            C_Timer.After(config.delay or 0.1, function()
                module:Initialize()
            end)
        end
    end)

    return module
end
