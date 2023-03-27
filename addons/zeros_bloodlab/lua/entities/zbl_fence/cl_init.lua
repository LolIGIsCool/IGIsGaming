include("shared.lua")

function ENT:Initialize()
	zbl.f.EntList_Add(self)

	self.WallModels = {}
	self.Constructed = false

	self:DrawShadow(false)
	self:DestroyShadow()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:DrawText(txt,color)
	local w,h = 340,100

	local font = zbl.f.GetFontFromTextSize(txt,10,"zbl_fence_title","zbl_fence_title_small")

	cam.Start3D2D(self:LocalToWorld(Vector(3.2, 0, 107.6)), self:LocalToWorldAngles(Angle(180, -90, -90)), 0.1)
		draw.RoundedBox(0, -w / 2, -h / 2, w, h, color)
		draw.SimpleText(txt, font, 0,0, zbl.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()

	cam.Start3D2D(self:LocalToWorld(Vector(-3.2, 0, 107.6)), self:LocalToWorldAngles(Angle(180, 90, -90)), 0.1)
		draw.RoundedBox(0, -w / 2, -h / 2, w, h, color)
		draw.SimpleText(txt, font, 0,0, zbl.default_colors["white01"], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	if GetConVar("zbl_cl_fence_simplify"):GetInt() == 1 then
		local _l_wall = self:GetLeftWall()
		local _r_wall = self:GetRightWall()

		if IsValid(_r_wall) then
			local min, max = _r_wall:GetCollisionBounds()
			render.SetColorMaterial()
			render.DrawBox(_r_wall:GetPos(), _r_wall:GetAngles(), min, max, zbl.default_colors["fence_indicator"])
		end

		if IsValid(_l_wall) then
			local min, max = _l_wall:GetCollisionBounds()
			render.SetColorMaterial()
			render.DrawBox(_l_wall:GetPos(), _l_wall:GetAngles(), min, max, zbl.default_colors["fence_indicator"])
		end
	end

	if GetConVar("zbl_cl_drawui"):GetInt() == 1 and zbl.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 1000) then
		local ScanResult = self:GetScanResult()

		if ScanResult == 1 then
			self:DrawText(zbl.language.General["Clean"],zbl.default_colors["fence_check_good"])
		elseif ScanResult == 0 then
			self:DrawText(zbl.language.General["Virus"],zbl.default_colors["fence_check_bad"])
		elseif ScanResult == 2 then
			self:DrawText(zbl.language.General["Sterilized"],zbl.default_colors["fence_check_sterilized"])
		elseif ScanResult == 3 then
			self:DrawText("MINGE",zbl.default_colors["fence_check_bad"])
		end
	end
end

function ENT:Think()
	if zbl.f.InDistance(LocalPlayer():GetPos(), self:GetPos(), 3000) and self:GetTurnedOn() and GetConVar("zbl_cl_fence_simplify"):GetInt() == 0 then

		if self.Constructed == false then
			self:RebuildMesh()

			self:EmitSound("zbl_fence_move")
			timer.Simple(0.5,function()
				if IsValid(self) then
					self:StopSound("zbl_fence_move")
					self:EmitSound("zbl_fence_stop")
				end
			end)

			self.Constructed = true
		end
	else
		if self.Constructed == true then
			self:DestroyMesh()
			self:StopSound("zbl_fence_move")
			self:EmitSound("zbl_fence_remove")

			self.Constructed = false
		end
	end
	self:SetNextClientThink(CurTime())
	return true
end

function ENT:CreateFencePiece(pos,ang)
	local cs = ents.CreateClientProp()

	if IsValid(cs) then
		cs:SetPos(pos)
		cs:SetAngles(ang)
		cs:SetModel("models/zerochain/props_bloodlab/zbl_fence.mdl")
		cs:SetMoveType(MOVETYPE_NONE)
		cs:SetParent(self)
		//cs:SetRenderMode(RENDERMODE_NORMAL)
		cs:Spawn()
		cs:DrawShadow(false)
		cs:DestroyShadow()

		table.insert(self.WallModels,cs)
	end
end

function ENT:ConstructWall(wall_end,left)

	local wall_size = 100

	local pos = self:GetPos()

	if left then
		pos = self:GetPos() + self:GetRight() * 40
	else
		pos = self:GetPos() - self:GetRight() * 40
	end

	local e_pos = wall_end:GetPos()
	local dist = math.Distance( pos.x,pos.y, e_pos.x,e_pos.y )

	debugoverlay.Sphere(pos,5,3,Color( 255, 255, 0 ),true)
	debugoverlay.Sphere(wall_end:GetPos(),5,3,Color( 255, 255, 0 ),true)

	local count = math.Round(dist / wall_size)
	local rest = dist - (wall_size * count)
	if rest > wall_size / 8 then
		count = count + 1
	end

	local ang = self:GetAngles()
	ang:RotateAroundAxis(self:GetUp(),90)

	if left then
		ang:RotateAroundAxis(self:GetUp(),180)
	end

	for i = 1, count do
		local w_pos = pos

		if left then
			w_pos = w_pos - self:GetRight() * 60
			w_pos = w_pos + self:GetRight() * (wall_size * i)
		else
			w_pos = w_pos + self:GetRight() * 60
			w_pos = w_pos - self:GetRight() * (wall_size * i)
		end

		self:CreateFencePiece(w_pos, ang)
	end
end

function ENT:RebuildMesh()

	local _l_wall = self:GetLeftWall()
	local _r_wall = self:GetRightWall()

	if not IsValid(_r_wall) or not IsValid(_l_wall) then return end

	self:ConstructWall(_r_wall,false)
	self:ConstructWall(_l_wall,true)
end

function ENT:DestroyMesh()
	for k,v in pairs(self.WallModels) do
		if IsValid(v) then
			v:Remove()
		end
	end
end

function ENT:OnRemove()
	self:DestroyMesh()
end
