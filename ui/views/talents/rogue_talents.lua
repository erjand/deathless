local Deathless = Deathless

local CLASS_COLOR = { 1.00, 0.96, 0.41 } -- Rogue yellow

--- Create Rogue Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "rogue_talents",
    className = "Rogue",
    classColor = CLASS_COLOR,
})
