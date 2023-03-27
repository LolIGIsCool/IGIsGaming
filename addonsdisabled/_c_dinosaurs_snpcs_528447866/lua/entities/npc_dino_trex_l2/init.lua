AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/l2trex.mdl" 
ENT.StartHealth = GetConVarNumber("vj_trex_l2_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
ENT.SightDistance = 10000
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackDistance = 95 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 240 -- How far the damage goes
ENT.MeleeDistanceB = 95 -- Sometimes 45 is a good number but Sometimes needs a change
ENT.Immune_CombineBall = true
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = GetConVarNumber("vj_trex_l2_d")
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 0.5 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.5 -- Next foot step sound when it is walking
ENT.HasWorldShakeOnMove = true -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 0.5 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 0.5 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveRadius = 2600 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.4 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"carno/trex_step.wav","carno/trex_step1.wav","carno/trex_step2.wav"}
ENT.SoundTbl_Idle = {"carno/idle1.wav","carno/idle2.wav"}
ENT.SoundTbl_Alert = {"carno/roar1.wav","carno/roar2.wav","carno/roar3.wav","carno/roar4.wav"}
ENT.SoundTbl_MeleeAttack = {"carno/bite1.wav","carno/bite2.wav","carno/bite3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"misses/miss1.wav","misses/miss2.wav","misses/miss3.wav","misses/miss4.wav"}
ENT.SoundTbl_Pain = {"carno/biteh1.wav","carno/angry1.wav"}
ENT.SoundTbl_Death = {"carno/die1.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(120, 90, 150), -Vector(120, 90, 0))
end

function ENT:CustomOnAlert()
	if self.VJ_IsBeingControlled == true then return end
	if math.random(1,2) == 1 then
		self.SoundTbl_Alert = {"carno/roar1.wav"}
		self:VJ_ACT_PLAYACTIVITY("Hoi",true,1.2,true)
	else
		self.SoundTbl_Alert = {"carno/roar3.wav"}
	end
end

/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/