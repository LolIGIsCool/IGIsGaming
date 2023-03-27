if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Dilophosaurus"
ENT.Category = "Jurassic Park"
ENT.Models = {"models/bryanjp19/jurassicpark/dilophosaurus.mdl"}
ENT.Skins = {0}
ENT.ModelScale = 1.0
ENT.CollisionBounds = Vector(10, 10, 60)
ENT.CrouchCollisionBounds = Vector(10, 10, 40)
ENT.BloodColor = BLOOD_COLOR_RED

-- Stats --
ENT.SpawnHealth = 80
ENT.HealthRegen = 1
ENT.MinPhysDamage = 100
ENT.MinFallDamage = 10

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
ENT.LastHoot = 0
ENT.LastSnarl = 0

-- AI --
ENT.Omniscient = false
ENT.SpotDuration = 10
ENT.RangeAttackRange = 4000
ENT.MeleeAttackRange = 20
ENT.ReachEnemyRange = 200
ENT.AvoidEnemyRange = 0
ENT.Cooldown = 0
ENT.BiteCooldown = 0
ENT.SpitCooldown = 0
ENT.RoarCooldown = 0

-- Relationships --
ENT.Factions = {"FACTION_DILO"}
ENT.Frightening = true
ENT.AllyDamageTolerance = 0.33
ENT.AfraidDamageTolerance = 0.33
ENT.NeutralDamageTolerance = 0.33

-- Locomotion --
ENT.Acceleration = 1000
ENT.Deceleration = 4000
ENT.JumpHeight = 50
ENT.StepHeight = 20
ENT.MaxYawRate = 400
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
ENT.PossessionCrosshair = true
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
	[IN_JUMP] = {{
		coroutine = false,
		onkeypressed = function(self)
			self:HWJump(80)
		end
	}},
	[IN_ATTACK] = {{
	coroutine = true,
	onkeydown = function(self)
		if self.BiteCooldown < CurTime() then
			self:PossessorNormal()
			self:FaceTowards(self:GetPos() + self:PossessorNormal())
			self:PlaySequence("bite",1,self.PossessionFaceForward)
			self.BiteCooldown = CurTime() + 0.5
		end
	end
	}},
	[IN_RELOAD] = {{
	coroutine = true,
	onkeydown = function(self)
		self:EmitSound("bryanjp19/dilo/spit"..math.random(1,7)..".wav")
		self:PlaySequenceAndMove("spit_in", 1, self.FaceEnemy)
		local proj = self:CreateProjectile("proj_DiloSpit")
		if not IsValid(proj) then return end
		proj:SetPos(self:GetPos() + Vector(5, 0, self:Height()*1.15))
		proj:GetPhysicsObject():EnableGravity(true)
		proj:DrG_AimAt(self:PossessorTrace().HitPos, 1500)
		self:PlaySequenceAndMove("spit_out")
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

local npc_dilo_music =
	CreateConVar("npc_dilo_music", 0, FCVAR_NONE,
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

function ENT:HWJump(lenght)
	if self:IsOnGround() then
		self:PlaySequence("fall")
		self:Jump(lenght)
	end
end

function ENT:OnStuck()
	-- PrintMessage(HUD_PRINTTALK, "Dilo stuck.")
	self.LastPos = self.Entity:GetPos()
	if self.LastPos:Distance( self.Entity:GetPos() ) < 100 then
		self.Entity:SetPos( self.Entity:LocalToWorld(Vector(60,0,0)))
	end
end

function ENT:OnLandOnGround()
	self:CallInCoroutine(function(self, delay)
	if delay > 0.1 then return end
		self:EmitSound("NPC_dog.Grab_Alyx")
		self:PlaySequence("jump_end")
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
	self.loco:SetDeathDropHeight(1200)
	self:SetIsCrouching(false)
	self:SetCooldown("HWCrouch", 2)
	self:SetCooldown("HWUnCrouch", 2)
	self.CanChaseMusic = false
	self.CanSuperSprint = false
	self.NoVocal = false
	self.smoothTrack = self.Entity:LocalToWorld(Vector(200,0,100))
	self.DiloAngry = false
	self:SetAttack("bite", true)
	self:SetDefaultRelationship(D_HT)
	self:SequenceEvent("bite",1,self.AttackFunction)
	self:SetName("Huggy Wuggy_"..self:EntIndex())
end

function ENT:AttackFunction()
	if self.BiteCooldown < CurTime() then
		self:Attack({
			damage = 40,
			viewpunch = Angle(10, 10, 1),
			type = DMG_BLAST,range=100,angle=135
		}, function(self, hit)
			if #hit == 0 then self:snd("")return end 
			self:snd("npc/zombie/claw_strike"..math.random(2)..".wav")
		end)
		self.BiteCooldown = CurTime() + 0.1
	end
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
	self.WalkAnimation = "stalk"
	self.RunAnimation = "charge"
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
			//	v:AddEntityRelationship( self, D_HT, 100 )
			//	self:AddEntityRelationship( v, D_HT, 100 )
				self:SetEnemy(v)	 
			end
		end
				
	end
end

function ENT:CustomThink()
	local MySpeedSqr = tonumber(self:GetGroundSpeedVelocity():Length2DSqr())
	-- PrintMessage( HUD_PRINTTALK, MySpeedSqr )

	if MySpeedSqr == 0 and self:HasEnemy() then
		if timer.TimeLeft( "dilo_stuck" .. self:EntIndex() ) == nil then
			if self:HasEnemy() then
				-- PrintMessage( HUD_PRINTTALK, "Dilo stuck!" )
				if self.Entity:GetPos():Distance( self.Entity:GetPos() ) < 100 then
					self.Entity:SetPos( self.Entity:LocalToWorld(Vector(10,0,0)))
				end
			end
			timer.Create( "dilo_stuck" .. self:EntIndex(), 10, 1, function() end )
		end
	else
		timer.Stop( "dilo_stuck" .. self:EntIndex() )
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
		LastKnown = self:GetEnemy():GetPos()
	else
		LastKnown = self.Entity:LocalToWorld(Vector(200,0,20))
	end
	self.smoothTrack = LerpVector(5 * FrameTime() , self.smoothTrack , LastKnown)
	if self:IsPossessed() then
		self:DirectPoseParametersAt(self:PossessorTrace().HitPos, "aim_pitch", "aim_yaw", self:EyePos())
	else
		self:DirectPoseParametersAt(self.smoothTrack, "aim_pitch", "aim_yaw", self:EyePos())
	end
-- Noises.
	if timer.TimeLeft( "dilo_idle" .. self:EntIndex() ) == nil and self.NoVocal == false then
		if !self.DiloAngry == false then
			self:EmitSound("bryanjp19/dilo/angry"..math.random(1,9)..".wav")
			self:PlaySequence("vocalize",0.7)
		else
			self:EmitSound("bryanjp19/dilo/hoot"..math.random(1,16)..".wav")
		end
		timer.Create( "dilo_idle" .. self:EntIndex(), math.random(4,15), 1, function() end )
	end
	timer.Simple( math.random(10,1000), function() 
		self.DiloAngry = true
		self.CanSuperSprint = true
		self.ReachEnemyRange = 0
		self.AvoidEnemyRange = 0
	end)
end

function ENT:OnRemove()
	-- PrintMessage( HUD_PRINTTALK, "Dilo was removed." )
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
	-- PrintMessage( HUD_PRINTTALK, "Dilo died." )
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
		ent:Freeze(true)
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
	self.WalkAnimation = "hop"
	self:EmitSound("bryanjp19/dilo/hoot"..math.random(1,16)..".wav")
	if !self.ThemeSongLoop and npc_dilo_music:GetBool() then 
				self.ThemeSongLoop = CreateSound(game.GetWorld(),"bryanjp19/dilo/chasetheme.wav")
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
	self.DiloAngry = false
	self.ReachEnemyRange = 200
	self.AvoidEnemyRange = 180
end

function ENT:OnRemove()
	-- self:StopSound("bryanjp19/dilo/intro.wav")
	if self.ThemeSongLoop then 
		self.ThemeSongLoop:Stop()
	end
end

function ENT:FatalityAI()
    if enemy:Health() <= (enemy:GetMaxHealth()*0.25) then
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
        if self:GetHullRangeSquaredTo(ent) > 100^2 then return end
        succeed = true
        self.NoVocal = true

	local dmg = DamageInfo() dmg:SetAttacker(self)
	local ragdoll = ent:DrG_RagdollDeath(dmg)

	self.actualragdoll = self:GrabRagdoll(ragdoll, "spine", "grabber")
	self:SetGrabbedEnemy(ent)
        if ent:IsPlayer() then self:SetGrabbedPlayer(ent) self:FreezePlayer(ent) end
        return true
    end)
    if succeed then
        self:Timer(1.65,function()
			self:EmitSound("bryanjp19/dilo/bite"..math.random(1,2)..".wav")
        end)
        self:Timer(1.95,function()
            self:EmitSound("physics/body/body_medium_break"..math.random(2,3)..".wav")
            ParticleEffectAttach("blood_advisor_puncture",PATTACH_POINT_FOLLOW,self,3)
            for i=1,math.random(5,10) do ParticleEffectAttach("blood_impact_red_01",PATTACH_POINT_FOLLOW,self,3) end
            if (ent:IsPlayer() and !ent:Alive()) then
                ent:ScreenFade(SCREENFADE.IN,Color(255,0,0,255),0.3,0.2)
                self:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
            end
            if IsValid(self.actualragdoll) then
                self:DropAllRagdolls()
 				self.actualragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)
                self.actualragdoll:Fire("fadeandremove",1,10)
                local HeadBone = self.actualragdoll:DrG_SearchBone("spine")
            end
        end)
	if npc_dilo_music:GetBool() then
		self:EmitSound("bryanjp19/dilo/roar"..math.random(1,5)..".wav")
	end
	self:EmitSound("bryanjp19/dilo/roar"..math.random(1,5)..".wav")
        self:PlaySequenceAndMove("jumpscare")
    end
	self.NoVocal = false
end

function ENT:UpdateAI()
    self:UpdateHostilesSight()
    self:UpdateEnemy()
end

function ENT:OnMeleeAttack(enemy)
	self.NoVocal = true
	if enemy:Health() <= (enemy:GetMaxHealth()*0.25) then
		if enemy.VJ_IsHugeMonster then
			self:PlaySequence("bite",1,self.FaceEnemy)
		else
			self:Grab(enemy)
		end
	else
		if enemy:Health() < 200 then
			self:Grab(enemy)
		else
		    self:PlaySequence("bite",1,self.FaceEnemy)
		end
	end
	self.NoVocal = false
end

  -- These hooks are called when the nextbot has an enemy (inside the coroutine)

function ENT:OnRangeAttack(enemy)
	local attID = self:LookupAttachment("spit")
	local att = self:GetAttachment(attID)

	if self:GetPos():Distance(enemy:GetPos()) >= 1000 then
		local jumptr = util.TraceLine{
			start = self:GetPos()+self:GetVelocity()+self:OBBCenter(),
			endpos = self:GetPos()+self:GetVelocity()+self:OBBCenter()+Vector(0,0,420),
			filter = self
		}
		if not jumptr.Hit then
			if math.random(-450,450) == 0 then
				self:HWJump(80)
			end
		end
	end
	if self.DiloAngry == false then
		timer.Simple( math.random(10,1000), function() 
			self.DiloAngry = true
			self.CanSuperSprint = true
			self.ReachEnemyRange = 0
			self.AvoidEnemyRange = 0
		end)
	end
	if self:GetPos():Distance(enemy:GetPos()) < 600 then
		self.RunAnimation = "charge"
	else
		self.RunAnimation = "run"
	end
	if self:GetPos():Distance(enemy:GetPos()) < 300 and self.DiloAngry == true then
		-- Spit.
		if self.SpitCooldown < CurTime() then
			self:EmitSound("bryanjp19/dilo/spit"..math.random(1,7)..".wav")
			self:PlaySequenceAndMove("spit_in", 1, self.FaceEnemy)
			local proj = self:CreateProjectile("proj_DiloSpit")
			if not IsValid(proj) then return end
			proj:SetPos(self:GetPos() + Vector(0, 0, self:Height()*1.15))
			proj:GetPhysicsObject():EnableGravity(true)
			proj:DrG_AimAt(enemy, 1500)
			self:PlaySequenceAndMove("spit_out")
			self.SpitCooldown = CurTime() + math.random(4,14) 
		end
	else
		-- Do the roar.
		if self.DiloAngry == true then
			if self.RoarCooldown < CurTime() then
				self:EmitSound("bryanjp19/dilo/roar"..math.random(1,5)..".wav")
				self:PlaySequenceAndMove("roar", 1, self.FaceEnemy)
				self.RoarCooldown = CurTime() + math.random(15,60) 
			end
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

  -- function ENT:OnAvoidEnemy(enemy) end

  -- These hooks are called while the nextbot is patrolling (inside the coroutine)
  function ENT:OnReachedPatrol(pos) end 
  function ENT:OnPatrolUnreachable(pos) end
  function ENT:OnPatrolling(pos) end

  -- Those hooks are called inside the coroutine
function ENT:OnSpawn() end

  function ENT:OnIdle()
	DiloAngry = false
    self:AddPatrolPos(self:RandomPos(1500))
end

  -- Called outside the coroutine
  function ENT:OnTakeDamage(dmg, hitgroup)
    self:SpotEntity(dmg:GetAttacker())
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