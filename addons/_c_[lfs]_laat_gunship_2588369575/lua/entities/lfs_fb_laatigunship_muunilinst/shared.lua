ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_gunship" )

ENT.PrintName   = "LAAT/i Muunilinst"
ENT.Author      = "Fisher & !Ben"
ENT.Information = ""
ENT.Category    = "[LFS] - Star Wars Pack"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.UseLAATiBF2AnimHook = true

ENT.MDL = "models/fisher/laat/laatm10.mdl"

ENT.AITEAM = 2

ENT.Mass = 10000
ENT.Drag = 0

ENT.SeatPos = Vector(280, 0, 125)
ENT.SeatAng = Angle(0, -90, 0)

ENT.MaxHealth = 6000

ENT.MaxPrimaryAmmo = 1400
ENT.MaxSecondaryAmmo = 24
ENT.MaxThirdAmmo = 8
ENT.MaxDetonatorsAmmo = 12

ENT.MaxTurnPitch = 70
ENT.MaxTurnYaw = 70
ENT.MaxTurnRoll = 70

ENT.PitchDamping = 2
ENT.YawDamping = 2
ENT.RollDamping = 1

ENT.TurnForcePitch = 6000
ENT.TurnForceYaw = 6000
ENT.TurnForceRoll = 4000

ENT.RotorPos = Vector(210, 0, 130)

ENT.RPMThrottleIncrement = 225

ENT.MaxVelocity = 2800

ENT.MaxThrust = 5000

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 101
ENT.MaxThrustVtol = 700

function ENT:AddDataTables()
	self:NetworkVar( "Bool", 12, "Uncontrollable" )
	self:NetworkVar( "Bool", 13, "WingTurretFire" )
	self:NetworkVar( "Vector", 14, "WingTurretTarget" )
	self:NetworkVar( "Int", 15, "LampMode" )
	self:NetworkVar( "Bool", 16, "GXHairRG" )
	self:NetworkVar( "Bool", 17, "GXHairWT" )
	self:NetworkVar( "Entity", 18, "WingRocketTarget" )
	self:NetworkVar( "Int", 19, "TimeLock" )
	self:NetworkVar( "Int", 20, "AmmoThird", { KeyName = "thirdammo", Edit = { type = "Int", order = 5, min = 0, max = self.MaxThirdAmmo, category = "Weapons"} } )
	self:NetworkVar( "Int", 21, "AmmoDetonators", { KeyName = "detonatorsammo", Edit = { type = "Int", order = 5, min = 0, max = self.MaxDetonatorsAmmo, category = "Weapons"} } )
	self:NetworkVar( "Float", 22, "WingTurretHeat" )
	self:NetworkVar( "Entity", 23, "LoadMasterSeat" )
end

function ENT:GetMaxAmmoThird()
	return self.MaxThirdAmmo
end

function ENT:GetMaxAmmoDetonators()
	return self.MaxDetonatorsAmmo
end