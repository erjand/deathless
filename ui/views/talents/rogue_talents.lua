local Deathless = Deathless

local CLASS_COLOR = Deathless.Constants.Colors.Class.rogue

--- Create Rogue Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "rogue_talents",
    className = "Rogue",
    classColor = CLASS_COLOR,
})
