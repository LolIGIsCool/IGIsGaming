AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");
include("shared.lua");

function ENT:Initialize()
	self:SetModel("models/props_c17/TrapPropeller_Lever.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	local physObj = self:GetPhysicsObject();

	if (IsValid(physObj)) then
		physObj:Wake();
		physObj:EnableMotion(true);
	end;
end;

function ENT:Use(activator, caller)
	
	if (timer.Exists( "PoisonTimer_" .. caller:SteamID() ) ) then
	     timer.Remove( "PoisonTimer_" .. caller:SteamID() )
		 end
	self:Remove()
	
end;

function ENT:OnTakeDamage()
    local vPoint = self:GetPos()
    local effectdata = EffectData()
    effectdata:SetOrigin( vPoint )
    util.Effect( "GlassImpact", effectdata )
	self:EmitSound("physics/glass/glass_bottle_break2.wav")
	SafeRemoveEntity(self)
end