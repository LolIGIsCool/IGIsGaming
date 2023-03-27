if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Tyrannosaurus"
ENT.Category = "Jurassic Park"
ENT.Models = {"models/bryanjp19/jurassicpark/tyrannosaurus.mdl"}
ENT.Skins = {1}
ENT.ModelScale = 1.0
ENT.CollisionBounds = Vector(30, 30, 180)
ENT.CrouchCollisionBounds = Vector(30, 30, 120)
ENT.BloodColor = BLOOD_COLOR_RED

-- Stats --
ENT.SpawnHealth = 4500
ENT.HealthRegen = 10
ENT.MinPhysDamage = 1000
ENT.MinFallDamage = 100

-- Sounds --
ENT.OnSpawnSounds = {}
ENT.OnIdleSounds = {}
ENT.IdleSoundDelay = 2
ENT.ClientIdleSounds = false
ENT.OnDamageSounds = {}
ENT.DamageSoundDelay = 8
ENT.OnDeathSounds = {}
ENT.OnDownedSounds = {}
ENT.Footsteps = {}
ENT.LastSnarl = 0
ENT.LastCall = 0

-- AI --
ENT.Omniscient = false
ENT.SpotDuration = 10
ENT.RangeAttackRange = 4000
ENT.MeleeAttackRange = 140
ENT.ReachEnemyRange = 30
ENT.AvoidEnemyRange = 0
ENT.Cooldown = 0
ENT.BiteCooldown = 0

-- Relationships --
ENT.Factions = {"FACTION_REX"}
ENT.Frightening = true
ENT.AllyDamageTolerance = 0.33
ENT.AfraidDamageTolerance = 0.33
ENT.NeutralDamageTolerance = 0.33

-- Locomotion --
ENT.Acceleration = 1000
ENT.Deceleration = 4000
ENT.JumpHeight = 50
ENT.StepHeight = 20
ENT.MaxYawRate = 100
ENT.DeathDropHeight = 200

-- Animations --
ENT.WalkAnimation = "walk"
ENT.WalkAnimRate = 1
ENT.RunAnimation = "run"
ENT.RunAnimRate = 1
ENT.IdleAnimation = "idle"
ENT.IdleAnimRate = 1
ENT.JumpAnimation = "fall"
ENT.JumpAnimRate = 1

-- Movements --
ENT.UseWalkframes = true
ENT.MaxYawRate = 200
ENT.WalkSpeed = 59.21
ENT.RunSpeed = 750

-- Climbing --
ENT.ClimbLedges = false
ENT.ClimbLedgesMaxHeight = math.huge
ENT.ClimbLedgesMinHeight = 0
ENT.LedgeDetectionDistance = 20
ENT.ClimbProps = false
ENT.ClimbLadders = false
ENT.ClimbLaddersUp = true
ENT.LaddersUpDistance = 20
ENT.ClimbLaddersUpMaxHeight = math.huge
ENT.ClimbLaddersUpMinHeight = 0
ENT.ClimbLaddersDown = false
ENT.LaddersDownDistance = 20
ENT.ClimbLaddersDownMaxHeight = math.huge
ENT.ClimbLaddersDownMinHeight = 0
ENT.ClimbSpeed = 60
ENT.ClimbUpAnimation = ACT_CLIMB_UP
ENT.ClimbDownAnimation = ACT_CLIMB_DOWN
ENT.ClimbAnimRate = 1
ENT.ClimbOffset = Vector(0, 0, 0)

-- Detection --
ENT.EyeBone = "DinoSpine02"
ENT.EyeOffset = Vector(10, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.SightFOV = 260
ENT.SightRange = 8000
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.HearingCoefficient = 1

-- Weapons --
ENT.UseWeapons = false
ENT.Weapons = {}
ENT.WeaponAccuracy = 1
ENT.WeaponAttachment = "Anim_Attachment_RH"
ENT.DropWeaponOnDeath = false
ENT.AcceptPlayerWeapons = true

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionPrompt = true
ENT.PossessionCrosshair = false
ENT.PossessionMovement = POSSESSION_MOVE_1DIR
ENT.PossessionViews = {
  {
    offset = Vector(0, 0, 50),
    distance = 150
  },
  {
    offset = Vector(7.5, 0, 0),
    distance = 0,
    eyepos = true
  }
}
ENT.PossessionBinds = {
	[IN_ATTACK] = {{
	coroutine = true,
	onkeydown = function(self)
			self.NoVocal = true
			self:PossessorNormal()
			self:FaceTowards(self:GetPos() + self:PossessorNormal())
			self:PlaySequence("bite",1,self.PossessionFaceForward)
			self.NoVocal = false
	end
	}},
	[IN_ATTACK2] = {{
	coroutine = true,
	onkeydown = function(self)
			self:PossessorNormal()
			self:FaceTowards(self:GetPos() + self:PossessorNormal())
			self:PossessorNormal()
			self:FaceTowards(self:GetPos() + self:PossessorNormal())
			local ent = self:GetClosestEnemy()
			if not IsValid(ent) then return end
			self:Grab(ent)
	end
	}},
	[IN_RELOAD] = {{
	coroutine = true,
	onkeydown = function(self)
	if self.BiteCooldown < CurTime() then
			self:EmitSound("bryanjp19/rex/roar_long"..math.random(1,3)..".wav")
			self:PlaySequence("vocalize",1)
		self.BiteCooldown = CurTime() + 2
	end
	end
	}},
	[IN_DUCK] = {{
		coroutine = false,
		onkeypressed = function(self)
			if self:IsCrouching() then
				self:UnCrouch()
			else
				self:ToCrouch()
			end
		end
	}}
}

if SERVER then

local npc_rex_music =
	CreateConVar("npc_rex_music", 0, FCVAR_NONE,
	"Enables or disables music.")

function ENT:snd(a)
	self:EmitSound(a)
end

function ENT:OnCombineBall(ball)
	local dmg = DamageInfo()
	dmg:SetAttacker(IsValid(ball:GetOwner()) and ball:GetOwner() or ball)
	dmg:SetInflictor(ball)
	dmg:SetDamageType(DMG_BLAST)
	
	self:TakeDamageInfo(dmg)
	ball:Fire("explode", 0)
	return true
end

function ENT:OnStuck()
	self.LastPos = self.Entity:GetPos()
	if self.LastPos:Distance( self.Entity:GetPos() ) < 100 then
		self.Entity:SetPos( self.Entity:LocalToWorld(Vector(100,0,0)))
	end
	-- PrintMessage(HUD_PRINTTALK, "Rex stuck.")
	self:RemovePatrol(self:GetPatrol())
end

function ENT:OnLandOnGround()
	self:CallInCoroutine(function(self, delay)
	if delay > 0.1 then return end
		self:EmitSound("NPC_dog.Rock_Drop")
		util.ScreenShake( self:GetPos(), 8, 0.1, 2, 3000 )
		self:PlaySequenceAndWait("jump_end")
	end)
end
function ENT:OnContact(ent)
	if ent:GetClass() == "prop_physics" then
		local velocity = Vector(0, 150, 50)
		local right = self:GetPos()+self:GetRight()*1
		local left = self:GetPos()-self:GetRight()*1
		local pos = ent:GetPos()
		local dmg = DamageInfo()
		dmg:SetDamage(100000)
		dmg:SetDamageForce(self:GetRight()* -velocity)
		dmg:SetDamageType(DMG_CLUB)
		dmg:SetAttacker(self)
		dmg:SetReportedPosition(self:GetPos())

		ent:SetVelocity(self:GetRight()* -velocity)
		ent:TakeDamageInfo(dmg)
	end
end

function ENT:CustomInitialize()
	self:SetStepHeight(30)
	self.loco:SetDeathDropHeight(1200)
	self:SetIsCrouching(false)
	self:SetCooldown("HWCrouch", 2)
	self:SetCooldown("HWUnCrouch", 2)
	self.CanChaseMusic = false
	self.CanSuperSprint = false
	self.NoVocal = false
	self.smoothTrack = self.Entity:LocalToWorld(Vector(200,0,130))
	self.TargetInMotion = true
	self.SearchTrack = self.Entity:LocalToWorld(Vector(400,0,120)) + VectorRand(-10,10)
	self:SetAttack("bite", true)
	self:SetDefaultRelationship(D_HT)
	self:SequenceEvent("bite",1,self.AttackFunction)
	self:SetName("Huggy Wuggy_"..self:EntIndex())
	for i, locomotion in ipairs({
		self.RunAnimation,
		self.WalkAnimation
	}) do
		self:SequenceEvent(locomotion, {0.263, 0.763}, function(self)
			self:EmitSound("bryanjp19/rex/stomp"..math.random(1,6)..".wav", 70, 100, 1)
			self:EmitSound("bryanjp19/rex/stomp_far"..math.random(1,3)..".wav", 120, 100, 0.2)
			util.ScreenShake( self:GetPos(), 4, 0.1, 2, 2000 )
		end)
	end
end

function ENT:AttackFunction()
	if self.BiteCooldown < CurTime() then
        self.NoVocal = true
		self:Attack({
			damage = 800,
			viewpunch = Angle(10, 10, 1),
			type = DMG_BLAST,range=100,angle=135
		}, function(self, hit)
			if #hit == 0 then self:snd("")return end 
			self:snd("npc/zombie/claw_strike"..math.random(2)..".wav")
		end)
		self.BiteCooldown = CurTime() + .3
	end
	self.NoVocal = false
end

function ENT:GetGrabbedPlayer()
	return self:GetNW2Entity("GrabbedPlayer")
end

function ENT:SetGrabbedPlayer(value)
	return self:SetNW2Entity("GrabbedPlayer", value)
end

function ENT:GetGrabbedEnemy()
	return self:GetNW2Entity("GrabbedEnemy")
end

function ENT:SetGrabbedEnemy(value)
	return self:SetNW2Entity("GrabbedEnemy", value)
end

function ENT:IsCrouching()
	return self:GetNW2Bool("IsCrouching")
end

function ENT:SetIsCrouching(value)
	return self:SetNW2Bool("IsCrouching", value)
end

function ENT:ToCrouch()
	self:SetIsCrouching(true)
	self.IdleAnimation = "idle_crouch"
	self.WalkAnimation = "walk_crouch"
	self.RunAnimation = "charge_crouch"
	if isvector(self.CrouchCollisionBounds) then
		self:SetCollisionBounds(
			Vector(self.CrouchCollisionBounds.x, self.CrouchCollisionBounds.y, self.CrouchCollisionBounds.z),
			Vector(-self.CrouchCollisionBounds.x, -self.CrouchCollisionBounds.y, 0)
		)
	else
		self:SetCollisionBounds(self:GetModelBounds())
	end
end

function ENT:UnCrouch()
	self:SetIsCrouching(false)
	self.IdleAnimation = "idle"
	self.WalkAnimation = "walk"
	self.RunAnimation = "run"
	if isvector(self.CollisionBounds) then
		self:SetCollisionBounds(
			Vector(self.CollisionBounds.x, self.CollisionBounds.y, self.CollisionBounds.z),
			Vector(-self.CollisionBounds.x, -self.CollisionBounds.y, 0)
		)
	else
		self:SetCollisionBounds(self:GetModelBounds())
	end
end

function ENT:Relations()
	if IsValid(self) then
		local All = ents.FindInSphere(self:GetPos(),999000000)
		 
		for k,v in pairs(All) do 
			if (IsValid(v) && (v.Base == "npc_vj_tank_base" or v.Base == "npc_vj_tankg_base") ) then return end

			if (IsValid(v) and (v:IsNPC() or v:IsNextBot()) and self:IsHostile(v) or IsValid(v) and GetConVarNumber("ai_ignoreplayers") == 0  and v:IsPlayer()) then		
				self:SetEnemy(v)	 
			end
		end
	end
end

function ENT:DestroyedDoor()
	for v,ball in pairs(ents.FindInSphere(self:LocalToWorld(Vector(0,0,5)), 50)) do
		if IsValid(ball) && IsValid(self) then
			if ball:GetClass() == "prop_door_rotating" then
				local pos = ball:GetPos()
				local angles = ball:GetAngles()
				local model = ball:GetModel()
				local bodygroups = ball:GetBodyGroups()
				local skinn = ball:GetSkin()

				//print(model)

				local broken_door = ents.Create("prop_physics")
				broken_door:SetPos(pos)
				broken_door:SetAngles(angles)
				broken_door:SetModel(model)
				broken_door:SetBodyGroups(bodygroups)
				broken_door:SetSkin(skinn)
				broken_door:SetCustomCollisionCheck(true)

				ball:EmitSound("doors/heavy_metal_stop1.wav",350,120)
				ball:Remove()

				broken_door:Spawn()
          
				local phys = broken_door:GetPhysicsObject()
				if IsValid(phys) then
					phys:ApplyForceOffset(self:GetForward() * 1000, phys:GetMassCenter())
				end
			elseif ball:GetClass() == "func_door" || ball:GetClass() == "func_door_rotating" then
				ball:Fire("Open")
			end 
		end
	end
end

function ENT:CustomThink()	
	local MySpeedSqr = tonumber(self:GetGroundSpeedVelocity():Length2DSqr())
	if MySpeedSqr == 0 and self:HasEnemy() then
		if timer.TimeLeft( "rex_stuck" .. self:EntIndex() ) == nil then
			if self:HasEnemy() then
				-- PrintMessage( HUD_PRINTTALK, "Rex stuck!" )
				self:RemovePatrol(self:GetPatrol())
				if self.Entity:GetPos():Distance( self.Entity:GetPos() ) < 100 then
					self.Entity:SetPos( self.Entity:LocalToWorld(Vector(10,0,0)))
				end
			end
			timer.Create( "rex_stuck" .. self:EntIndex(), 10, 1, function() end )
		end
	else
		timer.Stop( "rex_stuck" .. self:EntIndex() )
	end
				
	self:SetPoseParameter("move_z",self:GetVelocity().z)
	if not self:IsPossessed() then
		if self:IsCrouching() then
      			if not (self:GetCooldown("HWUnCrouch") > 0) then
				local ucrouchtr = util.TraceLine{
					start = self:GetPos()+self:GetForward()*-35+self:OBBCenter(),
					endpos = self:GetPos()+self:GetForward()*-35+self:OBBCenter()+Vector(0,0,141),
					filter = self
				}
				if not ucrouchtr.Hit then
					self:UnCrouch()
				end
			end
		end
      		if not (self:GetCooldown("HWCrouch") > 0) then
			if self:GetVelocity():Length() < 30 then
				local tcrouchtr = util.TraceLine{
					start = self:GetPos()+self:GetForward()*35+self:OBBCenter(),
					endpos = self:GetPos()+self:GetForward()*35+self:OBBCenter()+Vector(0,0,141),
					filter = self
				}
				if tcrouchtr.Hit then
					self:SetCooldown("HWUnCrouch", 1)
      					self:ToCrouch()
				end
			end
		end
	end
	if IsValid(self:GetGrabbedPlayer()) then
		if self:GetSequence() != self:LookupSequence("jumpscare") then
			if IsValid(self:GetGrabbedPlayer()) then
				self:GetGrabbedPlayer():SetParent(nil)
				self:GetGrabbedPlayer():SetViewEntity(nil)
				self:GetGrabbedPlayer():Freeze(false)
				self:GetGrabbedPlayer():SetNoDraw(false)
				self:SetIgnored(self:GetGrabbedPlayer(), false)
				self:SetGrabbedPlayer(nil)
				if IsEntity(self.cent) then
					self.cent:Remove()
				end
			end
		end
	end
	if IsValid(self:GetGrabbedEnemy()) and not IsValid(self:GetGrabbedPlayer()) then
		local camerapos = self:GetAttachment(self:LookupAttachment("camera")).Pos
		self:GetGrabbedEnemy():SetPos(camerapos)
		if self:GetSequence() != self:LookupSequence("jumpscare") then
			if IsValid(self:GetGrabbedEnemy()) then
				self:SetGrabbedEnemy(nil)
			end
		end
	end
	if self:HasEnemy() and self:IsInSight(self:GetEnemy()) and self.NoVocal == false then
		LastKnown = self:GetEnemy():EyePos()
		-- PrintMessage(HUD_PRINTTALK, "Tracking.")
	elseif self:HasEnemy() and !self.TargetInMotion then
		LastKnown = self.SearchTrack
		-- PrintMessage(HUD_PRINTTALK, "Searching.")
	else
		LastKnown = self.Entity:LocalToWorld(Vector(200,0,130))
		-- PrintMessage(HUD_PRINTTALK, "Idle.")
	end
	self.smoothTrack = LerpVector(3 * FrameTime() , self.smoothTrack , LastKnown)
	if self:IsPossessed() then
		self:DirectPoseParametersAt(self:PossessorTrace().HitPos, "aim_pitch", "aim_yaw", self:EyePos())
	elseif self.NoVocal == true then
		self:DirectPoseParametersAt(nil, "aim_pitch", "aim_yaw", self:EyePos())
	else
		self:DirectPoseParametersAt(self.smoothTrack, "aim_pitch", "aim_yaw", self:EyePos())
	end
	self:DestroyedDoor()
	if timer.TimeLeft( "rex_idle" .. self:EntIndex() ) == nil and self.NoVocal == false then
		if self:HasEnemy() then
			self:EmitSound("bryanjp19/rex/angry"..math.random(1,12)..".wav")
			self:PlaySequence("vocalize",1.5)
		else
			self:EmitSound("bryanjp19/rex/idle"..math.random(1,19)..".wav")
		end
		timer.Create( "rex_idle" .. self:EntIndex(), math.random(3,20), 1, function() end )
	end
end

function ENT:IsInSight(ent)
	if not IsValid(ent) then return false end
	if self:IsBlind() then return false end
	if ent:IsPlayer() and ent:GetVelocity():Length() < 30 and !self:IsOmniscient() then return false end
	if ent:IsNPC() and ent:GetMoveVelocity():Length() < 10 and !self:IsOmniscient() then return false end
	if ent == self then return true end
	-- local NPCTargetSpeedStr = tonumber(ent:GetMoveVelocity():Length())
	-- PrintMessage( HUD_PRINTTALK, NPCTargetSpeedStr )
	local eyepos = self:EyePos()
	if eyepos:DistToSqr(ent:GetPos()) > self:GetSightRange()^2 then return false end
	if ent:IsPlayer() then
		  if ent:DrG_IsPossessing() then return self:IsInSight(ent:DrG_GetPossessing()) end
		  local luminosity = ent:FlashlightIsOn() and 1 or ent:DrG_Luminosity()
		  local min, max = self:GetSightLuminosityRange()
		  if luminosity < min or luminosity > max then return false end
	end
	local angle = (eyepos + self:EyeAngles():Forward()):DrG_Degrees(ent:WorldSpaceCenter(), eyepos)
	if angle > self:GetSightFOV()/2 then return false end
	return self:Visible(ent)
end

function ENT:OnRemove()
	-- PrintMessage( HUD_PRINTTALK, "Rex was removed." )
	if IsValid(self:GetGrabbedPlayer()) then
		self:GetGrabbedPlayer():SetParent(nil)
		self:GetGrabbedPlayer():SetViewEntity(nil)
		self:GetGrabbedPlayer():Freeze(false)
		self:GetGrabbedPlayer():SetNoDraw(false)
		if IsEntity(self.cent) then
			self.cent:Remove()
		end
	end
end

function ENT:OnDeath()
	-- PrintMessage( HUD_PRINTTALK, "Rex died." )
	if IsValid(self:GetGrabbedPlayer()) then
		self:GetGrabbedPlayer():SetParent(nil)
		self:GetGrabbedPlayer():SetViewEntity(nil)
		self:GetGrabbedPlayer():Freeze(false)
		self:GetGrabbedPlayer():SetNoDraw(false)
		if IsEntity(self.cent) then
			self.cent:Remove()
		end
	end
end

function ENT:FreezePlayer(ent)
	if ent:IsPlayer() then
		-- ent:Freeze(true)
		ent:StripWeapons()
		ent:SetNoDraw(true)
		self:SetIgnored(ent, true)
		self.cent = ents.Create("prop_physics")
		self.cent:SetModel("models/dav0r/camera.mdl")
		self.cent:SetRenderMode(1)
		self.cent:SetColor(Color(255, 255, 255, 0))
		self.cent:DrawShadow(false)
		self.cent:SetMoveType( MOVETYPE_NONE )
		self.cent:SetParent(self, 1)
		self.cent:SetLocalPos(Vector(0, 0, 0))
		self.cent:SetAngles(Angle(self:GetAngles().x, self:GetAngles().y, self:GetAngles().z))
		if !IsValid(self.cent) then return end
		ent:SetViewEntity(self.cent)
	end
end

function ENT:OnNewEnemy(enemy)
	self:PlaySequence("alert", 1)
	timer.Simple(1.5, function()
		self:EmitSound("bryanjp19/rex/alert"..math.random(1,6)..".wav")
	end )
	-- self.WalkAnimation = "stride"
	self:StopSound("bryanjp19/rex/intro.wav")
	if !self.ThemeSongLoop and npc_rex_music:GetBool() then 
				self.ThemeSongLoop = CreateSound(game.GetWorld(),"bryanjp19/rex/chasetheme.wav")
			self.ThemeSongLoop:SetSoundLevel(0)
	self.ThemeSongLoop:Play()
	end
end

function ENT:OnLastEnemy(enemy)
	self.WalkAnimation = "walk"
	if self.ThemeSongLoop then 
		self.ThemeSongLoop:Stop()
	end
	self.CanSuperSprint = false
end

function ENT:OnRemove()
	self:StopSound("bryanjp19/rex/intro.wav")
	if self.ThemeSongLoop then 
		self.ThemeSongLoop:Stop()
	end
end

function ENT:FatalityAI()
    if enemy:Health() <= (enemy:GetMaxHealth()*0.35) then
            self:Grab(enemy)
    end
end

function ENT:Grab(ent)
    local grabbed = false
    local succeed = false
    self:PlaySequenceAndMove("jumpscare", 999, function(self, cycle)
        if grabbed or cycle < 0.28571428571429 then return end
        grabbed = true
        if not IsValid(ent) then return end
        if self:GetHullRangeSquaredTo(ent) > 120^2 then return end
        succeed = true
        self.NoVocal = true

	local dmg = DamageInfo() dmg:SetAttacker(self)
	local ragdoll = ent:DrG_RagdollDeath(dmg)

	self.actualragdoll = self:GrabRagdoll(ragdoll, "spine", "ragdoll")
	self:SetGrabbedEnemy(ent)
        if ent:IsPlayer() then
			self:SetGrabbedPlayer(ent)
			self:FreezePlayer(ent)
		end
        return true
    end)
    if succeed then
        self:Timer(1.05,function()
			self:EmitSound("bryanjp19/rex/bite"..math.random(1,3)..".wav")
            self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav")
            ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,2)
            for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,2) end
            if (ent:IsPlayer() and !ent:Alive()) then
                ent:ScreenFade(SCREENFADE.IN,Color(255,0,0,255),0.3,0.2)
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
        end)
        self:Timer(2.0,function()
			self:EmitSound("bryanjp19/rex/shake"..math.random(1,8)..".wav",90)
            self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav", 60)
            ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,2)
            for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,2) end
            if (ent:IsPlayer() and !ent:Alive()) then
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
        end)
        self:Timer(2.38,function()
			self:EmitSound("bryanjp19/rex/shake"..math.random(1,8)..".wav",90)
            self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav", 60)
            ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,2)
            for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,2) end
            if (ent:IsPlayer() and !ent:Alive()) then
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
        end)
        self:Timer(2.76,function()
			self:EmitSound("bryanjp19/rex/shake"..math.random(1,8)..".wav",90)
            self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav", 60)
            ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,2)
            for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,2) end
            if (ent:IsPlayer() and !ent:Alive()) then
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
        end)
        self:Timer(3.18,function()
			self:EmitSound("bryanjp19/rex/shake"..math.random(1,8)..".wav",90)
            self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav", 60)
            ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,2)
            for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,2) end
            if (ent:IsPlayer() and !ent:Alive()) then
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
        end)
        self:Timer(3.65,function()
			self:EmitSound("bryanjp19/rex/shake"..math.random(1,8)..".wav",90)
            self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav", 60)
            ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,2)
            for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,2) end
            if (ent:IsPlayer() and !ent:Alive()) then
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
        end)
        self:Timer(4.56,function()
			self:EmitSound("bryanjp19/rex/shake"..math.random(1,8)..".wav",90)
            self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav", 60)
            ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,2)
            for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,2) end
            if (ent:IsPlayer() and !ent:Alive()) then
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
        end)
        self:Timer(6.81,function()
            self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav")
            ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,2)
            for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,2) end
            if (ent:IsPlayer() and !ent:Alive()) then
                ent:ScreenFade(SCREENFADE.IN,Color(255,0,0,255),0.3,0.2)
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
        end)
        self:Timer(8.83,function()
            if (ent:IsPlayer() and !ent:Alive()) then
               ent:ScreenFade(SCREENFADE.IN,Color(255,0,0,255),0.3,0.2)
               ent:ScreenFade(SCREENFADE.OUT,Color(0,0,0,255),0.3,2)
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
            if IsValid(self.actualragdoll) then
                self:DropAllRagdolls()
 				self.actualragdoll:SetCollisionGroup(COLLISION_GROUP_NONE)
				self.actualragdoll:Fire("fadeandremove",0.1,0.01)
            end
        end)
		self:EmitSound("bryanjp19/rex/alert"..math.random(1,6)..".wav")
        self:PlaySequenceAndMove("jumpscare")
    end
	self.NoVocal = false
end

function ENT:UpdateAI()
    self:UpdateHostilesSight()
    self:UpdateEnemy()
	self.SearchTrack = self.Entity:LocalToWorld(Vector(800,0,100)) + VectorRand(-100,100)
end

function ENT:OnMeleeAttack(enemy)
	self.NoVocal = true
	if enemy:Health() <= (enemy:GetMaxHealth()*0.05) then
		if enemy.VJ_IsHugeMonster then
			self:PlaySequence("bite",1,self.FaceEnemy)
		else
			self:Grab(enemy)
		end
	else
		if enemy:Health() < 600 then
			self:Grab(enemy)
		else
		    self:PlaySequence("bite",1,self.FaceEnemy)
		end
	end
	self.NoVocal = false
end

  -- These hooks are called when the nextbot has an enemy (inside the coroutine)

function ENT:OnRangeAttack(enemy)
	if self:GetEnemy():IsPlayer() and self:GetEnemy():GetVelocity():Length() < 50 and !self:IsOmniscient() then
		self.TargetInMotion = false
	elseif self:GetEnemy():IsNPC() and self:GetEnemy():GetMoveVelocity():Length() < 40 and !self:IsOmniscient() then
		self.TargetInMotion = false
	else
		self.TargetInMotion = true
		timer.Remove("rex_motion")
		-- PrintMessage(HUD_PRINTTALK, "Stopping Timer")
	end
	if self:HasEnemy() then
		-- PrintMessage(HUD_PRINTTALK, "Has Enemy")
		if self.TargetInMotion and self:GetPos():Distance(enemy:GetPos()) > 1000 or self:GetEnemy():GetVelocity():Length() > 220 and self.CanSuperSprint == false then
			self.CanSuperSprint = true
			timer.Remove("rex_motion")
		end
	end
	if self:HasEnemy() and self:GetEnemy():GetVelocity():Length() < 50 and !self.TargetInMotion and !self:IsOmniscient() then
		local ChanceToStop = math.random(-10,10)
		if ChanceToStop == 0 and self:GetPos():Distance(enemy:GetPos()) < math.random(100,1200) then
			self.CanSuperSprint = false
		end
		timer.Create( "rex_motion" .. self:EntIndex(), math.random(5,60), 1, function() end)
		-- PrintMessage(HUD_PRINTTALK, "Starting Timer")
		if timer.TimeLeft( "rex_motion" .. self:EntIndex() ) == nil and self.NoVocal == false then
			timer.Simple(5, function()
				self:LoseEntity(enemy)
				self:RemovePatrol(self:GetPatrol())
				-- PrintMessage(HUD_PRINTTALK, "Rex lost target.")
			end)
		end
	end
end

function ENT:ShouldRun()
	if self:HasEnemy() and self.CanSuperSprint == true then
		return true
	else
		return false
	end
end

  function ENT:OnAvoidEnemy(enemy) end

  -- These hooks are called while the nextbot is patrolling (inside the coroutine)
  function ENT:OnReachedPatrol(pos)
    self:Wait(math.random(3, 7))
  end 
  function ENT:OnPatrolUnreachable(pos) end
  function ENT:OnPatrolling(pos) end

  -- Those hooks are called inside the coroutine
function ENT:OnSpawn()
end

  function ENT:OnIdle()
    self:AddPatrolPos(self:RandomPos(1500))
  end

  -- Called outside the coroutine
  function ENT:OnTakeDamage(dmg, hitgroup)
    self:SpotEntity(dmg:GetAttacker())
	self.CanSuperSprint = true
  end
  function ENT:OnFatalDamage(dmg, hitgroup) end
  
  -- Called inside the coroutine
  function ENT:OnTookDamage(dmg, hitgroup) end
  function ENT:OnDowned(dmg, hitgroup) end

else

function ENT:CustomInitialize() end
  function ENT:CustomThink() end
  function ENT:CustomDraw() end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)