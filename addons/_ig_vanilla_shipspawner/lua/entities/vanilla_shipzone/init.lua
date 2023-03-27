AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include("shared.lua");

function ENT:Initialize()
    self:SetModel( "models/hunter/plates/plate2x2.mdl" );
    self:PhysicsInit( SOLID_BBOX );
    self:SetMoveType( MOVETYPE_NONE );
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER);
    self:SetSolid( SOLID_BBOX );

    self:DrawShadow( false );
end
