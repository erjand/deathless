local Deathless = Deathless

local CLASS_COLOR = Deathless.Constants.Colors.Class.warrior

--- Create Warrior Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "warrior_talents",
    className = "Warrior",
    classColor = CLASS_COLOR,
})
