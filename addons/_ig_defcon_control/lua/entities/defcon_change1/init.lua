AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/kingpommes/starwars/misc/misc_panel_1.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetUseType(SIMPLE_USE)
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

local cooldown = 0

function ENT:Use( activator, caller )
    if caller:GetRegiment() == "Imperial Navy" or caller:IsAdmin() and cooldown <= CurTime() then 
        cooldown = CurTime() + 5
        globaldefconn = 1
        net.Start("DefconSound")
        net.WriteUInt(1,16)
        net.Broadcast()
        ulx.fancyLogAdmin( caller, "#A has pressed a defcon button and set the defcon level to 1" )
        net.Start("defconchatalert")
        net.Broadcast()
    end
end

function ENT:Think()
    return
end