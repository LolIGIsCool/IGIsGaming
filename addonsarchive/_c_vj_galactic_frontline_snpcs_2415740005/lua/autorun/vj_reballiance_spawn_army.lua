/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-New Republic Army" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.



VJ.AddNPC_HUMAN("Officer","npc_vjks_reb_army_officer",{"weapon_vjks_dh03"},vCat)


VJ.AddNPC_HUMAN("Trooper","npc_vjks_reb_army_trooper2",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24"},vCat)
			
			
VJ.AddNPC_HUMAN("Trooper Heavy","npc_vjks_reb_army_trooper_heavy",{"weapon_vjks_dlt19","weapon_vjks_tc55"},vCat)
			
			
VJ.AddNPC_HUMAN("Trooper Rocketeer","npc_vjks_reb_army_trooper_plex",{"weapon_vjks_rocketlauncher"},vCat)
			
			
VJ.AddNPC_HUMAN("Trooper Grenadier","npc_vjks_reb_army_trooper2_grenadier",{"weapon_vjks_grenadelauncher"},vCat)
			
			
VJ.AddNPC_HUMAN("Assault Trooper","npc_vjks_reb_army_assault_trooper",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24"},vCat)
			
			
VJ.AddNPC_HUMAN("Assault Trooper Heavy","npc_vjks_reb_army_assault_heavy",{"weapon_vjks_dlt19","weapon_vjks_tc55"},vCat)
			
			
VJ.AddNPC_HUMAN("Assault Trooper Rocketeer","npc_vjks_reb_army_assault_trooper_plex",{"weapon_vjks_rocketlauncher"},vCat)
			
			
VJ.AddNPC_HUMAN("Assault Trooper Grenadier","npc_vjks_reb_army_assault_grenadier",{"weapon_vjks_grenadelauncher"},vCat)
			
			
-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Friendly NPCs-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

VJ.AddNPC_HUMAN("Officer (Friendly)","npc_vjks_reb_army_officerf",{"weapon_vjks_dh03"},vCat)


VJ.AddNPC_HUMAN("Trooper (Friendly)","npc_vjks_reb_army_trooper2f",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24"},vCat)
			
			
VJ.AddNPC_HUMAN("Trooper Heavy (Friendly)","npc_vjks_reb_army_trooper_heavyf",{"weapon_vjks_dlt19","weapon_vjks_tc55"},vCat)
			
			
VJ.AddNPC_HUMAN("Trooper Rocketeer (Friendly)","npc_vjks_reb_army_trooper_plexf",{"weapon_vjks_rocketlauncher"},vCat)
			
			
VJ.AddNPC_HUMAN("Trooper Grenadier (Friendly)","npc_vjks_reb_army_trooper2_grenadierf",{"weapon_vjks_grenadelauncher"},vCat)
			
			
VJ.AddNPC_HUMAN("Assault Trooper (Friendly)","npc_vjks_reb_army_assault_trooperf",{"weapon_vjks_dh17","weapon_vjks_dh21","weapon_vjks_dh24"},vCat)
			
			
VJ.AddNPC_HUMAN("Assault Trooper Heavy (Friendly)","npc_vjks_reb_army_assault_heavyf",{"weapon_vjks_dlt19","weapon_vjks_tc55"},vCat)
			
			
VJ.AddNPC_HUMAN("Assault Trooper Rocketeer (Friendly)","npc_vjks_reb_army_assault_trooper_plexf",{"weapon_vjks_rocketlauncher"},vCat)
			
			
VJ.AddNPC_HUMAN("Assault Trooper Grenadier (Friendly)","npc_vjks_reb_army_assault_grenadierf",{"weapon_vjks_grenadelauncher"},vCat)



