local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

-- Class color definitions (matching WoW class colors)
local CLASS_COLORS = {
    druid = { 1.00, 0.49, 0.04 },
    hunter = { 0.67, 0.83, 0.45 },
    mage = { 0.25, 0.78, 0.92 },
    paladin = { 0.96, 0.55, 0.73 },
    priest = { 1.00, 1.00, 1.00 },
    rogue = { 1.00, 0.96, 0.41 },
    shaman = { 0.00, 0.44, 0.87 },
    warlock = { 0.53, 0.53, 0.93 },
    warrior = { 0.78, 0.61, 0.43 },
}

--- Classes overview view
Deathless.UI.Views:Register("classes", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Classes", "Class guides and tips")
    
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont(Fonts.family, Fonts.subtitle, "")
    content:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -12)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Select a class from the sub-menu to view guides, talent builds, and hardcore survival strategies.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end)

--- Factory function to create class view content
---@param className string The class name (lowercase)
---@param displayName string The display name for the class
---@return function View creator function
local function CreateClassViewCreator(className, displayName)
    return function(container)
        local Colors = Utils:GetColors()
        local Fonts = Deathless.UI.Fonts
        local classColor = CLASS_COLORS[className] or Colors.accent
        
        local title, subtitle, separator = Utils:CreateHeader(container, displayName, "Hardcore " .. displayName .. " Guide", classColor)
        
        local content = container:CreateFontString(nil, "OVERLAY")
        content:SetFont(Fonts.family, Fonts.subtitle, "")
        content:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -12)
        content:SetWidth(container:GetWidth() - 40)
        content:SetJustifyH("LEFT")
        content:SetText("Talent builds, leveling strategies, and survival tips for " .. displayName .. " in Hardcore Classic WoW.")
        content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
        
        return { title = title, subtitle = subtitle, content = content }
    end
end

-- Register individual class views
Deathless.UI.Views:Register("class_druid", CreateClassViewCreator("druid", "Druid"))
Deathless.UI.Views:Register("class_hunter", CreateClassViewCreator("hunter", "Hunter"))
Deathless.UI.Views:Register("class_mage", CreateClassViewCreator("mage", "Mage"))
Deathless.UI.Views:Register("class_paladin", CreateClassViewCreator("paladin", "Paladin"))
Deathless.UI.Views:Register("class_priest", CreateClassViewCreator("priest", "Priest"))
Deathless.UI.Views:Register("class_rogue", CreateClassViewCreator("rogue", "Rogue"))
Deathless.UI.Views:Register("class_shaman", CreateClassViewCreator("shaman", "Shaman"))
Deathless.UI.Views:Register("class_warlock", CreateClassViewCreator("warlock", "Warlock"))
Deathless.UI.Views:Register("class_warrior", CreateClassViewCreator("warrior", "Warrior"))

-- Export class colors for other modules
Deathless.UI.Views.ClassColors = CLASS_COLORS

