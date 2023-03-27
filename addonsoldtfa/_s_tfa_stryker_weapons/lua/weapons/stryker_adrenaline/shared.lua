if CLIENT then

	SWEP.PrintName = "Adrenaline Shot [Single Use]"
	SWEP.Author = "Stryker"
	SWEP.Slot = 2
	SWEP.SlotPos = 0
	SWEP.Description = "Quick Adrenaline shot to get you back in the fight, one time use"
	SWEP.Contact = ""
	SWEP.Purpose = "A quick boost of adrenaline!"
	SWEP.Instructions = "Left click: Heal yourself."

	SWEP.WepSelectIcon = surface.GetTextureID("HUD/killicons/syringe_Kit")
	killicon.Add( "weapon_jew_stimkit", "HUD/killicons/syringe_kit", Color( 255, 80, 0, 255 ) )

end

if SERVER then
	AddCSLuaFile("shared.lua")
end

DEFINE_BASECLASS("tfa_gun_base")
SWEP.HoldType = "slam"
SWEP.Category = "TFA StarWars Stryker"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Primary.Sound = Sound("weapons/medkit/sw_syringe.wav")
SWEP.Primary.ReloadSound = Sound ("weapons/medkit/sw_syringe.wav");
SWEP.Weight = 2
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Primary.Recoil = 0
SWEP.Primary.Damage = 0
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.RPM = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "XBowBolt"

SWEP.ViewModelFOV = 70
SWEP.UseHands = true
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["syringe"] = { type = "Model", model = "models/weapons/w_eq_healthshot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.201, 2.741, 1), angle = Angle(188.121, -8.627, 3.792), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["syringe"] = { type = "Model", model = "models/weapons/w_eq_healthshot.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-3.112, 1.258, -1.589), angle = Angle(25.728, 0, 180), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.data 							= {}
SWEP.data.ironsights				= 0
SWEP.Primary.Delay = 1
SWEP.PrintDelay = 0
SWEP.StripWeaponDelay = 0

function SWEP:Deploy()
	self.Weapon:EmitSound("startup", 35)
end



function SWEP:PrimaryAttack()
	local need
	need = math.min( self.Owner:GetMaxHealth() - self.Owner:Health(), self.Owner:GetMaxHealth() * .5 ) --[[1 = 100% health return and 0.1 = 10% health return you can also add .88 to make it 88% if you want]]--
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	local maxhealth = self.Owner:GetMaxHealth()
	if self.Owner:Health() >= maxhealth then
		if not CLIENT then return end
		if self.PrintDelay > CurTime() then return end
		self.Owner:PrintMessage(HUD_PRINTTALK, "The syringe is not effective you are not damaged!")
		self.PrintDelay = CurTime() + 0.3
		self:SetNextPrimaryFire(CurTime())
			else
		self.Owner:SetHealth( math.min( self.Owner:GetMaxHealth(), self.Owner:Health() + need ) )
		self:EmitSound("weapons/medkit/sw_syringe.wav", 75)
		if CLIENT then return end
		self.Owner:StripWeapon("stryker_adrenaline") 

	end
end


