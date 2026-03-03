local Deathless = Deathless

local CLASS_COLOR = Deathless.Constants.Colors.Class.paladin

--- Create Paladin Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "paladin_talents",
    className = "Paladin",
    classColor = CLASS_COLOR,
})
