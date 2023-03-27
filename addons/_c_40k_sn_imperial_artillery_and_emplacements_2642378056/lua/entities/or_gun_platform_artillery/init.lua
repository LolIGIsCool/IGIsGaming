AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/ordoredactus/platforms/gun_platform_artillery.mdl")

	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_NONE)
	self:SetLagCompensated( false )

	self.PlatformFireMode = 0
	self:SetNWFloat( "PlatformFireMode", self.PlatformFireMode )
	self.Ready = false
	self:SetNWBool("Ready", self.Ready)
	self.ReloadTime = 0
	self:SetNWFloat("ReloadTime", self.ReloadTime)
	self.Cannon = self:GetBodygroup(3)
	self.AimAttachmentName = ""
	self.GunnerSeat1 = seat
	self.AmmoTypesBasilisk = { "High Explosive (HE)", "Incendiary (INC)", "Chemical (CM)"}
	self.CurrentAmmoTypeBasilisk = 1
	self.AmmoTypesMedusa = { "High Explosive (HE)", "Incendiary (INC)", "Chemical (CM)"}
	self.CurrentAmmoTypeMedusa = 1

	self:InitGunnerSeat1()
	self:InitGunnerSeat2()

	self:SetHealth(2500)
	self:SetMaxHealth(2500)

	util.PrecacheSound( "ordoredactus/artillery/artillery_incoming_1.wav" )
	self:EmitSound( "ordoredactus/artillery/artillery_incoming_1.wav" )
	self:StopSound( "ordoredactus/artillery/artillery_incoming_1.wav" )

	
	self.cam = ents.Create("or_gun_platform_camera")
    self.cam:SetPos(self:GetPos()+Vector(0,0,750))
    self.cam:Spawn()
    self:SetNWEntity( "Camera", self.cam )
    self.cam:Activate()
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
	seat:FollowBone(self, 2)
	seat:SetLagCompensated( false )
	seat:SetLocalPos(Vector(30,5,-83))
	seat:SetLocalAngles(Angle(0,0,-90))
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
	seat:FollowBone(self, 2)
	seat:SetLagCompensated( false )
	seat:SetLocalPos(Vector(-30,5,-53))
	seat:SetLocalAngles(Angle(-90,0,-90))
	seat:DrawShadow(false)
	seat:SetNoDraw(true)
	seat:SetNotSolid(true)
	seat:SetCollisionGroup(COLLISION_GROUP_NONE)

	self.GunnerSeat2 = seat
end

function ENT:Use(activator, caller, useType, value)
	if self.GunnerSeat1:GetPassenger( 1 ):IsValid() then
		activator:EnterVehicle(self.GunnerSeat2)
	else
		activator:EnterVehicle(self.GunnerSeat1)
	end
end

function ENT:Destroy()
	self:Remove()
end

function ENT:Think()
	local Gunner1 = self.GunnerSeat1:GetPassenger( 1 )
	local Gunner2 = self.GunnerSeat2:GetPassenger( 1 )
	if Gunner1:IsValid() and Gunner2:IsValid() then 
		self.ReloadTimeMultiplier = 0.5 
	else if Gunner1:IsValid() then
		self.ReloadTimeMultiplier = 1
	else self.ReloadTimeMultiplier = 1
	end
end
	self.Cannon = self:GetBodygroup( 3 )
	if self.Cannon == 0 then 
		self.AimAttachmentName = "basilisk_muzzle"
		self.Spread = 30

	elseif self.Cannon == 1 then 
		self.AimAttachmentName = "medusa_muzzle"
		self.Spread = 20
	end

	self:SetNWString( "AimAttachmentName", self.AimAttachmentName )
	self:SetNWFloat( "Spread", self.Spread )

	self.AimAttachment = self:GetAttachment(self:LookupAttachment( self.AimAttachmentName ))

	if Gunner1:IsValid() then

		self:ControlMode( Gunner1 )
		self:ControlAmmoType( Gunner1 )

		local trace = util.TraceLine( {
			start = self.cam:GetPos(),
			endpos = self.cam:GetPos() + Vector(0,0,-99999),
		} )

		if self.PlatformFireMode == 0 then
			if Gunner1:KeyDown(IN_ATTACK) and self.Ready then
				if self.Cannon == 0 then
					self:AttackTopDownBasilisk( Gunner1, trace )
				elseif self.Cannon == 1 then
					self:AttackTopDownMedusa( Gunner1, trace )
				end
			end
		else if self.PlatformFireMode == 1 then
			self:AimDirect( Gunner1, self.AimAttachment )
			if Gunner1:KeyDown(IN_ATTACK) then
				local trace = util.TraceLine( {
       				start = self.AimAttachment.Pos,
      				endpos = self.AimAttachment.Pos + self.AimAttachment.Ang:Forward()*999999,
     				filter = self,
  				  } )
				if self.Cannon == 0 then
					self:AttackDirectBasilisk( Gunner1 )
				elseif self.Cannon == 1 then
					self:AttackDirectMedusa( Gunner1 )
				end
			end
		else if self.PlatformFireMode == 2 and IsValid(Gunner1) then

			self.cam:ControlCamera( Gunner1 )
			self:AimTopDown( Gunner1, trace, self.AimAttachment )

			if Gunner1:KeyPressed(IN_JUMP) then
				Gunner1:PrintMessage(HUD_PRINTCENTER, "Camera reset!")
				self.cam:SetPos( self:GetPos()+ Vector (0,0,750))
			end

			if Gunner1:KeyDown(IN_ATTACK) and self.Ready then
				if self.Cannon == 0 then
					self:AttackTopDownBasilisk( Gunner1, trace )
				elseif self.Cannon == 1 then
					self:AttackTopDownMedusa( Gunner1, trace )
				end
			end

		end
		end
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:ControlMode( Gunner1 )
	if IsValid( Gunner1 ) then 
		if Gunner1:KeyPressed( IN_ATTACK2 ) and self.PlatformFireMode == 0 then
			self.PlatformFireMode = 1
			self:SetNWFloat( "PlatformFireMode", self.PlatformFireMode )
		else if Gunner1:KeyPressed( IN_ATTACK2 ) and self.PlatformFireMode == 1 then
			self.PlatformFireMode = 2
			self:SetNWFloat( "PlatformFireMode", self.PlatformFireMode )
		else if Gunner1:KeyPressed( IN_ATTACK2 ) and self.PlatformFireMode == 2 then
			self.PlatformFireMode = 0
			self:SetNWFloat( "PlatformFireMode", self.PlatformFireMode )
		end
		end
	end
	end
end

function ENT:ReloadEffects()
	self:StopSound("artillery_cannon_reload")
	self:EmitSound("artillery_cannon_reload")
	self:AddGestureSequence(self:LookupSequence("reload"))
end

function ENT:ControlAmmoType( Gunner1 )
	if Gunner1:KeyPressed(IN_RELOAD) then
		if not self:CanAttack(self) then return end
		if self.Cannon == 0 then
			if self.CurrentAmmoTypeBasilisk < 3 then
				self.CurrentAmmoTypeBasilisk = self.CurrentAmmoTypeBasilisk + 1
				Gunner1:PrintMessage(HUD_PRINTCENTER, "Loaded "..self.AmmoTypesBasilisk[self.CurrentAmmoTypeBasilisk].." shell!")
				self:RateOfFire( self, CurTime() + 7.5 * self.ReloadTimeMultiplier )
				self:ReloadEffects()
			elseif self.CurrentAmmoTypeBasilisk == 3 then
				self.CurrentAmmoTypeBasilisk = 1 
				Gunner1:PrintMessage(HUD_PRINTCENTER, "Loaded "..self.AmmoTypesBasilisk[self.CurrentAmmoTypeBasilisk].." shell!")
				self:RateOfFire( self, CurTime() + 7.5 * self.ReloadTimeMultiplier )
				self:ReloadEffects()
			end
		elseif self.Cannon == 1 then
			if self.CurrentAmmoTypeMedusa < 3 then
				self.CurrentAmmoTypeMedusa = self.CurrentAmmoTypeMedusa + 1
				Gunner1:PrintMessage(HUD_PRINTCENTER, "Loaded "..self.AmmoTypesMedusa[self.CurrentAmmoTypeMedusa].." shell!")
				self:RateOfFire( self, CurTime() + 15 * self.ReloadTimeMultiplier )
				self:ReloadEffects()
			else 
				self.CurrentAmmoTypeMedusa = 1
				Gunner1:PrintMessage(HUD_PRINTCENTER, "Loaded "..self.AmmoTypesMedusa[self.CurrentAmmoTypeMedusa].." shell!")
				self:RateOfFire( self, CurTime() + 15 * self.ReloadTimeMultiplier )
				self:ReloadEffects()
			end
		end
	end
end

-- ==========================================
-- Direct Aiming
-- ==========================================

function ENT:AimDirect( Gunner1 )
	if IsValid( Gunner1 ) then
		if Gunner1:KeyDown( IN_FORWARD ) then 
			self:SetPoseParameter("platform_pitch", math.Clamp(self:GetPoseParameter("platform_pitch")+0.1, -25, 25) )
			self:SetPoseParameter("valve_pitch", self:GetPoseParameter("valve_pitch")+0.3)
		elseif Gunner1:KeyDown( IN_BACK ) then
			self:SetPoseParameter("platform_pitch", math.Clamp(self:GetPoseParameter("platform_pitch")-0.1, -25, 25) )
			self:SetPoseParameter("valve_pitch", self:GetPoseParameter("valve_pitch")-0.3)
		elseif Gunner1:KeyDown( IN_MOVERIGHT ) then
			self:SetPoseParameter("platform_yaw", self:GetPoseParameter("platform_yaw")+0.3 )
			self:SetPoseParameter("valve_yaw", self:GetPoseParameter("platform_yaw")+1)
		elseif Gunner1:KeyDown( IN_MOVELEFT ) then
			self:SetPoseParameter("platform_yaw", self:GetPoseParameter("platform_yaw")-0.3 )
			self:SetPoseParameter("valve_yaw", self:GetPoseParameter("platform_yaw")-1)
		end
	end
end

function ENT:AttackDirectBasilisk( Gunner1 )
	if not self:CanAttack( self ) then return end
	local trace = util.TraceLine( {
        start = self.AimAttachment.Pos,
        endpos = self.AimAttachment.Pos + self.AimAttachment.Ang:Forward()*999999,
        filter = self,
    } )

    self:RateOfFire( self, CurTime() + 15 * self.ReloadTimeMultiplier )
    self.ShellType = self.CurrentAmmoTypeBasilisk
	self:AddGestureSequence(self:LookupSequence( "basilisk_fire"), 1)
	self:EmitSound("artillery_basilisk_shot")
	self:EmitSound("artillery_cannon_clang")

	self:DoShotEffects()

	timer.Simple( 1.3, function()
		self:EmitSound("artillery_cannon_reload")
	end)

	timer.Simple( (self.AimAttachment.Pos:Distance( trace.HitPos )/52.49344)/750, function()
		if self.ShellType == 1 then
				self:BasiliskHEExplosion( Gunner1, trace )
			elseif self.ShellType == 2 then
				self:BasiliskINCExplosion( Gunner1, trace )
			elseif self.ShellType == 3 then
				self:BasiliskCMExplosion( Gunner1, trace )
		end
	end)
end

function ENT:AttackDirectMedusa( Gunner1 )
	if not self:CanAttack( self ) then return end
	local trace = util.TraceLine( {
        start = self.AimAttachment.Pos,
        endpos = self.AimAttachment.Pos + self.AimAttachment.Ang:Forward()*999999,
        filter = self,
    } )

    self:RateOfFire( self, CurTime() + 30 * self.ReloadTimeMultiplier )
    self.ShellType = self.CurrentAmmoTypeMedusa
	self:AddGestureSequence(self:LookupSequence( "medusa_fire"), 1)
	self:EmitSound("artillery_medusa_shot")
	self:EmitSound("artillery_cannon_clang")
	self:DoShotEffects()

	timer.Simple( 1.5, function()
		self:EmitSound("artillery_cannon_reload")
	end)

	timer.Simple( (self.AimAttachment.Pos:Distance( trace.HitPos )/52.49344)/250, function()
		if self.ShellType == 1 then
				self:MedusaHEExplosion( Gunner1, trace )
			elseif self.ShellType == 2 then
				self:MedusaINCExplosion( Gunner1, trace )
			elseif self.ShellType == 3 then
				self:MedusaCMExplosion( Gunner1, trace )
			end
	end)
end

-- ==========================================
-- Top Down Mode
-- ==========================================

function ENT:AimTopDown( Gunner1, trace, AimAttachment )
	
	if (self:GetPos() * Vector(1,1,0)):Distance(trace.HitPos * Vector(1,1,0)) > 1500 then
		local DesiredVector = self.AimAttachment.Pos - trace.HitPos
		local TargetAngle = self:WorldToLocalAngles( DesiredVector:Angle() )
		self.TargetYaw = self.TargetYaw and math.ApproachAngle( self.TargetYaw, TargetAngle.y, 5 * FrameTime() ) or 0
		self:SetPoseParameter("platform_yaw", -self.TargetYaw)
		self:SetPoseParameter("valve_yaw", -self.TargetYaw*10)

		self.DesiredPitch = math.Remap( self.AimAttachment.Pos:Distance( trace.HitPos )/52.49344, 50, 500, -10, 25 )
		self.TargetPitch = self.TargetPitch and math.Approach( self:GetPoseParameter( "platform_pitch"), self.DesiredPitch, 2.5 * FrameTime() ) or 0
		self:SetPoseParameter( "platform_pitch", self.TargetPitch  )
		self:SetPoseParameter( "valve_pitch", self.TargetPitch*5  )

		if math.Round(-TargetAngle.y) == math.Round(self:GetPoseParameter("platform_yaw")) then
			self.Ready = true
			self:SetNWBool("Ready", self.Ready)
		else
			self.Ready = false
			self:SetNWBool("Ready", self.Ready)
		end
	else 
		self.Ready = false
		self:SetNWBool("Ready", self.Ready)
	end
end

function ENT:AttackTopDownBasilisk( Gunner1, trace )
	if not self:CanAttack( self ) then return end
	self:RateOfFire( self, CurTime() + 15 * self.ReloadTimeMultiplier )
	self.ShellType = self.CurrentAmmoTypeBasilisk
	self:AddGestureSequence(self:LookupSequence( "basilisk_fire"), 1)
	self:EmitSound("artillery_basilisk_shot")
	self:EmitSound("artillery_cannon_clang")
		self:DoShotEffects()

	timer.Simple( 1.1, function()
		self:EmitSound("artillery_cannon_reload")
	end)

	local FlightTime = self.AimAttachment.Pos:Distance( trace.HitPos )/52.49344/200+2
			
	timer.Simple( FlightTime - 1, function()
		
		local ShellStart = trace.HitPos+VectorRand()*Vector(self:GetPos():Distance(trace.HitPos)/self.Spread,self:GetPos():Distance(trace.HitPos)/20,0)
		local trace2 = util.TraceLine( {
				start = ShellStart+Vector(0,0,1000),
				endpos = ShellStart+Vector(0,0,-2000),
			} )
		EmitSound( "ordoredactus/artillery/artillery_incoming_1.wav", trace2.HitPos, self:EntIndex(), CHAN_STATIC, 1, 130, 0, math.Rand(90,110))
		timer.Simple( 2, function()
			if self.ShellType == 1 then
				self:BasiliskHEExplosion( Gunner1, trace2 )
			elseif self.ShellType == 2 then
				self:BasiliskINCExplosion( Gunner1, trace2 )
			elseif self.ShellType == 3 then
				self:BasiliskCMExplosion( Gunner1, trace2 )
			end
		end)
	end)
end

function ENT:AttackTopDownMedusa( Gunner1, trace )
	if not self:CanAttack( self ) then return end
	self:RateOfFire( self, CurTime() + 30 * self.ReloadTimeMultiplier )
	self.ShellType = self.CurrentAmmoTypeMedusa
	self:AddGestureSequence(self:LookupSequence( "medusa_fire"), 1)
	self:EmitSound("artillery_medusa_shot")
	self:EmitSound("artillery_cannon_clang")
	self:DoShotEffects()

	timer.Simple( 1.5, function()
		self:EmitSound("artillery_cannon_reload")
	end)

	local FlightTime = self.AimAttachment.Pos:Distance( trace.HitPos )/52.49344/100+3
			
	timer.Simple( FlightTime - 1.5, function()
		
		local ShellStart = trace.HitPos+VectorRand()*Vector(self:GetPos():Distance(trace.HitPos)/self.Spread,self:GetPos():Distance(trace.HitPos)/20,0)
		local trace2 = util.TraceLine( {
				start = ShellStart+Vector(0,0,1000),
				endpos = ShellStart+Vector(0,0,-2000),
			} )
		EmitSound( "ordoredactus/artillery/artillery_incoming_1.wav", trace2.HitPos, self:EntIndex(), CHAN_STATIC, 1, 130, 0, math.Rand(70,90))
		timer.Simple( 2.5, function()
			if self.ShellType == 1 then
				self:MedusaHEExplosion( Gunner1, trace )
			elseif self.ShellType == 2 then
				self:MedusaINCExplosion( Gunner1, trace )
			elseif self.ShellType == 3 then
				self:MedusaCMExplosion( Gunner1, trace )
			end
		end)
	end)
end

-- ==========================================
-- Misc
-- ==========================================

function ENT:DoShotEffects()
	local effectdata = EffectData()
		effectdata:SetOrigin( self.AimAttachment.Pos )
		effectdata:SetAngles( self.AimAttachment.Ang )
		effectdata:SetEntity( self )
		effectdata:SetAttachment( self:LookupAttachment(self.AimAttachmentName) )
		effectdata:SetScale( 1 )
	util.Effect( "artillery_muzzle_1", effectdata, true, true )

	local effectdata2 = EffectData()
		effectdata2:SetOrigin( self:GetPos() )
		effectdata2:SetAngles( self:GetAngles() )
		effectdata2:SetEntity( self )
		effectdata2:SetAttachment( self:LookupAttachment("none") )
		effectdata2:SetScale( 1 )
	util.Effect( "artillery_dust", effectdata, true, true )

	util.ScreenShake( self:GetPos(), 1000, 50, 1, 1600 )
end

function ENT:BasiliskHEExplosion( Gunner1, trace )
	util.BlastDamage( self, Gunner1, trace.HitPos + Vector(0,0,20), 800, 8000 )
	util.BlastDamage( self, Gunner1, trace.HitPos + Vector(0,0,20), 1600, 80 )
	util.BlastDamage( self, Gunner1, trace.HitPos + Vector(0,0,20), 100, 16000 )
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
	util.Effect( "artillery_explosion_1", effectdata )
end

function ENT:BasiliskINCExplosion( Gunner1, trace )
	util.BlastDamage( self, Gunner1, trace.HitPos + Vector(0,0,20), 800, 200 )
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
	util.Effect( "artillery_explosion_1", effectdata )
	local shell = ents.Create("or_artillery_shell_basilisk_incendiary")
   	shell:SetPos(trace.HitPos + Vector(0,0, 5))
	shell:SetAngles(Angle(0,0, math.random(-360, 360)))
	shell:Spawn()
	shell:Activate()
	shell.Gunner = Gunner1
end

function ENT:BasiliskCMExplosion( Gunner1, trace )
	util.BlastDamage( self, Gunner1, trace.HitPos + Vector(0,0,20), 800, 200 )
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
	util.Effect( "artillery_explosion_1", effectdata )
	local shell = ents.Create("or_artillery_shell_basilisk_chemical")
   	shell:SetPos(trace.HitPos + Vector(0,0, 5))
	shell:SetAngles(Angle(0,0, math.random(-360, 360)))
	shell:Spawn()
	shell:Activate()
	shell.Gunner = Gunner1
end

function ENT:MedusaHEExplosion( Gunner1, trace )
	util.BlastDamage( self, Gunner1, trace2.HitPos + Vector(0,0,20), 1600, 24000 )
	local effectdata = EffectData()
		effectdata:SetOrigin( trace2.HitPos )
	util.Effect( "artillery_explosion_2", effectdata )
end

function ENT:MedusaINCExplosion( Gunner1, trace )
	util.BlastDamage( self, Gunner1, trace.HitPos + Vector(0,0,20), 800, 400 )
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
	util.Effect( "artillery_explosion_1", effectdata )
	local shell = ents.Create("or_artillery_shell_medusa_incendiary")
   	shell:SetPos(trace.HitPos + Vector(0,0, 5))
	shell:SetAngles(Angle(0,0, math.random(-360, 360)))
	shell:Spawn()
	shell:Activate()
	shell.Gunner = Gunner1
end

function ENT:MedusaCMExplosion( Gunner1, trace )
	util.BlastDamage( self, Gunner1, trace.HitPos + Vector(0,0,20), 800, 200 )
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
	util.Effect( "artillery_explosion_1", effectdata )
	local shell = ents.Create("or_artillery_shell_medusa_chemical")
   	shell:SetPos(trace.HitPos + Vector(0,0, 5))
	shell:SetAngles(Angle(0,0, math.random(-360, 360)))
	shell:Spawn()
	shell:Activate()
	shell.Gunner = Gunner1
end

function ENT:MedusaHEExplosion( Gunner1, trace )
	util.BlastDamage( self, Gunner1, trace.HitPos + Vector(0,0,20), 1600, 24000 )
	local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos )
	util.Effect( "artillery_explosion_2", effectdata )
end

function ENT:CanAttack( self )
	self.NextShot = self.NextShot or 0
	return self.NextShot < CurTime()
end

function ENT:RateOfFire( self, time )
	self.NextShot = time
	self:SetNWFloat( "ReloadTime", time )
end