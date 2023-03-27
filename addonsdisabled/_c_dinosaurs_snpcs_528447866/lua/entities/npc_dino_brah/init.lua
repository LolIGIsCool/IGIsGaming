AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/npcs/dinosaurs/brachiosaurus/brachiosaurus.mdl" 
ENT.StartHealth = GetConVarNumber("vj_brah_h")
ENT.MoveType = MOVETYPE_STEP
ENT.HullType = HULL_LARGE
ENT.IsHugeMonster = true
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_FriendlyNPCsSingle = {"npc_dino_triceratops","npc_dino_hadrosaur","npc_dino_brah"}
ENT.Bleeds = true -- Does the SNPC bleed? (Blood decal, particle and etc.)
ENT.BloodParticle = "blood_impact_red_01" -- Particle that the SNPC spawns when it's damaged
ENT.BloodDecal = "Blood" -- (Red = Blood) (Yellow Blood = YellowBlood) | Leave blank for none
ENT.BloodDecalRate = 1000 -- The more the nuumber is the more chance is has to spawn | 500 is a good number | Make the number smaller if you are using big decal like Antlion Splat
ENT.HasCustomBloodPoolParticle = true -- Should the SNPC have custom blood pool particle?
ENT.CustomBloodPoolParticle = "vj_bleedout_red_small" -- The custom blood pool particle
ENT.ZombieFriendly = true -- Makes the SNPC friendly to the HL2 Zombies
ENT.AntlionFriendly = true -- Makes the SNPC friendly to the Antlions
ENT.CombineFriendly = true -- Makes the SNPC friendly to the Combine
ENT.PlayerFriendly = true -- When true, this will make it friendly to rebels and characters like that
ENT.BrokenBloodSpawnUp = 10 -- Positive Number = Up | Negative Number = Down
ENT.Immune_CombineBall = true
ENT.Immune_Physics = true
ENT.HasDeathRagdoll = false
ENT.HasFootStepSound = true -- Should the SNPC make a footstep sound when it's moving?
ENT.FootStepTimeRun = 1 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 2.3 -- Next foot step sound when it is walking
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

ENT.FootStepSoundLevel = 100
ENT.AlertSoundLevel = 150
ENT.PainSoundLevel = 150
ENT.DeathSoundLevel = 150
ENT.IdleSoundLevel = 150
ENT.MeleeAttackSoundLevel = 150
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomInitialize()
	self:SetCollisionBounds(Vector(170, 109, 795), -Vector(150, 100, 0))
end


/*-----------------------------------------------
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/