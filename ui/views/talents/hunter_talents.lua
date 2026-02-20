local Deathless = Deathless

local CLASS_COLOR = { 0.67, 0.83, 0.45 } -- Hunter green

--- Create Hunter Talents view using the template
Deathless.UI.Views.TalentsTemplate:Create({
    viewName = "hunter_talents",
    className = "Hunter",
    classColor = CLASS_COLOR,
})
