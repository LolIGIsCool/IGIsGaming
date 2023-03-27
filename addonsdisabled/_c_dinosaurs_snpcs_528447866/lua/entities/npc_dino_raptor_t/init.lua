AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/raptor.mdl" 
ENT.StartHealth = GetConVarNumber("vj_raptor_t_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_FASTZOMBIE_BIG_SLASH, ACT_MELEE_ATTACK1}
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackDistance = 45 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 160 -- How far the damage goes
ENT.MeleeDistanceB = 45 -- Sometimes 45 is a good number but Sometimes needs a change
ENT.MeleeAttackHitTime = 0.4 -- This counted in seconds | This calculates the time until it hits something
ENT.UntilNextAttack_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = GetConVarNumber("vj_raptor_t_d")
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 1 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking

	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"raptor_jp/step1.wav","raptor_jp/step2.wav"}
ENT.SoundTbl_Idle = {"raptor/idle1.wav","raptor/idle2.wav","raptor/idle3.wav","raptor/idle4.wav","raptor/idle5.wav","raptor/idle6.wav","raptor/idle7.wav","raptor/idle8.wav"}
ENT.SoundTbl_Alert = {"raptor/raptor_alert1.wav","raptor/raptor_alert2.wav","raptor/raptor_alert3.wav","raptor/raptor_alert4.wav"}
ENT.SoundTbl_MeleeAttack = {"raptor/raptor_attack1.wav","raptor/raptor_attack2.wav","raptor/raptor_attack3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"misses/miss1.wav","misses/miss2.wav","misses/miss3.wav","misses/miss4.wav"}
ENT.SoundTbl_Pain = {"raptor/raptor_hurt1.wav","raptor/raptor_hurt2.wav"}
ENT.SoundTbl_Death = {"raptor/raptor_die1.wav","raptor/raptor_die2.wav","raptor/raptor_die3.wav","raptor/raptor_die4.wav"}


function ENT:LeapForceCode()
	local jumpyaw
	local jumpcode = (self:GetEnemy():GetPos() -self:GetPos()):GetNormal() *1000 +self:GetUp() *180 +self:GetForward() *4000
	jumpyaw = jumpcode:Angle().y
	self:SetLocalVelocity(jumpcode)
end

 