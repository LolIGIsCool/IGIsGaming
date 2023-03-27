AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_weapons.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_effects.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_trailsystem.lua" )
AddCSLuaFile( "cl_seatswitcher.lua" )
AddCSLuaFile( "cl_planescript_module.lua" )
include("shared.lua")
include( "sh_weapons.lua" )
include("sv_ai.lua")
include("sv_cppi.lua")
include("sv_pod.lua")
include("sv_engine.lua")
include("sv_physics.lua")
include("sv_damagesystem.lua")
include("sv_shieldsystem.lua")

ENT.WaterLevelPreventStart = 1
ENT.WaterLevelAutoStop = 2
ENT.WaterLevelDestroyAI = 2

function ENT:SpawnFunction( ply, tr, ClassName )

	if ply:InVehicle() then
		local ent = ents.Create( ClassName )
		ent:StoreCPPI( ply )
		ent:SetPos( ply:GetPos() + Vector(0,0,100 + ent.SpawnNormalOffset) )
		ent:SetAngles( Angle(0, ply:EyeAngles().y, 0 ) )
		ent:Spawn()
		ent:Activate()

		return ent
	else
		if not tr.Hit then return end

		local ent = ents.Create( ClassName )
		ent:StoreCPPI( ply )
		ent:SetPos( tr.HitPos + tr.HitNormal * ent.SpawnNormalOffset )
		ent:SetAngles( Angle(0, ply:EyeAngles().y, 0 ) )
		ent:Spawn()
		ent:Activate()

		return ent
	end
end

function ENT:Initialize()
	self:SetModel( self.MDL )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	self:AddFlags( FL_OBJECT )

	local PObj = self:GetPhysicsObject()

	if not IsValid( PObj ) then 
		self:Remove()

		print("LVS: missing model. Vehicle terminated.")

		return
	end

	PObj:SetMaterial( "default_silent" )
	PObj:EnableMotion( false )
	PObj:EnableDrag( false )

	self:OnSpawn( PObj )

	self:StartMotionController()

	if GetConVar( "developer" ):GetInt() ~= 1 then
		PObj:EnableMotion( true )
	end

	self:PhysWake()

	self:AutoAI()

	self:CallOnRemove( "finish_weapons_on_delete", function( ent )
		ent:WeaponsFinish()

		for _, pod in pairs( ent:GetPassengerSeats() ) do
			local weapon = pod:lvsGetWeapon()

			if not IsValid( weapon ) or not weapon._activeWeapon then continue end

			local CurWeapon = self.WEAPONS[ weapon:GetPodIndex() ][ weapon._activeWeapon ]

			if not CurWeapon then continue end

			if CurWeapon.FinishAttack then
				CurWeapon.FinishAttack( weapon )
			end
		end

		ent:WeaponsOnRemove()
	end)
end

function ENT:OnSpawn( PObj )
end

function ENT:Think()
	self:HandleActive()
	self:HandleStart()
	self:PhysicsThink()
	self:DamageThink()
	self:WeaponsThink()
	self:ShieldThink()

	if self:GetAI() then self:RunAI() end

	self:OnTick()

	self:NextThink( CurTime() )
	
	return true
end

function ENT:OnDriverChanged( Old, New, VehicleIsActive )
end

function ENT:OnTick()
end

function ENT:OnRemoved()
end

function ENT:OnRemove()
	self:OnRemoved()
end

function ENT:Lock()
	if self:GetlvsLockedStatus() then return end

	self:SetlvsLockedStatus( true )
	self:EmitSound( "doors/latchlocked2.wav" )
end

function ENT:UnLock()
	if not self:GetlvsLockedStatus() then return end

	self:SetlvsLockedStatus( false )
	self:EmitSound( "doors/latchunlocked1.wav" )
end

function ENT:Use( ply )
	if not IsValid( ply ) then return end

	if self:GetlvsLockedStatus() or (LVS.TeamPassenger:GetBool() and ((self:GetAITEAM() ~= ply:lvsGetAITeam()) and ply:lvsGetAITeam() ~= 0 and self:GetAITEAM() ~= 0)) then 

		self:EmitSound( "doors/default_locked.wav" )

		return
	end

	self:SetPassenger( ply )
end

function ENT:OnTakeDamage( dmginfo )
	self:CalcShieldDamage( dmginfo )
	self:CalcDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
	self:OnAITakeDamage( dmginfo )
end

function ENT:OnMaintenance()
end

function ENT:UpdateTransmitState() 
	return TRANSMIT_ALWAYS
end

function ENT:GetMissileOffset()
	return self:OBBCenter()
end

function ENT:GetCrosshairFilterEnts()
	if not istable( self.CrosshairFilterEnts ) then
		self.CrosshairFilterEnts = {}

		for _, Entity in pairs( constraint.GetAllConstrainedEntities( self ) ) do
			if not IsValid( Entity ) then continue end

			table.insert( self.CrosshairFilterEnts , Entity )
		end

		for _, Parent in pairs( self.CrosshairFilterEnts ) do
			for _, Child in pairs( Parent:GetChildren() ) do
				if not IsValid( Child ) then continue end

				table.insert( self.CrosshairFilterEnts , Child )
			end
		end
	end

	return self.CrosshairFilterEnts
end

function ENT:LVSFireBullet( data )
	data.Entity = self
	data.Velocity = data.Velocity + self:GetVelocity():Length()
	data.SrcEntity = self:WorldToLocal( data.Src )

	LVS:FireBullet( data )
end

function ENT:AddSoundEmitter( pos, snd, snd_interior )
	local Emitter = ents.Create( "lvs_soundemitter" )

	if not IsValid( Emitter ) then
		self:Remove()

		print("LVS: Failed to create sound emitter entity. Vehicle terminated.")

		return
	end

	Emitter:SetPos( self:LocalToWorld( pos ) )
	Emitter:SetAngles( self:GetAngles() )
	Emitter:Spawn()
	Emitter:Activate()
	Emitter:SetParent( self )
	Emitter:SetBase( self )
	Emitter:SetSound( snd or "" )
	Emitter:SetSoundInterior( snd_interior or "" )

	self:DeleteOnRemove( Emitter )

	self:TransferCPPI( Emitter )

	return Emitter
end
