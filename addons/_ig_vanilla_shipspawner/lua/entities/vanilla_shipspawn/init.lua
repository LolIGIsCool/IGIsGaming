AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
include("shared.lua");

function ENT:Initialize()
    self:SetModel( "models/props_phx/construct/metal_angle360.mdl" );
    self:PhysicsInit( SOLID_BBOX );
    self:SetMoveType( MOVETYPE_NONE );
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER);
    self:SetSolid( SOLID_BBOX );

    self:SetTrigger( true );
    self:SetUseType( SIMPLE_USE );
    self:DrawShadow( false );
end

function ENT:StartTouch( ent )
    if not ent:IsPlayer() then return end

    local id = self:GetPoolID();
    local zone = self:GetSpawnerID();

    if not file.Exists("vanilla_ships/" .. id .. ".json", "DATA") then
        local emptyTable = {};
        file.Write("vanilla_ships/" .. id .. ".json", util.TableToJSON(emptyTable, true));
    end

    local json = file.Read("vanilla_ships/" .. id .. ".json", "DATA");

    net.Start("VANILLASHIP_net_OpenMenu");
    net.WriteString(id); //pool
    net.WriteString(zone); //zone
    net.WriteTable(util.JSONToTable(json));
    net.Send(ent);
end
