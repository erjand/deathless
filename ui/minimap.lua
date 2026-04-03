local Deathless = Deathless

local ICON_TEXTURE = "Interface\\AddOns\\Deathless\\textures\\deathless-icon-transparent"

function Deathless.UI:InitializeMinimap()
    local LDB = LibStub("LibDataBroker-1.1")
    local LDBIcon = LibStub("LibDBIcon-1.0")

    local dataObj = LDB:NewDataObject(Deathless.Constants.Metadata.ADDON_NAME, {
        type = "launcher",
        icon = ICON_TEXTURE,
        OnClick = function(_, button)
            if button == "LeftButton" then
                if Deathless.UI.Frame then
                    if Deathless.UI.Frame.mainFrame and Deathless.UI.Frame.mainFrame:IsShown() then
                        Deathless.UI.Frame:Hide()
                    else
                        Deathless.UI.Frame:Show()
                    end
                end
            elseif button == "RightButton" then
                if Deathless.UI.MiniSummary then
                    Deathless.UI.MiniSummary:Toggle()
                end
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("Deathless", 0.4, 0.8, 0.4)
            tooltip:AddLine(" ")
            tooltip:AddLine("|cffffffffLeft-click|r to toggle main window")
            tooltip:AddLine("|cffffffffRight-click|r to toggle mini summary")
        end,
    })

    Deathless.config.minimap = Deathless.config.minimap or {}
    LDBIcon:Register(Deathless.Constants.Metadata.ADDON_NAME, dataObj, Deathless.config.minimap)
end
