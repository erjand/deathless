--- Reusable table styling utilities: static headers, border lines, column dividers, row hover.
--- Composable toolkit — views use whichever pieces they need alongside existing
--- sortable headers (`Utils:CreateSortableHeader`) and row striping (`ApplyStripedRowBackground`).
local Deathless = Deathless

Deathless.UI.Components = Deathless.UI.Components or {}
Deathless.UI.Components.Table = {}

local Table = Deathless.UI.Components.Table

-- ---------------------------------------------------------------------------
-- Static (non-sortable) column headers
-- ---------------------------------------------------------------------------

--- Create a row of static column header labels.
--- For sortable headers, continue using `Utils:CreateSortableHeader`.
---@param parent Frame Typically the scrollChild
---@param columns table Array of { label, x, width?, justify? }
---@param opts table|nil { yOffset?, xBase?, font?, fontSize? }
---@return FontString[] headers, number nextYOffset (20px below yOffset)
function Table:CreateStaticHeaders(parent, columns, opts)
    opts = opts or {}
    local Colors = Deathless.UI.Views.Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    local font = opts.font or Fonts.icons
    local fontSize = opts.fontSize or Fonts.small
    local xBase = opts.xBase or 0
    local yOffset = opts.yOffset or 0

    local headers = {}
    for _, col in ipairs(columns) do
        local fs = parent:CreateFontString(nil, "OVERLAY")
        fs:SetFont(font, fontSize, "")
        fs:SetPoint("TOPLEFT", parent, "TOPLEFT", xBase + col.x, yOffset)
        if col.width then
            fs:SetWidth(col.width)
        end
        fs:SetJustifyH(col.justify or "LEFT")
        fs:SetText(col.label)
        fs:SetTextColor(Colors.textDim[1], Colors.textDim[2], Colors.textDim[3], 1)
        table.insert(headers, fs)
    end

    return headers, yOffset - 20
end

-- ---------------------------------------------------------------------------
-- Header background bar
-- ---------------------------------------------------------------------------

--- Create a subtle background bar behind the header row.
--- Helps visually separate the header from content above.
---@param parent Frame
---@param opts table|nil { yOffset?, xLeft?, xRight?, height?, alpha? }
---@return Texture bg
function Table:CreateHeaderBackground(parent, opts)
    opts = opts or {}
    local Colors = Deathless.UI.Views.Utils:GetColors()
    local alpha = opts.alpha or 0.3
    local height = opts.height or 20

    local bg = parent:CreateTexture(nil, "BACKGROUND")
    bg:SetHeight(height)
    bg:SetPoint("TOPLEFT", parent, "TOPLEFT", opts.xLeft or 0, opts.yOffset or 0)
    bg:SetPoint("TOPRIGHT", parent, "TOPRIGHT", opts.xRight or 0, opts.yOffset or 0)
    bg:SetColorTexture(Colors.bgLight[1], Colors.bgLight[2], Colors.bgLight[3], alpha)

    return bg
end

-- ---------------------------------------------------------------------------
-- Header separator line
-- ---------------------------------------------------------------------------

--- Create a 1px horizontal line under a header row.
---@param parent Frame
---@param opts table|nil { yOffset?, xLeft?, xRight?, alpha? }
---@return Texture line
function Table:CreateHeaderBorder(parent, opts)
    opts = opts or {}
    local Colors = Deathless.UI.Views.Utils:GetColors()
    local RowStyle = Deathless.Constants.Colors.UI.Row
    local alpha = opts.alpha or RowStyle.headerBorderAlpha

    local line = parent:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetPoint("TOPLEFT", parent, "TOPLEFT", opts.xLeft or 0, opts.yOffset or 0)
    line:SetPoint("TOPRIGHT", parent, "TOPRIGHT", opts.xRight or 0, opts.yOffset or 0)
    line:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], alpha)

    return line
end

-- ---------------------------------------------------------------------------
-- Column dividers (vertical lines between header columns)
-- ---------------------------------------------------------------------------

--- Create thin vertical divider lines at given x positions.
---@param parent Frame
---@param xPositions number[] Array of x offsets for each divider
---@param opts table|nil { yTop?, height?, xBase?, alpha? }
---@return Texture[] dividers
function Table:CreateColumnDividers(parent, xPositions, opts)
    opts = opts or {}
    local Colors = Deathless.UI.Views.Utils:GetColors()
    local RowStyle = Deathless.Constants.Colors.UI.Row
    local alpha = opts.alpha or RowStyle.columnDividerAlpha
    local yTop = opts.yTop or 0
    local height = opts.height or 16
    local xBase = opts.xBase or 0

    local dividers = {}
    for _, x in ipairs(xPositions) do
        local div = parent:CreateTexture(nil, "ARTWORK")
        div:SetWidth(1)
        div:SetHeight(height)
        div:SetPoint("TOPLEFT", parent, "TOPLEFT", xBase + x, yTop)
        div:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], alpha)
        div._tableDivX = xBase + x ---@diagnostic disable-line: inject-field
        table.insert(dividers, div)
    end

    return dividers
end

-- ---------------------------------------------------------------------------
-- Row hover highlight
-- ---------------------------------------------------------------------------

--- Apply a standardized hover highlight to a row.
--- Uses the WoW HIGHLIGHT texture layer which auto-shows on mouseover for Button frames.
--- For plain Frame rows, the view should call this and also ensure `EnableMouse(true)`.
---@param row table Frame or Button
---@param opts table|nil { color?, alpha? }
function Table:ApplyRowHover(row, opts)
    if row._tableHover then return end
    opts = opts or {}

    local Colors = Deathless.UI.Views.Utils:GetColors()
    local RowStyle = Deathless.Constants.Colors.UI.Row
    local alpha = opts.alpha or RowStyle.hoverAlpha
    local color = opts.color or {
        Colors.bgLight[1] + 0.08,
        Colors.bgLight[2] + 0.08,
        Colors.bgLight[3] + 0.08,
    }

    local highlight = row:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetAllPoints()
    highlight:SetColorTexture(color[1], color[2], color[3], alpha)
    row._tableHover = highlight
end

-- ---------------------------------------------------------------------------
-- Table border group (reusable 4-edge border)
-- ---------------------------------------------------------------------------

--- Create a group of 4 border-line textures (hidden by default).
--- Use `PositionBorders` to show and position them each refresh.
---@param parent Frame
---@param opts table|nil { alpha?, createTex? } createTex is an optional factory for pooled textures
---@return table borders { top, bottom, left, right }
function Table:CreateBorderGroup(parent, opts)
    opts = opts or {}
    local Colors = Deathless.UI.Views.Utils:GetColors()
    local RowStyle = Deathless.Constants.Colors.UI.Row
    local alpha = opts.alpha or RowStyle.headerBorderAlpha

    local function MakeLine()
        local t = opts.createTex and opts.createTex() or parent:CreateTexture(nil, "ARTWORK")
        t:SetDrawLayer("ARTWORK")
        t:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], alpha)
        t:Hide()
        return t
    end

    local top = MakeLine()
    top:SetHeight(1)
    local bottom = MakeLine()
    bottom:SetHeight(1)
    local left = MakeLine()
    left:SetWidth(1)
    local right = MakeLine()
    right:SetWidth(1)

    return { top = top, bottom = bottom, left = left, right = right }
end

--- Position and show a border group around a table region.
---@param borders table { top, bottom, left, right } from CreateBorderGroup
---@param parent Frame The anchor parent (typically scrollChild)
---@param yTop number Top edge Y offset
---@param yBottom number Bottom edge Y offset
---@param xLeft number Left edge X offset
---@param xRight number Right edge X offset (negative)
function Table:PositionBorders(borders, parent, yTop, yBottom, xLeft, xRight)
    borders.top:ClearAllPoints()
    borders.top:SetPoint("TOPLEFT", parent, "TOPLEFT", xLeft, yTop)
    borders.top:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xRight, yTop)
    borders.top:Show()

    borders.bottom:ClearAllPoints()
    borders.bottom:SetPoint("TOPLEFT", parent, "TOPLEFT", xLeft, yBottom)
    borders.bottom:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xRight, yBottom)
    borders.bottom:Show()

    borders.left:ClearAllPoints()
    borders.left:SetPoint("TOPLEFT", parent, "TOPLEFT", xLeft, yTop)
    borders.left:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", xLeft, yBottom)
    borders.left:Show()

    borders.right:ClearAllPoints()
    borders.right:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xRight, yTop)
    borders.right:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", xRight, yBottom)
    borders.right:Show()
end

--- Hide all borders in a group.
---@param borders table { top, bottom, left, right }
function Table:HideBorders(borders)
    for _, tex in pairs(borders) do tex:Hide() end
end
