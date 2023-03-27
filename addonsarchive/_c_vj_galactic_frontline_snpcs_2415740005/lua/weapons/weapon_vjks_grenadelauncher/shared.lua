if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Imperial Grenade Launcher"
SWEP.Author 					= "DrVrej"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "Launches a bundle of grenades at targets."
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 1 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 1 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= 5 -- Next time it can use primary fires
SWEP.NPC_TimeUntilFire	 		= 0.8 -- How much time until the bullet/projectile is fired?
SWEP.NPC_ReloadSound			= {"weapons/reload_glauncher.wav"}
SWEP.NPC_FiringDistanceScale = 2.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_StandingOnly = true -- If true, the weapon can only be fired if the NPC is standing still
SWEP.NPC_AllowCustomSpread		= true
SWEP.NPC_CustomSpread	 		= 10


SWEP.NPC_HasReloadSound = true -- Should it play a sound when the base detects the SNPC playing a reload animation?
SWEP.NPC_ReloadSound = {"weapons/sw_reload1.ogg", "weapons/sw_reload2.ogg", "weapons/sw_reload3.ogg"} -- Sounds it plays when the base detects the SNPC playing a reload animation
SWEP.NPC_ReloadSoundLevel = 60 -- How far does the sound go?
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel					= "models/kriegsyntax/weapons/blastech_c20/blastech_c20.mdl" 
SWEP.WorldModel					= "models/kriegsyntax/weapons/blastech_c20/blastech_c20.mdl" -- The world model (Third person, when a NPC is holding it, on ground, etc.)
SWEP.HoldType 					= "ar2"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 20 -- Damage
SWEP.Primary.Force				= 1 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 3 -- Max amount of bullets per clip
SWEP.Primary.NumberOfShots		= 3 -- How many shots per attack?
SWEP.Primary.Recoil				= 2 -- How much recoil does the player get?
SWEP.Primary.Delay				= 0.2 -- Time until it can shoot again
SWEP.Primary.Automatic			= false -- Is it automatic?
SWEP.Primary.Ammo				= "AR2" -- Ammo type
SWEP.Primary.Sound				= {"weapons/grenadelauncher/grenadelauncher_fire.wav"}
SWEP.Primary.DistantSound		= {"weapons/grenadelauncher/grenadelauncher_distant.wav"}
//SWEP.Primary.DistantSoundVolume	= 0.25 -- Distant sound volume
SWEP.PrimaryEffects_MuzzleParticles = {"vj_rifle_smoke","vj_rifle_smoke_dark","vj_rifle_smoke_flash","vj_rifle_sparks2"}
SWEP.PrimaryEffects_MuzzleParticlesAsOne = true -- If set to true, the base will spawn all the given particles instead of picking one
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 0.6 -- Time until it can shoot again after deploying the weapon
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.5 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if (CLIENT) then return end
	local proj = ents.Create("obj_vjks_thermaldetonator")
	local ply_Ang = self:GetOwner():GetAimVector():Angle()
	local ply_Pos = self:GetOwner():GetShootPos()
	if self:GetOwner():IsPlayer() then proj:SetPos(ply_Pos) else proj:SetPos(self:GetNWVector("VJ_CurBulletPos")) end
	if self:GetOwner():IsPlayer() then proj:SetAngles(ply_Ang) else proj:SetAngles(self:GetOwner():GetAngles()) end
	proj:SetOwner(self:GetOwner())
	proj:Activate()
	proj:Spawn()
	
	local phys = proj:GetPhysicsObject()
	if IsValid(phys) then
		if self:GetOwner():IsPlayer() then
			phys:SetVelocity(self:GetOwner():GetAimVector() * 250)
		else
			phys:SetVelocity(self:GetOwner():CalculateProjectile("Line", self:GetNWVector("VJ_CurBulletPos"), self:GetOwner():GetEnemy():GetPos() + self:GetOwner():GetEnemy():OBBCenter(), 2050))
		end
	end
end
