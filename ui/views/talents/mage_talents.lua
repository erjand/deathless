local Deathless = Deathless

local CLASS_COLOR = { 0.41, 0.80, 0.94 } -- Mage blue

--- Create Mage Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "mage_talents",
    className = "Mage",
    classColor = CLASS_COLOR,
})
