SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 3
SWEP.PrintName = "IC Commando Blade"
SWEP.Author = "Misahu"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Imperial Arts"
SWEP.SlotPos = 3
 
SWEP.Purpose = "For the proletariat"

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
SWEP.Speed=2 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=2 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="imperialarts_blade_iccomblade"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 1
SWEP.DmgMin = 40
SWEP.DmgMax = 100
SWEP.Delay = 0.4
SWEP.TimeToHit = 0.01
SWEP.AttackAnimRate = 0.5
SWEP.Range = 100
SWEP.Punch1 = Angle(-2, 0, 0)
SWEP.Punch2 = Angle(5, 0, -2)
SWEP.HitFX = "bloodsplat"
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.35
SWEP.DmgMin2 = 4
SWEP.DmgMax2 = 15
SWEP.ThrowModel = "models/vibrolame/w_models/w_bxdroid_vibrosword.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 1200
SWEP.FixedThrowAng = Angle(90,0,90)
SWEP.SpinAng = Vector(0,0,-1500)

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
SWEP.Hit1Sound="ambient/machines/slicer4.wav"
SWEP.Hit2Sound="ambient/machines/slicer3.wav"
SWEP.Hit3Sound="ambient/machines/slicer4.wav"

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
end
function SWEP:AttackAnimation2()
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
end
function SWEP:AttackAnimation3()
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
end


SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "smdimport", rel = "", pos = Vector(5.133, 0.298, -0.308), angle = Angle(1.452, -3.742, -93.755), size = Vector(0.4, 0.23, 0.02), color = Color(61, 61, 61, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["blade1"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.133, -0.198, -0.308), angle = Angle(1.452, -3.742, -93.755), size = Vector(0.4, 0.23, 0.02), color = Color(61, 61, 61, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["blade2"] = { type = "Model", model = "models/props_c17/canister_propane01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "blade1", pos = Vector(2.441, -0.002, 0), angle = Angle(-90, -180, 0), size = Vector(0.01, 0.05, 0.05), color = Color(0, 246, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["blade3"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "blade1", pos = Vector(2.1, 0, 0), angle = Angle(0, -45, 0), size = Vector(0.22, 0.22, 0.013), color = Color(0, 221, 255, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} },
	["blade4"] = { type = "Model", model = "models/hunter/blocks/cube025x025x025.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "blade1", pos = Vector(2.1, 0, 0), angle = Angle(0, -45, 0), size = Vector(0.2, 0.2, 0.02), color = Color(61, 61, 61, 255), surpresslightning = false, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}