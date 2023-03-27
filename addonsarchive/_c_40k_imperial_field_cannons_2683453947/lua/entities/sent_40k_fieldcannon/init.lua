-- ==========================================
-- Init
-- ==========================================

AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:SpawnFunction(ply, tr, ClassName)
    if not tr.Hit then return end

    local ent = ents.Create(ClassName)
    ent:SetPos(tr.HitPos + tr.HitNormal * 25)
    ent:Spawn()
    ent:Activate()

    return ent
end

function ENT:Initialize()
    if (CLIENT) then return end

    self:SetModel("models/ordoredactus/wheelchairs/40k_fieldgun.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    self:InitGunnerSeat1()
	self:InitGunnerSeat2()
    
    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then 
        phys:Wake() 
        phys:EnableDrag(true)
        --phys:EnableGravity(false)
        phys:SetDamping(2, 0)
        phys:SetAngleDragCoefficient(0)
    end

    self.Deployed = false

    self.AimAttachmentList = { "fieldcannon_muzzle", "autocannon_muzzle", "bolter_muzzle", "assaultcannon_muzzle", "multilaser_muzzle", "lascannon_muzzle", "plasmacannon_muzzle" }
    self.Weapon = self:GetBodygroup(2)

    self.AimMode = 0
    self:SetNWFloat("AimMode", AimMode, 0)

    self.Ready = true
    self.ReloadTime = 0
    self.BolterAmmo = 200

    self.AmmoTypeFieldcannon = { "Frag", "HE", "HEAT", "TB", "Buckshot"}
    self.CurrentAmmoTypeFieldcannon = 1
    self:SetNWString("AmmoTypeFieldcannon", self.AmmoTypeFieldcannon[1], 0)

    self.AutocannonAmmo = 6
    self:SetNWFloat("AutocannonAmmo", self.AutocannonAmmo, 0)

    self.ModePlasmacannon = { "Safe", "Charge", "Overcharge" }
    self.CurrentModePlasmacannon = 1
    self:SetNWString("ModePlasmacannon", self.ModePlasmacannon[1], 0)
    self.Heat = 0
    self.CanExplode = true

    self:SetHealth( 8000 )
end

function ENT:OnTakeDamage( dmginfo )
	if dmginfo:GetDamage() > 200 then
		self:SetHealth( self:Health() - (dmginfo:GetDamage() - 100 ))
	end
	if self:Health() < 0 then 
		local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )
		util.Effect( "fieldcannon_explosion_medium", effectdata )
		self:Remove() 
	end
end

function ENT:InitGunnerSeat1()
	local seat = ents.Create("prop_vehicle_prisoner_pod")
	seat:SetModel("models/props_junk/sawblade001a.mdl")
	seat:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	seat:SetKeyValue("limitview", 0)
	seat:SetMoveType( MOVETYPE_VPHYSICS )
	seat:Spawn()
	seat:Activate()
	seat:SetPos(self:GetPos())
	seat:SetAngles(self:GetAngles())
	seat:SetParent(self)
	seat:SetLagCompensated( false )
	seat:SetLocalPos(Vector(-52,-33,0))
	seat:SetLocalAngles(Angle(0,0,0))
	seat:DrawShadow(false)
	seat:SetNoDraw(true)
	seat:SetNotSolid(true)
	seat:SetCollisionGroup(COLLISION_GROUP_NONE)

	self.GunnerSeat1 = seat
end

function ENT:InitGunnerSeat2()
	local seat = ents.Create("prop_vehicle_prisoner_pod")
	seat:SetModel("models/props_junk/sawblade001a.mdl")
	seat:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
	seat:SetKeyValue("limitview", 0)
	seat:SetMoveType( MOVETYPE_VPHYSICS )
	seat:Spawn()
	seat:Activate()
	seat:SetPos(self:GetPos())
	seat:SetAngles(self:GetAngles())
	seat:SetParent(self)
	seat:SetLagCompensated( false )
	seat:SetLocalPos(Vector(-49,33,0))
	seat:SetLocalAngles(Angle(0,0,0))
	seat:DrawShadow(false)
	seat:SetNoDraw(true)
	seat:SetNotSolid(true)
	seat:SetCollisionGroup(COLLISION_GROUP_NONE)

	self.GunnerSeat2 = seat
end

-- ==========================================
-- Stuff
-- ==========================================

function ENT:Use(activator, caller, useType, value)
	local DistanceToSeat1 = (self.GunnerSeat1:GetPos()):Distance(activator:GetPos())
	local DistanceToSeat2 = (self.GunnerSeat2:GetPos()):Distance(activator:GetPos())
	if DistanceToSeat2 < DistanceToSeat1 then 
		activator:EnterVehicle(self.GunnerSeat2)
	elseif DistanceToSeat2 > DistanceToSeat1 then
		activator:EnterVehicle(self.GunnerSeat1)
	end
end

function ENT:HandleMovementAnims( phy )
	local MovementDiff = math.abs(math.abs(self:GetForward():Angle().y)-math.abs((phy:GetVelocity():GetNormalized():Angle().y)))
	local Multiplier = 0
	if MovementDiff <= 30 then Multiplier = 1 elseif MovementDiff >= 150 then Multiplier = -1 end

	self:SetNWFloat("HorizontalMovement", (math.Remap(phy:GetAngleVelocity().r, -4, 4, -1, 1 )))
	self:SetNWFloat("FrontalMovement", (math.Remap(phy:GetVelocity():Length()*Multiplier, -80, 80, -1, 1 )))
	
	self:SetPoseParameter("wheel_left", self:GetPoseParameter("wheel_left")-(math.Remap(phy:GetVelocity():Length()*Multiplier, -60, 60, -1, 1 )))
	self:SetPoseParameter("wheel_right", self:GetPoseParameter("wheel_right")+(math.Remap(phy:GetVelocity():Length()*Multiplier, -60, 60, -1, 1 )))
end


function ENT:Think()
	local phy = self:GetPhysicsObject()
	local Gunner1 = self.GunnerSeat1:GetPassenger(1)
	local Gunner2 = self.GunnerSeat2:GetPassenger(1)

	self:TryEject( Gunner1, Gunner2, phy )

	if self.Heat > 0 then self.Heat = self.Heat - ( 0.1 * 66/(1/FrameTime()) ) end
	if self.Heat > 100 then self:PlasmaCannonExplode() else self.CanExplode = true end
	self:SetPoseParameter("graph", self.Heat - 50 )

	self.Weapon = self:GetBodygroup(2)
	self:SetNWFloat("Weapon", self.Weapon, 0)
	self:SetNWString("AimAttachment", self.AimAttachmentList[self.Weapon + 1 ], 0)
	self:SetNWFloat("BolterAmmo", self.BolterAmmo, 0)
	self:SetNWFloat("ReloadTime", self.ReloadTime, 0)
	self:SetNWBool("Ready", self.Ready, false)

	self:HandleMovementAnims( phy )
	
	if IsValid(Gunner1) then
		local inputForward1, inputReverse1, inputLeft1, inputRight1, inputReload1, inputDeploy1, inputAttack1, inputCamera1

	        inputForward1 = Gunner1:KeyDown(IN_FORWARD)
	        inputReverse1 = Gunner1:KeyDown(IN_BACK)
	        inputLeft1 = Gunner1:KeyDown(IN_MOVELEFT)
	        inputRight1 = Gunner1:KeyDown(IN_MOVERIGHT)
	        inputReload1 = Gunner1:KeyPressed(IN_RELOAD)
	        inputDeploy1 = Gunner1:KeyPressed(IN_JUMP)
	        inputAttack1 = Gunner1:KeyDown(IN_ATTACK)
	        inputCamera = Gunner1:KeyPressed(IN_ATTACK2)

	    local slopeAdjust = 0
	    if self:GetAngles().x < 0 then
	        slopeAdjust = self:GetAngles().x * -12000
	    end

	    local accForce = 210000 + slopeAdjust
	    local avForce = 3000
	    if (inputForward1) then
	        phy:ApplyForceCenter(self:GetForward() * accForce * FrameTime())
	    elseif (inputReverse1) then
	        phy:ApplyForceCenter(self:GetForward() * accForce * -1 * FrameTime())
	    end

	    if (inputLeft1) then
	        phy:AddAngleVelocity(-phy:GetAngleVelocity() + Vector(0, 0, avForce * FrameTime()))
	    elseif (inputRight1) then
	        phy:AddAngleVelocity(-phy:GetAngleVelocity() + Vector(0, 0, -avForce * FrameTime()))
	    else
	    	phy:SetVelocity(phy:GetVelocity() * 0.95)
	    	phy:AddAngleVelocity(-phy:GetAngleVelocity())
	    end

	    if (inputAttack1) then
	    	self:FireWeapon( Gunner1, phy )
	    end

	    if (inputReload1) then
	    	self:ReloadWeapon( Gunner1, Gunner2 )
	    end

	    if (inputDeploy1) then
			self:ToggleDeployed()
		end

		if (inputCamera) then
			self.AimMode = self.AimMode + 1
			if self.AimMode == 2 then self.AimMode = 0 end
			self:SetNWFloat("AimMode", self.AimMode, 0)
		end

		self:AimWeapon( Gunner1, phy)
	end

	if IsValid(Gunner2) then
		local inputForward2, inputReverse2, inputLeft2, inputRight2, inputDeploy2

	        inputForward2 = Gunner2:KeyDown(IN_FORWARD)
	        inputReverse2 = Gunner2:KeyDown(IN_BACK)
	        inputLeft2 = Gunner2:KeyDown(IN_MOVELEFT)
	        inputRight2 = Gunner2:KeyDown(IN_MOVERIGHT)
	        inputDeploy2 = Gunner2:KeyPressed(IN_JUMP)

	    local slopeAdjust = 0
	    if self:GetAngles().x < 0 then
	        slopeAdjust = self:GetAngles().x * -12000
	    end

	    local accForce = 210000 + slopeAdjust
	    local avForce = 3000
	    if (inputForward2) then
	        phy:ApplyForceCenter(self:GetForward() * accForce * FrameTime())
	    elseif (inputReverse2) then
	        phy:ApplyForceCenter(self:GetForward() * accForce * -1 * FrameTime())
	    end

	    if (inputLeft2) then
	        phy:AddAngleVelocity(-phy:GetAngleVelocity() + Vector(0, 0, avForce * FrameTime()))
	    elseif (inputRight2) then
	        phy:AddAngleVelocity(-phy:GetAngleVelocity() + Vector(0, 0, -avForce * FrameTime()))
	    else
	    	phy:SetVelocity(phy:GetVelocity() * 0.95)
	    	phy:AddAngleVelocity(-phy:GetAngleVelocity())
	    end

	    if (inputDeploy2) then
			self:ToggleDeployed()
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:ReloadWeapon( Gunner1 )
	if self.Weapon == 0 then
		self:ChangeAmmoTypeFieldCannon( Gunner1, Gunner2 )
	elseif self.Weapon == 2 or self.Weapon == 3 then
		self:ReloadBolterAmmo()
	elseif self.Weapon == 6 then
		self:ChangeModePlasmacannon( Gunner1, Gunner2 )
	end
end

function ENT:ChangeAmmoTypeFieldCannon( )
	if not self.Ready then return end
	self.Ready = false
	self.CurrentAmmoTypeFieldcannon = self.CurrentAmmoTypeFieldcannon + 1
	if self.CurrentAmmoTypeFieldcannon == 6 then self.CurrentAmmoTypeFieldcannon = 1 end
	self:SetNWString("AmmoTypeFieldcannon", self.AmmoTypeFieldcannon[self.CurrentAmmoTypeFieldcannon], 0)
	self:AddGestureSequence( self:LookupSequence( "fieldcannon_reload"), 1 )
	self.ReloadTime = CurTime() + 4
	self:RateOfFire( self, CurTime() + 4 )
	timer.Simple( 4, function()
		self.Ready = true
	end)
	self:EmitSound("fieldgun_fieldcannon_reload")
end 

function ENT:ReloadBolterAmmo()
	if not self.Ready then return end
	self.Ready = false
		self.ReloadTime = CurTime() + 10
		self:RateOfFire( self, CurTime() + 10 )
		timer.Simple( 8.3, function()
			if IsValid( self ) then
				self:EmitSound("fieldgun_bolter_reload")
			end
		end)
		timer.Simple( 10, function()
			if IsValid( self ) then
				self.BolterAmmo = 200
				self.Ready = true
			end
		end)
end

function ENT:ToggleDeployed(activator, caller, useType, value)
	if not self.Deployed then
		self:SetSequence(self:LookupSequence("legs_down_deployed"))
		self.Deployed = true
		self:GetPhysicsObject():EnableMotion( false )
		self:EmitSound("40k_fieldgun_deploy")
	elseif self.Deployed then
		self:SetSequence(self:LookupSequence("legs_down_stowed"))
		self.Deployed = false
		self:GetPhysicsObject():EnableMotion( true )
		self:EmitSound("40k_fieldgun_undeploy")
	end
end

function ENT:TryEject( Gunner1, Gunner2, phy )
	if phy:GetVelocity():Length() > 400 then
		if IsValid(Gunner1) then
			Gunner1:ExitVehicle()
		end
		if IsValid(Gunner2) then
			Gunner2:ExitVehicle()
		end
	end
end

-- ==========================================
-- Aiming
-- ==========================================

function ENT:AimWeapon( Gunner1, phy )
	local Aimang = self:WorldToLocalAngles( Gunner1:EyeAngles() )
		Aimang:Normalize()
		
		local AimRate = 60
		
		local Angles = Aimang
		
		self.sm_pp_yaw = self.sm_pp_yaw and math.ApproachAngle( self.sm_pp_yaw, Angles.y, AimRate * FrameTime() ) or 0
		self.sm_pp_pitch = self.sm_pp_pitch and math.ApproachAngle( self.sm_pp_pitch, Angles.p, AimRate/2 * FrameTime() ) or 0
		
		local TargetAng = Angle(self.sm_pp_pitch,self.sm_pp_yaw,0)
		TargetAng:Normalize() 

		self:SetPoseParameter("cannon_yaw",  -TargetAng.y )
		self:SetPoseParameter("cannon_pitch", -TargetAng.p - 7 + self:GetAngles().p  )
end

-- ==========================================
-- Weapons
-- ==========================================

function ENT:FireWeapon( Gunner1, phy )
	if self.Weapon == 0 then
		self:FireFieldCannon( Gunner1, phy )
	elseif self.Weapon == 1 then
		self:FireAutocannon( Gunner1, phy )
	elseif self.Weapon == 2 then
		self:FireBolter( Gunner1, phy )
	elseif self.Weapon == 3 then
		self:FireAssaultCannon( Gunner1, phy )
	elseif self.Weapon == 4 then
		self:FireMultilaser( Gunner1, phy )
	elseif self.Weapon == 5 then
		self:FireLascannon( Gunner1, phy )
	elseif self.Weapon == 6 then
		self:FirePlasmacannon( Gunner1, phy )
	end
end

function ENT:FireFieldCannon( Gunner1, phy )
	if not self:CanAttack( self ) then return end
	local ID = self:LookupAttachment("fieldcannon_muzzle")
	local Attachment = self:GetAttachment( ID )
	self:EmitSound("fieldgun_fieldcannon")
	local effectdata = EffectData()
		effectdata:SetOrigin( Attachment.Pos )
		effectdata:SetAngles( Attachment.Ang )
		effectdata:SetEntity( self )
		effectdata:SetAttachment( ID )
		effectdata:SetScale( 6 )
	util.Effect( "MuzzleEffect", effectdata, true, true )
	self:GetPhysicsObject():ApplyForceOffset( -Attachment.Ang:Forward() * 50000, Attachment.Pos ) 
	self:AddGestureSequence( self:LookupSequence( "fieldcannon_fire"), 1 )
	util.ScreenShake( self:GetPos(), 1000, 500, 1, 400 )

	if self.CurrentAmmoTypeFieldcannon == 1 then
 		FieldCannonFrag( Gunner1, Attachment.Pos, Attachment.Ang )
	elseif self.CurrentAmmoTypeFieldcannon == 2 then
		FieldCannonHE( Gunner1, Attachment.Pos, Attachment.Ang )
	elseif self.CurrentAmmoTypeFieldcannon == 3 then
		FieldCannonHEAT( Gunner1, Attachment.Pos, Attachment.Ang )
	elseif self.CurrentAmmoTypeFieldcannon == 4 then
		FieldCannonTB( Gunner1, Attachment.Pos, Attachment.Ang )
	elseif self.CurrentAmmoTypeFieldcannon == 5 then
		self:FieldCannonBuckshot( Gunner1, Attachment.Pos, Attachment.Ang )
	end

	self.Ready = false
	self.ReloadTime = CurTime() + 5
	self:RateOfFire( self, CurTime() + 5 )
	timer.Simple( 5, function()
		if IsValid( self ) then
			self.Ready = true
		end
	end)
	timer.Simple( 0.5, function()
		if IsValid( self ) then
			self:EmitSound("fieldgun_fieldcannon_reload")
		end
	end)
end

function FieldCannonFrag( Gunner1, Pos, Ang )
	local projectile = ents.Create( "sent_40k_fieldcannon_projectile" )
	projectile:SetPos( Pos )
	projectile:SetAngles( Ang )
	projectile.Attacker = Gunner1
	projectile.AttackingEnt = self
	projectile.MoveSpeed = 128
	projectile.Faloff = 0.15
	projectile.Force = 100
	projectile.Damage = 1500
	projectile.BlastRadius = 384
	projectile.BlastDamage = 500
	projectile:SetBlastEffect( "fieldcannon_explosion_medium" )
	projectile:SetSize(8)
	projectile:Spawn()
	projectile:Activate()
end

function FieldCannonHE( Gunner1, Pos, Ang )
	local projectile = ents.Create( "sent_40k_fieldcannon_projectile" )
	projectile:SetPos( Pos )
	projectile:SetAngles( Ang )
	projectile.Attacker = Gunner1
	projectile.AttackingEnt = self
	projectile.MoveSpeed = 128
	projectile.Faloff = 0.15
	projectile.Force = 100
	projectile.Damage = 1500
	projectile.BlastRadius = 256
	projectile.BlastDamage = 1500
	projectile:SetBlastEffect( "fieldcannon_explosion_medium" )
	projectile:SetSize(8)
	projectile:Spawn()
	projectile:Activate()
end

function FieldCannonHEAT( Gunner1, Pos, Ang )
	local projectile = ents.Create( "sent_40k_fieldcannon_projectile" )
	projectile:SetPos( Pos )
	projectile:SetAngles( Ang )
	projectile.Attacker = Gunner1
	projectile.AttackingEnt = self
	projectile.MoveSpeed = 128
	projectile.Faloff = 0.15
	projectile.Force = 100
	projectile.Damage = 5000
	projectile.BlastRadius = 64
	projectile.BlastDamage = 500
	projectile:SetBlastEffect( "fieldcannon_explosion_small" )
	projectile:SetSize(8)
	projectile:Spawn()
	projectile:Activate()
end

function FieldCannonTB( Gunner1, Pos, Ang )
	local projectile = ents.Create( "sent_40k_fieldcannon_projectile" )
	projectile:SetPos( Pos )
	projectile:SetAngles( Ang )
	projectile.Attacker = Gunner1
	projectile.AttackingEnt = self
	projectile.MoveSpeed = 128
	projectile.Faloff = 0.15
	projectile.Force = 100
	projectile.Damage = 1250
	projectile.BlastRadius = 384
	projectile.BlastDamage = 500
	projectile:SetBlastEffect( "fieldcannon_explosion_thermobaric" )
	projectile:SetSize(8)
	projectile.IsTB = true
	projectile.TBRadius = 512
	projectile.TBDamage = 200
	projectile:Spawn()
	projectile:Activate()
end

function ENT:FieldCannonBuckshot( Gunner1, Pos, Ang )
	local bullet = {}
		bullet.Num 			= 32
		bullet.Src 			= Pos
		bullet.Dir 			= Ang:Forward()
		bullet.Spread 		= Vector(0.07,0.07,0.07)
		bullet.Tracer		= 1
		bullet.TracerName	= "fieldcannon_tracer"
		bullet.Force		= 1
		bullet.Damage		= 200
		bullet.HullSize		= 1
		bullet.Attacker 	= Gunner1
		bullet.Callback = function(att, tr, dmginfo)
	end
	self:FireBullets( bullet )
end

function ENT:FireAutocannon( Gunner1, phy )
	if not self:CanAttack( self ) then return end
	local ID = self:LookupAttachment("autocannon_muzzle")
	local Attachment = self:GetAttachment( ID )
	self:EmitSound("fieldgun_autocannon")
	local effectdata = EffectData()
		effectdata:SetOrigin( Attachment.Pos )
		effectdata:SetAngles( Attachment.Ang )
		effectdata:SetEntity( self )
		effectdata:SetAttachment( ID )
		effectdata:SetScale( 5 )
	util.Effect( "MuzzleEffect", effectdata, true, true )
	self:GetPhysicsObject():ApplyForceOffset( -Attachment.Ang:Forward() * 10000, Attachment.Pos ) 
	self:AddGestureSequence( self:LookupSequence( "autocannon_fire"), 1 )
	self:SetPoseParameter("autocannon_rounds", self:GetPoseParameter("autocannon_rounds") + 1)
	self:RateOfFire( self, CurTime() + 0.8 )
	
	self:SetPoseParameter("autocannon_rounds", 7 - self.AutocannonAmmo)

 	Autocannon( Gunner1, Attachment.Pos, Attachment.Ang )

	self.AutocannonAmmo = self.AutocannonAmmo - 1
	self:SetNWFloat("AutocannonAmmo", self.AutocannonAmmo, 0)
	if self.AutocannonAmmo > 0 then
		self.ReloadTime = CurTime() + 0.8
	elseif self.AutocannonAmmo == 0 then
		self.Ready = false
		self:SetNWBool("Ready", self.Ready, false)
		self:RateOfFire( self, CurTime() + 6 )
		self.ReloadTime = CurTime() + 6
		timer.Simple( 4, function()
			if IsValid( self ) then
				self:EmitSound("fieldgun_bolter_reload")
				self:AddGestureSequence( self:LookupSequence("autocannon_reload"), 1 )
			end
		end)
		timer.Simple( 6, function()
			if IsValid( self ) then
				self.AutocannonAmmo = 6
				self:SetNWFloat("AutocannonAmmo", self.AutocannonAmmo, 0)
				self:SetPoseParameter("autocannon_rounds", 6 - self.AutocannonAmmo)
				self.Ready = true
			end
		end)
	end
end

function Autocannon( Gunner1, Pos, Ang )
	local projectile = ents.Create( "sent_40k_fieldcannon_projectile" )
	projectile:SetPos( Pos )
	projectile:SetAngles( Ang )
	projectile.Attacker = Gunner1
	projectile.AttackingEnt = self
	projectile.MoveSpeed = 256
	projectile.Faloff = 0.05
	projectile.Force = 100
	projectile.Damage = 2000
	projectile.BlastRadius = 128
	projectile.BlastDamage = 500
	projectile:SetBlastEffect( "fieldcannon_explosion_small" )
	projectile:SetSize(6)
	projectile:Spawn()
	projectile:Activate()
end

function ENT:FireBolter( Gunner1, phy )
	if not self:CanAttack( self ) then return end
	local ID = self:LookupAttachment("bolter_muzzle")
	local Attachment = self:GetAttachment( ID )
	local ID2 = self:LookupAttachment("bolter_ejectport")
	local Attachment2 = self:GetAttachment( ID2 )
	self:EmitSound("fieldgun_bolter" )
	local effectdata = EffectData()
		effectdata:SetOrigin( Attachment.Pos )
		effectdata:SetAngles( Attachment.Ang )
		effectdata:SetEntity( self )
		effectdata:SetAttachment( ID )
		effectdata:SetScale( 4 )
	util.Effect( "MuzzleEffect", effectdata, true, true )
	local effectdata2 = EffectData()
		effectdata2:SetOrigin( Attachment2.Pos )
		effectdata2:SetAngles( Attachment2.Ang )
		effectdata2:SetEntity( self )
		effectdata2:SetScale( 1 )
	util.Effect( "ShellEject", effectdata2, true, true )
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= Attachment.Pos
		bullet.Dir 			= Attachment.Ang:Forward()
		bullet.Spread 		= Vector(0.008,0.008,0.008)
		bullet.Tracer		= 1
		bullet.TracerName	= "bolter_tracer"
		bullet.Force		= 100
		bullet.Damage		= 200
		bullet.HullSize		= 10
		bullet.Attacker 	= Gunner1
		bullet.Callback = function(att, tr, dmginfo)
		end
	self:FireBullets( bullet )
	self.BolterAmmo = self.BolterAmmo - 1
	self:SetNWFloat("BolterAmmo", self.BolterAmmo, 0)
	if self.BolterAmmo == 0 then
		self:ReloadBolterAmmo()
	else
		self:RateOfFire( self, CurTime() + 0.12 )
	end
end

function ENT:FireAssaultCannon( Gunner1, phy )
	if not self:CanAttack( self ) then return end
	local ID = self:LookupAttachment("assaultcannon_muzzle")
	local Attachment = self:GetAttachment( ID )
	local ID2 = self:LookupAttachment("assaultcannon_ejectport")
	local Attachment2 = self:GetAttachment( ID2 )
	self:EmitSound("fieldgun_assaultcannon" )
	local effectdata = EffectData()
		effectdata:SetOrigin( Attachment.Pos )
		effectdata:SetAngles( Attachment.Ang )
		effectdata:SetEntity( self )
		effectdata:SetAttachment( ID )
		effectdata:SetScale( 2 )
	util.Effect( "MuzzleEffect", effectdata, true, true )
	local effectdata2 = EffectData()
		effectdata2:SetOrigin( Attachment2.Pos )
		effectdata2:SetAngles( Attachment2.Ang )
		effectdata2:SetEntity( self )
		effectdata2:SetScale( 1 )
	util.Effect( "RifleShellEject", effectdata2, true, true )
	self:AddGestureSequence( self:LookupSequence( "assaultcannon_fire"), 1 )
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= Attachment.Pos
		bullet.Dir 			= Attachment.Ang:Forward()
		bullet.Spread 		= Vector(0.02,0.02,0.02)
		bullet.Tracer		= 1
		bullet.TracerName	= "heavystubber_tracer"
		bullet.Force		= 100
		bullet.Damage		= 120
		bullet.HullSize		= 5
		bullet.Attacker 	= Gunner1
		bullet.Callback = function(att, tr, dmginfo)
		end
	self:FireBullets( bullet )
	self.BolterAmmo = self.BolterAmmo - 1
	self:SetNWFloat("BolterAmmo", self.BolterAmmo, 0)
	if self.BolterAmmo == 0 then
		self:ReloadBolterAmmo()
	else
		self:RateOfFire( self, CurTime() + 0.08 )
	end
end

function ENT:FireMultilaser( Gunner1, phy )
	if not self:CanAttack( self ) then return end
	local ID = self:LookupAttachment("multilaser_muzzle")
	local Attachment = self:GetAttachment( ID )
	self:EmitSound("fieldgun_multilaser" )

	local effectdata = EffectData()
		effectdata:SetOrigin( Attachment.Pos+Attachment.Ang:Forward()*6 )
		effectdata:SetScale( 1 )
	util.Effect( "effect_lasermuzzle", effectdata, true, true )
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= Attachment.Pos
		bullet.Dir 			= Attachment.Ang:Forward()
		bullet.Spread 		= Vector(0,0,0)
		bullet.Tracer		= 1
		bullet.TracerName	= "effect_tanklaser_small"
		bullet.Force		= 100
		bullet.Damage		= 250
		bullet.HullSize		= 1
		bullet.Attacker 	= Gunner1
		bullet.Callback = function(att, tr, dmginfo)
		end
	self:FireBullets( bullet )
	self:RateOfFire( self, CurTime() + 0.12 )
end

function ENT:FireLascannon( Gunner1, phy )
	if not self:CanAttack( self ) then return end
	local ID = self:LookupAttachment("lascannon_muzzle")
	local Attachment = self:GetAttachment( ID )
	self:EmitSound("fieldgun_lascannon_fire" )
	local bullet = {}
		bullet.Num 			= 1
		bullet.Src 			= Attachment.Pos
		bullet.Dir 			= Attachment.Ang:Forward()
		bullet.Spread 		= Vector(0,0,0)
		bullet.Tracer		= 1
		bullet.TracerName	= "effect_tanklaser_medium"
		bullet.Force		= 100
		bullet.Damage		= 7500
		bullet.HullSize		= 1
		bullet.Attacker 	= Gunner1
		bullet.Callback = function(att, tr, dmginfo)
		end
	self:FireBullets( bullet )
	local effectdata = EffectData()
		effectdata:SetOrigin( Attachment.Pos+Attachment.Ang:Forward()*6 )
		effectdata:SetScale( 1 )
	util.Effect( "effect_lasermuzzle", effectdata, true, true )
	self.Ready = false
	self.ReloadTime = 
	self:SetNWBool("Ready", self.Ready, false)
	self.ReloadTime = CurTime() + 6
	self:RateOfFire( self, CurTime() + 6 )
	timer.Simple( 4.5, function()
		if IsValid( self ) then
			self:EmitSound("fieldgun_lascannon_reload")
		end
	end)
	timer.Simple( 6, function()
		if IsValid( self ) then
			self.Ready = true
		end
	end)
end

function ENT:FirePlasmacannon( Gunner1, phy )
	if self.CurrentModePlasmacannon == 1 then
		if not self:CanAttack( self ) then return end
		local ID = self:LookupAttachment("plasmacannon_muzzle")
		local Attachment = self:GetAttachment( ID )
		self:EmitSound("fieldgun_plasmacannon")
		
	 	PlasmaCannonSafe( Gunner1, Attachment.Pos, Attachment.Ang )

	 	local effectdata = EffectData()
		effectdata:SetOrigin( Attachment.Pos )
		effectdata:SetAngles( Attachment.Ang )
		effectdata:SetEntity( self )
		effectdata:SetAttachment( ID )
		effectdata:SetScale( 6 )
		util.Effect( "effect_plasmamuzzle_small", effectdata, true, true )

		self.Ready = false
		self.Heat = self.Heat + 30
		self.ReloadTime = CurTime() + 3
		self:RateOfFire( self, CurTime() + 3 )
		timer.Simple( 3, function()
			if IsValid( self ) then
				self.Ready = true
			end
		end)
		timer.Simple( 2, function()
			if IsValid( self ) then
				self:EmitSound("fieldgun_plasmacannon_reload")
			end
		end)
	elseif self.CurrentModePlasmacannon == 2 then
		if not self:CanAttack( self ) then return end
		local ID = self:LookupAttachment("plasmacannon_muzzle")
		self:EmitSound("fieldgun_plasmacannon_charge")

		self.Ready = false
		self.ReloadTime = CurTime() + 6
		self:RateOfFire( self, CurTime() + 6 )

		timer.Simple( 2.7, function()
			if IsValid( self ) then
				local Attachment = self:GetAttachment( ID )
			 	PlasmaCannonCharged( Gunner1, Attachment.Pos, Attachment.Ang )

			 	local effectdata = EffectData()
				effectdata:SetOrigin( Attachment.Pos )
				effectdata:SetAngles( Attachment.Ang )
				effectdata:SetEntity( self )
				effectdata:SetAttachment( ID )
				effectdata:SetScale( 6 )
				util.Effect( "effect_plasmamuzzle_small", effectdata, true, true )

				self.Heat = self.Heat + 60
				timer.Simple( 3.3, function()
					if IsValid( self ) then
						self.Ready = true
					end
				end)
			end
		end)
	elseif self.CurrentModePlasmacannon == 3 then
		if not self:CanAttack( self ) then return end
		local ID = self:LookupAttachment("plasmacannon_muzzle")
		self:EmitSound("fieldgun_plasmacannon_overcharge")
		self.Ready = false
		self.ReloadTime = CurTime() + 9
		self:RateOfFire( self, CurTime() + 9 )
		timer.Simple( 6, function()
			if IsValid( self ) then
				local Attachment = self:GetAttachment( ID )
			 	PlasmaCannonOvercharged( Gunner1, Attachment.Pos, Attachment.Ang )

			 	local effectdata = EffectData()
				effectdata:SetOrigin( Attachment.Pos )
				effectdata:SetAngles( Attachment.Ang )
				effectdata:SetEntity( self )
				effectdata:SetAttachment( ID )
				effectdata:SetScale( 12 )
				util.Effect( "effect_plasmamuzzle_small", effectdata, true, true )

				self.Heat = self.Heat + 80 + math.Rand(0, 15)
				timer.Simple( 3, function()
					if IsValid( self ) then
						self.Ready = true
					end
				end)
			end
		end)
	end
end

function PlasmaCannonSafe( Gunner1, Pos, Ang )
	local projectile = ents.Create( "sent_40k_fieldcannon_plasma" )
	projectile:SetPos( Pos )
	projectile:SetAngles( Ang )
	projectile.Attacker = Gunner1
	projectile.AttackingEnt = self
	projectile.MoveSpeed = 128
	projectile.Faloff = 0
	projectile.Force = 100
	projectile.Damage = 3000
	projectile.BlastRadius = 128
	projectile.BlastDamage = 500
	projectile:SetBlastEffect( "effect_plasmaexplosion_small" )
	projectile:SetSize(4)
	projectile:Spawn()
	projectile:Activate()
end

function PlasmaCannonCharged( Gunner1, Pos, Ang )
	local projectile = ents.Create( "sent_40k_fieldcannon_plasma" )
	projectile:SetPos( Pos )
	projectile:SetAngles( Ang )
	projectile.Attacker = Gunner1
	projectile.AttackingEnt = self
	projectile.MoveSpeed = 128
	projectile.Faloff = 0
	projectile.Force = 100
	projectile.Damage = 7500
	projectile.BlastRadius = 192
	projectile.BlastDamage = 2000
	projectile:SetBlastEffect( "effect_plasmaexplosion_small" )
	projectile:SetSize(8)
	projectile:Spawn()
	projectile:Activate()
end

function PlasmaCannonOvercharged( Gunner1, Pos, Ang )
	local projectile = ents.Create( "sent_40k_fieldcannon_plasma" )
	projectile:SetPos( Pos )
	projectile:SetAngles( Ang )
	projectile.Attacker = Gunner1
	projectile.AttackingEnt = self
	projectile.MoveSpeed = 72
	projectile.Faloff = 0
	projectile.Force = 10000
	projectile.Damage = math.Rand(16000, 24000)
	projectile.BlastRadius = 256
	projectile.BlastDamage = 4000
	projectile:SetBlastEffect( "effect_plasmaexplosion_big" )
	projectile:SetSize(16)
	projectile:Spawn()
	projectile:Activate()
end

function ENT:PlasmaCannonExplode()
	if not self.CanExplode then return end
	self.CanExplode = false
	local Gunner1 = self.GunnerSeat1:GetPassenger(1)
	local Gunner2 = self.GunnerSeat2:GetPassenger(1)

	if IsValid(Gunner1) then 
		Gunner1:ExitVehicle() 
		Gunner1:TakeDamage( 5000, Gunner1, self)
	end
	if IsValid(Gunner2) then 
		Gunner2:ExitVehicle()
		Gunner2:TakeDamage( 5000, Gunner2, self)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		effectdata:SetEntity( self )
	util.Effect( "effect_plasmaexplosion_big", effectdata, true, true )
	local Attacker = self
	if IsValid(Gunner1) then Attacker = Gunner1 end
	util.BlastDamage( Attacker, Attacker, self:GetPos(),256,6000)
end

function ENT:ChangeModePlasmacannon( )
	self.CurrentModePlasmacannon = self.CurrentModePlasmacannon + 1
	if self.CurrentModePlasmacannon == 4 then self.CurrentModePlasmacannon = 1 end
	self:SetNWString("ModePlasmacannon", self.ModePlasmacannon[self.CurrentModePlasmacannon], 0)
end 

function ENT:CanAttack( self )
	self.NextShot = self.NextShot or 0
	return self.NextShot < CurTime()
end

function ENT:RateOfFire( self, time )
	self.NextShot = time
end

