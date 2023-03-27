AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 5000 )

	self:AddDriverSeat( Vector(180,0,80), Angle(0,-90,0) ).HidePlayer = true

	self:AddEngine( Vector(-230,0,70) )
	self:AddEngineSound( Vector(-100,0,70) )

	self.PrimarySND = self:AddSoundEmitter( Vector(145,0,22), "wpn_xwing_blaster_fire.wav", "wpn_xwing_blaster_fire.wav" )
	self.PrimarySND:SetSoundLevel( 110 )

	self.SecondarySND = self:AddSoundEmitter( Vector(145,0,0), "lvs/vehicles/vulturedroid/fire.mp3", "lvs/vehicles/vulturedroid/fire.mp3" )
	self.SecondarySND:SetSoundLevel( 110 )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/start.wav" )
	else
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/stop.wav" )
	end
end