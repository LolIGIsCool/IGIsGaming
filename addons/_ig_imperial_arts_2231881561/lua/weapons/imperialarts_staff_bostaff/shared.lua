SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 3
SWEP.PrintName = "BO Staff"
SWEP.Author = "Misahu"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Imperial Arts"
SWEP.SlotPos = 3
 
SWEP.Purpose = "BO Staff"

SWEP.ViewModelFOV = 95
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_oren_katana.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true
SWEP.CanThrow = false

--STAT RATING (1-6)
SWEP.Type=7 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=1 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=2 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=1 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="imperialarts_staff_bostaff"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=50
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 1
SWEP.DmgMin = 75
SWEP.DmgMax = 100
SWEP.Delay = 0.9
SWEP.TimeToHit = 0.03
SWEP.Range = 100
SWEP.Punch1 = Angle(-5, 10, 0)
SWEP.Punch2 = Angle(-5, 0, -3)
SWEP.HitFX = ""
SWEP.HitFX2 = ""
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.3
SWEP.DmgMin2 = 2
SWEP.DmgMax2 = 10
SWEP.ThrowModel = "models/rising/bo_rifle.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 0
SWEP.ThrowForce = 0
SWEP.FixedThrowAng = Angle(90,0,0)
SWEP.SpinAng = Vector(0,0,1500)

--HOLDTYPES
SWEP.AttackHoldType="knife"
SWEP.Attack2HoldType="melee2"
SWEP.ChargeHoldType="knife"
SWEP.IdleHoldType="melee2"
SWEP.BlockHoldType="slam"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound=""
SWEP.ThrowSound=""
SWEP.Hit1Sound="physics/body/body_medium_impact_hard1.wav"
SWEP.Hit2Sound="physics/body/body_medium_impact_hard2.wav"
SWEP.Hit3Sound="physics/body/body_medium_impact_hard3.wav"

SWEP.Impact1Sound="physics/metal/metal_solid_impact_hard1.wav"
SWEP.Impact2Sound="physics/metal/metal_solid_impact_hard4.wav"

SWEP.ViewModelBoneMods = {
	["RW_Weapon"] = { scale = Vector(0.039, 0.039, 0.039), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0, 0, 0)
SWEP.StunAng = Vector(-16.181, 0, 47.136)

SWEP.ShovePos = Vector(-6.633, -0.403, -1.005)
SWEP.ShoveAng = Vector(-3.518, 70, -70)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(0, 0, 0)

SWEP.WhipPos = Vector(0, -10.252, 0)
SWEP.WhipAng = Vector(70, 0, 0)

SWEP.ThrowPos = Vector(-4.624, -3.217, -2.613)
SWEP.ThrowAng = Vector(0, -90, -90)

SWEP.FanPos = Vector(5.23, -10.051, -3.62)
SWEP.FanAng = Vector(80, 16.884, 90)

SWEP.WallPos = Vector(0,0,0)
SWEP.WallAng = Vector(0,0,0)

function SWEP:AttackAnimation()
	self.Weapon.AttackAnimRate = 1.1
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing2.wav")
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
end
function SWEP:AttackAnimation2()
	self.Weapon.AttackAnimRate = 1.6
	self.Punch1 = Angle(0, -15, 0)
	self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing1.wav")
end
one=true
two=false
three=false
function SWEP:AttackAnimationCOMBO()
	self.Weapon.AttackAnimRate = 1.8
	if one==true then  
		self.Owner:EmitSound("weapons/stunstick/stunstick_swing1.wav")
		self.Punch1 = Angle(0, -10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK )
		one=false
		two=true
		three=false
	elseif two==true then
		self.Owner:EmitSound("weapons/stunstick/stunstick_swing2.wav")
		self.Punch1 = Angle(5, 10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_MISSLEFT )
		one=false
		two=false
		three=true
	elseif three==true then
		self.Owner:EmitSound("weapons/stunstick/stunstick_swing2.wav")
		self.Punch1 = Angle(5, 10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_PULLBACK_HIGH )
		one=true
		two=false
		three=false
	end
end
function SWEP:AttackAnimation3()
	self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
end
function SWEP:AtkExtra()
	self.Owner:EmitSound("weapons/stunstick/stunstick_fleshhit1.wav")
end


SWEP.VElements = {
	["FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(43, 0.3, -0.5), size = { x = 12, y = 12}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(45.5, 0.3, -0.5), size = { x = 9, y = 9}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(47, 0.3, -0.5), size = { x = 6, y = 6}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(48, 0.3, -0.5), size = { x = 3, y = 3}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(-14.5, 0.3, 0.5), size = { x = 12, y = 12}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(-16, 0.3, 0.5), size = { x = 9, y = 9}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(-18, 0.3, 0.5), size = { x = 6, y = 6}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(-19, 0.3, 0.5), size = { x = 3, y = 3}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["b"] = { type = "Model", model = "models/rising/bo_rifle.mdl", bone = "RW_Weapon", rel = "", pos = Vector(0.2, -0.5, -11), angle = Angle(90, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(44.5, 0, 0), size = { x = 12, y = 12}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(46.5, 0, 0), size = { x = 9, y = 9}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(48.5, 0, 0), size = { x = 6, y = 6}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(50.5, 0, 0), size = { x = 3, y = 3}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(-15.5, 0, -0), size = { x = 12, y = 12}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(-17.5, 0, 0), size = { x = 9, y = 9}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(-19.5, 0, 0), size = { x = 6, y = 6}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(-21.5, 0, 0), size = { x = 3, y = 3}, color = Color(255, 210, 0, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["b"] = { type = "Model", model = "models/rising/bo_rifle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 01, 13), angle = Angle(-90, -90, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}