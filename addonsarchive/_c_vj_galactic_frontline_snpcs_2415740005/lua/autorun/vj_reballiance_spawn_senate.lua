/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-New Republic Senate" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.



-------------------------------SENATE SECURITY

VJ.AddNPC_HUMAN("Senate Security","npc_vjks_reb_senate_security",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Security Heavy","npc_vjks_reb_senate_security_heavy",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Security Grenadier","npc_vjks_reb_senate_security_grenadier",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Senate Security Officer ","npc_vjks_reb_senate_security_officer",{"weapon_vjks_dh03"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
								
-------------------------------SENATE GUARDS

VJ.AddNPC_HUMAN("Senate Guard","npc_vjks_reb_senate_guard",{"weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Senate Guard Captain","npc_vjks_reb_senate_guard_captain",{"weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Guard Heavy","npc_vjks_reb_senate_guard_heavy",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Guard Grenadier","npc_vjks_reb_senate_guard_grenadier",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Guard Rocketeer","npc_vjks_reb_senate_guard_plex",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("Senate Guards Officer","npc_vjks_reb_senate_guards_officer",{"weapon_vjks_dh03"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
								
VJ.AddNPC_HUMAN("Senate Patrol","npc_vjks_reb_senate_commando",{"weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Friendly NPCs-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------


-------------------------------SENATE SECURITY

VJ.AddNPC_HUMAN("Senate Security (Friendly)","npc_vjks_reb_senate_securityf",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Security Heavy (Friendly)","npc_vjks_reb_senate_security_heavyf",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Security Grenadier (Friendly)","npc_vjks_reb_senate_security_grenadierf",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Senate Security Officer (Friendly)","npc_vjks_reb_senate_security_officerf",{"weapon_vjks_dh03"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
								
-------------------------------SENATE GUARDS

VJ.AddNPC_HUMAN("Senate Guard (Friendly)","npc_vjks_reb_senate_guardf",{"weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Senate Guard Captain (Friendly)","npc_vjks_reb_senate_guard_captainf",{"weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Guard Heavy (Friendly)","npc_vjks_reb_senate_guard_heavyf",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Guard Grenadier (Friendly)","npc_vjks_reb_senate_guard_grenadierf",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
--VJ.AddNPC_HUMAN("Senate Guard Rocketeer (Friendly)","npc_vjks_reb_senate_guard_plexf",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("Senate Guards Officer (Friendly)","npc_vjks_reb_senate_guards_officerf",{"weapon_vjks_dh03"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
VJ.AddNPC_HUMAN("Senate Patrol (Friendly)","npc_vjks_reb_senate_commandof",{"weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								


								
								

