CATEGORY = {}

-- The name of the category. If possible it is replaced by a translated string with the same name.
CATEGORY.Name = "Starter Weapons"

-- The description when the category is hovered.
CATEGORY.Description = "Weapons for newbies."

-- The tab's icon. Relative to materials/. Has to be 32x32 with the actual image being 24x24 (4px padding on every side)
CATEGORY.Icon = "shenesis/pointshop/gun.png"

-- The color of the tab name. Can either be a Color(R, G, B) or a string corresponding to a Style color
CATEGORY.Color = "text"

-- The position of the tab in the list. The lower the number, the higher the position.
CATEGORY.Index = 3

-- How should items in this category be listed?
-- 0: Tile layout
-- 1: List layout
CATEGORY.ListType = 0

-- The size of an item in this category.
-- In pixels.
CATEGORY.ItemDimensions = {width = 128, height = 128}

-- How many items of this category can be equipped at once?
-- Set to 0 for infinite.
CATEGORY.EquipLimit = 1

/*
	Custom functions related to the item.
	Unless specified otherwise, they are SHARED.
*/

-- SHARED function.
-- If you want to restrict this category to specific players or usergroups, you can use this function.
-- If it returns anything other than false, the player can access this category.
-- Will also block purchases if false is returned on the server.
function CATEGORY:CanAccess(ply)
	return true
end

-- CLIENT function.
-- Called when the local player enters this category's tab in the Shop.
function CATEGORY:OnEnter(body)
end

-- CLIENT function.
-- Called when the local player exits this category's tab in the Shop.
function CATEGORY:OnLeave(body)
end

-- Registers the category with the "hats" class name.
SH_POINTSHOP:RegisterCategory(CATEGORY, "starter")