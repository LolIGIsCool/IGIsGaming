/**
* General configuration
**/

-- Usergroups considered to be admins.
-- They'll be able to manage various parts of the Pointshop ingame.
SH_POINTSHOP.AdminUsergroups = {
	["superadmin"] = true,
	["Community Developer"] = true,
	["Senior Developer"] = true,
	["owner"] = true,

}

local IGClientPatronList = {};

net.Receive("VANILLA_PATRON_CLIENT",function()
	IGClientPatronList = net.ReadTable();
end)

-- The title of the Pointshop.
SH_POINTSHOP.Title = "IG | IMPERIAL RP STORE"

-- How to style SH Pointshop notifications on the player's screen?
-- 0: No notifications (at all!)
-- 1: Lounge-type notifications, a bar sliding in from the bottom
-- 2: GMod notifications, like when you undo an object in Sandbox
-- 3: Chat messages
SH_POINTSHOP.NotificationType = 2

--  The model to preview cosmetics on in item icons.
SH_POINTSHOP.PreviewModel = Model("models/player/breen.mdl")

-- Use libgmodstore?
-- This library is intended to help provide information about updates and support should you run into issues.
-- DISCLAIMER: libgmodstore is NOT maintained by me (Shendow), I am NOT responsible if it causes errors or other issues.
--			   If it does, then disable the option below. You don't need it for the script to work - it only makes life easier.
-- More information here: https://www.gmodstore.com/community/threads/4465-libgmodstore/post-31807#post-3180776561198006360138
SH_POINTSHOP.UseLibGModStore = false

-- Use Steam Workshop for the custom content?
-- If false, custom content will be downloaded through FastDL.
SH_POINTSHOP.UseWorkshop = true

/**
* Points configuration
**/

-- Default amount of Standard Points a player gets when joining for the first time.
SH_POINTSHOP.DefaultStandardPoints = 0

-- Default amount of Premium Points a player gets when joining for the first time.
SH_POINTSHOP.DefaultPremiumPoints = 0

-- Function which determines the max amount of Standard Points a player can have.
-- Return nothing or 0 for no limit.
SH_POINTSHOP.MaxStandardPoints = function(ply)
	return 0
end

-- Function which determines the max amount of Premium Points a player can have.
-- Return nothing or 0 for no limit.
SH_POINTSHOP.MaxPremiumPoints = function(ply)
	return 0
end

/**
* Shop configuration
**/

-- Price multipliers depending on the player's usergroup.
-- Do NOT remove the "default" line! This is the fallback value in case the player's usergroup is not found!
SH_POINTSHOP.PriceMultiplierGroups = {
	["superadmin"] = 1,
	["default"] = 1,
}

-- Global price scale applied to every item.
-- By default returns the player's price multiplier by usergroup.
SH_POINTSHOP.PriceMultiplier = function(ply)
	//check if user is patron
	for k, v in pairs(IGClientPatronList) do
		if v.id == ply:SteamID() then return 0.9 end
	end

	return SH_POINTSHOP.PriceMultiplierGroups[ply:GetUserGroup()] or SH_POINTSHOP.PriceMultiplierGroups.default
end

-- Sell multipliers depending on the player's usergroup.
-- Do NOT remove the "default" line! This is the fallback value in case the player's usergroup is not found!
SH_POINTSHOP.SellMultiplierGroups = {
    ["superadmin"] = 1,
    ["Senior Developer"] = 1,
    ["Senior Admin"] = 1,
    ["Benefactor"] = 0.85,
    ["Developer"] = 0.7,
    ["Donator"] = 0.7,
    ["Tier 1"] = 0.7,
    ["Tier 2"] = 0.7,
    ["Tier 3"] = 0.7,
    ["admin"] = 0.7,
    ["Senior Moderator"] = 0.7,
    ["Moderator"] = 0.7,
    ["Junior Moderator"] = 0.7,
    ["Trial Moderator"] = 0.7,
    ["Lead Event Master"] = 0.7,
    ["Senior Event Master"] = 0.7,
    ["Event Master"] = 0.7,
    ["Trial Event Master"] = 0.7,
    ["Junior Event Master"] = 0.7,
     ["default"] = 0.5,
	--["default"] = 1,
}
-- in order 1, 0.8, 0.8, 0.5
-- Function which determines the Points multiplier applied when selling an item.
-- Should be around between 0 and 1. Anything outside results in unexpected behaviour.
-- By default returns the player's sell multiplier by usergroup.
SH_POINTSHOP.SellMultiplier = function(ply)
	print(ply:GetUserGroup())

	//check if user is patron
	for k, v in pairs(IGClientPatronList) do
		if v.id == ply:SteamID() then return 0.85 end
	end

	return SH_POINTSHOP.SellMultiplierGroups[ply:GetUserGroup()] or SH_POINTSHOP.SellMultiplierGroups.default
end

/**
* Inventory configuration
**/

-- Inventory sizes depending on the player's usergroup.
-- Do NOT remove the "default" line! This is the fallback value in case the player's usergroup is not found!
SH_POINTSHOP.MaxInventorySizeGroups = {
	["admin"] = 1024,
	["superadmin"] = 1024,
	["vip"] = 1024,

	["default"] = 512,
}

-- Function which determines how many items a player can have in their inventory.
-- By default returns the player's inventory size by usergroup.
SH_POINTSHOP.MaxInventorySize = function(ply)
	return SH_POINTSHOP.MaxInventorySizeGroups[ply:GetUserGroup()] or SH_POINTSHOP.MaxInventorySizeGroups.default
end

/**
* Accessories configuration
**/

-- Should accessories appear on ragdolls?
SH_POINTSHOP.DisplayOnRagdolls = true

/**
* Adjusting
*
* What is adjusting?
* Adjusting is moving, rotating or scaling an accessory slightly in case it doesn't or barely fits a player model.
**/

-- Function which determines whether the player is allowed to adjust their accessories.
-- Return false to disallow. Anything else is allow.
SH_POINTSHOP.AdjustCheck = function(ply)
	return true
end

-- Function which returns a factor determining how much a player can adjust their accessory.
-- The smaller the value, the less the player will be able to adjust their accessory.
-- The higher, the (potentially) further they can move, rotate or scale it from their body, resulting in hilarious consequences.
-- Anything below or equal to 0 will produce unexpected results, so don't do that.
SH_POINTSHOP.AdjustFactor = function(ply)
	-- Admins can move, scale and rotate their accessories really high.
	if (ply:IsAdmin()) then
		return 100
	end

	return 5
end

-- How much translating, rotating and scaling are affected by adjustment.
-- Don't touch unless you've got a good reason to.
SH_POINTSHOP.AdjustFactorIndividual = {
	translate = 0.5,
	rotate = 1,
	scale = 0.01,
}

/**
* Command configuration
**/

-- Chat commands which can open the Pointshop
-- ! are automatically replaced by / and inputs are made lowercase for convenience.
SH_POINTSHOP.MenuCommands = {
	["/ps"] = true,
	["/pointshop"] = true,
	["/shop"] = true,
}

-- Key to open the Pointshop.
-- You can find available keys here: http://wiki.garrysmod.com/page/Enums/BUTTON_CODE
SH_POINTSHOP.MenuKey = KEY_F3

/**
* Advanced configuration
* Edit at your own risk!
**/

SH_POINTSHOP.DataFolderName = "sh_pointshop"

-- Time in seconds before adjustment changes are sent to the server and broadcasted to other players.
SH_POINTSHOP.AdjustSendTime = 0.5

/**
* Theme configuration
**/

-- Standard Points icon. Should be 32x32
SH_POINTSHOP.StandardPointsIcon = Material("shenesis/pointshop/scrap.png", "")

-- Premium Points icon. Should be 32x32
SH_POINTSHOP.PremiumPointsIcon = Material("shenesis/pointshop/credits.png", "")

-- Width multiplier of the main window.
SH_POINTSHOP.WidthMultiplier = 1.1

-- Height multiplier of the main window.
SH_POINTSHOP.HeightMultiplier = 1.1

-- Font to use for normal text throughout the interface.
SH_POINTSHOP.Font = "Circular Std Medium"

-- Font to use for bold text throughout the interface.
SH_POINTSHOP.FontBold = "Circular Std Bold"

-- Color sheet. Only modify if you know what you're doing.
SH_POINTSHOP.Style = {
	header = Color(2, 115, 255),
	bg = Color(52, 52, 52, 255),
	inbg = Color(39, 39, 39, 255),

	close_hover = Color(255, 0, 0),
	hover = Color(255, 255, 255, 10, 100),
	hover2 = Color(255, 255, 255, 5, 255),

	text = Color(255, 255, 255, 255),
	text_down = Color(0, 0, 0),
	textentry = Color(103, 56, 76),
	menu = Color(127, 140, 141),

	success = Color(200, 60, 70),
	failure = Color(231, 76, 60),
}

-- Enable blur background behind all Lounge windows?
-- "bg", "inbg" and "header" should be transparent for better effect.
SH_POINTSHOP.BlurredBackgrounds = false

/**
* Language configuration
**/

-- Various strings used throughout the script.
-- Available languages: english, french
-- To add your own language, see the reports/language folder
-- You may need to restart the map after changing the language!
SH_POINTSHOP.LanguageName = "english"
