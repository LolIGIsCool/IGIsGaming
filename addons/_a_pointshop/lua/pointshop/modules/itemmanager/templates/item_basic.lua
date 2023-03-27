-- This is a basic item template which allows you to easily create item in-games by modifying preset values

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
	{id = "model", name = "im_model", type = TYPE_STRING, default = "models/error.mdl", separator = true},

	{id = "price_std", name = "im_price_std", type = TYPE_NUMBER, min = 0, max = 2^32-1, decimals = 0},
	{id = "price_prm", name = "im_price_prm", type = TYPE_NUMBER, min = 0, max = 2^32-1, decimals = 0},
	{id = "addtoinventory", name = "im_addtoinventory", type = TYPE_BOOL, default = true, separator = true},

	{id = "camerafocus", name = "im_camerafocus", type = "select", vars = {"head", "torso", "back", "back_lower", "left_arm", "right_arm", "left_leg", "right_leg"}},
	{id = "adjustable", name = "im_adjustable", type = TYPE_BOOL, default = true, separator = true},

	{id = "props_sck", name = "im_sckdata", type = TYPE_STRING},
	{id = "props_pac", name = "im_pacdata", type = TYPE_STRING},
}

TEMPLATE.Editable = {
	category = "Category",
	displayname = "Name",
	description = "Description",
	model = "Model",
	price_std = "PointsCost",
	price_prm = "PremiumPointsCost",
	addtoinventory = "AddToInventory",
	camerafocus = "FocusPart",
	adjustable = "Adjustable",
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

-- The processor function is only called on the client!
TEMPLATE.Processors = {
	props_sck = function(inpt)
		-- Attempt to load SCK data
		if (inpt and inpt ~= nil and inpt:Trim() ~= "") then
			if (!glon) then
				return false, "im_sck_must_be_installed"
			end

			local f = file.Read("swep_construction_kit/" .. inpt .. ".txt", "DATA")
			if (f) then
				local succ, new_preset = pcall(glon.decode, f)
				if (!succ or !new_preset or !new_preset.w_models or table.Count(new_preset.w_models) == 0) then
					return false, "failed to load"
				end

				return MODULE:Serialize(new_preset.w_models, true)
			else
				return false, "im_missing_or_invalid_info"
			end
		end

		return "nil"
	end,
	props_pac = function(inpt)
		-- Attempt to load PAC data
		if (inpt and inpt ~= nil and inpt:Trim() ~= "") then
			local f = file.Read("pac3/" .. inpt .. ".txt", "DATA")
			if (f) then
				return f
			else
				return false, "im_missing_or_invalid_info"
			end
		end

		return "nil"
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
ITEM.FocusPart = "{camerafocus}"
ITEM.Adjustable = {adjustable}

ITEM.WElements = {Processor:props_sck}
ITEM.PACData = {{Processor:props_pac}}

// AUTO GENERATED: You can add your custom functions here.
// Refer to the documentation: https://github.com/Shendow/SH-Pointshop-Docs/wiki

SH_POINTSHOP:RegisterItem(ITEM, "{category}")
]]

MODULE.Templates["item_basic"] = TEMPLATE