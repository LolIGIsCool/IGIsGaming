/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-Imperial Navy" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.



	
VJ.AddNPC_HUMAN("Gunner","npc_vjks_imp_navy_crew_gunner",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
									
VJ.AddNPC_HUMAN("TIE Pilot","npc_vjks_imp_navy_tie_pilot",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
	
VJ.AddNPC_HUMAN("Crew","npc_vjks_imp_navy_crew",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Technician","npc_vjks_imp_navy_crew_technician",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("Officer","npc_vjks_imp_navy_officer",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Staff]","npc_vjks_imp_navy_officer_staff",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Adjutant]","npc_vjks_imp_navy_officer_adjutant",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Deathstar Trooper","npc_vjks_imp_navy_dstartrooper",{"weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Navy Trooper Officer","npc_vjks_imp_navy_trooper_officer",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Navy Trooper","npc_vjks_imp_navy_trooper",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Combat]","npc_vjks_imp_navy_officer_combat",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Technician Officer","npc_vjks_imp_navy_officer_technician",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
							
VJ.AddNPC_HUMAN("Grand Admiral","npc_vjks_imp_navy_grand_admiral",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Friendly NPCs-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

VJ.AddNPC_HUMAN("Gunner (Friendly)","npc_vjks_imp_navy_crew_gunnerf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
									
VJ.AddNPC_HUMAN("TIE Pilot (Friendly)","npc_vjks_imp_navy_tie_pilotf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
	
VJ.AddNPC_HUMAN("Crew (Friendly)","npc_vjks_imp_navy_crewf",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Technician (Friendly)","npc_vjks_imp_navy_crew_technicianf",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("Officer (Friendly)","npc_vjks_imp_navy_officerf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Staff] (Friendly)","npc_vjks_imp_navy_officer_stafff",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Adjutant] (Friendly)","npc_vjks_imp_navy_officer_adjutantf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Deathstar Trooper (Friendly)","npc_vjks_imp_navy_dstartrooperf",{"weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Navy Trooper Officer (Friendly)","npc_vjks_imp_navy_trooper_officerf",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Navy Trooper (Friendly)","npc_vjks_imp_navy_trooperf",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Officer [Combat] (Friendly)","npc_vjks_imp_navy_officer_combatf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Technician Officer (Friendly)","npc_vjks_imp_navy_officer_technicianf",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
							
VJ.AddNPC_HUMAN("Grand Admiral (Friendly)","npc_vjks_imp_navy_grand_admiralf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
