AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include("shared.lua");

util.AddNetworkString("VANILLAEASTER_NET_CHATPRINT2");

function ENT:Initialize()
    self:SetModel( "models/niksacokica/creatures/creature_rancor_egg.mdl" );
    self:PhysicsInit( SOLID_BBOX );
    self:SetMoveType( MOVETYPE_NONE );
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER);
    self:SetSolid( SOLID_BBOX );

    self:SetTrigger(true);
    self:SetUseType( SIMPLE_USE );
    self:DrawShadow(false);

    local colour = Color(math.random(0,255), math.random(0,255), math.random(0,255), 255);
    self:SetColor(colour);
    
    //self:SetPos(Vector(-1014.616089, -561.330994, -5783.095215));
    
    timer.Simple(600, function()
        if not self:IsValid() then return end
            
        self:Remove();
    end)
end

function ENT:StartTouch( ent )
    if not ent:IsPlayer() then return end

    net.Start("VANILLAEASTER_NET_CHATPRINT2");
    net.WriteEntity(ent);
    net.Broadcast();

    self:EmitSound("npc/turret_floor/ping.wav");
    self:Remove();

    local id = ent:SteamID64();

    local eggs = file.Read("eggs/" .. id .. ".txt", "DATA") or 0;
    local newEggs = eggs + 1;

    file.Write("eggs/" .. id .. ".txt", newEggs);

    ent:SH_AddPremiumPoints(1000, NULL, false, false);
end
