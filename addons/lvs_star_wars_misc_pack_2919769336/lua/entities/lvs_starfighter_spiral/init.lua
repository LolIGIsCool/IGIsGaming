AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 5000 )

	self:AddDriverSeat( Vector(100,0,60), Angle(0,-90,0) ).HidePlayer = true

	self:AddEngine( Vector(-100,0,90) )
	self:AddEngineSound( Vector(100,0,0) )

	self.PrimarySND = self:AddSoundEmitter( Vector(145,0,22), "wpn_jedistrftr_blaster_fire.wav", "wpn_jedistrftr_blaster_fire.wav" )
	self.PrimarySND:SetSoundLevel( 110 )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/start.wav" )
	else
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/stop.wav" )
	end
end