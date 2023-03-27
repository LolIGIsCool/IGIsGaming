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
ENT.Model = {"models/krieg/galacticempire/stormtroopers/shoretrooper/npc_male_01.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
	-- ====== Health ====== --
ENT.StartHealth = 75 -- The starting health of the NPC
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
ENT.DeathSoundLevel = 100
ENT.SoundTbl_FootStep = {"krieg/walk_trooper_1.wav",
						"krieg/walk_trooper_2.wav",
						"krieg/walk_trooper_3.wav",
						"krieg/walk_trooper_4.wav"}

ENT.SoundTbl_Idle = {"krieg/voice/commando_radio_1.ogg",
					"krieg/voice/commando_radio_2.ogg",
					"krieg/voice/commando_radio_3.ogg",
					"krieg/voice/commando_radio_4.ogg",
					"krieg/voice/commando_radio_5.ogg",
					"krieg/voice/commando_radio_6.ogg",
					"krieg/voice/commando_radio_7.ogg"}

ENT.SoundTbl_Alert = {"krieg/voice/sith/trooper/onenemysight/1.wav",
							"krieg/voice/sith/trooper/onenemysight/2.wav",
							"krieg/voice/sith/trooper/onenemysight/3.wav",
							"krieg/voice/sith/trooper/onenemysight/4.wav",
							"krieg/voice/sith/trooper/onenemysight/5.wav",
							"krieg/voice/sith/trooper/onenemysight/6.wav",
							"krieg/voice/sith/trooper/onenemysight/7.wav",
							"krieg/voice/sith/trooper/onenemysight/8.wav",
							"krieg/voice/sith/trooper/onenemysight/9.wav",
							"krieg/voice/sith/trooper/onenemysight/10.wav",
							"krieg/voice/sith/trooper/onenemysight/11.wav",
							"krieg/voice/sith/trooper/onenemysight/12.wav",
							"krieg/voice/sith/trooper/onenemysight/13.wav",
							"krieg/voice/sith/trooper/onenemysight/14.wav",
							"krieg/voice/sith/trooper/onenemysight/15.wav",
							"krieg/voice/sith/trooper/onenemysight/16.wav",
							"krieg/voice/sith/trooper/onenemysight/17.wav",
							"krieg/voice/sith/trooper/onenemysight/18.wav",
							"krieg/voice/sith/trooper/onenemysight/19.wav",
							"krieg/voice/sith/trooper/onenemysight/20.wav"}

ENT.SoundTbl_OnGrenadeSight = {"krieg/voice/sith/trooper/grenade_sighted/1.wav",
								"krieg/voice/sith/trooper/grenade_sighted/2.wav",
								"krieg/voice/sith/trooper/grenade_sighted/3.wav",
								"krieg/voice/sith/trooper/grenade_sighted/4.wav",
								"krieg/voice/sith/trooper/grenade_sighted/5.wav",
								"krieg/voice/sith/trooper/grenade_sighted/6.wav",
								"krieg/voice/sith/trooper/grenade_sighted/7.wav",
								"krieg/voice/sith/trooper/grenade_sighted/8.wav",
								"krieg/voice/sith/trooper/grenade_sighted/9.wav",
								"krieg/voice/sith/trooper/grenade_sighted/10.wav",
								"krieg/voice/sith/trooper/grenade_sighted/11.wav"}

ENT.SoundTbl_Pain = {"krieg/voice/sith/trooper/pain/1.wav",
					"krieg/voice/sith/trooper/pain/2.wav",
					"krieg/voice/sith/trooper/pain/3.wav",
					"krieg/voice/sith/trooper/pain/4.wav",
					"krieg/voice/sith/trooper/pain/5.wav",
					"krieg/voice/sith/trooper/pain/6.wav",
					"krieg/voice/sith/trooper/pain/7.wav",
					"krieg/voice/sith/trooper/pain/8.wav",
					"krieg/voice/sith/trooper/pain/9.wav",
					"krieg/voice/sith/trooper/pain/10.wav",
					"krieg/voice/sith/trooper/pain/11.wav",
					"krieg/voice/sith/trooper/pain/12.wav",
					"krieg/voice/sith/trooper/pain/13.wav",
					"krieg/voice/sith/trooper/pain/14.wav",
					"krieg/voice/sith/trooper/pain/15.wav",
					"krieg/voice/sith/trooper/pain/16.wav",
					"krieg/voice/sith/trooper/pain/17.wav",
					"krieg/voice/sith/trooper/pain/18.wav",
					"krieg/voice/sith/trooper/pain/19.wav",
					"krieg/voice/sith/trooper/pain/20.wav",
					"krieg/voice/sith/trooper/pain/21.wav",
					"krieg/voice/sith/trooper/pain/22.wav",
					"krieg/voice/sith/trooper/pain/23.wav",
					"krieg/voice/sith/trooper/pain/24.wav",
					"krieg/voice/sith/trooper/pain/25.wav",
					"krieg/voice/sith/trooper/pain/26.wav",
					"krieg/voice/sith/trooper/pain/27.wav"}

ENT.SoundTbl_Death = {"krieg/voice/sith/trooper/death/1.ogg",
					"krieg/voice/sith/trooper/death/2.ogg",
					"krieg/voice/sith/trooper/death/3.ogg",
					"krieg/voice/sith/trooper/death/4.ogg",
					"krieg/voice/sith/trooper/death/5.ogg",
					"krieg/voice/sith/trooper/death/6.ogg",
					"krieg/voice/sith/trooper/death/7.ogg",
					"krieg/voice/sith/trooper/death/8.ogg",
					"krieg/voice/sith/trooper/death/9.ogg",
					"krieg/voice/sith/trooper/death/10.ogg",
					"krieg/voice/sith/trooper/death/11.ogg",
					"krieg/voice/sith/trooper/death/12.ogg",
					"krieg/voice/sith/trooper/death/13.ogg",
					"krieg/voice/sith/trooper/death/14.ogg",
					"krieg/voice/sith/trooper/death/15.ogg",
					"krieg/voice/sith/trooper/death/16.ogg",
					"krieg/voice/sith/trooper/death/17.ogg",
					"krieg/voice/sith/trooper/death/18.ogg",
					"krieg/voice/sith/trooper/death/19.ogg",
					"krieg/voice/sith/trooper/death/20.ogg",
					"krieg/voice/sith/trooper/death/21.ogg",
					"krieg/voice/sith/trooper/death/22.ogg",
					"krieg/voice/sith/trooper/death/23.ogg",
					"krieg/voice/sith/trooper/death/24.ogg"}
					
					
ENT.SoundTbl_WeaponReload = {"krieg/voice/sith/trooper/reloading/1.ogg",
								"krieg/voice/sith/trooper/reloading/2.ogg",
								"krieg/voice/sith/trooper/reloading/3.ogg",
								"krieg/voice/sith/trooper/reloading/4.ogg",
								"krieg/voice/sith/trooper/reloading/5.ogg",
								"krieg/voice/sith/trooper/reloading/6.ogg",
								"krieg/voice/sith/trooper/reloading/7.ogg",
								"krieg/voice/sith/trooper/reloading/8.ogg",
								"krieg/voice/sith/trooper/reloading/9.ogg"}
								
ENT.SoundTbl_CombatIdle = {"krieg/voice/sith/trooper/suppressed/1.ogg",
							"krieg/voice/sith/trooper/suppressed/2.ogg",
							"krieg/voice/sith/trooper/suppressed/3.ogg",
							"krieg/voice/sith/trooper/suppressed/4.ogg",
							"krieg/voice/sith/trooper/suppressed/5.ogg",
							"krieg/voice/sith/trooper/suppressed/6.ogg",
							"krieg/voice/sith/trooper/suppressed/7.ogg",
							"krieg/voice/sith/trooper/suppressed/8.ogg",
							"krieg/voice/sith/trooper/suppressed/9.ogg",
							"krieg/voice/sith/trooper/suppressed/10.ogg",
							"krieg/voice/sith/trooper/suppressed/11.ogg"}
					
					
function ENT:CustomOnInitialize() --[[StormTrooper Bodygroups]]--
	if math.random(1,0) == 1 then
		self:SetSkin(math.random(2,3)) -- Ranks
		self:SetBodygroup(0,math.random(0,5)) -- Heads
		self:SetBodygroup(1,math.random(0,0)) -- Headwear
		self:SetBodygroup(2,math.random(0,0)) -- Uniform
		self:SetBodygroup(3,math.random(0,2)) -- Kit
		self:SetBodygroup(4,math.random(0,0)) -- Holster
	end
end


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
--CUSTOM VARIABLES

ENT.HasGrenadeAttack = true
ENT.GrenadeAttackEntity = "obj_vjks_stormdetonator" -- The entity that the SNPC throws | Half Life 2 Grenade: "npc_grenade_frag"
ENT.GrenadeAttackModel = "models/krieg/galacticempire/props/storm_grenade.mdl" -- The model for the grenade entity

--Misc
ENT.HasHelmetDrop = false
ENT.CanChangeAlertAnim = true
--Weapons
--ENT.CanUseSecondaryweapon = false
--ENT.Reloadwhenidle = false
--ENT.Reloadwhenattacking = false
--ENT.CanForceWeaponFire = true
--ENT.CanBlindFireCover = true
--ENT.CanProneCover = false
--Grenades
ENT.CanSmartDetectGrenades = true
ENT.CanDoSmartGrenadeThrow = true
ENT.CanDoGrenadeThrowHigh = true
ENT.CanThrowBlindGrenade = true
ENT.CanUseSpecialGrenade = false
--Weapons Melee
ENT.CanPerformMeleeCharge = false
ENT.MeleeCharge_range = 180
--Logic
ENT.CanThrowMedkit = false

ENT.SkillPreset = "waffeninf" --Can be heerprivate heerofficer waffeninf waffenoff
ENT.SkillSet = 0
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


