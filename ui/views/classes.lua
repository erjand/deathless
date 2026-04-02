local Deathless = Deathless
local Utils = Deathless.UI.Views.Utils

local CLASS_COLORS = Deathless.Constants.Colors.Class

--- Classes overview view (multi-class parent)
Deathless.UI.Views:Register("classes", function(container)
    local Colors = Utils:GetColors()
    local Fonts = Deathless.UI.Fonts
    
    local title, subtitle, separator = Utils:CreateHeader(container, "Classes")
    
    local content = container:CreateFontString(nil, "OVERLAY")
    content:SetFont(Fonts.family, Fonts.subtitle, "")
    content:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -12)
    content:SetWidth(container:GetWidth() - 40)
    content:SetJustifyH("LEFT")
    content:SetText("Select a class from the menu to view abilities, macros, and talent builds.\n\nYou can choose which classes are displayed from the Options menu.")
    content:SetTextColor(Colors.text[1], Colors.text[2], Colors.text[3], 1)
    
    return { title = title, subtitle = subtitle, content = content }
end)

--- Build tab definitions for a class
---@param className string Lowercase class name
---@param displayName string Display name (e.g., "Rogue")
---@return table Array of { id, label } tab definitions
local function GetClassTabs(className, displayName)
    local tabs = {
        { id = className .. "_abilities", label = "Abilities" },
        { id = className .. "_macros", label = "Macros" },
        { id = className .. "_stats", label = "Stats" },
        { id = className .. "_talents", label = "Talents" },
    }
    return tabs
end

--- Factory: create a tabbed class view with class tabs
---@param className string Lowercase class name
---@param displayName string Display name
---@return function View creator
local function CreateTabbedClassView(className, displayName)
    return function(container)
        local Colors = Utils:GetColors()
        local classColor = CLASS_COLORS[className] or Colors.accent
        
        local title, subtitle, separator = Utils:CreateHeader(
            container, displayName, "", classColor
        )
        
        local tabs = GetClassTabs(className, displayName)
        
        local tabBar = Deathless.UI.Components:CreateTabBar(container, tabs, -72, function(tabId, tabContainer)
            local creator = Deathless.UI.Views[tabId]
            if creator then
                tabContainer.elements = creator(tabContainer, { embedded = true })
            end
        end)
        
        return {
            title = title,
            subtitle = subtitle,
            tabBar = tabBar,
            Refresh = function()
                for _, tab in ipairs(tabs) do
                    local c = tabBar.containers[tab.id]
                    if c and c.elements and c.elements.Refresh then
                        c.elements.Refresh()
                    end
                end
            end,
        }
    end
end

-- Register tabbed class views
Deathless.UI.Views:Register("class_druid", CreateTabbedClassView("druid", "Druid"))
Deathless.UI.Views:Register("class_hunter", CreateTabbedClassView("hunter", "Hunter"))
Deathless.UI.Views:Register("class_mage", CreateTabbedClassView("mage", "Mage"))
Deathless.UI.Views:Register("class_paladin", CreateTabbedClassView("paladin", "Paladin"))
Deathless.UI.Views:Register("class_priest", CreateTabbedClassView("priest", "Priest"))
Deathless.UI.Views:Register("class_rogue", CreateTabbedClassView("rogue", "Rogue"))
Deathless.UI.Views:Register("class_shaman", CreateTabbedClassView("shaman", "Shaman"))
Deathless.UI.Views:Register("class_warlock", CreateTabbedClassView("warlock", "Warlock"))
Deathless.UI.Views:Register("class_warrior", CreateTabbedClassView("warrior", "Warrior"))

-- Export class colors for other modules
Deathless.UI.Views.ClassColors = CLASS_COLORS
