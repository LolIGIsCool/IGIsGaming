AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:RunOnSpawn()
	self:GetChildren()[1]:SetVehicleClass("phx_seat3")
	self:SetAutomaticFrameAdvance(true)
end

function ENT:OnEngineStarted()
	self:EmitSound( "lfs/naboo_n1_starfighter/start.wav" )
	self.HeightOffset = 20
end

function ENT:OnEngineStopped()
	self:EmitSound( "lfs/naboo_n1_starfighter/stop.wav" )
	self.HeightOffset = -20
end
