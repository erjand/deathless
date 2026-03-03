local Deathless = Deathless

local CLASS_COLOR = Deathless.Constants.Colors.Class.hunter

--- Create Hunter Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "hunter_talents",
    className = "Hunter",
    classColor = CLASS_COLOR,
})
