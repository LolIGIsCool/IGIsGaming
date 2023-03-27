AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 5000 )

	self:AddDriverSeat( Vector(105,0,30), Angle(0,-90,0) ).HidePlayer = true

	local Pod = self:AddPassengerSeat( Vector(60,0,60), Angle(0,90,0) )
	self:SetGunnerSeat( Pod )

	self:AddEngine( Vector(-50,0,30) )
	self:AddEngineSound( Vector(-50,0,0) )

	self.PrimarySND = self:AddSoundEmitter( Vector(145,0,22), "speeder_shoot.wav", "speeder_shoot.wav" )
	self.PrimarySND:SetSoundLevel( 110 )

	self.SecondarySND = self:AddSoundEmitter( Vector(145,0,0), "cannon_fire.mp3", "cannon_fire.mp3" )
	self.SecondarySND:SetSoundLevel( 110 )

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