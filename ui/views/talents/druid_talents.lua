local Deathless = Deathless

local CLASS_COLOR = { 1.00, 0.49, 0.04 } -- Druid orange

--- Create Druid Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "druid_talents",
    className = "Druid",
    classColor = CLASS_COLOR,
})
