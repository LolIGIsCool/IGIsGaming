if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base 						= "weapon_vj_base"
SWEP.PrintName					= "BlasTech DH-21"
SWEP.Author 					= "KStrudel"
SWEP.Purpose					= "The Standard blaster for the footsoldiers of the Alliance"
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ====== Primary Data ====== --
SWEP.MadeForNPCsOnly = true
SWEP.WorldModel					= "models/krieg/galacticempire/weapons/blastech_dh21.mdl" 
--SWEP.NPC_TimeUntilFireExtraTimers = {1.1,1.2,1.3,1.4,1.5,1.6}
SWEP.HoldType 					= "smg" -- List of holdtypes are in the GMod wiki
SWEP.HasIdleAnimation			= true -- Does it have a idle animation?
SWEP.AnimTbl_Idle				= {ACT_IDLE_RELAXED}
	-- ====== Before Fire Sound Variables ====== --
	-- NOTE: This only works with VJ Human SNPCs!
SWEP.NPC_BeforeFireSound = {"weapons/blaster_deploy_1.ogg","weapons/blaster_deploy_2.ogg","weapons/blaster_deploy_3.ogg","weapons/blaster_deploy_4.ogg","weapons/blaster_deploy_5.ogg"} -- Plays a sound before the firing code is ran, usually in the beginning of the animation
SWEP.NPC_BeforeFireSoundLevel = 50 -- How far does the sound go?
SWEP.NPC_BeforeFireSoundPitch = VJ_Set(100, 100)

	-- ====== Firing Distance ====== --
SWEP.NPC_FiringDistanceScale = 1 -- Changes how far the NPC can fire | 1 = No change, x < 1 = closer, x > 1 = farther
SWEP.NPC_FiringDistanceMax = 100000 -- Maximum firing distance | Clamped at the maximum sight distance of the NPC
SWEP.NPC_CustomSpread	 		= 1.5 -- This is added on top of the custom spread that's set inside the SNPC! | Starting from 1: Closer to 0 = better accuracy, Farther than 1 = worse accuracy
SWEP.NPC_CanBePickedUp = false -- Can this weapon be picked up by NPCs? (Ex: Rebels)
SWEP.NPC_StandingOnly = false -- If true, the weapon can only be fired if the NPC is standing still

SWEP.Primary.Damage = 10 -- Damage
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
SWEP.NPC_ReloadSound = {"weapons/sw_reload1.ogg", "weapons/sw_reload2.ogg", "weapons/sw_reload3.ogg"} -- Sounds it plays when the base detects the SNPC playing a reload animation
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



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




SWEP.NPC_HasRangeAdjustBurst = true --+200
SWEP.NPC_RangeCloseDist = 450
SWEP.NPC_RangeCloseBurst1 = 1
SWEP.NPC_RangeCloseBurst2 = 1
SWEP.NPC_RangeCloseCooldown1 = 0.8
SWEP.NPC_RangeCloseCooldown2 = 1.2
SWEP.NPC_RangeMediumDist = 1800
SWEP.NPC_RangeMediumBurst1 = 1
SWEP.NPC_RangeMediumBurst2 = 1
SWEP.NPC_RangeMediumCooldown1 = 0.5
SWEP.NPC_RangeMediumCooldown2 = 1.4
SWEP.NPC_RangeFarDist = 3100
SWEP.NPC_RangeFarBurst1 = 1
SWEP.NPC_RangeFarBurst2 = 1
SWEP.NPC_RangeFarCooldown1 = 0.8
SWEP.NPC_RangeFarCooldown2 = 1.8
SWEP.NPC_RangeVeryFarBurst1 = 1
SWEP.NPC_RangeVeryFarBurst2 = 1
SWEP.NPC_RangeVeryFarCooldown1 = 0.9
SWEP.NPC_RangeVeryFarCooldown2 = 2.3
SWEP.NPC_RangeAdjustDecrease = 400
SWEP.NPC_RangeAutocooldowntime = 3

SWEP.NPC_firecontrolshotfired = 0
SWEP.NPC_isRangeCooldown = 0
SWEP.NPC_NextRangeCooldownResetT = 0

SWEP.NPC_ExtraFireSoundPitch1 = 100
SWEP.NPC_ExtraFireSoundPitch2 = 100

SWEP.NPC_NoMoveShoot = false




---------------Weapon Code by: Panzer Elite




function SWEP:CustomOnInitialize_extrastuff() end

function SWEP:CustomOnInitialize()

	self:CustomOnInitialize_extrastuff()
	self.NPC_TimeUntilFire = self.NPC_TimeUntilFire	+ 0.05 
	self.Primary.Force = self.Primary.Force/5
	timer.Simple(0.1,function()
	if self:IsValid() then
	if self.Owner:IsValid() and self.Owner.Weapon_FiringDistanceFar != nil then
	
	if self.Owner.Weapon_FiringDistanceFar >= 3000 and self.NPC_RangeAdjustDecrease != nil then
	if self.Owner.Weapon_FiringDistanceFarOriginalAdjustment == nil then
	self.Owner.Weapon_FiringDistanceFarOriginalAdjustment = self.Owner.Weapon_FiringDistanceFar
	self.Owner.Weapon_FiringDistanceFar = self.Owner.Weapon_FiringDistanceFar - self.NPC_RangeAdjustDecrease
	--self.Owner.Weapon_FiringDistanceFarDoneAdjustment = 1
	else
		self.Owner.Weapon_FiringDistanceFar = self.Owner.Weapon_FiringDistanceFarOriginalAdjustment - self.NPC_RangeAdjustDecrease
		--self.Owner.Weapon_FiringDistanceFarDoneAdjustment = 1
	end
	end	
	
	if GetConVarNumber("vj_advancedoi_snpc_weapondmgmod") != 0 then
		self.Primary.Damage	= self.Primary.Damage*GetConVarNumber("vj_advancedoi_snpc_weapondmgmod")
	end
	
	if self.NPC_NoMoveShoot == true then 
		--self.Owner.HasShootWhileMoving = false
		--self.Owner.MoveRandomlyWhenShooting = false
		--self.Owner.CanFlankEnemy = false
		self.Owner.AnimTbl_ShootWhileMovingRun = self.Owner.AnimTbl_ShootWhileMovingWalk
		self.Owner.AnimTbl_ShootWhileMovingWalk = self.Owner.AnimTbl_ShootWhileMovingWalk --self.Owner.AnimTbl_WeaponAttack
	end
	
	end
	end
	end)

end

function SWEP:CustomOnThink() 

	if self:IsValid() then
	if self.NPC_NextRangeCooldownResetT != 0 and self.NPC_NextRangeCooldownResetT <= CurTime() then

		--self.NPC_isRangeCooldown = 0
		self.NPC_firecontrolshotfired = 0

	end
	end

end

function SWEP:CustomOnNPC_Reload() 

		self.NPC_isRangeCooldown = 0
		self.NPC_firecontrolshotfired = 0

end
/*
function SWEP:NPCShoot_Primary(ShootPos,ShootDir)
	//self:SetClip1(self:Clip1() -1)
	//if CurTime() > self.NPC_NextPrimaryFireT then
	//self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
	if (!self:IsValid()) or (!self.Owner:IsValid()) then return end
	if self.Owner.VJ_IsBeingControlled == false && !IsValid(self.Owner:GetEnemy()) then return end
	if self.Owner.VJ_IsBeingControlled == false && (!self.Owner:Visible(self.Owner:GetEnemy())) then return end
	if self.Owner.VJ_IsBeingControlled == false && self.NPC_isRangeCooldown == 1 then return end
	if self.Owner.IsVJBaseSNPC == true then
		//self.Owner.Weapon_TimeSinceLastShot = 0
		self.Owner.NextWeaponAttackAimPoseParametersReset = CurTime() + 1
		self.Owner:WeaponAimPoseParameters()
		//if self.Owner.IsVJBaseSNPC == true then self.Owner.Weapon_TimeSinceLastShot = 0 end
	end
	timer.Simple(self.NPC_TimeUntilFire,function()
		if IsValid(self) && IsValid(self.Owner) && self:NPCAbleToShoot() == true && self.NPC_isRangeCooldown != 1 && CurTime() > self.NPC_NextPrimaryFireT then
			if self.Owner.DisableWeaponFiringGesture != true then
				--self:NPC_PlayFiringGesture()
			end
			self:PrimaryAttack()
			if self.NPC_NextPrimaryFire != false then
				self.NPC_NextPrimaryFireT = CurTime() + self.NPC_NextPrimaryFire
				for tk, tv in ipairs(self.NPC_TimeUntilFireExtraTimers) do
					timer.Simple(tv, function() if IsValid(self) && IsValid(self.Owner) && self:NPCAbleToShoot() == true then self:PrimaryAttack() end end)
				end
			end
			if self.Owner.IsVJBaseSNPC == true then self.Owner.Weapon_TimeSinceLastShot = 0 end
		end
	end)
	//end
end
*/
function SWEP:CustomOnPrimaryAttack_AfterShoot() 
	
	if !IsValid(self.Owner) then return end
	if self.Owner:IsPlayer() then return end
	if self.Owner:IsNPC() && !IsValid(self.Owner:GetEnemy()) then return end

	if self.Owner.ForceWeaponFire_activated == nil or self.Owner.ForceWeaponFire_activated == 0 then
	self.NPC_firecontrolshotfired = self.NPC_firecontrolshotfired + 1
	end
	
	self.NPC_NextRangeCooldownResetT = CurTime() + self.NPC_RangeAutocooldowntime
	if self.NPC_isRangeCooldown != 1 then
	local EnemyDist = self.Owner:GetPos():DistToSqr( self.Owner:GetEnemy():GetPos() )
	local CooldownTime = 0
	
	if EnemyDist <= self.NPC_RangeCloseDist*self.NPC_RangeCloseDist then
	if self.NPC_firecontrolshotfired >= (self.NPC_RangeCloseBurst1 + math.random(0,self.NPC_RangeCloseBurst2)) then
	
	self.NPC_isRangeCooldown = 1
	
	timer.Simple((math.random(self.NPC_RangeCloseCooldown1*10,self.NPC_RangeCloseCooldown2*10))*0.1,function()
	
	if self:IsValid() then
	if self.NPC_isRangeCooldown != 0 then
		self.NPC_isRangeCooldown = 0
		self.NPC_firecontrolshotfired = 0
	end
	end
	
	end)
	
	end
	end
	
	if EnemyDist > self.NPC_RangeCloseDist*self.NPC_RangeCloseDist and EnemyDist <= self.NPC_RangeMediumDist*self.NPC_RangeMediumDist then
	if self.NPC_firecontrolshotfired >= (self.NPC_RangeMediumBurst1 + math.random(0,self.NPC_RangeMediumBurst2)) then
	self.NPC_isRangeCooldown = 1
	timer.Simple((math.random(self.NPC_RangeMediumCooldown1*10,self.NPC_RangeMediumCooldown2*10))*0.1,function()
	
	if self:IsValid() then
	if self.NPC_isRangeCooldown != 0 then
		self.NPC_isRangeCooldown = 0
		self.NPC_firecontrolshotfired = 0
	end
	end
	
	end)
	
	end
	end
	
	if EnemyDist > self.NPC_RangeMediumDist*self.NPC_RangeMediumDist and EnemyDist <= self.NPC_RangeFarDist*self.NPC_RangeFarDist then
	if self.NPC_firecontrolshotfired >= (self.NPC_RangeFarBurst1 + math.random(0,self.NPC_RangeFarBurst2)) then
	self.NPC_isRangeCooldown = 1
	timer.Simple((math.random(self.NPC_RangeFarCooldown1*10,self.NPC_RangeFarCooldown2*10))*0.1,function()
	
	if self:IsValid() then
	if self.NPC_isRangeCooldown != 0 then
		self.NPC_isRangeCooldown = 0
		self.NPC_firecontrolshotfired = 0
	end
	end
	
	end)
	
	end
	end
	
	if EnemyDist > self.NPC_RangeFarDist*self.NPC_RangeFarDist then
	if self.NPC_firecontrolshotfired >= (self.NPC_RangeVeryFarBurst1 + math.random(0,self.NPC_RangeVeryFarBurst2)) then
	self.NPC_isRangeCooldown = 1
	timer.Simple((math.random(self.NPC_RangeVeryFarCooldown1*10,self.NPC_RangeVeryFarCooldown2*10))*0.1,function()
	
	if self:IsValid() then
	if self.NPC_isRangeCooldown != 0 then
		self.NPC_isRangeCooldown = 0
		self.NPC_firecontrolshotfired = 0
	end
	end
	
	end)
	
	end
	end
	end
end

function SWEP:CustomOnPrimaryAttack_BeforeShoot() 

	if (!self:IsValid()) or (!self.Owner:IsValid()) then return end
	if self.Owner.VJ_IsBeingControlled == false && self.NPC_isRangeCooldown == 1 then return true end
	
	
	
end 