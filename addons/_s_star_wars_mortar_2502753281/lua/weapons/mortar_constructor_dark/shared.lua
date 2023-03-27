AddCSLuaFile()

SWEP.Base = "mortar_constructor"
SWEP.PrintName = "Mortar Dark"
SWEP.Spawnable = true

SWEP.Author = "DolUnity"
SWEP.Purpose = "Place a Mortar"
SWEP.Instructions = "Place the mortar with attack \nPick it up with duck and use"
SWEP.Category = "DolUnity"
SWEP.Spawnable = true
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.UseHands = true
SWEP.DrawAmmo = false

function SWEP:OnSpawn(ent)
    ent:SetSkin(1)
end