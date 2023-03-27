if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
AddCSLuaFile("shared.lua")
include("shared.lua")
/*--------------------------------------------------
	*** Copyright (c) 2012-2022 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AccessorFunc(ENT, "m_iClass", "NPCClass", FORCE_NUMBER)
AccessorFunc(ENT, "m_fMaxYawSpeed", "MaxYawSpeed", FORCE_NUMBER)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ Core Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.Model = {"models/KriegSyntax/rebel/navy/fleet_crew_bridge/npc_male_01.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
	-- ====== Health ====== --
ENT.StartHealth = 10 -- The starting health of the NPC
	-- ====== Miscellaneous Variables ====== --
ENT.AllowPrintingInChat = false -- Should this SNPC be allowed to post in player's chat? Example: "Blank no longer likes you."
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI / Relationship Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_REBF"}
	-- ====== Player Relationships ====== --
ENT.FriendsWithAllPlayerAllies = true
ENT.PlayerFriendly = true
	-- ====== Medic Variables ====== --
ENT.IsMedicSNPC = false
	-- ====== Movement & Idle Variables ====== --
ENT.AnimTbl_IdleStand = {}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI / Sound Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.FlinchChance = 1 -- Chance of it flinching from 1 to x | 1 will make it always flinch
	-- ====== File Path Variables ====== --
	-- Leave blank if you don't want any sounds to play
ENT.DeathSoundLevel = 100
ENT.SoundTbl_FootStep = {"kstrudel/rebels/boot_walk1.wav","kstrudel/rebels/boot_walk2.wav",
						"kstrudel/rebels/boot_walk3.wav","kstrudel/rebels/boot_walk4.wav"}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {}
ENT.SoundTbl_CombatIdle = {"kstrudel/rebels/rebel2/lost1.wav",
						"kstrudel/rebels/rebel2/sight1.wav",
						"kstrudel/rebels/rebel2/sight2.wav"}
ENT.SoundTbl_OnReceiveOrder = {"kstrudel/rebels/rebel2/cover5.wav"}
ENT.SoundTbl_FollowPlayer = {}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_MoveOutOfPlayersWay = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {"kstrudel/rebels/rebel2/anger1.wav",
							"kstrudel/rebels/rebel2/anger2.wav",
							"kstrudel/rebels/rebel2/anger3.wav",
							"kstrudel/rebels/rebel2/detected1.wav",
							"kstrudel/rebels/rebel2/detected2.wav",
							"kstrudel/rebels/rebel2/detected3.wav",
							"kstrudel/rebels/rebel2/detected5.wav",
							"kstrudel/rebels/rebel2/ffwarn.wav"}
ENT.SoundTbl_Investigate = {"kstrudel/rebels/rebel2/confuse3.wav",
							"kstrudel/rebels/rebel2/suspicious5.wav",
							"kstrudel/rebels/rebel2/sound1.wav",
							"kstrudel/rebels/rebel2/sound2.wav",
							"kstrudel/rebels/rebel2/sound3.wav",
							"kstrudel/rebels/rebel2/suspicious4.wav",
							"kstrudel/rebels/rebel2/suspicious3.wav"}
ENT.SoundTbl_Alert = {"kstrudel/rebels/rebel2/anger1.wav",
					"kstrudel/rebels/rebel2/anger2.wav",
					"kstrudel/rebels/rebel2/anger3.wav",
					"kstrudel/rebels/rebel2/detected1.wav",
					"kstrudel/rebels/rebel2/detected3.wav",
					"kstrudel/rebels/rebel2/detected5.wav",
					"kstrudel/rebels/rebel2/ffturn.wav"}
ENT.SoundTbl_CallForHelp = {"kstrudel/rebels/rebel2/cover4.wav",
							"kstrudel/rebels/rebel2/cover1.wav",
							"kstrudel/rebels/rebel2/detected5.wav"}
ENT.SoundTbl_BecomeEnemyToPlayer = {"kstrudel/rebels/rebel2/anger1.wav",
							"kstrudel/rebels/rebel2/anger2.wav",
							"kstrudel/rebels/rebel2/anger3.wav",
							"kstrudel/rebels/rebel2/detected1.wav",
							"kstrudel/rebels/rebel2/detected2.wav",
							"kstrudel/rebels/rebel2/detected3.wav",
							"kstrudel/rebels/rebel2/detected5.wav",
							"kstrudel/rebels/rebel2/ffwarn.wav"}
ENT.SoundTbl_Suppressing = {"kstrudel/rebels/rebel2/chase1.wav",
							"kstrudel/rebels/rebel2/chase3.wav",
							"kstrudel/rebels/rebel2/cover4.wav",
							"kstrudel/rebels/rebel2/cover1.wav"}
ENT.SoundTbl_WeaponReload = {}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {"kstrudel/rebels/rebel2/cover2.wav"}

ENT.SoundTbl_OnGrenadeSight = {"kstrudel/rebels/rebel2/cover3.wav",
							"kstrudel/rebels/rebel2/cover2.wav"}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_Pain = {"kstrudel/rebels/rebel2/pain25.wav",
					"kstrudel/rebels/rebel2/pain50.wav",
					"kstrudel/rebels/rebel2/pain75.wav",
					"kstrudel/rebels/rebel2/pain100.wav",
					"kstrudel/rebels/rebel2/gasp.wav",
					"kstrudel/rebels/rebel2/choke1.wav",
					"kstrudel/rebels/rebel2/choke2.wav",
					"kstrudel/rebels/rebel2/choke3.wav"}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {"kstrudel/rebels/rebel2/pain25.wav",
					"kstrudel/rebels/rebel2/pain50.wav",
					"kstrudel/rebels/rebel2/pain75.wav",
					"kstrudel/rebels/rebel2/pain100.wav",
					"kstrudel/rebels/rebel2/gasp.wav",
					"kstrudel/rebels/rebel2/choke1.wav",
					"kstrudel/rebels/rebel2/choke2.wav",
					"kstrudel/rebels/rebel2/choke3.wav"}
ENT.SoundTbl_Death = {"kstrudel/rebels/rebel2/death1.wav",
					"kstrudel/rebels/rebel2/death2.wav",
					"kstrudel/rebels/rebel2/death3.wav"}
					
					
					
function ENT:CustomOnInitialize()
	if math.random(1,0) == 1 then
		self:SetBodygroup(0,math.random(0,1))
		self:SetBodygroup(2,math.random(0,18))
		self:SetBodygroup(3,math.random(0,1))
		self:SetBodygroup(4,math.random(0,12))
		self:SetBodygroup(5,math.random(0,1))
		self:SetBodygroup(7,math.random(0,1))
		self:SetBodygroup(8,math.random(0,1))
		self:SetBodygroup(9,math.random(1,1))
	end
end	



---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
--CUSTOM VARIABLES

ENT.HasGrenadeAttack = false

--Misc
ENT.HasHelmetDrop = false
ENT.CanChangeAlertAnim = true
--Weapons
ENT.CanUseSecondaryweapon = false
ENT.Reloadwhenidle = false
ENT.Reloadwhenattacking = false
ENT.CanForceWeaponFire = true
ENT.CanBlindFireCover = false
ENT.CanProneCover = false
--Grenades
ENT.CanSmartDetectGrenades = true
ENT.CanDoSmartGrenadeThrow = true
ENT.CanDoGrenadeThrowHigh = true
ENT.CanThrowBlindGrenade = true
ENT.CanUseSpecialGrenade = false
--Weapons Melee
ENT.CanPerformMeleeCharge = false
--Logic
ENT.CanThrowMedkit = false


--Class
ENT.vj_doi_isofficer = false
ENT.vj_doi_isprivate = true


---Commanders
ENT.CanCommandSoldiers = false
ENT.Commanding_chance = 1
ENT.Commanding_range = 500 --500 for Sergeants  ||  1500 for Officers  ||  1000000 for Generals
ENT.Commanding_maxsoldier = 6 --This should change per commander (6 for Sergeants, 15 for Officers, 100 for Generals)
ENT.AnimTbl_CommandingAttack = {"ks_signal_advance","ks_signal_forward"}
ENT.AnimTbl_CommandingFlank = {"ks_signal_left","ks_signal_right"}
ENT.AnimTbl_CommandingDefend = {"ks_signal_rally","ks_signal_laylow","ks_signal_halt"}


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Dismemberment/Gib Variables ====== --
ENT.AllowedToGib = false -- Is it allowed to gib in general? This can be on death or when shot in a certain place
ENT.HasGibOnDeath = false -- Is it allowed to gib on death?
ENT.GibOnDeathDamagesTable = {} -- Damages that it gibs from | "UseDefault" = Uses default damage types | "All" = Gib from any damage
ENT.HasGibOnDeathSounds = false -- Does it have gib sounds? | Mostly used for the settings menu
ENT.HasGibDeathParticles = false -- Does it spawn particles on death or when it gibs? | Mostly used for the settings menu

---------------------------------------------------------------------------------------------------------------------------------------------



/*--------------------------------------------------
	=============== Human SNPC Base ===============
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to make human SNPCs
--------------------------------------------------*/


