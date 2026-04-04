-- Minimap button

local Deathless = Deathless
local Strings = Deathless.Constants.Strings

local ICON_TEXTURE = "Interface\\AddOns\\Deathless\\textures\\deathless-icon-transparent"

function Deathless.UI:InitializeMinimapButton()
    local LDB = LibStub("LibDataBroker-1.1")
    local LDBIcon = LibStub("LibDBIcon-1.0")

    local dataObj = LDB:GetDataObjectByName(Deathless.Constants.Metadata.ADDON_NAME) or LDB:NewDataObject(Deathless.Constants.Metadata.ADDON_NAME, {
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
            tooltip:AddLine(Deathless.Constants.Metadata.ADDON_NAME, 0.4, 0.8, 0.4)
            tooltip:AddLine(" ")
            tooltip:AddLine(Strings.MINIMAP_TOOLTIP_LINE_LEFT)
            tooltip:AddLine(Strings.MINIMAP_TOOLTIP_LINE_RIGHT)
        end,
    })

    if not dataObj then return end

    Deathless.config.minimap = Deathless.config.minimap or {}
    LDBIcon:Register(Deathless.Constants.Metadata.ADDON_NAME, dataObj, Deathless.config.minimap)
end
