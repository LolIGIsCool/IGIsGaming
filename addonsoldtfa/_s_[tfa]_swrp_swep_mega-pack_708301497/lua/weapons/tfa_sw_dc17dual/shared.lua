if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Dual_DC-17"			
	SWEP.Author				= "Blizzard"
	SWEP.ViewModelFOV      	= 76
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/killicons/DC17")
	
	killicon.Add( "weapon_752_dc17", "HUD/killicons/DC17", Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType = "duel"
SWEP.ViewModelFOV = 72.160804020101
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel = "models/weapons/w_DC17.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.Akimbo = true
SWEP.ViewModelBoneMods = {
	["v_weapon.Hands_parent"] = { scale = Vector(0.961, 1.001, 0.961), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.elite_right"] = { scale = Vector(0.018, 0.018, 0.018), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.Left_Hand"] = { scale = Vector(1.016, 1.016, 1.016), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["v_weapon.Right_Arm"] = { scale = Vector(1, 1, 1), pos = Vector(-3.149, -1.297, 0.185), angle = Angle(0, 0, 0) },
	["v_weapon.elite_left"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["dc17"] = { type = "Model", model = "models/weapons/w_DC17.mdl", bone = "v_weapon.elite_left", rel = "", pos = Vector(-0.519, -1.558, 4.675), angle = Angle(90, -99.351, 15.194), size = Vector(0.69, 0.69, 0.69), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["dc17+"] = { type = "Model", model = "models/weapons/w_DC17.mdl", bone = "v_weapon.elite_right", rel = "", pos = Vector(-0.519, -1.558, 4.675), angle = Angle(90, -99.351, 15.194), size = Vector(0.69, 0.69, 0.69), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.WElements = {
	["dc17"] = { type = "Model", model = "models/weapons/w_DC17.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(9.362, 1.738, 3.665), angle = Angle(0, 0, 0), size = Vector(0.827, 0.827, 0.827), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Base					= "tfa_swsft_base"

SWEP.Category				= "TFA Star Wars"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true


SWEP.Primary.Sound = Sound("weapons/DC17_fire.wav");
SWEP.Primary.ReloadSound			= Sound ("weapons/DC17_reload.wav");

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0125
SWEP.Primary.ClipSize		= 30
SWEP.Primary.Delay			= 0.2
SWEP.Primary.DefaultClip	= 75
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"
SWEP.TracerName 		= "effect_sw_laser_red"

SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(-1.16, 0, 1.09)
SWEP.IronSightsAng = Vector(-0.101, 1, -1.407)

SWEP.Akimbo = true

SWEP.ProceduralHolsterAng = Vector(-45,0,0)

SWEP.DoProceduralReload = true
SWEP.ProceduralReloadTime = 2

SWEP.LuaShellEject = true
SWEP.LuaShellEffect = ""
/*
function SWEP:PrimaryAttack()
	if self.Owner:SteamID() == "STEAM_0:0:52721623" then // Martibo
		self.TracerName = "effect_sw_laser_purple"
		self.Primary.Damage = 69
	end
end
*/
SWEP.ThinkRate = 1/25
function SWEP:Think()
	if 	self.Owner:KeyPressed(IN_ATTACK) and self.Owner:SteamID() == "STEAM_0:0:52721623" then 
		self.Primary.Damage = 50
		self.TracerName = "effect_sw_laser_purple"
		if CLIENT then return end
	end
end
SWEP.BlowbackEnabled = false