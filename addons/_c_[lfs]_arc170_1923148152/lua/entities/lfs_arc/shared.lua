--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "ARC-170"
ENT.Author = "htog"
ENT.Information = ""
ENT.Category = "[LFS]"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.MDL = "models/sdog/arc170ch.mdl"
ENT.GibModels = {
	"models/salza/arc170_gib1.mdl",
	"models/salza/arc170_gib2.mdl",
	"models/salza/arc170_gib3.mdl",
	"models/salza/arc170_gib4.mdl",
	"models/salza/arc170_gib5.mdl",
	"models/salza/arc170_gib6.mdl"
}

ENT.AITEAM = 2

ENT.Mass = 5000
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.SeatPos = Vector(55,0,3.5)
ENT.SeatAng = Angle(0,-90,11)

ENT.IdleRPM = 1
ENT.MaxRPM = 2700
ENT.LimitRPM = 3300

ENT.RotorPos = Vector(220,0,10)
ENT.WingPos = Vector(100,0,10)
ENT.ElevatorPos = Vector(-200,0,0)
ENT.RudderPos = Vector(-200,0,0)

ENT.MaxVelocity = 2600

ENT.MaxThrust = 50000

ENT.MaxTurnPitch = 600
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 400

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 1700
ENT.MaxShield = 800

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 10
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1000
ENT.MaxSecondaryAmmo = 9

sound.Add( {
	name = "arclaz",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 105,
	pitch = {0, 0},
	sound = {
		"lfs/arc170ch/arcls1.wav",
		"lfs/arc170ch/arcls2.wav",
		"lfs/arc170ch/arcls3.wav",
		"lfs/arc170ch/arcls4.wav",
		"lfs/arc170ch/arcls5.wav",
		"lfs/arc170ch/arcls6.wav",
		"lfs/arc170ch/arcls7.wav",
		"lfs/arc170ch/arcls8.wav",
	}
} )

sound.Add( {
	name = "arctail",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 105,
	pitch = {0, 0},
	sound = {
		"lfs/arc170ch/arctail1.wav",
		"lfs/arc170ch/arctail2.wav",
		"lfs/arc170ch/arctail3.wav",
		"lfs/arc170ch/arctail4.wav",
		"lfs/arc170ch/arctail5.wav",
		"lfs/arc170ch/arctail6.wav",
	}
} )

sound.Add( {
	name = "tonnnn",
	channel = CHAN_STATIC,
	volume = 0.9,
	level = 110,
	sound = "lfs/arc170ch/arcton.wav"
} )

sound.Add( {
	name = "arcproton",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 105,
	sound = "lfs/arc170ch/arcproton.wav"
} )

sound.Add( {
	name = "tonnnn2",
	channel = CHAN_STATIC,
	volume = 0.9,
	level = 110,
	sound = "lfs/arc170ch/arcton2.wav"
} )

sound.Add( {
	name = "foilss",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 100,
	sound = "lfs/arc170ch/arcfoils.wav"
} )