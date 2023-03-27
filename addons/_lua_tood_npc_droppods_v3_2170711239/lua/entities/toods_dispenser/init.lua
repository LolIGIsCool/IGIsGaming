--[[------------------------------------------------------------------------------
                                                                       dddddddd
TTTTTTTTTTTTTTTTTTTTTTT                                                d::::::d
T:::::::::::::::::::::T                                                d::::::d
T:::::TT:::::::TT:::::T                                                d:::::d 
TTTTTT  T:::::T  TTTTTT   ooooooooooo       ooooooooooo         ddddddddd:::::d 
        T:::::T        o:::::::::::::::o o:::::::::::::::o   d::::::::::::::::d 
        T:::::T        o:::::ooooo:::::o o:::::ooooo:::::o  d:::::::ddddd:::::d 
        T:::::T        o::::o     o::::o o::::o     o::::o  d:::::d     d:::::d 
      TT:::::::TT      o:::::ooooo:::::o o:::::ooooo:::::o  d::::::ddddd::::::dd
      T:::::::::T       oo:::::::::::oo   oo:::::::::::oo     d:::::::::ddd::::d
      TTTTTTTTTTT         ooooooooooo       ooooooooooo        ddddddddd   ddddd

Version: 3.0
Contact: Discord - The Toodster#0001 || Steam - https://steamcommunity.com/id/freelancertood/

Disclaimer: If you mess with anything inside this file and you break it then it's on you. Do not come to me for support. 
If you don't know what you are doing then don't touch it.

--]]-------------------------------------------------------------------------------

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include( "shared.lua" )

local NPCClass
local NPCModel
local NPCWeapon
local NPCHealth
local NPCAmount

local MinSpawn
local MaxSpawn

local WepDiff
local NPCRelations

function ENT:KeyValue( TKey, TValue )
    if TKey == "NPCClass" then
        NPCClass = TValue
    end
	if TKey == "NPCModel" then
		NPCModel = TValue
	end
    if TKey == "DispenserModel" then
        self:SetModel( TValue )
    end
    if TKey == "NPCWeapon" then
        NPCWeapon = TValue
    end
    if TKey == "NPCHealth" then
        NPCHealth = TValue
    end
    if TKey == "MinSpawnTime" then
        MinSpawn = TValue
    end
    if TKey == "MaxSpawnTime" then
        MaxSpawn = TValue
    end
    if TKey == "DispenserHealth" then
        self:SetHealth( TValue )
		self:SetMaxHealth( TValue )
    end
    if TKey == "NPCAmount" then
        NPCAmount = TValue
    end
	if TKey == "NPCWepDiff" then
		WepDiff = TValue
	end
	if TKey == "NPCRelations" then
		NPCRelations = TValue
	end
end

function ENT:Initialize()

    self:SetModel( self:GetModel() )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetHealth( self:Health() )
	self:SetMaxHealth( self:GetMaxHealth() )
    self:SetSolid( SOLID_VPHYSICS )
    self:DrawShadow( true )
    local phys = self:GetPhysicsObject()
 
    if ( phys:IsValid() ) then
        phys:Wake()
    end
 
    self.Collided = false
 
    timer.Simple( 2.6, function()
        self:EmitSound( "sanctum2/towers/tower_entry" .. math.random( 1, 2 ) .. ".ogg", 150, math.Rand( 80, 120 ) )
    end )
end

local ListNPCs = {
    "npc_citizen",
    "npc_alyx",
    "npc_barney",
    "npc_kleiner",
    "npc_mossman",
    "npc_eli",
    "npc_gman",
    "npc_breen",
    "npc_monk",
    "npc_combine_s",
    "npc_metropolice",
    "npc_zombine",
    "npc_poisonzombine"
    }

-- If you change the NPC amount limit in dispenser_tool.lua then you need to add more vectors to match the limit of the NPC amount.

local spawnTable = { }
 
spawnTable[1] = { v = Vector(90, 90, 1) }
spawnTable[2] = { v = Vector(-90, 90, 1) }
spawnTable[3] = { v = Vector(-90, -90, 1) }
spawnTable[4] = { v = Vector(90, -90, 1) }
spawnTable[5] = { v = Vector(-45, 90, 1) }
spawnTable[6] = { v = Vector(59, 90, 1) }
spawnTable[7] = { v = Vector(73, 75, 1) }
spawnTable[8] = { v = Vector(34, -85, 1) }
spawnTable[9] = { v = Vector(-130, 85, 1) }
spawnTable[10] = { v = Vector(-177, -95, 1) }
spawnTable[11] = { v = Vector(90, 85, 1) }
spawnTable[12] = { v = Vector(90, -85, 1) }
spawnTable[13] = { v = Vector(120, 45, 1) }
spawnTable[14] = { v = Vector(155, 120, 1) }
spawnTable[15] = { v = Vector(-120, 45, 1) }
spawnTable[16] = { v = Vector(155, -120, 1) }
spawnTable[17] = { v = Vector(60, -140, 1) }
spawnTable[18] = { v = Vector(-60, 140, 1) }
spawnTable[19] = { v = Vector(-60, -140, 1) }
spawnTable[20] = { v = Vector(195, -70, 1) } 

function ENT:SummonNPC( Class )
local AllNPCs = list.Get( "NPC" )
local CheckClass = AllNPCs[Class]
if !CheckClass then return end
	for i = 1, NPCAmount do
		timer.Simple( math.random( MinSpawn, MaxSpawn ), function() 
			if IsValid( self ) then
			local SpawnNPC = ents.Create( CheckClass.Class )
			if !IsValid( SpawnNPC ) then return end
				SpawnNPC:SetPos( self:GetPos() + spawnTable[i].v )
				if NPCModel != "" then
					SpawnNPC:SetModel( NPCModel )
				elseif CheckClass.Model then
					SpawnNPC:SetModel( CheckClass.Model )
				end
				timer.Simple( 0.1, function() 
					SpawnNPC:SetHealth( NPCHealth )
				end )
				SpawnNPC:Give( NPCWeapon )
				SpawnNPC:SetCurrentWeaponProficiency( WepDiff )
                SpawnNPC:SetKeyValue( "spawnflags", bit.bor( SF_NPC_NO_WEAPON_DROP ) )
                    /*
				for k, ply in ipairs( player.GetAll() ) do
					if NPCRelations == "1" then
						SpawnNPC:AddEntityRelationship( ply, D_HT, 99 )
					elseif NPCRelations == "3" then
						SpawnNPC:AddEntityRelationship( ply, D_LI, 99 )
					end
					for k2, ent in ipairs( ents.FindByClass( "npc_*" ) ) do
						if IsValid(ent:GetEnemy()) and ent:GetEnemy() == ply && ent:GetEnemy() != SpawnNPC then
							if NPCRelations == "1" then
								SpawnNPC:AddEntityRelationship( ent, D_LI, 99 )
								ent:AddEntityRelationship( SpawnNPC, D_LI, 99 )
							elseif NPCRelations == "3" then
								SpawnNPC:AddEntityRelationship( ent, D_HT, 99 )
								ent:AddEntityRelationship( SpawnNPC, D_HT, 99 ) -- For some reason ent doesn't attack SpawnNPC so I guess this is a quick fix?
							end
						end
					end
				end*/
				SpawnNPC:Spawn()
				SpawnNPC:Activate()
			end
		end )
	end
	return SpawnNPC
end 

function ENT:PhysicsCollide( data, phys )
    if not IsValid( self ) then return end
    if not IsValid( self ) then return end
    local CheckLocAng = self:GetAngles()
 
    if not data.HitEntity:IsValid() then
        self:CollideEffect()
        self.Collided = true
 
        if ( math.abs( CheckLocAng.r ) < 45 ) then
            phys:EnableMotion( false )
            phys:Sleep()
			local FetchClass = NPCClass
			self:SummonNPC( NPCClass ) -- Call the function to spawn the NPCs.
        end
    elseif data.HitEntity:IsValid() then
        if table.HasValue( ListNPCs, string.lower( data.HitEntity:GetClass() ) ) or data.HitEntity:IsPlayer() then
            if not self.Collided then
                local CheckBoom = EffectData()
                CheckBoom:SetScale( 1.6 )
                CheckBoom:SetOrigin( data.HitEntity:GetPos() + Vector( 0, 0, -32 ) )
                util.Effect( "m9k_gdcw_s_blood_cloud", CheckBoom )
            end
        end
 
        if not data.HitEntity:IsPlayer() and ( math.abs( CheckLocAng.r ) < 15 ) then
            if data.HitEntity:GetClass() ~= "prop_vehicle_jeep" then
                if not self.Collided then
                    data.HitEntity:Remove()
                end
            end
        end
    end
end
 
function ENT:CollideEffect()
if self.Collided then return end
local CheckBoom2 = EffectData()
    CheckBoom2:SetOrigin( self:GetPos() + Vector( 0, 0, 0 ) )
    CheckBoom2:SetEntity( self )
    CheckBoom2:SetScale( 1.2 )
    CheckBoom2:SetMagnitude( 65 )
    util.Effect( "m9k_gdcw_s_boom", CheckBoom2 )
    util.BlastDamage( self, self, self:GetPos(), 102, 212 )
    util.ScreenShake( self:GetPos(), 16, 250, 1, 512 )
    self:EmitSound( "sanctum2/towers/tower_impact" .. math.random( 1, 3 ) .. ".ogg", 150, math.Rand( 80, 120 ) )
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
		SafeRemoveEntity( self )
    end
end

function ENT:Think() 
end