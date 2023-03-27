AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

resource.AddFile("materials/shared/arrow.png")
resource.AddFile("materials/shared/implogo.png")
resource.AddFile("materials/shared/igicon.png")
resource.AddFile("materials/vgui/entities/notice_panel.vtf")
resource.AddFile("materials/vgui/entities/ranks_panel.vtf")
resource.AddFile("materials/vgui/entities/structure_panel.vtf")
resource.AddFile("materials/vgui/entities/defcon_panel.vtf")
resource.AddFile("materials/vgui/entities/faces_panel.vtf")
resource.AddFile("materials/vgui/entities/formations_panel.vtf")
resource.AddFile("materials/vgui/entities/notice_panel.vmt")
resource.AddFile("materials/vgui/entities/ranks_panel.vmt")
resource.AddFile("materials/vgui/entities/structure_panel.vmt")
resource.AddFile("materials/vgui/entities/defcon_panel.vmt")
resource.AddFile("materials/vgui/entities/faces_panel.vmt")
resource.AddFile("materials/vgui/entities/formations_panel.vmt")

function math.inrange(val, min, max)
    return val <= max and val >= min
end

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate3x5.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(50, 50, 50))
 
    local phys = self:GetPhysicsObject()
	
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end

local size = -1450 / 2

function ENT:Use(caller)
	local trace = caller:GetEyeTrace()
	if not trace.Entity == self then return end

	local cursor = self:WorldToLocal(trace.HitPos) * Vector(10, 10, 10)

	if math.inrange(cursor.y, -size - 64 - 64, -size) and math.inrange(cursor.x, -size - 64 - 64, -size) then 
		if self:GetPage() == self:GetMax() then 
		self:SetPage(0)
		self:EmitSound("buttons/blip1.wav", 50, 100, 0.5) 
		
		elseif self:GetPage() >= self:GetMax() then return end

		self:SetPage(self:GetPage() + 1)
		self:EmitSound("buttons/blip1.wav", 50, 100, 0.5)

	end
	

	if math.inrange(cursor.y, size , size + 64 + 64) and math.inrange(cursor.x, -size - 64 - 64, -size) then 
		if self:GetPage() <= 1 then return end

		self:SetPage(self:GetPage() - 1)
		self:EmitSound("buttons/blip1.wav", 50, 100, 0.5)
	end
end

