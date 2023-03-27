AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 5000 )

	local DriverSeat = self:AddDriverSeat( Vector(-180,0,180), Angle(0,-90,0) )
	DriverSeat:SetCameraDistance( 1.2 )
	DriverSeat.HidePlayer = true
	
	local Pod = self:AddPassengerSeat( Vector(-430,0,180), Angle(0,90,0) )
	self:SetGunnerSeat( Pod )

	self:AddEngine( Vector(-230,0,60) )
	self:AddEngineSound( Vector(-100,0,60) )

	self.PrimarySND = self:AddSoundEmitter( Vector(145,0,22), "cannon_fire.mp3", "cannon_fire.mp3" )
	self.PrimarySND:SetSoundLevel( 110 )

	self.SNDTail = self:AddSoundEmitter( Vector(145,0,0), "speeder_shoot.wav", "speeder_shoot.wav" )
	self.SNDTail:SetSoundLevel( 110 )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/start.wav" )
	else
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/stop.wav" )
	end
end