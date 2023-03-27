AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 2000 )

	self:AddDriverSeat( Vector(-11, 0, -32), Angle(0,-90,0) )

	self:AddEngine( Vector(-39.84,-38.25,0) )
	self:AddEngine( Vector(-39.84,38.25,0) )
	self:AddEngineSound( Vector(-39.84,0,0) )

	self.PrimarySND = self:AddSoundEmitter(Vector(49.91, 0, -42.09), "TIE_PEW", "TIE_PEW")
	self.PrimarySND:SetSoundLevel(100)

	self:ResetSequence(self:LookupSequence("TopOpen"))
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:SetSkin(1)
		self:EmitSound( "kingpommes/starwars/tie/startup.wav" )
	else
		self:SetSkin(0)
		self:EmitSound( "kingpommes/starwars/tie/shutdown.wav" )
	end
end