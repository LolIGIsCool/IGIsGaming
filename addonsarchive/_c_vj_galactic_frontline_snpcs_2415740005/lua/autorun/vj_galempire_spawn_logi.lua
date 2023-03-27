/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-Imperial Logistics" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.


VJ.AddNPC_HUMAN("Logistics Officer","npc_vjks_imp_logi_officer",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Officer [Combat]","npc_vjks_imp_logi_officer_combat",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Officer [Staff]","npc_vjks_imp_logi_officer_staff",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Cargo Pilot","npc_vjks_imp_logi_pilot",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Crew","npc_vjks_imp_logi_crew",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Cargo Guard","npc_vjks_imp_logi_trooper",{"weapon_vjks_e11","weapon_vjks_e22","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Friendly NPCs-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

VJ.AddNPC_HUMAN("Logistics Officer (Friendly)","npc_vjks_imp_logi_officerf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Officer [Combat] (Friendly)","npc_vjks_imp_logi_officer_combatf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Officer [Staff] (Friendly)","npc_vjks_imp_logi_officer_stafff",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Cargo Pilot (Friendly)","npc_vjks_imp_logi_pilotf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Crew (Friendly)","npc_vjks_imp_logi_crewf",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Logistics Cargo Guard (Friendly)","npc_vjks_imp_logi_trooperf",{"weapon_vjks_e11","weapon_vjks_e22","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.




