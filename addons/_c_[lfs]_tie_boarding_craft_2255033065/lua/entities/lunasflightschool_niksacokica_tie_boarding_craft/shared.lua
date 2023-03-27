ENT.Type = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "TIE Boarding Craft"
ENT.Author = "niksacokica"
ENT.Information = ""
ENT.Category = "[LFS] Nick's ships"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.MDL = "models/niksacokica/tie_boarding_craft/tie_boarding_craft.mdl"

ENT.AITEAM = 2

ENT.Mass = 3300
ENT.Inertia = Vector(150000,150000,150000)
ENT.Drag = -1

ENT.HideDriver = true
ENT.SeatPos = Vector(85,61,-33)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2500
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(0,61,0)
ENT.WingPos = Vector(100,61,0)
ENT.ElevatorPos = Vector(-300,61,0)
ENT.RudderPos = Vector(-300,61,0)

ENT.MaxVelocity = 2222
ENT.MaxPerfVelocity = 1111

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 750
ENT.MaxTurnYaw = 750
ENT.MaxTurnRoll = 333

ENT.MaxHealth = 1500
ENT.MaxShield = 500

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1000
ENT.MaxSecondaryAmmo = 500