--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "M3-A Scyk"
ENT.Author = "Nashatok"
ENT.Information = ""
ENT.Category =  "[LFS] Other" -- "[LFS] Vanilla"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/sfp_scyk/sfp_scyk.mdl"

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(100,0,90)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2300
ENT.LimitRPM = 3500

ENT.RotorPos = Vector(100,0,60)
ENT.WingPos = Vector(50,0,60)
ENT.ElevatorPos = Vector(-250,0,60)
ENT.RudderPos = Vector(-250,0,60)

ENT.MaxVelocity = 3000

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 700
ENT.MaxTurnYaw = 800
ENT.MaxTurnRoll = 600

ENT.MaxPerfVelocity = 2300

ENT.MaxHealth = 1200
ENT.MaxShield = 600

ENT.Stability = 0.6

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1500


sound.Add( {
	name = "SCYK_FIRE",
	channel = CHAN_STREAM,
	volume = 1.0,
	level = 125,
	pitch = {85, 95},
	sound = "lfs/speeder_shoot.wav"
} )
