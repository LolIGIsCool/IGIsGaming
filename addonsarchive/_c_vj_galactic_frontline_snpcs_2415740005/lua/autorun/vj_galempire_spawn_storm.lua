/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-Imperial Stormtroopers" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.

------------------------- COASTAL DEFENCE TROOPERS

VJ.AddNPC_HUMAN("CDT","npc_vjks_imp_shoretrooper",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("CDT Heavy","npc_vjks_imp_shoretrooper_heavy",{"weapon_vjks_dlt19","weapon_vjks_t21"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("CDT Genadier","npc_vjks_imp_shoretrooper_grenadier",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("CDT Pilot","npc_vjks_imp_shoretrooper_pilot",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("CDT Tanktrooper","npc_vjks_imp_shoretrooper_tank",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist



------------------------- STORMTROOPERS

VJ.AddNPC_HUMAN("Stormtrooper","npc_vjks_imp_strooper",{"weapon_vjks_e11",},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Commander","npc_vjks_imp_strooper_com",{"weapon_vjks_e11","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Squadleader","npc_vjks_imp_strooper_squad",{"weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Heavy","npc_vjks_imp_strooper_heavy",{"weapon_vjks_dlt19","weapon_vjks_t21"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Rocketeer","npc_vjks_imp_strooper_plex",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Genadier","npc_vjks_imp_strooper_grenadier",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Scouttrooper","npc_vjks_imp_strooper_scout",{"weapon_vjks_e11","weapon_vjks_dlt20"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Jumptrooper","npc_vjks_imp_strooper_jump",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist

--VJ.AddNPC_HUMAN("Jumptrooper Plex","npc_vjks_imp_strooper_jump",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist


------------------------- STORMTROOPER ASSAULT RECON COMMANDOS

VJ.AddNPC_HUMAN("SARC Trooper","npc_vjks_imp_sarctrooper",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist

--VJ.AddNPC_HUMAN("SARC Trooper Commander","npc_vjks_imp_sarctrooper_com",{"weapon_vjks_e11","weapon_vjks_e22","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist

--VJ.AddNPC_HUMAN("SARC Trooper Heavy","npc_vjks_imp_sarctrooper_heavy",{"weapon_vjks_dlt19","weapon_vjks_t21"},vCat) -- Add a human SNPC to the spawnlist

--VJ.AddNPC_HUMAN("SARC Trooper Genadier","npc_vjks_imp_sarctrooper_grenadier",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist



------------------------- MISC TROOPERS

VJ.AddNPC_HUMAN("AT-ACT Pilot","npc_vjks_imp_strooper_atact_pilot",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("Tanktrooper","npc_vjks_imp_strooper_tanktrooper",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist



------------------------- OFFICERS

VJ.AddNPC_HUMAN("Storm Officer","npc_vjks_imp_storm_officer",{"weapon_vjks_e11","weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("Storm Officer [Combat]","npc_vjks_imp_storm_officer_combat",{"weapon_vjks_e11","weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Friendly NPCs-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------

------------------------- COASTAL DEFENCE TROOPERS

VJ.AddNPC_HUMAN("CDT (Friendly)","npc_vjks_imp_shoretrooperf",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("CDT Heavy (Friendly)","npc_vjks_imp_shoretrooper_heavyf",{"weapon_vjks_dlt19","weapon_vjks_t21"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("CDT Genadier (Friendly)","npc_vjks_imp_shoretrooper_grenadierf",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("CDT Pilot (Friendly)","npc_vjks_imp_shoretrooper_pilotf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("CDT Tanktrooper (Friendly)","npc_vjks_imp_shoretrooper_tankf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist


------------------------- STORMTROOPERS

VJ.AddNPC_HUMAN("Stormtrooper (Friendly)","npc_vjks_imp_strooperf",{"weapon_vjks_e11",},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Commander (Friendly)","npc_vjks_imp_strooper_comf",{"weapon_vjks_e11","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Squadleader (Friendly)","npc_vjks_imp_strooper_squadf",{"weapon_vjks_e11"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Heavy (Friendly)","npc_vjks_imp_strooper_heavyf",{"weapon_vjks_dlt19","weapon_vjks_t21"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Rocketeer (Friendly)","npc_vjks_imp_strooper_plexf",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Stormtrooper Genadier (Friendly)","npc_vjks_imp_strooper_grenadierf",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Scouttrooper (Friendly)","npc_vjks_imp_strooper_scoutf",{"weapon_vjks_e11","weapon_vjks_dlt20"},vCat) -- Add a human SNPC to the spawnlist


VJ.AddNPC_HUMAN("Jumptrooper (Friendly)","npc_vjks_imp_strooper_jumpf",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist


--VJ.AddNPC_HUMAN("Jumptrooper Plex (Friendly)","npc_vjks_imp_strooper_jumpf",{"weapon_vjks_rocketlauncher"},vCat) -- Add a human SNPC to the spawnlist



------------------------- STORMTROOPER ASSAULT RECON COMMANDOS

VJ.AddNPC_HUMAN("SARC Trooper (Friendly)","npc_vjks_imp_sarctrooperf",{"weapon_vjks_e11","weapon_vjks_e22"},vCat) -- Add a human SNPC to the spawnlist

--VJ.AddNPC_HUMAN("SARC Trooper Commander (Friendly)","npc_vjks_imp_sarctrooper_comf",{"weapon_vjks_e11","weapon_vjks_e22","weapon_vjks_tc55"},vCat) -- Add a human SNPC to the spawnlist

--VJ.AddNPC_HUMAN("SARC Trooper Heavy (Friendly)","npc_vjks_imp_sarctrooper_heavyf",{"weapon_vjks_dlt19","weapon_vjks_t21"},vCat) -- Add a human SNPC to the spawnlist

--VJ.AddNPC_HUMAN("SARC Trooper Genadier (Friendly)","npc_vjks_imp_sarctrooper_grenadierf",{"weapon_vjks_grenadelauncher"},vCat) -- Add a human SNPC to the spawnlist

------------------------- MISC TROOPERS

VJ.AddNPC_HUMAN("AT-ACT Pilot (Friendly)","npc_vjks_imp_strooper_atact_pilotf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("Tanktrooper (Friendly)","npc_vjks_imp_strooper_tanktrooperf",{"weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist

------------------------- OFFICERS

VJ.AddNPC_HUMAN("Storm Officer (Friendly)","npc_vjks_imp_storm_officerf",{"weapon_vjks_e11","weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist

VJ.AddNPC_HUMAN("Storm Officer [Combat] (Friendly)","npc_vjks_imp_storm_officer_combatf",{"weapon_vjks_e11","weapon_vjks_se09e","weapon_vjks_se14r"},vCat) -- Add a human SNPC to the spawnlist


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



VJ.AddNPCWeapon("VJ_E-11", "weapon_vjks_e11")
VJ.AddNPCWeapon("VJ_E-22", "weapon_vjks_e22")
VJ.AddNPCWeapon("VJ_se14r", "weapon_vjks_se14r")
VJ.AddNPCWeapon("VJ_dh03", "weapon_vjks_dh03")
VJ.AddNPCWeapon("VJ_dh17", "weapon_vjks_dh17")
VJ.AddNPCWeapon("VJ_dh21", "weapon_vjks_dh21")
VJ.AddNPCWeapon("VJ_dh24", "weapon_vjks_dh24")
VJ.AddNPCWeapon("VJ_se09e", "weapon_vjks_se09e")
VJ.AddNPCWeapon("VJ_DLT22b", "weapon_vjks_dlt20")
VJ.AddNPCWeapon("VJ_DLT19", "weapon_vjks_dlt19")
VJ.AddNPCWeapon("VJ_t21", "weapon_vjks_t21")
VJ.AddNPCWeapon("VJ_e11d", "weapon_vjks_e11d")
VJ.AddNPCWeapon("VJ_TC55", "weapon_vjks_tc55")
VJ.AddNPCWeapon("VJ_ImpRocketLauncher", "weapon_vjks_rocketlauncher")
VJ.AddNPCWeapon("VJ_ImpGrenLauncher", "weapon_vjks_grenadelauncher")

VJ.AddEntity("Imperial Thermal Detonator","obj_vjks_thermaldetonator",vCat)
VJ.AddEntity("Imperial Stormtrooper Grenade","obj_vjks_stormgrenade",vCat)

VJ.AddNPC("E Web Blaster Turret","npc_vjks_imp_e_web",vCat)

	VJ.AddConVar("vj_advancedoi_snpc_canheal",1)
	VJ.AddConVar("vj_advancedoi_snpc_weapondmgmod",0)
	
	
game.AddParticles("particles/effects/kstrudel_blaster_fire.pcf")
	local particlename = {
	"vjks_blaster_glow_large_red",
	"vjks_blaster_glow_red",
	"vjks_blaster_inner_red",
	"vjks_blaster_top_left_glow_red",
	"vjks_blaster_red",
	"vjks_blaster_side_glow_red",
	"vjks_blaster_side_red",
	"vjks_blaster_smoke_flash_red",
	"vjks_blaster_sparks_red",
	"vjks_blaster_top_glow_red",
	"vjks_blaster_top_red",
	}
	
game.AddParticles("particles/effects/kstrudel_blaster_fire_2.pcf")
	local particlename = {
	"vjks_blasterfire_1_red",
	"vjks_blasterfire_1_glow_red",
	"vjks_blasterfire_1_core_red",
	"vjks_blasterfire_1_smoke_red",
	"vjks_blasterfire_1_sparks2_red",
	"vjks_blasterfire_1_sparks_red",
	"vjks_blasterfire_2_red",
	"vjks_blasterfire_2_glow_red",
	"vjks_blasterfire_2_core_red",
	}

