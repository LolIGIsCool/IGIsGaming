AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 15000 )

	local DriverSeat = self:AddDriverSeat( Vector(170,0,80), Angle(0,-90,0) )
	DriverSeat:SetCameraDistance( 1.2 )
	DriverSeat.HidePlayer = true

	local Pod = self:AddPassengerSeat( Vector(-210,0,180), Angle(0,90,0) )
	self:SetGunnerSeat( Pod )
	
	self:AddPassengerSeat( Vector(-140,30,100), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-170,30,100), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-200,30,100), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-140,-30,100), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-170,-30,100), Angle(0,-90,0) )
	self:AddPassengerSeat( Vector(-200,-30,100), Angle(0,-90,0) )

	self:AddEngine( Vector(-530,0,120) )
	self:AddEngineSound( Vector(-530,0,120) )

	self.PrimarySND = self:AddSoundEmitter( Vector(145,0,22), "cannon_fire.mp3", "cannon_fire.mp3" )
	self.PrimarySND:SetSoundLevel( 110 )

	self.SNDTail = self:AddSoundEmitter( Vector(-171.69,0,45), "lvs/vehicles/arc170/fire_gunner.mp3", "lvs/vehicles/arc170/fire_gunner.mp3" )
	self.SNDTail:SetSoundLevel( 110 )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/start.wav" )
	else
		self:EmitSound( "lvs/vehicles/naboo_n1_starfighter/stop.wav" )
	end
end