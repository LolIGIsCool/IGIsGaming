/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-Imperial Army" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.






---------------------------- INFANTRY

VJ.AddNPC_HUMAN("Trooper","npc_vjks_imp_army_trooper",{"weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Trooper Medic","npc_vjks_imp_army_medic",{"weapon_vjks_e11","weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Trooper Driver","npc_vjks_imp_army_driver",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Trooper Grenadier","npc_vjks_imp_army_grenadier",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Trooper Rocketeer","npc_vjks_imp_army_trooper_plex",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Trooper Gunner","npc_vjks_imp_army_trooper_heavy",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
---------------------------- MECHANIZED TROOPS (Dismounted)

VJ.AddNPC_HUMAN("M.Trooper","npc_vjks_imp_army_mech_trooper",{"weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("M.Trooper Heavy","npc_vjks_imp_army_mech_trooper_heavy",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("M.Trooper Grenadier","npc_vjks_imp_army_mech_trooper_grenadier",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("M.Trooper Rocketeer","npc_vjks_imp_army_mech_trooper_plex",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
								
---------------------------- MISC PERSONNELL

VJ.AddNPC_HUMAN("ATDP Driver","npc_vjks_imp_army_driver_atdp",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("ATPT Driver","npc_vjks_imp_army_driver_atrt",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Pilot","npc_vjks_imp_army_pilot",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Personnell","npc_vjks_imp_army_personnell",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Crewman","npc_vjks_imp_army_crew",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Security Trooper","npc_vjks_imp_army_security",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Commando","npc_vjks_imp_army_rax_trooper",{"weapon_vjks_e11","weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
---------------------------- OFFICERS

VJ.AddNPC_HUMAN("Officer","npc_vjks_imp_army_officer",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Staff]","npc_vjks_imp_army_officer_staff",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Combat]","npc_vjks_imp_army_officer_combat",{"weapon_vjks_se14r","weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								

-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Friendly NPCs-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

VJ.AddNPC_HUMAN("Trooper (Friendly)","npc_vjks_imp_army_trooperf",{"weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Trooper Medic (Friendly)","npc_vjks_imp_army_medicf",{"weapon_vjks_e11","weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Trooper Driver (Friendly)","npc_vjks_imp_army_driverf",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Trooper Grenadier (Friendly)","npc_vjks_imp_army_grenadierf",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Trooper Rocketeer (Friendly)","npc_vjks_imp_army_trooper_plexf",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Trooper Gunner (Friendly)","npc_vjks_imp_army_trooper_heavyf",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
---------------------------- MECHANIZED TROOPS (Dismounted)


VJ.AddNPC_HUMAN("M.Trooper (Friendly)","npc_vjks_imp_army_mech_trooperf",{"weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("M.Trooper Heavy (Friendly)","npc_vjks_imp_army_mech_trooper_heavyf",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("M.Trooper Grenadier (Friendly)","npc_vjks_imp_army_mech_trooper_grenadierf",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("M.Trooper Rocketeer (Friendly)","npc_vjks_imp_army_mech_trooper_plexf",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

								
---------------------------- MISC PERSONNELL

VJ.AddNPC_HUMAN("ATDP Driver (Friendly)","npc_vjks_imp_army_driver_atdpf",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("ATPT Driver (Friendly)","npc_vjks_imp_army_driver_atrtf",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Pilot (Friendly)","npc_vjks_imp_army_pilotf",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Personnell (Friendly)","npc_vjks_imp_army_personnellf",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Crewman (Friendly)","npc_vjks_imp_army_crewf",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Security Trooper (Friendly)","npc_vjks_imp_army_securityf",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Commando (Friendly)","npc_vjks_imp_army_rax_trooperf",{"weapon_vjks_e11","weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
---------------------------- OFFICERS

VJ.AddNPC_HUMAN("Officer (Friendly)","npc_vjks_imp_army_officerf",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Staff] (Friendly)","npc_vjks_imp_army_officer_stafff",{"weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Combat] (Friendly)","npc_vjks_imp_army_officer_combatf",{"weapon_vjks_se14r","weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
								
								
VJ.AddNPCWeapon("VJ_E-11", "weapon_vjks_e11")
VJ.AddNPCWeapon("VJ_se14r", "weapon_vjks_se14r")
VJ.AddNPCWeapon("VJ_dh17", "weapon_vjks_dh17")
VJ.AddNPCWeapon("VJ_Scoutblaster", "weapon_vjks_scoutblaster")
VJ.AddNPCWeapon("VJ_DLT22b", "weapon_vjks_dlt22b")
VJ.AddNPCWeapon("VJ_DLT19", "weapon_vjks_dlt19")
VJ.AddNPCWeapon("VJ_t21", "weapon_vjks_t21")
VJ.AddNPCWeapon("VJ_rt97c", "weapon_vjks_rt97c")
VJ.AddNPCWeapon("VJ_e11d", "weapon_vjks_e11d")
VJ.AddNPCWeapon("VJ_lasershotgun", "weapon_vjks_lasershot")
VJ.AddNPCWeapon("VJ_Relby V-10", "weapon_vjks_relby")
VJ.AddNPCWeapon("VJ_Laser Minigun", "weapon_vjks_laserminigun")
