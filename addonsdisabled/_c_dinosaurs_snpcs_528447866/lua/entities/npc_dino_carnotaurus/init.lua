AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/animals/carnotaurus_npc.mdl" 
ENT.StartHealth = GetConVarNumber("vj_carno_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the number is the more chance is has to spawn | 1000 is a good number for yellow blood, for red blood 500 is good | Make the number smaller if you are using big decal like Antlion Splat, Which 5 or 10 is a really good number for this stuff
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1}
ENT.MeleeAttackDistance = 115 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 330 -- How far the damage goes
ENT.Immune_CombineBall = true
ENT.Immune_Physics = true
ENT.MeleeAttackHitTime = 0.6 -- This counted in seconds | This calculates the time until it hits something
ENT.UntilNextAttack_Melee = 0.5 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = GetConVarNumber("vj_carno_d")
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
ENT.SoundTbl_FootStep = {"stalker/creature/giant/giant_hit.wav"}
ENT.SoundTbl_Idle = {"carnotaurus/idle1.wav","carnotaurus/idle2.wav"}
ENT.SoundTbl_Alert = {"carnotaurus/roar.wav"}
ENT.SoundTbl_MeleeAttack = {"carnotaurus/idle1.wav"}
ENT.SoundTbl_Pain = {"t-rex/pain1.wav"}
ENT.SoundTbl_Death = {"stalker/creature/giant/die_0.wav","stalker/creature/giant/die_1.wav"}

function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(190, 50, 150), Vector(-50, -50, 0))
end


function ENT:CustomOnAlert()
	if self.VJ_IsBeingControlled == true then return end
	if math.random(1,2) == 1 then
		self.SoundTbl_Alert = {"carnotaurus/roar.wav"}
		self:VJ_ACT_PLAYACTIVITY(ACT_FLINCH_PHYSICS,true,2.84,true)
	else
		self.SoundTbl_Alert = {"carnotaurus/roar.wav"}
	end
end



/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/