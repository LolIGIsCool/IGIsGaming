if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then

	SWEP.PrintName			= "Z6 Rotary Blaster"			
	SWEP.Author				= "TFA"
	SWEP.ViewModelFOV      	= 50
	SWEP.Slot				= 4
	SWEP.SlotPos			= 72	
end

SWEP.HoldType				= "crossbow"
SWEP.Base					= "tfa_swsft_base"

SWEP.Category = "TFA Star Wars"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.HoldType = "crossbow"
SWEP.ViewModelFOV = 56.08040201005
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/tfa_sw_z6_v2.mdl"
SWEP.WorldModel = "models/weapons/w_z6_rotary_blaster.mdl"--"models/weapons/w_crossbow.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.UseHands = true
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 15.312) },
	["barrel"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VMPos = Vector(2,-2,-1) -- If you want the gun on your back comment out this line.

SWEP.Primary.Sound = Sound ("TFA_SW_Z6.Fire");
SWEP.Primary.ReloadSound = Sound ("weapons/DC15A_reload.wav");

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Spread = 0.30
SWEP.Primary.ClipSize = 200
SWEP.Primary.Force = 60
SWEP.Primary.Damage = 20
SWEP.Primary.Delay = 0.08
SWEP.Primary.Recoil = 0.05
SWEP.Primary.DefaultClip = 300
SWEP.Primary.Automatic = true
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Sound = Sound("TFA_SW_Z6.Fire");
SWEP.TracerName = "effect_sw_laser_red"
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.data = {}
SWEP.data.ironsights = 0

SWEP.BlowbackVector = Vector(0,-3,0.025)
SWEP.Blowback_Only_Iron  = false

SWEP.DoProceduralReload = true
SWEP.ProceduralReloadTime = 3

SWEP.WElements = {
	//["element_name"] = { type = "Model", model = "models/weapons/w_z6_rotary_blaster.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.194, 1, -8.351), angle = Angle(-21.119, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Offset = {
	Pos = {
	Up = -8.351,
	Right = 1,
	Forward = 20.194,
	},
	Ang = {
	Up = 0,
	Right = -21.19,
	Forward = 178
	},
	Scale = 1
}

function SWEP:Think()

	self:SetWeaponHoldType( self.HoldType )
	
	if 	self.Owner:KeyPressed(IN_ATTACK) then 
		
		local vm = self.Owner:GetViewModel()
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fire04" ) )	
	    self:SetNextPrimaryFire(CurTime() + 0.7)
		self:SetNextSecondaryFire(CurTime() + 0.7)
		self.Weapon:EmitSound(Sound("TFA_SW_Z6.StartSpin"))
		//self.Owner:ConCommand( "+walk" )
		//self.Owner:ConCommand( "-speed" )
		if CLIENT then return end
	end
	

	if 	self.Owner:KeyReleased(IN_ATTACK) then
		local vm = self.Owner:GetViewModel()	
		self.Weapon:StopSound( "weapons/z6_stopspin.wav" )
		self.Weapon:EmitSound(Sound("TFA_SW_Z6.StopSpin"))
		//timer.Simple( 0.1, function() self.Owner:ConCommand( "-walk" ) end )
		if CLIENT then return end
	end
		
sound.Add( {
	name = "TFA_SW_Z6.Fire",
	channel = CHAN_USER_BASE+11,
	volume = 1.0,
	level = 120,
	pitch = { 95, 110 },
	sound = "weapons/repeat-1.wav"
} )

sound.Add( {
	name = "TFA_SW_Z6.StartSpin",
	channel = CHAN_USER_BASE+12,
	volume = 1.0,
	level = 70,
	pitch = { 100, 100 },
	sound = "weapons/z6_startspin.wav"
} )

sound.Add( {
	name = "TFA_SW_Z6.StopSpin",
	channel = CHAN_USER_BASE+12,
	volume = 1.0,
	level = 70,
	pitch = { 100, 100 },
	sound = "weapons/z6_stopspin.wav"
} )

sound.Add( {
	name = "TFA_SW_Z6.Spin",
	channel = CHAN_USER_BASE+12,
	volume = 1.0,
	level = 70,
	pitch = { 100, 100 },
	sound = "weapons/z6_spin.wav"
} )

sound.Add( {
	name = "TFA_SW_Z6.Reload",
	channel = CHAN_USER_BASE+12,
	volume = 1.0,
	level = 120,
	pitch = { 95, 110 },
	sound = "weapons/DC15A_reload.wav"
} )

end

function SWEP:Reload()
 if self.ReloadingTime and CurTime() <= self.ReloadingTime then return end
 
	if ( self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
	
		self:DefaultReload( ACT_VM_RELOAD )
				
				self.Owner:ConCommand( "-attack" )
				//self.Owner:ConCommand( "-speed" )
				//self.Owner:ConCommand( "-walk" )
				self.Weapon:EmitSound(Sound("TFA_SW_Z6.Reload"))
				self.Weapon:StopSound( "weapons/DC15A_reload.wav" )
                local AnimationTime = self.Owner:GetViewModel():SequenceDuration()
                self.ReloadingTime = CurTime() + 1
                self:SetNextPrimaryFire(CurTime() + 1)
                self:SetNextSecondaryFire(CurTime() + 1)
	end
	
	
	
end
--[[
SWEP.NextSpinSound = 0
SWEP.Primary.RPM_TransitionTime = 5
SWEP.Primary.RPM_Max = 10
SWEP.Primary.RPM_Base = 5
SWEP.BarrelRotation = 0
SWEP.BarrelVelocity = 0
SWEP.BarrelVelocityMax = 360*4.25
SWEP.BarrelAcceleration = SWEP.BarrelVelocityMax / SWEP.Primary.RPM_TransitionTime
SWEP.BarrelFriction = SWEP.BarrelVelocityMax / SWEP.Primary.RPM_TransitionTime * 2

local oldsh,sh,shfac,rpmfac,baracc
local rpmdif = SWEP.Primary.RPM_Max - SWEP.Primary.RPM_Base
SWEP.Callback = {}
SWEP.Callback.Deploy = function(self)
	self.BarrelRotation = 0
	self.BarrelVelocity = 0
	self.NextSpinSound = CurTime()
end

SWEP.Callback.PlayerThinkServer  = function(self)
	sh = ( self.Owner:KeyDown(IN_ATTACK) and !self:GetReloading() and !self:GetHolstering() and !self:GetDrawing() and !self:IsSafety() and !(self:GetNearWallRatio()>0.05) and self:Clip1()>0 )
	
	if oldsh==nil then oldsh = sh end
	
	if SERVER or ( CLIENT and !game.SinglePlayer() ) then
		if !oldsh and sh then
			print("startspin")
			self:EmitSound("TFA_SW_Z6.StartSpin")
			self.NextSpinSound = CurTime()+SoundDuration( "weapons/z6_startspin.wav" )	- 0.5
		elseif oldsh and !sh then
			self:EmitSound("TFA_SW_Z6.StopSpin")
			self.NextSpinSound = CurTime()+SoundDuration( "weapons/z6_stopspin.wav" )	
		elseif sh then
			if CurTime()>self.NextSpinSound then
				self:EmitSound("TFA_SW_Z6.Spin")
				self.NextSpinSound = CurTime()+SoundDuration( "weapons/z6_spin.wav" )
			end
		elseif !sh then
			self:StopSound("TFA_SW_Z6.Spin")
		end
	end
	
	oldsh = sh
	
	shfac = sh and 1 or 0
	rpmfac = sh and self.Primary.RPM_Max or self.Primary.RPM_Base
	self.Primary.RPM = math.Approach( self.Primary.RPM,rpmfac,rpmdif / self.Primary.RPM_TransitionTime * FrameTime() )
	self.BarrelVelocity = math.Clamp( self.BarrelVelocity + ( sh and self.BarrelAcceleration or -self.BarrelFriction ) * FrameTime(), 0, self.BarrelVelocityMax )
	self.BarrelRotation = math.NormalizeAngle( self.BarrelRotation + self.BarrelVelocity * FrameTime() )
	self.ViewModelBoneMods["barrel"].angle.p = self.BarrelRotation
	
end
SWEP.Callback.PlayerThinkClientFrame = SWEP.Callback.PlayerThinkServer
]]

local tracercolors = { "effect_sw_laser_purple", "effect_sw_laser_red", "effect_sw_laser_blue", "effect_sw_laser_white", "effect_sw_laser_green" }
//local tracercolors = { "effect_sw_laser_red", "effect_sw_laser_green" }

function SWEP:PrimaryAttack()

	--[[randompitch = math.Rand(90, 130)
	
	if ( !self:CanPrimaryAttack() ) then return end
	local bullet = {}
		bullet.Num = self.Primary.NumberofShots
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
		bullet.Tracer	= 1
		if self.Owner:SteamID() == "STEAM_0:0:23047205" then // Wolf
			bullet.TracerName = "effect_sw_laser_green"
			bullet.Damage = 69
		elseif self.Owner:SteamID() == "STEAM_0:0:52423713" or self.Owner:SteamID() == "STEAM_0:1:167427435" or self.Owner:SteamID() == "STEAM_0:0:7634642" then // Moose, Kosmos & Martibo
			--bullet.TracerName = "effect_sw_laser_purple"
			bullet.TracerName = table.Random(tracercolors)
			bullet.Damage = 69
		else
			bullet.TracerName = "effect_sw_laser_red"
			bullet.Damage = self.Primary.Damage
		end
		bullet.Force = self.Primary.Force
		bullet.AmmoType = self.Primary.Ammo	
	local rnda = self.Primary.Recoil * 1
	local rndb = self.Primary.Recoil * math.random(-10, 10)
	self.Owner:ViewPunch( Angle( 0.01, 0, 0 ) )
	self:ShootEffects()
	self.Owner:FireBullets( bullet )]]
	self.Weapon:EmitSound(Sound(self.Primary.Sound))
	--self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
	self:TakePrimaryAmmo(self.Primary.TakeAmmo)
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

end