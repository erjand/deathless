local Deathless = Deathless

local CLASS_COLOR = Deathless.Constants.Colors.Class.shaman

--- Create Shaman Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "shaman_talents",
    className = "Shaman",
    classColor = CLASS_COLOR,
})
