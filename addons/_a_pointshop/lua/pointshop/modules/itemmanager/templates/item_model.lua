-- This is a basic item template which allows you to easily create a model in-game by modifying preset values

local ps = SH_POINTSHOP
local MODULE = MODULE or ps.Modules.itemmanager
if (!MODULE) then
	return end

local TEMPLATE = {}

TEMPLATE.Variables = {
	{id = "classname", name = "im_classname", type = TYPE_STRING},
	{id = "category", name = "im_category", type = "select", vars = function()
		local t = {}
		for k in SortedPairsByMemberValue (ps.Categories, "Index") do
			table.insert(t, k)
		end

		return t
	end},
	{id = "displayname", name = "im_displayname", type = TYPE_STRING},
	{id = "description", name = "im_description", type = TYPE_STRING},
	{id = "model", name = "im_model", type = TYPE_STRING, default = "models/error.mdl", playermodel = true, separator = true},

	{id = "price_std", name = "im_price_std", type = TYPE_NUMBER, min = 0, max = 2^32-1, decimals = 0},
	{id = "price_prm", name = "im_price_prm", type = TYPE_NUMBER, min = 0, max = 2^32-1, decimals = 0},
	{id = "addtoinventory", name = "im_addtoinventory", type = TYPE_BOOL, default = true, separator = true},
}

TEMPLATE.Editable = {
	category = "Category",
	displayname = "Name",
	description = "Description",
	model = "Model",
	price_std = "PointsCost",
	price_prm = "PremiumPointsCost",
	addtoinventory = "AddToInventory",
}

TEMPLATE.Validators = {
	classname = function(inpt)
		inpt = inpt:lower():Trim()
		return inpt ~= "" and string.find(inpt, "[^a-z0-9_]") == nil and ps.Items[inpt] == nil, nil, inpt
	end,
	category = function(inpt)
		inpt = inpt:lower():Trim()
		return ps.Categories[inpt] ~= nil, nil, inpt
	end,
	displayname = function(inpt)
		inpt = inpt:lower():Trim()
		return inpt ~= ""
	end,
	model = function(inpt)
		inpt = inpt:lower()
		return inpt:Trim() ~= "", nil, inpt
	end,
	price_std = function(inpt)
		inpt = tonumber(inpt) or 0
		return inpt >= 0, nil, inpt
	end,
	price_prm = function(inpt)
		inpt = tonumber(inpt) or 0
		return inpt >= 0, nil, inpt
	end,
}

TEMPLATE.Code = [[
ITEM = {}

// Do NOT touch these!
// They are necessary for the Item Manager module to work properly!
ITEM.IsCustom = true
ITEM.TemplateName = "{TemplateName}"
ITEM.Category = "{category}"

ITEM.ClassName = "{classname}"
ITEM.Name = "{displayname}"
ITEM.Description = "{description}"
ITEM.Model = "{model}"

ITEM.PointsCost = {price_std}
ITEM.PremiumPointsCost = {price_prm}

ITEM.AddToInventory = {addtoinventory}
ITEM.AutoCameraAdjust = true
ITEM.IsPlayerModel = true

// AUTO GENERATED: You can add your custom functions here.
// Refer to the documentation: https://github.com/Shendow/SH-Pointshop-Docs/wiki

local function TTT_IsRoundActive()
	-- let's NOT allow players to change models during a round!
	if (ROLE_TRAITOR and GAMEMODE.round_state == ROUND_ACTIVE) then
		return true
	end

	return false
end

function ITEM:OnEquip(ply, itm)
	if (TTT_IsRoundActive()) then
		return end

	ply:SetModel(self.Model)
	ply:SH_SetupHands()
end

function ITEM:OnUnequip(ply, itm)
	if (TTT_IsRoundActive()) then
		return end

	hook.Run("PlayerSetModel", ply)
	ply:SetupHands()
end

function ITEM:PlayerSetModel(ply, itm)
	timer.Simple(0, function()
		if (!IsValid(ply)) then
			return end

		ply:SetModel(self.Model)
		ply:SH_SetupHands()
	end)
end

SH_POINTSHOP:RegisterItem(ITEM, "{category}")
]]

MODULE.Templates["item_model"] = TEMPLATE