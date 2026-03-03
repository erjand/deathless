local Deathless = Deathless

local CLASS_COLOR = Deathless.Constants.Colors.Class.priest

--- Create Priest Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "priest_talents",
    className = "Priest",
    classColor = CLASS_COLOR,
})
