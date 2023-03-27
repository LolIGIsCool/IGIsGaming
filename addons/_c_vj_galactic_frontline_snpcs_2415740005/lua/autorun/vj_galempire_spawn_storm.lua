/*--------------------------------------------------
	=============== Dummy Spawn ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load spawns for Dummy
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
include('autorun/vj_controls.lua')

local vCat = "VJ-Galactic Empire" -- Category

-- You can add as many of this as you want. 
-- WARNING: Just remember to always only add entities that exist, else Garry's Mod will make an error.



VJ.AddNPC("E Web Blaster Turret","npc_vjks_imp_e_web",vCat)

VJ.AddNPC("E Web Blaster Turret [Shield]","npc_vjks_imp_e_web_shield",vCat)


------------------------- STORMTROOPERS

VJ.AddNPC_HUMAN("Stormtrooper","npc_vjks_imp_st_trooper",{"weapon_vjks_e11"},vCat)
VJ.AddNPC_HUMAN("Stormtrooper (Friendly)","npc_vjks_imp_st_trooper_f",{"weapon_vjks_e11"},vCat)

VJ.AddNPC_HUMAN("Stormtrooper Sergeant","npc_vjks_imp_st_trooper_sgt",{"weapon_vjks_e11"},vCat)
VJ.AddNPC_HUMAN("Stormtrooper Sergeant (Friendly)","npc_vjks_imp_st_trooper_sgt_f",{"weapon_vjks_e11"},vCat)

VJ.AddNPC_HUMAN("Stormtrooper Officer","npc_vjks_imp_st_trooper_officer",{"weapon_vjks_e11"},vCat)
VJ.AddNPC_HUMAN("Stormtrooper Officer (Friendly)","npc_vjks_imp_st_trooper_officer_f",{"weapon_vjks_e11"},vCat)

VJ.AddNPC_HUMAN("Stormtrooper MG","npc_vjks_imp_st_trooper_mg",{"weapon_vjks_dlt19"},vCat)
VJ.AddNPC_HUMAN("Stormtrooper MG (Friendly)","npc_vjks_imp_st_trooper_mg_f",{"weapon_vjks_dlt19"},vCat)

VJ.AddNPC_HUMAN("Stormtrooper Heavy","npc_vjks_imp_st_trooper_heavy",{"weapon_vjks_t21"},vCat)
VJ.AddNPC_HUMAN("Stormtrooper Heavy (Friendly)","npc_vjks_imp_st_trooper_heavy_f",{"weapon_vjks_t21"},vCat)

VJ.AddNPC_HUMAN("Stormtrooper Plex","npc_vjks_imp_st_trooper_plex",{"weapon_vjks_rocketlauncher"},vCat)
VJ.AddNPC_HUMAN("Stormtrooper Plex (Friendly)","npc_vjks_imp_st_trooper_plex_f",{"weapon_vjks_rocketlauncher"},vCat)

VJ.AddNPC_HUMAN("Scouttrooper","npc_vjks_imp_st_scout",{"weapon_vjks_dlt20"},vCat)
VJ.AddNPC_HUMAN("Scouttrooper (Friendly)","npc_vjks_imp_st_scout_f",{"weapon_vjks_dlt20"},vCat)





VJ.AddNPC_HUMAN("Shoretrooper","npc_vjks_imp_st_shoretrooper",{"weapon_vjks_e22"},vCat)
VJ.AddNPC_HUMAN("Shoretrooper (Friendly)","npc_vjks_imp_st_shoretrooper_f",{"weapon_vjks_e22"},vCat)

VJ.AddNPC_HUMAN("Shoretrooper Leader","npc_vjks_imp_st_shoretrooper_leader",{"weapon_vjks_e22"},vCat)
VJ.AddNPC_HUMAN("Shoretrooper Leader (Friendly)","npc_vjks_imp_st_shoretrooper_leader_f",{"weapon_vjks_e22"},vCat)

VJ.AddNPC_HUMAN("Shoretrooper Grenadier","npc_vjks_imp_st_shoretrooper_grenadier",{"weapon_vjks_t21"},vCat)
VJ.AddNPC_HUMAN("Shoretrooper Grenadier (Friendly)","npc_vjks_imp_st_shoretrooper_grenadier_f",{"weapon_vjks_t21"},vCat)


VJ.AddNPC_HUMAN("SARC Trooper","npc_vjks_imp_st_sarctrooper",{"weapon_vjks_e22","weapon_vjks_e11","weapon_vjks_t21","weapon_vjks_dlt19"},vCat)
VJ.AddNPC_HUMAN("SARC Trooper (Friendly)","npc_vjks_imp_st_sarctrooper_f",{"weapon_vjks_e22","weapon_vjks_e11","weapon_vjks_t21","weapon_vjks_dlt19"},vCat)


VJ.AddNPC_HUMAN("SARC Commando","npc_vjks_imp_st_sarccommando",{"weapon_vjks_e11d"},vCat)
VJ.AddNPC_HUMAN("SARC Commando (Friendly)","npc_vjks_imp_st_sarccommando_f",{"weapon_vjks_e11d"},vCat)

VJ.AddNPC_HUMAN("Shadowtrooper","npc_vjks_imp_st_shadowtrooper",{"weapon_vjks_e11d"},vCat)
VJ.AddNPC_HUMAN("Shadowtrooper (Friendly)","npc_vjks_imp_st_shadowtrooper_f",{"weapon_vjks_e11d"},vCat)

VJ.AddNPC_HUMAN("Royal Guard Trooper","npc_vjks_imp_royal_trooper",{"weapon_vjks_e11d"},vCat)
VJ.AddNPC_HUMAN("Royal Guard Trooper (Friendly)","npc_vjks_imp_royal_trooper_f",{"weapon_vjks_e11d"},vCat)












------------------------- IMPERIAL ARMY

VJ.AddNPC_HUMAN("Army Officer","npc_vjks_imp_army_officer",{},vCat)
VJ.AddNPC_HUMAN("Army Officer (Friendly)","npc_vjks_imp_army_officer_f",{},vCat)

VJ.AddNPC_HUMAN("Army Officer [Staff]","npc_vjks_imp_army_officer_staff",{},vCat)
VJ.AddNPC_HUMAN("Army Officer [Staff] (Friendly)","npc_vjks_imp_army_officer_staff_f",{},vCat)

VJ.AddNPC_HUMAN("Army Crewman","npc_vjks_imp_army_crew",{"weapon_vjks_se14r"},vCat)
VJ.AddNPC_HUMAN("Army Crewman (Friendly)","npc_vjks_imp_army_crew_f",{"weapon_vjks_se14r"},vCat)

VJ.AddNPC_HUMAN("Army Personell","npc_vjks_imp_army_personell",{},vCat)
VJ.AddNPC_HUMAN("Army Personell (Friendly)","npc_vjks_imp_army_personell_f",{},vCat)

VJ.AddNPC_HUMAN("Army Trooper","npc_vjks_imp_army_trooper",{"weapon_vjks_e10"},vCat)
VJ.AddNPC_HUMAN("Army Trooper (Friendly)","npc_vjks_imp_army_trooper_f",{"weapon_vjks_e10"},vCat)

VJ.AddNPC_HUMAN("Army Trooper [Light]","npc_vjks_imp_army_trooper_light",{"weapon_vjks_e10"},vCat)
VJ.AddNPC_HUMAN("Army Trooper [Light] (Friendly)","npc_vjks_imp_army_trooper_light_f",{"weapon_vjks_e10"},vCat)

VJ.AddNPC_HUMAN("Army Medic","npc_vjks_imp_army_trooper_medic",{},vCat)
VJ.AddNPC_HUMAN("Army Medic (Friendly)","npc_vjks_imp_army_trooper_medic_f",{},vCat)

VJ.AddNPC_HUMAN("Army Engineer","npc_vjks_imp_army_engineer",{"weapon_vjks_grenadelauncher"},vCat)
VJ.AddNPC_HUMAN("Army Engineer (Friendly)","npc_vjks_imp_army_engineer_f",{"weapon_vjks_grenadelauncher"},vCat)


------------------------- IMPERIAL NAVY

VJ.AddNPC_HUMAN("Navy Officer","npc_vjks_imp_navy_officer",{},vCat)
VJ.AddNPC_HUMAN("Navy Officer (Friendly)","npc_vjks_imp_navy_officer_f",{},vCat)

VJ.AddNPC_HUMAN("Navy Officer [Staff]","npc_vjks_imp_navy_officer_staff",{},vCat)
VJ.AddNPC_HUMAN("Navy Officer [Staff] (Friendly)","npc_vjks_imp_navy_officer_staff_f",{},vCat)

VJ.AddNPC_HUMAN("Navy Crew","npc_vjks_imp_navy_crew",{"weapon_vjks_datapad"},vCat)
VJ.AddNPC_HUMAN("Navy Crew (Friendly)","npc_vjks_imp_navy_crew_f",{"weapon_vjks_datapad"},vCat)

VJ.AddNPC_HUMAN("Navy Trooper","npc_vjks_imp_navy_trooper",{"weapon_vjks_dh17"},vCat)
VJ.AddNPC_HUMAN("Navy Trooper (Friendly)","npc_vjks_imp_navy_trooper_f",{"weapon_vjks_dh17"},vCat)

VJ.AddNPC_HUMAN("Navy Trooper Officer","npc_vjks_imp_navy_trooper_officer",{"weapon_vjks_dh17"},vCat)
VJ.AddNPC_HUMAN("Navy Trooper Officer (Friendly)","npc_vjks_imp_navy_trooper_officer_f",{"weapon_vjks_dh17"},vCat)

VJ.AddNPC_HUMAN("Navy Gunner","npc_vjks_imp_navy_gunner",{"weapon_vjks_dh17","weapon_vjks_se09e","weapon_vjks_se14r"},vCat)
VJ.AddNPC_HUMAN("Navy Gunner (Friendly)","npc_vjks_imp_navy_gunner_f",{"weapon_vjks_dh17","weapon_vjks_se09e","weapon_vjks_se14r"},vCat)

VJ.AddNPC_HUMAN("Death Star Trooper","npc_vjks_imp_navy_death_star_trooper",{"weapon_vjks_e11"},vCat)
VJ.AddNPC_HUMAN("Death Star Trooper (Friendly)","npc_vjks_imp_navy_death_star_trooper_f",{"weapon_vjks_e11"},vCat)


------------------------- IMPERIAL SECURITY

VJ.AddNPC_HUMAN("ISB Officer","npc_vjks_imp_isb_officer",{},vCat)
VJ.AddNPC_HUMAN("ISB Officer (Friendly)","npc_vjks_imp_isb_officer_f",{},vCat)

VJ.AddNPC_HUMAN("ISB Officer [Staff]","npc_vjks_imp_isb_officer_staff",{},vCat)
VJ.AddNPC_HUMAN("ISB Officer [Staff] (Friendly)","npc_vjks_imp_isb_officer_staff_f",{},vCat)

VJ.AddNPC_HUMAN("Security Officer","npc_vjks_imp_security_officer",{"weapon_vjks_se09e"},vCat)
VJ.AddNPC_HUMAN("Security Officer (Friendly)","npc_vjks_imp_security_officer_f",{"weapon_vjks_se09e"},vCat)

VJ.AddNPC_HUMAN("Security Officer [Staff]","npc_vjks_imp_security_officer_staff",{"weapon_vjks_se09e"},vCat)
VJ.AddNPC_HUMAN("Security Officer [Staff] (Friendly)","npc_vjks_imp_security_officer_staff_f",{"weapon_vjks_se09e"},vCat)

VJ.AddNPC_HUMAN("Police Officer","npc_vjks_imp_police_officer",{"weapon_vjks_se14r","weapon_vjks_se09e"},vCat)
VJ.AddNPC_HUMAN("Police Officer (Friendly)","npc_vjks_imp_police_officer_f",{"weapon_vjks_se14r","weapon_vjks_se09e"},vCat)

VJ.AddNPC_HUMAN("Police Trooper","npc_vjks_imp_police_trooper",{"weapon_vjks_e10","weapon_vjks_dh21"},vCat)
VJ.AddNPC_HUMAN("Police Trooper (Friendly)","npc_vjks_imp_police_trooper_f",{"weapon_vjks_e10","weapon_vjks_dh21"},vCat)

VJ.AddNPC_HUMAN("Police Patrolman","npc_vjks_imp_police_patrolman",{"weapon_vjks_se14r","weapon_vjks_dh17"},vCat)
VJ.AddNPC_HUMAN("Police Patrolman (Friendly)","npc_vjks_imp_police_patrolman_f",{"weapon_vjks_se14r","weapon_vjks_dh17"},vCat)


local vCat = "VJ-Galactic Empire - Training" -- Category
------------------------- IMPERIAL TRAINING

VJ.AddNPC_HUMAN("Elite","npc_vjks_imp_train_st_trooper",{"weapon_vjks_e11_training"},vCat)

VJ.AddNPC_HUMAN("Trooper","npc_vjks_imp_train_st_trooper",{"weapon_vjks_e11_training"},vCat)



VJ.AddNPCWeapon("[GF]_Datapad", "weapon_vjks_datapad")

VJ.AddNPCWeapon("[GF]_E-11", "weapon_vjks_e11")
VJ.AddNPCWeapon("[GF]_E-11_Training", "weapon_vjks_e11_training")
VJ.AddNPCWeapon("[GF]_E-22", "weapon_vjks_e22")
VJ.AddNPCWeapon("[GF]_se14r", "weapon_vjks_se14r")
VJ.AddNPCWeapon("[GF]_dh03", "weapon_vjks_dh03")
VJ.AddNPCWeapon("[GF]_dh17", "weapon_vjks_dh17")
VJ.AddNPCWeapon("[GF]_dh21", "weapon_vjks_dh21")
VJ.AddNPCWeapon("[GF]_E-10", "weapon_vjks_e10")
VJ.AddNPCWeapon("[GF]_se09e", "weapon_vjks_se09e")
VJ.AddNPCWeapon("[GF]_DLT-22b", "weapon_vjks_dlt20")
VJ.AddNPCWeapon("[GF]_DLT-19", "weapon_vjks_dlt19")
VJ.AddNPCWeapon("[GF]_T-21", "weapon_vjks_t21")
VJ.AddNPCWeapon("[GF]_E-11d", "weapon_vjks_e11d")
VJ.AddNPCWeapon("[GF]_TC-55", "weapon_vjks_tc55")
VJ.AddNPCWeapon("[GF]_ImpRocketLauncher", "weapon_vjks_rocketlauncher")
VJ.AddNPCWeapon("[GF]_ImpGrenLauncher", "weapon_vjks_grenadelauncher")

VJ.AddEntity("Imperial Thermal Detonator","obj_vjks_thermaldetonator",vCat)
VJ.AddEntity("Imperial Stormtrooper Grenade","obj_vjks_stormdetonator",vCat)



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

