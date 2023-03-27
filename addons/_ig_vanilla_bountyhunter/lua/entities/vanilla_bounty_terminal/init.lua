AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include("shared.lua");

function ENT:Initialize()
    self:SetModel( "models/kingpommes/starwars/misc/circle_console_dirty.mdl" );
    self:PhysicsInit( SOLID_VPHYSICS );
    self:SetMoveType( MOVETYPE_VPHYSICS );
    self:SetSolid( SOLID_VPHYSICS );

    self:PhysWake();
end
