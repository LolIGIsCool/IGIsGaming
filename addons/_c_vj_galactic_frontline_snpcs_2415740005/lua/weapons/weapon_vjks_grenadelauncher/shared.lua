SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Imperial Grenade Launcher"
SWEP.Author 					= "KStrudel"
SWEP.Purpose					= "The Standard blaster carbine for the engineer troops of the Empire"
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Primary Data ====== --
SWEP.MadeForNPCsOnly = true
SWEP.WorldModel					= "models/krieg/galacticempire/weapons/blastech_c20.mdl"  -- The world model (Third person, when a NPC is holding it, on ground, etc.)
SWEP.NPC_NextPrimaryFire 		= 3.5 -- Next time it can use primary fire
SWEP.NPC_TimeUntilFire	 		= 3.5 -- How much time until the bullet/projectile is fired?
--SWEP.NPC_TimeUntilFireExtraTimers = {1.1,1.2,1.3,1.4,1.5,1.6}
SWEP.HoldType 					= "ar2" -- List of holdtypes are in the GMod wiki



	-- ====== Secondary Fire ====== --
SWEP.NPC_HasSecondaryFire = true -- Can the weapon have a secondary fire?
SWEP.NPC_SecondaryFireEnt = "obj_vjks_detonator_gl"
SWEP.NPC_SecondaryFireChance = 2 -- Chance that the secondary fire is used | 1 = always
SWEP.NPC_SecondaryFireDistance = 1000000 -- How close does the owner's enemy have to be for it to fire?
SWEP.NPC_SecondaryFireNext = VJ_Set(1, 4) -- How much time until the secondary fire can be used again?
SWEP.NPC_SecondaryFireSound = {"weapons/mortar/mortar_fire1.wav"} -- The sound it plays when the secondary fire is used



	-- ====== Firing Distance ====== --
SWEP.NPC_FiringDistanceScale = 1 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_FiringDistanceMax = 10000 -- Maximum firing distance | Clamped at the maximum sight distance of the NPC
SWEP.NPC_CustomSpread	 		= 1.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_CanBePickedUp = false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
SWEP.NPC_StandingOnly = false -- If true, the weapon can only be fired if the NPC is standing still

SWEP.Primary.NumberOfShots		= 5 -- How many shots per attack?

SWEP.Primary.Damage = 5 -- Damage
SWEP.Primary.ClipSize			= 50 -- Max amount of bullets per clip
	-- ====== Tracer Data ====== --
SWEP.Primary.Tracer				= 1
SWEP.Primary.TracerType			= "ks_effect_sw_laser_red" -- Tracer type (Examples: AR2, laster, 9mm)
SWEP.Primary.TakeAmmo			= 1 -- How much ammo should it take on each shot?
SWEP.PrimaryEffects_MuzzleParticles = {"vjks_blaster_red"}
SWEP.PrimaryEffects_DynamicLightColor = Color(255, 0, 0)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Sound				= {"weapons/e_11/e11_02.wav",
									"weapons/e_11/e11_03.wav",
									"weapons/e_11/e11_04.wav"}

SWEP.Primary.DistantSound		= {"weapons/e_11/e11_distant_1.wav",
									"weapons/e_11/e11_distant_2.wav",
									"weapons/e_11/e11_distant_3.wav"}

SWEP.Primary.DistantSoundLevel = 120 -- Distant sound level
SWEP.Primary.DistantSoundVolume	= 0.25 -- Distant sound volume

SWEP.NPC_HasReloadSound = true -- Should it play a sound when the base detects the SNPC playing a reload animation?
SWEP.NPC_ReloadSound = {"weapons/reload_glauncher.wav"} -- Sounds it plays when the base detects the SNPC playing a reload animation
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel_UseCustomPosition = true -- Should the gun use custom position? This can be used to fix guns that are in the crotch
SWEP.WorldModel_CustomPositionAngle = Vector(-10,1,180)
--1st#=Bring tip Up/Down, 2nd#=Rotate weapon Left/Right, 3rd#=Revolve weapon Left/Right 
SWEP.WorldModel_CustomPositionOrigin = Vector(-1.7,5.3,2.3)
--1st#=Slide Left/Right Horizontally, 2nd#=Bring weapon close or farther away, 3rd#=Move up/down
SWEP.WorldModel_CustomPositionBone = "ValveBiped.Bip01_R_Hand" -- The bone it will use as the main point
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







--Custom Variables

function SWEP:DoImpactEffect( tr, dmgtype )
	if( tr.HitSky ) then return true; end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos )
	effectdata:SetScale( 0.5 )
	effectdata:SetMagnitude( 1 )
	util.Effect( "effect_sw_impact_snpcs", effectdata, true, true )
	util.Effect( "cball_explode", effectdata, true, true )
	--util.Effect( "ManhackSparks", effectdata, true, true )
	util.Decal( "fadingscorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
	return true	
end
