if CLIENT then
	SWEP.PrintName = "Wardrobe Restocker"
	SWEP.Author = "Fire & Aiko"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.DrawAmmo = false

SWEP.HoldType = "normal"
SWEP.Category = "Aiko's Sweps"
SWEP.UseHands = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Automatic = false

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:PrimaryAttack()
	local ent = self.Owner:GetEyeTrace().Entity
	if ent:GetClass() != "radbox_wardrobe" then return end
	if SERVER then

		local suits = 1
		for _, ply in ipairs(player.GetAll()) do
			if string.find( ply:GetRegiment(), "107") then
				suits = suits + 1
			end
		end

		ent:SetHazmatSuits(suits)
		if suits == 1 then
			self.Owner:ChatPrint("Added " .. suits .. " hazmat suit to the wardrobe.")
		else
			self.Owner:ChatPrint("Added " .. suits .. " hazmat suits to the wardrobe.")
		end
		self.Owner:StripWeapon(self.Owner:GetActiveWeapon():GetClass())
	end
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end
function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
end