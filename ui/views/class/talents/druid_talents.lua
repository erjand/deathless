local Deathless = Deathless

local CLASS_COLOR = Deathless.Constants.Colors.Class.druid

--- Create Druid Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "druid_talents",
    className = "Druid",
    classColor = CLASS_COLOR,
})
