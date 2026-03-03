local Deathless = Deathless

local CLASS_COLOR = Deathless.Constants.Colors.Class.mage

--- Create Mage Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "mage_talents",
    className = "Mage",
    classColor = CLASS_COLOR,
})
