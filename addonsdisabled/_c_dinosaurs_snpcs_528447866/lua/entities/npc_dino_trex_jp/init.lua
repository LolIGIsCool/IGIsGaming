AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/animals/trexy_npc.mdl" 
ENT.StartHealth = GetConVarNumber("vj_trex_jp_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
ENT.SightDistance = 15000
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 125 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 370 -- How far the damage goes
ENT.MeleeDistanceB = 125 -- Sometimes 45 is a good number but Sometimes needs a change
ENT.Immune_CombineBall = true
ENT.Immune_Physics = true
ENT.TimeUntilMeleeAttackDamage = 0.6 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = GetConVarNumber("vj_trex_jp_d")
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.GetDamageFromIsHugeMonster = true
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.9 -- Next foot step sound when it is walking
ENT.HasWorldShakeOnMove = true -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 0.4 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 0.9 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveRadius = 2600 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 0.5 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS



	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"t-rex_jp/step1.wav","t-rex_jp/step2.wav","t-rex_jp/step3.wav"}
ENT.SoundTbl_Idle = {"t-rex_jp/idle1.wav","t-rex_jp/idle2.wav"}
ENT.SoundTbl_Alert = {"t-rex_jp/roar.wav"}
ENT.SoundTbl_MeleeAttack = {"t-rex_jp/idle1.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"misses/miss1.wav","misses/miss2.wav","misses/miss3.wav","misses/miss4.wav"}
ENT.SoundTbl_Pain = {"t-rex/pain1.wav"}
ENT.SoundTbl_Death = {"stalker/creature/giant/die_0.wav","stalker/creature/giant/die_1.wav"}

ENT.FootStepSoundLevel = 100
ENT.AlertSoundLevel = 150
ENT.PainSoundLevel = 150
ENT.DeathSoundLevel = 150
ENT.IdleSoundLevel = 150
ENT.MeleeAttackSoundLevel = 150
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(200, 50, 260), -Vector(200, 50, 0))
end

function ENT:CustomOnAlert()
	if self.VJ_IsBeingControlled == true then return end
	if math.random(1,2) == 1 then
		self.SoundTbl_Alert = {"t-rex_jp/roar.wav"}
		self:VJ_ACT_PLAYACTIVITY(ACT_FLINCH_PHYSICS,true,5.2,true)
	else
		self.SoundTbl_Alert = {"t-rex_jp/roar.wav"}
	end
end

/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/