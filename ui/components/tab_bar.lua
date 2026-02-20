local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

Deathless.UI.Components = Deathless.UI.Components or {}

--- Create a horizontal tab bar with content containers per tab.
--- Each tab gets its own content frame. Tabs can be lazily initialized via onInit.
---@param parent Frame The parent container frame
---@param tabs table Array of { id, label } tab definitions
---@param yOffset number Y offset from parent top for the tab bar
---@param onInit function|nil Optional callback(tabId, container) called on first tab selection
---@return table { SelectTab(id), GetActiveTab(), containers, bar }
function Deathless.UI.Components:CreateTabBar(parent, tabs, yOffset, onInit)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts

    local TAB_HEIGHT = 26
    local TAB_PADDING = 12
    local TAB_SPACING = 2

    local bar = CreateFrame("Frame", nil, parent)
    bar:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, yOffset)
    bar:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -20, yOffset)
    bar:SetHeight(TAB_HEIGHT)

    local borderLine = bar:CreateTexture(nil, "ARTWORK")
    borderLine:SetHeight(1)
    borderLine:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
    borderLine:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
    borderLine:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], 0.5)

    local tabButtons = {}
    local containers = {}
    local initialized = {}
    local activeTab = nil
    local contentTop = yOffset - TAB_HEIGHT - 2

    local function SelectTab(tabId)
        if activeTab == tabId then return end

        if activeTab then
            local prev = tabButtons[activeTab]
            if prev then
                prev.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
                prev.indicator:Hide()
            end
            if containers[activeTab] then
                containers[activeTab]:Hide()
            end
        end

        activeTab = tabId

        if not initialized[tabId] and onInit then
            onInit(tabId, containers[tabId])
            initialized[tabId] = true
        end

        local btn = tabButtons[tabId]
        if btn then
            btn.label:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
            btn.indicator:Show()
        end
        if containers[tabId] then
            containers[tabId]:Show()
        end
    end

    local xPos = 0
    for _, tab in ipairs(tabs) do
        local btn = CreateFrame("Button", nil, bar)
        btn:SetHeight(TAB_HEIGHT)

        btn.label = btn:CreateFontString(nil, "OVERLAY")
        btn.label:SetFont(Fonts.family, Fonts.subtitle, "")
        btn.label:SetText(tab.label)
        btn.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

        local textWidth = btn.label:GetStringWidth()
        local btnWidth = math.max(textWidth + TAB_PADDING * 2, 60)
        btn:SetWidth(btnWidth)
        btn:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", xPos, 0)
        btn.label:SetPoint("CENTER", btn, "CENTER", 0, 1)

        btn.indicator = btn:CreateTexture(nil, "OVERLAY")
        btn.indicator:SetHeight(2)
        btn.indicator:SetPoint("BOTTOMLEFT", btn, "BOTTOMLEFT", 0, 0)
        btn.indicator:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0, 0)
        btn.indicator:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 1)
        btn.indicator:Hide()

        local tabId = tab.id
        btn:SetScript("OnEnter", function(self)
            if activeTab ~= tabId then
                self.label:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
            end
        end)

        btn:SetScript("OnLeave", function(self)
            if activeTab ~= tabId then
                self.label:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
            end
        end)

        btn:SetScript("OnClick", function()
            SelectTab(tabId)
        end)

        tabButtons[tabId] = btn
        xPos = xPos + btnWidth + TAB_SPACING

        local container = CreateFrame("Frame", nil, parent)
        container:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, contentTop)
        container:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
        container:Hide()
        containers[tabId] = container
    end

    if tabs[1] then
        SelectTab(tabs[1].id)
    end

    return {
        SelectTab = SelectTab,
        GetActiveTab = function() return activeTab end,
        containers = containers,
        bar = bar,
    }
end
