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
    self:SetModel( "models/props/starwars/tech/mainframe.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_VPHYSICS )
	self:SetModelScale( self:GetModelScale() * 0.8 )
    self:SetHealth( self.PowerHealth )
    self:SetMaxHealth( self.PowerHealth )

    local PowerPhys = self:GetPhysicsObject()
    if IsValid( PowerPhys ) then
        PowerPhys:Wake()
    end
end

function ENT:OnTakeDamage( dmg )
    self:TakePhysicsDamage( dmg )
    if ( self:Health() <= 0 ) then return end
    self:SetHealth( math.Clamp( self:Health() - dmg:GetDamage(), 0, self:GetMaxHealth() ) )
    for k, v in pairs( ents.FindByClass( "func_door" ) ) do
        if ( self:Health() <= 0 ) then
        local BoomBoom4 = ents.Create( "env_explosion" )
            BoomBoom4:SetKeyValue( "spawnflags", 144 )
            BoomBoom4:SetKeyValue( "iMagnitude", 15 )
            BoomBoom4:SetKeyValue( "iRadiusOverride", 256 )
            BoomBoom4:SetPos( self:GetPos() )
            BoomBoom4:Spawn()
            BoomBoom4:Fire( "explode", "", 0 )
            PrintMessage( HUD_PRINTCENTER, "Power Station has been destroyed!" )
            self:Ignite( 20, 250 )
            v:Input( "Lock" )
            v:Input( "Close" )
        end
    end
end

function ENT:Think()
    self:NextThink(CurTime() + 1)
    if self:GetPlayerRepairing() then
        for k, v in pairs( ents.FindByClass( "func_door" ) ) do
            if self:Health() <= 0 then return end
            if self:Health() >= 500 then
                v:Input( "Unlock" )
            end
        end
        self:SetPlayerRepairing( false )
    end
end

function ENT:OnRemove() -- This is here purely to stop all doors from staying locked if someone destroys the entity then removes it.
    for k, v in pairs( ents.FindByClass( "func_door" ) ) do
        v:Input( "Unlock" )
    end
end
