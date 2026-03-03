local Deathless = Deathless

local CLASS_COLOR = Deathless.Constants.Colors.Class.warlock

--- Create Warlock Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "warlock_talents",
    className = "Warlock",
    classColor = CLASS_COLOR,
})
