AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:RunOnSpawn()
	self:AddPassengerSeat( Vector(-21,15,14), Angle(0,-90,22) ).ExitPos = Vector(30,30,30)
end

function ENT:OnKeyThrottle( bPressed )
end

function ENT:OnLandingGearToggled( bOn )
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/naboo_n1_starfighter/start.wav" )
	self.HeightOffset = 15
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/naboo_n1_starfighter/stop.wav" )
	self.HeightOffset = -15
end