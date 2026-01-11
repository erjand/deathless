local Deathless = Deathless

local CLASS_COLOR = { 1.00, 1.00, 1.00 } -- Priest white

--- Create Priest Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "priest_talents",
    className = "Priest",
    classColor = CLASS_COLOR,
})
