AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal )
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:RunOnSpawn()
	self:GetChildren()[1]:SetVehicleClass("phx_seat3")
	self:SetAutomaticFrameAdvance(true)

	local x = ents.Create("base_anim")
	x:SetModel("models/KingPommes/starwars/atrt/turret.mdl")
	x:SetPos(Vector())
	x:SetAngles(Angle())
	x:SetParent(self)
	x:Spawn()
	x:Activate()
	self.T = x
	self.T:Fire("setparentattachment", "turret", 0)
	
	self:SetSequence(self:LookupSequence( "sitdown" ))
	self:SetPlaybackRate(1)
	
	self.c = false
	self.j = CurTime()
	self:GetDriverSeat():Fire("setparentattachmentmaintainoffset", "driver", 0)
	self.Flashlight = {}
	self.Flashlights = {
        {Vector(25,1,85),Angle(10,0,0)},
		{Vector(25,-1,85),Angle(10,0,0)},
    }
	self.HasFlashlight = false;
    self.FlashlightDistance = 5000;
	self.jum = false
end

function ENT:CreateFlashlight()

    local i = 1;
    for k,v in pairs(self.Flashlights) do
        self.Flashlight[i] = ents.Create( "env_projectedtexture" )
        self.Flashlight[i]:SetParent(self)

        self.Flashlight[i]:SetLocalPos(v[1])
        self.Flashlight[i]:SetLocalAngles(v[2])

        self.Flashlight[i]:SetKeyValue( "enableshadows", 1 )
        self.Flashlight[i]:SetKeyValue( "farz", self.FlashlightDistance or 1000 )
        self.Flashlight[i]:SetKeyValue( "nearz", 12 )
        self.Flashlight[i]:SetKeyValue( "lightfov", 60 )

        local c = Color(255,255,255);
        local b = 0.7;
        self.Flashlight[i]:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r * b, c.g * b, c.b * b ) )
        self.Flashlight[i]:Spawn()
        self.Flashlight[i]:Input( "SpotlightTexture", NULL, NULL, "effects/flashlight001" )
        i = i+1;
    end
    self.FlashlightOn = true;
end
    
function ENT:RemoveFlashlight()
        
   if(IsValid(self.Flashlight[1])) then
        for k,v in pairs(self.Flashlight) do
            v:Remove(); 
            
        end
        table.Empty(self.Flashlight);
    end
    self.FlashlightOn = false;
end

function ENT:OnTick()
	local Pod = self:GetDriverSeat()
	if not IsValid( Pod ) then return end
	
	local Driver = Pod:GetDriver()
	
	local FT = FrameTime()
	
	local PObj = self:GetPhysicsObject()
	local MassCenterL = PObj:GetMassCenter()	
	local MassCenter = self:LocalToWorld( MassCenterL )
	self:SetMassCenter( MassCenter )
	
	local Forward = self:GetForward()
	local Right = self:GetRight()
	local Up = self:GetUp()
	
	self:DoTrace()
	
	local Trace = self.GroundTrace
	if self.WaterTrace.Fraction <= Trace.Fraction and !self.IgnoreWater and self:GetEngineActive() then
		Trace = self.WaterTrace
	end
	
	local EyeAngles = Angle(0,0,0)
	local KeyForward = false
	local KeyBack = false
	local KeyLeft = false
	local KeyRight = false
	
	local Sprint = false
	
	if IsValid( Driver ) then
		if self:GetForwardVelocity() < 10 then
			Driver.LFS_KEYDOWN["-THROTTLE"] = false
		end
		EyeAngles = Driver:EyeAngles()
		KeyForward = Driver:lfsGetInput( "+THROTTLE" ) or self.IsTurnMove
		KeyBack = Driver:lfsGetInput( "-THROTTLE" )
		if self.CanMoveSideways then
			KeyLeft = Driver:lfsGetInput( "+ROLL" )
			KeyRight = Driver:lfsGetInput( "-ROLL" )
		end
		
		if KeyBack then
			KeyForward = false
		end
		
		if KeyLeft then
			KeyRight = false
		end
		
		Sprint = Driver:lfsGetInput( "VSPEC" ) or Driver:lfsGetInput( "+PITCH" ) or Driver:lfsGetInput( "-PITCH" )
		
		self:MainGunPoser( Pod:WorldToLocalAngles( EyeAngles ) )
	end
	local MoveSpeed = Sprint and self.BoostSpeed or self.MoveSpeed
	
	local IsOnGround
	
	if IsValid( Driver ) then
		if self.jum and self.j > CurTime() then
			IsOnGround = false
		elseif Driver:KeyDown( IN_JUMP ) and self.j < CurTime() and self.onG then
			self.jum = true
			self.j = CurTime() + 0.5
			IsOnGround = false
			self:GetPhysicsObject():ApplyForceCenter( self:GetUp() * 666666)
		else
			IsOnGround = Trace.Hit and math.deg( math.acos( math.Clamp( Trace.HitNormal:Dot( Vector(0,0,1) ) ,-1,1) ) ) < 70
			self.jum = false
		end
	else
		IsOnGround = Trace.Hit and math.deg( math.acos( math.Clamp( Trace.HitNormal:Dot( Vector(0,0,1) ) ,-1,1) ) ) < 70
		self.jum = false
	end
	
	PObj:EnableGravity( not IsOnGround )
	self.onG = IsOnGround
	
	if (IsOnGround) then
		local pos = Vector( self:GetPos().x, self:GetPos().y, Trace.HitPos.z)
		local speedVector = Vector(0,0,0)
		
		if IsValid( Driver ) && !Driver:lfsGetInput( "FREELOOK" ) && self:GetEngineActive() then
			local lookAt = Vector(0,-1,0)
			lookAt:Rotate(Angle(0,Pod:WorldToLocalAngles( EyeAngles ).y,0))
			self.StoredForwardVector = lookAt
		else
			local lookAt = Vector(0,-1,0)
			lookAt:Rotate(Angle(0,self:GetAngles().y,0))
			self.StoredForwardVector = lookAt
		end
		
		local ang = self:LookRotation( self.StoredForwardVector, Trace.HitNormal ) - Angle(0,0,90)
		if self:GetEngineActive() then
			speedVector = Forward * ((KeyForward and MoveSpeed or 0) - (KeyBack and MoveSpeed or 0)) + Right * ((KeyLeft and MoveSpeed or 0) - (KeyRight and MoveSpeed or 0))
		end
		
		self.deltaV = LerpVector( self.LerpMultiplier * FT, self.deltaV, speedVector )
		self:SetDeltaV( self.deltaV )
		pos = pos + self.deltaV
		self:SetIsMoving(pos != self:GetPos())
		
		self.ShadowParams.pos = pos
		self.ShadowParams.angle = ang
		PObj:ComputeShadowControl( self.ShadowParams )
	end
	
	local GunnerPod = self:GetGunnerSeat()
	if IsValid( GunnerPod ) then
		local Gunner = GunnerPod:GetDriver()
		if Gunner ~= self:GetGunner() then
			self:SetTurretDriver( Gunner )
		end
	end
	
	local TurretPod = self:GetTurretSeat()
	if IsValid( TurretPod ) then
		local TurretDriver = TurretPod:GetDriver()
		if TurretDriver ~= self:GetTurretDriver() then
			self:SetTurretDriver( TurretDriver )
		end
	end
	self:Gunner( self:GetGunner(), GunnerPod )
	self:Turret( self:GetTurretDriver(), TurretPod )
	
	if self.LastSkin ~= self:GetSkin() then
		self.LastSkin = self:GetSkin()
		self.T:SetSkin(self.LastSkin)
	end
	
	if self.LastColor ~= self:GetColor() then
		self.LastColor = self:GetColor()
		self.T:SetColor(self.LastColor)
	end
	
	if not self:GetEngineActive() then
		if self.h then
			self:EmitSound( "hailfire_droid/engine_off.wav" )
			self:SetSequence(self:LookupSequence( "sitdown" ))
			self:SetPlaybackRate(1)
			self:ResetSequenceInfo()
			self.h = false
		end
		return
	end
	self.h = true
	
	if self:GetForwardVelocity() <= 5 then
		self:SetSequence(self:LookupSequence( "idle" ))
		self:SetPlaybackRate(0)
	end
	if self:GetForwardVelocity() <= 500  and self:GetForwardVelocity() > 5 then
		self:ResetSequence(self:LookupSequence( "walking" ))
		self:SetPlaybackRate(self:GetForwardVelocity()/75)
	end
	if self:GetForwardVelocity() > 500 then
		self:ResetSequence(self:LookupSequence("running"))
		self:SetPlaybackRate(self:GetForwardVelocity()/333)
	end
	
	if not IsValid( Driver ) then return end
	
	if Driver:KeyDown( IN_SPEED ) and self:GetForwardVelocity() > 10 then
		self.MoveSpeed = 300
	else
		self.MoveSpeed = 66
	end
	self.BoostSpeed = self.MoveSpeed
	
	local pi = Driver:GetVehicle():WorldToLocalAngles( Driver:EyeAngles() )
	local aimx = math.AngleDifference(pi.x, self:EyeAngles().x)
	aimx = math.Clamp( aimx,-25,25)
	
	local yaw = Driver:GetVehicle():WorldToLocalAngles( Driver:EyeAngles() )
	local aimy = math.AngleDifference(yaw.y, self:EyeAngles().y)
	aimy = math.Clamp( aimy,-60,60)
	self:ManipulateBoneAngles(self:LookupBone("turret_x"), Angle(0,0,aimx))
	self:ManipulateBoneAngles(self:LookupBone("turret_z"), Angle(aimy,0,0))
	
	if not util.QuickTrace( self:GetPos(), Vector(0,0,-100), nil ).Hit then
		self:ResetSequence(self:LookupSequence("inair_l"))
	end
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	local Driver = self:GetDriver()
	if not IsValid( Driver ) then return end
	if not self:GetEngineActive() then return end
	if not self.onG then return end
	
	local canon = self:GetAttachment(self:LookupAttachment("turret"))
	
	if not canon then return end
	
	self:EmitSound( "at-rt/shoot.wav" )
	
	self:SetNextPrimary( 0.2 )
	
	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= canon.Pos
	bullet.Dir 	= canon.Ang:Forward()
	bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_blue"
	bullet.Force	= 100
	bullet.HullSize 	= 50
	bullet.Damage	= 100
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
	dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	self:TakePrimaryAmmo()
end

function ENT:OnLandingGearToggled( bOn )
	if not self:GetEngineActive() then return end
	if self.FlashlightOn then
        self:RemoveFlashlight()
    else
        self:CreateFlashlight()
        self.Flashlight[1]:SetParent(self)
    end
end

function ENT:OnEngineStarted()
	self:EmitSound( "hailfire_droid/engine_on.wav" )
	self:SetSequence(self:LookupSequence( "standup" ))
	self:SetPlaybackRate(1)
	self:ResetSequenceInfo()
end

function ENT:OnEngineStopped()
	self:EmitSound( "hailfire_droid/engine_off.wav" )
	self:SetSequence(self:LookupSequence( "sitdown" ))
	self:SetPlaybackRate(1)
	self:ResetSequenceInfo()
	if self.FlashlightOn then
        self:RemoveFlashlight()
	end
end

function ENT:OnRemove()
	if self.FlashlightOn then
        self:RemoveFlashlight()
	end
end