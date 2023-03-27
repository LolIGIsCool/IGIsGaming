AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/lt_c/sci_fi/counter_sinks.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetUseType(SIMPLE_USE)
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
    activator:EmitSound( "ambient/water/water_spray3.wav", 50, 100, 1, CHAN_AUTO )
    activator:Say( "/me washes hands.", false )
end

function ENT:Think()
    return
end