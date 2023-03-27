ENT.Type = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_gunship" )

ENT.PrintName = "K79-S80"
ENT.Author = "niksacokica"
ENT.Information = ""
ENT.Category = "[LFS] Empire" -- "[LFS] Nick's ships"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.MDL = "models/niksacokica/jfO_vehicles/k79-s80.mdl"

ENT.AITEAM = 2

ENT.Mass = 2000

ENT.HideDriver = true
ENT.SeatPos = Vector(171,0,7)
ENT.SeatAng = Angle(0,-90,0)

ENT.LAATC_PICKUPABLE = true
ENT.LAATC_PICKUP_POS = Vector(-200,0,66)
ENT.LAATC_PICKUP_Angle = Angle(0,0,0)

ENT.MaxHealth = 13000 -- Default 1000
ENT.MaxPrimaryAmmo = 1000

ENT.MaxTurnPitch = 1000
ENT.MaxTurnYaw = 80
ENT.MaxTurnRoll = 1000

ENT.PitchDamping = 1
ENT.YawDamping = 1.5
ENT.RollDamping = 1

ENT.TurnForcePitch = 25
ENT.TurnForceYaw = 800
ENT.TurnForceRoll = 25

ENT.RotorPos = Vector(0,0,0)

ENT.IdleRPM = 0
ENT.MaxRPM = 150
ENT.LimitRPM = 175
ENT.RPMThrottleIncrement = 250

ENT.MaxVelocity = 600
ENT.BoostVelAdd = 200
ENT.ThrustMul = 5
ENT.DampingMul = 1

ENT.DontPushMePlease = true