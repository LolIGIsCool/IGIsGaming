AddCSLuaFile()
ENT.Type = "ai"
ENT.Base = "base_anim"
ENT.PrintName = "Simple NPC"
ENT.Author = "Mactavish"
ENT.Spawnable = false
ENT.AdminSpawnable = true

function ENT:Initialize()
	self.SimpleNPC = true
	self.UsingPlayer = false
	self.names = 0
	self.dist = 0

	if SERVER then
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	end
	timer.Simple(1, function()
		self.ClModels = MCS.Spawns[self:GetUID()] and MCS.Spawns[self:GetUID()].ClModels

		if CLIENT and self.ClModels then
			self.mdls = {}

			for k, v in ipairs(self.ClModels) do
				self.mdls[k] = ents.CreateClientProp()
				self.mdls[k]:SetModel( v.model )
				self.mdls[k]:InvalidateBoneCache()
				self.mdls[k]:SetMoveType(MOVETYPE_NONE)
				self.mdls[k]:SetParent( self )

				if v.marge then
					self.mdls[k]:AddEffects(EF_BONEMERGE)
					self.mdls[k]:AddEffects(EF_BONEMERGE_FASTCULL)
					self.mdls[k]:AddEffects(EF_PARENT_ANIMATES)
				else
					self.mdls[k]:SetPos(self:LocalToWorld(v.pos))
					self.mdls[k]:SetAngles( self:GetAngles() + v.ang )
					self.mdls[k].pos = v.pos
					self.mdls[k].ang = v.ang
					self.mdls[k].bone = v.bone
					local mat = Matrix()
					local scale = self:GetModelScale()
					mat:Scale(Vector(scale,scale,scale))
					self.mdls[k]:EnableMatrix("RenderMultiply", mat)
				end
				self.mdls[k]:Spawn()
			end
		end
	end)
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Namer")
	self:NetworkVar("String", 1, "UID")
	self:NetworkVar("String", 2, "DefAnimation")
	self:NetworkVar("Bool", 0, "InputLimit")
end

function ENT:Think()
	if SERVER and self:GetInputLimit() and self.UsingPlayer ~= false and not IsValid(self.UsingPlayer) then
		self.UsingPlayer = false
	end

	self:NextThink(CurTime())

	return true
end

if SERVER then
	function ENT:AcceptInput(istr, ply)
		if IsValid(ply) and (not ply.UseTimer or ply.UseTimer < CurTime()) then
			ply.UseTimer = CurTime() + MCS.Config.UseDelay

			if self:GetInputLimit() then
				if self.UsingPlayer then
					return
				else
					self.UsingPlayer = ply
				end
			end

			net.Start("MCS.OpenMenu")
			net.WriteEntity(self)
			net.Send(ply)
		end
	end
else
	function ENT:Draw()
		if MCS.Spawns[self:GetUID()] and MCS.Spawns[self:GetUID()].invisible then return false end

		self:DrawModel()

		local p_dist = self:GetPos():DistToSqr(LocalPlayer():GetPos())

		if p_dist > 100000000 then return end

		if p_dist < 100000 and not MCS.Dialogue then
			self.dist = Lerp(FrameTime() * 5, self.dist, 1)
		else
			self.dist = Lerp(FrameTime() * 5, self.dist, 0)
		end

		local Pos = self:GetPos()
		local Ang = self:GetAngles()
		local eyepos = EyePos()
		local planeNormal = Ang:Up()
		Ang:RotateAroundAxis(Ang:Forward(), 90)

		if MCS.Spawns[self:GetUID()] and MCS.Spawns[self:GetUID()].namepos then
			Pos.z = Pos.z + (MCS.Spawns[self:GetUID()].namepos * self:GetModelScale())
		else
			Pos.z = Pos.z + (77 * self:GetModelScale())
		end

		local relativeEye = eyepos - Pos
		local relativeEyeOnPlane = relativeEye - planeNormal * relativeEye:Dot(planeNormal)
		local textAng = relativeEyeOnPlane:AngleEx(planeNormal)

		textAng:RotateAroundAxis(textAng:Up(), 90)
		textAng:RotateAroundAxis(textAng:Forward(), 90)
		local hover = Vector(0,0,-2)
		if MCS.Config.NPCNameHover then
			hover = Ang:Right() * math.sin(CurTime()) * 0.9
		end

		cam.Start3D2D(Pos - hover, textAng, 0.1)
			draw.RoundedBox(0, -self.names / 2 - 10, 0, self.names + 20, 35, MSD.ColorAlpha(MSD.Theme.m, self.dist * 255))
			MCS.Frame( -self.names / 2 - 10, 0, self.names + 20, 35, 10, MSD.ColorAlpha(MSD.Theme.d, self.dist * 255), MSD.ColorAlpha(color_white, self.dist * 255))
			self.names = draw.SimpleText(self:GetNamer(), "MSDFont.32", 0, 0, MSD.ColorAlpha(color_white, self.dist * 255), TEXT_ALIGN_CENTER, 0)
		cam.End3D2D()

		if not self.mdls then return end

		for k,v in ipairs(self.mdls) do
			if not IsValid(v) then continue end
			if v.bone then
				local pos, ang = MCS.GetBoneOrientation(self, v.bone, v.pos, v.ang, self:GetModelScale())
				ang:RotateAroundAxis(ang:Up(), v.ang.y)
				ang:RotateAroundAxis(ang:Right(), v.ang.p)
				ang:RotateAroundAxis(ang:Forward(), v.ang.r)
				v:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				v:SetAngles(ang)
			end
			if v:GetParent() == NULL then
				v:SetParent(self)
			end
		end

	end

	function ENT:OnRemove()
		if not self.mdls then return end
		for k,v in ipairs(self.mdls) do
			if IsValid(v) then
				v:Remove()
			end
		end
	end
end