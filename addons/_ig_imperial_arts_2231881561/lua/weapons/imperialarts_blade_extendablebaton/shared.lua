SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 3
SWEP.PrintName = "extendable baton"
SWEP.Author = "Misahu"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Imperial Arts"
SWEP.SlotPos = 3

SWEP.Purpose = "N"

SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_oren_katana.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true

--STAT RATING (1-6)
SWEP.Type=1 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=2 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=4 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=3 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="imperialarts_blade_extendablebaton"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 0.6
SWEP.DmgMin = 70
SWEP.DmgMax = 120
SWEP.Delay = 0.4
SWEP.TimeToHit = 0.08
SWEP.AttackAnimRate = 1.2
SWEP.Range = 70
SWEP.Punch1 = Angle(0, 5, 0)
SWEP.Punch2 = Angle(0, -5, 5)
SWEP.HitFX = "bloodsplat"
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.8
SWEP.DmgMin2 = 5
SWEP.DmgMax2 = 20
SWEP.ThrowModel = "models/models/danguyen/commandoknife.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 1200

--HOLDTYPES
SWEP.AttackHoldType="knife"
SWEP.Attack2HoldType="melee"
SWEP.ChargeHoldType="knife"
SWEP.IdleHoldType="knife"
SWEP.BlockHoldType="magic"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound="WeaponFrag.Throw"
SWEP.ThrowSound="weapons/iceaxe/iceaxe_swing1.wav"
SWEP.Hit1Sound="physics/body/body_medium_impact_hard1.wav"
SWEP.Hit2Sound="physics/body/body_medium_impact_hard2.wav"
SWEP.Hit3Sound="physics/body/body_medium_impact_hard3.wav"

SWEP.Impact1Sound="physics/metal/weapon_impact_hard1.wav"
SWEP.Impact2Sound="physics/metal/weapon_impact_hard2.wav"
SWEP.ViewModelBoneMods = {
	["TrueRoot"] = { scale = Vector(1, 1, 1), pos = Vector(0, 1.146, -1.147), angle = Angle(0,0,0) },
	["LeftArm_1stP"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 30, 30), angle = Angle(0, 0, 0) },
	["RW_Weapon"] = { scale = Vector(0.076, 0.076, 0.076), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["RightArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-1.668, 0, 0), angle = Angle(10, 0, 0) }
}


SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0,0,0)
SWEP.StunAng = Vector(-11.61, -3.415, 9.56)

SWEP.ShovePos = Vector(-1.951, -10.537, -3.708)
SWEP.ShoveAng = Vector(0, 47.805, -55.318)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(-33.065, 0, 0)

SWEP.WhipPos = Vector(0, -5.628, 0)
SWEP.WhipAng = Vector(33.769, 28.843, 31.658)

SWEP.ThrowPos = Vector(0,0,0)
SWEP.ThrowAng = Vector(40.101, -56.281, 19.697)

SWEP.FanPos = Vector(-11.461, -15.277, -3.02)
SWEP.FanAng = Vector(60.502, 8.442, -42.211)

SWEP.WallPos = Vector(-0.601, -11.056, -9.65)
SWEP.WallAng = Vector(42.915, 0, 0)

function SWEP:AttackAnimation()
self.Weapon:SendWeaponAnim( ACT_VM_HITLEFT )
end
function SWEP:AttackAnimation2()
self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
end
function SWEP:AttackAnimation3()
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
end


SWEP.VElements = {
	["knife"] = { type = "Model", model = "models/models/danguyen/w_haberdash_baton.mdl", bone = "RW_Weapon", rel = "", pos = Vector(20, -22, 14), angle = Angle(270, 0, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["knife"] = { type = "Model", model = "models/models/danguyen/w_haberdash_baton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(23,-22.5,5), angle = Angle(-75,0,0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
