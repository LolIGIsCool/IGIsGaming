/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-Scum & Villany" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.


VJ.AddNPC_HUMAN("Mercenary","npc_vjks_scum_human",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("Rodian Mercenary","npc_vjks_scum_rodian",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Weequay Mercenary","npc_vjks_scum_weequay",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
							
								
-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Friendly NPCs-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

VJ.AddNPC_HUMAN("Mercenary (Firendly)","npc_vjks_scum_humanf",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("Rodian Mercenary (Firendly)","npc_vjks_scum_rodianf",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Weequay Mercenary (Firendly)","npc_vjks_scum_weequayf",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								






								
VJ.AddNPC_HUMAN("Angry Mob","npc_vjks_civ_mob",{"weapon_vjks_melee_baton","weapon_vjks_melee_pipe"},vCat)
		

VJ.AddNPCWeapon("[GF]_Baton", "weapon_vjks_melee_baton")
VJ.AddNPCWeapon("[GF]_Pipe", "weapon_vjks_melee_pipe")




