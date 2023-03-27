SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 3
SWEP.PrintName = "Electrohammer"
SWEP.Author = "Misahu"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Imperial Arts"
SWEP.SlotPos = 3
 
SWEP.Purpose = "For those Jedi that stand 9 feet tall and just wont die"

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_crovel.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true
SWEP.CanThrow = false

--STAT RATING (1-6)
SWEP.Type=3 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=5 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=2 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=4 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="imperialarts_bludgeon_electrohammer"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=55
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 1.3
SWEP.DmgMin = 200
SWEP.DmgMax = 300
SWEP.Delay = 2
SWEP.TimeToHit = 0.15
SWEP.AttackAnimRate = 1
SWEP.Range = 130
SWEP.Punch1 = Angle(-2, 0, 0)
SWEP.Punch2 = Angle(5, 0, -2)
SWEP.HitFX = ""
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.4
SWEP.DmgMin2 = 8
SWEP.DmgMax2 = 28
SWEP.ThrowModel = "models/red menace/fallenorder/props/purgetrooper/hammer.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 0
SWEP.ThrowForce = 0

--HOLDTYPES
SWEP.AttackHoldType="grenade"
SWEP.Attack2HoldType="melee2"
SWEP.ChargeHoldType="melee"
SWEP.IdleHoldType="melee2"
SWEP.BlockHoldType="physgun"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound="WeaponFrag.Throw"
SWEP.ThrowSound=""
SWEP.Hit1Sound="physics/body/body_medium_impact_hard1.wav"
SWEP.Hit2Sound="physics/body/body_medium_impact_hard2.wav"
SWEP.Hit3Sound="physics/body/body_medium_impact_hard3.wav"

SWEP.Impact1Sound="physics/metal/metal_solid_impact_hard1.wav"
SWEP.Impact2Sound="physics/metal/metal_solid_impact_hard4.wav"

SWEP.ViewModelBoneMods = {
	["LeftForeArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-3.052, -2.712, 1.355), angle = Angle(0, 0, 0) },
	["LeftHandRing1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -1.017), angle = Angle(0, 0, 0) },
	["LeftHandThumb1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-0.926, 0, -0.556), angle = Angle(-5.557, 0, 0) },
	["RightHandMiddle1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.555, 0, 0.555), angle = Angle(0, 0, 0) },
	["LeftHandPinky1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.678), angle = Angle(0, 0, 0) },
	["RightHandRing1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.555, 0, 0.555), angle = Angle(0, 0, 0) },
	["LeftHandMiddle1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -1.017), angle = Angle(0, 0, 0) },
	["RightHandPinky1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.555, 0, 0.185), angle = Angle(0, 0, 0) },
	["RightHandIndex1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(0.925, 0, 0.185), angle = Angle(0, 0, 0) },
	["RW_Weapon"] = { scale = Vector(0.052, 0.052, 0.052), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["LeftHandIndex1_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-0.339, 0, -1.017), angle = Angle(0, 0, 0) }
}


SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0,0,0)
SWEP.StunAng = Vector(-20.403, -7.035, 3.517)

SWEP.ShovePos = Vector(-5.64, -3.524, 0)
SWEP.ShoveAng = Vector(28.37, 62.907, -38.238)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(-33.065, 0, 0)

SWEP.ThrowPos = Vector(-3.451, -7.437, 3.42)
SWEP.ThrowAng = Vector(70, 1.406, -30.251)

SWEP.WhipPos = Vector(-3.451, -7.437, 3.42)
SWEP.WhipAng = Vector(70, 1.406, -30.251)

SWEP.FanPos = Vector(2.612, -5.628, -2.412)
SWEP.FanAng = Vector(36.583, 22.513, 28.141)

SWEP.WallPos = Vector(-0.601, -11.056, -9.65)
SWEP.WallAng = Vector(42.915, 0, 0)

function SWEP:AttackAnimation()
	self.Weapon.AttackAnimRate = 2
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing2.wav")	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end
left=false
right=true
function SWEP:AttackAnimation2()
	self.Weapon.AttackAnimRate = 1.5
	if right==true then  
		self.Punch1 = Angle(0, -15, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
		right=false
		left=true
	elseif left==true then
		self.Punch1 = Angle(5, 10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_HITLEFT )
		left=false
		right=true
	end
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing2.wav")
end
function SWEP:AttackAnimation3()
self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
self.Owner:EmitSound("weapons/stunstick/stunstick_swing2.wav")
end



SWEP.VElements = {
	["FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 7+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 9+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 11+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 13+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 15+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 17+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 19+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 21+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 23+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 25+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(7.5, 0, 26+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(6.5, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(4.5, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(2.5, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0.5, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(-1, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(-3, 0, 27+45-1), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(-3, 0, 27+45-3), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(-3, 0, 27+45-5), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(-3, 0, 27+45-7), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 5+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX+"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 3+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(8.5, 0, 1+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX+++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(7.25, 0, 0+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(6, 0, -1+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["b"] = { type = "Model", model = "models/red menace/fallenorder/props/purgetrooper/hammer.mdl", bone = "RW_Weapon", rel = "", pos = Vector(0.25, 0, -15), angle = Angle(2, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 7+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 9+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 11+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 13+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 15+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 17+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 19+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 21+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 23+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 25+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(7.5, 0, 26+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(6.5, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(4.5, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(2.5, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0.5, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(-1, 0, 27+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(-3, 0, 27+45-1), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(-3, 0, 27+45-3), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(-3, 0, 27+45-5), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++++++++++++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(-3, 0, 27+45-7), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 5+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX+"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 3+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(8.5, 0, 1+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX+++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(7.25, 0, 0+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["2FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(6, 0, -1+45), size = { x = 6, y = 6}, color = Color(150, 0, 255, 150), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["b"] = { type = "Model", model = "models/red menace/fallenorder/props/purgetrooper/hammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-4, -0.5, 20), angle = Angle(160, 180, -5), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}