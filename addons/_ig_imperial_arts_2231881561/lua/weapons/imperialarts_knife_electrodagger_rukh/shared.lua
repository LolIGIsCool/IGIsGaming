SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 2
SWEP.PrintName = "Electro Baton Rukh"
SWEP.Author = "Misahu"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 10
SWEP.Category = "Imperial Arts"
SWEP.SlotPos = 2
 
SWEP.Purpose = "Is the Jedi nimble? Well so are you"

SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_mastunstick.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true
SWEP.CanThrow = false

--STAT RATING (1-6)
SWEP.Type=1 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=3 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=5 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=1 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="imperialarts_knife_electrodagger_rukh"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=15
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 3.5
SWEP.DmgMin = 80
SWEP.DmgMax = 300
SWEP.Delay = 0.5
SWEP.TimeToHit = 0.02
SWEP.AttackAnimRate = 0.8
SWEP.Range = 75
SWEP.Punch1 = Angle(-2, 0, 0)
SWEP.Punch2 = Angle(5, 0, -2)
SWEP.HitFX = ""
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.35
SWEP.DmgMin2 = 10
SWEP.DmgMax2 = 30
SWEP.ThrowModel = "models/red menace/fallenorder/props/purgetrooper/dagger.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 1200
SWEP.FixedThrowAng = Angle(0,180,0)
SWEP.SpinAng = Vector(0,-1500,0)

--HOLDTYPES
SWEP.AttackHoldType="melee"
SWEP.Attack2HoldType="knife"
SWEP.ChargeHoldType="melee"
SWEP.IdleHoldType="knife"
SWEP.BlockHoldType="slam"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound="weapons/iceaxe/iceaxe_swing1.wav"
SWEP.ThrowSound="axethrow.mp3"
SWEP.Hit1Sound="ambient/machines/slicer3.wav"
SWEP.Hit2Sound="ambient/machines/slicer3.wav"
SWEP.Hit3Sound="ambient/machines/slicer3.wav"

SWEP.Impact1Sound="physics/metal/metal_solid_impact_hard1.wav"
SWEP.Impact2Sound="physics/metal/metal_solid_impact_hard4.wav"
SWEP.ViewModelBoneMods = {
	["smdimport"] = { scale = Vector(0.112, 0.112, 0.112), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}


SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0,0,0)
SWEP.StunAng = Vector(5.627, -11.961, 47.136)

SWEP.ThrowPos = Vector(2.612, -5.428, 10.251)
SWEP.ThrowAng = Vector(33.064, -56.986, 30.954)

SWEP.ShovePos = Vector(-11.061, -13.669, -7.841)
SWEP.ShoveAng = Vector(24.622, 70, -46.432)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(-33.065, 0, 0)

SWEP.WhipPos = Vector(-0.202, -20, -1.005)
SWEP.WhipAng = Vector(60.502, -9.146, 22.513)

SWEP.FanPos = Vector(8.039, -24, 8.239)
SWEP.FanAng = Vector(64.723, 24.622, 90)

SWEP.WallPos = Vector(0,0,0)
SWEP.WallAng = Vector(0,0,0)

function SWEP:AttackAnimation()
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing1.wav")	
end
function SWEP:AttackAnimation2()
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing1.wav")	
end
function SWEP:AttackAnimation3()
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing1.wav")	
end


SWEP.VElements = {
	["FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 7+4), size = { x = 10, y = 10 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 9+4), size = { x = 10, y = 10 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 11+4), size = { x = 9, y = 9 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 13+4), size = { x = 9, y = 9 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 15+4), size = { x = 9, y = 9 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 17+4), size = { x = 8, y = 8 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 19+4), size = { x = 8, y = 8 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 19+4), size = { x = 7, y = 7 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["b"] = { type = "Model", model = "models/red menace/fallenorder/props/purgetrooper/dagger.mdl", bone = "smdimport", rel = "", pos = Vector(0, 0, -0.557), angle = Angle(0, 20, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 7+4), size = { x = 10, y = 10 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 9+4), size = { x = 10, y = 10 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 11+4), size = { x = 9, y = 9 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 13+4), size = { x = 9, y = 9 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 15+4), size = { x = 9, y = 9 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 17+4), size = { x = 8, y = 8 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 19+4), size = { x = 8, y = 8 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 19+4), size = { x = 7, y = 7 }, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["b"] = { type = "Model", model = "models/red menace/fallenorder/props/purgetrooper/dagger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 1, 0.5), angle = Angle(180, 80, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}