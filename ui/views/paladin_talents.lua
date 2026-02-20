local Deathless = Deathless

local CLASS_COLOR = { 0.96, 0.55, 0.73 } -- Paladin pink

--- Create Paladin Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "paladin_talents",
    className = "Paladin",
    classColor = CLASS_COLOR,
})
