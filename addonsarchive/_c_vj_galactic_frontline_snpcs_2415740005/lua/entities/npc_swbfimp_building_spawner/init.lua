AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/npc_sw_gempire/misc_building_hqtent.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 1200
ENT.vj_doi_isteam = "Axis"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GERMAN"} -- NPCs with the same class with be allied to each other

-- Tank Base
ENT.Tank_GunnerENT = "npc_vj_mili_tiger_redg"
ENT.Tank_SpawningAngle = 0
ENT.Tank_CollisionBoundSize = 52
ENT.Tank_CollisionBoundUp = 105
ENT.Tank_AngleDiffuseNumber = 0
ENT.Tank_ForwardSpead = 0 -- Forward speed
ENT.Tank_MoveAwaySpeed = 0 -- Move away speed
ENT.Tank_UseGetRightForSpeed = false -- Should it use GetRight instead of GetForward when driving?
ENT.Tank_SeeClose = 600 -- If the enemy is closer than this number, than move!
ENT.Tank_DeathSoldierModels = {}

ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false
ENT.DisableFindEnemy = true
ENT.PlayerFriendly = false
ENT.Behavior = VJ_BEHAVIOR_PASSIVE 
ENT.MoveOutOfFriendlyPlayersWay = false -- Should the SNPC move out of the way when a friendly player comes close to it?
ENT.Passive_RunOnTouch = false
ENT.Passive_RunOnDamage = false
ENT.ConstantlyFaceEnemy = false
ENT.ConstantlyFaceEnemy_IfVisible = false
ENT.ConstantlyFaceEnemy_IfAttacking = false
ENT.DisableSelectSchedule = true
ENT.DisableTakeDamageFindEnemy = true 
ENT.DisableTouchFindEnemy = true 
ENT.DisableMakingSelfEnemyToNPCs = true 
ENT.BringFriendsOnDeath = false
ENT.CallForBackUpOnDamage = false 
ENT.MoveOrHideOnDamageByEnemy = false 
ENT.Immune_AcidPoisonRadiation = false
ENT.Immune_Bullet = false

--CUSTOM SPAWNER

ENT.Spawner_CanSpawn = true
ENT.Spawner_RunCodeNextT = 0
ENT.Spawner_RunCodenexttime = 1
--ENT.Spawner_RangeCheck_activated = 0
--ENT.Spawner_RangeCheck_NextT = 0
--ENT.Spawner_RangeCheck_nexttime = 0

ENT.Spawner_Spawntime_min = 3
ENT.Spawner_Spawntime_max = 6
ENT.Spawner_Spawntime_bonustime = 3 --When soldiers alive is more than half of max soldier
ENT.Spawner_Spawntime_NextT = 0


ENT.Spawner_Actorlimit = 6 -- include the "special" actor
--ENT.Spawner_Actortablelist = {{Entityclass="npc_doi_german_heer_private",Weaponclass="weapon_doi_german_kar98k"}, --Put "none" in Weaponclass for no weapon
--						{Entityclass="npc_doi_german_heer_private",Weaponclass="weapon_doi_german_kar98k"},
--						{Entityclass="npc_doi_german_heer_private",Weaponclass="weapon_doi_german_kar98k"},
--						{Entityclass="npc_doi_german_heer_officer",Weaponclass="weapon_doi_german_mp40"},
--						{Entityclass="npc_doi_german_heer_officer",Weaponclass="weapon_doi_german_mp40"}
--						}

ENT.Spawner_SpecialActorlimit = 1 --The spawner will prioritize filling the "special" type actor before doing the normal ones -- Put zero to not have "special" actor
ENT.Spawner_SpecialActorNextT = 0
ENT.Spawner_SpecialActorNexttime = 4 --Timer to spawn special actor again, overridden by the normal timer
--ENT.Spawner_SpecialActortablelist = {{Entityclass="npc_doi_german_heer_engineer",Weaponclass="weapon_doi_german_mp40"},
--						{Entityclass="npc_doi_german_heer_engineer",Weaponclass="weapon_doi_german_mp40"},
--						{Entityclass="npc_doi_german_heer_medic",Weaponclass="weapon_doi_german_luger"}
--						}
--ENT.Spawner_SpawnPositionTbl = {Vector(-27,-81,12),Vector(26,-81,12)} --Local to World
ENT.Spawner_SpawnPositionCheckRadius = 30

ENT.Spawner_EnemyCheckRadius = 10000
ENT.Spawner_EnemyCheckNextT = 0
ENT.Spawner_EnemyCheckNexttime = 5
ENT.Spawner_EnemyFound = NULL

--ENT.Prop_table = {{Model="models/npc_doi/misc_building_gercrate01.mdl",Pos=Vector(57,42,0),Ang=Angle(0,0,0)},{Model="models/npc_doi/misc_building_gercrate02.mdl",Pos=Vector(61,-36,0),Ang=Angle(0,0,0)}}

ENT.HasIdleSounds = true -- Does it have idle sounds?
ENT.SoundTbl_Idle = {}
ENT.IdleSoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.IdleSoundLevel = 80
ENT.IdleSoundPitch1 = 80
ENT.IdleSoundPitch2 = 100
ENT.NextSoundTime_Idle1 = 0.2
ENT.NextSoundTime_Idle2 = 0.5
ENT.SoundTbl_SpawnEntity = {}
ENT.SpawnEntitySoundChance = 1 -- How much chance to play the sound? 1 = always
ENT.SpawnEntitySoundLevel = 80
ENT.SpawnEntitySoundPitch1 = 80
ENT.SpawnEntitySoundPitch2 = 100
	-- Independent Variables ------


---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Tank_GunnerSpawnPosition()
	return self:GetPos() +self:GetUp()*92 +self:GetRight()*-20
end
---------------------------------------------------------------------------------------------------------------------------------------------

function ENT:CustomInitialize_CustomTank()
	self.Spawner_TotalActorTbl = {}
	self.Spawner_ActorTbl = {}
	self.Spawner_SpecialActorTbl = {}
	
	local canspawn = self.Spawner_CanSpawn
	self.Spawner_CanSpawn = false
	self.Spawner_EnemyCheckNextT = CurTime() + self.Spawner_EnemyCheckNexttime
	self.Spawner_RunCodeNextT = CurTime() + self.Spawner_RunCodenexttime
	self.Spawner_Spawntime_NextT = CurTime() + math.random(self.Spawner_Spawntime_min,self.Spawner_Spawntime_max)
	timer.Simple(0.12,function()
	if IsValid(self) && self.Dead == false then
		table.Empty(self.Spawner_TotalActorTbl)
		table.Empty(self.Spawner_ActorTbl)
		table.Empty(self.Spawner_SpecialActorTbl)
		self.Spawner_CanSpawn = canspawn
		if GetConVarNumber("vj_swbfimp_snpc_hqspawner_respawntimemod") != 0 then
			self.Spawner_Spawntime_min = self.Spawner_Spawntime_min*GetConVarNumber("vj_advancedoi_snpc_hqspawner_respawntimemod")
			self.Spawner_Spawntime_max = self.Spawner_Spawntime_max*GetConVarNumber("vj_advancedoi_snpc_hqspawner_respawntimemod")
			self.Spawner_Spawntime_bonustime = self.Spawner_Spawntime_bonustime*GetConVarNumber("vj_advancedoi_snpc_hqspawner_respawntimemod")
		end
		if GetConVarNumber("vj_swbfimp_snpc_hqspawner_maxsoldiermod") != 0 then
			self.Spawner_Actorlimit = self.Spawner_Actorlimit*GetConVarNumber("vj_advancedoi_snpc_hqspawner_maxsoldiermod")
			self.Spawner_SpecialActorlimit = self.Spawner_SpecialActorlimit*GetConVarNumber("vj_advancedoi_snpc_hqspawner_maxsoldiermod")
		end
	end
	end)
end

function ENT:CustomOnInitialize()

	self:CustomInitialize_CustomTank()
	self:PhysicsInit(SOLID_BBOX) // SOLID_VPHYSICS
	self:SetSolid(SOLID_BBOX)
	self:SetAngles(self:GetAngles()+Angle(0,self.Tank_SpawningAngle,0))
	self:SetCollisionBounds(Vector(self.Tank_CollisionBoundSize, self.Tank_CollisionBoundSize, self.Tank_CollisionBoundUp), Vector(-self.Tank_CollisionBoundSize, -self.Tank_CollisionBoundSize, -10))
	
	self.Spawner_SpawnPositionTbl = {Vector(-27,-91,12),Vector(26,-91,12)}
	self.Spawner_Actortablelist = {
						--{Entityclass="npc_doi_german_heer_officer",Weaponclass="weapon_doi_german_mp40"}
						}
	self.Spawner_SpecialActortablelist = {
						}
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(30000)
	end

	self.Gunner = ents.Create("prop_dynamic")
	self.Gunner:SetModel("models/npc_sw_gempire/misc_building_hqtent.mdl")
	self.Gunner:SetPos(self:Tank_GunnerSpawnPosition())
	self.Gunner:SetAngles(self:GetAngles())
	self.Gunner:Spawn()
	self.Gunner:SetParent(self)
	self.Gunner:SetNoDraw(true)
	
	self:SetSkin( 1 )
	
	//self:DropToFloor()

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartSpawnEffects()

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:StartMoveEffects()

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randpos = math.random(1,7)
	if randpos == 1 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*100 +self:GetUp()*60) else
	if randpos == 2 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*30 +self:GetUp()*60) end
	if randpos == 3 then return self.Spark1:SetLocalPos(self.WhiteLight1:GetPos()) end
	if randpos == 4 then return self.Spark1:SetLocalPos(self.WhiteLight2:GetPos()) end
	if randpos == 5 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*10 +self:GetUp()*60 +self:GetRight()*50) end
	if randpos == 6 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*80 +self:GetUp()*60 +self:GetRight()*-50) end
	if randpos == 7 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*-20 +self:GetUp()*60 +self:GetRight()*-30) end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTouch(entity)
	if GetConVarNumber("ai_disabled") == 1 then return end

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TANK_RUNOVER_DAMAGECODE(argent)
	// if self.HasMeleeAttack == false then return end

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:AngleDiffuse(ang1, ang2)
	local outcome = ang1 - ang2
	if outcome < -180 then outcome = outcome + 360 end
	if outcome > 180 then outcome = outcome - 360 end
	return outcome
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()
	if GetConVarNumber("vj_npc_noidleparticle") == 1 then return end
	timer.Simple(0.1,function()
		if IsValid(self) && self.Dead == false then
			--self:StartSpawnEffects()
		end
	end)

	if self:Health() < (self.StartHealth*0.30) && CurTime() > self.Tank_NextLowHealthSmokeT then
		//ParticleEffectAttach("vj_rpg2_smoke2", PATTACH_ABSORIGIN_FOLLOW, self, 0)

		self.Spark1 = ents.Create("env_spark")
		self.Spark1:SetKeyValue("MaxDelay",0.01)
		self.Spark1:SetKeyValue("Magnitude","8")
		self.Spark1:SetKeyValue("Spark Trail Length","3")
		self:GetNearDeathSparkPositions()
		self.Spark1:SetAngles(self:GetAngles())
		//self.Spark1:Fire("LightColor", "255 255 255")
		self.Spark1:SetParent(self)
		self.Spark1:Spawn()
		self.Spark1:Activate()
		self.Spark1:Fire("StartSpark", "", 0)
		self.Spark1:Fire("kill", "", 0.1)
		self:DeleteOnRemove(self.Spark1)

		/*local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos() +self:GetUp()*60 +self:GetForward()*100)
		effectdata:SetNormal(Vector(0,0,0))
		effectdata:SetMagnitude(5)
		effectdata:SetScale(0.1)
		effectdata:SetRadius(10)
		util.Effect("Sparks",effectdata)*/
		self.Tank_NextLowHealthSmokeT = CurTime() + math.random(4,6)
	end

end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	//timer.Simple(0.1, function() if self.Dead == false then ParticleEffect("smoke_exhaust_01",self:LocalToWorld(Vector(150,30,30)),Angle(0,0,0),self) end end)
	//timer.Simple(0.2, function() if self.Dead == false then self:StopParticles() end end)

	if self.Spawner_CanSpawn == true then
	if CurTime() > self.Spawner_RunCodeNextT then
	self.Spawner_RunCodeNextT = CurTime() + self.Spawner_RunCodenexttime
	local spawningengaged = 0
	if table.Count(self.Spawner_TotalActorTbl) > 0 then
		--print(table.Count(self.Spawner_TotalActorTbl))
		for ks,vs in ipairs(self.Spawner_TotalActorTbl) do
			if !IsValid(vs) or (IsValid(vs) and vs.Dead != nil and vs.Dead == true) then
				table.RemoveByValue(self.Spawner_TotalActorTbl, vs) 
			end
		end
	end
	if table.Count(self.Spawner_ActorTbl) > 0 then
		for ksa,vsa in ipairs(self.Spawner_ActorTbl) do
			if !IsValid(vsa) or (IsValid(vsa) and vsa.Dead != nil and vsa.Dead == true) then
				table.RemoveByValue(self.Spawner_ActorTbl, vsa) 
			end
		end
	end
	if table.Count(self.Spawner_SpecialActorTbl) > 0 then
		for kss,vss in ipairs(self.Spawner_SpecialActorTbl) do
			if !IsValid(vss) or (IsValid(vss) and vss.Dead != nil and vss.Dead == true) then
				table.RemoveByValue(self.Spawner_SpecialActorTbl, vss) 
			end
		end
	end
	
	
	if CurTime() > self.Spawner_Spawntime_NextT and table.Count(self.Spawner_TotalActorTbl) < self.Spawner_Actorlimit then
	
	if spawningengaged == 0 and self.Spawner_SpecialActorNextT < CurTime() and table.Count(self.Spawner_SpecialActorTbl) < self.Spawner_SpecialActorlimit then
		spawningengaged = 1
		self:SpawnAnEntity(self.Spawner_SpecialActortablelist,true,false)
	end
	
	if spawningengaged == 0 and table.Count(self.Spawner_ActorTbl) < self.Spawner_Actorlimit then
		spawningengaged = 1
		self:SpawnAnEntity(self.Spawner_Actortablelist,false,false)
	end
	
	
	
	
	end
	
	
	end
	end
	
	
	if self.Spawner_EnemyCheckNextT < CurTime() then
	self.Spawner_EnemyCheckNextT = CurTime() + self.Spawner_EnemyCheckNexttime
	local enemyent = NULL
	
	--if enemyent != NULL and enemyent != nil then
		
		for kw,vw in pairs(self.Spawner_TotalActorTbl) do
			if IsValid(vw) and vw:Health() > 0 and vw.Dead != true then
			if !IsValid(vw:GetEnemy()) and vw:IsMoving() == false and vw.vACT_StopAttacks != true and vw.CurrentSchedule == nil then
			
			if enemyent == NULL or !IsValid(enemyent) then
			local entlist1 = ents.FindInSphere(self:GetPos(),self.Spawner_EnemyCheckRadius)
			for kc,vc in pairs(entlist1) do
			if enemyent == NULL or !IsValid(enemyent) then
			if !vc:IsNPC() && !vc:IsPlayer() then continue end
			if vc:EntIndex() != vw:EntIndex() && vc:Health() > 0 then
			if vw:DoRelationshipCheck(vc) == true then
				enemyent = vc
			end
			end
			end
			end
			end
			if enemyent != NULL and enemyent != nil and IsValid(enemyent) then
			if vw:IsUnreachable(enemyent) == false then
					vw:SetLastPosition(enemyent:GetPos())
					vw:StopMoving()
					--self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true end)
					vw:VJ_TASK_GOTO_LASTPOS(VJ_PICKRANDOMTABLE({"TASK_RUN_PATH","TASK_RUN_PATH"}),function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.CanBeInterrupted = true x.StopScheduleIfNotMoving = true end)
					vw.NextWanderTime = CurTime() + math.Rand(4,6)*3
			end
			end
			
			end
			end
		end
		
	end
	
	--end
	
	--self:CustomOnSchedule()


end

function ENT:SpawnAnEntity(tbl,isspecialspawn,initspawn)
	
	--local enta = tbl
	local specialactor = isspecialspawn or false
	--local v = values
	local initspawn = initspawn or false
	local overridedisable = false

	if self.Spawner_CanSpawn == false && overridedisable == false then return end
	
	local chosenpos = Vector(0,0,0)
	local posisok = 1
	local entitytospawn = VJ_PICKRANDOMTABLE(tbl)
	--local spawnpos = VJ_PICKRANDOMTABLE(self.Spawner_SpawnPositionTbl)
	for g,vpos in pairs(self.Spawner_SpawnPositionTbl) do
	posisok = 1
	local FindEnts = ents.FindInSphere(self:LocalToWorld(vpos),self.Spawner_SpawnPositionCheckRadius)
	if FindEnts != nil then
		for _,vent in pairs( FindEnts ) do
		if IsValid(vent) and vent:IsWeapon() == false and vent:IsWorld() == false and vent != self and vent != self.Gunner  and vent:EntIndex() != self:EntIndex() and vent:IsSolid() and vent:GetSolid() > 0 and (vent:GetCollisionGroup() == 0 or vent:IsPlayer() == true or vent:IsNPC() == true) then
			posisok = 0
		end
		end
	end
	if posisok == 1 then chosenpos = self:LocalToWorld(vpos) end
	end
	
	if chosenpos != Vector(0,0,0) then
	
	local getthename = ents.Create(entitytospawn.Entityclass)
	getthename:SetPos(chosenpos)
	getthename:SetAngles( Angle(0,self:GetAngles().y,0) ) 
	getthename:Spawn()
	getthename:Activate()
	
	if entitytospawn.Weaponclass != "none" then getthename:Give(entitytospawn.Weaponclass) end
	
	--if initspawn == false then table.remove(self.CurrentEntities,k) end
	table.insert(self.Spawner_TotalActorTbl,getthename)
	if specialactor == true then
		table.insert(self.Spawner_SpecialActorTbl,getthename)
		self.Spawner_SpecialActorNextT = CurTime() + self.Spawner_SpecialActorNexttime
	else
		table.insert(self.Spawner_ActorTbl,getthename)
	end
	
	if table.Count(self.Spawner_TotalActorTbl) > self.Spawner_Actorlimit/2 then
		self.Spawner_Spawntime_NextT = CurTime() + math.random(self.Spawner_Spawntime_min,self.Spawner_Spawntime_max) + self.Spawner_Spawntime_bonustime
	else
		self.Spawner_Spawntime_NextT = CurTime() + math.random(self.Spawner_Spawntime_min,self.Spawner_Spawntime_max)
	end
	self:SpawnEntitySoundCode()
	--if self.VJBaseSpawnerDisabled == true && overridedisable == true then getthename:Remove() return end
	self:CustomOnEntitySpawn(getthename)
		timer.Simple(0.2,function()
		if IsValid(getthename) then
			getthename.NextWanderTime = CurTime()+0.3
		end
		end)
	end
	
end

function ENT:CustomOnEntitySpawn(ent)


end

function ENT:SpawnEntitySoundCode()
	if self.HasIdleSounds == false then return end
	local randomidlesound = math.random(1,2)
	if randomidlesound == 1 then
		self.CurrentSpawnEntitySound = VJ_CreateSound(self,self.SoundTbl_SpawnEntity,self.SpawnEntitySoundLevel,math.random(self.SpawnEntitySoundPitch1,self.SpawnEntitySoundPitch2))
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnSchedule()
	if self:Health() <= 0 or self.Dead == true then return end

	self:IdleSoundCode()

	if !IsValid(self:GetEnemy()) then
		if self.Tank_ResetedEnemy == false then
		self.Tank_ResetedEnemy = true
		self:ResetEnemy() end
	else
		EnemyPos = self:GetEnemy():GetPos()
		EnemyPosToSelf = self:GetPos():Distance(EnemyPos)
		if self.VJ_IsBeingControlled == true then
			if self.VJ_TheController:KeyDown(IN_FORWARD) then
				self.Tank_Status = 0
			else
				self.Tank_Status = 1
			end
		elseif self.VJ_IsBeingControlled == false then
			if EnemyPosToSelf > self.Tank_SeeLimit then -- If larger than this number than, move
				self.Tank_Status = 0
			elseif EnemyPosToSelf < self.Tank_SeeFar && EnemyPosToSelf > self.Tank_SeeClose then -- If between this two numbers, stay still
				self.Tank_Status = 1
			else
				self.Tank_Status = 0
			end
		end
	end
end

function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)
	util.BlastDamage(self, self, self:GetPos(), 400, 40)
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)

	-- Spawn the gunner
	if IsValid(self.Gunner) then
		self.Gunner:Remove()
	end
	
	

	-- Spawn the Soldier
	local panisrand = math.random(1,3)
	if panisrand == 1 then
		--self:CreateExtraDeathCorpse("prop_ragdoll",VJ_PICKRANDOMTABLE(self.Tank_DeathSoldierModels),{Pos=self:GetPos()+self:GetUp()*90+self:GetRight()*-30,Vel=Vector(math.Rand(-600,600), math.Rand(-600,600),500)},function(extraent) extraent:Ignite(math.Rand(8,10),0) extraent:SetColor(Color(90,90,90)) end)
	end

	self:SetPos(Vector(self:GetPos().x,self:GetPos().y,self:GetPos().z +4)) -- Because the NPC is too close to the ground
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() - Vector(0, 0, 500),
		filter = self
	})
	util.Decal("Scorch",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)

	if self.HasGibDeathParticles == true then
		//self.FireEffect = ents.Create( "env_fire_trail" )
		//self.FireEffect:SetPos(self:GetPos()+self:GetUp()*70)
		//self.FireEffect:Spawn()
		//self.FireEffect:SetParent(GetCorpse)
		//ParticleEffectAttach("smoke_large_01b",PATTACH_ABSORIGIN_FOLLOW,GetCorpse,0)
		ParticleEffect("vj_explosion3",self:GetPos(),Angle(0,0,0),nil)
		ParticleEffect("vj_explosion2",self:GetPos() +self:GetForward()*-130,Angle(0,0,0),nil)
		ParticleEffect("vj_explosion2",self:GetPos() +self:GetForward()*130,Angle(0,0,0),nil)
		ParticleEffectAttach("smoke_burning_engine_01",PATTACH_ABSORIGIN_FOLLOW,GetCorpse,0)
		local explosioneffect = EffectData()
		explosioneffect:SetOrigin(self:GetPos())
		util.Effect("VJ_Medium_Explosion1",explosioneffect)
		util.Effect("Explosion", explosioneffect)
		local dusteffect = EffectData()
		dusteffect:SetOrigin(self:GetPos())
		dusteffect:SetScale(800)
		util.Effect("ThumperDust",dusteffect)
	end
	
	if GetCorpse != nil and GetCorpse != NULL then GetCorpse:Remove() end
	
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TANK_MOVINGSOUND()
	if self.HasSounds == true && GetConVarNumber("vj_npc_sd_footstep") == 0 then
		--self.tank_movingsd = CreateSound(self,"vj_mili_tank/tankdriving1.wav") self.tank_movingsd:SetSoundLevel(80)
	--	self.tank_movingsd:PlayEx(1,100)

		--self.tank_tracksd = CreateSound(self,"vj_mili_tank/tanktrack1.wav") self.tank_tracksd:SetSoundLevel(70)
		--self.tank_tracksd:PlayEx(1,100)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)
	local panis = dmginfo:GetDamageType()
	
	if (panis == DMG_SLASH or panis == DMG_BULLET or panis == DMG_GENERIC or panis == DMG_CLUB) then
		if dmginfo:GetDamage() >= 4  then
			dmginfo:SetDamage(dmginfo:GetDamage() /4)
		else
			dmginfo:SetDamage(0)
		end
	end
	
end








---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetNearDeathSparkPositions()
	local randpos = math.random(1,7)
	if randpos == 1 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*90 +self:GetUp()*60 +self:GetRight()*-100) else
	if randpos == 2 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*-50 +self:GetUp()*100 +self:GetRight()*40) end
	if randpos == 3 then return self.Spark1:SetLocalPos(self:GetPos()+self:GetUp()*100 +self:GetRight()*-190 +self:GetForward()*-20) end 
	if randpos == 4 then return self.Spark1:SetLocalPos(self:GetPos()+self:GetUp()*100 +self:GetRight()*-140) end
	if randpos == 5 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*30 +self:GetUp()*70 +self:GetRight()*70) end
	if randpos == 6 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*80 +self:GetUp()*90 +self:GetRight()*-30) end
	if randpos == 7 then return self.Spark1:SetLocalPos(self:GetPos() +self:GetForward()*-100 +self:GetUp()*70 +self:GetRight()*-80) end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/