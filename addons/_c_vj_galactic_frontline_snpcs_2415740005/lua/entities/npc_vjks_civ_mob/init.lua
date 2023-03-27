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
ENT.Model = {"models/KriegSyntax/scum_and_villany/human/npc_male_01.mdl","models/KriegSyntax/scum_and_villany/human_jumpsuit/npc_male_01.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
	-- ====== Health ====== --
ENT.StartHealth = 25 -- The starting health of the NPC
	-- ====== Miscellaneous Variables ====== --
ENT.AllowPrintingInChat = false -- Should this SNPC be allowed to post in player's chat? Example: "Blank no longer likes you."
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI / Relationship Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_CIV"}
	-- ====== Player Relationships ====== --
ENT.FriendsWithAllPlayerAllies = true
ENT.PlayerFriendly = true

ENT.Behavior = VJ_BEHAVIOR_NEUTRAL -- The behavior of the SNPC
ENT.BecomeEnemyToPlayer = true -- Should the friendly SNPC become enemy towards the player if it's damaged by it or it witnesses another ally killed by it
ENT.BecomeEnemyToPlayerLevel = 2

ENT.RunAwayOnUnknownDamage = true -- Should run away on damage
ENT.NextRunAwayOnDamageTime = 5 -- Until next run after being shot when not alerted

	-- ====== Move Or Hide On Damage Variables ====== --
ENT.MoveOrHideOnDamageByEnemy = true -- Should the SNPC move or hide when being damaged by an enemy?
ENT.MoveOrHideOnDamageByEnemy_OnlyMove = true -- Should it only move and not hide?
ENT.MoveOrHideOnDamageByEnemy_HideTime = VJ_Set(3, 4) -- How long should it hide?
ENT.NextMoveOrHideOnDamageByEnemy1 = 3 -- How much time until it moves or hides on damage by enemy? | The first # in math.random
ENT.NextMoveOrHideOnDamageByEnemy2 = 3.5 -- How much time until it moves or hides on damage by enemy? | The second # in math.random

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
ENT.SoundTbl_FootStep = {"npc/metropolice/gear1.wav",
						"npc/metropolice/gear2.wav",
						"npc/metropolice/gear3.wav",
						"npc/metropolice/gear4.wav",
						"npc/metropolice/gear5.wav",
						"npc/metropolice/gear6.wav"}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {"kstrudel/scum/human/idle/idle 1.wav",
					"kstrudel/scum/human/idle/idle 2.wav",
					"kstrudel/scum/human/idle/idle 3.wav",
					"kstrudel/scum/human/idle/idle 4.wav",
					"kstrudel/scum/human/idle/idle 5.wav",
					"kstrudel/scum/human/idle/idle 6.wav",
					"kstrudel/scum/human/idle/idle 7.wav",
					"kstrudel/scum/human/idle/idle 8.wav",
					"kstrudel/scum/human/idle/idle 9.wav",
					"kstrudel/scum/human/idle/idle 10.wav",
					"kstrudel/scum/human/idle/idle 11.wav",
					"kstrudel/scum/human/idle/idle 12.wav",
					"kstrudel/scum/human/idle/idle 13.wav"}
ENT.SoundTbl_CombatIdle = {"kstrudel/scum/human/idle/idle 1.wav",
					"kstrudel/scum/human/idle/idle 2.wav",
					"kstrudel/scum/human/idle/idle 3.wav",
					"kstrudel/scum/human/idle/idle 4.wav",
					"kstrudel/scum/human/idle/idle 5.wav",
					"kstrudel/scum/human/idle/idle 6.wav",
					"kstrudel/scum/human/idle/idle 7.wav",
					"kstrudel/scum/human/idle/idle 8.wav",
					"kstrudel/scum/human/idle/idle 9.wav",
					"kstrudel/scum/human/idle/idle 10.wav",
					"kstrudel/scum/human/idle/idle 11.wav",
					"kstrudel/scum/human/idle/idle 12.wav",
					"kstrudel/scum/human/idle/idle 13.wav"}
ENT.SoundTbl_OnReceiveOrder = {"kstrudel/scum/human/onrecievingorder/onrecievingorder 1.wav",
					"kstrudel/scum/human/onrecievingorder/onrecievingorder 2.wav",
					"kstrudel/scum/human/onrecievingorder/onrecievingorder 3.wav",
					"kstrudel/scum/human/onrecievingorder/onrecievingorder 4.wav",
					"kstrudel/scum/human/onrecievingorder/onrecievingorder 5.wav",
					"kstrudel/scum/human/onrecievingorder/onrecievingorder 6.wav",
					"kstrudel/scum/human/onrecievingorder/onrecievingorder 7.wav"}
ENT.SoundTbl_FollowPlayer = {}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_MoveOutOfPlayersWay = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {}
ENT.SoundTbl_Investigate = {}
ENT.SoundTbl_Alert = {"kstrudel/scum/human/alert/alert 1.wav",
					"kstrudel/scum/human/alert/alert 2.wav",
					"kstrudel/scum/human/alert/alert 3.wav",
					"kstrudel/scum/human/alert/alert 4.wav",
					"kstrudel/scum/human/alert/alert 5.wav",
					"kstrudel/scum/human/alert/alert 6.wav",
					"kstrudel/scum/human/alert/alert 7.wav",
					"kstrudel/scum/human/alert/alert 8.wav",
					"kstrudel/scum/human/alert/alert 9.wav",
					"kstrudel/scum/human/alert/alert 10.wav"}
ENT.SoundTbl_CallForHelp = {}
ENT.SoundTbl_BecomeEnemyToPlayer = {}
ENT.SoundTbl_Suppressing = {"kstrudel/scum/human/suppressing/suppressing 1.wav",
					"kstrudel/scum/human/suppressing/suppressing 2.wav",
					"kstrudel/scum/human/suppressing/suppressing 3.wav",
					"kstrudel/scum/human/suppressing/suppressing 4.wav",
					"kstrudel/scum/human/suppressing/suppressing 5.wav",
					"kstrudel/scum/human/suppressing/suppressing 6.wav",
					"kstrudel/scum/human/suppressing/suppressing 7.wav",
					"kstrudel/scum/human/suppressing/suppressing 8.wav",
					"kstrudel/scum/human/suppressing/suppressing 9.wav"}
ENT.SoundTbl_WeaponReload = {"kstrudel/scum/human/Reloading/Reloading 1.wav",
					"kstrudel/scum/human/Reloading/Reloading 2.wav",
					"kstrudel/scum/human/Reloading/Reloading 3.wav",
					"kstrudel/scum/human/Reloading/Reloading 4.wav",
					"kstrudel/scum/human/Reloading/Reloading 5.wav",
					"kstrudel/scum/human/Reloading/Reloading 6.wav",
					"kstrudel/scum/human/Reloading/Reloading 7.wav",
					"kstrudel/scum/human/Reloading/Reloading 8.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {}

ENT.SoundTbl_OnGrenadeSight = {}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_Pain = {"kstrudel/scum/human/pain/pain 1.wav",
					"kstrudel/scum/human/pain/pain 2.wav",
					"kstrudel/scum/human/pain/pain 3.wav",
					"kstrudel/scum/human/pain/pain 4.wav",
					"kstrudel/scum/human/pain/pain 5.wav",
					"kstrudel/scum/human/pain/pain 6.wav",
					"kstrudel/scum/human/pain/pain 7.wav",
					"kstrudel/scum/human/pain/pain 8.wav",
					"kstrudel/scum/human/pain/pain 9.wav",
					"kstrudel/scum/human/pain/pain 10.wav",
					"kstrudel/scum/human/pain/pain 11.wav",
					"kstrudel/scum/human/pain/pain 12.wav",
					"kstrudel/scum/human/pain/pain 13.wav"}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {}
ENT.SoundTbl_Death = {"kstrudel/scum/human/death/death 1.wav",
					"kstrudel/scum/human/death/death 2.wav",
					"kstrudel/scum/human/death/death 3.wav",
					"kstrudel/scum/human/death/death 4.wav",
					"kstrudel/scum/human/death/death 5.wav",
					"kstrudel/scum/human/death/death 6.wav",
					"kstrudel/scum/human/death/death 7.wav",
					"kstrudel/scum/human/death/death 8.wav",
					"kstrudel/scum/human/death/death 9.wav",
					"kstrudel/scum/human/death/death 10.wav"}
					
					
function ENT:CustomOnInitialize()
	if math.random(1,0) == 1 then
		self:SetSkin(math.random(0,5))
		self:SetBodygroup(0,math.random(5,7))
		self:SetBodygroup(2,math.random(0,18))
		self:SetBodygroup(3,math.random(0,1))
		self:SetBodygroup(4,math.random(0,8))
		self:SetBodygroup(5,math.random(2,2))
		self:SetBodygroup(6,math.random(0,2))
		self:SetBodygroup(7,math.random(3,3))
		self:SetBodygroup(8,math.random(3,3))
	end
end	

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
--CUSTOM VARIABLES


ENT.HasGrenadeAttack = false -- Should the SNPC have a grenade attack?
ENT.GrenadeAttackEntity = "obj_vjks_beltbox" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.GrenadeAttackModel = "models/krieg/galacticempire/props/mag_medium.mdl" -- Picks a random model from this table to override the model of the grenade



ENT.NextThrowGrenadeTime = VJ_Set(10, 15) -- Time until it can throw a grenade again
ENT.ThrowGrenadeChance = 1 -- Chance that it will throw the grenade | Set to 1 to throw all the time
ENT.GrenadeAttackThrowDistance = 1500 -- How far it can throw grenades
ENT.GrenadeAttackThrowDistanceClose = 400 -- How close until it stops throwing grenades




	-- ====== Item Drops On Death Variables ====== --
ENT.HasItemDropsOnDeath = false -- Should it drop items on death?
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?

--Misc
ENT.HasHelmetDrop = false
ENT.CanChangeAlertAnim = false
--Weapons
ENT.CanUseSecondaryweapon = false
ENT.Reloadwhenidle = false
ENT.Reloadwhenattacking = false
ENT.CanForceWeaponFire = false
ENT.CanBlindFireCover = false
ENT.CanProneCover = false
--Grenades
ENT.CanSmartDetectGrenades = true
ENT.CanDoSmartGrenadeThrow = true
ENT.CanDoGrenadeThrowHigh = true
ENT.CanThrowBlindGrenade = true
ENT.CanUseSpecialGrenade = false
--Weapons Melee
ENT.CanPerformMeleeCharge = true
ENT.MeleeCharge_dmg = 1
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


