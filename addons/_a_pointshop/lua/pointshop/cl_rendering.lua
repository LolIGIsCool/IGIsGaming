-- TODO nep optimizatioans

local render_distance = CreateClientConVar("sh_pointshop_rendering_distance", "0", true, false):GetInt()
local disable_players = CreateClientConVar("sh_pointshop_rendering_players_disable", "0", true, false):GetBool()
local disable_ragdolls = CreateClientConVar("sh_pointshop_rendering_ragdolls_disable", "0", true, false):GetBool()

render_distance = render_distance * render_distance
local has_render_distance = render_distance > 0

cvars.AddChangeCallback("sh_pointshop_rendering_distance", function(c, o, n)
	render_distance = tonumber(n) or 0
	render_distance = render_distance * render_distance
	has_render_distance = render_distance > 0
end)
cvars.AddChangeCallback("sh_pointshop_rendering_players_disable", function(c, o, n)
	disable_players = tobool(n)
end)
cvars.AddChangeCallback("sh_pointshop_rendering_ragdolls_disable", function(c, o, n)
	disable_ragdolls = tobool(n)
end)

local IsValid = IsValid

local active_ragdolls = {}
local valid_models = {}

local function GetBoneOrientation(basetab, tab, ply)
	local r = tab.relative
	if (r) then
		local v = basetab[r]
		if (!v) then
			return end

		local p, a = GetBoneOrientation(basetab, v, ply)
		if (!p) then
			return end

		local pos, ang = Vector(p), Angle(a)
		local op, oa = v.pos, v.ang

		-- if (v.is_pac) then
			-- pos, ang = LocalToWorld(op, oa, pos, ang)
		-- else
			pos = pos + ang:Forward() * op[1] + ang:Right() * op[2] + ang:Up() * op[3]
			ang:RotateAroundAxis(ang:Up(), oa.y)
			ang:RotateAroundAxis(ang:Right(), oa.p)
			ang:RotateAroundAxis(ang:Forward(), oa.r)
		-- end

		return pos, ang
	else
		local b = tab.bone
		local bone = ply:LookupBone(b)
		if (!bone) then
			return end

		local m = ply:GetBoneMatrix(bone)
		if (m) then
			return m:GetTranslation(), m:GetAngles()
		end
	end
end

function SH_POINTSHOP:RemoveClientsideModels(ent)
	if not (ent.SH_MODELS) then
		return end

	for k, v in pairs (ent.SH_MODELS) do
		SafeRemoveEntity(v)
	end
	ent.SH_MODELS = {}
end

function SH_POINTSHOP:CreateFakeModel(ent, id, mdlname)
	ent.SH_MODELS = ent.SH_MODELS or {}

	if (IsValid(ent.SH_MODELS[id])) then
		return ent.SH_MODELS[id]
	else
		local v = valid_models[mdlname]
		if (v == nil) then
			valid_models[mdlname] = file.Exists(mdlname, "GAME")
		end
		if (v == false) then
			mdlname = "models/error.mdl"
		end

		local mdl = ClientsideModel(mdlname, RENDERGROUP_TRANSLUCENT)
		mdl:SetNoDraw(true)
		mdl:DrawShadow(false)
		mdl:DestroyShadow()
		mdl:SetNotSolid(true)
		ent:CallOnRemove("remove_" .. id, function()
			SafeRemoveEntity(mdl)
		end)

		ent.SH_MODELS[id] = mdl

		return mdl
	end
end

function SH_POINTSHOP:RemoveFakeModel(ent, id)
	ent.SH_MODELS = ent.SH_MODELS or {}

	SafeRemoveEntity(ent.SH_MODELS[id])
	ent.SH_MODELS[id] = nil
end

local function VectorOffset(pos, offset, ang)
	pos:Set(pos + ang:Forward() * offset.x + ang:Right() * offset.y + ang:Up() * offset.z)
end

local function AngleOffset(ang, offset)
	ang:RotateAroundAxis(ang:Up(), offset.y)
	ang:RotateAroundAxis(ang:Right(), offset.p)
	ang:RotateAroundAxis(ang:Forward(), offset.r)
end

local p, a
local pos, ang = Vector(), Angle()
function SH_POINTSHOP:RenderDisplayData(ent, ply, id, mdlname, data, alldata, class)
	local mdl = self:CreateFakeModel(ent, id, mdlname)
	if (!IsValid(mdl)) then
		return end

	local bone = ent:LookupBone(data.bone)
	if (!bone) then
		return end

	p, a = GetBoneOrientation(alldata, data, ent)
	if (!p) then
		return end

	pos:Set(p)
	ang:Set(a)

	local matr = Matrix()
	matr:SetScale(data.scale)

	-- Apply adjustments if any 76561198006360147
	if (ply and ply.SH_POINTSHOP_ADJUSTS) then
		local adjust = ply.SH_POINTSHOP_ADJUSTS[class]
		if (adjust) then
			VectorOffset(pos, adjust[1], ang)
			AngleOffset(ang, adjust[2])
			matr:Scale(adjust[3])
		end
	end

	local op, oa = data.pos, data.ang

	-- if (data.is_pac) then
		-- pos, ang = LocalToWorld(op, oa, pos, ang)
	-- else
		pos = pos + ang:Forward() * op[1] + ang:Right() * op[2] + ang:Up() * op[3]
		ang:RotateAroundAxis(ang:Up(), oa.y)
		ang:RotateAroundAxis(ang:Right(), oa.p)
		ang:RotateAroundAxis(ang:Forward(), oa.r)
	-- end

	mdl:SetRenderOrigin(pos)
	mdl:SetRenderAngles(ang)
	mdl:SetAngles(ang)

	mdl:EnableMatrix("RenderMultiply", matr)

	mdl:SetMaterial(data.material)

	local c = data.color
	render.SetColorModulation(c.r, c.g, c.b)
		render.SetBlend(c.a)
			mdl:DrawModel()
		render.SetBlend(1)
	render.SetColorModulation(1, 1, 1)
end

function SH_POINTSHOP:RebuildEquippedModels(ent, ply)
	ply = ply or ent
	self:RemoveClientsideModels(ent)
--[[
	if (pac and ply:IsPlayer()) then
		pac.RemovePartsFromUniqueID(ply:UniqueID())
	end
]]
	local tbl = {}
	for _, eq in pairs (ply:SH_GetEquipped()) do
		local item = self.Items[eq.class]
		if (!item or !item.DisplayData or !item.DisplayData.display) then
			continue end

		local id = eq.class .. eq.id
		local dat = table.Copy(item.DisplayData)
		dat.Model = item.Model
		dat.ItemDefinition = item
		dat.ItemInstance = eq

		if (dat.is_pac) then
			for id, outfit in pairs (dat.props) do
				-- Disable sounds and proxies for CSModels
				if (!ent:IsPlayer()) then
					outfit = self:SilentPACOutfit(outfit)
				end
			
				local part = pac.CreatePart(outfit.self.ClassName, ent)
				part:SetTable(outfit)
			end
		end
		
		tbl[id] = dat
	end

	ent.SH_EQUIPPED = tbl
end

function SH_POINTSHOP:RebuildDrawCalls(ply)
	local t = {}
	for _, eq in pairs (ply:SH_GetEquipped()) do
		local item = self.Items[eq.class]
		if (!item) or (!item.HasPrePlayerDraw and !item.HasPostPlayerDraw) then
			continue end

		table.insert(t, {item, eq})
	end

	ply.SH_DRAW_CALLS = t
end

function SH_POINTSHOP:RenderEquippedModels(ent, ply)
	if not (ent.SH_EQUIPPED) then
		return end

	ply = ply or ent

	for id, dat in pairs (ent.SH_EQUIPPED) do
		local class = dat.ItemInstance.class
		if (dat.is_pac) then
			continue end

		for k, v in pairs (dat.props) do
			self:RenderDisplayData(ent, ply, k, v.model, v, dat.props, class)
		end
	end

	if (!ply.SH_DRAW_CALLS) then
		return end

	for _, d in ipairs (ply.SH_DRAW_CALLS) do
		d[1]:PostPlayerDraw(ent, d)
	end
end

function SH_POINTSHOP:InitEntityEquipped(ent)
	if (self.DisplayOnRagdolls and ent:GetClass() == "class C_HL2MPRagdoll") then
		for _, v in ipairs (player.GetAll()) do
			if (v:GetRagdollEntity() == ent) then
				active_ragdolls[v] = ent
				self:RebuildEquippedModels(ent, v)
				break
			end
		end
	end
end

function SH_POINTSHOP:SilentPACOutfit(outfit)
	local c = table.Copy(outfit)

	local function rec(d)
		if (!d.children) then
			return end

		for i = #d.children, 1, -1 do
			local c = d.children[i]
			if (c.self.ClassName == "proxy" or c.self.ClassName == "sound") then
				table.remove(d.children, i)
			else
				rec(c)
			end
		end
	end
	
	rec(c)
	return c
end

hook.Add("OnEntityCreated", "SH_POINTSHOP.OnEntityCreated", function(ent)
	SH_POINTSHOP:InitEntityEquipped(ent)
end)

hook.Add("PrePlayerDraw", "SH_POINTSHOP.PrePlayerDraw", function(ply)
	if (!ply.SH_DRAW_CALLS) then
		return end

	for _, d in ipairs (ply.SH_DRAW_CALLS) do
		d[1]:PrePlayerDraw(ply, d)
	end
end)

hook.Add("PostPlayerDraw", "SH_POINTSHOP.PostPlayerDraw", function(ply)
	if (disable_players) then
		return end

	if (has_render_distance and ply:GetPos():DistToSqr(EyePos()) > render_distance) then
		return end

	SH_POINTSHOP:RenderEquippedModels(ply, ply)
end)

hook.Add("PostDrawTranslucentRenderables", "SH_POINTSHOP.PostDrawTranslucentRenderables", function()
	if (disable_ragdolls) then
		return end

	for ply, rag in pairs (active_ragdolls) do
		if (!IsValid(ply) or !IsValid(rag)) then
			active_ragdolls[ply] = nil
			continue
		end

		-- 76561198006360138
		if (has_render_distance and rag:GetPos():DistToSqr(EyePos()) > render_distance) then
			continue end

		SH_POINTSHOP:RenderEquippedModels(rag, ply)
	end
end)

hook.Add("PostCleanupMap", "SH_POINTSHOP.PostCleanupMap", function()
	active_ragdolls = {}

	for _, v in ipairs (player.GetAll()) do
		SH_POINTSHOP:RebuildEquippedModels(v)
	end
end)