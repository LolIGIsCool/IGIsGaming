AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )

include('shared.lua')

local musicOwner;
function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

    musicOwner = ply:SteamID()

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:Initialize()

    self:SetModel('models/props_lab/reciever01a.mdl')
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
    self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )

    self:Sethds_ownerSteamID(musicOwner)

    --self:SetColor( Color(255,255,255,0) )


    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
