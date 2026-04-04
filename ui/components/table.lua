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
-- Outer border (optional frame around entire table body)
-- ---------------------------------------------------------------------------

--- Draw a 1px rectangular border around a region.
---@param parent Frame
---@param opts table|nil { xLeft?, xRight?, yTop?, yBottom?, alpha? }
---@return table borders { top, bottom, left, right } Texture references
function Table:CreateOuterBorder(parent, opts)
    opts = opts or {}
    local Colors = Deathless.UI.Views.Utils:GetColors()
    local RowStyle = Deathless.Constants.Colors.UI.Row
    local alpha = opts.alpha or RowStyle.columnDividerAlpha
    local xL = opts.xLeft or 0
    local xR = opts.xRight or 0
    local yT = opts.yTop or 0
    local yB = opts.yBottom or 0

    local function MakeLine()
        local t = parent:CreateTexture(nil, "ARTWORK")
        t:SetColorTexture(Colors.border[1], Colors.border[2], Colors.border[3], alpha)
        return t
    end

    local top = MakeLine()
    top:SetHeight(1)
    top:SetPoint("TOPLEFT", parent, "TOPLEFT", xL, yT)
    top:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xR, yT)

    local bottom = MakeLine()
    bottom:SetHeight(1)
    bottom:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", xL, yB)
    bottom:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", xR, yB)

    local left = MakeLine()
    left:SetWidth(1)
    left:SetPoint("TOPLEFT", parent, "TOPLEFT", xL, yT)
    left:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", xL, yB)

    local right = MakeLine()
    right:SetWidth(1)
    right:SetPoint("TOPRIGHT", parent, "TOPRIGHT", xR, yT)
    right:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", xR, yB)

    return { top = top, bottom = bottom, left = left, right = right }
end
