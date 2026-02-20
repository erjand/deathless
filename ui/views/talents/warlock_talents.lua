local Deathless = Deathless

local CLASS_COLOR = { 0.58, 0.51, 0.79 } -- Warlock purple

--- Create Warlock Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "warlock_talents",
    className = "Warlock",
    classColor = CLASS_COLOR,
})
