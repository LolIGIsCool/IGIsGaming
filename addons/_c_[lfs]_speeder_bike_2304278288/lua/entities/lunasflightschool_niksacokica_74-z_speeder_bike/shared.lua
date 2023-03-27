ENT.Type = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_gunship" )

ENT.PrintName = "74-Z"
ENT.Author = "niksacokica"
ENT.Category = "[LFS] Empire"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.RotorPos = Vector(0,0,0)

ENT.MDL = "models/niksacokica/74-z_speeder_bike/74-z_speeder_bike.mdl"

ENT.AITEAM = 2
ENT.MaxPrimaryAmmo = 1000

ENT.Mass = 250

ENT.HideDriver = true

ENT.SeatPos = Vector(-37,0,6)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxTurnPitch = 1000
ENT.MaxTurnYaw = 1000
ENT.MaxTurnRoll = 1000

ENT.PitchDamping = 1
ENT.YawDamping = 1.5
ENT.RollDamping = 1

ENT.TurnForcePitch = 100
ENT.TurnForceYaw = 800
ENT.TurnForceRoll = 100

ENT.RotorPos = Vector(0,0,0)

ENT.IdleRPM = 0
ENT.MaxRPM = 250
ENT.LimitRPM = 333
ENT.RPMThrottleIncrement = 250

ENT.MaxVelocity = 1500
ENT.BoostVelAdd = 250
ENT.ThrustMul = 5
ENT.DampingMul = 1

ENT.DontPushMePlease = true