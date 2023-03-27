--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Moonpool Turret"
ENT.Author = "Vanilla"
ENT.Information = ""
ENT.Category = "Vanilla"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/kingpommes/starwars/misc/turbolaser_seat_dummy.mdl"

ENT.AITEAM = 0

ENT.Mass = 5000
ENT.Inertia = Vector(600000,600000,600000)
ENT.Drag = 1

ENT.HideDriver = false
ENT.SeatPos = Vector(0,-55,23)
ENT.SeatAng = Angle(0,0,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2
ENT.LimitRPM = 2

ENT.RotorPos = Vector(0,0,50)
ENT.WingPos = Vector(0,0,20)
ENT.ElevatorPos = Vector(0,0,20)
ENT.RudderPos = Vector(0,0,20)

ENT.MaxVelocity = 10

ENT.MaxThrust = 10

ENT.MaxTurnPitch = 0
ENT.MaxTurnYaw = 0
ENT.MaxTurnRoll = 0

ENT.MaxPerfVelocity = 10

ENT.MaxHealth = 4000

ENT.Stability = 0.7

ENT.MaxPrimaryAmmo = 250

sound.Add( {
	name = "AV_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {65, 85},
	sound = "lfs/arc170/fire_gunner.mp3"
} )
