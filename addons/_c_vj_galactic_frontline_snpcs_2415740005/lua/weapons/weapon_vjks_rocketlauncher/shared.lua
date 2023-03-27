if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "Imperial Plex Launcher"
SWEP.Author 					= "KStrudel"
SWEP.Contact					= "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose					= "An Imperial Rocket Launcher."
SWEP.Instructions				= "Controls are like a regular weapon."
SWEP.Category					= "VJ Base"
	-- Client Settings ---------------------------------------------------------------------------------------------------------------------------------------------
if (CLIENT) then
SWEP.Slot						= 4 -- Which weapon slot you want your SWEP to be in? (1 2 3 4 5 6) 
SWEP.SlotPos					= 4 -- Which part of that slot do you want the SWEP to be in? (1 2 3 4 5 6)
SWEP.UseHands					= true
end
	-- NPC Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.NPC_NextPrimaryFire 		= 5 -- Next time it can use primary fire
SWEP.NPC_ReloadSound			= {"weapons/reload_plex.mp3"}
SWEP.NPC_BulletSpawnAttachment = "missile" -- The attachment that the bullet spawns on, leave empty for base to decide!
SWEP.NPC_FiringDistanceScale = 2.5 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_StandingOnly = true -- If true, the weapon can only be fired if the NPC is standing still
SWEP.NPC_AllowCustomSpread		= true
SWEP.NPC_CustomSpread	 		= 10
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.WorldModel					= "models/krieg/galacticempire/weapons/blastech_smartrocket.mdl" -- The world model (Third person, when a NPC is holding it, on ground, etc.)
SWEP.HoldType 					= "rpg"
SWEP.ViewModelFOV				= 60 -- Player FOV for the view model
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= false
	-- Primary Fire ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Primary.Damage				= 50 -- Damage
SWEP.Primary.Force				= 30 -- Force applied on the object the bullet hits
SWEP.Primary.ClipSize			= 1 -- Max amount of bullets per clip
SWEP.Primary.Recoil				= 0.6 -- How much recoil does the player get?
SWEP.Primary.Delay				= 1 -- Time until it can shoot again
SWEP.Primary.Automatic			= false -- Is it automatic?
SWEP.Primary.Ammo				= "RPG_Round" -- Ammo type
SWEP.Primary.Sound				= {"weapons/RocketLauncher/rocketlauncher_shoot1.ogg","weapons/RocketLauncher/rocketlauncher_shoot2.ogg","weapons/RocketLauncher/rocketlauncher_shoot3.ogg"}
SWEP.Primary.SoundVolume		= 4 -- Sound volume
SWEP.Primary.DistantSound		= {"weapons/RocketLauncher/rocketlauncher_shoot_distant.ogg"}
SWEP.Primary.DistantSoundVolume	= 1 -- Distant sound volume
SWEP.Primary.DisableBulletCode	= true -- The bullet won't spawn, this can be used when creating a projectile-based weapon
SWEP.PrimaryEffects_MuzzleAttachment = 1
SWEP.PrimaryEffects_SpawnShells = false
	-- Deployment Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.DelayOnDeploy 				= 3 -- Time until it can shoot again after deploying the weapon
	-- Reload Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasReloadSound				= true -- Does it have a reload sound? Remember even if this is set to false, the animation sound will still play!
SWEP.Reload_TimeUntilAmmoIsSet	= 0.8 -- Time until ammo is set to the weapon
SWEP.Reload_TimeUntilFinished	= 1.8 -- How much time until the player can play idle animation, shoot, etc.
SWEP.ReloadSound				= "weapons/reload_plex.mp3"
	-- Idle Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_VM_IDLE}
SWEP.NextIdle_Deploy			= 0.5 -- How much time until it plays the idle animation after the weapon gets deployed
SWEP.NextIdle_PrimaryAttack		= 0.1 -- How much time until it plays the idle animation after attacking(Primary)
---------------------------------------------------------------------------------------------------------------------------------------------


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





















function SWEP:CustomOnPrimaryAttack_BeforeShoot()
	if (CLIENT) then return end
	local proj = ents.Create("obj_vjks_rocket_shell")
	local ply_Ang = self:GetOwner():GetAimVector():Angle()
	local ply_Pos = self:GetOwner():GetShootPos() + ply_Ang:Forward()*-20 + ply_Ang:Up()*-9 + ply_Ang:Right()*10
	if self:GetOwner():IsPlayer() then proj:SetPos(ply_Pos) else proj:SetPos(self:GetNWVector("VJ_CurBulletPos")) end
	if self:GetOwner():IsPlayer() then proj:SetAngles(ply_Ang) else proj:SetAngles(self:GetOwner():GetAngles()) end
	proj:SetOwner(self:GetOwner())
	proj:Activate()
	proj:Spawn()
	
	local phys = proj:GetPhysicsObject()
	if IsValid(phys) then
		if self:GetOwner():IsPlayer() then
			phys:SetVelocity(self:GetOwner():GetAimVector() * 2332500)
		else
			phys:SetVelocity(self:GetOwner():CalculateProjectile("Line", self:GetNWVector("VJ_CurBulletPos"), self:GetOwner():GetEnemy():GetPos() + self:GetOwner():GetEnemy():OBBCenter(), 1332500))
		end
	end
	
	self:SetBodygroup(1, 1)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnPrimaryAttackEffects()
	--//ParticleEffect("vj_rpg2_smoke1", self:GetAttachment(3).Pos, Angle(0,0,0), self)
	--ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 2)
	--ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 2)
	--ParticleEffectAttach("smoke_exhaust_01a", PATTACH_POINT_FOLLOW, self, 2)
	timer.Simple(4, function() if IsValid(self) then self:StopParticles() end end)
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
function SWEP:CustomOnReload()
	timer.Simple(0.8, function()
		if IsValid(self) then
			self:SetBodygroup(1, 0)
		end
	end)
end