AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/dinosaurs/triceratops.mdl" 
ENT.StartHealth = GetConVarNumber("vj_triceratops_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_FriendlyNPCsSingle = {"npc_dino_triceratops","npc_dino_hadrosaur","npc_dino_brah"}
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.Immune_CombineBall = true
ENT.Immune_Physics = true
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackAnimationDelay = 0 -- It will wait certain amount of time before playing the animation
ENT.MeleeAttackDistance = 85 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 180 -- How far the damage goes
ENT.MeleeDistanceB = 85 -- Sometimes 45 is a good number but Sometimes needs a change
ENT.TimeUntilMeleeAttackDamage = 0.8 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.7 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = GetConVarNumber("vj_triceratops_d")
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 1 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
ENT.PlayerFriendly = true -- When true, it will still attack If you attack to much, also this will make it friendly to rebels and characters like that
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by a player?
ENT.BecomeEnemyToPlayerLevel = 4 -- How many times does the player have to hit the SNPC for it to become enemy?
	-- ====== Flinching Code ====== --
ENT.Flinches = 0 -- 0 = No Flinch | 1 = Flinches at any damage | 2 = Flinches only from certain damages
ENT.FlinchingChance = 14 -- chance of it flinching from 1 to x | 1 will make it always flinch
ENT.FlinchingSchedules = {SCHED_FLINCH_PHYSICS} -- If self.FlinchUseACT is false the it uses this | Common: SCHED_BIG_FLINCH, SCHED_SMALL_FLINCH, SCHED_FLINCH_PHYSICS
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"t-rex_jp/step1.wav","t-rex_jp/step2.wav","t-rex_jp/step3.wav"}
ENT.SoundTbl_Idle = {"Triceratops/TricCall01.wav"}
ENT.SoundTbl_Alert = {"Triceratops/TricCall01.wav"}
ENT.SoundTbl_MeleeAttack = {"Triceratops/TricCall01.wav"}
ENT.SoundTbl_Pain = {"Triceratops/TricCall01.wav"}
ENT.SoundTbl_Death = {"Triceratops/TricCall03.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(120, 40, 80), -Vector(50, 40, 0))
end


/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/