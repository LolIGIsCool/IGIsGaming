--DO NOT EDIT OR REUPLOAD THIS FILE
ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Y-Wing"
ENT.Author = "chhhhh"
ENT.Information = "Y-Wing Starfighter. not a bomber"
ENT.Category = "[LFS] Rebellion"
ENT.Spawnable	 = true
ENT.AdminSpawnable	= false
ENT.MDL = "models/c_rf/Y-Wing.mdl"
ENT.GibModels = {
	"models/rebelfighter/ywing_gib_1.mdl",
	"models/rebelfighter/ywing_gib_2.mdl",
	"models/rebelfighter/ywing_gib_3.mdl",
}

ENT.AITEAM = 2

ENT.Mass = 6500
ENT.Inertia = Vector(650000,650000,650000)
ENT.Drag = 1

ENT.HideDriver = true
ENT.SeatPos = Vector(215,0,-9)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2500
ENT.LimitRPM = 2500
ENT.RPMThrottleIncrement = 1500

ENT.RotorPos = Vector(40,0,10)
ENT.WingPos = Vector(60,0,10)
ENT.ElevatorPos = Vector(-200,0,0)
ENT.RudderPos = Vector(-200,0,0)

ENT.MaxVelocity = 2000
ENT.MaxPerfVelocity = 3000

ENT.MaxThrust = 30000

ENT.MaxTurnPitch = 500
ENT.MaxTurnYaw = 400
ENT.MaxTurnRoll = 350

ENT.MaxHealth = 2250
ENT.MaxShield = 600

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.MaxThrustVtol = 8500

ENT.MaxPrimaryAmmo = 1650
ENT.MaxSecondaryAmmo = 12

sound.Add( {
	name = "engine_#777",
	channel = CHAN_STATIC,
	volume = 0.7,
	level = 120,
	pitch = { 95, 90 },
	sound = "lfs/ywing/engine_#777.wav"
} )

sound.Add( {
	name = "laser_#240",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 110,
	pitch = {0, 0},
	sound = {

"lfs/ywing/ywingfire7.wav",
"lfs/ywing/ywingfire8.wav",
"lfs/ywing/ywingfire9.wav",
"lfs/ywing/ywingfire10.wav",
"lfs/ywing/ywingfire11.wav",
"lfs/ywing/ywingfire12.wav",

	}
} )

sound.Add( {
	name = "torpedo_#1502",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 100,
	pitch = { 95, 110 },
	sound = "lfs/ywing/proton_#1502.wav"
} )

sound.Add( {
	name = "y_exp",
	channel = CHAN_STATIC,
	volume = 2,
	level = 140,
	pitch = { 0, 0 },
	sound = {
"lfs/ywing/y_exp.wav",
"lfs/ywing/y_exp2.wav",
"lfs/ywing/y_exp3.wav",



	}
} )

sound.Add( {
	name = "int_#12",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 120,
	pitch = { 95, 90 },
	sound = "lfs/ywing/int_#12.wav"
} )

sound.Add( {
	name = "laser_#561",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 110,
	pitch = { 0, 0 },
	sound = "lfs/ywing/laser_#561.wav"
} )
