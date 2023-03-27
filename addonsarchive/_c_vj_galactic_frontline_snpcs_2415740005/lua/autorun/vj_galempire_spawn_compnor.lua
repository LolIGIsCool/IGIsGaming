/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-Imperial COMPNOR" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.


------------------COMPNOR


VJ.AddNPC_HUMAN("COMPNOR Officer","npc_vjks_imp_compnor_officer",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
------------------IMPERIAL SECURITY BUREAU


VJ.AddNPC_HUMAN("ISB Officer","npc_vjks_imp_isb_officer",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("ISB Officer [Combat]","npc_vjks_imp_isb_officer_combat",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("ISB Officer [Staff]","npc_vjks_imp_isb_officer_staff",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("ISB Security Trooper","npc_vjks_imp_isb_trooper",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

------------------COMPFORCE
								
VJ.AddNPC_HUMAN("COMPFORCE Officer","npc_vjks_imp_compforce_officer",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("COMPFORCE Trooper","npc_vjks_imp_compforce",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("COMPFORCE Heavy","npc_vjks_imp_compforce_heavy",{"weapon_vjks_dlt19","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("COMPFORCE Rocketeer","npc_vjks_imp_compforce_plex",{"weapon_vjks_rocketlauncher","weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
------------------COMMANDOS
								
VJ.AddNPC_HUMAN("Commando","npc_vjks_imp_commando",{"weapon_vjks_e11d","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Commando Assaultier","npc_vjks_imp_commando_storm",{"weapon_vjks_e11d","weapon_vjks_e22","weapon_vjks_t21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
				
VJ.AddNPC_HUMAN("Commando Sniper","npc_vjks_imp_commando_sniper",{"weapon_vjks_dlt20"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Guard","npc_vjks_imp_guard",{"weapon_vjks_e11d"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.								

-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Friendly NPCs-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

------------------COMPNOR


VJ.AddNPC_HUMAN("COMPNOR Officer (Friendly)","npc_vjks_imp_compnor_officerf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
------------------IMPERIAL SECURITY BUREAU


VJ.AddNPC_HUMAN("ISB Officer (Friendly)","npc_vjks_imp_isb_officerf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("ISB Officer [Combat] (Friendly)","npc_vjks_imp_isb_officer_combatf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("ISB Officer [Staff] (Friendly)","npc_vjks_imp_isb_officer_stafff",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("ISB Security Trooper (Friendly)","npc_vjks_imp_isb_trooperf",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

------------------COMPFORCE
VJ.AddNPC_HUMAN("COMPFORCE Officer (Friendly)","npc_vjks_imp_compforce_officerf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("COMPFORCE Trooper (Friendly)","npc_vjks_imp_compforcef",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("COMPFORCE Heavy (Friendly)","npc_vjks_imp_compforce_heavyf",{"weapon_vjks_dlt19","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
VJ.AddNPC_HUMAN("COMPFORCE Rocketeer (Friendly)","npc_vjks_imp_compforce_plexf",{"weapon_vjks_rocketlauncher","weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
------------------COMMANDOS
								
VJ.AddNPC_HUMAN("Commando (Friendly)","npc_vjks_imp_commandof",{"weapon_vjks_e11d","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Commando Assaultier (Friendly)","npc_vjks_imp_commando_stormf",{"weapon_vjks_e11d","weapon_vjks_e22","weapon_vjks_t21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
				
VJ.AddNPC_HUMAN("Commando Sniper (Friendly)","npc_vjks_imp_commando_sniperf",{"weapon_vjks_dlt20"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
								
VJ.AddNPC_HUMAN("Guard (Friendly)","npc_vjks_imp_guardf",{"weapon_vjks_e11d"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								

