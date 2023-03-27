local function empty_func() end

function SH_POINTSHOP:IsEmptyFunction(f)
	return f == nil or f == empty_func
end

/* Categories & Items */
local temp_catid
local translate_bone

function SH_POINTSHOP:LoadCategories()
	local _, fo = file.Find("pointshop/items/*", "LUA")
	for _, catid in pairs (fo) do
		temp_catid = catid

		local fi = file.Find("pointshop/items/" .. catid .. "/*", "LUA")
		for __, itmid in pairs (fi) do
			AddCSLuaFile("pointshop/items/" .. catid .. "/" .. itmid)
			include("pointshop/items/" .. catid .. "/" .. itmid)
		end

		temp_catid = nil
		CATEGORY = nil
		ITEM = nil
	end
end

function SH_POINTSHOP:RegisterCategory(category, id_override)
	local catid = id_override or temp_catid

	local cat = table.Copy(category)

	-- Setup overrides
	cat.Items = {}

	-- Setup defaults
	cat.Name = cat.Name or "UNNAMED CATEGORY"
	cat.Icon = cat.Icon or ""
	cat.IconMaterial = CLIENT and cat.Icon ~= "" and Material(cat.Icon, "")
	cat.Color = cat.Color or color_white
	cat.ColorDisplay = isstring(cat.Color) and self.Style[cat.Color] or cat.Color
	cat.Index = cat.Index or table.Count(self.Categories) + 1
	cat.ListType = cat.ListType or 0
	cat.ItemDimensions = cat.ItemDimensions or {width = 128, height = 128}
	cat.EquipLimit = cat.EquipLimit or 1
	cat.CanAccess = cat.CanAccess or empty_func
	cat.OnEnter = cat.OnEnter or empty_func
	cat.OnLeave = cat.OnLeave or empty_func

	self.Categories[catid] = cat

	for cls, itm in pairs (self.Items) do
		if (itm.Category == catid) then
			cat.Items[cls] = itm
		end
	end
end

function SH_POINTSHOP:RegisterItem(item, category_override)
	local itm = table.Copy(item)
	local old = self.Items[itm.ClassName]

	local src = debug.getinfo(2).short_src
	if (old and old.SourceFile and old.SourceFile ~= src) then
		error("Item with class name '" .. itm.ClassName .. "' already exists at path " .. old.SourceFile .. "!")
	end
	itm.SourceFile = src

	-- Setup overrides
	itm.Category = category_override or temp_catid

	if (!itm.Category) then
		if (old) then
			itm.Category = old.Category
		end
	end

	-- Setup defaults
	itm.IsCustom = itm.IsCustom or false
	itm.Name = itm.Name or "UNNAMED ITEM"
	itm.Description = itm.Description or ""
	itm.Model = Model(itm.Model or "")
	itm.Material = itm.Material or ""
	if (itm.AutoCameraAdjust ~= nil) then
		itm.AutoCameraAdjust = itm.AutoCameraAdjust
	else
		itm.AutoCameraAdjust = true
	end
	itm.IsPlayerModel = itm.IsPlayerModel or false
	itm.PointsCost = itm.PointsCost or 0
	itm.PremiumPointsCost = itm.PremiumPointsCost or 0
	if (itm.AddToInventory ~= nil) then
		itm.AddToInventory = itm.AddToInventory
	else
		itm.AddToInventory = true
	end
	itm.SelectSound = itm.SelectSound or ""
	itm.BuySound = itm.SelectSound or ""
	itm.SellSound = itm.SellSound or ""
	itm.EquipSound = itm.EquipSound or ""
	itm.UnequipSound = itm.UnequipSound or ""
	if (itm.Adjustable ~= nil) then
		itm.Adjustable = itm.Adjustable
	else
		itm.Adjustable = true
	end
	itm.CanBuy = itm.CanBuy or empty_func
	itm.CanSell = itm.CanSell or empty_func
	itm.CanEquip = itm.CanEquip or empty_func
	itm.CanUnequip = itm.CanUnequip or empty_func
	itm.OnBuy = itm.OnBuy or empty_func
	itm.OnSell = itm.OnSell or empty_func
	itm.OnEquip = itm.OnEquip or empty_func
	itm.OnUnequip = itm.OnUnequip or empty_func
	itm.PlayerSpawn = itm.PlayerSpawn or empty_func
	itm.PlayerDisconnected = itm.PlayerDisconnected or empty_func
	itm.Think = itm.Think or empty_func
	itm.PrePlayerDraw = itm.PrePlayerDraw or empty_func
	itm.PostPlayerDraw = itm.PostPlayerDraw or empty_func
	itm.CustomItemIcon = itm.CustomItemIcon or empty_func

	--
	itm.HasThink = itm.Think ~= empty_func
	itm.HasPrePlayerDraw = itm.PrePlayerDraw ~= empty_func
	itm.HasPostPlayerDraw = itm.PostPlayerDraw ~= empty_func
	itm.HasCustomItemIcon = itm.CustomItemIcon ~= empty_func

	-- Adapt SCK code here
	if (itm.WElements and table.Count(itm.WElements) > 0) then
		itm.DisplayData = {display = false, props = {}}

		for k, v in pairs (itm.WElements) do
			local t = {
				model = v.model,
				bone = v.bone,
				pos = v.pos,
				ang = v.angle,
				relative = v.rel,
				scale = v.size,
				material = v.material,
				color = v.color,
			}
			itm.DisplayData.props[k] = t
		end

		itm.WElements = nil
	end

	-- Adapt PAC3 code here
	local is_pac = false
	if (itm.PACData) and (itm.PACData.children or itm.PACData[1]) then
		is_pac = true
	
		local data = itm.PACData
		if (!data[1] and data.children) then
			data = {[1] = data}
		end
		itm.DisplayData = {display = true, is_pac = true, props = data}

		-- local function AdaptPAC(children, rel)
			-- if not (children and table.Count(children) > 0) then
				-- return end

			-- for id, child in pairs (children) do
				-- if (!child.self.Model) then
					-- continue end

				-- local name = rel .. "_" .. id

				-- local t = {
					-- model = child.self.Model,
					-- bone = translate_bone(child.self.Bone),
					-- pos = child.self.Position + child.self.PositionOffset,
					-- ang = child.self.Angles + child.self.AngleOffset,
					-- relative = rel,
					-- scale = child.self.Scale * child.self.Size,
					-- material = child.self.Material,
					-- color = Color(child.self.Color.r, child.self.Color.g, child.self.Color.b, child.self.Alpha * 255), -- 76561198006360138
					-- is_pac = true,
				-- }
				-- itm.DisplayData.props[name] = t

				-- AdaptPAC(child.children, name)
			-- end
		-- end

		-- AdaptPAC(itm.PACData.children, "")
	end

	-- Setup displaydata defaults
	if (itm.DisplayData and !itm.DisplayData.is_pac) then
		local t = {}
		for k, v in pairs (itm.DisplayData.props) do
			t[itm.ClassName .. "_" .. k] = v
		end

		itm.DisplayData.props = t

		for k, v in pairs (itm.DisplayData.props) do
			v.model = v.model or ""
			v.bone = v.bone or ""
			v.pos = v.pos or Vector(0, 0, 0)
			v.ang = v.ang or Angle(0, 0, 0)
			v.relative = v.relative or nil
			v.scale = v.scale or Vector(1, 1, 1)
			v.material = v.mat or v.material or ""
			v.color = v.color or Color(255, 255, 255)
			v.color.r = v.color.r / 255
			v.color.g = v.color.g / 255
			v.color.b = v.color.b / 255
			v.color.a = (v.color.a or 255) / 255

			if (v.relative) then
				if (v.relative == "") then
					v.relative = nil
				else
					v.relative = itm.ClassName .. "_" .. v.relative
				end
			end
		end

		itm.DisplayData.display = table.Count(t) > 0
	end

	self.Items[item.ClassName] = itm

	if (self.Categories[itm.Category]) then
		self.Categories[itm.Category].Items[item.ClassName] = self.Items[item.ClassName]
	end

	--if (is_pac) then
	--	timer.Simple(1, function()
	--		if (!pac or !pac.SimpleFetch) then
	--			self:Print("Ignoring PAC item '" .. itm.ClassName .. "' - PAC3 is not installed!")
	--		
	--			self.Categories[itm.Category].Items[item.ClassName] = nil
	--			self.Items[item.ClassName] = nil
	--		end
	--	end)
	--end
end

function SH_POINTSHOP:RemoveItemFromCategory(cat, class)
	local category = self.Categories[cat]
	if (!category or !category.Items[class]) then
		return end

	category.Items[class] = nil
end

-- UTIL functions
local bones = {
	["anim_attachment_head"] = "anim_attachment_head",
	["anim_attachment_lh"] = "anim_attachment_LH",
	["anim_attachment_rh"] = "anim_attachment_RH",
	["attach left hand"] = "ValveBiped.Anim_Attachment_LH",
	["attach right hand"] = "ValveBiped.Anim_Attachment_RH",
	["chest"] = "chest",
	["eyes"] = "eyes",
	["forward"] = "ValveBiped.forward",
	["head"] = "ValveBiped.Bip01_Head1",
	["left calf"] = "ValveBiped.Bip01_L_Calf",
	["left clavicle"] = "ValveBiped.Bip01_L_Clavicle",
	["left finger 0"] = "ValveBiped.Bip01_L_Finger0",
	["left finger 01"] = "ValveBiped.Bip01_L_Finger01",
	["left finger 02"] = "ValveBiped.Bip01_L_Finger02",
	["left finger 1"] = "ValveBiped.Bip01_L_Finger1",
	["left finger 11"] = "ValveBiped.Bip01_L_Finger11",
	["left finger 12"] = "ValveBiped.Bip01_L_Finger12",
	["left finger 2"] = "ValveBiped.Bip01_L_Finger2",
	["left finger 21"] = "ValveBiped.Bip01_L_Finger21",
	["left finger 22"] = "ValveBiped.Bip01_L_Finger22",
	["left foot"] = "ValveBiped.Bip01_L_Foot",
	["left forearm"] = "ValveBiped.Bip01_L_Forearm",
	["left hand"] = "ValveBiped.Bip01_L_Hand",
	["left thigh"] = "ValveBiped.Bip01_L_Thigh",
	["left toe"] = "ValveBiped.Bip01_L_Toe0",
	["left upperarm"] = "ValveBiped.Bip01_L_UpperArm",
	["mouth"] = "mouth",
	["neck"] = "ValveBiped.Bip01_Neck1",
	["pelvis"] = "ValveBiped.Bip01_Pelvis",
	["right calf"] = "ValveBiped.Bip01_R_Calf",
	["right clavicle"] = "ValveBiped.Bip01_R_Clavicle",
	["right finger 0"] = "ValveBiped.Bip01_R_Finger0",
	["right finger 01"] = "ValveBiped.Bip01_R_Finger01",
	["right finger 02"] = "ValveBiped.Bip01_R_Finger02",
	["right finger 1"] = "ValveBiped.Bip01_R_Finger1",
	["right finger 11"] = "ValveBiped.Bip01_R_Finger11",
	["right finger 12"] = "ValveBiped.Bip01_R_Finger12",
	["right finger 2"] = "ValveBiped.Bip01_R_Finger2",
	["right finger 21"] = "ValveBiped.Bip01_R_Finger21",
	["right finger 22"] = "ValveBiped.Bip01_R_Finger22",
	["right foot"] = "ValveBiped.Bip01_R_Foot",
	["right forearm"] = "ValveBiped.Bip01_R_Forearm",
	["right hand"] = "ValveBiped.Bip01_R_Hand",
	["right thigh"] = "ValveBiped.Bip01_R_Thigh",
	["right toe"] = "ValveBiped.Bip01_R_Toe0",
	["right upperarm"] = "ValveBiped.Bip01_R_UpperArm",
	["spine"] = "ValveBiped.Bip01_Spine",
	["spine 1"] = "ValveBiped.Bip01_Spine1",
	["spine 2"] = "ValveBiped.Bip01_Spine2",
	["spine 4"] = "ValveBiped.Bip01_Spine4",
}

translate_bone = function(bone)
	if bones[bone] then return bones[bone] end
	if not bone.lower then debug.Trace() return "" end
	bone = bone:lower()
	for key, val in pairs(bones) do
		if bone == val then
			return key
		end
	end

	return bone
end

/* Modules */

function SH_POINTSHOP:LoadModules()
	local _, fo = file.Find("pointshop/modules/*", "LUA")
	for _, modid in pairs (fo) do
		AddCSLuaFile("pointshop/modules/" .. modid .. "/_module.lua")
		include("pointshop/modules/" .. modid .. "/_module.lua")
	end
end

function SH_POINTSHOP:RegisterModule(mod)
	self.Modules[mod.ClassName] = mod
end

SH_POINTSHOP:LoadCategories()
SH_POINTSHOP:LoadModules()