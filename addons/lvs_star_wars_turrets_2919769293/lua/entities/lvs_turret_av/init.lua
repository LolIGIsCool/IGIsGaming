AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	PObj:SetMass( 5000 )

	local GunnerSeat = self:AddPassengerSeat( Vector(0,0,50), Angle(0,-90,0) )
	self:SetGunnerSeat( GunnerSeat )
	GunnerSeat.HidePlayer = true

	self.PrimarySND = self:AddSoundEmitter( Vector(0,-40,57), "lvs/vehicles/atte/fire_turret.mp3", "lvs/vehicles/atte/fire_turret.mp3" )
	self.PrimarySND:SetSoundLevel( 160 )
	
	self.SecondarySND = self:AddSoundEmitter( Vector(0,-40,57), "lvs/vehicles/atte/fire.mp3", "lvs/vehicles/atte/fire.mp3" )
	self.SecondarySND:SetSoundLevel( 110 )

	local ID = self:LookupAttachment( "seat" )
	local Attachment = self:GetAttachment( ID )

	if Attachment then
		local Pos,Ang = LocalToWorld( Vector(0,0,30), Angle(0,180,0), Attachment.Pos, Attachment.Ang )

		GunnerSeat:SetParent( NULL )
		GunnerSeat:SetPos( Pos )
		GunnerSeat:SetAngles( Ang )
		GunnerSeat:SetParent( self )
	end
end

function ENT:OnEngineActiveChanged( Active )
end