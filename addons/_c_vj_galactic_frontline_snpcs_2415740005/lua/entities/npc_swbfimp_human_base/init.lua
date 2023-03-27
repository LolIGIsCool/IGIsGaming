AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want 
ENT.StartHealth = 50 --GetConVarNumber("vj_mili_pzgrenadier_h")
ENT.HullType = HULL_HUMAN
ENT.vj_doi_isteam = "Axis"
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_GERMAN"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDamage = 40 --GetConVarNumber("vj_mili_pzgrenadier_d")
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasGrenadeAttack = true -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackModel = "models/npc_doi/weapons/w_stielhandgranate.mdl" -- The model for the grenade entity
ENT.GrenadeAttackThrowDistance = 1500 -- How far it can throw grenades
ENT.GrenadeAttackThrowDistanceClose = 200 -- How close until it stops throwing grenades
ENT.GrenadeAttackFussTime = 4.5
ENT.Weapon_FiringDistanceFar = 4000
ENT.Weapon_FiringDistanceClose = 60 -- How close until it stops shooting
ENT.WeaponSpread = 1.1
ENT.MeleeAttackDistance = 50
ENT.LastSeenEnemyTimeUntilReset = 25
ENT.WaitForEnemyToComeOutTime1 = 3 -- How much time should it wait until it starts chasing the enemy? | First number in math.random
ENT.WaitForEnemyToComeOutTime2 = 5 -- How much time should it wait until it starts chasing the enemy? | Second number in math.random
ENT.WaitForEnemyToComeOutDistance = 400 -- If it's this close to the enemy, it won't do it
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
ENT.FlinchChance = 1
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {""}
ENT.SoundTbl_CombatIdle = {""}
ENT.SoundTbl_OnReceiveOrder = {""}
ENT.SoundTbl_MedicReceiveHeal = {""}
ENT.SoundTbl_Alert = {""}
ENT.SoundTbl_CallForHelp = {""}
ENT.SoundTbl_Suppressing = {""}
ENT.SoundTbl_WeaponReload = {""}
ENT.SoundTbl_GrenadeAttack = {""}
ENT.SoundTbl_OnGrenadeSight = {""}
ENT.SoundTbl_OnKilledEnemy = {""}
ENT.SoundTbl_Pain = {""}
ENT.SoundTbl_DamageByPlayer = {""}
ENT.SoundTbl_Death = {""}
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.SoundTbl_BeforeMeleeAttack = {""}
ENT.WeaponUseEnemyEyePos = true
ENT.AnimTbl_TakingCover = {"crouch_idle_rpg"}
ENT.CanDetectGrenades = false
ENT.AlertFriendsOnDeath = false -- Should the SNPCs allies get alerted when it dies? | Its allies will also need to have this variable set to true!
ENT.AlertFriendsOnDeathDistance = 1000
ENT.SightAngle = 95
--CUSTOM VARIABLES
ENT.vj_doi_isprivate = true


ENT.CanUseSecondaryweapon = true
ENT.Secondaryweapon_class = "weapon_doi_german_luger"
ENT.Secondaryweapon_switchtime_primary = 0.4
ENT.Secondaryweapon_switchtime_secondary = 0.46
ENT.Secondaryweapon_switchanimation = "vjseq_drawpistol"
ENT.Secondaryweapon_switchanimation2 = "vjseq_smgdraw"
ENT.Secondaryweapon_originalclass = "weapon_doi_german_luger"
ENT.Secondaryweapon_switchback = 0
ENT.Secondaryweapon_switchchance = 3
ENT.Secondaryweapon_timer = 0
ENT.Secondaryweapon_timersec = 3
ENT.Secondaryweapon_timer2 = 0
ENT.Secondaryweapon_timer2sec = 1.5
ENT.Secondaryweapon_Usingsecondaryweapon = 0
ENT.Secondaryweapon_Switchingmyweapon = 0
ENT.Secondaryweapon_Range = 920
ENT.NoWeapon_UseScaredBehavior = false -- Should it use the scared behavior when it sees an enemy and doesn't have a weapon?

ENT.HasHelmetDrop = true
ENT.HasHelmet = 1
ENT.HasHelmetDropChance = 2
ENT.HasHelmetDropBodygroup = 0
ENT.HasHelmetDropBodygroup2 = 0
ENT.droppedhelmet = 0
ENT.HasHelmetModel = "models/npc_doi/doi_german_soldier_helmet.mdl"
ENT.HasHelmetBlankBodygroup = 6 --Blank bodygroup for helmet

ENT.Reloadwhenidle = true
ENT.Reloadwhenidle_timer = 0
ENT.Reloadwhenidle_timersec = 2
ENT.Reloadwhenidle_chance = 2

ENT.Reloadwhenattacking = true
ENT.Reloadwhenattacking_chance = 3
ENT.Reloadwhenattacking_NextT = 0
ENT.Reloadwhenattacking_Nexttime = 2

ENT.CanPerformMeleeCharge = true
ENT.isMeleeCharging = 0
ENT.MeleeCharge_range = 185
ENT.MeleeCharge_forwardvel1 = 150
ENT.MeleeCharge_forwardvel2 = 200
ENT.MeleeCharge_upvel1 = 0
ENT.MeleeCharge_knockbackvel = 200
ENT.MeleeCharge_dmg = 70
ENT.MeleeCharge_timer = 0
ENT.MeleeCharge_timersec = 0.5
ENT.MeleeCharge_timer2 = 0
ENT.MeleeCharge_timersec2 = 4
ENT.MeleeCharge_chance = 2
ENT.AnimTbl_MeleeChargeAttack = {ACT_MELEE_ATTACK_SWING}
ENT.SoundTbl_MeleeChargeAttack = {"npc_doi/german/meleecharge01.wav","npc_doi/german/meleecharge02.wav","npc_doi/german/meleecharge03.wav"}
ENT.TimeUntilMeleeChargeDamage = 0.25
ENT.MeleeCharge_Vel = Vector(0,0,0)
ENT.MeleeChargeAttackDamageAngleRadius = 100
ENT.MeleeCharge_damagedentity = {}
ENT.MeleeChargeAttackDamageDistance = 55
ENT.MeleeCharge_originalfriction = 1
ENT.MeleeCharge_hit = 0

ENT.CanDoSmartGrenadeThrow = true
ENT.SmartGrenadeThrow_timer = 0
ENT.SmartGrenadeThrow_timersec = 2
ENT.SmartGrenadeThrow_chance = 3
ENT.NextThrowSmartGrenadeT = 0
ENT.ThrowSmartGrenadeChance = 2

ENT.CanRememberEnemyPosition = true
ENT.SmartGrenadeThrow_enemyvisibletimer = 0
ENT.SmartGrenadeThrow_enemyvisible_previously = 0
ENT.SmartGrenadeThrow_enemyvisible_lastposition = Vector(0,0,0)
ENT.SmartGrenadeThrow_enemyvisible_NextT = 0
ENT.SmartGrenadeThrow_enemyvisible_Next = 12
ENT.SmartGrenadeThrow_enemyvisibleshare_NextT = 0
ENT.SmartGrenadeThrow_enemyvisibleshare_Next = 4
ENT.SmartGrenadeThrow_enemyvisibleshared = 0

ENT.CanDoGrenadeThrowHigh = true
ENT.GrenadeThrowHigh_chance = -2
ENT.GrenadeThrowHigh_veltable = {vel1=1.00,vel2=1.01,forvel=5,upvel1=0,upvel2=10}
--ENT.GrenadeThrowHigh_vel1 = 1.03 --640 --1.2
--ENT.GrenadeThrowHigh_vel2 = 1.08 --640 --1.2
--ENT.GrenadeThrowHigh_forvel = 5 --90
--ENT.GrenadeThrowHigh_upvel1 = 10 --70
--ENT.GrenadeThrowHigh_upvel2 = 30 --70

ENT.CanSmartAiming = true
ENT.SmartAiming_timer = 0
ENT.SmartAiming_timersec = 2.5
ENT.SmartAiming_chance = 3
ENT.SmartAiming_attacktime = 1.5
ENT.SmartAiming_activated = 0
ENT.SmartAiming_originalshootrange = 4000
ENT.SmartAiming_allychargelimit = 1

ENT.CanFlankEnemy = true
ENT.FlankEnemy_NextT = 0
ENT.FlankEnemy_Nexttime = 3
ENT.FlankEnemy_chance = 3
ENT.FlankEnemy_activated = 0
ENT.FlankEnemy_allylimit = 9
ENT.FlankEnemy_ResetNextT = 0
ENT.FlankEnemy_StopNextT = 0
ENT.FlankEnemy_attackallylimit = 3
ENT.FlankEnemy_failed = 0
ENT.FlankEnemy_minrange = 3500

ENT.CanPickUpNewWeapon = true
ENT.PickUpNewWeapon_NextT = 0
ENT.PickUpNewWeapon_Nexttime = 6
ENT.PickUpNewWeapon_radius = 700
ENT.AnimTbl_PickUpNewWeapon = {"pickup"}
ENT.HasNewWeaponPickUp = false
ENT.PickUpNewWeapon_targetgun = nil

ENT.CanThrowMedkit = false
ENT.ThrowMedkit_range = 800
ENT.ThrowMedkit_chance = 2
ENT.ThrowMedkit_NextT = 0
ENT.ThrowMedkit_Nexttime = 3
ENT.ThrowMedkit_VelUp = 180 -- Grenade attack velocity up | The first # in math.random
ENT.ThrowMedkit_VelForward = 620 -- Grenade attack velocity up | The first # in math.random
ENT.AnimTbl_ThrowMedkit = {"grenThrow"} -- Grenade Attack Animations
ENT.ThrowMedkit_Medkitent = nil
ENT.ThrowMedkit_HealthAmount = 20
ENT.ThrowMedkit_activated = 0
ENT.ThrowMedkit_RemoveT = 0

ENT.CanForceWeaponFire = true
ENT.ForceWeaponFire_activated = 0
ENT.ForceWeaponFire_NPCNextPrimaryFireT = 0
ENT.ForceWeaponFire_cooldown = 0

ENT.CanBlindFireCover = true
ENT.BlindFire_activated = 0
ENT.BlindFire_NextT = 0
ENT.BlindFire_Nexttime = 1
ENT.BlindFire_durationT = 0
ENT.BlindFire_duration = 2.15
ENT.BlindFire_Cooltime = 5
ENT.BlindFire_Var = {CanFlinch=0,CanCover=false,CanPose=true,WeaponSpread=1,durationextra=7}
ENT.BlindFire_Chance = 6 --Chance: 1 to 10, 1 is always while more than 10 is never
ENT.BlindFire_range = 1600
ENT.BlindFire_UsePistolAnim = false

ENT.CanProneCover = true
ENT.CanProneCoverFire = false
ENT.ProneCover_activated = 0
ENT.ProneCover_NextT = 0
ENT.ProneCover_Nexttime = 2
ENT.ProneCover_durationT = 0
ENT.ProneCover_Var = {CanFlinch=0,CanCallHelp=true,CanCover=false,CanPose=true,WeaponSpread=1,Collidebound1=Vector(0,0,0),Collidebound2=Vector(0,0,0),Physbound1=Vector(0,0,0),Physbound2=Vector(0,0,0),duration=3,durationextra=25,Cooltime=7,rangemin=240}
ENT.ProneCover_Chance = 6 --Chance: 1 to 10, 1 is always while more than 10 is never
ENT.ProneCover_goingprone = 0

ENT.CanSmartAttackPos = true
--ENT.CanSmartAttackPos_Unreachonly = false
ENT.SmartAttackPos_activated = 0
ENT.SmartAttackPos_NextT = 0
ENT.SmartAttackPos_Var = {Nexttime=4.5,Chance=3,Range=800}
ENT.CurrentCoveringPosition = Vector(0,0,0)
ENT.CanLookForCover = true --cannot detect prop, lots of bugs --fixed
ENT.LookForCover_activated = 0
ENT.LookForCover_NextT = 0
ENT.LookForCover_Var = {Nexttime=2.2,Chance=2,Range=750}
ENT.CoverAttackReloadCheck = 0

ENT.CanAimCorrect = true
ENT.AimCorrect_activated = 0
ENT.AimCorrect_NextT = 0
ENT.AimCorrect_Var = {Nexttime=3.5,Chance=2}


ENT.CanThrowBlindGrenade = false

ENT.CanUseSpecialGrenade = false
ENT.UseSpecialGrenade_Var = {Class="obj_vj_doi_proj_gersatchel",Model="models/npc_doi/weapons/w_germansatchelcharge.mdl",Nexttime1=5,Nexttime2=8,FussTime=7,Backdist=0}

ENT.SkillPreset = "none" --Can be heerprivate heerofficer waffeninf waffenoff
ENT.SkillSet = 0

ENT.CanChangeAlertAnim = true
ENT.AlertAnimTbl_IdleStand = {ACT_RANGE_ATTACK1} -- The idle animation when AI is enabled
ENT.AlertAnimTbl_Walk = {ACT_WALK_AGITATED} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.AlertAnimTbl_Run = {ACT_RUN_AGITATED} -- Set the running animations | Put multiple to let the base pick a random animation when it moves
ENT.OriginalAnimTbl_IdleStand = {ACT_IDLE} -- The idle animation when AI is enabled
ENT.OriginalAnimTbl_Walk = {ACT_WALK} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.OriginalAnimTbl_Run = {ACT_RUN} -- Set the running animations | Put multiple to let the base pick a random animation when it moves
ENT.AlertAnimNextT = 0
ENT.AlertIdleAnimNextT = 0
ENT.AlertIdleAnim_original = 0
ENT.AlertIdleAnim_originalset = 0
ENT.EndAlertAnimTime1 = 4
ENT.EndAlertAnimTime2 = 6
ENT.UseAlertAnim = 0
ENT.CanCrouchMove = false
ENT.CrouchMove_NextT = 0
ENT.CrouchMove_Var = {Nexttime=1.0,Chance=2}

/*
ENT.CanCornerCover = true --useless
ENT.CornerCover_activated = 0
ENT.CornerCover_deactivated = 0
ENT.CornerCover_CheckNextT = 0
ENT.CornerCover_NextT = 0
ENT.CornerCover_Nexttime = 1.5
ENT.CornerCover_Nexttime2 = 2
*/
/*
ENT.CornerCover_durationT = 0
ENT.CornerCover_duration = 8.00
ENT.CornerCover_Cooltime = 4.5
ENT.CornerCover_Var = {CanFlinch=0,CanCover=false,CanPose=true,durationextra=8,durationextra2=6,Friction=1}
ENT.CornerCover_Chance = 4 --Chance: 1 to 10, 1 is always while more than 10 is never
ENT.CornerCover_range = 3800
ENT.CornerCover_GoHide = 0
ENT.CornerCover_Hiding = 0
ENT.CornerCover_Reloading = 0
ENT.CornerCover_HideChance = 6
ENT.CornerCover_ShootNextT = 0
ENT.CornerCover_ShootCheckNextT = 0
ENT.CornerCover_Shootnexttime = 2.0
ENT.CornerCover_Shootduration = 1.1
ENT.CornerCover_PosHide = Vector(0,0,0)
ENT.CornerCover_PosShoot = Vector(0,0,0)
ENT.CornerCover_ShootingPose = 0
*/

ENT.CanAnimationFix = true --lengthen idle anim by 4 times --doesnt work
ENT.AnimationFixAnimTbl_Idle_ar2 = {"smg1idle2","smg1idle1","batonidle1","batonidle2"} --"Idle1_SMG1"
ENT.AnimationFixAnimTbl_Idle_smg1 = {"smg1idle2","smg1idle1","batonidle1","batonidle2"}
ENT.AnimationFixAnimTbl_Idle_pistol = {"batonidle1","batonidle2"}
ENT.AnimationFixNextT = 0
ENT.AnimationFixNexttime = 5
ENT.AnimationFixHoldtype = "ar2"
ENT.AnimationFixAnimTbl_Idle_original = {ACT_IDLE}

ENT.CanSmartDetectGrenades = true

ENT.CanAlertFriendsOnDeath_Advanced = true

ENT.CanCoordinatedChasing = true
ENT.CoordinatedChasing_NextT = 0
ENT.CoordinatedChasing_Nexttime = 3.5
ENT.CoordinatedChasing_range = 500
ENT.CoordinatedChasing_activated = 0
ENT.CoordinatedChasing_activatedbyothers = 0
ENT.CoordinatedChasing_maxsoldier = 2

ENT.CanFlankBehind = true
ENT.FlankBehind_Range = 2000
ENT.FlankBehind_NextT = 0
ENT.FlankBehind_Nexttime = 2
ENT.FlankBehind_Chance = 7


ENT.CanTrickShoot = false
ENT.TrickShoot_OnlyWhenEnemyLooking = true
ENT.TrickShoot_OnlyWhenEnemyLookingradius = 90
ENT.TrickShoot_activated = 0
ENT.TrickShoot_NextT = 0
ENT.TrickShoot_Nexttime = 1.2
ENT.TrickShoot_Chance = 4
ENT.TrickShoot_Rangemin = 35
ENT.TrickShoot_Rangemax = 55
ENT.TrickShoot_Range = 2400
ENT.TrickShoot_Cooldown = 3

ENT.CanTrickShootHide = true
ENT.TrickShootHide_GoHide = 0
ENT.TrickShootHide_NextT = 0
ENT.TrickShootHide_chance = 4
ENT.TrickShootHide_Nexttime = 0.5
ENT.TrickShootHide_cooldown = 1.2

ENT.CanCornerTrickShoot = false
ENT.CornerTrickShoot_activated = 0
ENT.CornerTrickShoot_NextT = 0
ENT.CornerTrickShoot_Nexttime = 3
ENT.CornerTrickShoot_Side = "left" --"right"
ENT.CornerTrickShoot_durationT = 0
ENT.CornerTrickShoot_duration = 2
ENT.CornerTrickShoot_durationextra = 100 -- divided by 100
ENT.CornerTrickShoot_hidingspot = Vector(0,0,0)
ENT.CornerTrickShoot_shootingspot = Vector(0,0,0)
ENT.CornerTrickShoot_maxtimeT = 0
ENT.CornerTrickShoot_maxtime = 6

ENT.CanRegroupWhenHurt = true
ENT.RegroupWhenHurt_NextT = 0
ENT.RegroupWhenHurt_Nexttime = 1
ENT.RegroupWhenHurt_cooldown = 5
ENT.RegroupWhenHurt_Range = 1200
ENT.RegroupWhenHurt_RangeDone = 180
ENT.RegroupWhenHurt_start = 0
ENT.RegroupWhenHurt_activated = 0
ENT.RegroupWhenHurt_durationT = 0
ENT.RegroupWhenHurt_duration = 10
ENT.RegroupWhenHurt_threshold = 0.5
ENT.RegroupWhenHurt_NextT2 = 0

ENT.CanGroupRush = true
ENT.GroupRush_NextT = 0
ENT.GroupRush_Nexttime = 4
ENT.GroupRush_CallRange = 1200 --Center at enemy
ENT.GroupRush_StopRange = 150
ENT.GroupRush_activated = 0
ENT.GroupRush_activatedbyothers = 0
ENT.GroupRush_charging = 0
ENT.GroupRush_chance = 4
ENT.GroupRush_minsoldier = 3
ENT.GroupRush_maxsoldier = 7
ENT.GroupRush_GatherPos = Vector(0,0,0)
ENT.GroupRush_durationT = 0

ENT.CanPredictNextEnemy = true
ENT.PredictNextEnemy_NextT = 0
ENT.PredictNextEnemy_Nexttime = 0.8
ENT.PredictNextEnemy_Range = 320

ENT.CanRegenHealth = true
ENT.RegenHealth_wait = 9
ENT.RegenHealth_NextT = 0
ENT.RegenHealth_healwait = 1
ENT.RegenHealth_heal = 2

ENT.CanPathAvoidClog = true
ENT.PathAvoidClog_NextT = 0
ENT.PathAvoidClog_Next = 2
ENT.PathAvoidClog_Entity = NULL
ENT.PathAvoidClog_lastpos = Vector(0,0,0)
ENT.PathAvoidClog_schedule = nil
ENT.PathAvoidClog_mindist = 90

ENT.CanFixPathFailed = true
ENT.FixPathFailed_NextT = 0
ENT.FixPathFailed_Next = 0.3
ENT.FixPathFailed_duration = 0
ENT.FixPathFailed_schedule = 0

ENT.CanFlankAttackPosition = true
ENT.FlankAttackPosition_NextT = 0
ENT.FlankAttackPosition_Nexttime = 2.0
ENT.FlankAttackPosition_chance = 4
ENT.FlankAttackPosition_activated = 0
ENT.FlankAttackPosition_maxrange = 2200
ENT.FlankAttackPosition_minrrange = 800
ENT.FlankAttackPosition_minrange = 400
ENT.FlankAttackPosition_thinking = 0
ENT.FlankAttackPosition_ResetNextT = 0
ENT.FlankAttackPosition_StopNextT = 0

ENT.CanTargetExposedEnemy = true
ENT.TargetExposedEnemy_range = 1000
ENT.TargetExposedEnemy_chance = 2
ENT.TargetExposedEnemy_NextT = 0
ENT.TargetExposedEnemy_Nexttime = 1.5
ENT.TargetExposedEnemy_cooldown = 4

ENT.CanRunOnResetEnemy = true
ENT.RunOnResetEnemy_NextT = 0
ENT.RunOnResetEnemy_Nexttime = 1
ENT.RunOnResetEnemy_cooldown = 4

ENT.CanFlyingCorpse = false
ENT.FlyingCorpse_Chance = 50 -- -1 never 100 always

/*
ENT.CanCommandSoldiers = false
ENT.Commanding_soldiertable = {}
ENT.Commanding_NextT = 0
ENT.Commanding_Nexttime = 4
ENT.CommandingOrder_NextT = 0
ENT.CommandingOrder_Nexttime = 4
ENT.Commanding_chance = 3
ENT.Commanding_range = 900
ENT.Commanding_maxsoldier = 3
ENT.Commanding_currentorder = "Idle" --Can be "Idle" "Attack" "Flank" "Defend"
--ENT.AnimTbl_CommandingAttack = {"signal_forward","signal_advance"}
--ENT.AnimTbl_CommandingFlank = {"signal_left","signal_right"}
--ENT.AnimTbl_CommandingDefend = {"signal_takecover","signal_halt"}
ENT.isbeingCommanded = nil
*/

function ENT:CustomOnInitialize()
	--if math.random(1,5) == 1 then self.IsMedicSNPC = true end
	local rand = math.random(1,3)
	if rand == 1 then self:SetBodygroup(1, 0) end
	if rand == 2 then self:SetBodygroup(1, 1) end
	if rand == 3 then self:SetBodygroup(1, 2) end
	self:SetBodygroup( 2, 1)
	self:SetBodygroup( 3, 1)
	self:SetBodygroup( 5, 2)
	self:SetBodygroup( 6, 1) 
	self:SetBodygroup( 7, 1) 
	self:SetBodygroup( 10, 1) 
	self.HasHelmetDropBodygroup = self:GetBodygroup( 2 )
	
end



function ENT:CustomOnTakeDamage_BeforeDamage(dmginfo,hitgroup)

	local DamageInflictor = dmginfo:GetInflictor()
	if IsValid(DamageInflictor) then local DamageInflictorClass = DamageInflictor:GetClass() end
	local DamageAttacker = dmginfo:GetAttacker()
	if IsValid(DamageAttacker) then local DamageAttackerClass = DamageAttacker:GetClass() end
	local DamageType = dmginfo:GetDamageType()
	
		if VJ_PICKRANDOMTABLE(DamageAttacker.VJ_NPC_Class) == VJ_PICKRANDOMTABLE(self.VJ_NPC_Class) then
			dmginfo:ScaleDamage( 0 )
			dmginfo:SetDamage( 0 )
		end
		
		if DamageAttacker.vj_doi_isteam != nil then
		if self.vj_doi_isteam == DamageAttacker.vj_doi_isteam then
		
			dmginfo:SetDamage( 0 )
			dmginfo:ScaleDamage( 0 )
			if VJ_PICKRANDOMTABLE(DamageAttacker.VJ_NPC_Class) != VJ_PICKRANDOMTABLE(self.VJ_NPC_Class) then print("NIGGER") end
		
		else
			--print("FUCKING NIGGER")
		end
		end

	if self.HasHelmetDrop == true and self.HasHelmet == 1 then

	
	if self:GetEnemy() != nil then
	if self.SmartAiming_activated == 1 and DamageAttacker != self:GetEnemy() and DamageAttacker:GetPos():DistToSqr( self:GetEnemy():GetPos() ) > 200*200 then
	if (DamageAttacker:IsNPC() and self:Disposition(DamageAttacker) != D_LI) or ( GetConVarNumber("ai_ignoreplayers") == 0 and DamageAttacker:IsPlayer() ) then
		self.SmartAiming_activated = 0
		self.Weapon_FiringDistanceFar = self.SmartAiming_originalshootrange
		--self:ClearSchedule() 
	end
	end
	end
	
	if ( hitgroup == HITGROUP_HEAD or (DamageType == DMG_BLAST or DamageType == DMG_BLAST_SURFACE)) and dmginfo:GetDamage() > 5 and math.random(1,self.HasHelmetDropChance) == 1 and self:GetBodygroup( 2 ) < self.HasHelmetBlankBodygroup then
		
		self.HasHelmet = 0

		--dmginfo:ScaleDamage( 1.5 )
		local helmetent = ents.Create("prop_physics")
		helmetent:SetModel(self.HasHelmetModel)
		helmetent:SetPos(self:GetPos() + Vector(0,0,5))
		helmetent:SetAngles( self:GetAngles() )
		helmetent:SetSkin( self:GetSkin() )
		local helmtype = self:GetBodygroup( 2 )
		helmetent:SetBodygroup( 0, self.HasHelmetDropBodygroup) 
		helmetent:SetBodygroup( 1, self.HasHelmetDropBodygroup) 
		helmetent:SetCollisionGroup(20)
		helmetent:Spawn()
		helmetent:Activate()
		helmetent:SetCollisionGroup(20)
			local phys = helmetent:GetPhysicsObject()
			if (phys:IsValid()) then
				phys:Wake()
				phys:AddAngleVelocity(Vector(math.Rand(300,300),math.Rand(300,300),math.Rand(300,300)))
				phys:SetVelocity(self:GetUp()*math.random(180,240) + -1*self:GetForward()*math.Rand(150,250) +self:GetRight()*math.Rand(-80,80))
			end
		self:SetBodygroup( 2, self.HasHelmetBlankBodygroup) 
		self.droppedhelmet = helmetent
		timer.Simple(6,function()
		if IsValid(self) then
		if helmetent != nil then
			helmetent:Remove()
		end
		end
		end)
	end
	
	
	end
	
	
	if ( hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG ) then	
	if dmginfo:GetDamage() > 5 and dmginfo:GetDamage() < self:GetMaxHealth() then
		dmginfo:ScaleDamage( 1.6 ) --arm n leg now deal 40% damage instead of 25%
	end
	end
	
	--if self.Flinching == true then
	--	dmginfo:ScaleDamage( 0.75 )
	--else
	--	dmginfo:ScaleDamage( 0.50 )
	--end
end

function ENT:CustomOnTakeDamage_AfterDamage(dmginfo,hitgroup) 

	if self.Dead == true then return end
	local DamageInflictor = dmginfo:GetInflictor()
	local DamageAttacker = dmginfo:GetAttacker()

	local DamageType = dmginfo:GetDamageType()

	self.RegenHealth_NextT = CurTime() + self.RegenHealth_wait
	
	if self.CanRegroupWhenHurt == true then
	if math.random(0,9) >= 3 and self.RegroupWhenHurt_activated == 0 and self.RegroupWhenHurt_start == 0 and self:Health() > 0 and self:Health() <= self:GetMaxHealth()*self.RegroupWhenHurt_threshold*( math.random(9,13)/10 ) then
		self.RegroupWhenHurt_start = 1
		self.RegroupWhenHurt_NextT2 = CurTime() + 5
		if self.RegroupWhenHurt_NextT > CurTime()-1.2 then
		self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_Nexttime
		end
	end
	end
	
	--if IsValid(DamageInflictor) then local DamageInflictorClass = DamageInflictor:GetClass() end
	--if IsValid(DamageAttacker) then local DamageAttackerClass = DamageAttacker:GetClass() end
	if self.CanProneCover == true and CurTime() > self.ProneCover_durationT and self.ProneCover_goingprone != 1 and DamageAttacker != nil and IsValid(DamageAttacker) and DamageType != nil then
	if self.ProneCover_activated != 1 and self.BlindFire_activated == 0 and self.ProneCover_NextT < CurTime() and math.random(1,10) >= self.ProneCover_Chance and (dmginfo:IsBulletDamage() or DamageType == DMG_AIRBOAT or DamageType == DMG_BUCKSHOT) then
	if self.vACT_StopAttacks == false and dmginfo:GetDamage() != nil and dmginfo:GetDamage() > 8 and self:Health() <= self:GetMaxHealth()/1.3 and self:Health() -dmginfo:GetDamage() > 0 and (DamageAttacker:IsNPC() or DamageAttacker:IsPlayer()) then
	local shouldprone = 0
	self.ProneCover_NextT = CurTime() + self.ProneCover_Nexttime
	if self:DoRelationshipCheck(DamageAttacker) != false or (DamageAttacker.vj_doi_isteam != nil and DamageAttacker.vj_doi_isteam != self.vj_doi_isteam) then
	if self:GetPos():DistToSqr( DamageAttacker:GetPos() ) >= self.ProneCover_Var.rangemin*self.ProneCover_Var.rangemin then
			local trctbl = {
							start = self:GetPos()+self:GetUp()*28,
							endpos = DamageAttacker:EyePos(),
							filter = {self}
							}
			if self:GetActiveWeapon() != nil and self:GetActiveWeapon() != NULL then trctbl.filter = {self,self:GetActiveWeapon()} end
			
			local trc = util.TraceLine(trctbl)
		
		if trc.HitWorld == true or (trc.Entity != nil and trc.Entity != NULL and !trc.Entity:IsNPC() and !trc.Entity:IsPlayer() and trc.Entity:IsSolid() ) then
		
		if self:GetEnemy() == nil or !IsValid(self:GetEnemy()) then
		shouldprone = 2
		else
		if self:GetEnemy() == DamageAttacker then
		
			local soldierlist = ents.FindInSphere(self:GetPos(),1000)
			for kc,vc in ipairs(soldierlist) do
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) then
			if self:DoRelationshipCheck(vc) == false and (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) and (IsValid(vc:GetEnemy()) and vc:GetEnemy() == DamageAttacker and vc:Visible(DamageAttacker) ) then
		
				shouldprone = shouldprone + 2
		
			end
			end
			end
			
		
		end
		end
		
		if shouldprone >= 2 then 
			local clearside = self:VJ_CheckAllFourSides(80)
			if clearside.Forward and clearside.Backward then
				self.ProneCover_activated = 1
				self.ProneCover_Var.CanFlinch = self.CanFlinch
				self.ProneCover_Var.CanCallHelp = self.CallForHelp
				self.ProneCover_Var.CanFindEnemy = self.DisableTakeDamageFindEnemy
				self.ProneCover_Var.CanRunAway = self.RunAwayOnUnknownDamage 
				self.ProneCover_Var.CanCover = self.MoveOrHideOnDamageByEnemy
				self.CanFlinch = 0
				self.CallForBackUpOnDamage = false
				self.DisableTakeDamageFindEnemy = false
				self.RunAwayOnUnknownDamage = false
				self.MoveOrHideOnDamageByEnemy = false
				self.CallForHelp = false
			end
		end
		
		end
	end
	end
	
	end
	end
	end

end

function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo,hitgroup,GetCorpse)

	if self.droppedhelmet != 0 and self.droppedhelmet != nil then
	if IsValid(self.droppedhelmet) then
		local gunnercorpse = self.droppedhelmet
		if IsValid(gunnercorpse) then table.insert(GetCorpse.ExtraCorpsesToRemove,gunnercorpse) end
	end
	end
	
	if self.CanFlyingCorpse == true and GetCorpse != nil then
	if math.random(1,100) <= self.FlyingCorpse_Chance and IsValid(GetCorpse) then
	
	local ent = ents.Create("darktrooper_corpse")
	ent:SetOwner(self)
	ent:SetPos(self:GetPos())
	--ent:SetAngles()
	--ent:SetModel(Model(gerModel))
	ent:Spawn()
	ent:Activate()
	ent.theflyingcorpse = GetCorpse
	
	
	end
	end
	
	
	
end

function ENT:CustomOnPriorToKilled(dmginfo,hitgroup)

	if self.CanAlertFriendsOnDeath_Advanced == true then
	
	local isenemyattacker = 0
	local DamageInflictor = dmginfo:GetInflictor()
	if IsValid(DamageInflictor) then local DamageInflictorClass = DamageInflictor:GetClass() end
	local DamageAttacker = dmginfo:GetAttacker()
	if IsValid(DamageAttacker) then local DamageAttackerClass = DamageAttacker:GetClass() end
	
	if IsValid(DamageAttacker) then
	if self:DoRelationshipCheck(DamageAttacker) == true and self:Visible(DamageAttacker) then
		isenemyattacker = 1
	end
	end
	/*
		local checkents = self:CheckAlliesAroundMe(self.AlertFriendsOnDeathDistance)
		local LocalTargetTable = {}
		if checkents.ItFoundAllies == true then
			for k,v in ipairs(checkents.FoundAllies) do
				if !IsValid(v:GetEnemy()) && (v.AlertFriendsOnDeath == true or v.CanAlertFriendsOnDeath_Advanced == true) && #LocalTargetTable != self.AlertFriendsOnDeathUseCertainAmountNumber then
					table.insert(LocalTargetTable,v)
					--v.CurrentSchedule.Name == "vj_goto_lastpos_gren"
					if isenemyattacker == 0 then
						v:FaceCertainEntity(self,false)
						v:VJ_ACT_PLAYACTIVITY(VJ_PICKRANDOMTABLE(v.AnimTbl_AlertFriendsOnDeath),false,0,false)
						v.NextIdleTime = CurTime() + math.Rand(5,8)
					end
					
					if isenemyattacker == 1 then
						if v:DoRelationshipCheck(DamageAttacker) == true then -- and v:Visible(self) then
							v:VJ_DoSetEnemy(DamageAttacker,false)
							if math.random(0,2) < 2 then v:DoChaseAnimation() end
						end
					end
					
				end
			end
		end
	*/
		
	end

end


function ENT:CustomOnWeaponReload()
					/*
					if self.CoverAttackReloadCheck == 0 then
					if (self.SmartAttackPos_activated == 1 or self.LookForCover_activated == 1) and self.CurrentCoveringPosition != Vector(0,0,0) then
						timer.Simple(0.15,function()
						if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) then
							self:ClearSchedule() 
							self.CoverAttackReloadCheck = 1
						end
						end)
						timer.Simple(2.5,function()
						if IsValid(self) and self.Dead != true then
							self.CoverAttackReloadCheck = 0
						end
						end)
					end
					end
					*/
end

function ENT:CustomOnWeaponReload_AfterRanToCover()

					if (self.SmartAttackPos_activated == 1 or self.FlankAttackPosition_activated == 1 or self.LookForCover_activated == 1 or self.RegroupWhenHurt_activated == 1) and self.CurrentCoveringPosition != Vector(0,0,0) then
						timer.Simple(2.7,function()
						if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) then
							self:StopMoving()
							self:SetLastPosition(self.CurrentCoveringPosition)
							self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
						end
						end)
					end
						
						timer.Simple(4,function()
						if IsValid(self) and self.Dead != true then
						if self.vACT_StopAttacks != true and ((self:GetActivity() >= 376 and self:GetActivity() <= 381) or (self:GetActivity() >= 66 and self:GetActivity() <= 69)) then
							self:SelectSchedule()
							self.NextChaseTime = CurTime() + 0.5
						end
						end
						end)
end

function ENT:CustomOnFlinch_AfterFlinch(dmginfo,hitgroup) 

					if (self.SmartAttackPos_activated == 1 or self.FlankAttackPosition_activated == 1 or self.LookForCover_activated == 1 or self.RegroupWhenHurt_activated == 1) and self.CurrentCoveringPosition != Vector(0,0,0) then
						timer.Simple(1.1,function()
						if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) then
							self:StopMoving()
							self:SetLastPosition(self.CurrentCoveringPosition)
							self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
						end
						end)
					end

end

function ENT:CustomOnGrenadeThrow_After() 

					if (self.SmartAttackPos_activated == 1 or self.FlankAttackPosition_activated == 1 or self.LookForCover_activated == 1 or self.RegroupWhenHurt_activated == 1) and self.CurrentCoveringPosition != Vector(0,0,0) then
						timer.Simple(2.1,function()
						if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) then
							self:StopMoving()
							self:SetLastPosition(self.CurrentCoveringPosition)
							self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
						end
						end)
					end

end


function ENT:VJ_ACT_RESETENEMY_RUN(RunToEnemyOnReset)
	local RunToEnemyOnReset = RunToEnemyOnReset or false
	local vsched = ai_vj_schedule.New("vj_act_resetenemy")
	if IsValid(self:GetEnemy()) then vsched:EngTask("TASK_FORGET", self:GetEnemy()) end
	//vsched:EngTask("TASK_IGNORE_OLD_ENEMIES", 0)
	self.NextWanderTime = CurTime() + math.Rand(5,8)
	if self.Behavior != VJ_BEHAVIOR_PASSIVE && self.Behavior != VJ_BEHAVIOR_PASSIVE_NATURE && self.VJ_IsBeingControlled == false && RunToEnemyOnReset == true && CurTime() > self.LastHiddenZoneT && self.LastHiddenZone_CanWander == true && self.MeleeAttacking != true && self.RangeAttacking != true && self.LeapAttacking != true then
		//ParticleEffect("explosion_turret_break", self.LatestEnemyPosition, Angle(0,0,0))
		self:SetMovementActivity(VJ_PICKRANDOMTABLE(self.AnimTbl_Run))
		vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
		//vsched:EngTask("TASK_WALK_PATH", 0)
		vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		vsched.ResetOnFail = true
		vsched.CanShootWhenMoving = true
		vsched.ConstantlyFaceEnemy = true
		vsched.CanBeInterrupted = true
		vsched.IsMovingTask = true
		vsched.IsMovingTask_Run = true
		--vsched.IsMovingTask_Walk = true
		//self.NextIdleTime = CurTime() + 10
	end
	if vsched.TaskCount > 0 then
		self:StartSchedule(vsched)
	end
end

function ENT:CustomOnMovingPathFailed()

--x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end

	if IsValid(self) and self.Dead != true and IsValid(self:GetEnemy()) and self.CanFixPathFailed == true then
	if self.LastSeenEnemyTime > 2 then
		if math.abs(CurTime() -self.NextChaseTime) >= 2 then self.NextChaseTime = CurTime() + 2.0 end
		self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime/2.5 + math.random(0,10)/10
		--self.FlankEnemy_ResetNextT = CurTime() + 2
		--self.FlankEnemy_StopNextT = CurTime() + 1
		self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime/2.5 + math.random(0,15)/10
		self.LookForCover_NextT = CurTime() + self.LookForCover_Var.Nexttime/2.5 + math.random(0,15)/10
		self.NextIdleTime = CurTime() + 2
		self.SmartAttackPos_activated = 0
		self.LookForCover_activated = 0
		self.RegroupWhenHurt_activated = 0
		self.FlankAttackPosition_NextT = CurTime() + self.FlankAttackPosition_Nexttime/2.1 + math.random(0,15)/10
		self.FlankAttackPosition_activated = 0
		--print("nigged")
	end
	end

end

function ENT:CustomOnTouch(entity)

	if self.CanPathAvoidClog == true then
	if self.PathAvoidClog_NextT < CurTime() then
	--if IsValid(entity) then
	
	self.PathAvoidClog_NextT = CurTime() + self.PathAvoidClog_Next*0.25
	local CurSched = self.CurrentSchedule
	local CurSched2 = nil
	local shouldmove = 1
	if CurSched != nil and IsValid(entity) and self.MovementType == VJ_MOVETYPE_GROUND and (self.PathAvoidClog_Entity == NULL or !IsValid(self.PathAvoidClog_Entity) ) then
	if (CurSched.IsMovingTask_Walk == true or CurSched.IsMovingTask_Run == true) and CurSched.PathAvoidClog != true then
	
		if entity:IsNPC() or entity:IsPlayer() or entity:GetClass() == "prop_physics" or entity:GetClass() == "prop_dynamic" then
	
		if entity:IsNPC() and entity:IsMoving() then shouldmove = 0 end
		if entity:IsPlayer() and self:DoRelationshipCheck(entity) == true then shouldmove = 0 end
		if !IsValid( entity:GetPhysicsObject() ) then shouldmove = 0 end
	
		if shouldmove == 1 then
			self.PathAvoidClog_Entity = entity
			self.PathAvoidClog_NextT = CurTime() + self.PathAvoidClog_Next
			
			timer.Simple(1.4,function()
			if IsValid(self) then
			
			if IsValid(self.PathAvoidClog_Entity) and self.CurrentSchedule != nil and self.CurrentSchedule == CurSched then
			if self:GetPos():DistToSqr( self.PathAvoidClog_Entity:GetPos() ) < 24*24 then
			
			self.PathAvoidClog_NextT = CurTime() + self.PathAvoidClog_Next*1 + 2.6
			if CurSched.Name == "vj_goto_lastpos" or CurSched.Name == "vj_flank_enemy" then
				self.PathAvoidClog_lastpos = self.CurrentCoveringPosition
				else
				self.PathAvoidClog_lastpos = Vector(0,0,0)
			end
			self.PathAvoidClog_schedule = self.CurrentSchedule
			
						local randpos = math.random(120,160)
						--local checkdist = self:VJ_CheckAllFourSides(randpos)
						
						local checkdist = {Forward=false, Backward=false, Right=false, Left=false}
						local ii = 0
						for k,vn in ipairs({self:GetForward(),-self:GetForward(),self:GetRight(),-self:GetRight()}) do
						ii = ii +1
							local trce = util.TraceLine({
							start = self:GetPos() +self:OBBCenter(),
							endpos = self:GetPos() +self:OBBCenter() +vn *randpos,
							filter = self
						})
							if self:GetPos():DistToSqr(trce.HitPos) >= self.PathAvoidClog_mindist*self.PathAvoidClog_mindist then
							if ii == 1 then checkdist.Forward = true end
							if ii == 2 then checkdist.Backward = true end
							if ii == 3 then checkdist.Right = true end
							if ii == 4 then checkdist.Left = true  end
							end
						end
						
						
						local randmove = {}
						if checkdist.Backward == true then table.insert(randmove,"Backward") end
						if checkdist.Right == true then table.insert(randmove,"Right") end
						if checkdist.Left == true then table.insert(randmove,"Left") end
						local pickmove = VJ_PICKRANDOMTABLE(randmove)
						if pickmove == "Backward" then self:SetLastPosition(self:GetPos() + self:GetForward()*-randpos) end
						if pickmove == "Right" then self:SetLastPosition(self:GetPos() + self:GetRight()*randpos) end
						if pickmove == "Left" then self:SetLastPosition(self:GetPos() + self:GetRight()*-randpos) end
						if pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
						self:StopMoving()
						self:VJ_TASK_GOTO_LASTPOS(VJ_PICKRANDOMTABLE({"TASK_RUN_PATH","TASK_RUN_PATH"}),function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.PathAvoidClog = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
						
						timer.Simple(2.5,function()
						if IsValid(self) then
						if self.PathAvoidClog_lastpos != Vector(0,0,0) then
							self:SetLastPosition(self.PathAvoidClog_lastpos)
						end
							self:StartSchedule(self.PathAvoidClog_schedule)
						end
						end)
						
						end
						self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2)

			end
			end
			
			self.PathAvoidClog_Entity = NULL
			end
			end)
			
			
		end
		
		end
			
	end
	end
	
	end
	end

end

function ENT:CustomOnCallForHelp()

		if IsValid(self:GetEnemy()) then
		if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) < 1600*1600 then
			self.NextCallForHelpAnimationT = CurTime() + self.NextCallForHelpAnimationTime/2
		end
		end
		
					if self.HasCallForHelpAnimation == true && self.vACT_StopAttacks != true && CurTime() > self.NextCallForHelpAnimationT then
						local pickanim = VJ_PICKRANDOMTABLE(self.AnimTbl_CallForHelp)
						self:VJ_ACT_PLAYACTIVITY(pickanim,self.CallForHelpStopAnimations,self:DecideAnimationLength(pickanim,self.CallForHelpStopAnimationsTime),self.CallForHelpAnimationFaceEnemy,self.CallForHelpAnimationDelay,{PlayBackRate=self.CallForHelpAnimationPlayBackRate})
						self.NextCallForHelpAnimationT = CurTime() + self.NextCallForHelpAnimationTime
					end

end

function ENT:CustomOnDoKilledEnemy(argent,attacker,inflictor) 

	if self.CanPredictNextEnemy == true then
	if self.PredictNextEnemy_NextT < CurTime() and !IsValid(self:GetEnemy()) then
		self.PredictNextEnemy_NextT = CurTime() + self.PredictNextEnemy_Nexttime
		local foundents = 0
		local soldierlist = ents.FindInSphere(self.SmartGrenadeThrow_enemyvisible_lastposition,self.PredictNextEnemy_Range)
		if soldierlist != nil then		
			for kc,vc in ipairs(soldierlist) do
			if foundents == 0 then
			if !vc:IsNPC() and !vc:IsPlayer() then continue end
			if vc:EntIndex() != self:EntIndex() && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) then
			if self:DoRelationshipCheck(vc) == true then
				foundents = vc
			end
			end
			end
			end
		end
		if IsValid(vc) then
			self:VJ_DoSetEnemy(vc,false)
		end
	end
	end

	if self.CanRegroupWhenHurt == true then
	if self.RegroupWhenHurt_activated == 0 and self.RegroupWhenHurt_start == 0 and !IsValid(self:GetEnemy()) and self:Health() > 0 and self:Health() <= self:GetMaxHealth()*self.RegroupWhenHurt_threshold then
		self.RegroupWhenHurt_start = 1
		self.RegroupWhenHurt_NextT2 = CurTime() + 4
		if self.RegroupWhenHurt_NextT > CurTime()-1.2 then
		self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_Nexttime
		end
	end
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

function ENT:VJ_TASK_FLANK_ENEMY(UseLOSChase)
	UseLOSChase = UseLOSChase or false
	//if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_flank_enemy" then return end
	if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_flank_enemy" then return end
	if self:GetActivity() == ACT_CLIMB_UP or self:GetActivity() == ACT_CLIMB_DOWN or self:GetActivity() == ACT_CLIMB_DISMOUNT then return end
	self:SetMovementActivity(VJ_PICKRANDOMTABLE(self.AnimTbl_Run))

		local vsched = ai_vj_schedule.New("vj_flank_enemy")
		vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
		//vsched:EngTask("TASK_RUN_PATH", 0)
		vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		vsched:EngTask("TASK_GET_PATH_TO_ENEMY", 0)
		//vsched:EngTask("TASK_RUN_PATH", 0)
		vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
		//vsched:EngTask("TASK_FACE_ENEMY", 0)
		--vsched.ResetOnFail = false
		vsched.CanShootWhenMoving = true
		//vsched.StopScheduleIfNotMoving = true
		vsched.StopScheduleIfNotMoving = true
		--vsched.CanBeInterrupted = true
		vsched.IsMovingTask = true
		vsched.IsMovingTask_Run = true
		vsched:EngTask("TASK_FACE_ENEMY", 0)
		vsched.ConstantlyFaceEnemy = true
		vsched.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end
		self:StartSchedule(vsched)

end

function ENT:CustomOnThink_AIEnabledExtracode()

end

function ENT:CustomOnThink_AIEnabled()
	if self.Dead == true then return end
	


	if self.SkillSet == 0 then 
		self:CustomOnAISkillPreset()
	end
	
	self:CustomOnThink_AIEnabledExtracode()
	
	if self.CanFixPathFailed == true then
	local CurSchedc = self.CurrentSchedule
	
	if CurSchedc == nil then
	if self.FixPathFailed_schedule == 1 then
	if (!self:IsMoving() or (self:GetBlockingEntity() != nil && self:GetBlockingEntity():IsNPC())) then 
		self:CustomOnMovingPathFailed()
	end
	end
		self.FixPathFailed_schedule = 0
	end
	
	if CurSchedc != nil then
	if CurSchedc.StopScheduleIfNotMoving == true then
		self.FixPathFailed_schedule = 1
	else
		self.FixPathFailed_schedule = 0
	end
	end
	
	end
	
	
	/*
	if self.CanFixPathFailed == true and self.FixPathFailed_NextT < CurTime() then
	self.FixPathFailed_NextT = CurTime() + self.FixPathFailed_Next
	local CurSchedc = self.CurrentSchedule
	if CurSchedc != nil then
		if CurSchedc.StopScheduleIfNotMovingEx == true && (!self:IsMoving() or (self:GetBlockingEntity() != nil && self:GetBlockingEntity():IsNPC())) then
			--if self.FixPathFailed_schedule != CurSchedc then
			--self.FixPathFailed_schedule = CurSchedc
			--self.FixPathFailed_duration = 0
			--else
			--self.FixPathFailed_duration = self.FixPathFailed_duration+0.5
			--end
			--if self.FixPathFailed_duration >= 1.2 then
			if self:DoRunCode_OnFail(CurSchedc) == true then
				--self:ClearCondition(35)
				self:ScheduleFinished(CurSchedc)
			end
		--	end
			--if CurSchedc.AlreadyRanCode_OnFail != true then
			--	if CurSchedc.RunCode_OnFail != nil then CurSchedc.AlreadyRanCode_OnFail = true CurSchedc.RunCode_OnFail() end
			--end
		end
	end
	
	end
	*/
	
	
	
	if self.CanSmartDetectGrenades == true and CurTime() > self.NextProcessT then
	
		self:SmartCheckForGrenades()
	
	end
	
	if self.CanAnimationFix == true then
	
	if self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
	if self:GetActiveWeapon().HoldType != nil and self:GetActiveWeapon().HoldType != self.AnimationFixHoldtype then
		self.AnimationFixHoldtype = self:GetActiveWeapon().HoldType
		self.AnimationFixNextT = CurTime() + 0.2
	end
	else
		self.AnimationFixHoldtype = "pistol"
	end
	
	if CurTime() > self.AnimationFixNextT then
	self.AnimationFixNextT = CurTime() + self.AnimationFixNexttime + math.random(0,3)
	local chosenanim = 0
	local animtype = self.AnimationFixHoldtype
	if self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
	if self:GetActiveWeapon().HoldType != nil and self:GetActiveWeapon().HoldType != self.AnimationFixHoldtype then
		animtype = self:GetActiveWeapon().HoldType
		self.AnimationFixNextT = CurTime() + 0.2
	end
	else
		animtype = "pistol"
	end
	if animtype == "ar2" then
		chosenanim = VJ_PICKRANDOMTABLE(self.AnimationFixAnimTbl_Idle_ar2)
	end
	if animtype == "pistol" then
		chosenanim = VJ_PICKRANDOMTABLE(self.AnimationFixAnimTbl_Idle_pistol)
	end
	if animtype == "smg" then
		chosenanim = VJ_PICKRANDOMTABLE(self.AnimationFixAnimTbl_Idle_smg1)
	end
	if self.UseAlertAnim != 1 then
		if chosenanim != 0 then
			self.AnimTbl_IdleStand = {chosenanim}
		else
			self.AnimTbl_IdleStand = {ACT_IDLE}
		end
	end
	end
	
	end
	
	if self.CanRegenHealth == true and GetConVarNumber("vj_advancedoi_snpc_canheal") == 1 and self:GetMaxHealth() != nil and self:Health() != nil then 
	if CurTime() > self.RegenHealth_NextT and self:GetMaxHealth() > self:Health() then
	
	self.RegenHealth_NextT = CurTime() + self.RegenHealth_healwait
	self:SetHealth(math.Clamp(self:Health() + 2,self:Health(),self:GetMaxHealth()))
	
	end
	end
	
	if self.CanChangeAlertAnim == true then
	
	if self.AlertIdleAnimNextT < CurTime() then
	self.AlertIdleAnimNextT = CurTime() + 0.5
	if self.UseAlertAnim == 1 and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
		if self:GetActiveWeapon().IsVJBaseWeapon == true and self:GetActiveWeapon().ActivityTranslateAI[ACT_IDLE] != nil then
			--local seqqq = self:SelectWeightedSequence( self:GetActiveWeapon().ActivityTranslateAI[ACT_IDLE_ANGRY] )
			--self:ResetSequence( seqqq )
			if self.AlertIdleAnim_original != self:GetActiveWeapon().ActivityTranslateAI[ACT_IDLE] and self:GetActiveWeapon().ActivityTranslateAI[ACT_IDLE] != self:GetActiveWeapon().ActivityTranslateAI[ACT_RANGE_ATTACK1] then
			self.AlertIdleAnim_original = self:GetActiveWeapon().ActivityTranslateAI[ACT_IDLE]
			self:GetActiveWeapon().ActivityTranslateAI[ACT_IDLE] = self:GetActiveWeapon().ActivityTranslateAI[ACT_RANGE_ATTACK1]
			self.AlertIdleAnim_originalset = 1
			end
		end
	end

	end
	
	if self.AlertAnimNextT > CurTime() then 
		if self.UseAlertAnim == 0 then
		self.OriginalAnimTbl_IdleStand = self.AnimTbl_IdleStand
		self.AnimTbl_IdleStand = self.AlertAnimTbl_IdleStand
		--self.AnimTbl_Walk = self.AlertAnimTbl_Walk
		--//self.AnimTbl_Run = self.AlertAnimTbl_Run
		self.UseAlertAnim = 1
		end
	else
	if self.AlertAnimNextT <= CurTime() then 
		if self.UseAlertAnim == 1 then
		self.AnimTbl_IdleStand = self.OriginalAnimTbl_IdleStand
		--//self.AnimTbl_Walk = self.OriginalAnimTbl_Walk
		--//self.AnimTbl_Run = self.OriginalAnimTbl_Run
		self.UseAlertAnim = 0
			if self.AlertIdleAnim_originalset == 1 and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
			self:GetActiveWeapon().ActivityTranslateAI[ACT_IDLE] = self.AlertIdleAnim_original
			self.AlertIdleAnim_original = 0
			end
		end
	end
	end
	
	--if self.AlertAnimNextT/2 < CurTime() then 
	
		if IsValid(self:GetEnemy()) then
		self.AlertAnimNextT = CurTime() + math.random(self.EndAlertAnimTime1,self.EndAlertAnimTime2)
		end
	
	--end
	
	end
	
	--if self.vj_doi_isteam != "Axis" then
	--	print("NIBBA")
	--end
	
	
	if self.CanAimCorrect == true then 
	if self.AimCorrect_NextT < CurTime() and self.vACT_StopAttacks != true and self.Weapon_StartingAmmoAmount != nil and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil and IsValid(self:GetEnemy()) and (self:VJ_HasActiveWeapon() != false) then
	self.AimCorrect_NextT = CurTime() + self.AimCorrect_Var.Nexttime
	if self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self.DoingWeaponAttack == true and self:GetActiveWeapon():LookupAttachment("muzzle_flash") > 0 and self:Visible(self:GetEnemy()) then
	local bulletpos = self:GetActiveWeapon():GetAttachment(self:GetActiveWeapon():LookupAttachment("muzzle_flash")).Pos
	local enemypos = self:GetEnemy():GetPos()+self:GetEnemy():OBBCenter()
	local aimhigher = true
	local hitent = false
	local trx = util.TraceLine({
		start = bulletpos,
		endpos = enemypos,
		filter = {self,self:GetActiveWeapon()}
	})

	if trx.Entity != self:GetEnemy() then
	for k,v in ipairs(ents.FindInSphere(trx.HitPos,5)) do
		if v == self:GetEnemy() or self:Disposition(v) == 1 or self:Disposition(v) == 2 then
			hitent = true
		end
	end
	end
	
	if hitent == true then aimhigher = false end
	if trx.Entity == self:GetEnemy() and trx.HitWorld == true then aimhigher = false end
	if aimhigher == true then
		self.AimCorrect_activated = 1
	else
		self.AimCorrect_activated = 0
	end
	
	else
	if !self:Visible(self:GetEnemy()) or self.Weapon_ShotsSinceLastReload >= self.Weapon_StartingAmmoAmount then
		self.AimCorrect_activated = 0
	end
	
	end
	
	end
	
		if self.AimCorrect_activated == 1 then
			self.WeaponUseEnemyEyePos = true
		end
	
	end
	
	
	if self.CanLookForCover == true then
	if self.LookForCover_NextT < CurTime() and self.LookForCover_activated != 1 and IsValid(self:GetEnemy()) and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil and self.vACT_StopAttacks != true and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.Name == "vj_goto_lastpos") or (self.CurrentSchedule != nil and self.CurrentSchedule.Name == "vj_flank_enemy" and self.FlankEnemy_ResetNextT <= CurTime() + 17)) then
	self.LookForCover_NextT = CurTime() + self.LookForCover_Var.Nexttime

	if self.SmartAttackPos_NextT < CurTime() then
	self.SmartAttackPos_NextT = CurTime() + 0.8
	end
	
	if IsValid(self:GetEnemy()) and math.random(1,10) >= self.LookForCover_Var.Chance then
	if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) < self.Weapon_FiringDistanceFar*self.Weapon_FiringDistanceFar and self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) > 200*200 then
	--print("nig1")
		local tras = util.TraceLine({
						start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
		if (tras.HitWorld != true and ( (tras.Entity != nil and tras.Entity != NULL and tras.Entity == self:GetEnemy() ) ) ) or self:NearestPoint(self:GetPos() +self:OBBCenter()):DistToSqr(tras.HitPos) > 60*60 then 
	
		--local hidingspot = self:GetForward()*10 + self:GetRight()*10
		local orgpos = self:GetPos() +self:GetUp()*36
		/*
		local randomnumber = math.random(1,10)
	
		if randomnumber == 1 then hidingspot = self:GetForward()*2.679 +self:GetRight()*10 end		--15 degree
		if randomnumber == 2 then hidingspot = self:GetForward()*2.679 +self:GetRight()*-10 end 
		if randomnumber == 3 then hidingspot = self:GetForward()*5.773 +self:GetRight()*10 end		--30 degree
		if randomnumber == 4 then hidingspot = self:GetForward()*5.773 +self:GetRight()*-10 end		
		if randomnumber == 5 then hidingspot = self:GetForward()*10 +self:GetRight()*10 end		--45 degree
		if randomnumber == 6 then hidingspot = self:GetForward()*10 +self:GetRight()*-10 end
		if randomnumber == 7 then hidingspot = self:GetForward()*17.32 +self:GetRight()*10 end
		if randomnumber == 8 then hidingspot = self:GetForward()*17.32 +self:GetRight()*-10 end
		if randomnumber == 9 then hidingspot = self:GetForward()*37.32 +self:GetRight()*10 end
		if randomnumber == 10 then hidingspot = self:GetForward()*37.32 +self:GetRight()*-10 end
		*/
		
		local hidingspottbl = {self:GetForward()*2.679 +self:GetRight()*10,
			self:GetForward()*2.679 +self:GetRight()*-10,
			self:GetForward()*5.773 +self:GetRight()*10,	
			self:GetForward()*5.773 +self:GetRight()*-10,
			self:GetForward()*10 +self:GetRight()*10,
			self:GetForward()*10 +self:GetRight()*-10,
			self:GetForward()*17.32 +self:GetRight()*10,
			self:GetForward()*17.32 +self:GetRight()*-10,
			self:GetForward()*37.32 +self:GetRight()*10,
			self:GetForward()*37.32 +self:GetRight()*-10}
		local chosenspot = Vector(0,0,0)
		local usablespots = {}
		local actualcoverpos = Vector(0,0,0)
		local trac = {}
		local trac1 = {}
		local trac2 = {}
		local trac2a = {}
		local trac2aendingpos = Vector(0,0,0)
		local enemydir = Vector(0,0,0)
		local uselastenemypos = false
		if self.SmartGrenadeThrow_enemyvisible_lastposition != Vector(0,0,0) and self.SmartGrenadeThrow_enemyvisible_NextT > CurTime() +self.SmartGrenadeThrow_enemyvisible_Next/2 and self.SmartGrenadeThrow_enemyvisible_previously == 1 and self.SmartGrenadeThrow_enemyvisibleshared == 0 then
		trac2aendingpos = Vector(self.SmartGrenadeThrow_enemyvisible_lastposition.x,self.SmartGrenadeThrow_enemyvisible_lastposition.y,self:GetEnemy():EyePos().z)
		uselastenemypos = true
		end
		if (self.CurrentSchedule != nil and self.CurrentSchedule.Name == "vj_flank_enemy" and self.FlankEnemy_ResetNextT > CurTime() + 14)  then
		uselastenemypos = false
		end
		if math.random(1,10) >= 4 then 
		local orgdirection = self:GetForward()*math.random(-450,-100) +self:GetRight()*math.random(-64,64)
		local traca = util.TraceLine({
						start = orgpos,
						endpos = orgpos + orgdirection,--self:GetForward()*math.random(-450,-100),
						filter = {self,self:GetActiveWeapon()}
						})
		orgpos = traca.HitPos + orgdirection:GetNormalized()*-20 --self:GetForward()*20
		end
		--local hidingspotdir = hidingspot:GetNormalized()
		for k,vpos in ipairs(hidingspottbl) do
		if chosenspot == Vector(0,0,0) or table.Count( usablespots ) <= 5 then
		--print("ni99a")
				trac = util.TraceLine({
						start = orgpos,
						endpos = orgpos +vpos:GetNormalized()*self.LookForCover_Var.Range,
						filter = {self,self:GetActiveWeapon()}
						})
				if trac.HitWorld == true or (trac.Entity != nil and trac.Entity != NULL and (trac.Entity:GetClass() == "prop_physics" or trac.Entity:GetClass() == "prop_dynamic" ) ) then 
				enemydir = (self:GetEnemy():GetPos() +self:GetEnemy():GetUp()*36 ) -trac.HitPos
				actualcoverpos = trac.HitPos + enemydir:GetNormalized()*(-20)
				
				--print("ni9")
				trac1 = util.TraceLine({
						start = actualcoverpos + Vector(0,0,0),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})

						
				if (trac1.HitWorld == true or (trac1.Entity != nil and trac1.Entity != NULL and (trac1.Entity:GetClass() == "prop_physics" or trac1.Entity:GetClass() == "prop_dynamic" ) )) then 
				
				trac2 = util.TraceLine({
						start = actualcoverpos + Vector(0,0,19),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
				if uselastenemypos == true then
						trac2a = util.TraceLine({
						start = actualcoverpos + Vector(0,0,19),
						endpos = trac2aendingpos,
						filter = {self,self:GetActiveWeapon()}
						})
				end
				
				if (trac2.HitWorld != true and ( self:GetEnemy():EyePos():DistToSqr(trac2.HitPos) <= 22*22 or (trac2.Entity != nil and trac2.Entity != NULL and trac2.Entity == self:GetEnemy() ) )) or (uselastenemypos == true and trac2a.HitWorld != true and trac2aendingpos:DistToSqr(trac2a.HitPos) <= 20*20 ) then

				--chosenspot = actualcoverpos
					table.insert( usablespots, actualcoverpos )
					local isclosestone = 1
					for ku,usepos in pairs(usablespots) do
					if usepos != nil and usepos != NULL then
					if self:GetPos():DistToSqr(usepos) < self:GetPos():DistToSqr(actualcoverpos) then 
						--chosenspot = actualcoverpos
						isclosestone = 0
					end
					end
					end
					if isclosestone == 1 then chosenspot = actualcoverpos end
					
				end
				end
				end
			end
			end
			
			if chosenspot != Vector(0,0,0) then
					self:SetLastPosition(chosenspot)
					self.CurrentCoveringPosition = chosenspot
					self:StopMoving()
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 1
					self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime*1.2
					self.LookForCover_NextT = CurTime() + self.LookForCover_Var.Nexttime*3.0
					self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*2
					self.NextChaseTime = CurTime() + 5
					self.NextIdleTime = CurTime() + 5
					self.LookForCover_activated = 1
					--print("nigdone")
					timer.Simple(5,function()
					if IsValid(self) then
					if self.LookForCover_activated == 1 then self.LookForCover_activated = 0 end
					end
					end)
			end
			
			
		end
	end
	end
	
	
	end
	end
	
	
	if self.CanSmartAttackPos == true then
	if self.SmartAttackPos_NextT < CurTime() and self.SmartAttackPos_activated != 1 and self:GetEnemy() == nil then
	self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime/2
	end
	if self.SmartAttackPos_NextT < CurTime() and self.LookForCover_activated != 1 and self.SmartAttackPos_activated != 1 and self.FlankEnemy_NextT > CurTime() and self.vACT_StopAttacks != true and self:GetEnemy() != nil and self:IsMoving() != true and IsValid(self:GetEnemy()) and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.Name != "vj_goto_lastpos" and self.CurrentSchedule.CanBeInterrupted == true )  ) then
	self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime
			local shouldmove = 0
			local movepos = self:GetPos()
			local cannotseeenemy = self:VJ_ForwardIsHidingZone(self:EyePos(),self:GetEnemy():EyePos(),true)
			local selectedent = NULL
			if (self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos(),false) == false) or (self.TimeSinceSeenEnemy > 5 and self:IsUnreachable(self:GetEnemy()) and cannotseeenemy == true) then
			
			local randpos = math.random(60,70)
			--if shouldmove == 2 then randpos = math.random(90,180) end
			local checkdist = {}
			local soldierlist = ents.FindInSphere(self:GetPos(),self.SmartAttackPos_Var.Range)
						
			for kc,vc in ipairs(soldierlist) do
			if shouldmove <= 1 then
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) then
			if self:DoRelationshipCheck(vc) == false and (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) and (IsValid(vc:GetEnemy()) and vc:GetEnemy() != nil and vc:Visible(vc:GetEnemy()) ) then
		
				if vc.Weapon_TimeSinceLastShot != nil and vc.Weapon_TimeSinceLastShot <= 5 then
				
				if self:IsUnreachable(self:GetEnemy()) and cannotseeenemy == true then
					shouldmove = 1
					selectedent = vc
					
				end
				if vc:VJ_ForwardIsHidingZone(vc:NearestPoint(vc:GetPos() +vc:OBBCenter()),vc:GetEnemy():EyePos(),false) == true and vc:VJ_ForwardIsHidingZone(vc:EyePos(),vc:GetEnemy():EyePos(),true) == false then
				--if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos(),false) != true or self:VJ_ForwardIsHidingZone(self:EyePos(),self:GetEnemy():EyePos(),true) != false then
					shouldmove = 2
					selectedent = vc
				
				--end

				end
					if shouldmove > 0 then
					checkdist = vc:VJ_CheckAllFourSides(randpos)
					if shouldmove == 2 and (checkdist.Right != true and checkdist.Left != true) then 
						shouldmove = 0
					end
					if shouldmove == 1 and (checkdist.Forward != true and checkdist.Backward != true and checkdist.Right != true and checkdist.Left != true) then 
						shouldmove = 0
					end
					end
				end
				
	
			end
			end
			end
			end
			
				if shouldmove > 0 and selectedent != nil and selectedent != NULL then
					--local randpos = math.random(50,70)
					--if shouldmove == 2 then randpos = math.random(90,180) end
					--local checkdist = selectedent:VJ_CheckAllFourSides(randpos)
					local randmove = {}
					if checkdist.Forward == true and shouldmove == 1 then table.insert(randmove,"Forward") end
					if checkdist.Backward == true and shouldmove == 1 then table.insert(randmove,"Backward") end
					if checkdist.Right == true then table.insert(randmove,"Right") end
					if checkdist.Left == true then table.insert(randmove,"Left") end
					local pickmove = VJ_PICKRANDOMTABLE(randmove)
					if pickmove == "Forward" then 
					self:SetLastPosition(selectedent:GetPos() + selectedent:GetForward()*randpos + selectedent:GetRight()*10) 
					self.CurrentCoveringPosition = selectedent:GetPos() + selectedent:GetForward()*randpos + selectedent:GetRight()*10
					end
					if pickmove == "Backward" then
					self:SetLastPosition(selectedent:GetPos() + selectedent:GetForward()*-randpos + selectedent:GetRight()*-10) 
					self.CurrentCoveringPosition = selectedent:GetPos() + selectedent:GetForward()*-randpos + selectedent:GetRight()*-10
					end
					if pickmove == "Right" then 
					self:SetLastPosition(selectedent:GetPos() + selectedent:GetForward()*-8 + selectedent:GetRight()*randpos) 
					self.CurrentCoveringPosition = selectedent:GetPos() + selectedent:GetForward()*-8 + selectedent:GetRight()*randpos
					end
					if pickmove == "Left" then 
					self:SetLastPosition(selectedent:GetPos() + selectedent:GetForward()*-8 + selectedent:GetRight()*-randpos) 
					self.CurrentCoveringPosition = selectedent:GetPos() + selectedent:GetForward()*-8 + selectedent:GetRight()*-randpos
					end
					if pickmove == "Forward" or pickmove == "Backward" or pickmove == "Right" or pickmove == "Left" then
					self:StopMoving()
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 0.5
					self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime*1.4
					self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*3
					self.NextChaseTime = CurTime() + 5
					self.NextIdleTime = CurTime() + 5
					self.SmartAttackPos_activated = 1
					timer.Simple(self.SmartAttackPos_Var.Nexttime+2.0,function()
					if IsValid(self) then
					if self.SmartAttackPos_activated == 1 then self.SmartAttackPos_activated = 0 end
					end
					end)
					
					end
				end
			
			end
			
	end
	end
	
	if self.CanProneCover == true then
	
	if self.ProneCover_activated == 1 and self.ProneCover_goingprone != 1 and CurTime() > self.ProneCover_durationT and self.ThrowingGrenade != true and self.vACT_StopAttacks != true and self.Flinching != true and self.BlindFire_activated == 0 then

		local tra = util.TraceLine({
						start = self:GetPos() + self:GetForward()*75,
						endpos =  self:GetPos() + self:GetForward()*75 + Vector(0,0,-90),
						filter = {self,self:GetActiveWeapon()}
						})
		if tra.HitWorld == true or (tra.Entity != nil and tra.Entity != NULL and !tra.Entity:IsNPC() and !tra.Entity:IsPlayer() ) then 
	
		local pronecoverduration = self.ProneCover_Var.duration + (math.random(0,self.ProneCover_Var.durationextra)/10)
		--self.ProneCover_goingprone = 1
		self.ProneCover_durationT = CurTime() + pronecoverduration
		self.NextChaseTime = CurTime() + pronecoverduration + 0.8
		self.TakingCoverT = CurTime() + pronecoverduration + 0.8
		self.NextCallForHelpT = CurTime() + pronecoverduration + self.NextCallForHelpTime
		self.NextWeaponAttackT = CurTime() + (pronecoverduration + 0.8)
		self.NextThrowSmartGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2) + pronecoverduration/2
		self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2) + pronecoverduration/2
		self.CanFlinch = 0
		self.MoveOrHideOnDamageByEnemy = false
		self:ClearPoseParameters()
		self.ProneCover_Var.CanPose = self.HasPoseParameterLooking
		self.HasPoseParameterLooking = false
		self.ProneCover_Var.WeaponSpread = self.WeaponSpread
		self.WeaponSpread = self.WeaponSpread*1.2
		--self.ProneCover_Var.Hulltype = self:GetHullType()
		local vec1, vec2 = self:GetCollisionBounds()
		if vec1 != nil then
			self.ProneCover_Var.Collidebound1 = vec1
			self.ProneCover_Var.Collidebound2 = vec2
		end
		
		self.CurrentAttackAnimation = "vjseq_arrestidle"
	
		self.PlayingAttackAnimation = true
		timer.Simple( (pronecoverduration+1) -0,function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:FaceCertainEntity(self:GetEnemy(),false)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,true,(pronecoverduration+0),true,0,{SequenceDuration=(pronecoverduration+0)})
		self:SetAbsVelocity( self:GetForward()*120 + self:GetUp()*50 ) 
		timer.Simple(0.35,function()
		if IsValid(self) then
			--self:SetHullType(HULL_TINY)
			--self:SetHullSizeNormal() 

			print(self:GetHullType())
			self.ProneCover_goingprone = 1
			--self.ForceWeaponFire_activated = 1
			self:CustomManipulateBone(self,"ValveBiped.Bip01_Head1",Angle(-45,0,60))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Thigh",Angle(0,-15,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_UpperArm",Angle(30,90,-30))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_Spine4",Angle(0,-30,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_L_UpperArm",Angle(0,30,60))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_L_Calf",Angle(0,-105,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Calf",Angle(0,-105,0))
			timer.Simple(0.08,function()
			if IsValid(self) then
				self:SetCollisionBounds(Vector(35, 22 , 25), Vector(-35, -22, 0))
			end
			end)
			timer.Simple(0.35,function()
			if IsValid(self) then
			if !IsValid(self:GetEnemy()) and self:CheckAlliesAroundMe(self.CallForBackUpOnDamageDistance).ItFoundAllies == true then
				self:BringAlliesToMe(self.CallForBackUpOnDamageDistance,self.CallForBackUpOnDamageUseCertainAmount,self.CallForBackUpOnDamageUseCertainAmountNumber)
			end
			end
			end)
		end 
		end)
	
		end
	

	end
	
	
	if self.ProneCover_goingprone == 1 then
	if self.ProneCover_durationT < CurTime() or ((self.ProneCover_durationT-(self.ProneCover_Var.duration/1.5)) < CurTime() and self:GetSequenceName(self:GetSequence()) != "arrestidle" ) or self.Flinching == true then
	--print(self:GetSequenceName(self:GetSequence()))
	self.ProneCover_activated = 0
	self.ProneCover_goingprone = 0
	self.ProneCover_NextT = CurTime() + self.ProneCover_Var.Cooltime
	self.ForceWeaponFire_activated = 0
	
	self.CanFlinch = self.ProneCover_Var.CanFlinch
	self.CallForHelp = self.ProneCover_Var.CanCallHelp
	self.DisableTakeDamageFindEnemy = self.ProneCover_Var.CanFindEnemy
	self.RunAwayOnUnknownDamage = self.ProneCover_Var.CanRunAway
	self.MoveOrHideOnDamageByEnemy = self.ProneCover_Var.CanCover
	self.CallForBackUpOnDamage = self.ProneCover_Var.CanCallHelp
	self.HasPoseParameterLooking = self.ProneCover_Var.CanPose
	self.WeaponSpread = self.ProneCover_Var.WeaponSpread
	--if self.HasHull == true then 
	--self:SetHullType(self.ProneCover_Var.Hulltype) 
	--self:SetHullSizeNormal() 
	--print(self:GetHullType())
	--end
	if self.ProneCover_Var.Collidebound1.x > self.ProneCover_Var.Collidebound2.x then
	self:SetCollisionBounds(self.ProneCover_Var.Collidebound1, self.ProneCover_Var.Collidebound2)
	else
	self:SetCollisionBounds(self.ProneCover_Var.Collidebound2, self.ProneCover_Var.Collidebound1)
	end
		timer.Simple(0.12,function()
		if IsValid(self) then
		self:CustomManipulateBone(self,"ValveBiped.Bip01_Head1",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Thigh",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_R_UpperArm",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_Spine4",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_L_UpperArm",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_L_Calf",Angle(0,0,0))
		self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Calf",Angle(0,0,0))
		end
		end)
	if self.ProneCover_durationT < CurTime() and self:GetSequenceName(self:GetSequence()) == "arrestidle" then 
		--self:DoIdleAnimation()
		self.CurrentAttackAnimation = "vjseq_crouch_idled"
		self.PlayingAttackAnimation = true
		timer.Simple((0.6),function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,true,(0.6),true,0,{SequenceDuration=(0.6)})
		print("11")
		print(self:GetHullType())
	else
	print( self:GetSequenceName(self:GetSequence()) )
	end
	
	if self:GetActiveWeapon() != nil and self:GetActiveWeapon() != NULL then
	if self:GetActiveWeapon().NPC_isRangeCooldown != nil then
		self:GetActiveWeapon().NPC_isRangeCooldown = 0
		self:GetActiveWeapon().NPC_firecontrolshotfired = 0
	end
	end
	
	
	end
	end
	
	end
	
	
	
	
	
	
	
	if self.CanBlindFireCover == true then
	if CurTime() >= self.BlindFire_NextT then
	self.BlindFire_NextT = CurTime() + self.BlindFire_Nexttime
	if self.BlindFire_activated == 0 and self.ThrowingGrenade != true and self.vACT_StopAttacks != true and self.Flinching != true and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil and self:GetEnemy() != nil and math.random(1,10) >= self.BlindFire_Chance then
	if (self:GetActiveWeapon().NPC_NoMoveShoot == nil or self:GetActiveWeapon().NPC_NoMoveShoot != true) and self:Visible(self:GetEnemy()) and self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) <= self.BlindFire_range*self.BlindFire_range and self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount*0.6 then
			
		local tra = util.TraceLine({
						start = self:GetPos() + self:GetUp()*32,
						endpos =  self:GetPos() + self:GetForward()*90 + self:GetUp()*32,
						filter = {self,self:GetActiveWeapon()}
						})
		if tra.HitWorld == true or (tra.Entity != nil and tra.Entity != NULL and !tra.Entity:IsNPC() and !tra.Entity:IsPlayer() ) then 
	
		local blindfireduration = self.BlindFire_duration + (math.random(0,self.BlindFire_Var.durationextra)/10)
	
		self.BlindFire_durationT = CurTime() + blindfireduration
		self.NextChaseTime = CurTime() + blindfireduration + 1
		self.TakingCoverT = CurTime() + blindfireduration + 0.7
		self.NextWeaponAttackT = CurTime() + (blindfireduration + 0.7)
		self.NextCallForHelpT = CurTime() + blindfireduration + self.NextCallForHelpTime
		self.NextThrowSmartGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2)
		self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2)
		self.BlindFire_Var.CanFlinch = self.CanFlinch
		self.BlindFire_Var.CanCover = self.MoveOrHideOnDamageByEnemy
		self.CanFlinch = 0
		self.MoveOrHideOnDamageByEnemy = false
		self:ClearPoseParameters()
		self.BlindFire_Var.CanPose = self.HasPoseParameterLooking
		self.HasPoseParameterLooking = false
		self.BlindFire_Var.WeaponSpread = self.WeaponSpread
		self.WeaponSpread = self.WeaponSpread*1.4
		
		if (self:GetActiveWeapon().HoldType != nil and self:GetActiveWeapon().HoldType == "pistol") or self.BlindFire_UsePistolAnim == true then
		self.CurrentAttackAnimation = "vjseq_crouch_idle_pistol"
		else
		self.CurrentAttackAnimation = "vjseq_crouch_idled"
		end
		self.PlayingAttackAnimation = true
		timer.Simple( (blindfireduration+1) -0,function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:FaceCertainEntity(self:GetEnemy(),false)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,true,(blindfireduration+1.0),true,0,{SequenceDuration=(blindfireduration+1)})
		
		timer.Simple(0.25,function()
		if IsValid(self) then
		
			self.BlindFire_activated = 1
			--self.ForceWeaponFire_activated = 1
			self:CustomManipulateBone(self,"ValveBiped.Bip01_Spine1",Angle(0,-45,-45))
			if self:GetActiveWeapon() != NULL and self:GetActiveWeapon().HoldType != nil and self:GetActiveWeapon().HoldType == "pistol" then
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Hand",Angle(45,-15,75))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Forearm",Angle(0,45,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_UpperArm",Angle(120,0,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_Head1",Angle(0,-45,0))
			else
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_UpperArm",Angle(135,-30,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_Head1",Angle(0,-60,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Forearm",Angle(0,30,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Hand",Angle(45,-45,45))
			end
			timer.Simple(0.4,function()
			if IsValid(self) then
			if self.BlindFire_activated == 1 then
				self.ForceWeaponFire_activated = 1
			end
			end
			end)
		end 
		end)
	
		end
	
	end
	end
	end
	
	if self.BlindFire_activated == 1 then
	if self.BlindFire_durationT < CurTime() or ((self.BlindFire_durationT-1.4) < CurTime() and self:GetSequenceName(self:GetSequence()) != "Crouch_idleD" and self:GetSequenceName(self:GetSequence()) != "Crouch_idle_pistol") or self.Weapon_ShotsSinceLastReload >= self.Weapon_StartingAmmoAmount or self:GetEnemy() == nil or self.Flinching == true then
	--print(self:GetSequenceName(self:GetSequence()))
	self.BlindFire_activated = 0
	self.BlindFire_NextT = CurTime() + self.BlindFire_Cooltime
	self.ForceWeaponFire_activated = 0
	self.CanFlinch = self.BlindFire_Var.CanFlinch
	self.MoveOrHideOnDamageByEnemy = self.BlindFire_Var.CanCover
	self.WeaponSpread = self.BlindFire_Var.WeaponSpread
	
	self:CustomManipulateBone(self,"ValveBiped.Bip01_Spine1",Angle(0,0,0))
	self:CustomManipulateBone(self,"ValveBiped.Bip01_R_UpperArm",Angle(0,0,0))
	self:CustomManipulateBone(self,"ValveBiped.Bip01_Head1",Angle(0,0,0))
	self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Forearm",Angle(0,0,0))
	self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Hand",Angle(0,0,0))
	
	self.HasPoseParameterLooking = self.BlindFire_Var.CanPose
	
	if self:GetActiveWeapon() != nil and self:GetActiveWeapon() != NULL then
	if self:GetActiveWeapon().NPC_isRangeCooldown != nil then
		self:GetActiveWeapon().NPC_isRangeCooldown = 0
		self:GetActiveWeapon().NPC_firecontrolshotfired = 0
	end
	end
	
	
	end
	end
	
	end
	
	if self.CanForceWeaponFire == true and self.ForceWeaponFire_activated == 1 then
	
	if self.ForceWeaponFire_activated == 1 and self:GetEnemy() != nil and IsValid(self:GetEnemy()) and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
	if CurTime() > self.ForceWeaponFire_NPCNextPrimaryFireT and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self:GetActiveWeapon().IsVJBaseWeapon != nil and (self.ForceWeaponFire_cooldown == 0 or (self:GetActiveWeapon().NPC_isRangeCooldown != 1)) then
	
	self:GetActiveWeapon():PrimaryAttack()
	self.ForceWeaponFire_NPCNextPrimaryFireT = CurTime() + self:GetActiveWeapon().NPC_NextPrimaryFire
	
	end
	end
	
	timer.Simple(0.03,function()
	if IsValid(self) then
		if self.ForceWeaponFire_activated == 1 and self:GetEnemy() != nil and IsValid(self:GetEnemy()) and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
		if CurTime() > self.ForceWeaponFire_NPCNextPrimaryFireT and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self:GetActiveWeapon().IsVJBaseWeapon != nil and (self.ForceWeaponFire_cooldown == 0 or (self:GetActiveWeapon().NPC_isRangeCooldown != 1)) then
		self:GetActiveWeapon():PrimaryAttack()
		self.ForceWeaponFire_NPCNextPrimaryFireT = CurTime() + self:GetActiveWeapon().NPC_NextPrimaryFire
		end
		end
	end
	end)
	
	timer.Simple(0.06,function()
	if IsValid(self) then
		if self.ForceWeaponFire_activated == 1 and self:GetEnemy() != nil and IsValid(self:GetEnemy()) and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil then
		if CurTime() > self.ForceWeaponFire_NPCNextPrimaryFireT and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self:GetActiveWeapon().IsVJBaseWeapon != nil and (self.ForceWeaponFire_cooldown == 0 or (self:GetActiveWeapon().NPC_isRangeCooldown != 1)) then
		self:GetActiveWeapon():PrimaryAttack()
		self.ForceWeaponFire_NPCNextPrimaryFireT = CurTime() + self:GetActiveWeapon().NPC_NextPrimaryFire
		end
		end
	end
	end)
	
	
	
	end
	
	
	
	if self.IsMedicSNPC == true and self.CanThrowMedkit == true then
	
	if self.ThrowMedkit_Medkitent != nil and self.ThrowMedkit_Medkitent != NULL then
	local entlist = ents.FindInSphere(self.ThrowMedkit_Medkitent:GetPos(),15)
	for kb,vb in ipairs(entlist) do
		if !vb:IsNPC() && !vb:IsPlayer() then continue end
		if self.ThrowMedkit_Medkitent != nil and self.ThrowMedkit_Medkitent != NULL then
		if vb:EntIndex() != self:EntIndex() && (!vb.IsVJBaseSNPC_Tank) && vb:Health() > 0 && ((vb.IsVJBaseSNPC == true ) or (vb:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0)) then
		if self:DoRelationshipCheck(vb) == false or (vb.vj_doi_isteam != nil and vb.vj_doi_isteam == self.vj_doi_isteam) then
		
		local frimaxhp = vb:GetMaxHealth()
		local fricurhp = vb:Health()
		vb:SetHealth(math.Clamp(fricurhp + self.ThrowMedkit_HealthAmount,fricurhp,frimaxhp))
		self:CustomOnMedic_OnHeal()
		self:MedicSoundCode_OnHeal()
		vb:RemoveAllDecals()
		if vb:IsNPC() && vb.IsVJBaseSNPC == true && vb.IsVJBaseSNPC_Animal != true then
			vb:MedicSoundCode_ReceiveHeal()
		end
		self.ThrowMedkit_Medkitent:Remove()
		end
		end
		end
	end
		if self.ThrowMedkit_RemoveT < CurTime() then self.ThrowMedkit_Medkitent:Remove() end
	end
	
	if CurTime() >= self.ThrowMedkit_NextT then
	
	self.ThrowMedkit_NextT = CurTime() + self.ThrowMedkit_Nexttime
	if self.ThrowMedkit_activated == 0 and math.random(1,self.ThrowMedkit_chance) == 1 and self.ThrowMedkit_NextT != 0 and self.Medic_IsHealingAlly == false and self.DoingWeaponAttack == false and CurTime() >= self.Medic_NextHealT and self.vACT_StopAttacks == false then
		--self.NextChaseTime = CurTime() + 4
		--self.Medic_NextHealT = CurTime() + math.Rand(self.Medic_NextHealTime1,self.Medic_NextHealTime2)
		if self.ThrowMedkit_Medkitent == nil or self.ThrowMedkit_Medkitent == NULL then
			local entlist1 = ents.FindInSphere(self:GetPos(),self.ThrowMedkit_range)
			for kc,vc in ipairs(entlist1) do
			if !vc:IsNPC() && !vc:IsPlayer() then continue end
			if self.ThrowMedkit_activated == 0 then
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && self:Visible(vc) && vc:Health() > 0 && vc:Health() <= vc:GetMaxHealth()*0.7 && ((vc.IsVJBaseSNPC == true ) or (vc:IsPlayer() && GetConVarNumber("ai_ignoreplayers") == 0)) then
			if self:DoRelationshipCheck(vc) == false or (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) then
		
				self.ThrowMedkit_RemoveT = CurTime() + 10
				self.ThrowMedkit_activated = 1
				self:ThrowMedkitCode(vc)
				self.NextChaseTime = CurTime() + 4
				self.Medic_NextHealT = CurTime() + math.Rand(self.Medic_NextHealTime1,self.Medic_NextHealTime2)
				timer.Simple(1,function()
				if IsValid(self) then
					self.ThrowMedkit_activated = 0
				end
				end)
				
			end
			end
			end
			end
		end
	end
	
	
	end
	
	
	
	end
	
	
	
	if self.Secondaryweapon_Usingsecondaryweapon == 0 and self.CanPickUpNewWeapon == true and (self:GetEnemy() == nil or self:GetActiveWeapon() == NULL) and self.PickUpNewWeapon_targetgun != nil and self.vACT_StopAttacks == false then
	
	for ks,vs in ipairs(ents.FindInSphere(self:GetPos(),50)) do
	if self.PickUpNewWeapon_targetgun != nil and vs == self.PickUpNewWeapon_targetgun then
	

	local weaponclass = self.PickUpNewWeapon_targetgun:GetClass()
	self.PickUpNewWeapon_targetgun = nil
	if self.VJ_PlayingSequence == false then
		self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_PickUpNewWeapon)
		self.PlayingAttackAnimation = true
		timer.Simple(VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -0.1,function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:FaceCertainEntity(vs,false)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,true,self:DecideAnimationLength(self.CurrentAttackAnimation,false),false,0)
	end
	
	timer.Simple(0.2,function()
	if IsValid(self) then
		if (self:GetActiveWeapon() != nil) and (self:GetActiveWeapon() != NULL) then 
		self:GetActiveWeapon():Remove() 
		end
	end
	end)
	
	timer.Simple(0.67,function()
	if IsValid(self) then
			self:Give( weaponclass )
			self.Weapon_ShotsSinceLastReload = 0
			self.HasNewWeaponPickUp = true
			if IsValid(vs) then vs:Remove() end
			--if self:GetActiveWeapon() != nil then
		--	if self:GetActiveWeapon():LookupAttachment("muzzle_flash") == 0 then self.CanSmartAiming == false end
			--end
			timer.Simple(math.random(75,105),function()
			if IsValid(self) then
				self.HasNewWeaponPickUp = false
			end
			end)
	end
	end)
	
	timer.Simple(0.675,function()
	if IsValid(self) then
			if self:GetActiveWeapon() != nil and self:GetActiveWeapon() != NULL then
			if self:GetActiveWeapon():LookupAttachment("muzzle_flash") == 0 then self.CanSmartAiming = false end
			end
	end
	end)
	
	
	end
	end
	
	end
	
	if self.CanPickUpNewWeapon == true and self.Secondaryweapon_Usingsecondaryweapon != 1 and self.HasNewWeaponPickUp != true and (!IsValid(self:GetEnemy()) or self:GetActiveWeapon() == NULL) and self.PickUpNewWeapon_targetgun == nil then
	
	if self:GetActiveWeapon() == NULL and self.PickUpNewWeapon_targetgun == nil then self.PickUpNewWeapon_radius = 1500 end
	
	if CurTime() >= self.PickUpNewWeapon_NextT then

		local weaponallycount = 0
		--local selectedweapon = 0
	for ka,va in ipairs(ents.FindInSphere(self:GetPos(),self.PickUpNewWeapon_radius)) do
	if self.PickUpNewWeapon_targetgun == nil and self.PickUpNewWeapon_NextT != 0 then
		
		if va:IsNPC() && va != self && va.VJ_NPC_Class != nil && va.HasNewWeaponPickUp != nil then
		if va.vj_doi_isteam == self.vj_doi_isteam and va.HasNewWeaponPickUp == true then
			weaponallycount = weaponallycount + 1
		end
		end

	
		if va.IsVJBaseWeapon != nil and va.VJBaseWeaponbeingpickedup == nil then
		if va.IsVJBaseWeapon == true and va.Primary != nil and (va.Owner == nil or va.Owner == NULL) then
		
		local weaponpoints = 0
		if (self:GetActiveWeapon() != nil) and (self:GetActiveWeapon() != NULL) then
			if va.Primary.Damage != nil and va.Primary.ClipSize != nil and va.Primary.Damage != nil and va.NPC_NextPrimaryFire != nil and self:GetActiveWeapon().Primary != nil then
			if va.Primary.Damage >= self:GetActiveWeapon().Primary.Damage + 8 then weaponpoints = weaponpoints + 1 end
			if va.Primary.ClipSize >= self:GetActiveWeapon().Primary.ClipSize + 20 then weaponpoints = weaponpoints + 1 end
			if va.Primary.ClipSize >= self:GetActiveWeapon().Primary.ClipSize + 40 then weaponpoints = weaponpoints + 1 end
			if va.NPC_NextPrimaryFire+0.15 <= self:GetActiveWeapon().NPC_NextPrimaryFire then weaponpoints = weaponpoints + 1 end
			if va.NPC_CustomSpread + 0.15 <= self:GetActiveWeapon().NPC_CustomSpread then weaponpoints = weaponpoints + 1 end
			if va.doi_isheavyweapon != nil and self:GetActiveWeapon().doi_isheavyweapon == nil then 
				weaponpoints = weaponpoints + 3
			end
			if va.HoldType != "pistol" and self:GetActiveWeapon().HoldType == "pistol" then 
				weaponpoints = weaponpoints + 1
			end
			end
		else
			weaponpoints = 100
			weaponallycount = -100
		end
		
		if weaponpoints >= 3 and weaponallycount < 3 then
			--selectedweapon = va
			va.VJBaseWeaponbeingpickedup = 1
			self.PickUpNewWeapon_targetgun = va
			self:SetLastPosition( va:GetPos() ) 
			self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH")
			self.PickUpNewWeapon_NextT = CurTime() + 13
				timer.Simple(10,function()
				if IsValid(self) then
				if self.PickUpNewWeapon_targetgun != nil and self.PickUpNewWeapon_targetgun != NULL then self.PickUpNewWeapon_targetgun.VJBaseWeaponbeingpickedup = nil end
					self.PickUpNewWeapon_targetgun = nil
				end
				end)
		end
		
		end
		end
		
	end
	end
			self.PickUpNewWeapon_NextT = CurTime() + self.PickUpNewWeapon_Nexttime
	end
	end
	
	
	if self.CanFlankEnemy == true then
	
	if self.FlankEnemy_ResetNextT < CurTime() and self:GetEnemy() == nil and self.CurrentSchedule != nil then
	if self.CurrentSchedule.Name == "vj_flank_enemy" then 
	self:ClearSchedule()
	self.FlankEnemy_ResetNextT = CurTime() + 20
	self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime
	end
	end
	
	if self.FlankEnemy_StopNextT < CurTime() and self:GetEnemy() != nil and self.CurrentSchedule != nil then
	if self.CurrentSchedule.Name == "vj_flank_enemy" then 
	self.FlankEnemy_StopNextT = CurTime() + 2.5
	if self.LastSeenEnemyTime > 2 then self.LastSeenEnemyTime = self.LastSeenEnemyTime - 1.5 end
	if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) <= 280*280 and self:GetEnemy():Visible(self) then
		self:ClearSchedule()
		self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*3
	end
	end
	end
	
	if self:GetEnemy() != nil and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.Name != "vj_flank_enemy") or (self.CurrentSchedule != nil and self.CurrentSchedule.Name == "vj_goto_lastpos" and self.CurrentSchedule.CanBeInterrupted == true ) ) and CurTime() > self.FlankEnemy_NextT then
	self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime
	local EnemyDist = self:GetPos():DistToSqr( self:GetEnemy():GetPos() )
	local flankingallycount = 0
	local attackingallycount = 0
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),900)) do
		if v:IsNPC() && v != self && v.VJ_NPC_Class != nil && v.CurrentSchedule != nil then
		if v.vj_doi_isteam == self.vj_doi_isteam and v.CurrentSchedule.Name == "vj_flank_enemy" then
		flankingallycount = flankingallycount + 1
		end
		end
			if v:IsNPC() then
			if v:EntIndex() != self:EntIndex() && (!v.IsVJBaseSNPC_Tank) && v:Health() > 0 && (v.IsVJBaseSNPC == true && v.Dead != true) and v:GetActiveWeapon() != NULL and v:GetActiveWeapon() != nil then
			if (v.vj_doi_isteam != nil and v.vj_doi_isteam == self.vj_doi_isteam) and v.vACT_StopAttacks == false and v.DoingWeaponAttack == true and self:GetEnemy():Visible(v) then
			attackingallycount = attackingallycount + 1
			end
			end
			end
		end
	local isincover = 0
	if attackingallycount >= self.FlankEnemy_attackallylimit then
		local trascc = util.TraceLine({
						start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
	if (trascc.HitWorld == true or (trascc.Entity != nil and trascc.Entity != NULL and (trascc.Entity:GetClass() == "prop_physics" or trascc.Entity:GetClass() == "prop_dynamic") ) ) and self:NearestPoint(self:GetPos() +self:OBBCenter()):DistToSqr(trascc.HitPos) < 100*100 then 
		isincover = 1
	end
	end
	if self.DoingWeaponAttack == false and self.vACT_StopAttacks != true and flankingallycount <= self.FlankEnemy_allylimit and self:CanDoCertainAttack() == true and self:CanDoWeaponAttack() == true and self.FlankEnemy_activated == 0 and EnemyDist > 350*350 and EnemyDist <= 4100*4100 and self.SmartAiming_activated == 0 and (!self:GetEnemy():Visible(self) or (isincover == 0 and attackingallycount >= self.FlankEnemy_attackallylimit)) and math.random(1,self.FlankEnemy_chance) == 1 then
	self.FlankEnemy_activated = 1

	local enemypos = self:GetEnemy():GetPos() + self:GetEnemy():GetUp()*5
	local selfpos = self:GetPos() + self:GetUp()*5
	local Midpoint = Vector((selfpos.x + enemypos.x)/2,(selfpos.y + enemypos.y)/2,(selfpos.z + enemypos.z)/2)

	local shouldflankbehind = false
	if self.CanFlankBehind == true then
	if math.random(1,10) >= self.FlankBehind_Chance or (math.random(1,10) >= self.FlankBehind_Chance/1.5 and self.FlankEnemy_failed == 1 ) then 
	if EnemyDist <= self.FlankBehind_Range*self.FlankBehind_Range then
		shouldflankbehind = true
	end
	end
	end
	if self.FlankEnemy_failed == 1 then self.FlankEnemy_failed = 0 end
	local point = ents.Create("prop_dynamic")
	point:SetModel("models/vj_weapons/w_grenade.mdl")
	if shouldflankbehind == true then
		point:SetPos(enemypos)
	else
		point:SetPos(Midpoint)
	end
	point:SetAngles( Angle(0,(enemypos-selfpos):Angle().y,0) )
	point:Spawn()
	point:SetNoDraw( true ) 
	self:DeleteOnRemove(point)
	local physa = point:GetPhysicsObject()
	if (physa:IsValid()) then
		physa:EnableCollisions(false)
	end
	local flankrange_min = 20
	local flankrange_max = 100
	if EnemyDist <= 1400*1400 then
	flankrange_min = 35
	flankrange_max = 120
	end
	local goal = Vector(0,0,0)
	if math.random(1,2) == 1 then
		if shouldflankbehind == true then
		goal = point:GetPos() + point:GetRight()*( selfpos:Distance(enemypos)*math.random(flankrange_min,flankrange_max)/100 ) + point:GetForward()*( math.random(-1,18)*10 )
		else
		goal = point:GetPos() + point:GetRight()*( selfpos:Distance(enemypos)*math.random(flankrange_min-5,flankrange_max+10)/100 )
		end
	else
		if shouldflankbehind == true then
		goal = point:GetPos() + point:GetRight()*( selfpos:Distance(enemypos)*math.random(flankrange_min,flankrange_max)/100 )*-1 + point:GetForward()*( math.random(-1,18)*10 )
		else
		goal = point:GetPos() + point:GetRight()*( selfpos:Distance(enemypos)*math.random(flankrange_min-5,flankrange_max+10)/100 )*-1
		end
	end
	
	timer.Simple(0.1,function()
	if IsValid(self) then
		point:SetPos(goal)
		if self:IsUnreachable(point) == false and self:GetEnemy() != nil and IsValid(self:GetEnemy()) and goal:DistToSqr( self:GetEnemy():GetPos() ) < self.FlankEnemy_minrange*self.FlankEnemy_minrange then
		--self:NavSetGoal( goal )
		if math.abs( self.NextChaseTime - CurTime() ) < 4 then
			self.NextChaseTime = CurTime() + 5
		end
		self.CurrentCoveringPosition = goal
		self:SetLastPosition( goal ) 
		self:VJ_TASK_FLANK_ENEMY()
		self.FlankEnemy_ResetNextT = CurTime() + 20
		self.FlankEnemy_StopNextT = CurTime() + 5
		self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 0.5
		else
		if self:GetEnemy() != nil and IsValid(self:GetEnemy()) then self.FlankEnemy_failed = 1 end
		end
	end
	end)
	
	
	timer.Simple(0.5,function()
	if IsValid(self) then
	self.FlankEnemy_activated = 0
	point:Remove()
	end 
	end)
	
	
	
	
	end
	end
	
	end
	
	if self.CanTrickShoot == true then
	if CurTime() > self.TrickShoot_NextT and self.TrickShoot_activated == 0 and self.MovementType == VJ_MOVETYPE_GROUND and /*self.CurrentSchedule == nil and self:IsMoving() == false and*/ self.vACT_StopAttacks == false then
	self.TrickShoot_NextT = CurTime() + self.TrickShoot_Nexttime
	--	print("n199a")
	if IsValid(self:GetEnemy()) and ((self.DoingWeaponAttack == true and self.DoingWeaponAttack_Standing == true) or (self.LastSeenEnemyTime < 4)) and math.random(1,10) >= self.TrickShoot_Chance then
	if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) < self.TrickShoot_Range*self.TrickShoot_Range then
	if (self.TrickShoot_OnlyWhenEnemyLooking == false) or (self:GetEnemy():GetForward():Dot((self:GetPos() -self:GetEnemy():GetPos()):GetNormalized()) > math.cos(math.rad(self.TrickShoot_OnlyWhenEnemyLookingradius))) then
		
		local chosenspottododge = Vector(0,0,0)
		local randomside = 1
		if math.random(0,1) == 1 then randomside = -1 end
		local isincover = true
		local canonlychooseoneside = false
		local ismovingnow = false
		local trase = util.TraceLine({
						start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
		if (trase.HitWorld != true and ( (trase.Entity != nil and trase.Entity != NULL and trase.Entity == self:GetEnemy() ) ) ) or self:NearestPoint(self:GetPos() +self:OBBCenter()):DistToSqr(trase.HitPos) > 120*120 then 
			isincover = false
		end
		
		if self.CurrentSchedule != nil and self:IsMoving() == true then
			ismovingnow = true
			canonlychooseoneside = true
			local velpos = self:GetPos() +self:GetVelocity():GetNormalized()*100 --self:GetGroundSpeedVelocity():GetNormalized()*100
			if velpos:DistToSqr( (self:GetPos() +self:GetRight()*100) ) < velpos:DistToSqr( (self:GetPos() +self:GetRight()*-100) ) then 
				randomside = 1
			else
				randomside = -1
			end
		end
		
		local trace11tbl = {
						start = self:GetPos() +self:GetUp()*5,
						endpos = self:GetPos() +self:GetUp()*5 +self:GetRight()*math.random(self.TrickShoot_Rangemin+5,self.TrickShoot_Rangemax)*randomside,
						filter = {self,self:GetActiveWeapon()}
						}
		local trace11 = {}
		local trace11b = {}
		local trace11c = {}
		local trace11c2 = {}
		local trace11c3 = {}
		local trace11d = {}
		trace11 = util.TraceEntity(trace11tbl,self)
		--print("n1994")
		if self:GetPos():DistToSqr( trace11.HitPos ) >= self.TrickShoot_Rangemin*self.TrickShoot_Rangemin then
		trac11b = util.TraceLine({
						start = Vector(trace11.HitPos.x,trace11.HitPos.y,self:EyePos().z-15),--trace11.HitPos + Vector(0,0,70),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})

						
			if (trac11b.HitPos:DistToSqr(self:GetEnemy():EyePos()) <= 2*2 or trac11b.Entity == self:GetEnemy()) or self.TrickShootHide_GoHide == 1 then
			
			trac11c = util.TraceLine({
						start = trace11.HitPos,--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(0,0,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			trac11c2 = util.TraceLine({
						start = trace11.HitPos + Vector(10,10,0),--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(10,10,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			trac11c3 = util.TraceLine({
						start = trace11.HitPos + Vector(-10,-10,0),--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(-10,-10,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			if trac11c.HitWorld == true and trac11c2.HitWorld == true and trac11c3.HitWorld == true then
			
				if isincover == true then 
					trac11d = util.TraceLine({
						start = Vector(trace11.HitPos.x,trace11.HitPos.y,self:NearestPoint(self:GetPos()+self:OBBCenter()).z),--trace11.HitPos + Vector(0,0,70),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
					if trac11d.HitWorld == true or (trac11d.Entity != NULL and trac11d.Entity != nil and (trac11d.Entity:GetClass() == "prop_dynamic" or trac11d.Entity:GetClass() == "prop_physics")) then 
						chosenspottododge = trace11.HitPos
					end
				else
					chosenspottododge = trace11.HitPos
				end
				
			end
			
			end
		end
		if chosenspottododge == Vector(0,0,0) and canonlychooseoneside == false then
		trace11tbl = {
						start = self:GetPos() +self:GetUp()*5,
						endpos = self:GetPos() +self:GetUp()*5 +self:GetRight()*math.random(self.TrickShoot_Rangemin+5,self.TrickShoot_Rangemax)*randomside*-1,
						filter = {self,self:GetActiveWeapon()}
						}
		trace11 = util.TraceEntity(trace11tbl,self)
		--print("n19944")
		if self:GetPos():DistToSqr( trace11.HitPos ) >= self.TrickShoot_Rangemin*self.TrickShoot_Rangemin then
		trac11b = util.TraceLine({
						start = Vector(trace11.HitPos.x,trace11.HitPos.y,self:EyePos().z-15),--trace11.HitPos + Vector(0,0,70),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
			if (trac11b.HitPos:DistToSqr(self:GetEnemy():EyePos()) <= 2*2 or trac11b.Entity == self:GetEnemy()) or self.TrickShootHide_GoHide == 1 then
			
			trac11c = util.TraceLine({
						start = trace11.HitPos,--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(0,0,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			trac11c2 = util.TraceLine({
						start = trace11.HitPos + Vector(10,10,0),--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(10,10,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			trac11c3 = util.TraceLine({
						start = trace11.HitPos + Vector(-10,-10,0),--trace11.HitPos + Vector(0,0,70),
						endpos = trace11.HitPos + Vector(-10,-10,-60),
						filter = {self,self:GetActiveWeapon()}
						})
			if trac11c.HitWorld == true and trac11c2.HitWorld == true and trac11c3.HitWorld == true then
			
				if isincover == true then 
					trac11d = util.TraceLine({
						start = Vector(trace11.HitPos.x,trace11.HitPos.y,self:NearestPoint(self:GetPos()+self:OBBCenter()).z),--trace11.HitPos + Vector(0,0,70),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
					if trac11d.HitWorld == true or (trac11d.Entity != NULL and trac11d.Entity != nil and (trac11d.Entity:GetClass() == "prop_dynamic" or trac11d.Entity:GetClass() == "prop_physics")) then 
						chosenspottododge = trace11.HitPos
					end
				else
					chosenspottododge = trace11.HitPos
				end
				
			end
			
			end
		end
		end
		if self.TrickShootHide_GoHide == 1 then self.TrickShootHide_GoHide = 0 end
		if chosenspottododge != Vector(0,0,0) then
			self.TrickShoot_activated = 1
			self.TrickShoot_NextT = CurTime() + self.TrickShoot_Cooldown
			self.ProneCover_NextT = CurTime() + self.ProneCover_Nexttime*3
			self.BlindFire_NextT = CurTime() + self.BlindFire_Nexttime*2
				
			local greShootVel = chosenspottododge -self:GetPos()
			local selfpos = self:GetPos()
			local heightdifference = chosenspottododge.z - selfpos.z
			local targetdir = chosenspottododge -selfpos
			local Midpoint = Vector((selfpos.x + chosenspottododge.x)/2,(selfpos.y + chosenspottododge.y)/2,(selfpos.z + chosenspottododge.z)/2)
			local midpointdist = selfpos:Distance( Midpoint )
			local midpointupper = Midpoint + Vector(0,0, midpointdist*0.3639 ) --/1 for tan45 , 1.731 for tan60 (sqroot 3), 0.5773 tan 30 , tan 20 0.36397
			local tr = util.TraceLine({
							start = self:GetPos() + self:GetUp()*85,
							endpos = midpointupper,
							filter = {self}
							})
			local vel_range = 0
			local vel_force	= 0
				greShootVel = midpointupper -selfpos
				vel_range = (midpointdist*2)*0.01905 + ((heightdifference*0.01905)/0.3639)
				vel_force = math.sqrt( (11.43*vel_range)/(0.6428) ) --1 unit = 0.01905m sin 2.1 rad = 0.8632 -- 11.43 sin 0.6981 rad
				greShootVel = greShootVel:GetNormalized()*(vel_force/0.01905)
			local enabledrag = true
			local physo = self:GetPhysicsObject()
			if (physo:IsValid()) then
				enabledrag = physo:IsDragEnabled()
				physo:EnableDrag( false )
			end
			self:SetGroundEntity(NULL)
			self:SetVelocity(greShootVel*1.0)
			self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Thigh",Angle(15,-9,0))
			self:CustomManipulateBone(self,"ValveBiped.Bip01_L_Thigh",Angle(-15,0,0))
		--	print("n199")
			timer.Simple(0.5,function()
			if IsValid(self) then
			if self.TrickShoot_activated == 1 then
				self.TrickShoot_activated = 0
				if (physo:IsValid()) then
				physo:EnableDrag( enabledrag )
				end
				self:CustomManipulateBone(self,"ValveBiped.Bip01_R_Thigh",Angle(0,0,0))
				self:CustomManipulateBone(self,"ValveBiped.Bip01_L_Thigh",Angle(0,0,0))
				--print("h1009")
			end
			end
			end)
			
		end
	end
	end
	end
	
	end
	end
	
	
	if self.CanTrickShootHide == true then
	if self.TrickShootHide_NextT < CurTime() then
		self.TrickShootHide_NextT = CurTime() + self.TrickShootHide_Nexttime
		if IsValid(self:GetEnemy()) and math.abs(CurTime() - self.TrickShoot_NextT) > 0.4 and math.random(1,10) >= self.TrickShootHide_chance then
		if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) <= 3600*3600 then
		local shouldtrickhiding = 0
			if self:GetEnemy():IsPlayer() and self:GetEnemy():GetActiveWeapon() != NULL and self:GetEnemy():GetActiveWeapon() != nil then
				local traca2s2 = util.TraceLine({
						start = self:GetEnemy():GetShootPos(),
						endpos = self:GetEnemy():GetShootPos()+self:GetEnemy():GetAimVector():GetNormalized()*3600,
						filter = {self:GetEnemy(),self:GetEnemy():GetActiveWeapon(),self:GetActiveWeapon()}
						})
				if traca2s2.Entity != nil and traca2s2.Entity != NULL and traca2s2.Entity == self then
					shouldtrickhiding = 1
				end
			end
			if self:GetEnemy():IsNPC() and self:GetEnemy().IsVJBaseSNPC == true && self:GetEnemy().Dead != true then
			if self:GetEnemy():GetEnemy() != nil and self:GetEnemy():GetEnemy() != NULL and IsValid(self:GetEnemy():GetEnemy()) and self:GetEnemy():GetEnemy() == self then
				if self:GetEnemy():GetActiveWeapon() != NULL and self:GetEnemy():GetActiveWeapon() != nil then
				if self:GetEnemy():GetActiveWeapon().IsVJBaseWeapon == true then 
				if self:GetEnemy():GetActiveWeapon().Primary.DisableBulletCode == true and (CurTime() + self:GetEnemy():GetActiveWeapon().NPC_NextPrimaryFire) - self:GetEnemy():GetActiveWeapon().NPC_NextPrimaryFireT < 0.4 then
					shouldtrickhiding = 1
				end
				end
				end
				
				if self:GetEnemy().AlreadyDoneRangeAttackFirstProjectile == true or self:GetEnemy().AlreadyDoneFirstLeapAttack == true then
					shouldtrickhiding = 1
				end
			end
			end
			
			if shouldtrickhiding == 1 then
				self.TrickShootHide_NextT = CurTime() + self.TrickShootHide_cooldown
				self.TrickShoot_NextT = CurTime() + 0.2 + (math.random(0,2)/10)
				if self.TrickShootHide_GoHide == 0 then self.TrickShootHide_GoHide = 1 end
			end
		end
		end
	
	end
	end
	
	
	if self.CanFlankAttackPosition == true then
	
	if self.FlankAttackPosition_ResetNextT < CurTime() and !IsValid(self:GetEnemy()) and self.CurrentSchedule != nil then
	if self.CurrentSchedule.IsFlankAttacking == true then 
	self:ClearSchedule()
	self.FlankAttackPosition_ResetNextT = CurTime() + 15
	self.FlankAttackPosition_NextT = CurTime() + self.FlankAttackPosition_Nexttime
	end
	end
	
	if self.FlankAttackPosition_StopNextT < CurTime() and IsValid(self:GetEnemy()) and self.CurrentSchedule != nil then
	if self.CurrentSchedule.IsFlankAttacking == true then 
	self.FlankAttackPosition_StopNextT = CurTime() + 2.5
	if self.LastSeenEnemyTime > 2 then self.LastSeenEnemyTime = self.LastSeenEnemyTime - 1.5 end
	if self:GetPos():DistToSqr( self:GetEnemy():GetPos() ) <= 300*300 and self:GetEnemy():Visible(self) then
		self:ClearSchedule()
		self.FlankAttackPosition_NextT = CurTime() + self.FlankAttackPosition_Nexttime*1.2
	end
	end
	end
	
	if self.FlankAttackPosition_NextT < CurTime() and self.FlankAttackPosition_thinking != 1 and self.FlankAttackPosition_activated != 1 and self.vACT_StopAttacks == false and self.MovementType == VJ_MOVETYPE_GROUND and IsValid(self:GetEnemy()) and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.CanBeInterrupted == true) ) then
	self.FlankAttackPosition_NextT = CurTime() + self.FlankAttackPosition_Nexttime
	
	if math.random(1,10) >= self.FlankAttackPosition_chance and self:GetPos():DistToSqr(self:GetEnemy():GetPos()) <= 3000*3000 and (self:GetEnemy():GetForward():Dot((self:GetPos() -self:GetEnemy():GetPos()):GetNormalized()) > math.cos(math.rad(80))) then
		local incoverfromenemy = 0
		
		local traca2 = util.TraceLine({
						start = self:EyePos(),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
				
		if (traca2.HitWorld != true and ( self:GetEnemy():EyePos():DistToSqr(traca2.HitPos) <= 24*24 or (traca2.Entity != nil and traca2.Entity != NULL and traca2.Entity == self:GetEnemy() ) )) then
		local tracs1 = util.TraceLine({
						start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
		if (tracs1.HitWorld == true or (tracs1.Entity != nil and tracs1.Entity != NULL and (tracs1.Entity:GetClass() == "prop_physics" or tracs1.Entity:GetClass() == "prop_dynamic" ) )) then 
				incoverfromenemy = 1
		end
		end
		
		if incoverfromenemy == 0 then
		
		self.FlankAttackPosition_thinking = 1
		local attackspottbl = {self:GetEnemy():GetForward()*math.random(0,100) +self:GetEnemy():GetRight()*math.random(-100,100),
			self:GetEnemy():GetForward()*math.random(-100,100) +self:GetEnemy():GetRight()*math.random(-100,100),
			self:GetEnemy():GetForward()*math.random(-100,100) +self:GetEnemy():GetRight()*math.random(-120,120),
			self:GetEnemy():GetForward()*math.random(-120,0) +self:GetEnemy():GetRight()*math.random(-150,150),
			self:GetEnemy():GetForward()*math.random(-120,0) +self:GetEnemy():GetRight()*math.random(-50,50)}
		local chosenpos = Vector(0,0,0)
		local sutiableattackpos = {}
		local actualattackpos = Vector(0,0,0)
		local tracss = {}
		local tracssdata = {}
		local tracsscx = {}
		--local enemydirection = Vector(0,0,0)
		local enemyeyepos = self:GetEnemy():EyePos()
		local postocheck = Vector(0,0,0)
		--local timeaddition = 0
		local isenemyunreachable = false
		if self:IsUnreachable(self:GetEnemy()) == true and self:GetEnemy():GetPos().z > self:GetPos().z then
			isenemyunreachable = true
		end
		
			for k,vapos in ipairs(attackspottbl) do
			if chosenpos == Vector(0,0,0) or table.Count( sutiableattackpos ) <= 5 then
			--print("ni99a")
				tracssdata = {
						start = enemyeyepos,
						endpos = enemyeyepos +vapos:GetNormalized()*math.random(self.FlankAttackPosition_minrrange,self.FlankAttackPosition_maxrange),
						filter = {self,self:GetActiveWeapon(),self:GetEnemy()}
						}
				if self:GetEnemy():GetActiveWeapon() != NULL and self:GetEnemy():GetActiveWeapon() != nil then tracssdata.filter = {self,self:GetActiveWeapon(),self:GetEnemy(),self:GetEnemy():GetActiveWeapon()} end
				tracss = util.TraceLine(tracssdata)
				
				if math.random(1,10) > 5 or tracss.HitWorld == true or (tracss.Entity != nil and tracss.Entity != NULL and (tracss.Entity:GetClass() == "prop_physics" or tracss.Entity:GetClass() == "prop_dynamic" ) ) then 
				if tracss.HitPos:DistToSqr(self:GetEnemy():GetPos()) > self.FlankAttackPosition_minrange*self.FlankAttackPosition_minrange then
				
				--table.insert( sutiableattackpos, pointa:GetPos() )
				--table.insert( sutiableattackpos, tracss.HitPos+Vector(0,0,-15) )
				postocheck = tracss.HitPos+Vector(0,0,-10)
				if isenemyunreachable == true then
				tracsscx = util.TraceLine({
						start = postocheck,
						endpos = postocheck+Vector(0,0,-800),
						filter = {self,self:GetActiveWeapon()}
						})
				if tracsscx.HitWorld == true then postocheck = tracsscx.HitPos +Vector(0,0,20) end
				end
				local pointa = ents.Create("prop_dynamic")
				pointa:SetModel("models/vj_weapons/w_grenade.mdl")
				pointa:SetPos(postocheck)
				pointa:SetAngles( Angle(0,0,0) )
				pointa:Spawn()
				pointa:SetNoDraw( true ) 
				self:DeleteOnRemove(pointa)
				local physaa = pointa:GetPhysicsObject()
				if (physaa:IsValid()) then
					physaa:EnableCollisions(false)
				end
				timer.Simple(0.3,function()
				if IsValid(self) and IsValid(pointa) then
					pointa:Remove()
					--self.FlankAttackPosition_thinking = 0
				end
				end)
			
				timer.Simple(0.15,function()
				if IsValid(self) and IsValid(pointa) then
				--pointa:SetPos(tracss.HitPos+Vector(0,0,-10))
				if self:IsUnreachable(pointa) == false and IsValid(self:GetEnemy()) then
				table.insert( sutiableattackpos, pointa:GetPos() )
				--if math.abs( self.NextChaseTime - CurTime() ) < 4 then
				--	self.NextChaseTime = CurTime() + 5
				--end
				end
				end
				end)
				


				end
				end
				
			end
			end
			
			
				timer.Simple(0.3,function()
				if IsValid(self) then
				if self.FlankAttackPosition_thinking == 1 and self.FlankAttackPosition_activated != 1 and self.vACT_StopAttacks == false and self.MovementType == VJ_MOVETYPE_GROUND and IsValid(self:GetEnemy()) and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.CanBeInterrupted == true) ) then
	
					for ku,useablepos in pairs(sutiableattackpos) do
					if useablepos != nil and useablepos != NULL and chosenpos == Vector(0,0,0) then
					if (self:GetEnemy():GetForward():Dot((useablepos -self:GetEnemy():GetPos()):GetNormalized()) <= math.cos(math.rad(135))) then 
						--chosenspot = actualcoverpos
						--isclosestone = 0
						chosenpos = useablepos
					end
					end
					end
					if chosenpos == Vector(0,0,0) then
						for ku,useablepos in pairs(sutiableattackpos) do
						if useablepos != nil and useablepos != NULL and chosenpos == Vector(0,0,0) then
						if (self:GetEnemy():GetForward():Dot((useablepos -self:GetEnemy():GetPos()):GetNormalized()) <= math.cos(math.rad(80))) then 
							chosenpos = useablepos
						end
						end
						end
					end
					if chosenpos == Vector(0,0,0) then
						for ku,useablepos in pairs(sutiableattackpos) do
						if useablepos != nil and useablepos != NULL and chosenpos == Vector(0,0,0) then
						if (self:GetEnemy():GetForward():Dot((useablepos -self:GetEnemy():GetPos()):GetNormalized()) <= math.cos(math.rad(60))) then 
							chosenpos = useablepos
						end
						end
						end
					end
					
					if chosenpos != Vector(0,0,0) then
										
					self:SetLastPosition(chosenpos)
					self.CurrentCoveringPosition = chosenpos
					self:StopMoving()
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.IsFlankAttacking = true x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 1
					self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime*1.3
					self.LookForCover_NextT = CurTime() + self.LookForCover_Var.Nexttime*1.0
					self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*2.5
					self.NextChaseTime = CurTime() + 5
					self.NextIdleTime = CurTime() + 5
					self.FlankAttackPosition_activated = 1
					
					self.FlankAttackPosition_ResetNextT = CurTime() + 15
					self.FlankAttackPosition_StopNextT = CurTime() + 3
					
					--print("danigdone")
					timer.Simple(9,function()
					if IsValid(self) then
					if self.FlankAttackPosition_activated == 1 then self.FlankAttackPosition_activated = 0 end
					end
					end)
					
					end
				self.FlankAttackPosition_thinking = 0
					
				end
				end
				end)
			
		end
	
	end
	
	end
	end
	
	
	if self.CanTargetExposedEnemy == true then
	if self.TargetExposedEnemy_NextT < CurTime() then
	self.TargetExposedEnemy_NextT = CurTime() + self.TargetExposedEnemy_Nexttime
	
	if IsValid(self:GetEnemy()) and math.random(1,10) >= self.TargetExposedEnemy_chance then
	if self:GetPos():DistToSqr(self:GetEnemy():GetPos()) < 2500*2500 and self.LastSeenEnemyTime < 0.5 then
	
		local tracs112 = util.TraceLine({
						start = self:EyePos()+self:GetUp()*-5,
						endpos = self:GetEnemy():NearestPoint(self:GetEnemy():GetPos() +self:GetEnemy():OBBCenter())+self:GetEnemy():GetUp()*8, --self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
		if (tracs112.HitWorld == true or (tracs112.Entity != nil and tracs112.Entity != NULL and (tracs112.Entity:GetClass() == "prop_physics" or tracs112.Entity:GetClass() == "prop_dynamic" ) )) then 
				--incoverfromenemy = 1
				self.TargetExposedEnemy_NextT = CurTime() + self.TargetExposedEnemy_cooldown
				local foundenemyents = 0
				local thesoldierlist = ents.FindInSphere(self:GetEnemy():GetPos(),self.TargetExposedEnemy_range)
				if thesoldierlist != nil then		
					for kc,vcca in ipairs(thesoldierlist) do
					if foundenemyents == 0 then
					if !vcca:IsNPC() and !vcca:IsPlayer() then continue end
					if IsValid(vcca) and vcca:EntIndex() != self:EntIndex() && vcca:Health() > 0 && (vcca.IsVJBaseSNPC == true && vcca.Dead != true) then
					if self:DoRelationshipCheck(vcca) == true then
						local trase221 = util.TraceLine({
						start = self:EyePos()+self:GetUp()*-5,
						endpos = vcca:NearestPoint(vcca:GetPos() +vcca:OBBCenter())+vcca:GetUp()*-10, --self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
						--foundenemyents = 1
						if (trase221.HitWorld != true and ( (trase221.Entity != nil and trase221.Entity != NULL and trase221.Entity == vcca ) ) ) then 
							foundenemyents = vcca
						end
					end
					end
					end
					end
				end
				if foundenemyents != 0 and IsValid(foundenemyents) then
					self:VJ_DoSetEnemy(foundenemyents,false)
				end
				
		end
	
	
	end
	end
	
	end
	end
	
	
	
	
	if self.CanRegroupWhenHurt == true then
		
		if self.RegroupWhenHurt_start == 1 and self.RegroupWhenHurt_NextT2 < CurTime() then
			self.RegroupWhenHurt_start = 0
		end
		if self.RegroupWhenHurt_NextT < CurTime() and self.vACT_StopAttacks == false then
		self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_Nexttime
		
		if self.RegroupWhenHurt_activated == 1 then
			if self.CurrentSchedule != nil and self.CurrentSchedule.isRegrouping != nil and self.CurrentSchedule.isRegrouping == true then
				if self:GetPos():DistToSqr(self.CurrentCoveringPosition) <= self.RegroupWhenHurt_RangeDone*self.RegroupWhenHurt_RangeDone then
				self.RegroupWhenHurt_activated = 0
				self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_cooldown
				self:ClearSchedule()
				self:StopMoving()
				self:DoIdleAnimation()
				end
			end
			if self.CurrentSchedule == nil then
				self.RegroupWhenHurt_activated = 0
			end
			if self.RegroupWhenHurt_durationT < CurTime() then
				self.RegroupWhenHurt_activated = 0
				self.RegroupWhenHurt_NextT = CurTime() + self.RegroupWhenHurt_cooldown
				if self.CurrentSchedule != nil and self.CurrentSchedule.isRegrouping != nil and self.CurrentSchedule.isRegrouping == true then
					self:ClearSchedule()
					self:StopMoving()
					self:DoIdleAnimation()
				end
			end
			
		end
		
		if self.RegroupWhenHurt_start == 1 and self.RegroupWhenHurt_activated == 0 and (self.CurrentSchedule == nil or (self.CurrentSchedule != nil and self.CurrentSchedule.CanBeInterrupted == true) ) and self.MovementType == VJ_MOVETYPE_GROUND then
		if !IsValid(self:GetEnemy()) or ( self.LastSeenEnemyTime > 2.0 ) then
		
		local foundtargetally = 0
		local foundtargetally_dist = 0
		local foundtargetallynear = 0
		local stopswitching = 0
		local allysoldierlist = ents.FindInSphere(self:GetPos(),self.RegroupWhenHurt_Range)
		
			for kc,vc in ipairs(allysoldierlist) do
			if foundtargetallynear == 0 then
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) and vc:GetActiveWeapon() != NULL and vc:GetActiveWeapon() != nil then
			if self:DoRelationshipCheck(vc) == false and (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) and vc.vACT_StopAttacks == false and vc.Weapon_ShotsSinceLastReload < vc.Weapon_StartingAmmoAmount then
			
			if foundtargetally == 0	then 
			foundtargetally = vc 
			foundtargetally_dist = self:GetPos():DistToSqr(vc:GetPos())
			else
				if math.random(1,10) >= 4 and stopswitching == 0 then
				if self:GetPos():DistToSqr(vc:GetPos()) > foundtargetally_dist then
					foundtargetally = vc 
					foundtargetally_dist = self:GetPos():DistToSqr(vc:GetPos())
				end
				else
					stopswitching = 1
				end
			end
				if foundtargetally_dist <= self.RegroupWhenHurt_RangeDone*self.RegroupWhenHurt_RangeDone then foundtargetallynear = 1 end
			
			end
			end
			end
			end
			
			if foundtargetally != 0 and foundtargetallynear == 0 and IsValid(foundtargetally) then
			self.RegroupWhenHurt_activated = 1
			self.RegroupWhenHurt_start = 0
			self.RegroupWhenHurt_durationT = CurTime() + self.RegroupWhenHurt_duration
			
					self:SetLastPosition(foundtargetally:GetPos())
					self.CurrentCoveringPosition = foundtargetally:GetPos()
					self:StopMoving()
					self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.isRegrouping = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 0.5
					self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime*1.8
					self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*3.2
					self.NextChaseTime = CurTime() + 6
					self.NextIdleTime = CurTime() + 6
			
			end
		
		end
		end
		
		end
		
	end
	
	if self.CanCoordinatedChasing == true then
	if self.CoordinatedChasing_NextT < CurTime() and self.CoordinatedChasing_activated == 0 and self.CoordinatedChasing_activatedbyothers == 0 and self.CurrentSchedule != nil and self.vACT_StopAttacks == false then
	if IsValid(self:GetEnemy()) and (self.CurrentSchedule.Name == "vj_chase_enemy" or self.CurrentSchedule.Name == "vj_flank_enemy" or (self.CurrentSchedule.Name == "vj_goto_lastpos" and self.LookForCover_activated == 1 and self.CurrentCoveringPosition != Vector(0,0,0)) ) then
		self.CoordinatedChasing_NextT = CurTime() + self.CoordinatedChasing_Nexttime
		local mode = "chase"
		
		if self.CurrentSchedule.Name == "vj_flank_enemy" then
			mode = "flank"
		end
		
		if self.CurrentSchedule.Name == "vj_goto_lastpos" and self.LookForCover_activated == 1 and self.CurrentCoveringPosition != Vector(0,0,0) then
			mode = "cover"
		end
		
			--local checkdist = {}
			local soldierlist = ents.FindInSphere(self:GetPos(),self.CoordinatedChasing_range)
			local hasallies = 0
			for kc,vc in ipairs(soldierlist) do
			if hasallies < self.CoordinatedChasing_maxsoldier then
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) and vc:GetActiveWeapon() != NULL and vc:GetActiveWeapon() != nil and vc.MovementType == VJ_MOVETYPE_GROUND then
			if self:DoRelationshipCheck(vc) == false and (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) and vc.CoordinatedChasing_activatedbyothers == 0 and vc.vACT_StopAttacks == false and vc.CurrentSchedule == nil and vc.Weapon_ShotsSinceLastReload < vc.Weapon_StartingAmmoAmount then
		
			if IsValid(vc:GetEnemy()) and vc:GetEnemy() != self:GetEnemy() then
			
				if vc.Weapon_TimeSinceLastShot > 2 and !vc:Visible(vc:GetEnemy()) then
					--vc.NextChaseTime = CurTime() + 0.5
					vc:VJ_DoSetEnemy(self:GetEnemy(),false)
					--vc:VJ_TASK_CHASE_ENEMY(false)
					hasallies = hasallies + 1
					if math.random(1,10) <= 3 then hasallies = hasallies + 1 end
					vc.CoordinatedChasing_activatedbyothers = 1
					timer.Simple(self.CoordinatedChasing_Nexttime/1.5,function()
					if IsValid(vc) then
					vc.CoordinatedChasing_activatedbyothers = 0
					end
					end)
					if mode == "chase" and math.random(1,10) > 3 then
						vc:VJ_TASK_CHASE_ENEMY(false)
					end
					if mode == "flank" then
					if vc:IsUnreachable(self) == false then
					--vc:VJ_TASK_CHASE_ENEMY(false)
								if math.abs( vc.NextChaseTime - CurTime() ) < 4 then
								vc.NextChaseTime = CurTime() + 5
								end
							vc.CurrentCoveringPosition = self.CurrentCoveringPosition
							vc:SetLastPosition( vc.CurrentCoveringPosition ) 
							vc:VJ_TASK_FLANK_ENEMY()
							vc.FlankEnemy_ResetNextT = CurTime() + 20
							vc.FlankEnemy_StopNextT = CurTime() + 5
							vc.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(vc.NextMoveRandomlyWhenShootingTime1,vc.NextMoveRandomlyWhenShootingTime2) + 0.5
					end
					end
					if mode == "cover" then
					if vc:IsUnreachable(self) == false then
					vc:SetLastPosition(self.CurrentCoveringPosition)
					vc.CurrentCoveringPosition = self.CurrentCoveringPosition
					vc:StopMoving()
					vc:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					vc.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(vc.NextMoveRandomlyWhenShootingTime1,vc.NextMoveRandomlyWhenShootingTime2) + 1
					vc.SmartAttackPos_NextT = CurTime() + vc.SmartAttackPos_Var.Nexttime*1.2
					vc.LookForCover_NextT = CurTime() + vc.LookForCover_Var.Nexttime*1.5
					vc.FlankEnemy_NextT = CurTime() + vc.FlankEnemy_Nexttime*1.5
					vc.NextChaseTime = CurTime() + 3
					vc.NextIdleTime = CurTime() + 3
					vc.LookForCover_activated = 1

						timer.Simple(3,function()
						if IsValid(vc) then
						if vc.LookForCover_activated == 1 then vc.LookForCover_activated = 0 end
						end
						end)
					end
					end
					
				end
				
			else
				if !vc:Visible(self:GetEnemy()) then
				if vc:GetEnemy() != self:GetEnemy() then
					vc:VJ_DoSetEnemy(self:GetEnemy(),false)
				end
					--vc.NextChaseTime = CurTime() + 0.5
					--vc:VJ_TASK_CHASE_ENEMY(false)
					hasallies = hasallies + 1
					if math.random(1,10) <= 3 then hasallies = hasallies + 1 end
					vc.CoordinatedChasing_activatedbyothers = 1
					timer.Simple(self.CoordinatedChasing_Nexttime/1.4,function()
					if IsValid(vc) then
					vc.CoordinatedChasing_activatedbyothers = 0
					end
					end)
					
					if mode == "chase" and math.random(1,10) > 3 then
						vc:VJ_TASK_CHASE_ENEMY(false)
					end
					if mode == "flank" then
					if vc:IsUnreachable(self) == false then
					--vc:VJ_TASK_CHASE_ENEMY(false)
								if math.abs( vc.NextChaseTime - CurTime() ) < 4 then
								vc.NextChaseTime = CurTime() + 5
								end
							vc.CurrentCoveringPosition = self.CurrentCoveringPosition
							vc:SetLastPosition( vc.CurrentCoveringPosition ) 
							vc:VJ_TASK_FLANK_ENEMY()
							vc.FlankEnemy_ResetNextT = CurTime() + 20
							vc.FlankEnemy_StopNextT = CurTime() + 5
							vc.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(vc.NextMoveRandomlyWhenShootingTime1,vc.NextMoveRandomlyWhenShootingTime2) + 0.5
					end
					end
					if mode == "cover" then
					if vc:IsUnreachable(self) == false then
					vc:SetLastPosition(self.CurrentCoveringPosition)
					vc.CurrentCoveringPosition = self.CurrentCoveringPosition
					vc:StopMoving()
					vc:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true x.RunCode_OnFail = function() self:CustomOnMovingPathFailed() end end)
					vc.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(vc.NextMoveRandomlyWhenShootingTime1,vc.NextMoveRandomlyWhenShootingTime2) + 1
					vc.SmartAttackPos_NextT = CurTime() + vc.SmartAttackPos_Var.Nexttime*1.2
					vc.LookForCover_NextT = CurTime() + vc.LookForCover_Var.Nexttime*1.5
					vc.FlankEnemy_NextT = CurTime() + vc.FlankEnemy_Nexttime*1.5
					vc.NextChaseTime = CurTime() + 3
					vc.NextIdleTime = CurTime() + 3
					vc.LookForCover_activated = 1

						timer.Simple(3,function()
						if IsValid(vc) then
						if vc.LookForCover_activated == 1 then vc.LookForCover_activated = 0 end
						end
						end)
					end
					end
					
				end
			end
				
			end
			end
			end
			end
			
			if hasallies > 0 then
				self.CoordinatedChasing_activated = 1
				timer.Simple(self.CoordinatedChasing_Nexttime/1.4,function()
				if IsValid(self) then
				self.CoordinatedChasing_activated = 0
				end
				end)
			end
			
	end
	end
	end
	
	if self.CanRunOnResetEnemy == true then
	if self.RunOnResetEnemy_NextT < CurTime() then
	self.RunOnResetEnemy_NextT = CurTime() + self.RunOnResetEnemy_Nexttime
	
	if self.CurrentSchedule != nil and self.Alerted == false and !IsValid(self:GetEnemy()) then
	if self.CurrentSchedule.Name == "vj_act_resetenemy" and self.CurrentSchedule.IsMovingTask_Walk == true and self.CurrentSchedule.IsMovingTask_Run != true then
		self:VJ_ACT_RESETENEMY_RUN()
		self.RunOnResetEnemy_NextT = CurTime() + self.RunOnResetEnemy_cooldown
	end
	end
	
	end
	end
	
	if self.CanSmartAiming == true and self.AimCorrect_NextT > CurTime() and self.vACT_StopAttacks == false and self.Weapon_StartingAmmoAmount != nil and self:GetActiveWeapon() != NULL and self:GetActiveWeapon() != nil and (self:VJ_HasActiveWeapon() != false) and self.CurrentSchedule == nil then 
	if self.SmartAiming_timer == 0 and CurTime() > self.LastHiddenZoneT and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self.FlankEnemy_activated == 0 and self:GetEnemy() != nil and math.random(1,self.SmartAiming_chance) == 1 and self.Weapon_TimeSinceLastShot < 2 and self.DoingWeaponAttack_Standing == true and self.SmartAiming_activated == 0 then
	self.SmartAiming_timer = 1
			local tras = util.TraceLine({
						start = self:NearestPoint(self:GetPos() +self:OBBCenter()),
						endpos = self:GetEnemy():EyePos(),
						filter = {self,self:GetActiveWeapon()}
						})
	if tras.HitWorld == false and tras.Entity != nil and tras.Entity != NULL and tras.Entity == self:GetEnemy() then
	local bulletpos = self:GetActiveWeapon():GetAttachment(self:GetActiveWeapon():LookupAttachment("muzzle_flash")).Pos
	if self:GetActiveWeapon().IsVJBaseWeapon == true then bulletpos = self:GetActiveWeapon():GetNWVector("VJ_CurBulletPos") end
	local enemypos = self:GetEnemy():EyePos() + Vector(0,0,-3)
		local hitent = false
		local allycharging = false
		local allychargecount = 0
		local SmartAiming_allylimit = self.SmartAiming_allychargelimit
		local tr = util.TraceLine({
		start = bulletpos,
		endpos = enemypos,
		filter = {self,self:GetActiveWeapon()}
		})
		for k,v in ipairs(ents.FindInSphere(tr.HitPos,5)) do
		if !v:IsNPC() && v != self && v:GetClass() == "prop_dynamic" && v:GetClass() == "prop_physics" then
				hitent = true
		end
		end
		
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),600)) do
		if v:IsNPC() && v != self && v.VJ_NPC_Class != nil && v.SmartAiming_activated != nil then
		
		if VJ_PICKRANDOMTABLE(v.VJ_NPC_Class) == VJ_PICKRANDOMTABLE(self.VJ_NPC_Class) and v.SmartAiming_activated == 1 then
		allychargecount = allychargecount + 1
		if SmartAiming_allylimit <= allychargecount then
				allycharging = true
		end
		
		end
		end
		end
	
	
	if (tr.HitWorld or hitent == true) and allycharging == false and !self:IsUnreachable(self:GetEnemy()) then
	
	self.SmartAiming_activated = 1
	self.SmartAiming_originalshootrange = self.Weapon_FiringDistanceFar
	--self.Weapon_FiringDistanceFar = 550
	self:VJ_TASK_CHASE_ENEMY(false)
		timer.Simple(self.SmartAiming_attacktime,function()
		if IsValid(self) then
		if self.SmartAiming_activated == 1 then
		self.SmartAiming_activated = 0
		self.Weapon_FiringDistanceFar = self.SmartAiming_originalshootrange
		if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_chase_enemy" then self:ClearSchedule() end
			timer.Simple(self.SmartAiming_attacktime,function()
			if IsValid(self) then
			if self.CurrentSchedule == nil then
				self:SelectSchedule()
			end
			end
			end)
		end
		end
		end)
	
	
	end
	
	end
		timer.Simple(self.SmartAiming_timersec,function()
		if IsValid(self) then
		self.SmartAiming_timer = 0
		end
		end)
	
	
	end
	end
	
	if self.CanDoSmartGrenadeThrow == true and self.HasGrenadeAttack == true then
	
	if self.SmartGrenadeThrow_timer == 0 and self:GetEnemy() != nil then
	self.SmartGrenadeThrow_timer = 1
	
			if self.HasGrenadeAttack == true && CurTime() > self.NextThrowSmartGrenadeT && (self.SmartGrenadeThrow_enemyvisible_previously != 0 or self.CanThrowBlindGrenade == true ) && self.vACT_StopAttacks == false && self.ThrowingGrenade != true && math.random(1,self.SmartGrenadeThrow_chance) == 1 && self.IsReloadingWeapon == false && CurTime() > self.TakingCoverT && (self:VJ_ForwardIsHidingZone(self:EyePos(),self:GetEnemy():EyePos(),true) != false)  then
				local isbeingcontrolled = false
				local isbeingcontrolled_attack = false
				if self.VJ_IsBeingControlled == true then isbeingcontrolled = true end
					
					local trc = util.TraceLine({
					start = self:EyePos(),
					endpos = self.SmartGrenadeThrow_enemyvisible_lastposition,
					filter = self
					})
				if (trc.HitWorld != true and ( trc.Entity == nil or trc.Entity == NULL or (self:GetActiveWeapon() != NULL and trc.Entity == self:GetActiveWeapon()) ) and self.SmartGrenadeThrow_enemyvisible_lastposition:DistToSqr(trc.HitPos) <= 20*20) or self.CanThrowBlindGrenade == true then
				--local checkdist = self:VJ_CheckAllFourSides(150)
				
				if CurTime() > self.NextThrowSmartGrenadeT then
					local chancevar = self.ThrowSmartGrenadeChance
					local grenchance = math.random(1,chancevar)
					if grenchance == 1 then
						local EnemyDistance = self:GetPos():DistToSqr(self:GetEnemy():GetPos()) --self:GetPos():Distance(self:GetEnemy():GetPos())
						if (isbeingcontrolled_attack == true) or (EnemyDistance < self.GrenadeAttackThrowDistance*self.GrenadeAttackThrowDistance && EnemyDistance > self.GrenadeAttackThrowDistanceClose*self.GrenadeAttackThrowDistanceClose) then
							self:ThrowGrenadeCode()
							self.NextThrowSmartGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2)
							self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2)
						end
					end
				end
				end
			end
	
	
		timer.Simple(self.SmartGrenadeThrow_timersec,function()
		if IsValid(self) then
		self.SmartGrenadeThrow_timer = 0
		end
		end)
		
	end
	

	

	
	end
	
	if self.CanRememberEnemyPosition == true then
	
	if self.SmartGrenadeThrow_enemyvisibletimer == 0 then
	self.SmartGrenadeThrow_enemyvisibletimer = 1
	
	if CurTime() > self.SmartGrenadeThrow_enemyvisible_NextT then
		self.SmartGrenadeThrow_enemyvisible_previously = 0
	end
	if self:GetEnemy() != nil then
	if (self:GetEnemy() != nil) and (self:VJ_ForwardIsHidingZone(self:EyePos(),self:GetEnemy():EyePos(),true) == false) then
		self.SmartGrenadeThrow_enemyvisible_previously = 1
		self.SmartGrenadeThrow_enemyvisible_NextT = CurTime() + self.SmartGrenadeThrow_enemyvisible_Next

		self.SmartGrenadeThrow_enemyvisible_lastposition = self:GetEnemy():GetPos() + self:GetEnemy():GetUp()*75
		self.SmartGrenadeThrow_enemyvisibleshared = 0
		
		--print("enemy last visible")
		if self.SmartGrenadeThrow_enemyvisibleshare_NextT < CurTime() then
		self.SmartGrenadeThrow_enemyvisibleshare_NextT = CurTime() + self.SmartGrenadeThrow_enemyvisibleshare_Next
		if self.SmartGrenadeThrow_enemyvisibleshare_NextT != 0 then 
		
			for kc,vc in ipairs(ents.FindInSphere(self:GetPos(),900)) do
			if !vc:IsNPC() then continue end
			if vc:EntIndex() != self:EntIndex() && (!vc.IsVJBaseSNPC_Tank) && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) then
			if self:DoRelationshipCheck(vc) == false and (vc.vj_doi_isteam != nil and vc.vj_doi_isteam == self.vj_doi_isteam) and vc.SmartGrenadeThrow_enemyvisible_lastposition != nil and vc.SmartGrenadeThrow_enemyvisible_previously != nil then
			if vc.SmartGrenadeThrow_enemyvisible_previously == 0 then --and (vc:VJ_ForwardIsHidingZone(vc:EyePos(),self.SmartGrenadeThrow_enemyvisible_lastposition,true) == false) then
			vc.SmartGrenadeThrow_enemyvisible_lastposition = self.SmartGrenadeThrow_enemyvisible_lastposition + Vector(0,0,40)
			vc.SmartGrenadeThrow_enemyvisible_previously = 1
			vc.SmartGrenadeThrow_enemyvisibleshared = 1
			end
			end
			end
			end
		
		end
		end
	end
	end
		timer.Simple(1.2,function()
		if IsValid(self) then
		self.SmartGrenadeThrow_enemyvisibletimer = 0
		end
		end)
	
	end
	
	end
	
	if self.Reloadwhenidle == true then
	if self.Reloadwhenidle_timer == 0 and self:GetEnemy() == nil and self.vACT_StopAttacks == false and self:VJ_HasActiveWeapon() == true and self.Weapon_StartingAmmoAmount != nil then
	self.Reloadwhenidle_timer = 1
	
	if math.random(1,self.Reloadwhenidle_chance) == 1 and self.Reloadwhenidle_activated != 1 and self.Weapon_ShotsSinceLastReload >= self.Weapon_StartingAmmoAmount*0.6 then
	
				self.Reloadwhenidle_activated = 1
					self.DoingWeaponAttack = false
					self.DoingWeaponAttack_Standing = false
					self.IsReloadingWeapon_ServerNextFire = false
					if self.VJ_IsBeingControlled == false then self.IsReloadingWeapon = true end
					self.NextChaseTime = CurTime() + 2
					self:WeaponReloadSoundCode()
					self:CustomOnWeaponReload()
					if self.DisableWeaponReloadAnimation == false then
						local function DoReloadAnimation(animtbl)
							self.CurrentAnim_WeaponReload = VJ_PICKRANDOMTABLE(animtbl)
							local translateact = self:VJ_TranslateWeaponActivity(self.CurrentAnim_WeaponReload)
							if VJ_AnimationExists(self,translateact) == true then
								self.CurrentAnim_WeaponReload = translateact
							end
							self.CurrentAnimDuration_WeaponReload = VJ_GetSequenceDuration(self,self.CurrentAnim_WeaponReload) - self.WeaponReloadAnimationDecreaseLengthAmount
							timer.Simple(self.CurrentAnimDuration_WeaponReload,function() if IsValid(self) then 
							self.IsReloadingWeapon = false 
							self.Weapon_ShotsSinceLastReload = 0 
							self.Reloadwhenidle_activated = 0
							end end)
							self:VJ_ACT_PLAYACTIVITY(self.CurrentAnim_WeaponReload,true,self.CurrentAnimDuration_WeaponReload,self.WeaponReloadAnimationFaceEnemy,self.WeaponReloadAnimationDelay,{SequenceDuration=self.CurrentAnimDuration_WeaponReload})
						end

						--self.IsReloadingWeapon = true
						DoReloadAnimation(self.AnimTbl_WeaponReload)

					else
						self.Weapon_ShotsSinceLastReload = 0
						self.IsReloadingWeapon = false
					end
	
	end
	
		timer.Simple(self.Reloadwhenidle_timersec,function()
		if IsValid(self) then
		self.Reloadwhenidle_timer = 0
		end
		end)
	
	end
	end
	
	if self.Reloadwhenattacking == true then
	if self.Reloadwhenattacking_NextT < CurTime() and self:GetEnemy() != nil and self.vACT_StopAttacks == false and self:VJ_HasActiveWeapon() == true and self.Weapon_StartingAmmoAmount != nil then
	self.Reloadwhenattacking_NextT = CurTime() + self.Reloadwhenattacking_Nexttime
	
	if self:IsMoving() == false and math.random(1,10) >= self.Reloadwhenattacking_chance and self.SmartGrenadeThrow_enemyvisible_lastposition != Vector(0,0,0) and self.LastSeenEnemyTime > 2 and self.Reloadwhenidle_activated != 1 and self.Weapon_ShotsSinceLastReload >= self.Weapon_StartingAmmoAmount*0.35 then
		local foundents = 0
		local soldierlist = ents.FindInSphere(self.SmartGrenadeThrow_enemyvisible_lastposition,160)
		if soldierlist != nil then		
			for kc,vc in ipairs(soldierlist) do
			if foundents == 0 then
			if !vc:IsNPC() and !vc:IsPlayer() then continue end
			if vc:EntIndex() != self:EntIndex() && vc:Health() > 0 && (vc.IsVJBaseSNPC == true && vc.Dead != true) then
			if self:DoRelationshipCheck(vc) == true then
				foundents = 1
			end
			end
			end
			end
		end
			
			if foundents == 0 then
					self.Reloadwhenattacking_NextT = CurTime() + self.Reloadwhenattacking_Nexttime*2
					self.DoingWeaponAttack = false
					self.DoingWeaponAttack_Standing = false
					self.IsReloadingWeapon_ServerNextFire = false
					if self.VJ_IsBeingControlled == false then self.IsReloadingWeapon = true end
					self.NextChaseTime = CurTime() + 2
					self:WeaponReloadSoundCode()
					self:CustomOnWeaponReload()
					if self.DisableWeaponReloadAnimation == false then
						local function DoReloadAnimation(animtbl)
							self.CurrentAnim_WeaponReload = VJ_PICKRANDOMTABLE(animtbl)
							local translateact = self:VJ_TranslateWeaponActivity(self.CurrentAnim_WeaponReload)
							if VJ_AnimationExists(self,translateact) == true then
								self.CurrentAnim_WeaponReload = translateact
							end
							self.CurrentAnimDuration_WeaponReload = VJ_GetSequenceDuration(self,self.CurrentAnim_WeaponReload) - self.WeaponReloadAnimationDecreaseLengthAmount
							timer.Simple(self.CurrentAnimDuration_WeaponReload,function() if IsValid(self) then 
							self.IsReloadingWeapon = false 
							self.Weapon_ShotsSinceLastReload = 0 
							self.Reloadwhenidle_activated = 0
							end end)
							self:VJ_ACT_PLAYACTIVITY(self.CurrentAnim_WeaponReload,true,self.CurrentAnimDuration_WeaponReload,self.WeaponReloadAnimationFaceEnemy,self.WeaponReloadAnimationDelay,{SequenceDuration=self.CurrentAnimDuration_WeaponReload})
						end

						--self.IsReloadingWeapon = true
						DoReloadAnimation(self.AnimTbl_WeaponReload)

					else
						self.Weapon_ShotsSinceLastReload = 0
						self.IsReloadingWeapon = false
					end
			end
	end
	
	end
	end
	
	if self.CanUseSecondaryweapon == true then
	
	if self.IsReloadingWeapon == true and self.Reloadwhenidle_activated != 1 then
	if self.Secondaryweapon_timer == 0 then
	self.Secondaryweapon_timer = 1
	local EnemyDist = 0
	if self:GetEnemy() != nil then
		EnemyDist = self:GetPos():DistToSqr( self:GetEnemy():GetPos() )
	end
	
	if math.random(1,self.Secondaryweapon_switchchance) == 1 and self.Secondaryweapon_Switchingmyweapon == 0 and self.isMeleeCharging != 1 and EnemyDist > 60*60 and EnemyDist <= self.Secondaryweapon_Range*self.Secondaryweapon_Range and ( self:GetEnemy() == nil or self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos(),false,{SetLastHiddenTime=true}) != true) and self:Visible(self:GetEnemy()) then
	
	if self.Secondaryweapon_Usingsecondaryweapon == 0 then
	
		if (self:GetActiveWeapon() != nil) and self:GetActiveWeapon() != NULL then self.Secondaryweapon_originalclass = self:GetActiveWeapon():GetClass() end
		self.Secondaryweapon_Usingsecondaryweapon = 1
		self.Secondaryweapon_Switchingmyweapon = 1
		self.Weapon_ShotsSinceLastReload = 0
		self.IsReloadingWeapon = true
		self:ClearSchedule()
		self:VJ_TASK_IDLE_STAND()

		timer.Simple(0.1,function()
		if IsValid(self) then
		
		self:VJ_ACT_PLAYACTIVITY(self.Secondaryweapon_switchanimation,true,0.65,false,0,{SequenceDuration=0.65,PlayBackRate=1.5})
	
		timer.Simple(self.Secondaryweapon_switchtime_primary,function()
		if IsValid(self) then
		if (self:GetActiveWeapon() != nil) and self:GetActiveWeapon() != NULL then self:GetActiveWeapon():Remove() end
		end
		end)

		timer.Simple(self.Secondaryweapon_switchtime_secondary,function()
		if IsValid(self) then
			self:Give(self.Secondaryweapon_class)
			self.Weapon_ShotsSinceLastReload = 0
			--self.IsReloadingWeapon = false
			self.Secondaryweapon_Switchingmyweapon = 0
			self:ClearSchedule()
			self:SelectSchedule()
				timer.Simple(0.2,function()
				if IsValid(self) then
					self.IsReloadingWeapon = false
				end
				end)
		end
		end)
		
		timer.Simple(0.65,function()
		if IsValid(self) then
				self:ClearSchedule()
				self:VJ_TASK_IDLE_STAND()
		end
		end)
		
		end
		end)
	else
	
		self.Secondaryweapon_Usingsecondaryweapon = 0
		self.Secondaryweapon_Switchingmyweapon = 1
		self:ClearSchedule() 
		self:VJ_TASK_IDLE_STAND()
		self.IsReloadingWeapon = true

		timer.Simple(0.1,function()
		if IsValid(self) then
		
		self:VJ_ACT_PLAYACTIVITY(self.Secondaryweapon_switchanimation2,true,0.8,false,0,{SequenceDuration=0.8,PlayBackRate=1.4})
	
		timer.Simple(self.Secondaryweapon_switchtime_primary,function()
		if IsValid(self) then
		if self:GetActiveWeapon() != nil and self:GetActiveWeapon() != NULL then self:GetActiveWeapon():Remove() end
		end
		end)

		timer.Simple(self.Secondaryweapon_switchtime_secondary,function()
		if IsValid(self) then
			self:Give(self.Secondaryweapon_originalclass)
			--self.Weapon_ShotsSinceLastReload = 1000
			self.Secondaryweapon_Switchingmyweapon = 0
		end
		end)
		
		timer.Simple(0.85,function()
		if IsValid(self) then
			self:VJ_TASK_IDLE_STAND()
			self.Weapon_ShotsSinceLastReload = 1000
			self.IsReloadingWeapon = false
		end
		end)
		
		end
		end)
		
	
	end
	
	end
	
		
		timer.Simple(self.Secondaryweapon_timersec,function()
		if IsValid(self) then
		self.Secondaryweapon_timer = 0
		end
		end)
	
	end
	end
	
	
	if self.Secondaryweapon_Usingsecondaryweapon == 1 and self.Secondaryweapon_Switchingmyweapon == 0 then
	if self.Secondaryweapon_timer2 == 0 then
	self.Secondaryweapon_timer2 = 1
	
	if (self.vACT_StopAttacks == false or self.IsReloadingWeapon == true) and (self:GetEnemy() == nil or self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos(),false,{SetLastHiddenTime=true}) == true or self.LastSeenEnemyTime > 5) then
	if math.random(1,self.Secondaryweapon_switchchance) == 1 and self.Secondaryweapon_Switchingmyweapon == 0 and self.isMeleeCharging != 1 then
	
		self.Secondaryweapon_Usingsecondaryweapon = 0
		self.Secondaryweapon_Switchingmyweapon = 1
		self:ClearSchedule()
		self:VJ_TASK_IDLE_STAND()
		self.IsReloadingWeapon = true

		timer.Simple(0.1,function()
		if IsValid(self) then
		
		self:VJ_ACT_PLAYACTIVITY(self.Secondaryweapon_switchanimation2,true,0.8,false,0,{SequenceDuration=0.8,PlayBackRate=1.4})
	
		timer.Simple(self.Secondaryweapon_switchtime_primary,function()
		if IsValid(self) then
		if (self:GetActiveWeapon() != nil) and self:GetActiveWeapon() != NULL then self:GetActiveWeapon():Remove() end
		end
		end)

		timer.Simple(self.Secondaryweapon_switchtime_secondary,function()
		if IsValid(self) then
			self:Give(self.Secondaryweapon_originalclass)
			--self.Weapon_ShotsSinceLastReload = 1000
			self.Secondaryweapon_Switchingmyweapon = 0
		end
		end)
		
		timer.Simple(0.85,function()
		if IsValid(self) then
			self.IsReloadingWeapon = false
			self:VJ_TASK_IDLE_STAND()
			self.Weapon_ShotsSinceLastReload = 1000
		end
		end)
	
		end	
		end)
	
	end
	end
	
		timer.Simple(self.Secondaryweapon_timer2sec,function()
		if IsValid(self) then
		self.Secondaryweapon_timer2 = 0
		end
		end)
		
	end
	end
	
	end
	
	
	if self.CanPerformMeleeCharge == true then
	
		if self.isMeleeCharging == 1 and self.MeleeCharge_Vel != Vector(0,0,0) then
			if self.MeleeCharge_hit == 0 then
				self:SetVelocity(self.MeleeCharge_Vel +self:GetForward()*math.Rand(self.MeleeCharge_forwardvel1,self.MeleeCharge_forwardvel2))
			else
				self:SetFriction( self.MeleeCharge_originalfriction ) 
				self:SetVelocity(self:GetVelocity()/2 )
			end
			self:MeleeChargeAttackCode()
		end
	
	
	
	if self.MeleeCharge_timer == 0 and IsValid(self:GetEnemy()) then
	self.MeleeCharge_timer = 1
	
	local EnemyDist = 0
	if self:GetEnemy() != nil then
		EnemyDist = self:GetPos():DistToSqr( self:GetEnemy():GetPos() )
	end
	
	if self.vACT_StopAttacks == false and self.MeleeCharge_timer2 == 0 and self.Weapon_StartingAmmoAmount != nil and self.Weapon_ShotsSinceLastReload < self.Weapon_StartingAmmoAmount and self.Secondaryweapon_Switchingmyweapon != 1 and self.isMeleeCharging != 1 and self:Visible(self:GetEnemy()) and self:CanDoCertainAttack("MeleeAttack") and self.IsReloadingWeapon == false and EnemyDist <= self.MeleeCharge_range*self.MeleeCharge_range and EnemyDist > 70*70 then
	
		local trace112tbl = {
						start = self:GetPos() +self:GetUp()*5,
						endpos = self:GetEnemy():GetPos() +self:GetEnemy():GetUp()*5,
						filter = {self,self:GetActiveWeapon()}
						}
		local trace112 = {}
		trace112 = util.TraceEntity(trace112tbl,self)
	
	if self:GetEnemy():GetPos():DistToSqr( trace112.HitPos ) < self.MeleeChargeAttackDamageDistance*self.MeleeChargeAttackDamageDistance then
		self.MeleeCharge_timer2 = 1

			--self:VJ_TASK_IDLE_STAND()
			local originalmove = self.MovementType
			self.MovementType = VJ_MOVETYPE_STATIONARY
			self.MeleeAttacking = true
			self.AlreadyDoneMeleeAttackFirstHit = false
			self.IsAbleToMeleeAttack = false
			self.AlreadyDoneFirstMeleeAttack = false
			self.AllowWeaponReloading = false
			self:MeleeChargeAttackSoundCode()
			self.NextAlertSoundT = CurTime() + 0.4
			self.NextWeaponAttackT = CurTime() + 1.0
			self.NextChaseTime = CurTime() + 1.2
			if self.DisableMeleeAttackAnimation == false then
						self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_MeleeChargeAttack)
						self.CurrentAttackAnimationDuration = VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -self.MeleeAttackAnimationDecreaseLengthAmount
						self.PlayingAttackAnimation = true
						timer.Simple(self.CurrentAttackAnimationDuration,function()
							if IsValid(self) then
								self.PlayingAttackAnimation = false
							end
						end)
						self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,true,1.0,false,self.MeleeAttackAnimationDelay,{SequenceDuration=self.CurrentAttackAnimationDuration})
			end
			local ChargePos = self:GetPos() + self:GetForward()*300
			if IsValid(self:GetEnemy()) then 
			ChargePos = self:GetEnemy():GetPos() 
			self:FaceCertainEntity(self:GetEnemy(),false)
			end
			local ChargeVel = ChargePos -self:GetPos() 
			local phys = self:GetPhysicsObject()
			--local originalfriction = self:GetFriction()
			self.MeleeCharge_originalfriction = self:GetFriction()
			ChargeVel = Vector(ChargeVel.x, ChargeVel.y, 0)
			self.MeleeCharge_Vel = ChargeVel:GetNormalized() 
			if (phys:IsValid()) then
				--phys:SetVelocity(ChargeVel +self:GetUp()*math.random(self.GrenadeAttackVelUp1,self.GrenadeAttackVelUp2) +self:GetForward()*math.Rand(self.GrenadeAttackVelForward1,self.GrenadeAttackVelForward2) +self:GetRight()*math.Rand(self.GrenadeAttackVelRight1,self.GrenadeAttackVelRight2))
			end
			timer.Simple(0.2,function()
			if IsValid(self) then
				self.isMeleeCharging = 1
				self:SetFriction( 0 ) 
				self:SetVelocity(self.MeleeCharge_Vel +self:GetUp()*math.random(self.MeleeCharge_upvel1,self.MeleeCharge_upvel1) +self:GetForward()*math.Rand(self.MeleeCharge_forwardvel1,self.MeleeCharge_forwardvel2))
				self.MeleeCharge_damagedentity = {}
				self.MeleeCharge_hit = 0
			end
			end)
			timer.Simple(0.6,function()
			if IsValid(self) then
				self:SetFriction( self.MeleeCharge_originalfriction ) 
				self.AllowWeaponReloading = true
				self.MovementType = originalmove
			if self.isMeleeCharging == 1 then
				self.isMeleeCharging = 0
				self.MeleeCharge_hit = 0
				self.MeleeCharge_damagedentity = {}
			end
			end
			end)
			--timer.Create( "timer_melee_start"..self:EntIndex(), self.TimeUntilMeleeChargeDamage, 1, function() self:MeleeChargeAttackCode() end)
	
		timer.Simple(self.MeleeCharge_timersec2,function()
		if IsValid(self) then
		self.MeleeCharge_timer2 = 0
		end
		end)
	
	end
	end
	
		timer.Simple(self.MeleeCharge_timersec,function()
		if IsValid(self) then
		self.MeleeCharge_timer = 0
		end
		end)
	
	end
	end
	
	
end

function ENT:MeleeChargeAttackCode()
	if self.Dead == true or self.Flinching == true or self.ThrowingGrenade == true then return end
	if self.StopMeleeAttackAfterFirstHit == true && self.AlreadyDoneMeleeAttackFirstHit == true then return end
	--if /*self.VJ_IsBeingControlled == false &&*/ self.MeleeAttackAnimationFaceEnemy == true then self:FaceCertainEntity(self:GetEnemy(),true) end
	//self.MeleeAttacking = true
	local FindEnts = ents.FindInSphere(self:GetPos() + self:GetForward(),self.MeleeChargeAttackDamageDistance)
	local hitentity = false
	local HasHitNonPropEnt = false
	
	if FindEnts != nil then
		for _,v in pairs(FindEnts) do
			if (self.VJ_IsBeingControlled == true && self.VJ_TheControllerBullseye == v) or (v:IsPlayer() && v.IsControlingNPC == true) then continue end
			if (v:IsNPC() || (v:IsPlayer() && v:Alive())) && (self:Disposition(v) != D_LI) && (v != self) && (v:GetClass() != self:GetClass()) or (v:GetClass() == "prop_physics") or v:GetClass() == "func_breakable_surf" or v:GetClass() == "func_breakable" then
				if (table.HasValue( self.MeleeCharge_damagedentity, v ) == false) and (self:GetForward():Dot((v:GetPos() -self:GetPos()):GetNormalized()) > math.cos(math.rad(self.MeleeChargeAttackDamageAngleRadius))) then
					local doactualdmg = DamageInfo()
					doactualdmg:SetDamage(self:VJ_GetDifficultyValue(self.MeleeCharge_dmg))
					if v:IsNPC() or v:IsPlayer() then doactualdmg:SetDamageForce(self:GetForward()*((doactualdmg:GetDamage()+100)*70)) end
					doactualdmg:SetInflictor(self)
					doactualdmg:SetAttacker(self)
					v:TakeDamageInfo(doactualdmg, self)
					v:SetVelocity(self:GetForward()*self.MeleeCharge_knockbackvel)
					if self.MeleeCharge_hit == 0 then
						self.MeleeCharge_hit = 1
					end
					table.insert( self.MeleeCharge_damagedentity, v )
				if v:IsPlayer() then
					v:ViewPunch(Angle(math.random(-1,1)*10,math.random(-1,1)*10,math.random(-1,1)*10))
				end
				VJ_DestroyCombineTurret(self,v)
				if v:GetClass() != "prop_physics" then HasHitNonPropEnt = true end
				if v:GetClass() == "prop_physics" && HasHitNonPropEnt == false then
					//if VJ_HasValue(self.EntitiesToDestoryModel,v:GetModel()) or VJ_HasValue(self.EntitiesToPushModel,v:GetModel()) then
					//hitentity = true else hitentity = false end
					hitentity = false
				else
					hitentity = true
					end
				end
			end
		end
	end
	if hitentity == true then
		self:MeleeAttackSoundCode()
		if self.StopMeleeAttackAfterFirstHit == true then self.AlreadyDoneMeleeAttackFirstHit = true /*self:StopMoving()*/ end
	else
		self:CustomOnMeleeAttack_Miss()
		self:MeleeAttackMissSoundCode()
	end
	if self.AlreadyDoneFirstMeleeAttack == false && self.TimeUntilMeleeAttackDamage != false then
		self:MeleeAttackCode_DoFinishTimers()
	end
	self.AlreadyDoneFirstMeleeAttack = true
end

function ENT:MeleeChargeAttackSoundCode(CustomTbl)
	if self.HasSounds == false or self.HasMeleeAttackSounds == false then return end
	local randomattacksound = math.random(1,1)
	local soundtbl = self.SoundTbl_MeleeChargeAttack
	if CustomTbl != nil && #CustomTbl != 0 then soundtbl = CustomTbl end
	if randomattacksound == 1 && VJ_PICKRANDOMTABLE(soundtbl) != false then
		VJ_STOPSOUND(self.CurrentIdleSound)
		self.NextIdleSoundT_RegularChange = CurTime() + 1
		self.CurrentBeforeMeleeAttackSound = VJ_CreateSound(self,soundtbl,self.BeforeMeleeAttackSoundLevel,self:VJ_DecideSoundPitch(self.BeforeMeleeAttackSoundPitch1,self.BeforeMeleeAttackSoundPitch2))
	end
end

function ENT:ThrowGrenadeCode(CustomEnt,NoOwner)
	if self.Dead == true or self.Flinching == true or self.MeleeAttacking == true or self:GetEnemy() == nil or (self.SmartGrenadeThrow_enemyvisible_previously == 0 and self.CanThrowBlindGrenade != true) or self.vACT_StopAttacks != false then return end
	//if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true then return end
	local NoOwner = NoOwner or false
	local getIsCustom = false
	local gerModel = self.GrenadeAttackModel
	local gerClass = self.GrenadeAttackEntity
	local gerFussTime = self.GrenadeAttackFussTime
	
	if self.CanUseSpecialGrenade == true then
	
	gerModel = self.UseSpecialGrenade_Var.Model
	gerClass = self.UseSpecialGrenade_Var.Class
	gerFussTime = self.UseSpecialGrenade_Var.FussTime
	
	end

	if CustomEnt != nil && CustomEnt != NULL then -- For custom grenades
		getIsCustom = true
		gerModel = CustomEnt:GetModel()
		gerClass = CustomEnt:GetClass()
		CustomEnt:SetMoveType(MOVETYPE_NONE)
		CustomEnt:SetParent(self)
		CustomEnt:Fire("SetParentAttachment",self.GrenadeAttackAttachment)
		//CustomEnt:SetPos(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos)
		CustomEnt:SetAngles(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Ang)
		if gerClass == "obj_vj_grenade" then gerFussTime = math.abs(CustomEnt.FussTime - CustomEnt.TimeSinceSpawn) end
		if gerClass == "npc_grenade_frag" then gerFussTime = 1.5 end
	end

	self.ThrowingGrenade = true
	self:CustomOnGrenadeAttack_BeforeThrowTime()
	self:CustomOnGrenadeThrow_After() 
	
	
			local gerShootPos = self:GetPos() + self:GetForward()*1200
			local grenadethrowhigh = 0
			if !IsValid(self:GetEnemy()) then
				local iamarmo = self:VJ_CheckAllFourSides()
				if iamarmo.Forward then gerShootPos = self:GetPos() + self:GetForward()*1200 self:FaceCertainPosition(gerShootPos)
					elseif iamarmo.Right then gerShootPos = self:GetPos() + self:GetRight()*1200 self:FaceCertainPosition(gerShootPos)
					elseif iamarmo.Left then gerShootPos = self:GetPos() + self:GetRight()*-1200 self:FaceCertainPosition(gerShootPos)
					elseif iamarmo.Backward then gerShootPos = self:GetPos() + self:GetForward()*-1200 self:FaceCertainPosition(gerShootPos)
				end
			end
			if IsValid(self:GetEnemy()) then 
			if (self:VJ_ForwardIsHidingZone(self:EyePos(),self:GetEnemy():EyePos(),true) == true) && self.SmartGrenadeThrow_enemyvisible_lastposition != Vector(0,0,0) then
				if self:GetPos():DistToSqr( self.SmartGrenadeThrow_enemyvisible_lastposition ) > self.GrenadeAttackThrowDistanceClose*self.GrenadeAttackThrowDistanceClose then
				self:FaceCertainPosition(self.SmartGrenadeThrow_enemyvisible_lastposition)
				gerShootPos = self.SmartGrenadeThrow_enemyvisible_lastposition + Vector(0,0,15)
				end
			else
			
				gerShootPos = self:GetEnemy():GetPos() + self:GetEnemy():GetUp()*90
			
			end
			if self.CanThrowBlindGrenade == true then 
				if self.SmartGrenadeThrow_enemyvisible_previously == 1 and self.SmartGrenadeThrow_enemyvisible_lastposition != Vector(0,0,0) and math.random(1,10) > 6 then
					if self:GetPos():DistToSqr( self.SmartGrenadeThrow_enemyvisible_lastposition ) > self.GrenadeAttackThrowDistanceClose*self.GrenadeAttackThrowDistanceClose then
					self:FaceCertainPosition(self.SmartGrenadeThrow_enemyvisible_lastposition)
					gerShootPos = self.SmartGrenadeThrow_enemyvisible_lastposition + Vector(0,0,15)
					end
				else
					gerShootPos = self:GetEnemy():GetPos() + self:GetEnemy():GetUp()*90
				end
			end
			end
			
			local greShootVel = gerShootPos -self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos
			
			local selfpos = self:GetPos() + self:GetUp()*50
			local heightdifference = gerShootPos.z - selfpos.z
			
			if self.CanDoGrenadeThrowHigh == true then
			--if math.random(self.GrenadeThrowHigh_chance,50) > -40 then
			gerShootPos = gerShootPos + Vector(0,0,5)
			
			local targetdir = gerShootPos -selfpos
			local Midpoint = Vector((selfpos.x + gerShootPos.x)/2,(selfpos.y + gerShootPos.y)/2,(selfpos.z + gerShootPos.z)/2)
			local midpointdist = selfpos:Distance( Midpoint )
			local midpointupper = Midpoint + Vector(0,0, midpointdist*1.732 ) --/1 for tan45 , 1.731 for tan60 (sqroot 3)
			heightdifference = gerShootPos.z - selfpos.z
			
			if math.abs(heightdifference) > 1 then 
				--midpointupper = midpointupper + Vector(0,0, heightdifference/2) + targetdir:GetNormalized()*(heightdifference/2)
			end
			
			local tr = util.TraceLine({
							start = self:GetPos() + self:GetUp()*85,
							endpos = midpointupper,
							filter = {self}
							})
			local vel_range = 0
			local vel_force	= 0
			local failedsecondcheck = 0
			local failedsecondcheck2 = 0
			local failedsecondcheck3 = 0
			if self.CanThrowBlindGrenade == true then 
						local tr2 = util.TraceLine({
							start = midpointupper,
							endpos = gerShootPos,
							filter = {self}
							})
							if (tr2.Entity != nil and tr2.Entity != NULL) or tr2.HitWorld == true then failedsecondcheck = 1 end
			end
			
			if failedsecondcheck == 0 and tr.HitWorld == false and ( tr.Entity == nil or tr.Entity == NULL or (self:GetActiveWeapon() != NULL and tr.Entity == self:GetActiveWeapon()) ) then
				greShootVel = midpointupper -self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos
				grenadethrowhigh = 1
				
				--local vel_lengthz = math.sqrt( 22.86*(midpointupper.z - selfpos.z) ) 
				--local vel_lengthx = (midpointdist*2)/((vel_lengthz*2)/11.43) --calculate the flight time of grenade
				--local vel_force =  math.sqrt( vel_lengthx*vel_lengthx + vel_lengthz*vel_lengthz )
				vel_range = (midpointdist*2)*0.01905 + ((heightdifference*0.01905)/1.732)
				vel_force = math.sqrt( (11.43*vel_range)/(0.8632) ) --1 unit = 0.01905m sin 2.1 rad = 0.8632
				
				--if math.abs(heightdifference) > 1 then 
				
				--end
				
				--local vel_force = math.sqrt( vel_force2 )
				greShootVel = greShootVel:GetNormalized()*(vel_force/0.01905)
				
			else
				midpointupper = Midpoint + Vector(0,0, midpointdist/1 ) --try 45 degrees
				--if math.abs(heightdifference) > 1 then 
				--midpointupper = midpointupper + Vector(0,0, heightdifference/2) + targetdir:GetNormalized()*(heightdifference/2)
				--end
				local trt = util.TraceLine({
						start = self:GetPos() + self:GetUp()*85,
						endpos = midpointupper,
						filter = {self}
						})
					if self.CanThrowBlindGrenade == true then 
						local tr2a = util.TraceLine({
							start = midpointupper,
							endpos = gerShootPos,
							filter = {self}
							})
							if (tr2a.Entity != nil and tr2a.Entity != NULL) or tr2a.HitWorld == true then failedsecondcheck2 = 1 end
					end
				if failedsecondcheck2 == 0 and trt.HitWorld == false and ( trt.Entity == nil or trt.Entity == NULL or (self:GetActiveWeapon() != NULL and trt.Entity == self:GetActiveWeapon()) ) then 
				greShootVel = midpointupper -self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos
				grenadethrowhigh = 1
				
				--local vel_lengthz = math.sqrt( 22.86*(midpointupper.z - selfpos.z) ) 
				--local vel_lengthx = (midpointdist*2)/( (vel_lengthz*2)/11.43 ) --calculate the flight time of grenade
				--local vel_force =  math.sqrt( vel_lengthx*vel_lengthx + vel_lengthz*vel_lengthz )

				vel_range = (midpointdist*2)*0.01905 + ((heightdifference*0.01905)/1)
				vel_force = math.sqrt( (11.43*vel_range)/(1) ) --1 unit = 0.01905m sin 1.57 rad = 0.99999
	
				greShootVel = greShootVel:GetNormalized()*(vel_force/0.01905)
				
				else
				
				midpointupper = Midpoint + Vector(0,0, midpointdist*0.176 ) ------------------try 10 degrees

				local trtbc = util.TraceLine({
						start = self:GetPos() + self:GetUp()*75,
						endpos = midpointupper,
						filter = {self}
						})
					if self.CanThrowBlindGrenade == true then 
						local tr2abc = util.TraceLine({
							start = midpointupper,
							endpos = gerShootPos,
							filter = {self}
							})
							if (tr2abc.Entity != nil and tr2abc.Entity != NULL) or tr2abc.HitWorld == true then failedsecondcheck3 = 1 end
					end
				if failedsecondcheck3 == 0 and trtbc.HitWorld == false and ( trtbc.Entity == nil or trtbc.Entity == NULL or (self:GetActiveWeapon() != NULL and trtbc.Entity == self:GetActiveWeapon()) ) then 
				greShootVel = midpointupper -self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos
				grenadethrowhigh = 1
				vel_range = (midpointdist*2)*0.01905 + ((heightdifference*0.01905)/0.176)
				vel_force = math.sqrt( (11.43*vel_range)/(0.343) ) --1 unit = 0.01905m sin 0.349 rad = 0.35
				greShootVel = greShootVel:GetNormalized()*(vel_force/0.01905)*0.75
				end
				
				end
				
			
			end
			
			--end
			end
	
	
	if grenadethrowhigh == 1 then --or (math.abs(heightdifference) <= 100 and self.CanThrowBlindGrenade != true ) then
		self:GrenadeAttackSoundCode()
	if self.VJ_PlayingSequence == false && self.DisableGrenadeAttackAnimation == false then
		self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_GrenadeAttack)
		self.PlayingAttackAnimation = true
		timer.Simple(VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -0.2,function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,self.GrenadeAttackAnimationStopAttacks,self:DecideAnimationLength(self.CurrentAttackAnimation,self.GrenadeAttackAnimationStopAttacksTime),false,self.GrenadeAttackAnimationDelay)
	end
	end

	timer.Simple(self.TimeUntilGrenadeIsReleased,function()
		if getIsCustom == true && !IsValid(CustomEnt) then return end
		if IsValid(CustomEnt) then CustomEnt.VJHumanTossingAway = false CustomEnt:Remove() end
		if IsValid(self) && self.Dead == false /*&& IsValid(self:GetEnemy())*/ then

			
			if grenadethrowhigh == 1 then -- or (math.abs(heightdifference) <= 100 and self.CanThrowBlindGrenade != true ) then
			local grenent = ents.Create(gerClass)
			if NoOwner == false then grenent:SetOwner(self) end
			grenent:SetPos(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos)
			grenent:SetAngles(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Ang)
			grenent:SetModel(Model(gerModel))
			if gerClass == "obj_vj_grenade" then grenent.FussTime = gerFussTime end
			grenent:Spawn()
			grenent:Activate()
			grenent.RadiusDamageDisableVisibilityCheck = true
			if self.CanUseSpecialGrenade != true then
			grenent.RadiusDamage = 90
			end
			if self.CanUseSpecialGrenade == true then
			grenent.FussTime = gerFussTime
			end
			if gerClass == "npc_grenade_frag" then grenent:Input("SetTimer",self:GetOwner(),self:GetOwner(),gerFussTime) end
			local phys = grenent:GetPhysicsObject()
			if (phys:IsValid()) then
				if grenadethrowhigh == 1 then 
				phys:EnableDrag( false ) 
				grenent:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
				end
				phys:Wake()
				phys:AddAngleVelocity(Vector(math.Rand(150,250),math.Rand(150,250),math.Rand(150,250)))
				if grenadethrowhigh == 1 then
				phys:SetVelocity(greShootVel*(math.random(self.GrenadeThrowHigh_veltable.vel1*100,self.GrenadeThrowHigh_veltable.vel2*100)/100) +self:GetUp()*math.random(self.GrenadeThrowHigh_veltable.upvel1,self.GrenadeThrowHigh_veltable.upvel2) +self:GetForward()*self.GrenadeThrowHigh_veltable.forvel )
				phys:EnableDrag( false ) 
				else
				phys:SetVelocity(greShootVel +self:GetUp()*math.random(self.GrenadeAttackVelUp1,self.GrenadeAttackVelUp2) +self:GetForward()*math.Rand(self.GrenadeAttackVelForward1,self.GrenadeAttackVelForward2) +self:GetRight()*math.Rand(self.GrenadeAttackVelRight1,self.GrenadeAttackVelRight2))
				end
				if self.CanUseSpecialGrenade == true then
				phys:SetMass( 10 ) 
				phys:SetInertia( phys:GetInertia()*50 )
				if grenent.ArmourPenetrationValue != nil and grenent.HighExplosiveValue != nil then 
				self.ArmourPenetrationValue = grenent.ArmourPenetrationValue 
				self.HighExplosiveValue = grenent.HighExplosiveValue
				end
				
				else
				phys:SetMass( 5 )
				phys:SetInertia( phys:GetInertia()*50 )
				--phys:SetDamping( 0, 0 ) 
				end
				for kc,vf in ipairs(ents.FindInSphere(grenent:GetPos(),180)) do
				if !vf:IsNPC() then continue end
				if vf:EntIndex() != grenent:EntIndex() && (!vf.IsVJBaseSNPC_Tank) && vf:Health() > 0 && (vf.IsVJBaseSNPC == true && vf.Dead != true) then
					constraint.NoCollide( grenent, vf)
				end
				end
				
			end
			self:CustomOnGrenadeAttack_OnThrow(grenent)
			
			if self.CanUseSpecialGrenade == true then
			self.NextThrowSmartGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2) + math.random(self.UseSpecialGrenade_Var.Nexttime1,self.UseSpecialGrenade_Var.Nexttime2)
			self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1,self.NextThrowGrenadeTime2) + math.random(self.UseSpecialGrenade_Var.Nexttime1,self.UseSpecialGrenade_Var.Nexttime2)
			
			if self.UseSpecialGrenade_Var.Backdist > 0 then
			local originaldist = self.DistanceToRunFromEnemy 
			self.DistanceToRunFromEnemy = self.UseSpecialGrenade_Var.Backdist
			timer.Simple(self.UseSpecialGrenade_Var.FussTime,function()
			if IsValid(self) && self.Dead == false then
				self.DistanceToRunFromEnemy = originaldist
			end
			end)
			end
			
			end
			
			else
			self.NextThrowSmartGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1/3,self.NextThrowGrenadeTime2/3)
			self.NextThrowGrenadeT = CurTime() + math.random(self.NextThrowGrenadeTime1/3,self.NextThrowGrenadeTime2/3)
			end
			
		end
		self.ThrowingGrenade = false
	end)
end

function ENT:ThrowMedkitCode(HealTarget,CustomEnt,NoOwner)
	if self.Dead == true or self.Flinching == true or self.MeleeAttacking == true or HealTarget == nil or !IsValid(HealTarget) or self.vACT_StopAttacks != false then return end
	//if self:VJ_ForwardIsHidingZone(self:NearestPoint(self:GetPos() +self:OBBCenter()),self:GetEnemy():EyePos()) == true then return end
	local NoOwner = NoOwner or false
	local getIsCustom = false
	local gerModel = self.Medic_SpawnPropOnHealModel --"models/healthvial.mdl"
	local gerClass = "prop_physics"
	local gerFussTime = self.GrenadeAttackFussTime
	local Targettoheal = HealTarget

	self.ThrowingGrenade = true
	--self:CustomOnGrenadeAttack_BeforeThrowTime()
	--self:GrenadeAttackSoundCode()
	self:FaceCertainPosition(Targettoheal:GetPos())
	if self.VJ_PlayingSequence == false then
		self.CurrentAttackAnimation = VJ_PICKRANDOMTABLE(self.AnimTbl_ThrowMedkit)
		self.PlayingAttackAnimation = true
		timer.Simple(VJ_GetSequenceDuration(self,self.CurrentAttackAnimation) -0.2,function()
			if IsValid(self) then
				self.PlayingAttackAnimation = false
			end
		end)
		self:VJ_ACT_PLAYACTIVITY(self.CurrentAttackAnimation,true,self:DecideAnimationLength(self.CurrentAttackAnimation,false),false,0)
	end

	timer.Simple(0.72,function()

		if IsValid(CustomEnt) then CustomEnt.VJHumanTossingAway = false CustomEnt:Remove() end
		if IsValid(self) && self.Dead == false then
			local gerShootPos = self:GetPos() + self:GetForward()*200
			if Targettoheal == nil or !IsValid(Targettoheal) then
				local iamarmo = self:VJ_CheckAllFourSides()
				if iamarmo.Forward then gerShootPos = self:GetPos() + self:GetForward()*200 self:FaceCertainPosition(gerShootPos)
					elseif iamarmo.Right then gerShootPos = self:GetPos() + self:GetRight()*200 self:FaceCertainPosition(gerShootPos)
					elseif iamarmo.Left then gerShootPos = self:GetPos() + self:GetRight()*-200 self:FaceCertainPosition(gerShootPos)
					elseif iamarmo.Backward then gerShootPos = self:GetPos() + self:GetForward()*-200 self:FaceCertainPosition(gerShootPos)
				end
			end
			if Targettoheal != nil and IsValid(HealTarget) then 
			gerShootPos = Targettoheal:GetPos()+Targettoheal:GetUp()*10 
			self:FaceCertainPosition(Targettoheal:GetPos())
			end
			local grenent = ents.Create(gerClass)
			local greShootVel = gerShootPos -self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos
			if NoOwner == false then grenent:SetOwner(self) end
			grenent:SetPos(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Pos)
			grenent:SetAngles(self:GetAttachment(self:LookupAttachment(self.GrenadeAttackAttachment)).Ang)
			grenent:SetModel(Model(gerModel))
			grenent:SetCollisionGroup(20)
			grenent:Spawn()
			grenent:Activate()
			self:DeleteOnRemove(grenent)
			self.ThrowMedkit_Medkitent = grenent
			local phys = grenent:GetPhysicsObject()
			if (phys:IsValid()) then
				phys:Wake()
				phys:AddAngleVelocity(Vector(math.Rand(500,500),math.Rand(500,500),math.Rand(500,500)))
				phys:SetVelocity(greShootVel +self:GetUp()*self.ThrowMedkit_VelUp +self:GetForward()*self.ThrowMedkit_VelForward)
			end
			self:CustomOnGrenadeAttack_OnThrow(grenent)
		end
		self.ThrowingGrenade = false
	end)
end

function ENT:SmartCheckForGrenades()
	if self.CanSmartDetectGrenades == false or self.ThrowingGrenade == true or self.vACT_StopAttacks == true or self.HasSeenGrenade == true or self.VJ_IsBeingControlled == true then return end
	local FindNearbyGrenades = ents.FindInSphere(self:GetPos(),self.RunFromGrenadeDistance)
	for k,v in pairs(FindNearbyGrenades) do
		if self.HasSeenGrenade == false then
		local IsFriendlyGrenade = false
		if self.EntitiesToRunFrom[v:GetClass()] && self:Visible(v) && v:GetVelocity():Length() < 200 then
			if v:GetOwner() != nil && v:GetOwner() != NULL && v:GetOwner().IsVJBaseSNPC == true && (self:Disposition(v:GetOwner()) == D_LI or self:Disposition(v:GetOwner()) == D_NU) then
				IsFriendlyGrenade = true
			end
			if IsFriendlyGrenade == false then
				self:OnGrenadeSightSoundCode()
				self.HasSeenGrenade = true
				local GrenDist = self:VJ_GetNearestPointToEntityDistance(v)
				self.TakingCoverT = CurTime() + 4
				if v.VJHumanNoPickup != true && v.VJHumanTossingAway != true && self.CanThrowBackDetectedGrenades == true && self.HasGrenadeAttack == true && v:GetVelocity():Length() < 400 && GrenDist < 100 && (v:GetClass() == "npc_grenade_frag" or v:GetClass() == "obj_vj_grenade") then
					self.NextGrenadeAttackSoundT = CurTime() + 3
					self:ThrowGrenadeCode(v,true)
					v.VJHumanTossingAway = true
					//v:Remove()
				end
				//if self.VJ_PlayingSequence == false then self:VJ_SetSchedule(SCHED_RUN_FROM_ENEMY) end
				--self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
				local runspots = {}
				local dir = (self:GetPos() +self:GetUp()*30) -(v:GetPos()+Vector(0,0,30))
				local dir1 = (self:GetPos() +self:GetRight()*GrenDist +self:GetUp()*30) -(v:GetPos()+Vector(0,0,30))
				local dir2 = (self:GetPos() +self:GetRight()*-GrenDist +self:GetUp()*30) -(v:GetPos()+Vector(0,0,30))
				local trac1 = util.TraceLine({
						start = self:GetPos()+self:GetUp()*30,
						endpos = dir:GetNormalized()*self.RunFromGrenadeDistance,
						filter = {self,self:GetActiveWeapon()}
						})
				local trac2 = util.TraceLine({
						start = self:GetPos()+self:GetUp()*30,
						endpos = dir1:GetNormalized()*self.RunFromGrenadeDistance,
						filter = {self,self:GetActiveWeapon()}
						})
				local trac3 = util.TraceLine({
						start = self:GetPos()+self:GetUp()*30,
						endpos = dir2:GetNormalized()*self.RunFromGrenadeDistance,
						filter = {self,self:GetActiveWeapon()}
						})
				table.insert( runspots, trac1.HitPos )
				table.insert( runspots, trac2.HitPos )
				table.insert( runspots, trac3.HitPos )
				local chosenspot = trac1.HitPos
					local isclosestone = 1
					for ku,usepos in pairs(runspots) do
					if usepos != nil and usepos != NULL then
					if v:GetPos():DistToSqr(usepos) > v:GetPos():DistToSqr(chosenspot) then 
						chosenspot = usepos
					end
					end
					end
					
				self:SetLastPosition(chosenspot)
				--self.CurrentCoveringPosition = chosenspot
				self:StopMoving()
				--self:VJ_TASK_GOTO_LASTPOS("TASK_RUN_PATH",function(x) x:EngTask("TASK_FACE_ENEMY", 0) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true x.StopScheduleIfNotMoving = true end)
				self.NextMoveRandomlyWhenShootingT = CurTime() + math.Rand(self.NextMoveRandomlyWhenShootingTime1,self.NextMoveRandomlyWhenShootingTime2) + 1
				self.SmartAttackPos_NextT = CurTime() + self.SmartAttackPos_Var.Nexttime*1.2
				self.LookForCover_NextT = CurTime() + self.LookForCover_Var.Nexttime
				self.FlankEnemy_NextT = CurTime() + self.FlankEnemy_Nexttime*2.5
				self.NextChaseTime = CurTime() + 4
				self.NextIdleTime = CurTime() + 4
				
				local alertfri = self.AlertFriendsOnDeath
				local alertfri2 = self.CanAlertFriendsOnDeath_Advanced
				local alertfri3 = self.AllowWeaponReloading
				self.AllowWeaponReloading = false
				self.AlertFriendsOnDeath = false 
				self.CanAlertFriendsOnDeath_Advanced = false
				
				local coverfailed = 0
				if v:GetPos():DistToSqr(chosenspot) < 200*200 then
					coverfailed = 1
				end
				if coverfailed == 1 then
				
				self:VJ_TASK_COVER_FROM_ENEMY("TASK_RUN_PATH",function(x) x.CanShootWhenMoving = true x.ConstantlyFaceEnemy = true end)
				else
			
				local MoveType = "TASK_RUN_PATH"
				local vsched = ai_vj_schedule.New("vj_goto_lastpos_gren")
				vsched:EngTask("TASK_GET_PATH_TO_LASTPOSITION", 0)
				//vsched:EngTask(MoveType, 0)
				vsched:EngTask("TASK_WAIT_FOR_MOVEMENT", 0)
				vsched.IsMovingTask = true
				vsched.CanShootWhenMoving = true 
				vsched.ConstantlyFaceEnemy = true
				if MoveType == "TASK_RUN_PATH" then self:SetMovementActivity(VJ_PICKRANDOMTABLE(self.AnimTbl_Run)) vsched.IsMovingTask_Run = true else self:SetMovementActivity(VJ_PICKRANDOMTABLE(self.AnimTbl_Walk)) vsched.IsMovingTask_Walk = true end
				//self.CanDoSelectScheduleAgain = false
				//vsched.RunCode_OnFinish = function()
				//self.CanDoSelectScheduleAgain = true
				//end
				--if (CustomCode) then CustomCode(vsched) end
				if self.vACT_StopAttacks != true and self.ThrowingGrenade != true then
				self:StartSchedule(vsched)
				end
				
				end
				
				timer.Simple(4,function() if IsValid(self) then 
				self.HasSeenGrenade = false 
				self.AlertFriendsOnDeath = alertfri
				self.CanAlertFriendsOnDeath_Advanced = alertfri2
				self.AllowWeaponReloading = alertfri3
				if self.CurrentSchedule != nil && self.CurrentSchedule.Name == "vj_goto_lastpos_gren" then
					self:ClearSchedule()
				end
				end 
				end)
				//else
				//self.HasSeenGrenade = false
				//return
			end
		end
		end
	end
end

function ENT:CustomOnAISkillPreset_extra()

end

function ENT:CustomOnAISkillPreset()

	if self.SkillSet == 1 then return end
	local ClassName = self:GetClass()
	self:CustomOnAISkillPreset_extra()
	
	if string.find(ClassName, "npc_doi_german_heer_private") or string.find(ClassName, "npc_doi_german_heer_grenadier") or string.find(ClassName, "npc_doi_german_heer_medic") then
	self.BlindFire_Cooltime = 5
	self.BlindFire_Var = {CanFlinch=0,CanCover=false,CanPose=true,WeaponSpread=1,durationextra=7}
	self.BlindFire_Chance = 4 --Chance: 1 to 10, 1 is always while more than 10 is never
	self.FlankEnemy_Nexttime = 3
	self.FlankEnemy_chance = 3
	self.AimCorrect_Var = {Nexttime=2.8,Chance=2}
	self.SmartAttackPos_Var = {Nexttime=4.5,Chance=3,Range=800}
	self.LookForCover_Var = {Nexttime=2.5,Chance=2,Range=700}
	self.CanThrowBlindGrenade = false
	self.SmartAiming_chance = 3
	self.SmartAiming_attacktime = 1.5
	self.SmartGrenadeThrow_chance = 4
	self.NextThrowSmartGrenadeT = 0
	self.ThrowSmartGrenadeChance = 4
	self.Reloadwhenidle_chance = 2
	self.Reloadwhenattacking_chance = 3
	self.TrickShoot_Nexttime = 1.5
	self.TrickShoot_Chance = 7
	self.FlankAttackPosition_Nexttime = 2.7
	self.FlankAttackPosition_chance = 6
	self.CanTrickShootHide = false
	self.TrickShootHide_Nexttime = 0.9
	self.TrickShootHide_cooldown = 2
	end
	
	if string.find(ClassName, "npc_doi_german_heer_officer") or string.find(ClassName, "npc_doi_german_heer_engineer") or string.find(ClassName, "npc_doi_german_heer_gunner") then
	self.AimCorrect_Var = {Nexttime=2.5,Chance=2}
	self.SmartAttackPos_Var = {Nexttime=4.5,Chance=3,Range=800}
	self.LookForCover_Var = {Nexttime=2.0,Chance=2,Range=700}
	self.SmartAiming_chance = 3
	self.SmartAiming_attacktime = 1.5
	self.SmartGrenadeThrow_chance = 3
	self.NextThrowSmartGrenadeT = 0
	self.ThrowSmartGrenadeChance = 3
	self.Reloadwhenidle_chance = 1
	self.Reloadwhenattacking_chance = 3
	self.TrickShoot_Nexttime = 1.4
	self.TrickShoot_Chance = 6
	self.FlankAttackPosition_Nexttime = 2.5
	self.FlankAttackPosition_chance = 5
	self.CanTrickShootHide = true
	self.TrickShootHide_Nexttime = 0.8
	self.TrickShootHide_cooldown = 2
	self.TrickShootHide_chance = 6
	end
	
	if string.find(ClassName, "npc_swbfimp_storm") or string.find(ClassName, "npc_swbfimp_stormtrooper") or string.find(ClassName, "npc_doi_german_waffen_gunner") then
	self.BlindFire_Cooltime = 5
	self.BlindFire_Var = {CanFlinch=0,CanCover=false,CanPose=true,WeaponSpread=1,durationextra=7}
	self.BlindFire_Chance = 6 --Chance: 1 to 10, 1 is always while more than 10 is never
	self.FlankEnemy_Nexttime = 3
	self.FlankEnemy_chance = 2
	self.AimCorrect_Var = {Nexttime=2.3,Chance=2}
	self.SmartAttackPos_Var = {Nexttime=4.2,Chance=3,Range=800}
	self.LookForCover_Var = {Nexttime=1.6,Chance=2,Range=750}
	self.SmartAiming_chance = 3
	self.SmartAiming_attacktime = 1.2
	self.SmartGrenadeThrow_chance = 3
	self.NextThrowSmartGrenadeT = 0
	self.ThrowSmartGrenadeChance = 3
	self.Reloadwhenidle_chance = 2
	self.Reloadwhenattacking_chance = 2
	self.TrickShoot_Nexttime = 1.4
	self.TrickShoot_Chance = 5
	self.FlankAttackPosition_Nexttime = 2.3
	self.FlankAttackPosition_chance = 4
	self.CanTrickShootHide = true
	self.TrickShootHide_Nexttime = 0.6
	self.TrickShootHide_cooldown = 1.5
	self.TrickShootHide_chance = 5
	end
	
	if string.find(ClassName, "npc_swbfimp_darktrooper") or string.find(ClassName, "npc_swbfimp_scofficer") or string.find(ClassName, "npc_swbfimp_navyofficer") then
	self.BlindFire_Cooltime = 4
	self.BlindFire_Var = {CanFlinch=0,CanCover=false,CanPose=true,WeaponSpread=1,durationextra=7}
	self.BlindFire_Chance = 6 --Chance: 1 to 10, 1 is always while more than 10 is never
	self.FlankEnemy_Nexttime = 2.4
	self.FlankEnemy_chance = 2
	self.AimCorrect_Var = {Nexttime=2.1,Chance=2}
	self.SmartAttackPos_Var = {Nexttime=4.2,Chance=3,Range=800}
	self.LookForCover_Var = {Nexttime=1.4,Chance=2,Range=750}
	self.SmartAiming_chance = 3
	self.SmartAiming_attacktime = 1.2
	self.SmartGrenadeThrow_chance = 3
	self.NextThrowSmartGrenadeT = 0
	self.ThrowSmartGrenadeChance = 3
	self.Reloadwhenidle_chance = 2
	self.Reloadwhenattacking_chance = 2
	self.TrickShoot_Nexttime = 1.2
	self.TrickShoot_Chance = 4
	self.FlankAttackPosition_Nexttime = 2.0
	self.FlankAttackPosition_chance = 3
	self.TrickShootHide_Nexttime = 0.5
	self.TrickShootHide_cooldown = 1.5
	self.TrickShootHide_chance = 4
	end
	
	if string.find(ClassName, "npc_swbfimp_isbofficer") then
	self.BlindFire_Cooltime = 3
	self.BlindFire_Var = {CanFlinch=0,CanCover=false,CanPose=true,WeaponSpread=1,durationextra=7}
	self.BlindFire_Chance = 7 --Chance: 1 to 10, 1 is always while more than 10 is never
	self.FlankEnemy_Nexttime = 2.2
	self.FlankEnemy_chance = 2
	self.AimCorrect_Var = {Nexttime=1.5,Chance=2}
	self.SmartAttackPos_Var = {Nexttime=4.1,Chance=3,Range=800}
	self.LookForCover_Var = {Nexttime=1.1,Chance=2,Range=750}
	self.SmartAiming_chance = 3
	self.SmartAiming_attacktime = 1.2
	self.SmartGrenadeThrow_chance = 2
	self.NextThrowSmartGrenadeT = 0
	self.ThrowSmartGrenadeChance = 2
	self.Reloadwhenidle_chance = 2
	self.Reloadwhenattacking_chance = 2
	self.TrickShoot_Nexttime = 1.0
	self.TrickShoot_Chance = 4
	self.TrickShoot_Cooldown = 2.0
	self.FlankAttackPosition_Nexttime = 1.5
	self.FlankAttackPosition_chance = 3
	self.TrickShootHide_Nexttime = 0.4
	self.TrickShootHide_cooldown = 1.1
	self.TrickShootHide_chance = 2
	end
	
	if string.find(ClassName, "npc_doi_american_army") then
	self.AimCorrect_Var = {Nexttime=2.0,Chance=2}
	self.SmartAttackPos_Var = {Nexttime=4.5,Chance=3,Range=800}
	self.LookForCover_Var = {Nexttime=1.8,Chance=2,Range=700}
	self.FlankEnemy_Nexttime = 2.8
	self.SmartAiming_chance = 3
	self.SmartAiming_attacktime = 1.5
	self.SmartGrenadeThrow_chance = 3
	self.NextThrowSmartGrenadeT = 0
	self.ThrowSmartGrenadeChance = 3
	self.Reloadwhenidle_chance = 1
	self.Reloadwhenattacking_chance = 3
	self.TrickShoot_Nexttime = 1.2
	self.TrickShoot_Chance = 5
	self.FlankAttackPosition_Nexttime = 2.0
	self.FlankAttackPosition_chance = 4
	self.TrickShootHide_Nexttime = 0.8
	self.TrickShootHide_cooldown = 1.8
	self.TrickShootHide_chance = 5
	end
	
	if string.find(ClassName, "npc_doi_american_ranger") then
	self.BlindFire_Cooltime = 4
	self.BlindFire_Var = {CanFlinch=0,CanCover=false,CanPose=true,WeaponSpread=1,durationextra=7}
	self.BlindFire_Chance = 6 --Chance: 1 to 10, 1 is always while more than 10 is never
	self.FlankEnemy_Nexttime = 2.4
	self.FlankEnemy_chance = 2
	self.AimCorrect_Var = {Nexttime=1.8,Chance=2}
	self.SmartAttackPos_Var = {Nexttime=4.2,Chance=3,Range=800}
	self.LookForCover_Var = {Nexttime=1.4,Chance=2,Range=750}
	self.SmartAiming_chance = 3
	self.SmartAiming_attacktime = 1.2
	self.SmartGrenadeThrow_chance = 3
	self.NextThrowSmartGrenadeT = 0
	self.ThrowSmartGrenadeChance = 3
	self.Reloadwhenidle_chance = 2
	self.Reloadwhenattacking_chance = 2
	self.TrickShoot_Nexttime = 1.4
	self.TrickShoot_Chance = 4
	self.FlankAttackPosition_Nexttime = 2.0
	self.FlankAttackPosition_chance = 3
	self.TrickShootHide_Nexttime = 0.5
	self.TrickShootHide_cooldown = 1.3
	self.TrickShootHide_chance = 4
	end
	
	self.SkillSet = 1
end

/*-----------------------------------------------
	*** Copyright (c) 2012-2017 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/