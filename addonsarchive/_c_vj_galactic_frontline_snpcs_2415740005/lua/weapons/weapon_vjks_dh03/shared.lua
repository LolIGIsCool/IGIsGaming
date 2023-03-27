if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Rebel Holdout Pistol"
SWEP.Author 					= "KStrudel"
SWEP.Purpose					= "This weapon is made for Players and NPCs"
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 2 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= false
end

-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_EnableDontUseRegulate 	= false -- Used for VJ Base SNPCs, if enabled the SNPC will remove use regulate
SWEP.NPC_NextPrimaryFire 		= 0.8 -- Next time it can use primary fire

SWEP.NPC_HasReloadSound = true -- Should it play a sound when the base detects the SNPC playing a reload animation?
SWEP.NPC_ReloadSound = {"weapons/sw_reload1.ogg", "weapons/sw_reload2.ogg", "weapons/sw_reload3.ogg"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_ReloadSoundLevel = 60 -- How far does the sound go?

	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.MadeForNPCsOnly 			= true -- Is tihs weapon meant to be for NPCs only?
SWEP.WorldModel					= "models/kriegsyntax/weapons/blastech_dh03/blastech_dh03.mdl" 
SWEP.WorldModel					= "models/kriegsyntax/weapons/blastech_dh03/blastech_dh03.mdl" -- The world model (Third person, when a NPC is holding it, on ground, etc.)
SWEP.HoldType 					= "pistol" -- List of holdtypes are in the GMod wiki
SWEP.Spawnable					= false
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 41 -- Damage
SWEP.Primary.PlayerDamage		= 1 -- Put 1 to make it the same as above
SWEP.Primary.UseNegativePlayerDamage = false -- Should it use a negative number for the player damage?
SWEP.Primary.Force				= 9 -- Force applied on the object the bullet hits
SWEP.Primary.NumberOfShots		= 1 -- How many shots per attack?
SWEP.Primary.ClipSize			= 10 -- Max amount of bullets per clip
SWEP.Primary.ClipSizeReload		= 3 -- If there is x amount of bullets left in the clip, then reload
SWEP.Primary.DefaultClip		= 300 -- How much ammo do you get when you first pick up the weapon?
SWEP.Primary.Cone				= 7 -- How accurate is the bullet? (Players)
SWEP.Primary.Delay				= 5.0 -- Time until it can shoot again
SWEP.Primary.Tracer				= 1
SWEP.Primary.TracerType			= "ks_effect_sw_laser_red" -- Tracer type (Examples: AR2, laster, 9mm)
SWEP.Primary.TakeAmmo			= 1 -- How much ammo should it take on each shot?
SWEP.Primary.Automatic			= true -- Is it automatic?
SWEP.Primary.Ammo				= "AR2" -- Ammo type
SWEP.Primary.Sound				= "weapons/scoutblaster/scoutblaster_fire.wav"
SWEP.Primary.HasDistantSound	= true -- Does it have a distant sound when the gun is shot?
SWEP.Primary.DistantSound		= "weapons/scoutblaster/scoutblaster_fire_distant.wav"
SWEP.Primary.DistantSoundVolume	= 0.3 -- Distant sound volume
SWEP.PrimaryEffects_MuzzleParticles = {"vjks_blaster_red"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = false -- If set to true, the base will spawn all the given particles instead of picking one
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false
SWEP.PrimaryEffects_DynamicLightColor = Color(255, 0, 0)
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.ReloadSound				= {"weapons/sw_reload1.ogg", "weapons/sw_reload2.ogg", "weapons/sw_reload3.ogg"}
SWEP.SetReloadingToFalseTime	= 1 -- Time until self.Reloading becomes false, so the gun for example can holster
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)
SWEP.NextIdle_Reload			= 3 -- How much time until it plays the idle animation after reloading
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_HasRangeAdjustBurst = true

function SWEP:DoImpactEffect( tr, dmgtype )
	if( tr.HitSky ) then return true; end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( tr.HitPos )
	effectdata:SetScale( 1 )
	effectdata:SetMagnitude( 2 ) 
	util.Effect( "effect_sw_impact_SNPCs", effectdata, true, true )
	util.Decal( "fadingscorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
	return true	
end