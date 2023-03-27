--NO U

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "A-Wing"
ENT.Author = "Digger"
ENT.Information = ""
ENT.Category = "[LFS] Rebellion" -- "[LFS] Vanilla"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/DiggerThings/AWing/awing3.mdl"
ENT.GibModels = {
	"models/DiggerThings/AWing/gib1.mdl",
	"models/DiggerThings/AWing/gib2.mdl",
	"models/DiggerThings/AWing/gib3.mdl",
	"models/DiggerThings/AWing/gib4.mdl",
	"models/DiggerThings/AWing/gib5.mdl",
	"models/DiggerThings/AWing/gib6.mdl"
}

ENT.AITEAM = 2

ENT.Mass = 2000
ENT.Inertia = Vector(150000,150000,150000)
ENT.Drag = -1

ENT.SeatPos = Vector(-20,0,0)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2800
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(40,0,0)
ENT.WingPos = Vector(100,0,0)
ENT.ElevatorPos = Vector(-300,0,0)
ENT.RudderPos = Vector(-300,0,0)

ENT.MaxVelocity = 3000

ENT.MaxThrust = 28000

ENT.MaxTurnPitch = 800 -- max turning force in pitch, lower this value if you encounter spazz
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 1200
ENT.MaxShield = 300

ENT.Stability = 0.7

ENT.MaxPrimaryAmmo = 1500
ENT.MaxSecondaryAmmo = 100

sound.Add( {
	name = "AWING_FIRE",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/awing/wpn_jediStrftr_blaster_fire.wav"
} )

sound.Add( {
	name = "AWING_FIRE2",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/awing/wpn_xwing_blaster_fire.wav"
} )

sound.Add( {
	name = "AWING_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/awing/eng_jedistarfighter_hi_lp.wav"
} )

sound.Add( {
	name = "AWING_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/awing/eng_jedistarfighter_mid_lp.wav"
} )

sound.Add( {
	name = "AWING_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/awing/a_wing_by_1.wav"
} )

sound.Add( {
	name = "AWING_BRAKE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/awing/a_wing_by_2.wav"
} )
