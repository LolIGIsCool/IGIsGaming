-- This item template allows you to create a wearable that shows 3D2D text on the player's model.

local ps = SH_POINTSHOP
local MODULE = MODULE or ps.Modules.itemmanager
if (!MODULE) then
	return end

-- Set up available positions for text wearables here.
ps.TextWearablePositions = {
	["head"] = {bone = "ValveBiped.Bip01_Head1", offset = Vector(0, 0, 24), eyeangles = true},
	["face"] = {bone = "ValveBiped.Bip01_Head1", pos = Vector(3, -6, 0), ang = Angle(90, 0, 90)},
	["behind"] = {bone = "ValveBiped.Bip01_Spine", pos = Vector(-5.5, -5.5, 0), ang = Angle(90, 0, 90)},
}

function ps:DrawTextWearable(ply, item, itm)
	local data = self.TextWearablePositions[item.WearablePosition]
	if (!data) then
		return end

	local bone = ply:LookupBone(data.bone)
	if (!bone) then
		return end

	local mat = ply:GetBoneMatrix(bone)
	if (!mat) then
		return end

	local pos, ang = mat:GetTranslation(), mat:GetAngles()

	local op, oa = data.pos, data.ang
	if (op or oa) then
		op = op or Vector(0, 0, 0)
		oa = oa or Angle(0, 0, 0)

		pos, ang = LocalToWorld(op, oa, pos, ang)
	end

	if (data.offset) then
		pos = pos + data.offset
	end

	if (data.eyeangles) then
		local ea = EyeAngles()
		ea:RotateAroundAxis(ea:Right(), 90)
		ea:RotateAroundAxis(ea:Up(), -90)
		ang = ea
	end

	local col = item.WearableColor
	if (item.WearableRainbow) then
		if (itm.m_iHue) then
			itm.m_iHue = (itm.m_iHue + FrameTime() * math.min(720, itm.m_iRate)) % 360
			col = HSVToColor(itm.m_iHue, 1, 1)
		else
			itm.m_iHue = 0
			itm.m_iRate = 72
		end
	end

	cam.Start3D2D(pos, ang, item.WearableScale)
		draw.SimpleText(item.WearableText, "SH_POINTSHOP.3D", 0, 0, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

-- Set up the actual template here.
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
	{id = "description", name = "im_description", type = TYPE_STRING, separator = true},

	{id = "wearabletext", name = "Wearable Text", type = TYPE_STRING},
	{id = "wearablepos", name = "Wearable Position", type = "select", vars = function()
		local t = {}
		for k in pairs (ps.TextWearablePositions) do
			table.insert(t, k)
		end

		return t
	end},
	{id = "wearablecolor", name = "Wearable Color", type = "color"},
	{id = "wearablerainbow", name = "Wearable Rainbow Color?", type = TYPE_BOOL},
	{id = "wearablescale", name = "Wearable Scale (0-1)", type = TYPE_NUMBER, default = 0.05, min = 0.001, max = 1, decimals = 3, separator = true},

	{id = "price_std", name = "im_price_std", type = TYPE_NUMBER, min = 0, max = 2^32-1},
	{id = "price_prm", name = "im_price_prm", type = TYPE_NUMBER, min = 0, max = 2^32-1},
}

TEMPLATE.Editable = {
	category = "Category",
	displayname = "Name",
	description = "Description",
	wearabletext = "WearableText",
	wearablepos = "WearablePosition",
	wearablecolor = "WearableColor",
	wearablerainbow = "WearableRainbow",
	wearablescale = "WearableScale",
	price_std = "PointsCost",
	price_prm = "PremiumPointsCost",
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

ITEM.WearableText = "{wearabletext}"
ITEM.WearablePosition = "{wearablepos}"
ITEM.WearableColor = string.ToColor("{wearablecolor}")
ITEM.WearableRainbow = {wearablerainbow}
ITEM.WearableScale = {wearablescale}

ITEM.PointsCost = {price_std}
ITEM.PremiumPointsCost = {price_prm}

ITEM.AddToInventory = true
ITEM.Adjustable = false

// AUTO GENERATED: You can add your custom functions here.
// Refer to the documentation: https://github.com/Shendow/SH-Pointshop-Docs/wiki

SH_POINTSHOP:RegisterItem(ITEM, "{category}")
]]

TEMPLATE.BaseItemVars = {
	OnModified = function(self)
		self.WearableColor = isstring(self.WearableColor) and string.ToColor(self.WearableColor) or self.WearableColor
		self.WearableRainbow = tostring(self.WearableRainbow) == "true"
	end,
	PostPlayerDraw = function(self, ply, itm)
		SH_POINTSHOP:DrawTextWearable(ply, SH_POINTSHOP.Items[self.ClassName], itm)
	end,
	CustomItemIcon = function(self, parent)
		local lbl = ps:QuickLabel(self.WearableText, "{prefix}Large", self.WearableColor, parent)
		lbl:Dock(FILL)
		lbl:SetContentAlignment(5)

		return lbl
	end,
}

MODULE.Templates["item_textwearable"] = TEMPLATE