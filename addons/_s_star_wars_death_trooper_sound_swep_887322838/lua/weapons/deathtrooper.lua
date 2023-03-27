if SERVER then AddCSLuaFile() end

if CLIENT then

	SWEP.PrintName		= "Death Trooper Sounds"
	SWEP.Author			= "Luke"
	SWEP.Slot			= 0
	SWEP.SlotPos		= 1
	
end

-- You don't have to use sound scripts, but as far as I know it works better for compatibility
local sounds = {}
--sounds["sound_name_here"] 	= "file/path/to/sound.mp3"
sounds["1"] 	= "weapons/deathtrooper/a.wav"
sounds["2"] 		= "weapons/deathtrooper/c.wav"
sounds["3"] 	= "weapons/deathtrooper/c.wav"

for k, v in pairs(sounds) do
	sound.Add({
		name = k,
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = 100,
		sound = v
	})
end


SWEP.Category				= "Star Wars"
SWEP.ViewModelFlip			= false
SWEP.ViewModelFOV			= 60

SWEP.Spawnable				= true
SWEP.AdminOnly				= false
SWEP.UseHands				= false

SWEP.ViewModel				= "models/weapons/c_arms_hev.mdl"
SWEP.WorldModel				= ""

SWEP.Weight			  		= 1
SWEP.AutoSwitchTo			= true
SWEP.AutoSwitchFrom			= true

SWEP.Primary.Recoil			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		    = "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NextSoundTime 			= CurTime()
SWEP.SoundDelay 			= 5 --The delay in second before another sound can be played

function SWEP:Initialize()
	timer.Simple(0.2, function()
		self:SetHoldType("idle")
	end)
	self:SetHoldType("idle")
	self.NextSoundTime = CurTime()
end

function SWEP:PrimaryAttack()
	self:FireSound("1")
end

function SWEP:SecondaryAttack()
	self:FireSound("2")
end

function SWEP:Reload()
	self:FireSound("3")
end

function SWEP:FireSound(path)
	if self.NextSoundTime > CurTime() then return end
	self:EmitSound(path)
	self.NextSoundTime = CurTime() + self.SoundDelay
end