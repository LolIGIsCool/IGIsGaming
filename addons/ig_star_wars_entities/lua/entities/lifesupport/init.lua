--[[------------------------------------------------------------
    ____________										   ___
    |		   |   									 	  |	  |
    |___	___|	__________   	__________			  |	  |
    	|	|	   /		  \	   /		  \		   	  |	  |
    	|	|	  |			   |  |			   |	  ____|   |
    	|	|	  |			   |  |			   |	 / 		  |
    	|	|	  |			   |  |			   |	|		  |
    	|___|	   \__________/    \__________/		 \________|

    Author: Tood/The Toodster.
    Contact: Discord - The Toodster#0001 || Steam - https://steamcommunity.com/id/freelancertood/
--]]------------------------------------------------------------

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/props_combine/combine_monitorbay.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetPos( self:GetPos() + Vector( 0, 0, 100 ) ) -- This spawns underground in some maps so set to 100 then DropToFloor().
    self:SetHealth( self.SuppHealth )
    self:SetMaxHealth( self.SuppHealth )
    self:DropToFloor()

    local SuppPhys = self:GetPhysicsObject()
    if IsValid( SuppPhys ) then
        SuppPhys:Wake()
    end
end

function ENT:OnTakeDamage( dmg )
    self:TakePhysicsDamage( dmg )
    if ( self:Health() <= 0 ) then return end
    self:SetHealth( math.Clamp( self:Health() - dmg:GetDamage(), 0, self:GetMaxHealth() ) )

    if ( self:Health() <= 0 ) then
    local BoomBoom2 = ents.Create( "env_explosion" )
        BoomBoom2:SetKeyValue( "spawnflags", 144 )
        BoomBoom2:SetKeyValue( "iMagnitude", 15 )
        BoomBoom2:SetKeyValue( "iRadiusOverride", 256 )
        BoomBoom2:SetPos( self:GetPos() )
        BoomBoom2:Spawn()
        BoomBoom2:Fire( "explode", "", 0 )
        PrintMessage( HUD_PRINTCENTER, "Life Support System has been destroyed!" )
        self:Ignite( 20, 250 )
        for k, v in pairs( player.GetAll() ) do
		if v:InVehicle() then continue end
		if v:Team() == GAMEMODE.DefaultTeam then continue end
        local PDMG = DamageInfo()
            PDMG:SetDamage( 2 )
            PDMG:SetDamageType( DMG_RADIATION )
            if v:Health() < 0 then return end
            if v:Health() >= 0 then
                timer.Create( "OverTime", 1.5, 0, function()
                    v:TakeDamageInfo( PDMG )
                end )
            end
        end
    end
end

function ENT:Think()
    self:NextThink(CurTime() + 1)
    if self:GetPlayerRepairing() then
        if self:Health() <= 0 then return end
        if self:Health() >= 500 && timer.Exists( "OverTime" ) then
            timer.Stop( "OverTime" )
        end
        self:SetPlayerRepairing( false )
    end
end

function ENT:OnRemove()
    if timer.Exists( "OverTime" ) then
        timer.Stop( "OverTime" )
    end
end