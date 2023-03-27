--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Kimogila Heavy Fighter"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category = "[LFS] Other"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sfp_kimogila/sfp_kimogila.mdl"

ENT.AITEAM = 2

ENT.Mass = 3000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(200,0,65)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2800
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(300,0,65)
ENT.WingPos = Vector(100,0,65)
ENT.ElevatorPos = Vector(-200,0,65)
ENT.RudderPos = Vector(-200,0,65)

ENT.MaxVelocity = 2630

ENT.MaxThrust = 28000

ENT.MaxTurnPitch = 400
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 350

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 1500
ENT.MaxShield = 0

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 12
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1500
ENT.MaxSecondaryAmmo = 16
