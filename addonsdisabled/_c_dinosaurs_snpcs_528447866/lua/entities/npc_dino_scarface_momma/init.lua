AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/turok/scarface/scarfacemomma.mdl" 
ENT.StartHealth = GetConVarNumber("vj_scar_m_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
ENT.SightDistance = 30000
ENT.IsHugeMonster = true

---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number s_mommaaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2,ACT_MELEE_ATTACK3} -- Melee Attack Animations
ENT.MeleeAttackDistance = 225 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 730 -- How far the damage goes

ENT.MeleeAttackHitTime = 0.4 -- This counted in seconds | This calculates the time until it hits something
ENT.UntilNextAttack_Melee = 0.6 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = GetConVarNumber("vj_scar_m_d")
ENT.HasExtraMeleeAttackSounds = true
ENT.Immune_CombineBall = true -- Immune to Combine Ball
ENT.GetDamageFromIsHugeMonster = true
ENT.BrokenBloodSpawnUp = 200 -- Positive Number = Up | Negative Number = Down
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 1.2 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 3.4 -- Next foot step sound when it is walking
ENT.HasWorldShakeOnMove = true -- Should the world shake when it's moving?
ENT.NextWorldShakeOnRun = 1.2 -- How much time until the world shakes while it's running
ENT.NextWorldShakeOnWalk = 3.4 -- How much time until the world shakes while it's walking
ENT.WorldShakeOnMoveRadius = 5600 -- How far the screen shake goes, in world units
ENT.WorldShakeOnMoveDuration = 1 -- How long the screen shake will last, in seconds
ENT.WorldShakeOnMoveFrequency = 100 -- Just leave it to 100
ENT.HasSoundTrack = true -- Does the SNPC have a sound track?
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_s_mommaALL_FLINCH, SCHED_FLINCH_PHYSICS
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"smom/step.wav"}
ENT.SoundTbl_Idle = {"smom/trexbreathing1.wav","smom/trexhissbreathe.wav"}
ENT.SoundTbl_Alert = {"smom/trexroar.wav"}
ENT.SoundTbl_MeleeAttack = {"smom/trexbitehiss.wav"}
ENT.SoundTbl_Pain = {"smom/pain1.wav"}
ENT.SoundTbl_Death = {"smom/die.wav"}
ENT.SoundTbl_SoundTrack = {"smom/scarface_soundtrack.wav"}

ENT.FootStepSoundLevel = 100
ENT.AlertSoundLevel = 150
ENT.PainSoundLevel = 150
ENT.DeathSoundLevel = 150
ENT.IdleSoundLevel = 150
ENT.MeleeAttackSoundLevel = 150
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(189, 100, 530), Vector(-170, -100, 0))
end

function ENT:CustomOnAlert()
	if self.VJ_IsBeingControlled == true then return end
	if math.random(1,2) == 1 then
		self.SoundTbl_Alert = {"smom/trexroar.wav"}
		self:VJ_ACT_PLAYACTIVITY(ACT_IDLE_ANGRY,true,5.2,true)
	else
		self.SoundTbl_Alert = {"smom/trexroar.wav"}
	end
end

/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/