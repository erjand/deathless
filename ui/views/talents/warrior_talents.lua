local Deathless = Deathless

local CLASS_COLOR = { 0.78, 0.61, 0.43 } -- Warrior tan

--- Create Warrior Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "warrior_talents",
    className = "Warrior",
    classColor = CLASS_COLOR,
})
