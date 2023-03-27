AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

resource.AddFile("materials/shared/arrow.png")
resource.AddFile("materials/shared/implogo.png")
resource.AddFile("materials/shared/igicon.png")
resource.AddFile("materials/shared/igmenuicon.png")

function math.inrange(val, min, max)
    return val <= max and val >= min
end

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate4x5.mdl")
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

