local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

local QUOTE_ROTATION_SECONDS = 10

--- Build a shuffled order of indices that never repeats the previous quote.
---@param count number Total number of quotes
---@param lastIndex number|nil Index shown most recently
---@return table Shuffled index list
local function ShuffleOrder(count, lastIndex)
    local order = {}
    for i = 1, count do
        order[i] = i
    end
    for i = count, 2, -1 do
        local j = math.random(1, i)
        order[i], order[j] = order[j], order[i]
    end
    if lastIndex and order[1] == lastIndex then
        order[1], order[count] = order[count], order[1]
    end
    return order
end

--- Home view content
Deathless.UI.Views:Register("home", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts

    local title, subtitle = Utils:CreateCenteredHeader(container, "Deathless", "Hardcore Classic WoW Companion")

    local desc = container:CreateFontString(nil, "OVERLAY")
    desc:SetFont(Fonts.family, Fonts.subtitle, "")
    desc:SetPoint("TOP", subtitle, "BOTTOM", 0, -24)
    desc:SetWidth(container:GetWidth() - 60)
    desc:SetJustifyH("CENTER")
    desc:SetText("Select a content area from the left to get started.")
    desc:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)

    local versionLabel = container:CreateFontString(nil, "OVERLAY")
    versionLabel:SetFont(Fonts.family, Fonts.small, "")
    versionLabel:SetPoint("BOTTOMRIGHT", container, "BOTTOMRIGHT", -12, 10)
    versionLabel:SetText(Deathless.Constants.Metadata.VERSION)
    versionLabel:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)

    -- Decorative divider between description and quote
    local dividerWidth = 120
    local dividerLeft = container:CreateTexture(nil, "ARTWORK")
    dividerLeft:SetHeight(1)
    dividerLeft:SetWidth(dividerWidth)
    dividerLeft:SetPoint("RIGHT", container, "CENTER", -22, 0)
    dividerLeft:SetPoint("TOP", desc, "BOTTOM", 0, -23)
    dividerLeft:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.3)

    local dividerIcon = container:CreateTexture(nil, "OVERLAY")
    dividerIcon:SetSize(32, 32)
    dividerIcon:SetPoint("CENTER", container, "CENTER", 0, 0)
    dividerIcon:SetPoint("TOP", desc, "BOTTOM", 0, -8)
    dividerIcon:SetTexture("Interface\\AddOns\\Deathless\\textures\\deathless-icon-transparent")
    -- dividerIcon:SetAlpha(0.5)

    local dividerRight = container:CreateTexture(nil, "ARTWORK")
    dividerRight:SetHeight(1)
    dividerRight:SetWidth(dividerWidth)
    dividerRight:SetPoint("LEFT", container, "CENTER", 22, 0)
    dividerRight:SetPoint("TOP", desc, "BOTTOM", 0, -23)
    dividerRight:SetColorTexture(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.3)

    -- Quote carousel
    local quoteFrame = CreateFrame("Frame", nil, container)
    quoteFrame:SetSize(container:GetWidth() - 80, 60)
    quoteFrame:SetPoint("TOP", desc, "BOTTOM", 0, -51)

    local quoteText = quoteFrame:CreateFontString(nil, "OVERLAY")
    quoteText:SetFont(Fonts.family, Fonts.header, "")
    quoteText:SetPoint("TOP", quoteFrame, "TOP", 0, 0)
    quoteText:SetWidth(quoteFrame:GetWidth())
    quoteText:SetJustifyH("CENTER")
    quoteText:SetTextColor(Colors.accent[1], Colors.accent[2], Colors.accent[3], 0.7)

    local quoteAuthor = quoteFrame:CreateFontString(nil, "OVERLAY")
    quoteAuthor:SetFont(Fonts.family, Fonts.body, "")
    quoteAuthor:SetPoint("TOP", quoteText, "BOTTOM", 0, -8)
    quoteAuthor:SetJustifyH("CENTER")
    quoteAuthor:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 0.7)

    -- Fade animation
    local fadeOut = quoteFrame:CreateAnimationGroup()
    local alphaOut = fadeOut:CreateAnimation("Alpha")
    alphaOut:SetFromAlpha(1)
    alphaOut:SetToAlpha(0)
    alphaOut:SetDuration(0.5)
    alphaOut:SetSmoothing("OUT")
    fadeOut:SetScript("OnFinished", function()
        quoteFrame:SetAlpha(0)
    end)

    local fadeIn = quoteFrame:CreateAnimationGroup()
    local alphaIn = fadeIn:CreateAnimation("Alpha")
    alphaIn:SetFromAlpha(0)
    alphaIn:SetToAlpha(1)
    alphaIn:SetDuration(0.5)
    alphaIn:SetSmoothing("IN")
    fadeIn:SetScript("OnFinished", function()
        quoteFrame:SetAlpha(1)
    end)

    -- Carousel state
    local quotes = Deathless.Data.Quotes
    local order = ShuffleOrder(#quotes, nil)
    local pos = 0
    local ticker = nil

    local function ShowQuote(quote)
        quoteText:SetText("\"" .. quote.text .. "\"")
        quoteAuthor:SetText("- " .. quote.author)
    end

    local function AdvanceQuote()
        pos = pos + 1
        if pos > #order then
            order = ShuffleOrder(#quotes, order[#order])
            pos = 1
        end
        local nextQuote = quotes[order[pos]]

        fadeOut:Play()
        C_Timer.After(0.5, function()
            ShowQuote(nextQuote)
            fadeIn:Play()
        end)
    end

    local function StartCarousel()
        pos = 1
        order = ShuffleOrder(#quotes, nil)
        ShowQuote(quotes[order[pos]])
        quoteFrame:SetAlpha(1)
        if not ticker then
            ticker = C_Timer.NewTicker(QUOTE_ROTATION_SECONDS, AdvanceQuote)
        end
    end

    local function StopCarousel()
        if ticker then
            ticker:Cancel()
            ticker = nil
        end
    end

    container:SetScript("OnShow", StartCarousel)
    container:SetScript("OnHide", StopCarousel)

    -- Kick off immediately since home is the default view
    StartCarousel()

    return { title = title, subtitle = subtitle, desc = desc }
end)

