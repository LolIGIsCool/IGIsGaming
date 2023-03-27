local util = util
local pairs = pairs
local table = table
local istable = istable
local IsInWorld = util.IsInWorld
local TraceLine = util.TraceLine
local QuickTrace = util.QuickTrace
local Effect = util.Effect
local MASK_ALL = MASK_ALL
local game = game
local gameAddParticles = game.AddParticles
local gameAddDecal = game.AddDecal
local PrecacheParticleSystem = PrecacheParticleSystem
local GRED_SVAR = { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY }
local CreateConVar = CreateConVar
local CreateClientConVar = CreateClientConVar
local tableinsert = table.insert
local IsValid = IsValid
local DMG_BLAST = DMG_BLAST
local CLIENT = CLIENT

-- Adding particles
gred.CVars = gred.CVars or {}
gred.CVars["gred_sv_easyuse"] 								= CreateConVar("gred_sv_easyuse"								,  "1"  , GRED_SVAR) 
gred.CVars["gred_sv_12mm_he_impact"] 						= CreateConVar("gred_sv_12mm_he_impact"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_7mm_he_impact"] 						= CreateConVar("gred_sv_7mm_he_impact"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_fragility"] 							= CreateConVar("gred_sv_fragility"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shockwave_unfreeze"] 					= CreateConVar("gred_sv_shockwave_unfreeze"						,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_tracers"] 								= CreateConVar("gred_sv_tracers"								,  "5"  , GRED_SVAR)
gred.CVars["gred_sv_oldrockets"] 							= CreateConVar("gred_sv_oldrockets"								,  "0"  , GRED_SVAR)
gred.CVars["gred_jets_speed"] 								= CreateConVar("gred_jets_speed"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_healthslider"] 							= CreateConVar("gred_sv_healthslider"							, "100" , GRED_SVAR)
gred.CVars["gred_sv_enablehealth"] 							= CreateConVar("gred_sv_enablehealth"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_enableenginehealth"] 					= CreateConVar("gred_sv_enableenginehealth"						,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_fire_effect"] 							= CreateConVar("gred_sv_fire_effect"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_multiple_fire_effects"] 				= CreateConVar("gred_sv_multiple_fire_effects"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_bullet_dmg"] 							= CreateConVar("gred_sv_bullet_dmg"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_bullet_radius"] 						= CreateConVar("gred_sv_bullet_radius"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_soundspeed_divider"] 					= CreateConVar("gred_sv_soundspeed_divider"						,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_arti_spawnaltitude"] 					= CreateConVar("gred_sv_arti_spawnaltitude"						, "1000", GRED_SVAR)
gred.CVars["gred_sv_wac_radio"] 							= CreateConVar("gred_sv_wac_radio"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_spawnable_bombs"] 						= CreateConVar("gred_sv_spawnable_bombs"						,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_wac_bombs"] 							= CreateConVar("gred_sv_wac_bombs"								,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_speed_multiplier"] 				= CreateConVar("gred_sv_shell_speed_multiplier"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_wac_explosion_water"] 					= CreateConVar("gred_sv_wac_explosion_water"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_default_wac_munitions"] 				= CreateConVar("gred_sv_default_wac_munitions"					,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_wac_explosion"] 						= CreateConVar("gred_sv_wac_explosion"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_wac_heli_spin"] 						= CreateConVar("gred_sv_wac_heli_spin"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_wac_heli_spin_chance"] 					= CreateConVar("gred_sv_wac_heli_spin_chance"					,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_lfs_healthmultiplier"] 					= CreateConVar("gred_sv_lfs_healthmultiplier"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_lfs_healthmultiplier_all"] 				= CreateConVar("gred_sv_lfs_healthmultiplier_all"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_wac_override"] 							= CreateConVar("gred_sv_wac_override"							,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_override_hab"] 							= CreateConVar("gred_sv_override_hab"							,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_lfs_godmode"] 							= CreateConVar("gred_sv_lfs_godmode"							,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_lfs_infinite_ammo"] 					= CreateConVar("gred_sv_lfs_infinite_ammo"						,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_minricochetangle"] 						= CreateConVar("gred_sv_minricochetangle"						, "70"  , GRED_SVAR)
gred.CVars["gred_sv_shell_ap_damagemultiplier"]				= CreateConVar("gred_sv_shell_ap_damagemultiplier"				, "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_arcade"] 						= CreateConVar("gred_sv_simfphys_arcade"						,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_infinite_ammo"] 				= CreateConVar("gred_sv_simfphys_infinite_ammo"					,  "1"  , GRED_SVAR)
-- gred.CVars["gred_sv_simfphys_bullet_dmg_tanks"] 			= CreateConVar("gred_sv_simfphys_bullet_dmg_tanks"				,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_spawnwithoutammo"] 			= CreateConVar("gred_sv_simfphys_spawnwithoutammo"				,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_enablecrosshair"] 				= CreateConVar("gred_sv_simfphys_enablecrosshair"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_lesswheels"] 					= CreateConVar("gred_sv_simfphys_lesswheels"					,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_turnrate_multplier"] 			= CreateConVar("gred_sv_simfphys_turnrate_multplier"			,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_simfphys_health_multplier"] 			= CreateConVar("gred_sv_simfphys_health_multplier"				,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_ap_lowpen_system"] 				= CreateConVar("gred_sv_shell_ap_lowpen_system"					,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_ap_lowpen_shoulddecreasedamage"] 	= CreateConVar("gred_sv_shell_ap_lowpen_shoulddecreasedamage"	,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_ap_lowpen_maxricochetchance"] 	= CreateConVar("gred_sv_shell_ap_lowpen_maxricochetchance"		,  "1"  , GRED_SVAR)
gred.CVars["gred_sv_shell_ap_lowpen_heat_damage"] 			= CreateConVar("gred_sv_shell_ap_lowpen_heat_damage"			,  "0"  , GRED_SVAR)
gred.CVars["gred_sv_shell_ap_lowpen_ap_damage"] 			= CreateConVar("gred_sv_shell_ap_lowpen_ap_damage"				,  "0"  , GRED_SVAR)

gred = gred or {}
gred.AllNPCs = {}
gred.Calibre = {}
tableinsert(gred.Calibre,"wac_base_7mm")
tableinsert(gred.Calibre,"wac_base_12mm")
tableinsert(gred.Calibre,"wac_base_20mm")
tableinsert(gred.Calibre,"wac_base_30mm")
tableinsert(gred.Calibre,"wac_base_40mm")
gred.Mats = {
	default_silent			=	-1,
	floatingstandable		=	-1,
	no_decal				=	-1,
	
	boulder 				=	1,
	concrete				=	1,
	default					=	1,
	item					=	1,
	concrete_block			=	1,
	plaster					=	1,
	pottery					=	1,
	
	dirt					=	2,
			
	alienflesh				=	3,
	antlion					=	3,
	armorflesh				=	3,
	bloodyflesh				=	3,
	player					=	3,
	flesh					=	3,
	player_control_clip		=	3,
	zombieflesh				=	3,

	glass					=	4,
	ice						=	4,
	glassbottle				=	4,
	combine_glass			=	4,
		
	canister				=	5,
	chain					=	5,
	chainlink				=	5,
	combine_metal			=	5,
	crowbar					=	5,
	floating_metal_barrel	=	5,
	grenade					=	5,
	metal					=	5,
	metal_barrel			=	5,
	metal_bouncy			=	5,
	metal_Box				=	5,
	metal_seafloorcar		=	5,
	metalgrate				=	5,
	metalpanel				=	5,
	metalvent				=	5,
	metalvehicle			=	5,
	paintcan				=	5,
	roller					=	5,
	slipperymetal			=	5,
	solidmetal				=	5,
	strider					=	5,
	popcan					=	5,
	weapon					=	5,
		
	quicksand				=	6,
	sand					=	6,
	slipperyslime			=	6,
	antlionsand				=	6,
	
	snow					=	7,
		
	foliage					=	8,
	
	wood					=	9,
	wood_box				=	9,
	wood_crate 				=	9,
	wood_furniture			=	9,
	wood_lowDensity 		=	9,
	ladder 					=	9,
	wood_plank				=	9,
	wood_panel				=	9,
	wood_polid				=	9,
		
	grass					=	10,
	
	tile					=	11,
	ceiling_tile			=	11,
	
	plastic_barrel			=	12,
	plastic_barrel_buoyant	=	12,
	Plastic_Box				=	12,
	plastic					=	12,
	
	baserock 				=	13,
	rock					=	13,
	
	gravel					=	14,
	
	mud						=	15,
	
	watermelon				=	16,
		
	asphalt 				=	17,
	
	cardbaord 				=	18,
		
	rubber 					=	19,
	rubbertire 				=	19,
	slidingrubbertire 		=	19,
	slidingrubbertire_front =	19,
	slidingrubbertire_rear 	=	19,
	jeeptire 				=	19,
	brakingrubbertire 		=	19,
	
	carpet 					=	20,
	brakingrubbertire 		=	20,
	
	brick					=	21,
		
	foliage					=	22,
	
	paper 					=	23,
	papercup 				=	23,
		
	computer				=	24,
}

gred.Precache = function()
	gameAddParticles( "particles/doi_explosion_fx.pcf")
	gameAddParticles( "particles/doi_explosion_fx_b.pcf")
	gameAddParticles( "particles/doi_explosion_fx_c.pcf")
	gameAddParticles( "particles/doi_explosion_fx_grenade.pcf")
	gameAddParticles( "particles/doi_explosion_fx_new.pcf")
	gameAddParticles( "particles/doi_impact_fx.pcf" )
	gameAddParticles( "particles/doi_weapon_fx.pcf" )

	gameAddParticles( "particles/gb_water.pcf")
	gameAddParticles( "particles/gb5_100lb.pcf")
	gameAddParticles( "particles/gb5_500lb.pcf")
	gameAddParticles( "particles/gb5_1000lb.pcf")
	gameAddParticles( "particles/gb5_jdam.pcf")
	gameAddParticles( "particles/gb5_large_explosion.pcf")
	gameAddParticles( "particles/gb5_napalm.pcf")
	gameAddParticles( "particles/gb5_light_bomb.pcf")
	gameAddParticles( "particles/gb5_high_explosive_2.pcf")
	gameAddParticles( "particles/gb5_high_explosive.pcf")
	gameAddParticles( "particles/gb5_fireboom.pcf")
	gameAddParticles( "particles/neuro_tank_ap.pcf")

	gameAddParticles( "particles/ins_rockettrail.pcf")
	gameAddParticles( "particles/ammo_cache_ins.pcf")
	gameAddParticles( "particles/doi_rockettrail.pcf")
	gameAddParticles( "particles/mnb_flamethrower.pcf")
	gameAddParticles( "particles/impact_fx_ins.pcf" )
	gameAddParticles( "particles/environment_fx.pcf")
	gameAddParticles( "particles/water_impact.pcf")
	gameAddParticles( "particles/explosion_fx_ins.pcf")
	gameAddParticles( "particles/weapon_fx_tracers.pcf" )
	gameAddParticles( "particles/weapon_fx_ins.pcf" )

	gameAddParticles( "particles/gred_particles.pcf" )
	gameAddParticles( "particles/fire_01.pcf" )
	gameAddParticles( "particles/doi_explosions_smoke.pcf" )
	gameAddParticles( "particles/explosion_fx_ins_b.pcf" )
	gameAddParticles( "particles/ins_smokegrenade.pcf" )
	gameAddParticles( "particles/ww1_gas.pcf" )
	-- gameAddParticles( "particles/world_fx_ins.pcf" )

	-- Precaching main particles
	gred.Particles = {} 						
	tableinsert(gred.Particles,"gred_20mm")
	tableinsert(gred.Particles,"gred_20mm_airburst")
	tableinsert(gred.Particles,"gred_40mm")
	tableinsert(gred.Particles,"gred_40mm_airburst")
	tableinsert(gred.Particles,"30cal_impact")
	tableinsert(gred.Particles,"fire_large_01")
	tableinsert(gred.Particles,"30cal_impact")
	tableinsert(gred.Particles,"doi_gunrun_impact")
	tableinsert(gred.Particles,"doi_artillery_explosion")
	tableinsert(gred.Particles,"doi_stuka_explosion")
	tableinsert(gred.Particles,"gred_mortar_explosion")
	tableinsert(gred.Particles,"gred_50mm")
	tableinsert(gred.Particles,"ins_rpg_explosion")
	tableinsert(gred.Particles,"ins_water_explosion")
	tableinsert(gred.Particles,"fireboom_explosion_midair")
	tableinsert(gred.Particles,"doi_petrol_explosion")

	tableinsert(gred.Particles,"doi_impact_water")
	tableinsert(gred.Particles,"ins_impact_water")
	tableinsert(gred.Particles,"water_small")
	tableinsert(gred.Particles,"water_medium")
	tableinsert(gred.Particles,"water_huge")

	tableinsert(gred.Particles,"muzzleflash_sparks_variant_6")
	tableinsert(gred.Particles,"muzzleflash_1p_glow")
	tableinsert(gred.Particles,"muzzleflash_m590_1p_core")
	tableinsert(gred.Particles,"muzzleflash_smoke_small_variant_1")
	for i = 0,1 do
		if i == 1 then pcfD = "ins_" else pcfD = "doi_" end
		tableinsert(gred.Particles,""..pcfD.."impact_concrete")
		tableinsert(gred.Particles,""..pcfD.."impact_dirt")
		tableinsert(gred.Particles,""..pcfD.."impact_glass")
		tableinsert(gred.Particles,""..pcfD.."impact_metal")
		tableinsert(gred.Particles,""..pcfD.."impact_sand")
		tableinsert(gred.Particles,""..pcfD.."impact_snow")
		tableinsert(gred.Particles,""..pcfD.."impact_leaves")
		tableinsert(gred.Particles,""..pcfD.."impact_wood")
		tableinsert(gred.Particles,""..pcfD.."impact_grass")
		tableinsert(gred.Particles,""..pcfD.."impact_tile")
		tableinsert(gred.Particles,""..pcfD.."impact_plastic")
		tableinsert(gred.Particles,""..pcfD.."impact_rock")
		tableinsert(gred.Particles,""..pcfD.."impact_gravel")
		tableinsert(gred.Particles,""..pcfD.."impact_mud")
		tableinsert(gred.Particles,""..pcfD.."impact_fruit")
		tableinsert(gred.Particles,""..pcfD.."impact_asphalt")
		tableinsert(gred.Particles,""..pcfD.."impact_cardboard")
		tableinsert(gred.Particles,""..pcfD.."impact_rubber")
		tableinsert(gred.Particles,""..pcfD.."impact_carpet")
		tableinsert(gred.Particles,""..pcfD.."impact_brick")
		tableinsert(gred.Particles,""..pcfD.."impact_leaves")
		tableinsert(gred.Particles,""..pcfD.."impact_paper")
		tableinsert(gred.Particles,""..pcfD.."impact_computer")
	end

	tableinsert(gred.Particles,"high_explosive_main_2")
	tableinsert(gred.Particles,"high_explosive_air_2")
	tableinsert(gred.Particles,"water_torpedo")
	tableinsert(gred.Particles,"high_explosive_air")
	tableinsert(gred.Particles,"napalm_explosion")
	tableinsert(gred.Particles,"napalm_explosion_midair")
	tableinsert(gred.Particles,"cloudmaker_ground")
	tableinsert(gred.Particles,"1000lb_explosion")
	tableinsert(gred.Particles,"500lb_air")
	tableinsert(gred.Particles,"100lb_air")
	tableinsert(gred.Particles,"500lb_ground")
	tableinsert(gred.Particles,"rockettrail")
	tableinsert(gred.Particles,"grenadetrail")
	tableinsert(gred.Particles,"gred_ap_impact")
	tableinsert(gred.Particles,"doi_mortar_explosion")
	tableinsert(gred.Particles,"doi_wparty_explosion")
	tableinsert(gred.Particles,"doi_smoke_artillery")
	tableinsert(gred.Particles,"doi_ceilingDust_large")
	tableinsert(gred.Particles,"m203_smokegrenade")
	tableinsert(gred.Particles,"doi_GASarty_explosion")
	tableinsert(gred.Particles,"doi_compb_explosion")
	tableinsert(gred.Particles,"doi_wpgrenade_explosion")
	tableinsert(gred.Particles,"ins_c4_explosion")
	tableinsert(gred.Particles,"doi_artillery_explosion_OLD")
	tableinsert(gred.Particles,"gred_highcal_rocket_explosion")

	tableinsert(gred.Particles,"muzzleflash_bar_3p")
	tableinsert(gred.Particles,"muzzleflash_garand_3p")
	tableinsert(gred.Particles,"muzzleflash_mg42_3p")
	tableinsert(gred.Particles,"ins_weapon_at4_frontblast")
	tableinsert(gred.Particles,"ins_weapon_rpg_dust")
	tableinsert(gred.Particles,"gred_arti_muzzle_blast")
	tableinsert(gred.Particles,"gred_mortar_explosion_smoke_ground")
	tableinsert(gred.Particles,"weapon_muzzle_smoke")
	tableinsert(gred.Particles,"ins_ammo_explosionOLD")
	tableinsert(gred.Particles,"gred_ap_impact")
	tableinsert(gred.Particles,"AP_impact_wall")
	tableinsert(gred.Particles,"ins_m203_explosion")
	tableinsert(gred.Particles,"ins_weapon_rpg_frontblast")
	tableinsert(gred.Particles,"gred_arti_muzzle_blast_alt")
	tableinsert(gred.Particles,"doi_wprocket_explosion")
	tableinsert(gred.Particles,"gred_tracers_red_7mm")
	tableinsert(gred.Particles,"gred_tracers_green_7mm")
	tableinsert(gred.Particles,"gred_tracers_white_7mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_7mm")
	tableinsert(gred.Particles,"gred_tracers_red_12mm")
	tableinsert(gred.Particles,"gred_tracers_green_12mm")
	tableinsert(gred.Particles,"gred_tracers_white_12mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_12mm")
	tableinsert(gred.Particles,"gred_tracers_red_20mm")
	tableinsert(gred.Particles,"gred_tracers_green_20mm")
	tableinsert(gred.Particles,"gred_tracers_white_20mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_20mm")
	tableinsert(gred.Particles,"gred_tracers_red_30mm")
	tableinsert(gred.Particles,"gred_tracers_green_30mm")
	tableinsert(gred.Particles,"gred_tracers_white_30mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_30mm")
	tableinsert(gred.Particles,"gred_tracers_red_40mm")
	tableinsert(gred.Particles,"gred_tracers_green_40mm")
	tableinsert(gred.Particles,"gred_tracers_white_40mm")
	tableinsert(gred.Particles,"gred_tracers_yellow_40mm")
	tableinsert(gred.Particles,"flame_jet")
	tableinsert(gred.Particles,"doi_flak88_explosion")
	tableinsert(gred.Particles,"flamethrower_long")
	tableinsert(gred.Particles,"ap_impact_dirt")
	for k,v in pairs(gred.Particles) do PrecacheParticleSystem(v) end

	gameAddDecal( "scorch_small",		"decals/scorch_small" );
	gameAddDecal( "scorch_medium",		"decals/scorch_medium" );
	gameAddDecal( "scorch_big",			"decals/scorch_big" );
	gameAddDecal( "scorch_huge",		"decals/scorch_huge" );
	gameAddDecal( "scorch_gigantic",	"decals/scorch_gigantic" );
	gameAddDecal( "scorch_x10",			"decals/scorch_x10" );


	local filecount = 0
	local foldercount = 0
	local utilPrecacheModel = util.PrecacheModel
	local precache = function( dir, flst ) -- .mdl file list precahcer
		for _, _f in ipairs( flst ) do
			utilPrecacheModel( dir.."/".._f )
			filecount = filecount + 1
		end
	end

	findDir = function( parent, direcotry, foot ) -- internal shit
		local flst, a = file.Find( parent.."/"..direcotry.."/"..foot, "GAME" )
		local b, dirs = file.Find( parent.."/"..direcotry.."/*", "GAME" )
		for k,v in ipairs(dirs) do
			findDir(parent.."/"..direcotry,v,foot)
			foldercount = foldercount + 1
		end
		precache( parent.."/"..direcotry, flst )
	end
	timer.Simple(1,function()
		findDir( "models", "gredwitch", "*.mdl" )

		print("[GREDWITCH'S BASE] Precached "..filecount.." files in "..foldercount.." folders.")
	end)
end

gred.Precache()


gred.AddonList = gred.AddonList or {}
tableinsert(gred.AddonList,1582297878) -- Materials

if CLIENT then
	local ply = LocalPlayer()
	
	gred.simfphys = gred.simfphys or {}
	gred.CVars["gred_cl_sound_shake"] 							= CreateClientConVar("gred_cl_sound_shake"							, "1" ,true,false)
	gred.CVars["gred_cl_nowaterimpacts"] 						= CreateClientConVar("gred_cl_nowaterimpacts"						, "0" ,true,false)
	gred.CVars["gred_cl_insparticles"]		 					= CreateClientConVar("gred_cl_insparticles"							, "0" ,true,false)
	gred.CVars["gred_cl_noparticles_7mm"] 						= CreateClientConVar("gred_cl_noparticles_7mm"						, "0" ,true,false)
	gred.CVars["gred_cl_noparticles_12mm"] 						= CreateClientConVar("gred_cl_noparticles_12mm"						, "0" ,true,false)
	gred.CVars["gred_cl_noparticles_20mm"] 						= CreateClientConVar("gred_cl_noparticles_20mm"						, "0" ,true,false)
	gred.CVars["gred_cl_noparticles_30mm"] 						= CreateClientConVar("gred_cl_noparticles_30mm"						, "0" ,true,false)
	gred.CVars["gred_cl_noparticles_40mm"] 						= CreateClientConVar("gred_cl_noparticles_40mm"						, "0" ,true,false)
	gred.CVars["gred_cl_decals"] 								= CreateClientConVar("gred_cl_decals"								, "1" ,true,false)
	gred.CVars["gred_cl_altmuzzleeffect"] 						= CreateClientConVar("gred_cl_altmuzzleeffect"						, "0" ,true,false)
	gred.CVars["gred_cl_wac_explosions"] 						= CreateClientConVar("gred_cl_wac_explosions" 						, "1" ,true,false)
	gred.CVars["gred_cl_enable_popups"] 						= CreateClientConVar("gred_cl_enable_popups"	 					, "1" ,true,false)
	gred.CVars["gred_cl_firstload"] 							= CreateClientConVar("gred_cl_firstload"							, "1" ,true,false)
	gred.CVars["gred_cl_simfphys_sightsensitivity"] 			= CreateClientConVar("gred_cl_simfphys_sightsensitivity"			,"0.25",true,false)
	gred.CVars["gred_cl_simfphys_maxsuspensioncalcdistance"] 	= CreateClientConVar("gred_cl_simfphys_maxsuspensioncalcdistance"	, "85000000" ,true,false)
	
	local TAB_PRESS = {FCVAR_ARCHIVE,FCVAR_USERINFO}
	CreateConVar("gred_cl_simfphys_key_changeshell"			, "21",TAB_PRESS)
	CreateConVar("gred_cl_simfphys_key_togglesight"			, "22",TAB_PRESS)
	CreateConVar("gred_cl_simfphys_key_togglegun"			, "23",TAB_PRESS)
	
	
	local Created
	local NextThink = 0
	local NextFind = 0
	local id = 0
	local SIMFPHYS_COLOR = Color(255,235,0)
	
	
	
	local function GetTrackPos(ent,div,smoother) -- taken from simfphys (by Luna)
		local FT =  FrameTime()
		local spin_left = ent.trackspin_l and (-ent.trackspin_l / div) or 0
		local spin_right = ent.trackspin_r and (-ent.trackspin_r / div) or 0
		
		ent.sm_TrackDelta_L = ent.sm_TrackDelta_L and (ent.sm_TrackDelta_L + (spin_left - ent.sm_TrackDelta_L) * smoother) or 0
		ent.sm_TrackDelta_R = ent.sm_TrackDelta_R and (ent.sm_TrackDelta_R + (spin_right- ent.sm_TrackDelta_R) * smoother) or 0

		return {Left = ent.sm_TrackDelta_L,Right = ent.sm_TrackDelta_R}
	end
	
	local function GetAllTanks()
		local class
		for k,v in pairs(gred.simfphys) do
			v.entities = {}
		end
		for k,v in pairs(ents.FindByClass("gmod_sent_vehicle_fphysics_base")) do
			class = v:GetSpawn_List()
			if gred.simfphys[class] then
				tableinsert(gred.simfphys[class].entities,v)
			end
		end
	end
	
	local function RoundAngle(ang,decimals)
		ang.p = math.Round(ang.p,decimals)
		ang.r = math.Round(ang.r,decimals)
		return ang
	end
	
	local function DrawAmmoLeft(vehicle,scrW,scrH)
		local sizex = scrW * ((scrW / scrH) > (4/3) and 1 or 1.32)
		local s_xpos = scrW * 0.5 - sizex * 0.115 - sizex * 0.032
		local s_ypos = scrH - scrH * 0.092 - scrH * 0.02
		local shelltype = vehicle:GetNWInt("ShellType",1)
		draw.SimpleText("SHELLTYPE: "..vehicle.shellTypes[shelltype]..(vehicle:GetNWBool("Reloading",false) and " [RELOADING]" or ""),"simfphysfont", s_xpos + sizex * 0.185, s_ypos + scrH*0.012 ,SIMFPHYS_COLOR,0,1)
		draw.SimpleText("AMMO: "..vehicle:GetNWInt("CurAmmo"..shelltype,0),"simfphysfont", s_xpos + sizex * 0.185, s_ypos + scrH*0.035 ,SIMFPHYS_COLOR,0,1)
	end
	
	local function DrawWorldTip(text,pos,tipcol,font,offset)
		pos = pos:ToScreen()
		local black = Color(0,0,0,tipcol.a)
		
		local x = 0
		local y = 0
		local padding = 10
		
		surface.SetFont(font)
		local w,h = surface.GetTextSize(text)
		
		x = pos.x - w*0.5
		y = pos.y - h*0.5 - offset
		
		draw.RoundedBox(8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, black)
		draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, tipcol )
		draw.DrawText(text,font,x+w/2,y,black,TEXT_ALIGN_CENTER)

	end
	
	local function DrawCircle( X, Y, radius ) -- copyright LunasFlightSchool™
		local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
		
		for a = 0, 360 - segmentdist, segmentdist do
			surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
		end
	end

	local function gred_settings_bullets(CPanel)
		CPanel:ClearControls()
		
		-- if notdedicated then
			local this = CPanel:CheckBox("Should 12mm MGs have a radius?","gred_sv_12mm_he_impact" );
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_12mm_he_impact",val)
			end
					
			local this = CPanel:CheckBox("Should 7mm MGs have a radius?","gred_sv_7mm_he_impact" );
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_7mm_he_impact",val)
			end
			
			local this = CPanel:NumSlider( "Bullet damage multiplier","gred_sv_bullet_dmg",0,10,2 );this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand("gred_sv_bullet_dmg",val)
			end
			
			local this = CPanel:NumSlider( "Bullet radius multiplier","gred_sv_bullet_radius",0,10,2 );this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand("gred_sv_bullet_radius",val)
			end
			
			local this = CPanel:NumSlider( "Tracer ammo apparition", "gred_sv_tracers", 0, 20, 0 );this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand("gred_sv_tracers",val)
			end
			
			if hab and hab.Module.PhysBullet then
				local this = CPanel:CheckBox("Override Havok's physical bullets?","gred_sv_override_hab" );
				this.OnChange = function(this,val)
					val = val and 1 or 0
					gred.CheckConCommand("gred_sv_override_hab",val)
				end
			end
		-- end
		
		CPanel:CheckBox("Use Insurgency impact effects for 7mm MGs?","gred_cl_insparticles" );
		
		CPanel:CheckBox("Disable impact effects for 7mm MGs?","gred_cl_noparticles_7mm" );
		
		CPanel:CheckBox("Disable impact effects for 12mm MGs?","gred_cl_noparticles_12mm" );
		
		CPanel:CheckBox("Disable impact effects for 20mm cannons?","gred_cl_noparticles_20mm" );
		
		CPanel:CheckBox("Disable impact effects for 30mm cannons?","gred_cl_noparticles_30mm" );
		
		CPanel:CheckBox("Disable impact effects for 40mm cannons?","gred_cl_noparticles_40mm" );
		
		CPanel:CheckBox("Disable water impact effects?","gred_cl_nowaterimpacts" );
	end

	local function gred_settings_wac(CPanel)
		CPanel:ClearControls()
		
		CPanel:AddPanel( plane );
		-- if notdedicated then
		
			local this = CPanel:CheckBox("Override the WAC base?","gred_sv_wac_override");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_wac_override",val)
			end
			
			local this = CPanel:CheckBox("Use old rockets?","gred_sv_oldrockets");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_oldrockets",val)
			end
			
			local this = CPanel:CheckBox("Enable bombs in aircrafts?","gred_sv_wac_bombs");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_wac_bombs",val)
			end
			
			local this = CPanel:CheckBox("Enable radio sounds?","gred_sv_wac_radio");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_wac_radio",val)
			end
			
			local this = CPanel:CheckBox("Should jets be very fast?","gred_jets_speed");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_jets_speed",val)
			end
			
			local this = CPanel:CheckBox("Should aircrafts crash underwater?","gred_sv_wac_explosion_water");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_wac_explosion_water",val)
			end
			
			local this = CPanel:CheckBox("Should aircrafts crash?","gred_sv_wac_explosion");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_wac_explosion",val)
			end
			
			local this = CPanel:CheckBox("Use the default WAC munitions?","gred_sv_default_wac_munitions");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_default_wac_munitions",val)
			end
		
			local this = CPanel:CheckBox("Should helicopters spin when their health is low?","gred_sv_wac_heli_spin");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_wac_heli_spin",val)
			end
			
			local this = CPanel:CheckBox("Use a custom health system?","gred_sv_enablehealth");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_enablehealth",val)
			end
			
			local this = CPanel:CheckBox("Use a health per engine system?","gred_sv_enableenginehealth");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_enableenginehealth",val)
			end
			
			local this = CPanel:NumSlider( "Default engine health", "gred_sv_healthslider", 1, 1000, 0 );this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand("gred_sv_healthslider",val)
			end
			
			local this = CPanel:NumSlider( "Helicopter spin chance", "gred_sv_wac_heli_spin_chance", 1, 10, 0 );this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand("gred_sv_wac_heli_spin_chance",val)
			end
			
			local this = CPanel:CheckBox("Use alternative fire particles?","gred_sv_fire_effect");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_fire_effect",val)
			end
				
			local this = CPanel:CheckBox("Use multiple fire particles?","gred_sv_multiple_fire_effects");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_multiple_fire_effects",val)
			end
		-- end
		
		CPanel:CheckBox("Enable explosion particles?","gred_cl_wac_explosions");
		
	end

	local function gred_settings_misc(CPanel)
		CPanel:ClearControls()
		
		Created = true;
		
		CPanel:CheckBox("Use an alternative muzzleflash?","gred_cl_altmuzzleeffect");
		CPanel:CheckBox("Enable pop ups about missing content?","gred_cl_enable_popups");
	end
	
	local function gred_settings_simfphys(CPanel)
		CPanel:ClearControls()
		
		Created = true;
		
		local this = CPanel:CheckBox("Arcade mode","gred_sv_simfphys_arcade");
		local parent = this:GetParent()
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_simfphys_arcade",val)
		end
		
		local this = CPanel:CheckBox("Infinite ammo","gred_sv_simfphys_infinite_ammo");
		local parent = this:GetParent()
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_simfphys_infinite_ammo",val)
		end
		
		local this = CPanel:CheckBox("Enable 3rd person crosshair?","gred_sv_simfphys_enablecrosshair");
		local parent = this:GetParent()
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_simfphys_enablecrosshair",val)
		end
		
		local this = CPanel:CheckBox("Use 4 wheels instead of 6 for tanks?","gred_sv_simfphys_lesswheels");
		local parent = this:GetParent()
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_simfphys_lesswheels",val)
		end
		
		local this = CPanel:CheckBox("Spawn without ammo","gred_sv_simfphys_spawnwithoutammo");
		local parent = this:GetParent()
		this.OnChange = function(this,val)
			val = val and 1 or 0
			gred.CheckConCommand("gred_sv_simfphys_spawnwithoutammo",val)
		end
		
		local this = CPanel:NumSlider("Turn rate multipler", "gred_sv_simfphys_turnrate_multplier",0,3,2);
		this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
		this.OnValueChanged = function(this,val)
			if this.ConVarChanging then return end
			gred.CheckConCommand( "gred_sv_simfphys_turnrate_multplier",val)
		end
		
		local this = CPanel:NumSlider("Health multipler", "gred_sv_simfphys_health_multplier",1,3,2);
		this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
		this.OnValueChanged = function(this,val)
			if this.ConVarChanging then return end
			gred.CheckConCommand( "gred_sv_simfphys_health_multplier",val)
		end
		
		-- local this = CPanel:CheckBox("Should bullets damage tanks?","gred_sv_simfphys_bullet_dmg_tanks");
		-- local parent = this:GetParent()
		-- this.OnChange = function(this,val)
			-- val = val and 1 or 0
			-- gred.CheckConCommand("gred_sv_simfphys_bullet_dmg_tanks",val)
		-- end
		
		local DBinder = vgui.Create("DBinder")
		DBinder:SetValue(GetConVar("gred_cl_simfphys_key_changeshell"):GetInt())
		DBinder.OnChange = function(DBinder,key)
			GetConVar("gred_cl_simfphys_key_changeshell"):SetInt(key)
		end
		CPanel:AddItem(CPanel:Help("Toggle shell types"),DBinder)
		
		local DBinder = vgui.Create("DBinder")
		DBinder:SetValue(GetConVar("gred_cl_simfphys_key_togglesight"):GetInt())
		DBinder.OnChange = function(DBinder,key)
			GetConVar("gred_cl_simfphys_key_togglesight"):SetInt(key)
		end
		CPanel:AddItem(CPanel:Help("Toggle tank sight"),DBinder)
		
		local DBinder = vgui.Create("DBinder")
		DBinder:SetValue(GetConVar("gred_cl_simfphys_key_togglegun"):GetInt())
		DBinder.OnChange = function(DBinder,key)
			GetConVar("gred_cl_simfphys_key_togglegun"):SetInt(key)
		end
		CPanel:AddItem(CPanel:Help("Toggle tank gun"),DBinder)
		
		local this = CPanel:NumSlider("Sensitivity in sight mode","gred_cl_simfphys_sightsensitivity",0,1,2);this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
		this.OnValueChanged = function(this,val)
			if this.ConVarChanging then return end
			GetConVar("gred_cl_simfphys_sightsensitivity"):SetInt(val)
		end
		
		local this = CPanel:NumSlider("Max suspension calculation distance","gred_cl_simfphys_maxsuspensioncalcdistance",0,300000000,0);this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
		this.OnValueChanged = function(this,val)
			if this.ConVarChanging then return end
			GetConVar("gred_cl_simfphys_maxsuspensioncalcdistance"):SetInt(val)
		end
	end

	local function gred_settings_lfs(CPanel)
		CPanel:ClearControls()
		
		-- local msounds={}
		-- msounds[1]="extras/american/outgoingstraferun1.ogg"
		Created = true;
		
		-- local plane = vgui.Create( "DImageButton" );
		-- plane:SetImage( "hud/planes_settings.png" );
		-- plane:SetSize( 200, 80 );
		-- plane.DoClick = function()
			-- local psnd = Sound( table.Random(psounds) );
			-- surface.PlaySound( psnd );
		-- end
		-- CPanel:AddPanel( plane );
		-- if notdedicated then
		
			local this = CPanel:NumSlider( "Aircraft health multiplier", "gred_sv_lfs_healthmultiplier", 1, 10, 2 );this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand("gred_sv_lfs_healthmultiplier",val)
			end
			
			local this = CPanel:CheckBox("Should the health multiplier only apply to Gredwitch's LFS aircrafts?","gred_sv_lfs_healthmultiplier_all");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_lfs_healthmultiplier_all",val)
			end
			
			local this = CPanel:CheckBox("Should LFS aircrafts be invincible?","gred_sv_lfs_godmode");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_lfs_godmode",val)
			end
			
			local this = CPanel:CheckBox("Should LFS aircrafts have infinite ammo?","gred_sv_lfs_infinite_ammo");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_lfs_infinite_ammo",val)
			end
			
		-- end
	end

	local function gred_settings_bombs(CPanel)
		CPanel:ClearControls()
		--[[local sound = "extras/terrorist/allahu.mp3"
		
		Created = true;
		
		local logo = vgui.Create( "DImageButton" );
		logo:SetImage( "hud/bombs_settings.png" );
		logo:SetSize( 250, 250 );
		logo.DoClick = function()
			local snd = Sound( sound );
			surface.PlaySound( snd );
		end
		CPanel:AddPanel( logo );--]]
		
		CPanel:CheckBox("Should there be sound shake when something explodes?","gred_cl_sound_shake");
		
		-- if notdedicated then
			local this = CPanel:CheckBox("Should explosions unweld and unfreeze?","gred_sv_shockwave_unfreeze");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_shockwave_unfreeze",val)
			end
			
			local this = CPanel:NumSlider( "Sound muffling divider", "gred_sv_soundspeed_divider", 1, 3, 0 );
			this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand( "gred_sv_soundspeed_divider",val)
			end
		
			local this = CPanel:NumSlider( "Shell speed multiplier", "gred_sv_shell_speed_multiplier", 0.01, 1, 2 );
			this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand( "gred_sv_shell_speed_multiplier",val)
			end
			local this = CPanel:NumSlider("Ricochet angle", "gred_sv_minricochetangle",50, 90, 1 );
			this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand( "gred_sv_minricochetangle",val)
			end
			local this = CPanel:NumSlider("AP Shell damage multiplier", "gred_sv_shell_ap_damagemultiplier",0,10,2);
			this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand( "gred_sv_shell_ap_damagemultiplier",val)
			end
			local this = CPanel:NumSlider("Max non-penetration ricochet chance", "gred_sv_shell_ap_lowpen_maxricochetchance",0,1,2);
			this.Scratch.OnValueChanged = function() this.ConVarChanging = true this:ValueChanged(this.Scratch:GetFloatValue()) this.ConVarChanging = false end
			this.OnValueChanged = function(this,val)
				if this.ConVarChanging then return end
				gred.CheckConCommand( "gred_sv_shell_ap_lowpen_maxricochetchance",val)
			end
			
			local this = CPanel:CheckBox("Enable advanced non-penetration system?","gred_sv_shell_ap_lowpen_system");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_shell_ap_lowpen_system",val)
			end
			
			local this = CPanel:CheckBox("Should the non-penetration system decrease damage?","gred_sv_shell_ap_lowpen_shoulddecreasedamage");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_shell_ap_lowpen_shoulddecreasedamage",val)
			end
			
			local this = CPanel:CheckBox("Should the AP shells deal no damage at all in case of a non penetration?","gred_sv_shell_ap_lowpen_ap_damage");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_shell_ap_lowpen_ap_damage",val)
			end
			
			local this = CPanel:CheckBox("Should HEAT shells deal damage even if there was no penetration?","gred_sv_shell_ap_lowpen_heat_damage");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_shell_ap_lowpen_heat_damage",val)
			end
			
			local this = CPanel:CheckBox("Should explosives be easily armed?","gred_sv_easyuse");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_easyuse",val)
			end
			
			local this = CPanel:CheckBox("Should explosives be spawnable?","gred_sv_spawnable_bombs");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_spawnable_bombs",val)
			end
			
			local this = CPanel:CheckBox("Should explosives arm when hit or dropped?","gred_sv_fragility");
			this.OnChange = function(this,val)
				val = val and 1 or 0
				gred.CheckConCommand("gred_sv_fragility",val)
			end
		-- end
			
		CPanel:CheckBox("Should explosives leave decals behind?","gred_cl_decals");
		
	end
	
	local function CheckForUpdates()
		local CURRENT_VERSION = ""
		local changelogs = file.Exists("changelog.lua","LUA") and file.Read("changelog.lua","LUA") or false
		changelogs = changelogs or (file.Exists("changelog.lua","lsv") and file.Read("changelog.lua","lsv") or "")
		for i = 1,14 do if !changelogs[i] then break end CURRENT_VERSION = CURRENT_VERSION..changelogs[i] end
		local GITHUB_VERSION = "" 
		local GitHub = http.Fetch("https://raw.githubusercontent.com/Gredwitch/gredwitch-base/master/Base%20Addon/lua/changelog.lua",function(body)
			if !body then return end
			for i = 1,14 do GITHUB_VERSION = GITHUB_VERSION..body[i] end
			if CURRENT_VERSION != GITHUB_VERSION then
				local DFrame = vgui.Create("DFrame")
				DFrame:SetSize(ScrW()*0.9,ScrH()*0.9)
				DFrame:SetTitle("GREDWITCH'S BASE IS OUT OF DATE. EXPECT LUA ERRORS!")
				DFrame:Center()
				DFrame:MakePopup()
				
				local DHTML = vgui.Create("DHTML",DFrame)
				DHTML:Dock(FILL)
				DHTML:OpenURL("https://steamcommunity.com/workshop/filedetails/discussion/1131455085/1640915206496685563/")
			end
		end)
		local exists = file.Exists("gredwitch_base.txt","DATA")
		if !exists or (exists and file.Read("gredwitch_base.txt","DATA") != CURRENT_VERSION) then
			local DFrame = vgui.Create("DFrame")
			DFrame:SetSize(ScrW()*0.5,ScrH()*0.5)
			DFrame:SetTitle("Gredwitch's Base : last update changelogs")
			DFrame:Center()
			DFrame:MakePopup()
			
			local DHTML = vgui.Create("DHTML",DFrame)
			DHTML:Dock(FILL)
			DHTML:OpenURL("https://raw.githubusercontent.com/Gredwitch/gredwitch-base/master/Base%20Addon/lua/changelog.lua")
			
			file.Write("gredwitch_base.txt",CURRENT_VERSION)
		end
	end
	
	local function CheckDXDiag()
		if GetConVar("mat_dxlevel"):GetInt() < 80 then
			local DFrame = vgui.Create("DFrame")
			DFrame:SetSize(ScrW()*0.9,ScrH()*0.9)
			DFrame:SetTitle("DXDIAG ERROR")
			DFrame:Center()
			DFrame:MakePopup()
			
			local DHTML = vgui.Create("DHTML",DFrame)
			DHTML:Dock(FILL)
			DHTML:OpenURL("https://steamcommunity.com/workshop/filedetails/discussion/1131455085/3166519278505386201/")
		end
	end
	
	
	
	gred.CheckConCommand = function(cmd,val)
		net.Start("gred_net_checkconcommand")
			net.WriteString(cmd)
			net.WriteFloat(val)
		net.SendToServer()
	end
	
	gred.UpdateBoneTable = function(self)
		if self.CreatingBones then return end
		self.Bones = nil
		timer.Simple(0,function()
			if !self or (self and !IsValid(self)) then return end
			if self.CreatingBones then return end
			self.CreatingBones = true
			self:SetLOD(0)
			self.Bones = {}
			local name
			for i=0, self:GetBoneCount()-1 do
				name = self:GetBoneName(i)
				if name == "__INVALIDBONE__" and ((self.BoneBlackList and !self.BoneBlackList[i]) or !self.BoneBlackList) and i != 0 then
					print("["..self.ClassName.."] INVALID BONE : "..i)
					self.Bones = nil
					break
				end
				self.Bones[name] = i
			end
			self:SetLOD(-1)
			self.CreatingBones = false
		end)
	end
	
	gred.ManipulateBoneAngles = function(self,bone,angle)
		if !self.Bones or (self.Bones and !self.Bones[bone]) then
			gred.UpdateBoneTable(self)
			return
		end
		
		self:ManipulateBoneAngles(self.Bones[bone],angle)
	end
	
	gred.ManipulateBonePosition = function(self,bone,pos)
		if !self.Bones or (self.Bones and !self.Bones[bone]) then
			gred.UpdateBoneTable(self)
			return
		end
		
		self:ManipulateBonePosition(self.Bones[bone],pos)
	end
	
	gred.ManipulateBoneScale = function(self,bone,scale)
		if !self.Bones or (self.Bones and !self.Bones[bone]) then
			gred.UpdateBoneTable(self)
			return
		end
		
		self:ManipulateBoneScale(self.Bones[bone],scale)
	end
	
	gred.HandleFlyBySound = function(self,ply,ct,minvel,maxdist,delay,snd)
		ply.NGPLAY = ply.NGPLAY or 0
		ply.lfsGetPlane = ply.lfsGetPlane or function() return nil end
		if ply:lfsGetPlane() != self and (ply.NGPLAY < ct) and self:GetEngineActive() then
			local vel = self:GetVelocity():Length()
			if vel >= minvel then
				local plypos = ply:GetPos()
				local pos = self:GetPos()
				local dist = pos:Distance(plypos)
				if dist < maxdist then
					ply.NGPLAY = ct + delay
					ply:EmitSound(snd)
				end
			end
		end
	end
	
	gred.HandleVoiceLines = function(self,ply,ct,hp)
		ply.lfsGetPlane = ply.lfsGetPlane or function() return nil end
		self.BumpSound = self.BumpSound or ct
		if self.BumpSound < ct then
			for k,v in pairs(self.SoundQueue) do
				ply:EmitSound(v)
				
				table.RemoveByValue(self.SoundQueue,v)
				self.BumpSound = ct + 4
				break
			end
		end
		
		if self.IsDead then
			local Driver = self:GetDriver()
			if self.CheckDriver and Driver != self.OldDriver and !IsValid(Driver) then
				for k,v in pairs(player.GetAll()) do
					if v:lfsGetAITeam() == self.OldDriver:lfsGetAITeam() and (IsValid(v:lfsGetPlane()) or v == self.OldDriver) then
						v:EmitSound("GRED_VO_BAILOUT_0"..math.random(1,3))
					end
				end
			end
			self.CheckDriver = true
			self.OldDriver = Driver
		end
		if ply:lfsGetPlane() == self then
			if self.EmitNow.wing_r and self.EmitNow.wing_r != "CEASE" then
				self.EmitNow.wing_r = "CEASE"
				table.insert(self.SoundQueue,"GRED_VO_HOLE_RIGHT_WING_0"..math.random(1,3))
			end
			if self.EmitNow.wing_l and self.EmitNow.wing_l != "CEASE" then
				self.EmitNow.wing_l = "CEASE"
				table.insert(self.SoundQueue,"GRED_VO_HOLE_LEFT_WING_0"..math.random(1,3))
			end
			if hp == 0 then
				self.IsDead = true
			end
		end
	end
	
	gred.LFSHUDPaintFilterParts = function(self)
		local partnum = {}
		local a = 1
		if self.Parts then
			for k,v in pairs(self.Parts) do
				partnum[a] = v
				a = a + 1
			end
		end
		partnum[a] = self
		
		return partnum
	end
	
	gred.CalcViewThirdPersonLFSParts = function(self,view,ply)
		view.origin = ply:EyePos()
		local Parent = ply:lfsGetPlane()
		local Pod = ply:GetVehicle()
		local radius = 550
		radius = radius + radius * Pod:GetCameraDistance()
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
		local WallOffset = 4
		local tr = util.TraceHull( {
			start = view.origin,
			endpos = TargetOrigin,
			filter = function( e )
				local c = e:GetClass()
				local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS and Parent:GetCalcViewFilter(e)
				
				return collide
			end,
			mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
			maxs = Vector( WallOffset, WallOffset, WallOffset ),
		} )
		view.origin = tr.HitPos
		
		if tr.Hit and not tr.StartSolid then
			view.origin = view.origin + tr.HitNormal * WallOffset
		end
		
		return view
	end
	
	gred.GunnersInit = function(self)
		local ATT
		local seat
		for k,v in pairs(self.Gunners) do
			for a,b in pairs(v.att) do
				v.att[a] = self:LookupAttachment(b)
			end
		end
	end
	
	gred.GunnersDriverHUDPaint = function(self,ply)
		if !self.Initialized then
			gred.GunnersInit(self)
			self.Initialized = true
		end
		
		local att
		local tr
		local filter = self:GetCrosshairFilterEnts()
		local ScrW,ScrH = ScrW(),ScrH()
		local pparam1
		local pparam2
		local alpha
		
		for k,v in pairs(self.Gunners) do
			att = self:GetAttachment(v.att[1])
			tr = util.TraceLine({
				start = att.Pos,
				endpos = (att.Pos + att.Ang:Forward() * 50000),
				filter = filter
			})
			
			alpha = !IsValid(self["GetGunner"..k](self)) and 255 or 0
			
			pparam1,pparam2 = self:GetPoseParameter(v.poseparams[1]),self:GetPoseParameter(v.poseparams[2])
			
			if pparam1 == 1 or pparam2 == 1 or pparam1 == 0 or pparam2 == 0 then -- yea but shut up ok
				surface.SetDrawColor(255,0,0,alpha)
			else
				surface.SetDrawColor(0,255,0,alpha)
			end
			
			tr.ScreenPos = tr.HitPos:ToScreen()
			tr.ScreenPos.x = tr.ScreenPos.x > ScrW and tr.ScreenPosW or (tr.ScreenPos.x < 0 and 0 or tr.ScreenPos.x)
			tr.ScreenPos.y = tr.ScreenPos.y > ScrH and tr.ScreenPosH or (tr.ScreenPos.y < 0 and 0 or tr.ScreenPos.y)
			DrawCircle(tr.ScreenPos.x,tr.ScreenPos.y,5)
		end
	end
	
	gred.GunnersHUDPaint = function(self,ply)
		if !self.Initialized then
			gred.GunnersInit(self)
			self.Initialized = true
		end
		
		local att
		local tr
		local filter = self:GetCrosshairFilterEnts()
		local ScrW,ScrH = ScrW(),ScrH()
		local pparam1
		local pparam2
		local veh = ply:GetVehicle()
		for k,v in pairs(self.Gunners) do
			if veh == self["GetGunnerSeat"..k](self) then
				att = self:GetAttachment(v.att[1])
				tr = util.TraceLine({
					start = att.Pos,
					endpos = (att.Pos + att.Ang:Forward() * 50000),
					filter = filter
				})
				
				pparam1,pparam2 = self:GetPoseParameter(v.poseparams[1]),self:GetPoseParameter(v.poseparams[2])
				
				if pparam1 == 1 or pparam2 == 1 or pparam1 == 0 or pparam2 == 0 then -- yea but shut up ok
					surface.SetDrawColor(255,0,0,255)
				else
					surface.SetDrawColor(0,255,0,255)
				end
				
				tr.ScreenPos = tr.HitPos:ToScreen()
				tr.ScreenPos.x = tr.ScreenPos.x > ScrW and tr.ScreenPosW or (tr.ScreenPos.x < 0 and 0 or tr.ScreenPos.x)
				tr.ScreenPos.y = tr.ScreenPos.y > ScrH and tr.ScreenPosH or (tr.ScreenPos.y < 0 and 0 or tr.ScreenPos.y)
				DrawCircle(tr.ScreenPos.x,tr.ScreenPos.y,5)
				break
			end
		end
	end
	
	
	
	hook.Add("Think","gred_simfphys_managetanks",function()
		local ct = CurTime()
		if ct > NextThink then
			NextThink = ct + 0.02
			if ct > NextFind then
				NextFind = ct + 30
				GetAllTanks()
			end
			ply = IsValid(ply) and ply or LocalPlayer()
			local pos = ply:GetPos()
			local var = gred.CVars["gred_cl_simfphys_maxsuspensioncalcdistance"]:GetInt()
			for class,tab in pairs(gred.simfphys) do
				for k,v in pairs(tab.entities) do
					if IsValid(v) then
						if pos:DistToSqr(v:GetPos()) < var then
							if !v.GRED_INDEX then
								id = id + 1
								v.GRED_INDEX = id
							end
							if not v.wheel_left_mat then
								v.wheel_left_mat = CreateMaterial("gred_trackmat_"..class.."_"..v.GRED_INDEX.."_left","VertexLitGeneric",tab.trackTex)
							end

							if not v.wheel_right_mat then
								v.wheel_right_mat = CreateMaterial("gred_trackmat_"..class.."_"..v.GRED_INDEX.."_right","VertexLitGeneric",tab.trackTex)
							end
							local TrackPos = GetTrackPos(v,tab.div,tab.smoother)
							if tab.UpTranslate then
								v.wheel_left_mat:SetVector("$translate",Vector(0,0,TrackPos.Left))
								v.wheel_right_mat:SetVector("$translate",Vector(0,0,TrackPos.Right))
							elseif tab.RightTranslate then
								v.wheel_left_mat:SetVector("$translate",Vector(TrackPos.Left))
								v.wheel_right_mat:SetVector("$translate",Vector(TrackPos.Right))
							else
								v.wheel_left_mat:SetVector("$translate",Vector(0,TrackPos.Left))
								v.wheel_right_mat:SetVector("$translate",Vector(0,TrackPos.Right))
							end
							-- PrintTable(v:GetMaterials())
							if tab.SeparateTracks then
								if !IsValid(v.LeftTrack) then v.LeftTrack = v:GetNWEntity("LeftTrack") end
								if !IsValid(v.RightTrack) then v.RightTrack = v:GetNWEntity("RightTrack") end
								if !IsValid(v.RightTrack) or !IsValid(v.LeftTrack) then return end -- one last check just to be safe
								v.LeftTrack:SetSubMaterial(tab.LeftTrackID,"!gred_trackmat_"..class.."_"..v.GRED_INDEX.."_left") 
								v.RightTrack:SetSubMaterial(tab.RightTrackID,"!gred_trackmat_"..class.."_"..v.GRED_INDEX.."_right")
							else
								v:SetSubMaterial(tab.LeftTrackID,"!gred_trackmat_"..class.."_"..v.GRED_INDEX.."_left") 
								v:SetSubMaterial(tab.RightTrackID,"!gred_trackmat_"..class.."_"..v.GRED_INDEX.."_right")
							end
						end
					else
						table.remove(tab.entities,k)
					end
				end
			end
		end
	end)
	
	hook.Add( "PopulateToolMenu", "gred_menu", function()
		spawnmenu.AddToolMenuOption("Options",					-- Tab
									"Gredwitch's Stuff",		-- Sub-tab
									"gred_settings_bullets",	-- Identifier
									"Bullets",					-- Name of the sub-sub-tab
									"",							-- Command
									"",							-- Config (deprecated)
									gred_settings_bullets		-- Function
		)
		spawnmenu.AddToolMenuOption("Options",
									"Gredwitch's Stuff",
									"gred_settings_wac",
									"WAC",
									"",
									"",
									gred_settings_wac
		)
		spawnmenu.AddToolMenuOption("Options",
									"Gredwitch's Stuff",
									"gred_settings_lfs",
									"LFS",
									"",
									"",
									gred_settings_lfs
		)
		spawnmenu.AddToolMenuOption("Options",
									"Gredwitch's Stuff",
									"gred_settings_bombs",
									"Explosives",
									"",
									"",
									gred_settings_bombs
		)
		spawnmenu.AddToolMenuOption("Options",
									"Gredwitch's Stuff",
									"gred_settings_misc",
									"Misc",
									"",
									"",
									gred_settings_misc
		)
		spawnmenu.AddToolMenuOption("Options",
									"Gredwitch's Stuff",
									"gred_settings_simfphys",
									"Simfphys",
									"",
									"",
									gred_settings_simfphys
		)
	end );
	
	hook.Add("CalcView","gred_simfphys_tanksightview",function(ply,ang,pos)
		if !IsValid(ply) or !ply:Alive() or !ply:InVehicle() or ply:GetViewEntity() != ply then return end
		local vehicle = ply:GetVehicle()
		if not IsValid(vehicle) then return end
		local Base = ply.GetSimfphys and ply:GetSimfphys() or vehicle.vehiclebase
		if not IsValid(Base) then return end
		if !vehicle.GetThirdPersonMode or ply:GetViewEntity() ~= ply then return end
		if vehicle.GRED_USE_SIGHT and vehicle:GetThirdPersonMode() then 
			vehicle:SetThirdPersonMode(false)
		end
		if vehicle:GetNWBool("simfphys_SpecialCam") or not vehicle.GRED_USE_SIGHT or vehicle.GRED_SIGHT_ATT == 0 then return end
		
		local view = {
			origin = pos,
			drawviewer = false,
		}
		ply.simfphys_smooth_out = 0
		local attachment = Base:GetAttachment(vehicle.GRED_SIGHT_ATT)
		attachment.Ang = vehicle:GetNWBool("HasStabilizer") and RoundAngle(attachment.Ang,2) or attachment.Ang
		view.angles = attachment.Ang + vehicle.GRED_SIGHT_OFFSET_ANG
		view.origin = attachment.Pos + attachment.Ang:Forward() * vehicle.GRED_SIGHT_OFFSET.x  + attachment.Ang:Right() * vehicle.GRED_SIGHT_OFFSET.y  + attachment.Ang:Up() *  vehicle.GRED_SIGHT_OFFSET.z
		view.fov = vehicle:GetNWFloat("SightZoom",40)
		return view
	end)
	
	hook.Add("AdjustMouseSensitivity","gred_tank_sight",function(val)
		local ply = LocalPlayer()
		if not IsValid(ply) or not ply:Alive() then return end
		local vehicle = ply:GetVehicle()
		if not IsValid(vehicle) then return end
		if not vehicle.GRED_USE_SIGHT or vehicle.GRED_SIGHT_ATT == 0 then return end
		if !vehicle.GetThirdPersonMode then return end
		if vehicle:GetThirdPersonMode() then return end
		
		return gred.CVars.gred_cl_simfphys_sightsensitivity:GetFloat()
	end)
	
	hook.Add("HUDPaint","gred_simfphys_tanksighthud",function()
		local ply = LocalPlayer()
		if not IsValid(ply) or not ply:Alive() then return end
		if not ply:InVehicle() or ply:GetViewEntity() ~= ply then
			local obj = ply:GetNWEntity("PickedUpObject",nil)
			if !IsValid(obj) or obj.ClassName != "base_shell" then return end
			local pos = ply:GetPos()
			local sqr = 350*350
			for k,ent in pairs(ents.FindInSphere(pos,350)) do
				if ent.ClassName == "gmod_sent_vehicle_fphysics_base" then
					if ent.GRED_ISTANK == nil then 
						timer.Simple(0.4,function()
							if IsValid(ent) and ent.GRED_ISTANK == nil then
								ent.GRED_ISTANK = ent:GetNWBool("GRED_ISTANK")
							end
						end)
					end
					if ent.Seats == nil then
						ent.Seats = ent.pSeat and table.Copy(ent.pSeat) or {}
						table.insert(ent.Seats,ent:GetDriverSeat())
					end
					if ent.GRED_ISTANK and istable(ent.Seats) then
						local _,maxs = ent:GetModelBounds()
						maxs.x = 0
						maxs.y = 0
						local textpos = ent:LocalToWorld(maxs)
						local col = Color(100,100,100,math.Clamp((1 - pos:DistToSqr(textpos) / sqr) * 1200,0,255))
						local i = 0
						for a,seat in pairs(ent.Seats) do
							if IsValid(seat) and seat:GetNWBool("HasCannon") then
								seat.shellTypes = seat.shellTypes or util.JSONToTable(seat:GetNWString("ShellTypes"))
								seat.maxAmmo = seat.maxAmmo or seat:GetNWInt("MaxAmmo",0)
								local curammo = 0
								local ammo
								local str = ""
								for A = 1,#seat.shellTypes do
									ammo = seat:GetNWInt("CurAmmo"..A,0)
									curammo = curammo + ammo
									str = str..seat.shellTypes[A]..": "..ammo..(A == #seat.shellTypes and "" or "\n")
								end
								str = seat:GetNWInt("Caliber",0).."mm cannon\nCapacity: "..curammo.."/"..seat.maxAmmo.."\n"..str
								DrawWorldTip(str,textpos,col,"GModWorldtip",150*i)
								i = i + 1
							end
						end
					end
				end
			end
			return
		end
		
		local vehicle = ply:GetVehicle()
		if not IsValid(vehicle) then return end
		local Base = ply.GetSimfphys and ply:GetSimfphys() or vehicle.vehiclebase
		if not IsValid(Base) then return end
		
		vehicle.shellTypes = vehicle.shellTypes or util.JSONToTable(vehicle:GetNWString("ShellTypes"))
		local scrW,scrH
		if vehicle.shellTypes and !vehicle.GRED_USE_SIGHT then
			scrW,scrH = ScrW(),ScrH()
			DrawAmmoLeft(vehicle,scrW,scrH)
		end
		if vehicle:GetNWBool("simfphys_SpecialCam") or not vehicle.GRED_USE_SIGHT or vehicle.GRED_SIGHT_ATT == 0 then return end
		if !vehicle.GetThirdPersonMode or ply:GetViewEntity() ~= ply then return end
		if vehicle:GetThirdPersonMode() then return end
		
		local ScrW,ScrH = scrW or ScrW(),scrH or ScrH()
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(surface.GetTextureID(vehicle:GetNWString("SightTexture")))
		surface.DrawTexturedRect(0,-(ScrW-ScrH)*0.5,ScrW,ScrW)
		
		if vehicle.shellTypes and vehicle.GRED_USE_SIGHT then
			DrawAmmoLeft(vehicle,ScrW,ScrH)
		end
		
		Base.GRED_FILTER_ENTS = Base.GRED_FILTER_ENTS or {
			Base,
		}
		local startpos = Base:GetAttachment(vehicle.GRED_SIGHT_ATT).Pos
		local scr = util.TraceLine({
			start = startpos,
			endpos = (startpos + ply:EyeAngles():Forward() * 50000),
			-- mask = MASK_WATER,
			filter = Base.GRED_FILTER_ENTS,
		}).HitPos:ToScreen()
		
		scr.x = scr.x > ScrW and ScrW or (scr.x < 0 and 0 or scr.x)
		scr.y = scr.y > ScrH and ScrH or (scr.y < 0 and 0 or scr.y)
		
		surface.SetDrawColor(255,255,255)
		DrawCircle(scr.x,scr.y,19)
		surface.SetDrawColor(0,0,0)
		DrawCircle(scr.x,scr.y,20)
		
		local scrW,scrH = ScrW*0.5,ScrH*0.518
		
		surface.SetDrawColor( 240, 200, 0, 255 ) 
		local Yaw = Base:GetPoseParameter( "turret_yaw" ) * 360 - 90
		
		local dX = math.cos( math.rad( -Yaw ) )
		local dY = math.sin( math.rad( -Yaw ) )
		local len = scrH * 0.04
		
		DrawCircle( scrW, scrH * 1.85, len )
		surface.DrawLine( scrW + dX * len, scrH * 1.85 + dY * len, scrW + dX * len * 3, scrH * 1.85 + dY * len * 3 )
		
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW - len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW + len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 - len * 2, scrW + len * 1.25, scrH * 1.85 - len * 2 )
		surface.DrawLine( scrW - len * 1.25, scrH * 1.85 + len * 2, scrW + len * 1.25, scrH * 1.85 + len * 2 )
	end)
	
	
	
	net.Receive("gred_net_tank_setsight",function()
		local ply = LocalPlayer()
		local pod = ply:GetVehicle()
		local offset = net.ReadVector()
		local att = net.ReadString()
		local angoffset = net.ReadAngle()
		if !IsValid(pod) then return end
		
		pod.GRED_SIGHT_OFFSET_ANG 	= angoffset
		pod.GRED_SIGHT_OFFSET 		= offset
		pod.GRED_SIGHT_ATT 			= ply:GetSimfphys():LookupAttachment(att)
		pod.GRED_USE_SIGHT 			= !pod.GRED_USE_SIGHT
	end)
	
	net.Receive("gred_lfs_setparts",function()
		local self = net.ReadEntity()
		if not self then print("[LFS] ERROR! ENTITY NOT INITALIZED CLIENT SIDE! PLEASE, RE-SPAWN!") return end
		self.Parts = {}
		for k,v in pairs(net.ReadTable()) do
			self.Parts[k] = v
		end
	end)
	
	net.Receive("gred_lfs_remparts",function()
		local self = net.ReadEntity()
		local k = net.ReadString()
		
		self.EmitNow = istable(self.EmitNow) and self.EmitNow or {}
		if self.EmitNow and (k == "wing_l" or k == "wing_r") and self.EmitNow[k] != "CEASE" then
			self.EmitNow[k] = true
		end
		if self.Parts then
			self.Parts[k] = nil
		end
	end)
	
	net.Receive("gred_net_registertank",function(length)
		local ent = net.ReadEntity()
		if not IsValid(ent) or !ent.GetSpawn_List then return end
		
		local tab = gred.simfphys[ent:GetSpawn_List()]
		tableinsert(tab.entities,ent)
		if tab.UpdateSuspension_CL and ent:GetModel() != "models/error.mdl" then
			local OldThink = ent.Think
			ent.Think = function(ent)
				OldThink(ent)
				tab.UpdateSuspension_CL(ent)
			end
		end
	end)
	
	net.Receive("gred_net_send_ply_hint_key",function()
		surface.PlaySound("ambient/water/drip"..math.random(1,4)..".wav")
		notification.AddLegacy("Press the '"..input.GetKeyName(net.ReadInt(9))..net.ReadString(),NOTIFY_HINT,10)
	end)
	
	net.Receive("gred_net_check_binding_simfphys",function()
		if input.LookupBinding("+walk") != nil then return end
		
		local DFrame = vgui.Create("DFrame")
		DFrame:SetSize(ScrW()*0.9,ScrH()*0.9)
		DFrame:Center()
		DFrame:MakePopup()
		DFrame:SetDraggable(false)
		DFrame:ShowCloseButton(false)
		DFrame:SetTitle("YOU DON'T HAVE YOUR +WALK KEY BOUND, WHICH IS REQUIRED IF YOU WANT THE TANK TURRET TO WORK")
		
		timer.Simple(3,function()
			if !IsValid(DFrame) then return end
			DFrame:ShowCloseButton(true)
		end)
		
		local DHTML = vgui.Create("DHTML",DFrame)
		DHTML:Dock(FILL)
		DHTML:OpenURL("https://steamuserimages-a.akamaihd.net/ugc/773983150582822983/8FAB41F8FDC796EF2033B0AF3379DF5734DDC150/")
		
	end)
	
	net.Receive("gred_net_send_ply_hint_simple",function()
		surface.PlaySound("ambient/water/drip"..math.random(1,4)..".wav")
		notification.AddLegacy(net.ReadString(),NOTIFY_HINT,10)
	end)
	
	net.Receive("gred_net_message_ply",function()
		ply = IsValid(ply) and ply or LocalPlayer()
		local msg = net.ReadString()
		ply:PrintMessage(HUD_PRINTTALK,msg)
	end)

	net.Receive("gred_net_bombs_decals",function()
		local decal = net.ReadString()
		local start = net.ReadVector()
		local hitpos = net.ReadVector()
		if GetConVar("gred_cl_decals"):GetInt() <= 0 then return end
		util.Decal(decal,start,hitpos)
	end)
	
	net.Receive("gred_net_sound_lowsh",function()
		ply = IsValid(ply) and ply or LocalPlayer()
		ply:GetViewEntity():EmitSound(net.ReadString())
	end)
	
	net.Receive("gred_net_nw_var",function()
		local self = net.ReadEntity()
		local str = net.ReadString()
		local t = net.ReadInt(4)
		if t == 1 then
			local val = net.ReadString()
			self:SetNWString(str,val)
		elseif t == 2 then
			local ent = net.ReadEntity()
			self:SetNWEntity(str,ent)
		elseif t == 3 then
			local table = net.ReadTable()
			self:SetNWTable(str,table)
		end
	end)
	
	net.Receive("gred_net_createtracer",function()
		local effect = EffectData()
		effect:SetOrigin(net.ReadVector())
		effect:SetFlags(net.ReadInt(4))
		effect:SetMaterialIndex(net.ReadInt(4))
		effect:SetStart(net.ReadVector())
		Effect("gred_particle_tracer",effect)
	end)
	
	net.Receive("gred_net_createimpact",function()
		-- local tab = util.JSONToTable(net.ReadString())
		-- local effectdata = EffectData()
		-- effectdata:SetOrigin(tab[1])
		-- effectdata:SetAngles(tab[2])
		-- effectdata:SetSurfaceProp(tab[3])
		-- effectdata:SetMaterialIndex(tab[4])
		-- effectdata:SetFlags(tab[5])
		-- Effect("gred_particle_impact",effectdata)
		
		local effectdata = EffectData()
		effectdata:SetOrigin(net.ReadVector())
		effectdata:SetAngles(net.ReadAngle())
		effectdata:SetSurfaceProp(net.ReadInt(4))
		effectdata:SetMaterialIndex(net.ReadInt(4))
		effectdata:SetFlags(net.ReadInt(4))
		Effect("gred_particle_impact",effectdata)
	end)
	
	net.Receive("gred_net_createparticle",function()
		local effectdata = EffectData()
		effectdata:SetFlags(table.KeyFromValue(gred.Particles,net.ReadString()))
		effectdata:SetOrigin(net.ReadVector())
		effectdata:SetAngles(net.ReadAngle())
		effectdata:SetSurfaceProp(net.ReadBool() and 1 or 0)
		Effect("gred_particle_simple",effectdata)
	end)
			
	timer.Simple(5,function()
		local singleplayerIPs = {
			["loopback"] = true,
			["0.0.0.0"] = true,
			["0.0.0.0:port"] = true,
		}
		if singleplayerIPs[game.GetIPAddress()] then
			CheckForUpdates()
		end
		CheckDXDiag()
	end)
else
	resource.AddWorkshop(1131455085) -- Base addon
	
	local AddNetworkString = util.AddNetworkString
	AddNetworkString("gred_net_checkconcommand")
	AddNetworkString("gred_net_check_binding_simfphys")
	AddNetworkString("gred_net_sound_lowsh")
	AddNetworkString("gred_net_message_ply")
	AddNetworkString("gred_net_bombs_decals")
	AddNetworkString("gred_net_nw_var")
	AddNetworkString("gred_net_createtracer")
	AddNetworkString("gred_net_createimpact")
	AddNetworkString("gred_net_createparticle")
	AddNetworkString("gred_net_impact")
	AddNetworkString("gred_lfs_setparts")
	AddNetworkString("gred_lfs_remparts")
	AddNetworkString("gred_net_registertank")
	AddNetworkString("gred_net_tank_setsight")
	AddNetworkString("gred_net_send_ply_hint_key")
	AddNetworkString("gred_net_send_ply_hint_simple")
	
	
	
	local OverrideHAB 		= gred.CVars["gred_sv_override_hab"]
	local Tracers 			= gred.CVars["gred_sv_tracers"]
	local BulletDMG 		= gred.CVars["gred_sv_bullet_dmg"]
	local HE12MM 			= gred.CVars["gred_sv_12mm_he_impact"]
	local HE7MM 			= gred.CVars["gred_sv_7mm_he_impact"]
	local HERADIUS 			= gred.CVars["gred_sv_bullet_radius"]
	local SoundAdd 			= sound.Add
	local NoCollide 		= constraint.NoCollide
	local BulletID 			= 0
	local angle_zero 		= angle_zero
	local vector_zero 		= Vector(0,0,0)
	local startsWith = string.StartWith
	local soundSpeed = 18005.25*18005.25 -- 343m/s
	local IN_USE = IN_USE
	local CAL_TABLE = {
		["wac_base_7mm"] = 1,
		["wac_base_12mm"] = 2,
		["wac_base_20mm"] = 3,
		["wac_base_30mm"] = 4,
		["wac_base_40mm"] = 5,
	}
	local COL_TABLE = {
		["red"]    = 1,
		["green"]  = 2,
		["white"]  = 3,
		["yellow"] = 4,
	}
	local bad = {
		["prop_vehicle_prisoner_pod"] = true,
	}
	local badclass = {
		["gmod_sent_vehicle_fphysics_wheel"] = true,
	}
	
	
	
	local function CreateExplosion(ply,pos,radius,dmg,cal)
		local sqrR = radius*radius
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker(ply)
		dmginfo:SetDamagePosition(pos)
		dmginfo:SetDamageType(CAL_TABLE[cal] > 3 and 64 or 2) -- DMG_BLAST or DMG_BULLET
		for k,v in pairs(ents.FindInSphere(pos,radius)) do
			if !(v.InVehicle and v:InVehicle()) and !bad[v:GetClass()] and (!(v.IsOnPlane and !v.Armed) or !v.IsOnPlane) then
				dmginfo:SetDamage(math.abs(1-math.Clamp(v:GetPos():DistToSqr(pos),0,sqrR)/sqrR)*(v.GRED_ISTANK and dmg*0.2 or dmg))
				v:TakeDamageInfo(dmginfo)
			end
		end
	end
	
	local function BulletExplode(ply,NoBullet,tr,cal,filter,ang,NoParticle,explodable,dmg,radius,fusetime)
		ply = IsValid(ply) and ply or Entity(0)
		local hitang
		local hitpos
		local HitSky = false
		if istable(tr) then -- if tr isn't a table, then it's a vector
			hitang = tr.HitNormal:Angle()
			hitpos = tr.HitPos
			if cal == "wac_base_7mm" then
				hitang:Add(Angle(90))
			end
			HitSky = tr.HitSky
		else
			hitang = angle_zero
			hitpos = tr
			HitSky = true
		end
		if not explodable then
			if HitSky then return end
			local shouldExplode = (cal == "wac_base_12mm" and  HE12MM:GetInt() == 1) or (cal == "wac_base_7mm" and  HE7MM:GetInt() == 1)
			if !NoBullet then
				local bullet = {}
				bullet["Attacker"] = ply
				bullet["Callback"] = nil
				bullet["Damage"] = shouldExplode and 0 or dmg
				bullet["Force"] = 5
				bullet["HullSize"] = 0
				bullet["Num"] = 1
				bullet["Tracer"] = 0
				bullet["AmmoType"] = nil
				bullet["TracerName"] = nil
				bullet["Dir"] = ang:Forward()
				bullet["Spread"] = vector_zero
				bullet["Src"] = hitpos
				bullet["IgnoreEntity"] = filter
				ply:FireBullets(bullet,false)
			end
			if shouldExplode then
				-- util.BlastDamage(ply,ply,hitpos,radius,dmg)
				CreateExplosion(ply,hitpos,radius,dmg,cal)
			end
			if !NoParticle then
				net.Start("gred_net_createimpact")
					-- local tab = {hitpos,hitang}
					net.WriteVector(hitpos)
					net.WriteAngle(hitang)
					if cal == "wac_base_7mm" then
						-- tableinsert(tab,gred.Mats[util.GetSurfacePropName(tr.SurfaceProps)] or 24)
						net.WriteInt(gred.Mats[util.GetSurfacePropName(tr.SurfaceProps)] or 24,4)
					else
						-- tableinsert(tab,0)
						net.WriteInt(0,4)
					end
					-- tableinsert(tab,1)
					net.WriteInt(1,4)
					-- tableinsert(tab,table.KeyFromValue(gred.Calibre,cal))
					net.WriteInt(table.KeyFromValue(gred.Calibre,cal),4)
					
					-- tab = util.TableToJSON(tab)
					-- net.WriteString(tab)
				net.Broadcast()
			end
			
			if cal == "wac_base_12mm" then
				sound.Play("impactsounds/gun_impact_"..math.random(1,14)..".wav",hitpos,75,100,0.5)
			end
		else
			if cal == "wac_base_30mm" then
				sound.Play("impactsounds/30mm_old.wav",hitpos,110,math.random(90,110),1)
			elseif cal == "wac_base_20mm" then
				sound.Play("impactsounds/20mm_0"..math.random(1,5)..".wav",hitpos,100,100,0.7)
			else
				sound.Play("impactsounds/20mm_0"..math.random(1,5)..".wav",hitpos,100,100,0.7)
			end
			if !HitSky and !NoBullet then
				local bullet = {}
				bullet.Damage = 0
				bullet.Attacker = ply
				bullet.Callback = nil
				bullet.Damage = 0
				bullet.Force = 100
				bullet.HullSize = 0
				bullet.Num = 1
				bullet.Tracer = 0
				bullet.AmmoType = nil
				bullet.TracerName = nil
				bullet.Dir = ang:Forward()
				bullet.Spread = vector_zero
				bullet.Src = hitpos
				bullet.IgnoreEntity = filter
				ply:FireBullets(bullet,false)
			end
			CreateExplosion(ply,hitpos,radius,dmg,cal)
			-- util.BlastDamage(ply,ply,hitpos,radius,dmg)
			if !NoParticle then
				net.Start("gred_net_createimpact")
					net.WriteVector(hitpos)
					if !HitSky then 
						net.WriteAngle(hitang)
						net.WriteInt(0,4)
					else 
						net.WriteAngle(hitang)
						net.WriteInt(1,4)
					end
					net.WriteInt(1,4)
					net.WriteInt(table.KeyFromValue(gred.Calibre,cal),4)
				net.Broadcast()
			end
		end
	end
	
	local function GetSeatID(ply,ent)
		if !ent.pSeats then return end
		if ply == ent:GetDriver() then return 0 end
		for k,v in pairs(ent.pSeats) do
			if ply == v:GetDriver() then return k end
		end
	end
	
	local function IsSmall(k)
		return startsWith(k,"gear") or startsWith(k,"wheel") or startsWith(k,"airbrake")
	end
	
	
	
	gred.GunnersInit = function(self)
		local ATT
		local seat
		for k,v in pairs(self.Gunners) do
		
			v.tracer = 0
			v.UpdateTracers = function(self)
				v.tracer = v.tracer + 1
				if v.tracer >= self.TracerConvar:GetInt() then
					v.tracer = 0
					return "red"
				else
					return false
				end
			end
			for a,b in pairs(v.att) do
				v.att[a] = self:LookupAttachment(b)
			end
			seat = self:AddPassengerSeat(v.pos,v.ang)
			seat.Shoot = v.snd_loop and CreateSound(seat,v.snd_loop) or nil
			seat.Stop = v.snd_stop and CreateSound(seat,v.snd_stop) or nil
			self["SetGunnerSeat"..k](self,seat)
		end
	end
	
	gred.GunnersTick = function(self,Driver,DriverSeat,DriverFireGunners,ct,IsShooting)
		ct = ct and ct or CurTime()
		Driver = Driver and Driver or self:GetDriver()
		DriverSeat = DriverSeat and DriverSeat or self:GetDriverSeat()
		DriverFireGunners = DriverFireGunners != nil and DriverFireGunners or (IsValid(Driver) and Driver:lfsGetInput("FREELOOK") and Driver:KeyDown(IN_ATTACK))
		local ang
		local pod
		local gunner
		local gunnerValid
		local shootAng
		local tracer
		local gunnerpod
		local IsDriver
		local selfAngle = self:GetAngles()
		selfAngle:Normalize()
		for k,v in pairs(self.Gunners) do
			pod = self["GetGunnerSeat"..k](self)
			gunnerpod = pod
			if IsValid(pod) then
				gunner = pod:GetDriver()
				gunnerValid = IsValid(gunner)
				if gunnerValid or (!gunnerValid and DriverFireGunners) then
					gunner = gunnerValid and gunner or Driver
					IsDriver = gunner == Driver
					pod = IsDriver and DriverSeat or pod
					
					IsShooting = IsShooting or gunner:KeyDown(IN_ATTACK)
					
					for C,att in pairs(v.att) do
						att = self:GetAttachment(att)
						if C == 1 then
							ang = pod:WorldToLocalAngles(gunner:EyeAngles())
							ang:Normalize() 
							ang = v.AngleOperate(self:WorldToLocalAngles(ang),IsDriver,selfAngle)
							ang:Normalize()
							self:SetPoseParameter(v.poseparams[1],ang.p)
							self:SetPoseParameter(v.poseparams[2],ang.y)
							if (ang.y > v.maxang.y or ang.p > v.maxang.p or ang.y < v.minang.y or ang.p < v.minang.p) and DriverFireGunners then break end
							if IsShooting and v.nextshot <= ct then
								tracer = v.UpdateTracers(self)
							end
						end
						if IsShooting then
							v.IsShooting = true
							if gunnerpod.Stop then
								gunnerpod.Stop:Stop()
							else
								gunnerpod.Shoot:Stop()
							end
							gunnerpod.Shoot:Play()
							if v.nextshot <= ct then
								v.spread = v.spread and v.spread or 0.3
								shootAng = att.Ang + Angle(math.Rand(-v.spread,v.spread), math.Rand(-v.spread,v.spread), math.Rand(-v.spread,v.spread))
								
								gred.CreateBullet(gunner,att.Pos,shootAng,v.cal,self.FILTER,nil,false,tracer)
								
								local effectdata = EffectData()
								effectdata:SetFlags(self.MUZZLEEFFECT)
								effectdata:SetOrigin(att.Pos)
								effectdata:SetAngles(shootAng)
								effectdata:SetSurfaceProp(0)
								util.Effect("gred_particle_simple",effectdata)
								if C == #v.att or v.Sequential then
									v.nextshot = ct + v.delay
								end
							end
						else
							if v.IsShooting then
								v.IsShooting = false
								if gunnerpod.Stop then
									gunnerpod.Stop:Play()
									gunnerpod.Shoot:Stop()
								end
							end
						end
					end
				else
					if v.IsShooting then
						v.IsShooting = false
						if gunnerpod.Stop then
							gunnerpod.Stop:Play()
							gunnerpod.Shoot:Stop()
						end
					end
				end
			end
			
			pod = nil
			gunner = nil
		end
	end

	gred.HandleActiveGunners = function(self)
		local gpod
		local gunner
		for k,v in pairs(self.Gunners) do
			gpod = self["GetGunnerSeat"..k](self)
			if IsValid(gpod) then
				local Gunner = gpod:GetDriver()
				
				gunner = self["GetGunner"..k](self)
				if Gunner ~= gunner then
					self:SetGunner( Gunner )
					
					if IsValid( Gunner ) then
						Gunner:CrosshairEnable() 
					end
				end
			end
		end
	end
	
	gred.CreateExplosion = function(pos,radius,damage,decal,trace,ply,bomb,DEFAULT_PHYSFORCE,DEFAULT_PHYSFORCE_PLYGROUND,DEFAULT_PHYSFORCE_PLYAIR)
		local ConVar = gred.CVars["gred_sv_shockwave_unfreeze"]:GetInt() >= 1
		
		net.Start("gred_net_bombs_decals")
			net.WriteString(decal and decal or "scorch_medium")
			net.WriteVector(pos)
			net.WriteVector(pos-Vector(0,0,trace))
		net.Broadcast()
		
		debugoverlay.Sphere(pos,radius,3, Color( 255, 255, 255 ))
		
		local bombvalid = IsValid(bomb)
		ply = IsValid(ply) and ply or (bombvalid and bomb or Entity(0))
		util.BlastDamage(!bombvalid and ply or bomb,ply,pos,radius,damage)
		
		local v_pos
		local phys
		local F_dir
		local massmul
		
		for k,v in pairs(ents.FindInSphere(pos,radius)) do
			v_pos = v:GetPos()
			phys = v:GetPhysicsObject()
			
			if !badclass[v:GetClass()] and !v.IsOnPlane and IsValid(phys) and !IsValid(v:GetParent()) then
				massmul = 1/phys:GetMass()
				
				phys:AddAngleVelocity(Vector(DEFAULT_PHYSFORCE, DEFAULT_PHYSFORCE, DEFAULT_PHYSFORCE) * math.Clamp((radius - (pos - v_pos):Length()) / radius,0,1) * massmul)
				phys:AddVelocity((DEFAULT_PHYSFORCE and (v_pos - pos) * DEFAULT_PHYSFORCE or (v_pos - pos))*massmul)
				if ConVar and !v.isWacAircraft and !v.LFS then
					phys:Wake()
					phys:EnableMotion(true)
					constraint.RemoveAll(v)
				end
				
				-- local class = v:GetClass()
				-- if class == "func_breakable" or class == "func_breakable_surf" or class == "func_physbox" then
					-- v:Fire("Break", 0)
				-- end
			end
			
			if v:IsPlayer() then
				v:SetMoveType(MOVETYPE_WALK)
				v:SetVelocity(v:IsOnGround() and (!DEFAULT_PHYSFORCE_PLYGROUND and (v_pos - pos) or (v_pos - pos) * DEFAULT_PHYSFORCE_PLYGROUND) or (!DEFAULT_PHYSFORCE_PLYAIR and (v_pos - pos) or (v_pos - pos) * DEFAULT_PHYSFORCE_PLYAIR))
			end
		end
	end
	
	gred.CreateSound = function(pos,rsound,e1,e2,e3)
		local currange = 1000 / gred.CVars["gred_sv_soundspeed_divider"]:GetInt()
		
		local curRange_min = currange*5
		curRange_min = curRange_min*curRange_min
		local curRange_mid = currange*14
		curRange_mid = curRange_mid * curRange_mid
		local curRange_max = currange*40
		curRange_max = curRange_max * curRange_max
		
		for k,v in pairs(player.GetHumans()) do
			local ply = v:GetViewEntity()
			local distance = ply:GetPos():DistToSqr(pos)
			
			if distance <= curRange_min then
			
				if v:GetInfoNum("gred_sound_shake",1) == 1 then
					util.ScreenShake(v:GetPos(),9999999,55,1.5,50)
				end
				
				net.Start("gred_net_sound_lowsh")
					net.WriteString(e1)
				net.Send(v)
				
			elseif distance <= curRange_mid then
				timer.Simple(distance/soundSpeed,function()
					if v:GetInfoNum("gred_sound_shake",1) == 1 then
						util.ScreenShake(v:GetPos(),9999999,55,1.5,50)
					end
					net.Start("gred_net_sound_lowsh")
						net.WriteString(!rsound and e2 or e1)
					net.Send(v)
				end)
			elseif distance <= curRange_max then
				timer.Simple(distance/soundSpeed,function()
					net.Start("gred_net_sound_lowsh")
						net.WriteString(!rsound and e3 or e1)
					net.Send(v)
				end)
			end
		end
	end
	
	gred.CreateBullet = function(ply,pos,ang,cal,filter,fusetime,NoBullet,tracer,dmg,radius)
		if hab and hab.Module.PhysBullet and OverrideHAB:GetInt() == 0 then
			local bullet = {}
			bullet.AmmoType		= cal..(tracer and tracer or "")
			bullet.Num 			= 1
			bullet.Src 			= pos
			bullet.Dir 			= ang:Forward()
			bullet.Spread 		= vector_zero
			bullet.Tracer		= 0--tracer and 0 or 1
			bullet.IsNetworked	= true
			bullet.IgnoreEntity = filter
			bullet.Distance		= false
			bullet.Damage		= ((cal == "wac_base_7mm" and HE7MM:GetInt() >= 1) or (cal == "wac_base_12mm" and HE12MM:GetInt() >= 1)) and 0 or (dmg and dmg or (cal == "wac_base_7mm" and 40 or (cal == "wac_base_12mm" and 60 or (cal == "wac_base_20mm" and 80 or (cal == "wac_base_30mm" and 100 or (cal == "wac_base_40mm" and 120)))))) * BulletDMG:GetFloat()
			bullet.Force		= bullet.Damage*0.1
			ply:FirePhysicalBullets(bullet)
		else
			World = IsValid(World) or Entity(0)
			BulletID = BulletID + 1
			local ct = CurTime()
			local speed = cal == "wac_base_7mm" and 1500 or (cal == "wac_base_12mm" and 1300 or (cal == "wac_base_20mm" and 950 or (cal == "wac_base_30mm" and 830 or (cal == "wac_base_40mm" and 680))))
			local dmg = (dmg and dmg or (cal == "wac_base_7mm" and 40 or (cal == "wac_base_12mm" and 60 or (cal == "wac_base_20mm" and 80 or (cal == "wac_base_30mm" and 100 or (cal == "wac_base_40mm" and 120)))))) * BulletDMG:GetFloat()
			local radius = (radius and radius or 70) * HERADIUS:GetFloat()
			radius = (cal == "wac_base_7mm" and radius or (cal == "wac_base_12mm" and radius or (cal == "wac_base_20mm" and radius*2 or (cal == "wac_base_30mm" and radius*3 or (cal == "wac_base_40mm" and radius*4)))))
			local orpos = pos
			local expltime = fusetime and ct + fusetime or nil
			local fwd = ang:Forward()
			local oldpos = orpos - fwd * speed
			local explodable = cal == "wac_base_20mm" or cal == "wac_base_30mm" or cal == "wac_base_40mm"
			local dif
			local NoParticle
			local oldbullet = BulletID
			
			if tracer then
				net.Start("gred_net_createtracer")
					net.WriteVector(pos)
					net.WriteInt(CAL_TABLE[cal],4)
					net.WriteInt(COL_TABLE[tracer],4)
					net.WriteVector(expltime and QuickTrace(pos,fwd*(fusetime*speed),filter).HitPos or QuickTrace(pos,fwd*99999999999999,filter).HitPos)
				net.Broadcast()
			end
			timer.Create("gred_bullet_"..oldbullet,0,0,function()
				dif = pos + pos - oldpos
				oldpos = pos
				local tr = TraceLine({start = pos,endpos = dif,filter = filter,mask = MASK_ALL})
				if tr.MatType == 83 then
					net.Start("gred_net_createimpact")
						net.WriteVector(tr.HitPos)
						net.WriteAngle(angle_zero)
						net.WriteInt(0,4)
						net.WriteInt(0,4)
						net.WriteInt(table.KeyFromValue(gred.Calibre,cal),4)
					net.Broadcast()
					
					NoParticle = true
					sound.Play("impactsounds/water_bullet_impact_0"..math.random(1,5)..".wav",pos,75,100,1)
				end
				
				if tr.Hit then
					BulletExplode(ply,NoBullet,tr,cal,filter,ang,NoParticle,explodable,dmg,radius,fusetime)
					timer.Remove("gred_bullet_"..oldbullet)
					return
				else
					if !IsInWorld(dif) then
						if explodable then 
							BulletExplode(ply,NoBullet,tr,cal,filter,ang,NoParticle,explodable,dmg,radius,fusetime)
						end
						timer.Remove("gred_bullet_"..oldbullet)
					else
						pos = dif
					end
				end
				if expltime and CurTime() >= expltime then
					BulletExplode(ply,NoBullet,pos,cal,filter,ang,NoParticle,explodable,dmg,radius,fusetime)
					timer.Remove("gred_bullet_"..oldbullet)
					return
				end
			end)
		end
	end

	gred.InitAircraftParts = function(self,ForceToDestroy)
		self.Attachements = {}
		self.Parts = {}
		local tostring = tostring
		local pairs = pairs
		local GetModel = GetModel
		
		for k,v in pairs (self:GetAttachments()) do
			self.Attachements[v.name] = self:LookupAttachment(tostring(v.name))
		end
		for k,v in pairs(self.Attachements) do
			if k != "blister" then
				local ent = ents.Create("gred_prop_part")
				ent.ForceToDestroy = ForceToDestroy or 1000
				ent:SetModel(self:GetPartModelPath(k))
				ent:SetPos(self:GetAttachment(self.Attachements[k]).Pos)
				ent:SetAngles(self:GetAngles())
				ent:SetParent(self,self.Attachements[k])
				if k == "tail" then
					ent.MaxHealth = self.TailHealth and self.TailHealth or 1100
				elseif k == "wing_r" or k == "wing_l" then
					ent.MaxHealth = self.WingHealth and self.WingHealth or 600
					ent.Mass = 500
				elseif IsSmall(k) then
					ent.MaxHealth = self.SmallPartHealth and self.SmallPartHealth or 100
				else
					ent.MaxHealth = self.PartHealth and self.PartHealth or 350
				end
				ent.CurHealth = ent.MaxHealth
				ent:Spawn()
				ent:Activate()
				self.Parts[k] = ent
			end
		end
		self.GibModels = self.GibModels or {}
		self.FILTER = {self}
		for k,v in pairs(self.Parts) do
			table.insert(self.FILTER,v)
			v.Parts = self.Parts
			v.Plane = self
			self.GibModels[k] = v:GetModel()
			v.PartParent = self.PartParents[k] and self.Parts[self.PartParents[k]] or self
		end
		self.LOADED = 1
	end
	
	gred.PartCalcFlight = function(self,Pitch,Yaw,Roll,Stability,AddRoll,AddYaw)
		AddRoll = AddRoll or 0.3
		AddYaw = AddYaw or 0.2
		local addRoll = 0
		local addYaw = 0
		local vel = self:GetVelocity():Length()
		if not self.Parts.elevator then
			Pitch = 0
		end
		if not self.Parts.rudder then
			Yaw = 0
		end
		if not self.Parts.wing_l then
			addRoll = AddRoll*vel
			addYaw = vel*AddYaw
		end
		if not self.Parts.wing_r then
			addRoll = !self.Parts.wing_l and addRoll or -AddRoll*vel
			addYaw = !self.Parts.wing_l and addYaw*2 or -vel*AddYaw
			Pitch = !self.Parts.wing_l and addYaw or Pitch
		end
		if not self.Parts.aileron_l then
			if Roll < 0 then Roll = Roll*0.5 end
		end
		if not self.Parts.aileron_r then
			if Roll > 0 then Roll = Roll*0.5 end
		end
		if not self.Parts.tail then
			Pitch = AddYaw*vel*10
			addYaw = addYaw + Pitch*0.3
			addRoll = addRoll + addYaw
		end
		Roll = Roll + addRoll
		Yaw = Yaw + addYaw
		return Pitch,Yaw,Roll,Stability,Stability,Stability
	end
	
	gred.PartThink = function(self,skin)
		if self.LOADED == 1 then
			for k,v in pairs(self.Parts) do
				self:DeleteOnRemove(v)
				NoCollide(v,self,0,0)
				NoCollide(v,self.wheel_R,0,0)
				NoCollide(v,self.wheel_L,0,0)
				NoCollide(v,self.wheel_C,0,0)
				NoCollide(v,self.wheel_C_master,0,0)
				if k == "tail" or k == "wing_l" or k == "wing_r" then
					v:SetParent(nil)
					v:SetPos(self:GetAttachment(self.Attachements[k]).Pos)
					v.Weld = constraint.Weld(v,self,0,0,0,true,false)
				end
				for a,p in pairs(self.Parts) do
					NoCollide(v,p,0,0)
				end
				v.LOADED = true
				v.PartName = k
			end
			net.Start("gred_lfs_setparts")
				net.WriteEntity(self)
				net.WriteTable(self.Parts)
			net.Broadcast()
			self.LOADED = true
		end
		skin = skin and skin or self:GetSkin()
		for k,v in pairs(self.Parts) do
			if not IsValid(v) then
				if k == "wheel_c" or k == "wheel_b" then
					self.wheel_C:Remove()
					self.wheel_C_master:Remove()
				end
				if k == "wheel_r" then
					self.wheel_R:Remove()
				end
				if k == "wheel_l" then
					self.wheel_L:Remove()
				end
				net.Start("gred_lfs_remparts")
					net.WriteEntity(self)
					net.WriteString(k)
				net.Broadcast()
				self.Parts[k] = nil
				self.GibModels[k] = nil
				k = nil
			return end
			if !v.PartParent or !IsValid(v.PartParent) or v.PartParent.Destroyed then
				v.CurHealth = 0
				v.DONOTEMIT = true
			end
			if v.CurHealth <= v.MaxHealth/2 then
				if not table.HasValue(self.DamageSkin,skin) then
					v:SetSkin(skin+1)
				end
				if v.CurHealth <=0 then
					if k == "wheel_c" or k == "wheel_b" then
						self.wheel_C:Remove()
						self.wheel_C_master:Remove()
					end
					if k == "wheel_r" then
						self.wheel_R:Remove()
					end
					if k == "wheel_l" then
						self.wheel_L:Remove()
					end
					constraint.RemoveAll(v)
					if not v.DONOTEMIT then
						v:EmitSound("LFS_PART_DESTROYED_0"..math.random(1,3))
					end
					v:SetParent(nil)
					v:SetVelocity(self:GetVelocity())
					v.Destroyed = true
					self.Parts[k] = nil
					self.GibModels[k] = nil
				end
				net.Start("gred_lfs_remparts")
					net.WriteEntity(self)
					net.WriteString(k)
				net.Broadcast()
			else
				if table.HasValue(self.DamageSkin,skin) then
					v:SetSkin(skin-1)
				else
					v:SetSkin(skin)
				end
			end
		end
	end
	
	gred.HandleLandingGear = function(self,animName)
		if not self.CurSeq then
			self.CurSeq = self:GetSequenceName(self:GetSequence())
		end
		if self.CurSeq != animName then
			self:ResetSequence(animName)
			self.CurSeq = self:GetSequenceName(self:GetSequence())
		end
		self:SetCycle(self:GetLGear())
	end
	
	gred.CreateShell = function(pos,ang,ply,filter,caliber,shelltype,muzzlevelocity,mass,color,dmg,callback,tntequivalent,explosivemass,linearpenetration,normalization,CoreMass) -- EXPLOSIVE MASS AND TNT EQUIVALENT IN KILOGRAMS!
		local ent = ents.Create("base_shell")
		ent:SetPos(pos)
		ent:SetAngles(ang)
		ent:SetOwner(ply)
		ent.Caliber = caliber
		ent.ShellType = shelltype
		ent.MuzzleVelocity = muzzlevelocity
		ent.TNTEquivalent = tntequivalent
		ent.ExplosiveMass = explosivemass
		ent.LinearPenetration = linearpenetration
		ent.Normalization = normalization or 0
		ent.CoreMass = CoreMass
		ent.Mass = mass
		ent.Filter = filter
		ent.IsOnPlane = true
		ent.TracerColor = color or "white"
		ent.ExplosionDamageOverride = dmg
		
		if callback then
			callback(ent)
		end
		
		ent:Spawn()
		ent:Activate()
		ent:SetBodygroup(1,shelltype == "AP" and 0 or 1)
		
		for k,v in pairs(filter) do
			NoCollide(v,ent,0,0)
		end
		
		return ent
	end
	
	gred.TankInit = function(self,vehicle)
		vehicle.GRED_TANK = true
		vehicle:SetSkin(math.random(0,vehicle:SkinCount()))
		
		local tab = vehicle.pSeat and table.Copy(vehicle.pSeat) or {}
		table.insert(tab,vehicle:GetDriverSeat())
		
		timer.Simple(0.1,function()
			local shelltypes
			for _,seat in pairs(tab) do
				if seat:GetNWBool("HasCannon") then
					shelltypes = {}
					for k,v in pairs(seat.ShellTypes) do
						table.insert(shelltypes,v.ShellType)
					end
					seat:SetNWBool("simfphys_SpecialCam",true)
					seat:SetNWString("ShellTypes",util.TableToJSON(shelltypes))
				end
			end
		end)
		
		vehicle.TOQUECENTER_D = 0
		vehicle.TOQUECENTER_A = 0
		
		timer.Simple(1,function()
			if not IsValid(vehicle) then return end
			if not vehicle.VehicleData["filter"] then 
				print("[simfphys Armed Vehicle Pack] ERROR:TRACE FILTER IS INVALID. PLEASE UPDATE SIMFPHYS BASE") 
				return
			end
			local health = math.ceil(vehicle:GetMaxHealth() * gred.CVars.gred_sv_simfphys_health_multplier:GetFloat())
			vehicle.MaxHealth = health
			vehicle:SetNWFloat("MaxHealth",health)
			vehicle:SetNWFloat("Health",health)
			vehicle:SetMaxHealth(health)
			vehicle:SetCurHealth(health)
			vehicle.WheelOnGround = function( ent )
				ent.FrontWheelPowered = ent:GetPowerDistribution() ~= 1
				ent.RearWheelPowered = ent:GetPowerDistribution() ~= -1
				
				for i = 1, table.Count( ent.Wheels ) do
					local Wheel = ent.Wheels[i]		
					if IsValid( Wheel ) then
						local dmgMul = Wheel:GetDamaged() and 0.5 or 1
						local surfacemul = simfphys.TractionData[Wheel:GetSurfaceMaterial():lower()]
						
						ent.VehicleData[ "SurfaceMul_" .. i ] = (surfacemul and math.max(surfacemul,0.001) or 1) * dmgMul
						
						local WheelPos = ent:LogicWheelPos( i )
						
						local WheelRadius = WheelPos.IsFrontWheel and ent.FrontWheelRadius or ent.RearWheelRadius
						local startpos = Wheel:GetPos()
						local dir = -ent.Up
						local len = WheelRadius + math.Clamp(-ent.Vel.z / 50,2.5,6)
						local HullSize = Vector(WheelRadius,WheelRadius,0)
						local tr = util.TraceHull( {
							start = startpos,
							endpos = startpos + dir * len,
							maxs = HullSize,
							mins = -HullSize,
							filter = ent.VehicleData["filter"]
						} )
						
						local onground = (self.IsOnGround and self:IsOnGround( vehicle )) and 1 or 0
						Wheel:SetOnGround( onground )
						ent.VehicleData[ "onGround_" .. i ] = onground
						
						if tr.Hit then
							Wheel:SetSpeed( Wheel.FX )
							Wheel:SetSkidSound( Wheel.skid )
							Wheel:SetSurfaceMaterial( util.GetSurfacePropName( tr.SurfaceProps ) )
						end
					end
				end
				
				local FrontOnGround = math.max(ent.VehicleData[ "onGround_1" ],ent.VehicleData[ "onGround_2" ])
				local RearOnGround = math.max(ent.VehicleData[ "onGround_3" ],ent.VehicleData[ "onGround_4" ])
				
				ent.DriveWheelsOnGround = math.max(ent.FrontWheelPowered and FrontOnGround or 0,ent.RearWheelPowered and RearOnGround or 0)
			end
			net.Start("gred_net_registertank")
				net.WriteEntity(vehicle)
			net.Broadcast()
			local tab = gred.simfphys[vehicle:GetSpawn_List()]
			if tab and tab.UpdateSuspension_SV then
				local OldThink = vehicle.Think
				vehicle.Think = function(vehicle)
					tab.UpdateSuspension_SV(vehicle)
					return OldThink(vehicle)
				end
			end
		end)
	end
	
	gred.TankTurn = function(vehicle,MaxTurn,TorqueCenter,TorqueCenterRate,ForceMul)
		if vehicle:EngineActive() and vehicle.susOnGround then
			local phys = vehicle:GetPhysicsObject()
			if !IsValid(phys) then return end
			if !vehicle.ModelBounds then
				local mins,maxs = vehicle:GetModelBounds()
				vehicle.ModelBounds = {maxs = maxs,mins = mins}
			end
			local massvec
			local vel = phys:GetAngleVelocity()
			local gear = vehicle:GetGear()
			-- local mul = (ShouldNotGearMul or gear <= 2) and 1 or math.abs(gear-2)*0.5
			-- MaxTurn = MaxTurn * mul
			if gear > 3 then
				phys:ApplyForceOffset(vehicle:GetRight()*(vehicle.TOQUECENTER_D > vehicle.TOQUECENTER_A and -vehicle.TOQUECENTER_D or vehicle.TOQUECENTER_A)*ForceMul,Vector(0,0,vehicle.ModelBounds.maxs.z*0.5))
			end
			if math.abs(vel.z) <= MaxTurn then
				local var = gred.CVars.gred_sv_simfphys_turnrate_multplier:GetFloat()
				TorqueCenter = TorqueCenter * var
				TorqueCenterRate = TorqueCenterRate * var
				
				if (vehicle.PressedKeys.D and gear != 1) or (vehicle.PressedKeys.A and gear == 1) then
					massvec = Vector(0,0,phys:GetMass())
					vehicle.TOQUECENTER_D = math.Clamp(vehicle.TOQUECENTER_D+TorqueCenterRate,0,TorqueCenter)
					if gear == 2 then
						local torque = vehicle.TOQUECENTER_D*0.5
						vehicle.VehicleData["spin_3"] = vehicle.VehicleData[ "spin_3" ] + torque
						vehicle.VehicleData["spin_5"] = vehicle.VehicleData[ "spin_5" ] + torque
					end
					phys:ApplyTorqueCenter(massvec*-vehicle.TOQUECENTER_D)
				else
					vehicle.TOQUECENTER_D = 0
				end
				
				if (vehicle.PressedKeys.A and gear != 1) or (vehicle.PressedKeys.D and gear == 1) then
					massvec = massvec or Vector(0,0,phys:GetMass())
					vehicle.TOQUECENTER_A = math.Clamp(vehicle.TOQUECENTER_A+TorqueCenterRate,0,TorqueCenter)
					if gear == 2 then
						local torque = vehicle.TOQUECENTER_A*0.5
						vehicle.VehicleData["spin_4"] = vehicle.VehicleData[ "spin_4" ] + torque
						vehicle.VehicleData["spin_6"] = vehicle.VehicleData[ "spin_6" ] + torque
					end
					phys:ApplyTorqueCenter(massvec*vehicle.TOQUECENTER_A)
				else
					vehicle.TOQUECENTER_A = 0
				end
			end
			
			if !vehicle.PressedKeys.A and !vehicle.PressedKeys.D then
				massvec = massvec or Vector(0,0,phys:GetMass())
				phys:ApplyTorqueCenter(massvec*-vel.z)
			end
		end
	end
	
	gred.TankDestruction = function(ent,gib,ang,skin,pitch,yaw,CreateAmmoFire,StopAmmoFire,CreateExplosion,CreateTurret)
		--[[
			DESTRUCTION TYPES
			- 0 = Normal gib
			- 1 = Turret goes boom
			- 2 = Jet fire only
			- 3 = Jet fire and boom
			- 4 = Jet fire and boom and turret goes boom
			- 5 = Short jet fire and boom and turret goes boom
			- 6 = Turret and tank go boom
		]]
		
		if ent.DestructionType and ent.DestructionType != 0 then
			if ent.DestructionType == 1 then
				CreateTurret(gib,ang,pitch,yaw)
			elseif ent.DestructionType == 6 then
				local ang = gib:GetAngles()
				CreateExplosion(gib,ang)
				CreateTurret(gib,ang,pitch,yaw)
			else
				if ent.DestructionType == 2 then
					CreateAmmoFire(gib,ang)
					timer.Simple(4,function()
						if !IsValid(gib) then return end
						StopAmmoFire(gib)
						
						if IsValid(gib.particleeffect) then gib.particleeffect:Fire("Start") end
						if gib.FireSound then
							gib.FireSound:Play()
						end
					end)
				elseif ent.DestructionType == 3 then
					CreateAmmoFire(gib,ang)
					timer.Simple(math.Rand(2,3),function()
						if !IsValid(gib) then return end
						StopAmmoFire(gib)
						CreateExplosion(gib,gib:GetAngles())
						
						if IsValid(gib.particleeffect) then gib.particleeffect:Fire("Start") end
						if gib.FireSound then
							gib.FireSound:Play()
						end
					end)
				elseif ent.DestructionType == 4 then
					CreateAmmoFire(gib,ang)
					timer.Simple(math.Rand(2,3),function()
						if !IsValid(gib) then return end
						StopAmmoFire(gib)
						local ang = gib:GetAngles()
						CreateExplosion(gib,ang)
						CreateTurret(gib,ang,pitch,yaw)
						
						if IsValid(gib.particleeffect) then gib.particleeffect:Fire("Start") end
						if gib.FireSound then
							gib.FireSound:Play()
						end
					end)
				elseif ent.DestructionType == 5 then
					CreateAmmoFire(gib,ang)
					timer.Simple(math.Rand(0.5,1.3),function()
						if !IsValid(gib) then return end
						StopAmmoFire(gib)
						local ang = gib:GetAngles()
						CreateExplosion(gib,ang)
						CreateTurret(gib,ang,pitch,yaw)
						
						if IsValid(gib.particleeffect) then gib.particleeffect:Fire("Start") end
						if gib.FireSound then
							gib.FireSound:Play()
						end
					end)
				end
				local function RemoveGibFire(gib)
					if IsValid(gib) then
						if gib.particleeffect and IsValid(gib.particleeffect) then
							gib.particleeffect:Fire("Stop")
							gib:OnRemove()
						else
							timer.Simple(0.01,function()
								RemoveGibFire(gib)
							end)
						end
					end
				end
				timer.Simple(0.7,function()
					RemoveGibFire(gib)
				end)
			end
		end
	end
	
	
	
	numpad.Register("k_gred_shell",function(ply,ent,key,bool)
		if not IsValid(ply) or not IsValid(ent) then return false end
		ent[key] = bool
	end)
	
	numpad.Register("k_gred_sight",function(ply,ent,key,bool)
		if not IsValid(ply) or not IsValid(ent) then return false end
		ent[key] = bool
	end)
	
	numpad.Register("k_gred_gun",function(ply,ent,key,bool)
		if not IsValid(ply) or not IsValid(ent) then return false end
		ent[key] = bool
	end)
	
	
	
	hook.Add("KeyPress","gred_keypress_shellhold",function(ply,key)
		if key != IN_USE then return end
		timer.Simple(0,function()
			if !IsValid(ply) then return end
			local ent = ply:GetNWEntity("PickedUpObject")
			if !IsValid(ent) then return end
			if !ent:IsPlayerHolding() then 
				ply:SetNWEntity("PickedUpObject",Entity(0))
			end
		end)
	end)
	
	hook.Add("PlayerDeath","gred_playerdeath_shellhold",function(ply)
		ply:SetNWEntity("PickedUpObject",Entity(0))
	end)
	
	hook.Add("PlayerEnteredVehicle","gred_player_entervehicle_hint",function(ply,seat)
				ply.CHECKED_BINDING_SIMFPHYS = false
				ply.GRED_HINT_SIMFPHYS_01_DONE = false
		if (seat.vehiclebase or (ply.GetSimfphys and IsValid(ply:GetSimfphys()))) and seat:GetNWBool("HasCannon",false) then
			if !ply.CHECKED_BINDING_SIMFPHYS then
				net.Start("gred_net_check_binding_simfphys")
				net.Send(ply)
				ply.CHECKED_BINDING_SIMFPHYS = true
			elseif !ply.GRED_HINT_SIMFPHYS_01_DONE then
				timer.Simple(0.2,function()
					if !IsValid(ply) then return end
					net.Start("gred_net_send_ply_hint_key")
						net.WriteInt(ply:GetInfoNum("gred_cl_simfphys_key_togglesight",22),9)
						net.WriteString("' key to toggle the tank sight while the turret is activated")
					net.Send(ply)
					timer.Simple(5,function()
						if !IsValid(ply) then return end
						net.Start("gred_net_send_ply_hint_key")
							net.WriteInt(ply:GetInfoNum("gred_cl_simfphys_key_changeshell",21),9)
							net.WriteString("' key to toggle shell types - Use HE against infantry or unarmored vehicles and AP against armored vehicles")
						net.Send(ply)
						timer.Simple(5,function()
							if !IsValid(ply) then return end
							net.Start("gred_net_send_ply_hint_simple")
								net.WriteString("You can reload the tank by spawning an ammo box entity and by throwing the right shells at the tank")
							net.Send(ply)
							timer.Simple(5,function()
								if !IsValid(ply) then return end
								net.Start("gred_net_send_ply_hint_simple")
									net.WriteString("You can change the settings by going to the 'Gredwitch's Stuff' category in the top right 'Options' menu of the spawnmenu")
								net.Send(ply)
							end)
						end)
					end)
				end)
				ply.GRED_HINT_SIMFPHYS_01_DONE = true
			end
		elseif !ply.GRED_HINT_LFS_01_DONE and ply.lfsGetPlane then
			local plane = ply:lfsGetPlane()
			timer.Simple(0,function()
				if IsValid(ply) and IsValid(plane) and ply == plane:GetDriver() then
					net.Start("gred_net_send_ply_hint_simple")
						net.WriteString("Don't forget to check out the controls by going to the 'Controls' tab of the LFS Icon while holding the C key")
					net.Send(ply)
					timer.Simple(5,function()
						if !IsValid(ply) then return end
						net.Start("gred_net_send_ply_hint_simple")
							net.WriteString("You can change some settings by going to the 'Gredwitch's Stuff' category in the top right 'Options' menu of the spawnmenu")
						net.Send(ply)
					end)
					ply.GRED_HINT_LFS_01_DONE = true
				end
			end)
		end
	end)
	
	
	
	net.Receive("gred_net_checkconcommand",function(len,ply)
		local str = net.ReadString()
		local cvar = gred.CVars[str]
		local val = net.ReadFloat()
		if !cvar then return end
		if !ply:IsSuperAdmin() then return end
		cvar:SetFloat(val)
		
		local TABLE = file.Read("gredwitch_base_config_sv.txt","DATA")
		TABLE = TABLE and util.JSONToTable(TABLE) or {}
		TABLE[str] = val
		file.Write("gredwitch_base_config_sv.txt",util.TableToJSON(TABLE))
	end)
	
	timer.Simple(1,function()
		local TABLE = file.Read("gredwitch_base_config_sv.txt","DATA")
		if TABLE then
			TABLE = util.JSONToTable(TABLE)
			for k,v in pairs(TABLE) do
				gred.CVars[k]:SetFloat(v)
			end
		end
	end)
end

for i = 1,3 do
	sound.Add( 	{
		name = "GRED_VO_HOLE_LEFT_WING_0"..i,
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 125,
		sound = "gredwitch/voice/eng_left_wing_v1_r"..i.."_t1_mood_high.wav"
	} )
	sound.Add( 	{
		name = "GRED_VO_HOLE_RIGHT_WING_0"..i,
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 125,
		sound = "gredwitch/voice/eng_right_wing_v1_r"..i.."_t1_mood_high.wav"
	} )
	sound.Add( 	{
		name = "GRED_VO_BAILOUT_0"..i,
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 90,
		sound = "gredwitch/voice/eng_bailout_v1_r"..i.."_t1_mood_high.wav"
	} )
end

local LFSInifniteAmmo 		= gred.CVars["gred_sv_lfs_infinite_ammo"]
local LFSGodmode 			= gred.CVars["gred_sv_lfs_godmode"]
local WACOverride 			= gred.CVars["gred_sv_wac_override"]
local healthmultiplier 		= gred.CVars["gred_sv_lfs_healthmultiplier"]
local healthmultiplier_all 	= gred.CVars["gred_sv_lfs_healthmultiplier_all"]
local nextRefil 			= 0.5
local bigNum 				= 999999
-- local no = {
	-- [2] = true,
	-- [8194] = true
-- }

local function AddHABAmmoTypes()
	if not hab then return end
	if not hab.Module.PhysBullet then return end
	
	local HAB_COLOR_RED 	= HAB_COLOR_RED or Color( 255, 0, 0, 255 )
	local HAB_COLOR_GREEN 	= HAB_COLOR_GREEN or Color( 0, 255, 0, 255 )
	local HAB_COLOR_YELLOW 	= HAB_COLOR_YELLOW or Color( 255, 255, 0, 255 )
	local Types = {}
	local hab_colors = {
		["red"] = HAB_COLOR_RED,
		["green"] = HAB_COLOR_GREEN,
		["white"] = color_white,
		["yellow"] = HAB_COLOR_YELLOW,
		[""] = HAB_COLOR_RED,
	}
	
	for k,v in pairs(hab_colors) do
		Types["wac_base_7mm"..k] = {
			name = "wac_base_7mm"..k,
			
			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 15,
			npcdmg = 15,

			force = 32,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 853,
			Color = v,
			EffectSize = 1,
			HullSize = 0,
			Penetration = 7,

			BlastDamage = 5,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 7,

			BalisticsType = HAB_BULLET_MODEL_G7,
			Fused = false,
			Proximity = false,
			Radius = 0,
			TimeToLive = 10,
			TracerTimeToLive = 10,

			Caliber = 7.62,
			Mass = 9.2,

			Number = 1,

			BulletType = HAB_BULLET_APHE
		}
		
		Types["wac_base_12mm"..k] = {
			name = "wac_base_12mm"..k,

			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 25,
			npcdmg = 25,

			force = 66,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 820,
			Color = HAB_COLOR_GREEN,
			EffectSize = 1,
			HullSize = 0,
			Penetration = 24,

			BlastDamage = 16,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 12,

			BalisticsType = HAB_BULLET_MODEL_G7,
			Fused = false,
			Proximity = false,
			Radius = 0,
			TimeToLive = 10,
			TracerTimeToLive = 10,

			Caliber = 12.7,
			Mass = 50,

			Number = 1,

			BulletType = HAB_BULLET_APHE
		}
		
		Types["wac_base_20mm"..k] = {
			name = "wac_base_20mm"..k,
			
			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 30,
			npcdmg = 30,

			force = 80,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 1030,
			Color = HAB_COLOR_RED,
			EffectSize = 2,
			HullSize = 0,
			Penetration = 13,

			BlastDamage = 45,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 30,

			BalisticsType = HAB_BULLET_MODEL_G7,
			Fused = true,
			Proximity = false,
			Radius = 0,
			TimeToLive = 8,
			TracerTimeToLive = 8,

			Caliber = 20,
			Mass = 10.2,

			Number = 1,

			BulletType = HAB_BULLET_APHE
		}
		
		Types["wac_base_30mm"..k] = {
			name = "wac_base_30mm"..k,
			
			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 42,
			npcdmg = 42,

			force = 80,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 960,
			Color = HAB_COLOR_RED,
			EffectSize = 3,
			HullSize = 0,
			Penetration = 15,

			BlastDamage = 50,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 50,

			BalisticsType = HAB_BULLET_MODEL_G7,
			Fused = true,
			Proximity = false,
			Radius = 0,
			TimeToLive = 8,
			TracerTimeToLive = 8,

			Caliber = 30,
			Mass = 38.9,

			Number = 1,

			BulletType = HAB_BULLET_HE
		}
		
		Types["wac_base_40mm"..k] = {
			name = "wac_base_40mm"..k,
			
			tracer = k == "" and nil or true,
			dmgtype = DMG_BULLET,
			plydmg = 58,
			npcdmg = 58,

			force = 120,
			minsplash = 0,
			maxsplash = 0,

			maxcarry = 1000,
			flags = 0,

			Velocity = 690,
			Color = HAB_COLOR_RED,
			EffectSize = 4,
			HullSize = 0,
			Penetration = 5,

			BlastDamage = 48,
			BlastDamageType = DMG_BLAST,
			BlastDamageRadius = 60,

			BalisticsType = HAB_BULLET_MODEL_G1,
			Fused = true,
			Proximity = false,
			Radius = 0,
			TimeToLive = 8,
			TracerTimeToLive = 8,

			Caliber = 37,
			Mass = 30,

			Number = 1,

			BulletType = HAB_BULLET_HE
		}
		
	end
	
	for k, v in pairs(Types) do
		hab.Module.PhysBullet.AddAmmoType(v)
	end
end
-- timer.Simple(1,function() AddHABAmmoTypes() end)
hook.Add("PhysBulletOnAddAmmoTypes","gred_add_hab_ammotypes",AddHABAmmoTypes)

hook.Add("OnEntityCreated","gred_ent_override",function(ent)
	if ent:IsNPC() then
		table.insert(gred.AllNPCs,ent)
		return
	end
	timer.Simple(0,function()
		if !IsValid(ent) then return end
		-----------------------------------
		
		if ent.isWacAircraft then
			if WACOverride:GetInt() == 1 then
			-- if ent.Base == "wac_hc_base" then
				
				ent.Engines = 1
				ent.Sounds.Radio = ""
				ent.Sounds.crashsnd = ""
				ent.Sounds.bipsnd = "crash/bip_loop.wav"
				
				-- SHARED.LUA
				ent.addSounds = function(self)
					self.sounds = {}
					self.Sounds.crashsnd = "crash/crash_"..math.random(1,10)..".ogg" --ADDED BY THE GREDWITCH
					for name, value in pairs(self.Sounds) do
						if name != "BaseClass" then
							sound.Add({
								name = "wac."..self.ClassName.."."..name,
								channel = CHAN_STATIC,
								soundlevel = (name == "Blades" or name == "Engine") and 200 or 100,
								sound = value
							})
							self.sounds[name] = CreateSound(self, "wac."..self.ClassName.."."..name)
							if name == "Blades" then
								self.sounds[name]:SetSoundLevel(120)
							elseif name == "Engine" then
								self.sounds[name]:SetSoundLevel(110)
							elseif name == "Radio" and value != "" then --ADDED BY THE GREDWITCH (start)
								self.sounds[name]:SetSoundLevel(60)
							elseif name == "crashsnd" then
								self.sounds[name]:SetSoundLevel(120)
							elseif name == "bipsnd" then
								self.sounds[name]:SetSoundLevel(80) --ADDED BY THE GREDWITCH (end)
							end
						end
					end
				end
				
				if SERVER then -- INIT.LUA
					ent.addStuff = function(self)
						local HealthsliderVAR = gred.CVars["gred_sv_healthslider"]:GetInt()
						local HealthEnable = gred.CVars["gred_sv_enablehealth"]:GetInt()
						local EngineHealthEnable = gred.CVars["gred_sv_enableenginehealth"]:GetInt()
						local Healthslider = 100
						if HealthEnable == 1 and EngineHealthEnable == 1 then
							
							if HealthsliderVAR == nil or HealthsliderVAR <= 0 then 
								Healthslider = 100
							else 
								Healthslider = HealthsliderVAR
							end
							
							self.engineHealth = self.Engines*Healthslider
							self.EngineHealth = self.Engines*Healthslider
							
						elseif HealthEnable == 1 and EngineHealthEnable == 0 then
						
							if HealthsliderVAR == nil or HealthsliderVAR <= 0 then 
								Healthslider = 100
							else 
								Healthslider = HealthsliderVAR
							end
							
							self.Engines = 1
							self.engineHealth = Healthslider
							self.EngineHealth = Healthslider
						end
					end
					
					ent.GredExplode = function(self,speed,pos)
						if self.blewup then return end
						self.blewup = true
						local lasta=(self.LastDamageTaken<CurTime()+6 and self.LastAttacker or self.Entity)
						for k, p in pairs(self.passengers) do
							if p and p:IsValid() then
								p:TakeDamage(speed,lasta,self.Entity)
							end
						end
						self:TakeDamage(self.engineHealth)
						if gred.CVars["gred_sv_wac_explosion"]:GetInt() <= 0 then return end
						local radius = self:BoundingRadius()
						local hitang = Angle(0,self:GetAngles().y+90,0)
						
						gred.CreateSound(pos,false,"explosions/fuel_depot_explode_close.wav","explosions/fuel_depot_explode_dist.wav","explosions/fuel_depot_explode_far.wav")
						
						self:Remove()
						if radius <= 300 then
							local effectdata = EffectData()
							effectdata:SetOrigin(pos)
							effectdata:SetAngles(hitang)
							effectdata:SetFlags(1)
							effectdata:SetSurfaceProp(1)
							Effect("gred_particle_wac_explosion",effectdata)
							radius = 600
						elseif radius <= 500 then
							local effectdata = EffectData()
							effectdata:SetOrigin(pos)
							effectdata:SetAngles(hitang)
							effectdata:SetFlags(5)
							effectdata:SetSurfaceProp(1)
							Effect("gred_particle_wac_explosion",effectdata)
							
							radius = 800
						elseif radius <= 2000 then
							local effectdata = EffectData()
							effectdata:SetOrigin(pos)
							effectdata:SetAngles(hitang)
							effectdata:SetFlags(9)
							effectdata:SetSurfaceProp(1)
							Effect("gred_particle_wac_explosion",effectdata)
							radius = 1000
						end
						gred.CreateExplosion(pos,radius,1000,self.Decal,self.TraceLength,self.GBOWNER,self,self.DEFAULT_PHYSFORCE,self.DEFAULT_PHYSFORCE_PLYGROUND,self.DEFAULT_PHYSFORCE_PLYAIR)
					end
					 
					ent.PhysicsCollide = function(self,cdat, phys)
						timer.Simple(0,function()
							if wac.aircraft.cvars.nodamage:GetInt() == 1 then
								return
							end
							if cdat.DeltaTime > 0.5 then
								local mass = cdat.HitObject:GetMass()
								if cdat.HitEntity:GetClass() == "worldspawn" then
									mass = 5000
								end
								local dmg = (cdat.Speed*cdat.Speed*math.Clamp(mass, 0, 5000))/10000000
								if !dmg or dmg < 1 then return end
								self:TakeDamage(dmg*15)
								if dmg > 2 then
									self.Entity:EmitSound("vehicles/v8/vehicle_impact_heavy"..math.random(1,4)..".wav")
									local lasta=(self.LastDamageTaken<CurTime()+6 and self.LastAttacker or self.Entity)
									for k, p in pairs(self.passengers) do
										if p and p:IsValid() then
											p:TakeDamage(dmg/5, lasta, self.Entity)
										end
									end
								end
							end
							-- ADDED BY THE GREDWITCH
							if (cdat.Speed > 1000 and !self.ShouldRotate) 
							or (cdat.Speed > 100 and self.ShouldRotate and !cdat.HitEntity.isWacRotor) 
							and (!cdat.HitEntity:IsPlayer() and!cdat.HitEntity:IsNPC() and !string.StartWith(cdat.HitEntity:GetClass(),"vfire")) then
								self:GredExplode(cdat.speed,cdat.HitPos)
							end
						end)
					end
				
					ent.Think = function(self)
						self:base("wac_hc_base").Think(self)
						-- START ADDED BY THE GREDWITCH
						if self.sounds.Radio then
							if self.active and gred.CVars["gred_sv_wac_radio"]:GetInt() == 1 then
								self.sounds.Radio:Play()
							else
								self.sounds.Radio:Stop()
							end
						end
						if self:WaterLevel() >= 2 and gred.CVars["gred_sv_wac_explosion_water"]:GetInt() >= 1 and !self.hascrashed then
							local pos = self:GetPos()
							local trdat   = {}
							trdat.start   = pos+Vector(0,0,4000)
							trdat.endpos  = pos
							trdat.filter  = self
							trdat.mask    = MASK_WATER + CONTENTS_TRANSLUCENT
							
							local tr = util.TraceLine(trdat)
							
							if tr.Hit then
								local ang = Angle(-90,0,0)
								local radius = self:BoundingRadius()
								local water = "ins_water_explosion"
								if radius <= 600 then
									local effectdata = EffectData()
									effectdata:SetOrigin(pos)
									effectdata:SetAngles(ang)
									effectdata:SetSurfaceProp(2)
									effectdata:SetFlags(1)
									Effect("gred_particle_wac_explosion",effectdata)
								else
									local effectdata = EffectData()
									effectdata:SetOrigin(pos)
									effectdata:SetAngles(ang)
									effectdata:SetSurfaceProp(2)
									effectdata:SetFlags(2)
									Effect("gred_particle_wac_explosion",effectdata)
								end
								
								gred.CreateSound(pos,false,"/explosions/aircraft_water_close.wav","/explosions/aircraft_water_dist.wav","/explosions/aircraft_water_far.wav")
								
								local lasta=(self.LastDamageTaken<CurTime()+6 and self.LastAttacker or self.Entity)
								if istable(self.passengers) then
									for k, p in pairs(self.passengers) do
										if p and p:IsValid() then
											p:TakeDamage(p:Health() + 20, lasta, self.Entity)
										end
									end
								end
								self.hascrashed = true
								self:Remove()
							end
						end
						
						if self.ShouldRotate and self.backRotor and self.topRotor and self.Base != "wac_pl_base" and !self.disabled
						and self.rotorRpm > 0.2 and gred.CVars["gred_sv_wac_heli_spin"]:GetInt() >= 1 then
							local p = self:GetPhysicsObject()
							if p and IsValid(p) then
								if !self.sounds.crashsnd:IsPlaying() then
									self.sounds.crashsnd:Play()
								end
								self.sounds.bipsnd:Play()
								local m = p:GetMass()
								local v = p:GetAngleVelocity()
								local v1 = p:GetVelocity()
								-- if p:GetVelocity().z > -300 then
									-- p:AddVelocity(Vector(0,0,2*(m/1200)*-(15*self.rotorRpm)))
								-- end
								p:SetVelocity(Vector(v1.x,v1.y,-300))--2*(m/1200)*-(15*self.rotorRpm)))
								m = m/200
								if v.z < 150 then
									p:AddAngleVelocity(Vector(0,0,3*m))
								end
								if v.y > -50 then
									p:AddAngleVelocity(Vector(0,-10-m,0))
								end
								self:SetHover(true)
								self.controls.throttle = 0
								for k,v in pairs (self.wheels) do
									if !v.ph then
										v.ph = function(ent,data) 
											v.GredHitGround = true	
										end
										v:AddCallback("PhysicsCollide",v.ph)
									end
									if v.GredHitGround then
										self:GredExplode(500,self:GetPos())
									end
								end
							end
						else
							if !self.topRotor and self.sounds.crashsnd then
								self.sounds.crashsnd:Stop()
							end
						end
						
						-- END ADDED BY THE GREDWITCH
					end
					
					ent.GredIsOnGround = function(self,v)
						local p = v:GetPos()
						return util.QuickTrace(p,p-Vector(0,0,1)).Hit
					end
					
					ent.DamageEngine = function(self,amt)
						if wac.aircraft.cvars.nodamage:GetInt() == 1 then
							return
						end
						if self.disabled then return end
						self.engineHealth = self.engineHealth - amt

						if self.engineHealth < 80  then
							if !self.sounds.MinorAlarm:IsPlaying() then
								self.sounds.MinorAlarm:Play()
							end
							if !self.Smoke and self.engineHealth>0 then
								self.Smoke = self:CreateSmoke()
							end
							if self.engineHealth < 50 then
								if !self.sounds.LowHealth:IsPlaying() then
									self.sounds.LowHealth:Play()
								end
								f = math.random(0,gred.CVars["gred_sv_wac_heli_spin_chance"]:GetInt())
								if !self.ShouldRotate and f == 0 then
									self.OldGredUP = self:GetUp()
									self.ShouldRotate = true
								end
								
								
								if self.engineHealth < 20 and !self.EngineFire then
									local fire = ents.Create("env_fire")
									fire:SetPos(self:LocalToWorld(self.FirePos))
									fire:Spawn()
									fire:SetParent(self.Entity)
									if gred.CVars["gred_sv_fire_effect"]:GetInt() >= 1 then
										ParticleEffectAttach("fire_large_01", 1, fire, 0)
										if (gred.CVars["gred_sv_multiple_fire_effects"]:GetInt() >= 1) then
											if self.OtherRotors then 
												for i = 1,3 do
													if not self.OtherRotors[i] then return end
													ParticleEffectAttach("fire_large_01", 1, self.OtherRotors[i], 0)
												end
											end
											if self.OtherRotor then ParticleEffectAttach("fire_large_01", 1, self.OtherRotor, 0) end
											if self.rotor2 then ParticleEffectAttach("fire_large_01", 1, self.rotor2, 0) end
											if self.topRotor2 then ParticleEffectAttach("fire_large_01", 1, self.topRotor2, 0) end
										end
									elseif gred.CVars["gred_sv_fire_effect"]:GetInt() <= 0 then
										if gred.CVars["gred_sv_multiple_fire_effects"]:GetInt() >= 1 then
											if self.OtherRotors then
												for i = 1,3 do
													if not self.OtherRotors[i] then return end
													local fire = ents.Create("env_fire_trail")
													fire:SetPos(self:LocalToWorld(self.OtherRotorPos[i]))
													fire:Spawn()
													fire:SetParent(self.Entity)
												end
											else
												if self.OtherRotor then local pos = self:LocalToWorld(self.OtherRotorPos) end
												if self.rotor2 then local pos = self:LocalToWorld(self.rotorPos2) end
												if self.topRotor2 then local pos = self:LocalToWorld(self.TopRotor2.pos) end
												if pos then
													local fire = ents.Create("env_fire_trail")
													fire:SetPos(pos)
													fire:Spawn()
													fire:SetParent(self.Entity)
												end
											end
										end
									end
									self.sounds.LowHealth:Play()
									self.EngineFire = fire
								end
								if self.engineHealth < 10 and (!self.ShouldRotate or !self.blewup) then 
									self.engineDead = true 
									self:setEngine(false) 
								end

								if self.engineHealth < 0 and !self.disabled and (!self.ShouldRotate or !self.blewup) then
									self.disabled = true
									self.engineRpm = 0
									self.rotorRpm = 0
									local lasta=(self.LastDamageTaken<CurTime()+6 and self.LastAttacker or self.Entity)
									for k, p in pairs(self.passengers) do
										if p and p:IsValid() then
											p:TakeDamage(p:Health() + 20, lasta, self.Entity)
										end
									end

									for k,v in pairs(self.seats) do
										v:Remove()
									end
									self.passengers={}
									self:StopAllSounds()

									self:setVar("rotorRpm", 0)
									self:setVar("engineRpm", 0)
									self:setVar("up", 0)

									self.IgnoreDamage = false
									--[[ this affects the base class
										for name, vec in pairs(self.Aerodynamics.Rotation) do
											vec = VectorRand()*100
										end
										for name, vec in pairs(self.Aerodynamics.Lift) do
											vec = VectorRand()
										end
										self.Aerodynamics.Rail = Vector(0.5, 0.5, 0.5)
									]]
									local effectdata = EffectData()
									effectdata:SetStart(self.Entity:GetPos())
									effectdata:SetOrigin(self.Entity:GetPos())
									effectdata:SetScale(1)
									Effect("Explosion", effectdata)
									Effect("HelicopterMegaBomb", effectdata)
									Effect("cball_explode", effectdata)
									util.BlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), 300, 300)
									self:setEngine(false)
									if self.Smoke then
										self.Smoke:Remove()
										self.Smoke=nil
									end
									if self.RotorWash then
										self.RotorWash:Remove()
										self.RotorWash=nil
									end
									if self:WaterLevel() >= 1 and gred.CVars["gred_sv_wac_explosion_water"]:GetInt() >= 1 then
										local pos = self:GetPos()
										local trdat   = {}
										trdat.start   = pos+Vector(0,0,4000)
										trdat.endpos  = pos
										trdat.filter  = self
										trdat.mask    = MASK_WATER + CONTENTS_TRANSLUCENT
											 
										local tr = util.TraceLine(trdat)
							
										if tr.Hit then
											local ang = Angle(-90,0,0)
											local radius = self:BoundingRadius()
											local water = "ins_water_explosion"
											if radius <= 600 then
												local effectdata = EffectData()
												effectdata:SetOrigin(tr.HitPos)
												effectdata:SetAngles(ang)
												effectdata:SetSurfaceProp(2)
												effectdata:SetFlags(1)
												Effect("gred_particle_wac_explosion",effectdata)
											else
												local effectdata = EffectData()
												effectdata:SetOrigin(tr.HitPos)
												effectdata:SetAngles(ang)
												effectdata:SetSurfaceProp(2)
												effectdata:SetFlags(2)
												Effect("gred_particle_wac_explosion",effectdata)
											end
											self.hascrashed = true
											self:Remove()
										end
									end
									--[[self:SetNWBool("locked", true)
									timer.Simple( 0.1, function() self:Remove() end)--]]
								end
							end
						end
						if self.Smoke then
							local rcol = math.Clamp(self.engineHealth*3.4, 0, 170)
							self.Smoke:SetKeyValue("rendercolor", rcol.." "..rcol.." "..rcol)
						end
						self:SetNWFloat("health", self.engineHealth)
					end
				end
				
				if CLIENT then -- CL_INIT.LUA
					ent.receiveInput = function(self,name, value, seat)
						if name == "FreeView" then
							local player = LocalPlayer()
							if value > 0.5 then
								-- ADDED BY GREDWITCH
								if self.Camera and seat == self.Camera.seat and seat != 1 then
									if !player:GetVehicle().useCamerazoom then player:GetVehicle().useCamerazoom = 0 end
									player:GetVehicle().useCamerazoom = player:GetVehicle().useCamerazoom + 1
									if player:GetVehicle().useCamerazoom > 3 then player:GetVehicle().useCamerazoom = 0 end
								else -- END
									player.wac.viewFree = true
								end -- ADDED BY GREDWITCH
							else
								if self.Camera and seat == self.Camera.seat and seat != 1 then
								else
									player.wac.viewFree = false
									player.wac_air_resetview = true
								end
							end
						elseif name == "Camera" then
							local player = LocalPlayer()
							if value > 0.5 then
								player:GetVehicle().useCamera = !player:GetVehicle().useCamera
								if self.Camera and seat == self.Camera.seat then player:GetVehicle().useCamerazoom = 0 end -- ADDED BY GREDWITCH
							end
						end
					end
					
					ent.viewCalcCamera = function(self,k, p, view)
						view.origin = self.camera:LocalToWorld(self.Camera.viewPos)
						view.angles = self.camera:GetAngles()
						
						-- ADDED BY GREDWITCH
						local zoom = p:GetVehicle().useCamerazoom
						if zoom then
							if zoom >= 1 then
								view.fov = view.fov - zoom*20
							end
						end	
						for k, t in pairs(self.Seats) do
							if k != "BaseClass" and self:getWeapon(k) then
								if self:getWeapon(k).HasLastShot then
									if self:getWeapon(k):GetIsShooting() then
										local ang = view.angles
										view.angles = view.angles + Angle(0,0,math.random(-2,2))
										timer.Simple(0.02,function() if IsValid(self) then
											view.angles = ang
											end
										end)
									end
								end
							end
						end
						-- END
						if self.viewTarget then
							self.viewTarget.angles = p:GetAimVector():Angle() - self:GetAngles()
						end
						self.viewPos = nil
						p.wac.lagAngles = Angle(0, 0, 0)
						p.wac.lagAccel = Vector(0, 0, 0)
						p.wac.lagAccelDelta = Vector(0, 0, 0)
						return view
					end
				end
				
				ent:addSounds()
			end
		
		elseif ent.LFS then
			if ent.Author == "Gredwitch" or healthmultiplier_all:GetInt() == 1 and ent.MaxHealth then
				ent.MaxHealth = ent.MaxHealth * healthmultiplier:GetFloat()
				ent.OldSetupDataTables = ent.SetupDataTables
				ent.SetupDataTables = function()
					if ent.DataSet then return end
					ent.DataSet = true
					ent:OldSetupDataTables()
					ent:NetworkVar( "Float",6, "HP", { KeyName = "health", Edit = { type = "Float", order = 2,min = 0, max = ent.MaxHealth, category = "Misc"} } )
				end
				ent:SetupDataTables()
				
				ent:SetHP(ent.MaxHealth)
			end
			if LFSGodmode:GetInt() == 1 then
				ent.Explode = function() return end
				ent.OnTakeDamage = function() return end
				ent.CheckRotorClearance = function() return end
				ent.nextDFX = 999999999999
			end
			if !CLIENT then
				if LFSInifniteAmmo:GetInt() == 1 then
					local oldthink = ent.Think
					ent.Think = function(self)
						if nextRefil < CurTime() then
							if self.MaxPrimaryAmmo != -1 then
								self:SetAmmoPrimary(self.MaxPrimaryAmmo)
							end
							if self.MaxSecondaryAmmo != -1 then
								self:SetAmmoSecondary(self.MaxSecondaryAmmo)
							end
							if self.SetAmmoMGFF then
								self:SetAmmoMGFF(self.AmmoMGFF)
							end
							if self.SetAmmoCannon then
								self:SetAmmoCannon(self.AmmoCannon)
							end
						end
						return oldthink(self)
					end
				end
			end
		end
		if !CLIENT then
			if ent.ClassName == "wac_hc_rocket" then
				ent.Initialize = function(self)
					math.randomseed(CurTime())
					self.Entity:SetModel("models/weltensturm/wac/rockets/rocket01.mdl")
					self.Entity:PhysicsInit(SOLID_VPHYSICS)
					self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
					self.Entity:SetSolid(SOLID_VPHYSICS)
					self.phys = self.Entity:GetPhysicsObject()
					if (self.phys:IsValid()) then
						self.phys:SetMass(400)
						self.phys:EnableGravity(false)
						self.phys:EnableCollisions(true)
						self.phys:EnableDrag(false)
						self.phys:Wake()
					end
					self.sound = CreateSound(self.Entity, "WAC/rocket_idle.wav")
					self.matType = MAT_DIRT
					self.hitAngle = Angle(270, 0, 0)
					if self.calcTarget then
						self.Speed = 70
					else
						self.Speed = 100
					end
				end
			elseif ent.ClassName == "gred_prop_part" or ent.ClassName == "gred_prop_tail" then
				if LFSGodmode:GetInt() == 1 then
					ent.OnTakeDamage = function() return end
				end
			elseif simfphys and simfphys.IsCar and simfphys.IsCar(ent) then
				timer.Simple(0.35,function()
					if !IsValid(ent) then return end
					
					local OldCollide = ent.PhysicsCollide
					local OldDamage = ent.OnTakeDamage
					local OldDestroyed = ent.OnDestroyed
					local inflictor,gdmg,T,dmgtype
					
					-- if gred.CVars["gred_sv_simfphys_bullet_dmg_tanks"]:GetInt() == 0 then
						for i = 0, ent:GetNumPoseParameters() - 1 do
							if ent:GetPoseParameterName(i) == "turret_yaw" then
								ent.GRED_ISTANK = true
								ent:SetNWBool("GRED_ISTANK",true)
								break
							end
						end
					-- end
					
					ent.Gred_MaxHP = ent:GetMaxHealth()
					
					ent.OnDestroyed = function(ent)
						DMG = ent.DMGDelt and ent.DMGDelt*10 or (ent.Gred_OldHP or ent.Gred_MaxHP)
						T = DMG/ent.Gred_MaxHP
						
						if T >= 0.1 then
							if T >= 0.25 then
								if T >= 0.35 then
									if T >= 0.6 then
										ent.DestructionType = math.random(5,6)
									else
										ent.DestructionType = math.random(3,4)
									end
								else
									ent.DestructionType = math.random(2,3)
								end
							else
								ent.DestructionType = 1
							end
						else
							ent.DestructionType = 0
						end
						OldDestroyed(ent)
					end
					ent.OnTakeDamage = function(ent,dmg)
						-- if ent.GRED_ISTANK and no[dmg:GetDamageType()] then return end
						
						inflictor = dmg:GetInflictor()
						if ent.IsArmored and inflictor and IsValid(inflictor) and inflictor.GetClass and inflictor:GetClass() == "base_shell" then
							DMG = ((inflictor.ShellType == "HE" and (inflictor.fraction and inflictor.fraction >= 1 or !inflictor.fraction) and !inflictor.ExplosionDamageOverride) or (inflictor.IS_HEAT[inflictor.ShellType] and inflictor.EntityHit != ent)) and 0 or dmg:GetDamage()*(inflictor.ExplosionDamageOverride and 1 or 0.1)
							dmg:SetDamage(DMG)
						end
						
						ent.Gred_OldHP 	= ent:GetCurHealth()
						ent.DMGDelt		= DMG
						
						OldDamage(ent,dmg)
					end
					
					ent.PhysicsCollide = function(ent,data,phy)
						if not (data.HitEntity and data.HitEntity.GetClass and data.HitEntity:GetClass() == "base_shell") then
							OldCollide(ent,data,phy)
						else
							if !data.HitEntity.Fired then
								local seat = ent:GetDriverSeat()
								if seat:GetNWBool("HasCannon",false) then
									local ammo = 0
									if seat:GetNWInt("Caliber",0) == data.HitEntity.Caliber then
										local ShellType
										local Caliber
										for k,v in pairs(seat.ShellTypes) do
											ammo = ammo + seat:GetNWInt("CurAmmo"..k,0)
											ShellType = ShellType and ShellType or (v.ShellType == data.HitEntity.ShellType and k or nil)
										end
										if ammo < seat:GetNWInt("MaxAmmo",0) then
											local str = "CurAmmo"..ShellType
											seat:SetNWInt(str,seat:GetNWInt(str,0) + 1)
											data.HitEntity:Remove()
											ent:EmitSound(seat.ReloadSound)
										end
										return
									end
								end
								for k,seat in pairs(ent.pSeat) do
									if seat:GetNWBool("HasCannon",false) then
										local ammo = 0
										if seat:GetNWInt("Caliber",0) == data.HitEntity.Caliber then
											local HasShelltype
											local ShellType
											for k,v in pairs(seat.ShellTypes) do
												ammo = ammo + seat:GetNWInt("CurAmmo"..k,0)
												ShellType = ShellType or (v.ShellType == data.HitEntity.ShellType and k or nil)
											end
											if ammo < seat:GetNWInt("MaxAmmo",0) then
												local str = "CurAmmo"..ShellType
												seat:SetNWInt(str,seat:GetNWInt(str,0) + 1)
												data.HitEntity:Remove()
												ent:EmitSound(seat.ReloadSound)
											end
											return
										end
									end
								end
							end
						end
					end
				end)
			end
		end
	end)
end)

hook.Add("EntityRemoved","gred_ent_removed",function(ent)
	if ent:IsNPC() then
		table.RemoveByValue(gred.AllNPCs,ent)
		return
	end
end)
