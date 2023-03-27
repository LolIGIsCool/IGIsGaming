ENT.Base = "lvs_base_turret"

ENT.PrintName = "Anti-Air Turret"
ENT.Author = "Luna"
ENT.Information = "It shoots lasers into the sky and makes things go boom"
ENT.Category = "[LVS] - Turrets (CIS)"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/antiairturret/rep_anti-airturret.mdl"

ENT.AITEAM = 1

ENT.MaxVelocity = 3000
ENT.MaxThrust = 3000

ENT.ThrustVtol = 55
ENT.ThrustRateVtol = 3

ENT.TurnRatePitch = 1
ENT.TurnRateYaw = 1
ENT.TurnRateRoll = 1

ENT.ForceLinearMultiplier = 1

ENT.ForceAngleMultiplier = 1
ENT.ForceAngleDampingMultiplier = 1

ENT.LAATC_PICKUPABLE = true
ENT.LAATC_DROP_IN_AIR = true
ENT.LAATC_PICKUP_POS = Vector(-200,0,25)
ENT.LAATC_PICKUP_Angle = Angle(0,0,0)

ENT.MaxHealth = 4800

function ENT:OnSetupDataTables()
	self:AddDT( "Bool", "IsCarried" )
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Float", "TurretPitch" )
	self:AddDT( "Float", "TurretYaw" )

	if SERVER then
		self:NetworkVarNotify( "IsCarried", self.OnIsCarried )
	end
end

function ENT:TraceTurret()
	local ID = self:LookupAttachment( "muzzle1" )
	local Muzzle = self:GetAttachment( ID )

	if not Muzzle then return end

	local dir = Muzzle.Ang:Up()
	local pos = Muzzle.Pos

	local trace = util.TraceLine( {
		start = pos,
		endpos = (pos + dir * 50000),
	} )

	return trace
end

function ENT:GetAimAngles( ent )
    local trace = ent:GetEyeTrace()
    local AimAngles = self:WorldToLocalAngles( (trace.HitPos - self:LocalToWorld( Vector(0,0,60) ) ):GetNormalized():Angle() )

    return AimAngles
end

function ENT:WeaponsInRange( ent )
    local AimAngles = self:GetAimAngles( ent )

    return not (AimAngles.p >= -10 or AimAngles.p <= -180)
end

function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Delay = 0.25
	weapon.HeatRateUp = .34
	weapon.HeatRateDown = .5
	weapon.Attack = function( ent )
        if not ent:GetVehicle():WeaponsInRange( ent ) then return true end
		local base = ent:GetVehicle()

		local ID_1 = self:LookupAttachment( "muzzle1" )
		local ID_2 = self:LookupAttachment( "muzzle2" )
		local Muzzle1 = self:GetAttachment( ID_1 )
		local Muzzle2 = self:GetAttachment( ID_2 )

		if not Muzzle1 or not Muzzle2 then return end		

		ent.MirrorPrimary = not ent.MirrorPrimary

		local Pos = ent.MirrorPrimary and Muzzle1.Pos or Muzzle2.Pos
		local Dir =  (ent.MirrorPrimary and Muzzle1.Ang or Muzzle2.Ang):Up()

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.025,  0.025, 0.025 )
		bullet.TracerName = "lvs_laser_red"
		bullet.Force	= 100
		bullet.HullSize 	= 50
		bullet.Damage	= 35
		bullet.Velocity = 50000
		bullet.SplashDamage	= 70
		bullet.SplashDamageRadius	= 250
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(255,50,50) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_explosion", effectdata )
		end

		local effectdata = EffectData()
		effectdata:SetStart( Vector(255,50,50) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )

		base.PrimarySND:PlayOnce( 100 + math.Rand(-3,3), 1 )
		ent:LVSFireBullet( bullet )
		
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav")end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.OnThink = function( ent, active )	
		if ent:GetVehicle():GetIsCarried( ent ) then
			self:SetPoseParameter("turret_pitch", 0 )
			self:SetPoseParameter("turret_yaw", 0 )
		end
		
		local AimAngles = self:GetAimAngles( ent )

		self:SetPoseParameter("turret_pitch", AimAngles.p )
		self:SetPoseParameter("turret_yaw", AimAngles.y )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local Pos2D = base:TraceTurret().HitPos:ToScreen()

		base:PaintCrosshairCenter( Pos2D, color_white )
		base:PaintCrosshairOuter( Pos2D, color_white )
		base:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, 2 )
	
	
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/dual_mg.png")
	weapon.Delay = 0.1
	weapon.HeatRateUp = .2
	weapon.HeatRateDown = .5
	weapon.Attack = function( ent )
        if not ent:GetVehicle():WeaponsInRange( ent ) then return true end
		local pod = ent:GetDriverSeat()
		local dir = ent:GetAimVector()
		local trace = ent:GetEyeTrace()
		local base = ent:GetVehicle()

		local ID_1 = self:LookupAttachment( "muzzle1" )
		local ID_2 = self:LookupAttachment( "muzzle2" )
		local Muzzle1 = self:GetAttachment( ID_1 )
		local Muzzle2 = self:GetAttachment( ID_2 )

		if not Muzzle1 or not Muzzle2 then return end

		ent.MirrorPrimary = not ent.MirrorPrimary

		local Pos = ent.MirrorPrimary and Muzzle1.Pos or Muzzle2.Pos
		local Dir =  (ent.MirrorPrimary and Muzzle1.Ang or Muzzle2.Ang):Up()

		ent.SwapTopBottom = not ent.SwapTopBottom

		base.SecondarySND:PlayOnce( 100 + math.Rand(-3,3), 1 )

		local bullet = {}
		bullet.Src = Pos
		bullet.Dir = Dir
		bullet.Spread 	= Vector( 0.07,  0.07, 0.07 )
		bullet.TracerName = "lvs_laser_red"
		bullet.Force	= 10
		bullet.HullSize 	= 25
		bullet.Damage	= 20
		bullet.Velocity = 50000
		--bullet.SplashDamage	= 20
		--bullet.SplashDamageRadius	= 200
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(255,50,50) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_explosion", effectdata )
		end

		local effectdata = EffectData()
		effectdata:SetStart( Vector(255,50,50) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )
		
		ent:LVSFireBullet( bullet )
	end
	
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav")end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local Pos2D = base:TraceTurret().HitPos:ToScreen()

		base:PaintCrosshairCenter( Pos2D, color_white )
		base:PaintCrosshairOuter( Pos2D, color_white )
		base:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, 2 )
end

ENT.DeathSound = "lvs/vehicles/generic_starfighter/crash.wav"