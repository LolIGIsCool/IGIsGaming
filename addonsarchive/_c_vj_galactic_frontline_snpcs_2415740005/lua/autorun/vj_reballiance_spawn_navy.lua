/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-New Republic Navy" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.


VJ.AddNPC_HUMAN("Fleet Guard","npc_vjks_reb_fleet_guard",{"weapon_vjks_dh17","weapon_vjks_dh21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("Fleet Trooper","npc_vjks_reb_fleet_trooper",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Trooper Heavy","npc_vjks_reb_fleet_trooper_heavy",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Sapper Rocketeer","npc_vjks_reb_fleet_trooper_plex",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Trooper Officer","npc_vjks_reb_fleet_trooper_officer",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
							
VJ.AddNPC_HUMAN("Fleet Officer","npc_vjks_reb_fleet_officer",{"weapon_vjks_dh03"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
VJ.AddNPC_HUMAN("Fleet Patrolman","npc_vjks_reb_fleet_patrol",{"weapon_vjks_dh17","weapon_vjks_dh21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Crewman","npc_vjks_reb_fleet_crew",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Gunner","npc_vjks_reb_fleet_crew_gunner",{"weapon_vjks_dh17","weapon_vjks_dh21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Marine","npc_vjks_reb_fleet_commando",{"weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
-------------------------------------ENGINEERS
								
VJ.AddNPC_HUMAN("Fleet Engineer","npc_vjks_reb_fleet_crew_engineer",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Mechanic","npc_vjks_reb_fleet_mechanic",{"weapon_vjks_dh17","weapon_vjks_dh21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Sapper","npc_vjks_reb_fleet_sapper",{"weapon_vjks_tc55","weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
-------------------------------------MEDICS
	
								
-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Friendly NPCs-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

VJ.AddNPC_HUMAN("Fleet Guard (Friendly)","npc_vjks_reb_fleet_guardf",{"weapon_vjks_dh17","weapon_vjks_dh21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("Fleet Trooper (Friendly)","npc_vjks_reb_fleet_trooperf",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Trooper Heavy (Friendly)","npc_vjks_reb_fleet_trooper_heavyf",{"weapon_vjks_dlt19"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Sapper Rocketeer (Friendly)","npc_vjks_reb_fleet_trooper_plexf",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Trooper Officer (Friendly)","npc_vjks_reb_fleet_trooper_officerf",{"weapon_vjks_dh17"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Officer (Friendly)","npc_vjks_reb_fleet_officerf",{"weapon_vjks_dh03"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.

VJ.AddNPC_HUMAN("Fleet Patrolman (Friendly)","npc_vjks_reb_fleet_patrolf",{"weapon_vjks_dh17","weapon_vjks_dh21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Crewman (Friendly)","npc_vjks_reb_fleet_crewf",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Gunner (Friendly)","npc_vjks_reb_fleet_crew_gunnerf",{"weapon_vjks_dh17","weapon_vjks_dh21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Marine (Friendly)","npc_vjks_reb_fleet_commandof",{"weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
								
-------------------------------------ENGINEERS
								
VJ.AddNPC_HUMAN("Fleet Engineer (Friendly)","npc_vjks_reb_fleet_crew_engineerf",{"weapon_vjks_datapad"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Mechanic (Friendly)","npc_vjks_reb_fleet_mechanicf",{"weapon_vjks_dh17","weapon_vjks_dh21"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								
VJ.AddNPC_HUMAN("Fleet Sapper (Friendly)","npc_vjks_reb_fleet_sapperf",{"weapon_vjks_tc55","weapon_vjks_dh21","weapon_vjks_dh24"},vCat) -- Add a human SNPC to the spawnlist
								-- Add as many weapons here as you want. The SNPC will spawn with a random one.
								



