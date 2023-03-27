AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/krieg/galacticempire/weapons/e_web_tripod.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 4000
ENT.HullType = HULL_HUMAN
ENT.SightDistance = 6200 -- How far it can see
ENT.MovementType = VJ_MOVETYPE_STATIONARY -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
--ENT.Behavior = VJ_BEHAVIOR_PASSIVE_NATURE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {}
ENT.HasAllies = true
ENT.HasMeleeAttack = false -- Should the SNPC have a melee attack?
ENT.Immune_AcidPoisonRadiation = true -- Immune to Acid, Poison and Radiation
ENT.Immune_Bullet = true -- Immune to Bullets
ENT.Immune_Physics = false -- Immune to Physics
ENT.DisableFindEnemy = true -- Disables FindEnemy code, friendly code still works though
ENT.DisableSelectSchedule = true -- Disables Schedule code, Custom Schedule can still work
ENT.DisableTakeDamageFindEnemy = true -- Disable the SNPC finding the enemy when being damaged
ENT.DisableTouchFindEnemy = true -- Disable the SNPC finding the enemy when being touched
ENT.FindEnemy_UseSphere = true -- Should the SNPC be able to see all around him? (360) | Objects and walls can still block its sight!
ENT.CallForHelp = false -- Does the SNPC call for help?
ENT.DisableWandering = true -- Disables wandering when the SNPC is idle
ENT.BringFriendsOnDeath = false -- Should the SNPC's friends come to its position before it dies?
ENT.CallForBackUpOnDamage = false -- Should the SNPC call for help when damaged? (Only happens if the SNPC hasn't seen a enemy)
ENT.MoveOrHideOnDamageByEnemy = false -- Should the SNPC move or hide when being damaged by an enemy?
ENT.DisableMakingSelfEnemyToNPCs = true

ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeDistance = 40000 -- This is how far away it can shoot
ENT.RangeDistanceEffective = 5500 -- After this distance the mg become quite inaccurate
ENT.RangeToMeleeDistance = 10 -- How close does it have to be until it uses melee?
ENT.TimeUntilRangeAttackProjectileRelease = 0.1 -- How much time until the projectile code is ran?
ENT.DisableDefaultRangeAttackCode = true -- When true, it won't spawn the range attack entity, allowing you to make your own
ENT.DisableRangeAttackAnimation = true -- if true, it will disable the animation code
ENT.RangeAttackAngleRadius = 55
ENT.NextRangeAttackTime = 0.04 -- How much time until it can use a range attack? --Rate of fire
ENT.HasBloodParticle = true -- Does it spawn a particle when damaged?
ENT.SetCorpseOnFire = true -- Sets the corpse on fire when the SNPC dies
ENT.UsesBoneAngle = true -- This can be used to stop the corpse glitching or flying on death



//ENT.SoundTbl_RangeAttack = {"vj_emplacements/m2/m2_tp.wav"}

ENT.RangeAttackPitch1 = 100
ENT.RangeAttackPitch2 = 100
ENT.RangeAttackSoundLevel = 85

-- Custom
ENT.Emp_MaxAmmo = 275
ENT.Emp_CurrentAmmo = 0
ENT.Emp_Reloading = false

ENT.Emp_Lerp_Yaw = 0
ENT.Emp_Lerp_Ptich = 0
ENT.Emp_Lerp_Ptich_Previous = 0

ENT.Emp_CanReload = true
--CUSTOM--
ENT.AttackHeightRatioLimit = 0.45
ENT.Bullet_NextT = 0
ENT.Bullet_Nexttime = 0.1
ENT.Bullet_Range = 4000
ENT.Bullet_Charging = 0
ENT.Bullet_Chargedone = 0
ENT.Bullet_ChargeresetNextT = 0
ENT.Bullet_ChargeresetNexttime = 2
ENT.Bullet_Chargetime_min = 25 --Reaction time of gun divided by 100
ENT.Bullet_Chargetime_max = 45
ENT.Bullet_Accuracy = 50 --Original 50 --Lower means more spread
ENT.Bullet_Position = Vector(-27.0,0.7,3.4) --LocaltoWorld of the gun model
ENT.Bullet_Damage = 35
ENT.Bullet_Burstmin = 5
ENT.Bullet_Burstmax = 8
ENT.Bullet_Burst = 0
ENT.Bullet_Cooldown_min = 0.5
ENT.Bullet_Cooldown_max = 0.9
ENT.Bullet_Reloadtime = 1.6
ENT.Bullet_Coolingdown = 0
ENT.Bullet_CooldownautoNextT = 0
ENT.Bullet_CooldownautoNexttime = 1.5
ENT.Bullet_Fired = 0
ENT.Bullet_Firesound = "weapons/dlt19/dlt19_fire.wav"
ENT.Bullet_FiresoundDist = "weapons/dlt19/dlt19_distant.wav"
ENT.Bullet_Reloadsound = {"weapons/sw_reload1.ogg","weapons/sw_reload2.ogg","weapons/sw_reload3.ogg"}
ENT.Bullet_Reloadmodel = ""
ENT.Bullet_TracerType = "ks_effect_sw_laser_red"
ENT.Bullet_AltDMG = DMG_BLAST
ENT.Bullet_AltDMGChance = 10

ENT.Crew_Gunner = NULL
ENT.Crew_GunnerPosition = Vector(52,10,0)
ENT.Crew_FoundEnt = NULL
ENT.Crew_GunnerAnim = "vjseq_man_gun"
ENT.Crew_GunnerAnim2 = "Man_Gun"
ENT.ExtraGunAngleDiffuse = 180 --270
ENT.ExtraGunAngleDiffuseGeneral = 15
ENT.IsUsableByCrew = true
ENT.DoSearchCrew = true
ENT.EnterCrew_Range = 208
ENT.EnterCrew_CheckNextT = 0
ENT.SearchCrew_Range = 100
ENT.SearchCrew_Amount = 1
ENT.SearchCrew_NextT = 0
ENT.SearchCrew_Nexttime = 1
ENT.SearchCrewReset_NextT = 0
ENT.SearchCrewReset_Nexttime = 8

ENT.CanCrewDischarge = true
ENT.Crew_Discharging = 0
ENT.Crew_DischargeCheckNextT = 0
ENT.Crew_DischargeCheckNexttime = 1

ENT.Crew_Gunner_Setupdone = 0
ENT.Crew_Gunner_CanFlinch = 0
ENT.Crew_Gunner_Idleanim = 0
ENT.Crew_Gunner_Callforhelp = false
ENT.Crew_Gunner_Weapon = ""
ENT.Crew_Gunner_Weaponammo = 0
ENT.Crew_Gunner_Movetype = 0
ENT.Crew_Gunner_DisableWeapon = false
ENT.Crew_Gunner_Medic = false
ENT.Crew_Gunner_TakeCover = true
ENT.Crew_Gunner_HasPoseParameterLooking = true
ENT.Crew_Gunner_Grenade = true
ENT.Crew_Gunner_Secondaryweapon = true
ENT.Crewweapon_switchanimation = "vjseq_smgdraw"





	-- ====== Dismemberment/Gib Variables ====== --
ENT.AllowedToGib = false -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = false -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {"UseDefault"} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = false -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = false -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu






function ENT:CustomOnInitialKilled(dmginfo, hitgroup) 

	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	util.Effect( "ThumperDust", effectdata )
	util.Effect( "Explosion", effectdata )
	util.Effect( "WheelDust", effectdata )
	util.Effect( "ManhackSparks", effectdata )

	self.ExplosionLight1 = ents.Create("light_dynamic")
	self.ExplosionLight1:SetKeyValue("brightness", "4")
	self.ExplosionLight1:SetKeyValue("distance", "300")
	self.ExplosionLight1:SetLocalPos(self:GetPos())
	self.ExplosionLight1:SetLocalAngles( self:GetAngles() )
	self.ExplosionLight1:Fire("Color", "255 150 0")
	self.ExplosionLight1:SetParent(self)
	self.ExplosionLight1:Spawn()
	self.ExplosionLight1:Activate()
	self.ExplosionLight1:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(self.ExplosionLight1)
	util.ScreenShake(self:GetPos(), 100, 200, 1, 2500)
	
	

end








---------------------------------------------------------------------------------------------------------------------------------------------

function ENT:CustomOnInitialize()

	self:CustomOnInitialize_extra()
	self:SetCollisionBounds(Vector(10, 10, 40), Vector(-10, -10, -1))
	
	self.ExtraGunModel = ents.Create("prop_vj_animatable")
	self.ExtraGunModel:SetModel("models/krieg/galacticempire/weapons/e_web_turret_armored.mdl")
	self.ExtraGunModel:SetLocalPos( self:LocalToWorld( Vector(0,0,0) ) )
	self.ExtraGunModel:SetLocalAngles(Angle(self:GetAngles().p,self:GetAngles().y-0,self:GetAngles().r))
	self.ExtraGunModel:SetOwner(self)
	self.ExtraGunModel:SetParent(self)
	self.ExtraGunModel:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self.ExtraGunModel:Spawn()
	self.ExtraGunModel:Activate()
	self.ExtraGunModel:SetNoDraw(true)
	
	self.ExtraGunModel2 = ents.Create("prop_vj_animatable")
	self.ExtraGunModel2:SetModel("models/krieg/galacticempire/weapons/e_web_turret_armored.mdl")
	self.ExtraGunModel2:SetLocalPos(self:LocalToWorld( Vector(0,0,0) ) )
															--FB  --LR --H
	self.ExtraGunModel2:SetLocalAngles(Angle(self:GetAngles().p,self:GetAngles().y-0,self:GetAngles().r))
	self.ExtraGunModel2:SetOwner(self)
	self.ExtraGunModel2:SetParent(self.ExtraGunModel)
	self.ExtraGunModel2:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self.ExtraGunModel2:Spawn()
	self.ExtraGunModel2:Activate()
	
	
	self:CustomOnInitialize_extrastuff()
	
	self.Emp_CurrentAmmo = self.Emp_MaxAmmo
	
	self.VJ_NoTarget = true
	self.FriendlyToVJSNPCs = true
	self.Bullet_Burst = math.random(self.Bullet_Burstmin,self.Bullet_Burstmax)
end

function ENT:CustomOnInitialize_extrastuff()
end

function ENT:CustomOnInitialize_extra()

	if GetConVarNumber("vj_advancedoi_snpc_statweapondmgmod") != nil and GetConVarNumber("vj_advancedoi_snpc_statweapondmgmod") != 0 then
		self.Bullet_Damage = self.Bullet_Damage*GetConVarNumber("vj_advancedoi_snpc_statweapondmgmod")
	end

end


function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup) 

	if IsValid(self.Crew_Gunner) and self.Crew_Gunner != NULL and self.Crew_Gunner != nil then
	local DamageInflictor = dmginfo:GetInflictor()
	if IsValid(DamageInflictor) then local DamageInflictorClass = DamageInflictor:GetClass() end
	local DamageAttacker = dmginfo:GetAttacker()
	if IsValid(DamageAttacker) then local DamageAttackerClass = DamageAttacker:GetClass() end
	local DamageType = dmginfo:GetDamageType()
	
		if VJ_PICKRANDOMTABLE(DamageAttacker.VJ_NPC_Class) == VJ_PICKRANDOMTABLE(self.Crew_Gunner.VJ_NPC_Class) then
			dmginfo:ScaleDamage( 0 )
			dmginfo:SetDamage( 0 )
		end
		

		if DamageAttacker.vj_doi_isteam != nil then
		if self.Crew_Gunner.vj_doi_isteam == DamageAttacker.vj_doi_isteam then
		
			dmginfo:SetDamage( 0 )
			dmginfo:ScaleDamage( 0 )

		else

		end
		end
		
		if dmginfo:GetDamage() > 0 then
		if self.Crew_Gunner:DoRelationshipCheck(DamageAttacker) == false then
			dmginfo:ScaleDamage( 0 )
			dmginfo:SetDamage( 0 )
		end
		end
		
		
	end
end


function ENT:CustomSetupCrew(ent) --ent is the crew
	if ent != nil and ent != NULL and IsValid(ent) then
	
	self.Crew_Gunner_CanFlinch = ent.CanFlinch 
	ent.CanFlinch = 0
	
	if ent.OriginalAnimTbl_IdleStand != nil then 
	self.Crew_Gunner_Idleanim = ent.OriginalAnimTbl_IdleStand
	else
	self.Crew_Gunner_Idleanim = ent.AnimTbl_IdleStand
	end
	ent.AnimTbl_IdleStand = {ACT_IDLE_MANNEDGUN}
	ent.CurrentAnim_IdleStand = ACT_IDLE_MANNEDGUN
	
	self.Crew_Gunner_Callforhelp = ent.CallForHelp
	ent.CallForHelp = false
	ent.CallForBackUpOnDamage = false
	
	self.Crew_Gunner_Medic = ent.IsMedicSNPC
	ent.IsMedicSNPC = false
	
	if ent:GetActiveWeapon() != nil and ent:GetActiveWeapon() != NULL then
	self.Crew_Gunner_Weapon = ent:GetActiveWeapon():GetClass()
	self.Crew_Gunner_Weaponammo = ent.Weapon_ShotsSinceLastReload
	ent:GetActiveWeapon():Remove()
	end
	
	self.Crew_Gunner_Movetype = ent.MovementType
	ent:DoChangeMovementType(VJ_MOVETYPE_STATIONARY)
	ent.CanTurnWhileStationary = false
	
	self.Crew_Gunner_DisableWeapon = ent.DisableWeapons
	ent.DisableWeapons = true
	ent.HasMeleeAttack = false
	ent.DisableWeaponFiringGesture = true
	ent:CapabilitiesRemove(CAP_USE_WEAPONS)
	ent:CapabilitiesRemove(CAP_WEAPON_RANGE_ATTACK1)
		
	self.Crew_Gunner_Grenade = ent.HasGrenadeAttack
	ent.HasGrenadeAttack = false
	
	self.Crew_Gunner_TakeCover = ent.MoveOrHideOnDamageByEnemy
	ent.MoveOrHideOnDamageByEnemy = false
	
	self.Crew_Gunner_HasPoseParameterLooking = ent.HasPoseParameterLooking
	ent:ClearPoseParameters()
	ent.HasPoseParameterLooking = false
	
	if ent.CanUseSecondaryweapon != nil then
	self.Crew_Gunner_Secondaryweapon = ent.CanUseSecondaryweapon
	ent.CanUseSecondaryweapon = false
	end
	
	self.Crew_Gunner = ent
	self.Crew_Gunner_Setupdone = 1
	self.Crew_FoundEnt = NULL
	
	self:CustomManipulateBoneCrew(self.Crew_Gunner)

	end
end

function ENT:CustomSetupCrewReset(ent) --ent is the crew
	if ent != nil and ent != NULL and IsValid(ent) then
	
	ent.VJ_IsPlayingInterruptSequence = false
	ent.VJ_PlayingSequence = false
	ent.vACT_StopAttacks = false
	ent:ClearSchedule()
	ent:StopMoving()
	ent.NextChaseTime = CurTime() + 4
	ent.NextIdleTime = CurTime() + 4
	
	local crewpos = self.ExtraGunModel:LocalToWorld(self.Crew_GunnerPosition)
	local thepos = Vector(crewpos.x,crewpos.y,self:GetPos().z+6)
	ent:SetPos( Vector(crewpos.x,crewpos.y,self:GetPos().z+6) )
	ent:SetAngles( Angle(0,self.ExtraGunModel:GetAngles().y-self.ExtraGunAngleDiffuse,0) ) 
		timer.Simple(0.1,function()
		if IsValid(ent) then
				ent:ClearSchedule()
				ent:StopMoving()
				ent:SetPos( thepos )
		end
		end)
	
	ent.CanFlinch = self.Crew_Gunner_CanFlinch

	--self.Crew_Gunner_Idleanim = ent.AnimTbl_IdleStand
	ent.AnimTbl_IdleStand = self.Crew_Gunner_Idleanim
	ent.CurrentAnim_IdleStand = VJ_PICKRANDOMTABLE(self.Crew_Gunner_Idleanim)
	
	--self.Crew_Gunner_Callforhelp = ent.CallForHelp
	ent.CallForHelp = self.Crew_Gunner_Callforhelp
	ent.CallForBackUpOnDamage = self.Crew_Gunner_Callforhelp
	
	--self.Crew_Gunner_Medic = ent.IsMedicSNPC
	ent.IsMedicSNPC = self.Crew_Gunner_Medic
	
	if self.Crew_Gunner_Weapon != nil then
	--self.Crew_Gunner_Weapon = ent:GetActiveWeapon():GetClass()
	--ent:Give(self.Crew_Gunner_Weapon)
	ent.Weapon_ShotsSinceLastReload = self.Crew_Gunner_Weaponammo
	local weaponclass = self.Crew_Gunner_Weapon
	ent:VJ_ACT_PLAYACTIVITY(self.Crewweapon_switchanimation,true,0.9,false,0,{SequenceDuration=0.9,PlayBackRate=1.4})
	
		timer.Simple(0.66,function()
		if IsValid(ent) and weaponclass != nil then
				ent:Give(weaponclass)
		end
		end)
	
	--ent:GetActiveWeapon():Remove()
	end
	
	ent.MovementType = self.Crew_Gunner_Movetype
	ent:DoChangeMovementType(self.Crew_Gunner_Movetype)
	--ent.CanTurnWhileStationary = false
	if self.Crew_Gunner_DisableWeapon != true then
	--self.Crew_Gunner_DisableWeapon = ent.DisableWeapons
	ent.DisableWeapons = self.Crew_Gunner_DisableWeapon
	ent.HasMeleeAttack = true
	ent.DisableWeaponFiringGesture = false
	ent:CapabilitiesAdd(bit.bor(CAP_USE_WEAPONS))
	ent:CapabilitiesAdd(bit.bor(CAP_WEAPON_RANGE_ATTACK1))
	--ent:CapabilitiesRemove(CAP_USE_WEAPONS)
	--ent:CapabilitiesRemove(CAP_WEAPON_RANGE_ATTACK1)
	end
	
	--self.Crew_Gunner_Grenade = ent.HasGrenadeAttack
	ent.HasGrenadeAttack = self.Crew_Gunner_Grenade
	
	--self.Crew_Gunner_TakeCover = ent.MoveOrHideOnDamageByEnemy
	ent.MoveOrHideOnDamageByEnemy = self.Crew_Gunner_TakeCover
	
	--self.Crew_Gunner_HasPoseParameterLooking = ent.HasPoseParameterLooking
	ent:ClearPoseParameters()
	ent.HasPoseParameterLooking = self.Crew_Gunner_HasPoseParameterLooking
	
	if ent.CanUseSecondaryweapon != nil then
	ent.CanUseSecondaryweapon = self.Crew_Gunner_Secondaryweapon
	end
	
	self:CustomManipulateBoneCrewReset(ent)
	
	self.SearchCrew_NextT = CurTime() + self.SearchCrew_Nexttime*1.2
	self.Crew_Gunner = NULL
	self.Crew_Gunner_Setupdone = 0
	self.Crew_FoundEnt = NULL
		
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink()

	if GetConVarNumber("ai_disabled") == 1 then return end
	
	self.VJ_NoTarget = true

	--.HasAllies = true
	
	if !IsValid(self.Crew_Gunner) or self.Crew_Gunner == NULL or self.Crew_Gunner == nil then
	self.Bullet_Chargedone = 0
	self.Bullet_Charging = 0
	self.Crew_Gunner_Setupdone = 0
	
	if IsValid(self:GetEnemy()) then
		self.ResetedEnemy = true
		self:ResetEnemy(true)
	end
	
	if self.IsUsableByCrew == true and self.DoSearchCrew == true then
	
	if self.Crew_FoundEnt != NULL and self.Crew_FoundEnt != nil and IsValid(self.Crew_FoundEnt) and (self.Crew_Gunner == NULL or self.Crew_Gunner == nil or !IsValid(self.Crew_Gunner)) then
	if self.EnterCrew_CheckNextT < CurTime() then
	self.EnterCrew_CheckNextT = CurTime() + 0.6
				if self.Crew_FoundEnt:GetPos():DistToSqr( self:GetPos() ) <= self.EnterCrew_Range*self.EnterCrew_Range then 
					--self.Crew_Gunner = self.Crew_FoundEnt
					if self.Crew_Gunner_Setupdone != 1 then
					self:CustomSetupCrew(self.Crew_FoundEnt)
					self.SearchCrew_NextT = CurTime() + self.SearchCrew_Nexttime
					end
				end
	
	end
	end
	
	if self.SearchCrewReset_NextT < CurTime() and self.Crew_FoundEnt != NULL and self.Crew_FoundEnt != nil and IsValid(self.Crew_FoundEnt) then
		self.Crew_FoundEnt = NULL
		self.SearchCrewReset_NextT = CurTime() + self.SearchCrewReset_Nexttime
	end
	if self.SearchCrew_NextT < CurTime() and (self.Crew_FoundEnt == NULL or self.Crew_FoundEnt == nil or !IsValid(self.Crew_FoundEnt)) then
	self.SearchCrew_NextT = CurTime() + self.SearchCrew_Nexttime
			local entlist1 = ents.FindInSphere(self:GetPos(),self.SearchCrew_Range)
			if entlist1 != nil then
			for kc,vc in ipairs(entlist1) do
			if !vc:IsNPC() then continue end
			if self.Crew_FoundEnt == nil or self.Crew_FoundEnt == NULL or !IsValid(self.Crew_FoundEnt) then
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && ((vc.IsVJBaseSNPC == true )) then
			if vc.MovementType == VJ_MOVETYPE_GROUND and VJ_AnimationExists(vc,self.Crew_GunnerAnim2) == true and vc.vACT_StopAttacks != true and vc.IsVJBaseSNPC_Human == true then
			
			if IsValid(vc:GetEnemy()) then
			
			if (self:GetForward():Dot((vc:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.RangeAttackAngleRadius))) and self:GetPos():DistToSqr(vc:GetEnemy():GetPos()) < self.RangeDistance*self.RangeDistance then
				self.Crew_FoundEnt = vc
			end
			else
			
				self.Crew_FoundEnt = vc
			
			end
			
			end
			end
			end
			end
			end
			
		if self.Crew_FoundEnt != nil and self.Crew_FoundEnt != NULL and IsValid(self.Crew_FoundEnt) then
			self.Crew_FoundEnt:SetLastPosition(self:GetPos())
			self.Crew_FoundEnt:StopMoving()
			self.Crew_FoundEnt:ClearSchedule()
			self.Crew_FoundEnt:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true end)
			self.SearchCrewReset_NextT = CurTime() + self.SearchCrewReset_Nexttime
			if self.Crew_FoundEnt.FlankEnemy_NextT != nil then
				self.Crew_FoundEnt.FlankEnemy_NextT = CurTime() + self.Crew_FoundEnt.FlankEnemy_Nexttime*2.5
			end
		end
	
	end
	end
	
	
	
	
	end
	
	
	if self.Crew_Gunner != NULL and IsValid(self.Crew_Gunner) then
	if IsValid(self.ExtraGunModel) then
	if self.Crew_Gunner:Health() <= 0 or (self.Crew_Gunner.Dead != nil and self.Crew_Gunner.Dead == true) then
		self.Crew_Gunner = NULL
	end
	
		--self:SetEnemy(self.Crew_Gunner:GetEnemy())
	if self.Crew_Gunner != NULL and IsValid(self.Crew_Gunner) then
		if self.Crew_Gunner:GetEnemy() != self:GetEnemy() then
		self:VJ_DoSetEnemy(self.Crew_Gunner:GetEnemy(),false,true)
		end

		
		if IsValid(self.Crew_Gunner:GetEnemy()) then
		if self.Bullet_Charging == 0 and self.Bullet_Chargedone == 0 and self.Crew_Gunner:Visible(self.Crew_Gunner:GetEnemy()) then
		self.Bullet_Charging = 1
		self.Bullet_ChargeresetNextT = CurTime() + self.Bullet_ChargeresetNexttime
				timer.Simple(math.random(self.Bullet_Chargetime_min,self.Bullet_Chargetime_max)/100,function()
				if IsValid(self) then
				if self.Bullet_Chargedone != 1 then
					self.Bullet_Chargedone = 1
					self.Bullet_Charging = 0
					self.Bullet_ChargeresetNextT = CurTime() + self.Bullet_ChargeresetNexttime
				end
				end
				end)
		end
		end
		if self.Bullet_ChargeresetNextT < CurTime() and self.Bullet_Chargedone != 0 then
			self.Bullet_ChargeresetNextT = CurTime() + self.Bullet_ChargeresetNexttime
			if self.RangeAttacking != true and self.Bullet_Charging == 0 then self.Bullet_Chargedone = 0 end
		end
		
		
		if self.Bullet_CooldownautoNextT < CurTime() and self.Bullet_Fired > 0 then
			self.Bullet_Fired = 0
		end
		

		
		if IsValid(self:GetEnemy()) && (self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.RangeAttackAngleRadius))) then
			
			local Heigh_Ratio = (self:GetEnemy():GetPos().z - self:GetPos().z )*(self:GetEnemy():GetPos().z - self:GetPos().z ) / self:GetPos():DistToSqr(Vector(self:GetEnemy():GetPos().x,self:GetEnemy():GetPos().y,self:GetPos().z))
			if Heigh_Ratio < self.AttackHeightRatioLimit then
			local previousyaw = self.Emp_Lerp_Yaw
			local theyaw = (self:GetEnemy():GetPos() - self.ExtraGunModel:GetPos()):Angle().y
			
			if theyaw <= 0 then
				theyaw = 360 + theyaw
			end
			
			theyaw = theyaw - 180
			
			if theyaw <= 0 then
				theyaw = 360 + theyaw
			end
			
			--previousyaw = 360 + previousyaw
			if theyaw < 0 then 
				--theyaw = 360 + theyaw

			end
			
				if self.Emp_Lerp_Yaw <= 0 then
					self.Emp_Lerp_Yaw = self.Emp_Lerp_Yaw+360
				end
						
			local yaw01 = math.abs( self.Emp_Lerp_Yaw -theyaw )
			local yaw02 = 360 - yaw01
			
				--if self.Emp_Lerp_Yaw >= 0 then
				--	self.Emp_Lerp_Yaw = self.Emp_Lerp_Yaw-360
				--end
			
			
			--self.Emp_Lerp_Yaw = Lerp(20*FrameTime(),self.Emp_Lerp_Yaw,(self:GetEnemy():GetPos() - self.ExtraGunModel:GetPos()):Angle().y - 90)
			if yaw01 < yaw02 then
			self.Emp_Lerp_Yaw = Lerp(20*FrameTime(),self.Emp_Lerp_Yaw,theyaw)
			else
			self.Emp_Lerp_Yaw = Lerp(20*FrameTime(),360-self.Emp_Lerp_Yaw,theyaw)
			theyaw = theyaw
			end
			--self.Emp_Lerp_Yaw = Lerp(20*FrameTime(),self.Emp_Lerp_Yaw,theyaw)
			
			local pitch = -((self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - (self.ExtraGunModel:GetPos()  + self.ExtraGunModel:OBBCenter())):Angle().p
			self.Emp_Lerp_Ptich = Lerp(20*FrameTime(),self.Emp_Lerp_Ptich,pitch)
			local dist = math.Distance(self.Emp_Lerp_Ptich,0,self.Emp_Lerp_Ptich_Previous,0)
			if dist < 20 then
			
			if math.abs( (self:GetEnemy():GetPos() - self.ExtraGunModel:GetPos()):Angle().y ) != 0 then
				self.ExtraGunModel:SetAngles(Angle(self.Emp_Lerp_Ptich,self.Emp_Lerp_Yaw,0))
				--print(self.Emp_Lerp_Yaw)
				--print( math.abs( (self:GetEnemy():GetPos() - self.ExtraGunModel:GetPos()):Angle().y ) )
				--print( (self:GetEnemy():GetPos() - self.ExtraGunModel:GetPos()):Angle().y - 90 )
				--print(theyaw)
				--print("s0")
			end
				
			else
				self.Emp_Lerp_Ptich = pitch
				
			end
			self.Emp_Lerp_Ptich_Previous = self.Emp_Lerp_Ptich
			end
			
			
					if (self:CustomAttackCheck_RangeAttack() == true && (self:GetEnemy():GetPos():DistToSqr(self:GetPos()) < self.RangeDistance*self.RangeDistance) && self:GetEnemy():Visible(self.Crew_Gunner) && (self:GetEnemy():GetPos():DistToSqr(self:GetPos()) > self.RangeToMeleeDistance*self.RangeToMeleeDistance)) then
						--if self.RangeAttackAnimationStopMovement == true then self:StopMoving() end
						self.RangeAttacking = true
						self.IsAbleToRangeAttack = false
						self.AlreadyDoneRangeAttackFirstProjectile = false
						self:CustomOnRangeAttack_BeforeStartTimer()
						
						--print("NIg")
						if self.TimeUntilRangeAttackProjectileRelease == false then
							self:RangeAttackCode_DoFinishTimers()
						else
							timer.Create( "timer_range_start"..self:EntIndex(), self.TimeUntilRangeAttackProjectileRelease, self.RangeAttackReps, function() self:RangeAttackCode() end)
						end
						self:CustomOnRangeAttack_AfterStartTimer()
					end
			
			
		end
		
		
		
		local crewpos = self.ExtraGunModel:LocalToWorld(self.Crew_GunnerPosition)
		
		self.Crew_Gunner:SetPos( Vector(crewpos.x,crewpos.y,self:GetPos().z-5) )
		self.Crew_Gunner:SetAngles( Angle(0,self.ExtraGunModel:GetAngles().y-self.ExtraGunAngleDiffuse,0) ) 
		
		if self.Crew_Gunner:GetActiveWeapon() != NULL and self.Crew_Gunner:GetActiveWeapon() != nil then
			self.Crew_Gunner:GetActiveWeapon():SetNoDraw(true)
		end
		if self.Crew_Gunner:GetSequenceName(self.Crew_Gunner:GetSequence()) != self.Crew_GunnerAnim2 then
			self.Crew_Gunner:VJ_ACT_PLAYACTIVITY(self.Crew_GunnerAnim,true,2123320,false,0,{SequenceDuration=2123320})
		end
		self.Crew_Gunner.NextChaseTime = CurTime() + 12
		self.Crew_Gunner.NextIdleTime = CurTime() + 12
		--self:CustomManipulateBoneCrew(self.Crew_Gunner)
		self.Crew_Gunner.vACT_StopAttacks = true
		
		if self.Emp_CurrentAmmo <= 0 && self.Emp_Reloading == false && self.Emp_CanReload == true then
			self.Emp_Reloading = true
			--self.ExtraGunModel:SetBodygroup(2,1)
			VJ_EmitSound(self,self.Bullet_Reloadsound)
			--self.ExtraGunModel:ResetSequence(self.ExtraGunModel:LookupSequence("reload"))
			--self.ExtraGunModel:ResetSequenceInfo()
			--self.ExtraGunModel:SetCycle(0)
			timer.Simple(self.Bullet_Reloadtime,function()
				if IsValid(self) then
					self.Emp_CurrentAmmo = self.Emp_MaxAmmo
					self.Emp_Reloading = false
				end
			end)
		end
		
		if self.CanCrewDischarge == true then 
		if self.Crew_DischargeCheckNextT < CurTime() and IsValid(self:GetEnemy()) then
		self.Crew_DischargeCheckNextT = CurTime() + self.Crew_DischargeCheckNexttime
		
		--if IsValid(self:GetEnemy()) && self:GetEnemy():Visible(self.Crew_Gunner) && !(self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.RangeAttackAngleRadius))) then
		local Heigh_Ratio = ((self:GetEnemy():GetPos().z - self:GetPos().z )*(self:GetEnemy():GetPos().z - self:GetPos().z )) / self:GetPos():DistToSqr(Vector(self:GetEnemy():GetPos().x,self:GetEnemy():GetPos().y,self:GetPos().z))
		if (Heigh_Ratio > self.AttackHeightRatioLimit+0.1) or (self:GetEnemy():Visible(self.Crew_Gunner) && !(self:GetForward():Dot((self:GetEnemy():GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.RangeAttackAngleRadius)))) then
		
		local Findents = ents.FindInSphere(self:GetPos(),self.RangeDistance*0.75)
		local foundents = 0
		if (Findents) then 
			for k,vc in pairs(Findents) do
		--if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
		--if v:EntIndex() == self:EntIndex() or v:EntIndex() == self:GetParent():EntIndex() then continue end
		--if (v:IsNPC() && (v:Disposition(self) != D_LI) && v:Health() > 0 && (v != self) && (v:GetClass() != self:GetParent():GetClass())) or (v:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0 && v:Alive() && v:Health() > 0 && v.VJ_NoTarget != true) then
			if foundents == 0 then
			if !vc:IsNPC() and !vc:IsPlayer() then continue end
			if vc:EntIndex() != self:EntIndex() && vc:EntIndex() != self.Crew_Gunner:EntIndex() && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) then
			if self.Crew_Gunner:DoRelationshipCheck(vc) == true and vc:Visible(self.Crew_Gunner) then
			
			if (self:GetForward():Dot((vc:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.RangeAttackAngleRadius))) then
			local Heigh_Ratio = ((vc:GetPos().z - self:GetPos().z )*(vc:GetPos().z - self:GetPos().z )) / self:GetPos():DistToSqr(Vector(vc:GetPos().x,vc:GetPos().y,self:GetPos().z))
			if Heigh_Ratio < self.AttackHeightRatioLimit-0.1 then
				foundents = 1
				self.Crew_Gunner:VJ_DoSetEnemy(vc,false,true)
			end
			end
			
			end
			end
			end
			
			end
		end
		
		if foundents < 2 then
			self:CustomSetupCrewReset(self.Crew_Gunner)
		end
		
		end
		--end
		
		end
		end
	end
	end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomAttackCheck_RangeAttack()
	if self.Emp_CurrentAmmo > 0 and self.Crew_Gunner != NULL and self.Crew_Gunner != nil and self.IsAbleToRangeAttack == true and IsValid(self:GetEnemy()) and self.Bullet_Charging == 0 and self.Bullet_Chargedone == 1 then 
	--if ((self.ExtraGunModel:GetRight()*-1):Dot((self:GetEnemy():GetPos() -self.ExtraGunModel:GetPos()):GetNormalized()) > math.cos(math.rad(self.ExtraGunAngleDiffuseGeneral))) then
	
	local Heigh_Ratio = ((self:GetEnemy():GetPos().z - self:GetPos().z )*(self:GetEnemy():GetPos().z - self:GetPos().z )) / self:GetPos():DistToSqr(Vector(self:GetEnemy():GetPos().x,self:GetEnemy():GetPos().y,self:GetPos().z))
	if Heigh_Ratio < self.AttackHeightRatioLimit then
		return true 
	end
	
	--end
	end
	
	
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomRangeAttackCode()
	if !IsValid(self.ExtraGunModel) then return end
	
	if self.Crew_Gunner == NULL or self.Crew_Gunner == nil or !IsValid(self:GetEnemy()) or self.Bullet_Coolingdown == 1 then return end
	
	--self:RangeAttackSoundCode({self.Bullet_Firesound},{UseEmitSound=true})
	VJ_EmitSound(self,self.Bullet_Firesound,80)
	VJ_EmitSound(self,self.Bullet_FiresoundDist,110)
	
	if self.Crew_Gunner == NULL or self.Crew_Gunner == nil or !IsValid(self:GetEnemy()) or self.Bullet_Coolingdown == 1 or self.Bullet_NextT > CurTime() then return end
	--if (self.Crew_Gunner.Dead != nil and self.Crew_Gunner.Dead == true) then return end
	self.Emp_CurrentAmmo = self.Emp_CurrentAmmo - 1
	
	local dist = self:GetPos():Distance(self:GetEnemy():GetPos())
	local accuracy = self.Bullet_Accuracy
	if dist > self.RangeDistanceEffective then accuracy = self.Bullet_Accuracy*0.5 end
	local fSpread = ((dist)/accuracy)
	local shootpos = (self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - (self.ExtraGunModel2:LocalToWorld( self.Bullet_Position ))
	local bullet = {}
		bullet.Attacker = self.Crew_Gunner
		bullet.Num = 1
		bullet.Src = self.ExtraGunModel2:LocalToWorld( self.Bullet_Position ) --self:GetPos() + self:OBBCenter() //self.ExtraGunModel:GetAttachment(self.ExtraGunModel:LookupAttachment("muzzle")).Pos
		bullet.Dir = shootpos --(self:GetEnemy():GetPos() + self:GetEnemy():OBBCenter()) - (self:GetPos() + self:OBBCenter())
		bullet.Spread = Vector(fSpread,fSpread,0)
		bullet.Tracer = 1
		bullet.TracerName = self.Bullet_TracerType
		bullet.Force = 6
		bullet.Damage = self.Bullet_Damage
		bullet.AmmoType = "ar2"
		
		bullet.Callback = function(attacker,tr,dmginfo)
			/*
			local mat = "doi_impact_concrete"
			if tr.MatType == MAT_CONCRETE then
				mat = "doi_impact_concrete"
			elseif tr.MatType == MAT_DIRT then
				mat = "doi_impact_dirt"
			elseif tr.MatType == MAT_GLASS then
				mat = "doi_impact_glass"
			elseif tr.MatType == MAT_METAL or tr.MatType == MAT_VENT then
				mat = "doi_impact_metal"
			elseif tr.MatType == MAT_SAND then
				mat = "doi_impact_sand"
			elseif tr.MatType == MAT_SNOW then
				mat = "doi_impact_snow"
			elseif tr.MatType == MAT_WOOD then
				mat = "doi_impact_wood"
			elseif tr.MatType == MAT_GRASS then
				mat = "doi_impact_grass"
			elseif tr.MatType == MAT_TILE then
				mat = "doi_impact_tile"
			elseif tr.MatType == MAT_PLASTIC then
				mat = "doi_impact_plastic"
			elseif tr.MatType == MAT_COMPUTER then
				mat = "doi_impact_computer"
			elseif tr.MatType == MAT_FOLIAGE then
				mat = "doi_impact_leaves"
			elseif tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH or tr.MatType == MAT_FLESH then
				mat = nil
			end
			if mat != nil then
				ParticleEffect(mat,tr.HitPos,tr.HitNormal:Angle()+Angle(90,0,0))
			end
			*/
			local effectdata = EffectData()
			effectdata:SetOrigin( tr.HitPos )
			effectdata:SetScale( 0.5 )
			effectdata:SetMagnitude( 3 ) 
			util.Effect( "vjks_sw_effect_e_web_hit", effectdata, true, true )
			util.Effect( "ManhackSparks", effectdata, true, true )
			util.Decal( "fadingscorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
			if math.random(1,self.Bullet_AltDMGChance) == 1 and dmginfo != nil then 
					dmginfo:SetDamageType(self.Bullet_AltDMG)
			end
		end
		

		
	self.ExtraGunModel2:FireBullets(bullet)
	
	self.Bullet_ChargeresetNextT = CurTime() + self.Bullet_ChargeresetNexttime
	self.Bullet_CooldownautoNextT = CurTime() + self.Bullet_CooldownautoNexttime
	self.Bullet_Fired = self.Bullet_Fired + 1
	
		if self.Bullet_Fired >= self.Bullet_Burst and self.Bullet_Coolingdown == 0 then
		self.Bullet_Coolingdown = 0.3
		self.Bullet_Fired = 0
				timer.Simple(math.random(self.Bullet_Cooldown_min,self.Bullet_Cooldown_max),function()
				if IsValid(self) then
				if self.Bullet_Coolingdown != 0 then
					self.Bullet_Coolingdown = 0
				end
				end
				end)
		end
	
	
	--self:RangeAttackSoundCode({self.Bullet_Firesound},{UseEmitSound=true})
	--VJ_EmitSound(self,self.Bullet_FiresoundDist,110)
	



	
	
	self:CustomOnAttackaftershot()
	ParticleEffectAttach("vjks_blaster_red",PATTACH_POINT,self.ExtraGunModel2,1)
	--ParticleEffectAttach("muzzleflash_bar_3p",PATTACH_POINT,self.ExtraGunModel,1)
	if GetConVarNumber("vj_wep_nobulletshells") == 0 then
	--local BulletShell = EffectData()
	--BulletShell:SetEntity(self.ExtraGunModel)
	--BulletShell:SetOrigin(self.ExtraGunModel:GetPos() + self:GetForward()*-2 + self:GetUp()*2)
	--util.Effect("RifleShellEject",BulletShell)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	if IsValid(self.ReloadAmmoBox) then self.ReloadAmmoBox:Remove() end
	if IsValid(self.Crew_Gunner) then
		self:CustomSetupCrewReset(self.Crew_Gunner)
	end
	if IsValid(self.ExtraGunModel) then
		self.ExtraGunModel:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
		self.ExtraGunModel:SetOwner(NULL)
		self.ExtraGunModel:SetParent(NULL)
		self.ExtraGunModel:Fire("ClearParent")
		self.ExtraGunModel:SetMoveType(MOVETYPE_VPHYSICS)
		self:CreateExtraDeathCorpse("prop_physics",self.ExtraGunModel:GetModel(),{Pos=self.ExtraGunModel:GetPos(), Ang=self.ExtraGunModel:GetAngles(), HasVel=true})
		self.ExtraGunModel:Remove()
	end
	if IsValid(self.ExtraGunModel2) then
		self.ExtraGunModel2:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
		self.ExtraGunModel2:SetOwner(NULL)
		self.ExtraGunModel2:SetParent(NULL)
		self.ExtraGunModel2:Fire("ClearParent")
		self.ExtraGunModel2:SetMoveType(MOVETYPE_VPHYSICS)
		self.ExtraGunModel2:Remove()
	end

end

function ENT:CustomManipulateBoneCrew(ent)
	if ent != nil and ent != NULL and IsValid(ent) then

	self:CustomManipulateBone(ent,"ValveBiped.Bip01_L_UpperArm",Angle(-12,-60,25))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_R_UpperArm",Angle(6,10,3))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_R_Forearm",Angle(6,-20,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_L_Forearm",Angle(0,12,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_Spine4",Angle(0,6,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_Spine2",Angle(0,12,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_Spine",Angle(0,3,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_Spine1",Angle(0,-12,0))
	end
end

function ENT:CustomManipulateBoneCrewReset(ent)
	if ent != nil and ent != NULL and IsValid(ent) then

	self:CustomManipulateBone(ent,"ValveBiped.Bip01_L_UpperArm",Angle(0,0,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_R_UpperArm",Angle(0,0,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_R_Forearm",Angle(0,0,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_L_Forearm",Angle(0,0,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_Spine4",Angle(0,0,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_Spine2",Angle(0,0,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_Spine",Angle(0,0,0))
	self:CustomManipulateBone(ent,"ValveBiped.Bip01_Spine1",Angle(0,0,0))
	end
end

function ENT:CustomManipulateBone(ent,bonename,ang)

	if IsValid(ent) and bonename != nil and ang != nil then
		local id = ent:LookupBone( bonename )
		local newang = Angle(ang.y,ang.p,ang.r)
		if id != nil then 
			ent:ManipulateBoneAngles( id, ang ) 
		end
	end
	
end

function ENT:CustomOnAttackaftershot()


end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/