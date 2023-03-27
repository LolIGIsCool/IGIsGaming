AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/defcon/loudmantis/npc/sentry.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 3000
ENT.HullType = HULL_LARGE
ENT.HasHull = true -- Set to false to disable HULL
ENT.HullSizeNormal = true -- set to false to cancel out the self:SetHullSizeNormal()
ENT.HasSetSolid = true -- set to false to disable SetSolid
ENT.IdleAlwaysWander = true -- If set to true, it will make the SNPC always wander when idling
ENT.DisableWandering = false -- Disables wandering when the SNPC is idle
	-- ====== Sight & Speed Variables ====== --
ENT.TurningSpeed = 4 -- How fast it can turn
ENT.VJ_IsHugeMonster = false -- Is this a huge monster?
	-- ====== Movement Code ====== --
	-- Types: VJ_MOVETYPE_GROUND | VJ_MOVETYPE_AERIAL | VJ_MOVETYPE_AQUATIC | VJ_MOVETYPE_STATIONARY | VJ_MOVETYPE_PHYSICS
ENT.MovementType = VJ_MOVETYPE_GROUND -- How does the SNPC move?
ENT.CanTurnWhileStationary = false -- If set to true, the SNPC will be able to turn while it's a stationary SNPC
	-- Blood & Damages ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.GodMode = false -- Immune to everything
	-- Relationships ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasAllies = true -- Put to false if you want it not to have any allies
ENT.VJ_NPC_Class = {"CLASS_COMBINE","CLASS_CIS_HOSTILE"} -- NPCs with the same class with be allied to each other
	-- ====== Miscellaneous Variables ====== --
ENT.HasEntitiesToNoCollide = true -- If set to false, it won't run the EntitiesToNoCollide code
ENT.EntitiesToNoCollide = {"npc_rollermine"} -- Entities to not collide with when HasEntitiesToNoCollide is set to true
	-- ====== Flinching Variables ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.FlinchDamageTypes = {DMG_BLAST} -- If it uses damage-based flinching, which types of damages should it flinch from?
ENT.FlinchChance = 7 -- Chance of it flinching from 1 to x | 1 will make it always flinch
ENT.AnimTbl_Flinch = {"Hit"} -- If it uses normal based animation, use this
	-- Range Attack ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.HasRangeAttack = true -- Should the SNPC have a range attack?
ENT.RangeDistance = 9999 -- This is how far away it can shoot
ENT.RangeAttackAnimationStopMovement = true -- Should it stop moving when performing a range attack?
ENT.AnimTbl_RangeAttack = {"Fire"} 
ENT.RangeAttackPos_Up = 65
ENT.RangeAttackPos_Right = 15
ENT.TimeUntilRangeAttackProjectileRelease = 0.3
ENT.NextRangeAttackTime = 3 -- How much time until it can use a range attack?
ENT.RangeToMeleeDistance = 30 -- How close does it have to be until it uses melee?
ENT.RangeAttackReps = 5
ENT.RangeAttackEntityToSpawn = "obj_vj_blaster" -- The entity that is spawned when range attacking--lunasflightschool_droidgunship_missile

	-- Miscellaneous ---------------------------------------------------------------------------------------------------------------------------------------------
ENT.AnimTbl_IdleStand = {ACT_IDLE} -- The idle animation when AI is enabled
ENT.AnimTbl_Walk = {ACT_WALK} -- Set the walking animations | Put multiple to let the base pick a random animation when it moves
ENT.AnimTbl_Run = {ACT_RUN}
-------------------------------------------------------------------------
-- ====== Idle Sound Variables ====== --
ENT.IdleSounds_PlayOnAttacks = false -- It will be able to continue and play idle sounds when it performs an attack
ENT.IdleSounds_NoRegularIdleOnAlerted = false -- if set to true, it will not play the regular idle sound table if the combat idle sound table is empty
	-- ====== Idle dialogue Sound Variables ====== --
	-- When an allied SNPC or a allied player is in range, the SNPC will play a different sound table. If the ally is a VJ SNPC and has dialogue answer sounds, it will respond to this SNPC
ENT.HasIdleDialogueSounds = true -- If set to false, it won't play the idle dialogue sounds
ENT.HasIdleDialogueAnswerSounds = false -- If set to false, it won't play the idle dialogue answer sounds
ENT.IdleDialogueDistance = 400 -- How close should the ally be for the SNPC to talk to the ally?
ENT.IdleDialogueCanTurn = false -- If set to false, it won't turn when a dialogue occurs
	-- ====== Miscellaneous Variables ====== --
ENT.AlertSounds_OnlyOnce = false -- After it plays it once, it will never play it again
ENT.BeforeMeleeAttackSounds_WaitTime = 0 -- Time until it starts playing the Before Melee Attack sounds
ENT.OnlyDoKillEnemyWhenClear = true -- If set to true, it will only play the OnKilledEnemy sound when there isn't any other enemies
	-- ====== Main Control Variables ====== --
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.HasIdleSounds = true -- If set to false, it won't play the idle sounds
ENT.HasInvestigateSounds = true -- If set to false, it won't play any sounds when it's investigating something
ENT.HasAlertSounds = true -- If set to false, it won't play the alert sounds
ENT.HasOnKilledEnemySound = true -- Should it play a sound when it kills an enemy?
ENT.HasPainSounds = true -- If set to false, it won't play the pain sounds
ENT.HasDeathSounds = true -- If set to false, it won't play the death sounds

ENT.HasSounds = true -- Put to false to disable ALL sounds!
ENT.SoundTbl_FootStep = {"dtd_e/fs_GEN_sBd_conc_BFsec_01.wav", "dtd_e/fs_GEN_sBd_conc_BFsec_02.wav"}
ENT.SoundTbl_Idle = {"dtd_e/Idle1.wav", "dtd_e/Idle2.wav", "dtd_e/Idle3.wav", "dtd_e/Idle4.wav"}
ENT.SoundTbl_Investigate = {"dtd_e/Investigate.wav"}
ENT.SoundTbl_CombatIdle = {"dtd_e/Combat1.wav", "dtd_e/Combat2.wav", "dtd_e/Combat3.wav", "dtd_e/Combat4.wav", "dtd_e/Combat5.wav", "dtd_e/Combat6.wav"}
ENT.SoundTbl_Alert = {"dtd_e/Alert1.wav", "dtd_e/Alert2.wav"}
ENT.SoundTbl_OnKilledEnemy = {"dtd_e/EnemyKilled.wav"}
ENT.SoundTbl_Pain = {"dtd_e/Pain1.wav", "dtd_e/Pain2.wav", "dtd_e/Pain3.wav", "dtd_e/Pain4.wav"}
ENT.SoundTbl_Death = {"dtd_e/Death.wav"}

ENT.FootStepSoundLevel = 80
ENT.IdleSoundLevel = 85
ENT.IdleDialogueSoundLevel = 85
ENT.CombatIdleSoundLevel = 85
ENT.InvestigateSoundLevel = 80
ENT.LostEnemySoundLevel = 75
ENT.AlertSoundLevel = 80
ENT.OnKilledEnemySoundLevel = 80
ENT.PainSoundLevel = 80
ENT.ImpactSoundLevel = 50
ENT.DamageByPlayerSoundLevel = 75
ENT.DeathSoundLevel = 80
-------------------------------------------------------------------------------------------------------obj_vj_paukvs
ENT.HasMeleeAttack = true -- How close does it have to be until it attacks?
ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 80 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.1 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 2 -- How much time until it can use a attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 200
ENT.AnimTbl_MeleeAttack = {"MeleeAttack"} -- Melee Attack Animations
ENT.MeleeAttackDamageType = DMG_SLASH -- Type of Damage

ENT.HasDeathAnimation = true -- Does it play an animation when it dies?
ENT.AnimTbl_Death = {"Death"} -- Death Animations
	-- To let the base automatically detect the animation duration, set this to false:
ENT.DeathAnimationTime = false -- Time until the SNPC spawns its corpse and gets removed
	   ------------------------------------------------------------------------------------------------------------

	   function ENT:CustomOnInitialize()

end

function ENT:RangeAttackCode_GetShootPos(TheProjectile)
	return (self:GetEnemy():GetPos() - self:LocalToWorld(Vector(1,1)))*5 + self:GetUp()*-300
end


function ENT:CustomOnKilled()
	if self:Health() <= 0 then

	local effectdataspk = EffectData()
	effectdataspk:SetOrigin(self:GetPos())
	effectdataspk:SetScale( 40 )
	util.Effect( "ManhackSparks", effectdataspk )
	local effectdataexp = EffectData()
	effectdataexp:SetOrigin(self:GetPos())
	effectdataexp:SetScale(1)
	util.Effect( "Explosion", effectdataexp )
	self:EmitSound( "dtd_e/Death.wav" )


		self:Remove()

	end
	




end



/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
