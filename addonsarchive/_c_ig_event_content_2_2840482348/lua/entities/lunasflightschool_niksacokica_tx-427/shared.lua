ENT.Type = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_gunship" )

ENT.PrintName = "TX-427"
ENT.Author = "niksacokica, deno and some_stranger"
ENT.Category = "[LFS] Orbital Vehicles"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.MDL = "models/lfs_vehicles/tx427/tx427_static.mdl"
ENT.GibModels = {
	"models/lfs_vehicles/tx427/gibs/tx427_barrel.mdl",
	"models/lfs_vehicles/tx427/gibs/tx427_blaster.mdl",
	"models/lfs_vehicles/tx427/gibs/tx427_blaster.mdl",
	"models/lfs_vehicles/tx427/gibs/tx427_body.mdl",
	"models/lfs_vehicles/tx427/gibs/tx427_cannon.mdl",
	"models/lfs_vehicles/tx427/gibs/tx427_missiles.mdl",
	"models/lfs_vehicles/tx427/gibs/tx427_missiles.mdl"
}

ENT.AITEAM = 2

ENT.Mass = 1000

ENT.HideDriver = true
ENT.SeatPos = Vector(20,25,35)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxHealth = 2500
ENT.MaxShield = 500

ENT.MaxTurnPitch = 1000
ENT.MaxTurnYaw = 80
ENT.MaxTurnRoll = 1000

ENT.PitchDamping = 1
ENT.YawDamping = 1.5
ENT.RollDamping = 1

ENT.TurnForcePitch = 25
ENT.TurnForceYaw = 800
ENT.TurnForceRoll = 25

ENT.RotorPos = Vector(-130, 0, 100)

ENT.IdleRPM = 0
ENT.MaxRPM = 100
ENT.LimitRPM = 100
ENT.RPMThrottleIncrement = 250

ENT.MaxVelocity = 400
ENT.BoostVelAdd = 40
ENT.ThrustMul = 5
ENT.DampingMul = 1

ENT.LAATC_PICKUPABLE = true
ENT.LAATC_PICKUP_POS = Vector(-260,0,0)
ENT.LAATC_PICKUP_Angle = Angle(0,0,0)

ENT.DontPushMePlease = true
function ENT:AddDataTables()
	self:NetworkVar( "Entity", 5, "MainGunner" )
	self:NetworkVar( "Entity", 6, "CoDriver" )
	
	self:NetworkVar( "Bool", 20, "IsCarried" )
	
	if SERVER then
		self:NetworkVarNotify( "IsCarried", self.OnIsCarried )
	end
end