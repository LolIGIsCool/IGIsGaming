AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/animals/raptor_npc.mdl" 
ENT.StartHealth = GetConVarNumber("vj_raptor_jp_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.ZombieFriendly = false -- Makes the SNPC friendly to the HL2 Zombies
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackDistance = 65 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 170 -- How far the damage goes

ENT.MeleeAttackHitTime = 0.6 -- This counted in seconds | This calculates the time until it hits something
ENT.UntilNextAttack_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = GetConVarNumber("vj_raptor_jp_d")
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
ENT.SoundTbl_Idle = {"raptor_jp/idle1.wav","raptor_jp/idle2.wav"}
ENT.SoundTbl_Alert = {"raptor_jp/roar1.wav"}
ENT.SoundTbl_MeleeAttack = {"raptor_jp/attack1.wav","raptor_jp/attack2.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"misses/miss1.wav","misses/miss2.wav","misses/miss3.wav","misses/miss4.wav"}
ENT.SoundTbl_Pain = {"raptor_jp/hurt1.wav"}
ENT.SoundTbl_Death = {"raptor_jp/die1.wav"}

function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(70, 5, 80), -Vector(80, 5, 0))
end


function ENT:CustomOnAlert()
	if self.VJ_IsBeingControlled == true then return end
	if math.random(1,2) == 1 then
		self.SoundTbl_Alert = {"raptor_jp/roar1.wav"}
		self:VJ_ACT_PLAYACTIVITY(ACT_FLINCH_PHYSICS,true,3,true)
	else
		self.SoundTbl_Alert = {"raptor_jp/roar1.wav"}
	end
end



/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/