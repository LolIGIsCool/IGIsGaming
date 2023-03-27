ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Slave I"
ENT.Author = "Jack"
ENT.Information = ""
ENT.Category = "[LFS] Other"

ENT.Spawnable		= true
ENT.AdminSpawnable		= true

ENT.MDL = "models/jackjack/ships/slave13p.mdl"

ENT.AITEAM = 1
ENT.Mass = 2000
ENT.Inertia = Vector(150000,150000,150000)
ENT.Drag = -1
ENT.HideDriver = false
ENT.SeatPos = Vector(135,0,46.5)
ENT.SeatAng = Angle(0,-90,0)
ENT.IdleRPM = 0
ENT.MaxRPM = 3000
ENT.LimitRPM = 3800
ENT.RotorPos = Vector(200,0,110)
ENT.WingPos = Vector(100,0,0)
ENT.ElevatorPos = Vector(-200,0,110)
ENT.RudderPos = Vector(-300,0,110)
ENT.MaxVelocity = 3550
ENT.MaxThrust = 22000
ENT.MaxTurnPitch = 1000
ENT.MaxTurnYaw = 1000
ENT.MaxTurnRoll = 400
ENT.MaxPerfVelocity = 4500
ENT.MaxHealth = 3000
ENT.MaxShield = 3000
ENT.Stability = 0.7
ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 10000
ENT.MaxPrimaryAmmo = 3000
ENT.MaxSecondaryAmmo = 400
sound.Add( {
	name = "SLAVE_ENG",
	channel = CHAN_STATIC,
	volume = 0.68,
	level = 125,
	sound = "^slave1/engine.wav"
} )
