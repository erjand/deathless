local Deathless = Deathless

local CLASS_COLOR = { 0.00, 0.44, 0.87 } -- Shaman blue

--- Create Shaman Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "shaman_talents",
    className = "Shaman",
    classColor = CLASS_COLOR,
})
