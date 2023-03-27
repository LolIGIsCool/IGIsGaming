if SERVER then
	AddCSLuaFile()
end

ENT.Type = "anim"
ENT.Base = "tfa_ammo_base"
ENT.PrintName = "Tibanna Stun Charge"
ENT.Category = "TFA Star Wars Ammunition"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Class = ""
ENT.MyModel = "models/Items/BoxMRounds.mdl"
ENT.ImpactSound = "Default.ImpactSoft"
ENT.AmmoCount = 40
ENT.AmmoType = "stun_ammo"
ENT.DrawText = true
ENT.TextColor = Color(0, 255, 255, 255)
ENT.TextPosition = Vector(2, 1.5, 13.5)
ENT.TextAngles = Vector(90, 90, 90)
ENT.ShouldDrawShadow = true
ENT.ImpactSound = "Default.ImpactSoft"
ENT.Damage = 35
ENT.Text = "Tibanna Stun Charge"
