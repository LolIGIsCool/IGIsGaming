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
ENT.Model = {"models/krieg/galacticempire/army/trooper/npc_male_01.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
	-- ====== Health ====== --
ENT.StartHealth = 25 -- The starting health of the NPC
	-- ====== Miscellaneous Variables ====== --
ENT.AllowPrintingInChat = false -- Should this SNPC be allowed to post in player's chat? Example: "Blank no longer likes you."
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ AI / Relationship Variables ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_IMPF"}
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
ENT.SoundTbl_FootStep = {"krieg/walk_trooper_1.wav",
						"krieg/walk_trooper_2.wav",
						"krieg/walk_trooper_3.wav",
						"krieg/walk_trooper_4.wav"}

ENT.SoundTbl_Idle = {}

ENT.SoundTbl_Alert = {"krieg/voice/sith/officer/onenemysight/1.ogg",
							"krieg/voice/sith/officer/onenemysight/2.ogg",
							"krieg/voice/sith/officer/onenemysight/3.ogg",
							"krieg/voice/sith/officer/onenemysight/4.ogg",
							"krieg/voice/sith/officer/onenemysight/5.ogg",
							"krieg/voice/sith/officer/onenemysight/6.ogg",
							"krieg/voice/sith/officer/onenemysight/7.ogg",
							"krieg/voice/sith/officer/onenemysight/8.ogg",
							"krieg/voice/sith/officer/onenemysight/9.ogg",
							"krieg/voice/sith/officer/onenemysight/10.ogg",
							"krieg/voice/sith/officer/onenemysight/11.ogg",
							"krieg/voice/sith/officer/onenemysight/12.ogg",
							"krieg/voice/sith/officer/onenemysight/13.ogg"}

ENT.SoundTbl_OnGrenadeSight = {"krieg/voice/sith/officer/grenade_sighted/1.ogg",
								"krieg/voice/sith/officer/grenade_sighted/2.ogg",
								"krieg/voice/sith/officer/grenade_sighted/3.ogg",
								"krieg/voice/sith/officer/grenade_sighted/4.ogg",
								"krieg/voice/sith/officer/grenade_sighted/5.ogg",
								"krieg/voice/sith/officer/grenade_sighted/6.ogg",
								"krieg/voice/sith/officer/grenade_sighted/7.ogg",
								"krieg/voice/sith/officer/grenade_sighted/8.ogg",
								"krieg/voice/sith/officer/grenade_sighted/9.ogg",
								"krieg/voice/sith/officer/grenade_sighted/10.ogg",
								"krieg/voice/sith/officer/grenade_sighted/11.ogg",
								"krieg/voice/sith/officer/grenade_sighted/12.ogg",
								"krieg/voice/sith/officer/grenade_sighted/13.ogg",
								"krieg/voice/sith/officer/grenade_sighted/14.ogg"}

ENT.SoundTbl_Pain = {"krieg/voice/sith/officer/pain/1.ogg",
					"krieg/voice/sith/officer/pain/2.ogg",
					"krieg/voice/sith/officer/pain/3.ogg",
					"krieg/voice/sith/officer/pain/4.ogg",
					"krieg/voice/sith/officer/pain/5.ogg",
					"krieg/voice/sith/officer/pain/6.ogg",
					"krieg/voice/sith/officer/pain/7.ogg",
					"krieg/voice/sith/officer/pain/8.ogg",
					"krieg/voice/sith/officer/pain/9.ogg",
					"krieg/voice/sith/officer/pain/10.ogg",
					"krieg/voice/sith/officer/pain/11.ogg",
					"krieg/voice/sith/officer/pain/12.ogg",
					"krieg/voice/sith/officer/pain/13.ogg",
					"krieg/voice/sith/officer/pain/14.ogg",
					"krieg/voice/sith/officer/pain/15.ogg",
					"krieg/voice/sith/officer/pain/16.ogg",
					"krieg/voice/sith/officer/pain/17.ogg",
					"krieg/voice/sith/officer/pain/18.ogg"}

ENT.SoundTbl_Death = {"krieg/voice/sith/officer/death/1.ogg",
					"krieg/voice/sith/officer/death/2.ogg",
					"krieg/voice/sith/officer/death/3.ogg",
					"krieg/voice/sith/officer/death/4.ogg",
					"krieg/voice/sith/officer/death/5.ogg",
					"krieg/voice/sith/officer/death/6.ogg",
					"krieg/voice/sith/officer/death/7.ogg",
					"krieg/voice/sith/officer/death/8.ogg",
					"krieg/voice/sith/officer/death/9.ogg",
					"krieg/voice/sith/officer/death/10.ogg",
					"krieg/voice/sith/officer/death/11.ogg",
					"krieg/voice/sith/officer/death/12.ogg",
					"krieg/voice/sith/officer/death/13.ogg",
					"krieg/voice/sith/officer/death/14.ogg",
					"krieg/voice/sith/officer/death/15.ogg",
					"krieg/voice/sith/officer/death/16.ogg",
					"krieg/voice/sith/officer/death/17.ogg",
					"krieg/voice/sith/officer/death/18.ogg",
					"krieg/voice/sith/officer/death/19.ogg",
					"krieg/voice/sith/officer/death/20.ogg",
					"krieg/voice/sith/officer/death/21.ogg",
					"krieg/voice/sith/officer/death/22.ogg",
					"krieg/voice/sith/officer/death/23.ogg",
					"krieg/voice/sith/officer/death/24.ogg",
					"krieg/voice/sith/officer/death/25.ogg",
					"krieg/voice/sith/officer/death/26.ogg",
					"krieg/voice/sith/officer/death/27.ogg",
					"krieg/voice/sith/officer/death/28.ogg"}
					
					
function ENT:CustomOnInitialize() --[[Imperial Army Trooper Bodygroups]]--
	if math.random(1,0) == 1 then
		self:SetSkin(math.random(0,0)) -- Rank
		self:SetBodygroup(0,math.random(0,4)) -- Heads
		self:SetBodygroup(1,math.random(0,0)) -- Headwear
		self:SetBodygroup(2,math.random(1,1)) -- Uniform
		self:SetBodygroup(3,math.random(0,0)) -- Belt Boxes
		self:SetBodygroup(4,math.random(0,1)) -- Webbings
		self:SetBodygroup(5,math.random(1,3)) -- Holster
		self:SetBodygroup(6,math.random(0,1)) -- Pants
		self:SetBodygroup(7,math.random(0,0)) -- Mask
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


