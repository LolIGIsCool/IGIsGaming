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
ENT.Model = {"models/krieg/galacticempire/navy/navytrooper/npc_male_01.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
	-- ====== Health ====== --
ENT.StartHealth = 15 -- The starting health of the NPC
	-- ====== Miscellaneous Variables ====== --
ENT.AllowPrintingInChat = false -- Should this SNPC be allowed to post in player's chat? Example: "Blank no longer likes you."
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI / Relationship Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_IMP"}
	-- ====== Player Relationships ====== --
ENT.FriendsWithAllPlayerAllies = false
ENT.PlayerFriendly = false
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
ENT.SoundTbl_FootStep = {"kstrudel/imps/boot_walk1.wav","kstrudel/imps/boot_walk2.wav",
						"kstrudel/imps/boot_walk3.wav","kstrudel/imps/boot_walk4.wav"}
ENT.SoundTbl_Breath = {}
ENT.SoundTbl_Idle = {"kstrudel/imps/gunner/idle/idle_1.wav",
					"kstrudel/imps/gunner/idle/idle_2.wav",
					"kstrudel/imps/gunner/idle/idle_3.wav",
					"kstrudel/imps/gunner/idle/idle_4.wav",
					"kstrudel/imps/gunner/idle/idle_5.wav",
					"kstrudel/imps/gunner/idle/idle_6.wav",
					"kstrudel/imps/gunner/idle/idle_7.wav",
					"kstrudel/imps/gunner/idle/idle_8.wav",
					"kstrudel/imps/gunner/idle/idle_9.wav",
					"kstrudel/imps/gunner/idle/idle_10.wav",
					"kstrudel/imps/gunner/idle/idle_11.wav",
					"kstrudel/imps/gunner/idle/idle_12.wav",
					"kstrudel/imps/gunner/idle/idle_13.wav",
					"kstrudel/imps/gunner/idle/idle_14.wav",
					"kstrudel/imps/gunner/idle/idle_15.wav"}
ENT.SoundTbl_CombatIdle = {"kstrudel/imps/gunner/combatidle/combatidle_1.wav",
						"kstrudel/imps/gunner/combatidle/combatidle_2.wav",
						"kstrudel/imps/gunner/combatidle/combatidle_3.wav"}
ENT.SoundTbl_FollowPlayer = {}
ENT.SoundTbl_UnFollowPlayer = {}
ENT.SoundTbl_MoveOutOfPlayersWay = {}
ENT.SoundTbl_MedicBeforeHeal = {}
ENT.SoundTbl_MedicAfterHeal = {}
ENT.SoundTbl_MedicReceiveHeal = {}
ENT.SoundTbl_OnPlayerSight = {"kstrudel/imps/gunner/onplayersight/onplayersight_1.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_2.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_3.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_4.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_5.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_6.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_7.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_8.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_9.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_10.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_11.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_12.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_13.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_14.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_15.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_16.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_17.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_18.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_19.wav"}
ENT.SoundTbl_Investigate = {"kstrudel/imps/gunner/investigate/investigate_1.wav",
							"kstrudel/imps/gunner/investigate/investigate_2.wav",
							"kstrudel/imps/gunner/investigate/investigate_3.wav",
							"kstrudel/imps/gunner/investigate/investigate_4.wav",
							"kstrudel/imps/gunner/investigate/investigate_5.wav",
							"kstrudel/imps/gunner/investigate/investigate_6.wav",
							"kstrudel/imps/gunner/investigate/investigate_7.wav",
							"kstrudel/imps/gunner/investigate/investigate_8.wav",
							"kstrudel/imps/gunner/investigate/investigate_9.wav",
							"kstrudel/imps/gunner/investigate/investigate_10.wav"}
ENT.SoundTbl_Alert = {"kstrudel/imps/gunner/alert/alert_1.wav",
					"kstrudel/imps/gunner/alert/alert_2.wav",
					"kstrudel/imps/gunner/alert/alert_3.wav",
					"kstrudel/imps/gunner/alert/alert_4.wav",
					"kstrudel/imps/gunner/alert/alert_5.wav",
					"kstrudel/imps/gunner/alert/alert_6.wav",
					"kstrudel/imps/gunner/alert/alert_7.wav",
					"kstrudel/imps/gunner/alert/alert_8.wav",
					"kstrudel/imps/gunner/alert/alert_9.wav",
					"kstrudel/imps/gunner/alert/alert_10.wav",
					"kstrudel/imps/gunner/alert/alert_11.wav",
					"kstrudel/imps/gunner/alert/alert_12.wav"}
ENT.SoundTbl_CallForHelp = {"kstrudel/imps/gunner/callforhelp/callforhelp_1.wav",
							"kstrudel/imps/gunner/callforhelp/callforhelp_1.wav",
							"kstrudel/imps/gunner/callforhelp/callforhelp_1.wav"}
ENT.SoundTbl_BecomeEnemyToPlayer = {"kstrudel/imps/gunner/onplayersight/onplayersight_1.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_2.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_3.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_4.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_5.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_6.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_7.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_8.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_9.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_10.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_11.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_12.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_13.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_14.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_15.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_16.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_17.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_18.wav",
							"kstrudel/imps/gunner/onplayersight/onplayersight_19.wav"}
ENT.SoundTbl_Suppressing = {"kstrudel/imps/gunner/suppressing/suppressing_1.wav",
							"kstrudel/imps/gunner/suppressing/suppressing_2.wav",
							"kstrudel/imps/gunner/suppressing/suppressing_3.wav",
							"kstrudel/imps/gunner/suppressing/suppressing_4.wav",
							"kstrudel/imps/gunner/suppressing/suppressing_5.wav",
							"kstrudel/imps/gunner/suppressing/suppressing_6.wav",
							"kstrudel/imps/gunner/suppressing/suppressing_7.wav",
							"kstrudel/imps/gunner/suppressing/suppressing_8.wav",
							"kstrudel/imps/gunner/suppressing/suppressing_9.wav",
							"kstrudel/imps/gunner/suppressing/suppressing_10.wav"}
ENT.SoundTbl_WeaponReload = {}
ENT.SoundTbl_BeforeMeleeAttack = {}
ENT.SoundTbl_MeleeAttack = {}
ENT.SoundTbl_MeleeAttackExtra = {}
ENT.SoundTbl_MeleeAttackMiss = {}
ENT.SoundTbl_GrenadeAttack = {"kstrudel/imps/gunner/grenadeattack/grenadeattack_1.wav",
							"kstrudel/imps/gunner/grenadeattack/grenadeattack_2.wav",
							"kstrudel/imps/gunner/grenadeattack/grenadeattack_3.wav",
							"kstrudel/imps/gunner/grenadeattack/grenadeattack_4.wav"}

ENT.SoundTbl_OnGrenadeSight = {"kstrudel/imps/gunner/grenadesight/grenadesight_1.wav"}
ENT.SoundTbl_OnKilledEnemy = {}
ENT.SoundTbl_Pain = {"kstrudel/imps/gunner/pain/pain_1.wav",
					"kstrudel/imps/gunner/pain/pain_2.wav",
					"kstrudel/imps/gunner/pain/pain_3.wav",
					"kstrudel/imps/gunner/pain/pain_4.wav",
					"kstrudel/imps/gunner/pain/pain_5.wav",
					"kstrudel/imps/gunner/pain/pain_6.wav",
					"kstrudel/imps/gunner/pain/pain_7.wav",
					"kstrudel/imps/gunner/pain/pain_8.wav",
					"kstrudel/imps/gunner/pain/pain_9.wav",
					"kstrudel/imps/gunner/pain/pain_10.wav",
					"kstrudel/imps/gunner/pain/pain_11.wav",
					"kstrudel/imps/gunner/pain/pain_12.wav",
					"kstrudel/imps/gunner/pain/pain_13.wav",
					"kstrudel/imps/gunner/pain/pain_14.wav",
					"kstrudel/imps/gunner/pain/pain_15.wav",
					"kstrudel/imps/gunner/pain/pain_16.wav",
					"kstrudel/imps/gunner/pain/pain_17.wav",
					"kstrudel/imps/gunner/pain/pain_18.wav"}
ENT.SoundTbl_Impact = {}
ENT.SoundTbl_DamageByPlayer = {"kstrudel/imps/gunner/pain/pain_1.wav",
					"kstrudel/imps/gunner/pain/pain_2.wav",
					"kstrudel/imps/gunner/pain/pain_3.wav",
					"kstrudel/imps/gunner/pain/pain_4.wav",
					"kstrudel/imps/gunner/pain/pain_5.wav",
					"kstrudel/imps/gunner/pain/pain_6.wav",
					"kstrudel/imps/gunner/pain/pain_7.wav",
					"kstrudel/imps/gunner/pain/pain_8.wav",
					"kstrudel/imps/gunner/pain/pain_9.wav",
					"kstrudel/imps/gunner/pain/pain_10.wav",
					"kstrudel/imps/gunner/pain/pain_11.wav",
					"kstrudel/imps/gunner/pain/pain_12.wav",
					"kstrudel/imps/gunner/pain/pain_13.wav",
					"kstrudel/imps/gunner/pain/pain_14.wav",
					"kstrudel/imps/gunner/pain/pain_15.wav",
					"kstrudel/imps/gunner/pain/pain_16.wav",
					"kstrudel/imps/gunner/pain/pain_17.wav",
					"kstrudel/imps/gunner/pain/pain_18.wav"}
ENT.SoundTbl_Death = {"kstrudel/imps/gunner/death/death_1.wav",
					"kstrudel/imps/gunner/death/death_2.wav",
					"kstrudel/imps/gunner/death/death_3.wav",
					"kstrudel/imps/gunner/death/death_4.wav",
					"kstrudel/imps/gunner/death/death_5.wav",
					"kstrudel/imps/gunner/death/death_6.wav",
					"kstrudel/imps/gunner/death/death_7.wav",
					"kstrudel/imps/gunner/death/death_8.wav",
					"kstrudel/imps/gunner/death/death_9.wav",
					"kstrudel/imps/gunner/death/death_10.wav"}
					
					
function ENT:CustomOnInitialize() --[[Imperial Navy Trooper Bodygroups]]--
	if math.random(1,0) == 1 then
		self:SetBodygroup(0,math.random(0,5)) -- Heads
		self:SetBodygroup(1,math.random(3,3)) -- Headwear
		self:SetBodygroup(2,math.random(3,3)) -- Uniform
		self:SetBodygroup(3,math.random(0,0)) -- Code Cylinder 1
		self:SetBodygroup(4,math.random(0,0)) -- Code Cylinder 2
		self:SetBodygroup(5,math.random(0,0)) -- Code Cylinder 3
		self:SetBodygroup(6,math.random(0,0)) -- Code Cylinder 4
		self:SetBodygroup(7,math.random(0,6)) -- Belt Boxes
		self:SetBodygroup(8,math.random(1,1)) -- Gunner Bib
		self:SetBodygroup(9,math.random(0,1)) -- Holster
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
--CUSTOM VARIABLES



	-- ====== Item Drops On Death Variables ====== --
ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropsOnDeathChance = 4 -- If set to 1, it will always drop it
ENT.ItemDropsOnDeath_EntityList = {"obj_vjks_beltbox"} -- List of items it will randomly pick from | Leave it empty to drop nothing or to make your own dropping code (Using CustomOn...)
ENT.DropWeaponOnDeath = true -- Should it drop its weapon on death?
ENT.DropWeaponOnDeathAttachment = "anim_attachment_RH" -- Which attachment should it use for the weapon's position





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


