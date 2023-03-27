-- INSERT A COMMENT ABOUT NOT REUPLOADING THIS

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "X-Wing"
ENT.Author = "CH5"
ENT.Information = ""
ENT.Category = "[LFS] Rebellion"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.MDL = "models/min3r/X-Wing.mdl"

ENT.GibModels = {
	"models/min3r/gib1.mdl",
	"models/min3r/gib2.mdl",
	"models/min3r/gib3.mdl",
	"models/min3r/gib4.mdl",
	"models/min3r/gib5.mdl",
	"models/XQM/wingpiece2.mdl",
	"models/XQM/wingpiece2.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/XQM/jetwing2medium.mdl",
	"models/props_phx/misc/propeller3x_small.mdl",
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/XQM/jetbody2fuselage.mdl",
	"models/XQM/jettailpiece1medium.mdl",
	"models/XQM/pistontype1huge.mdl",
}

ENT.AITEAM = 2

ENT.Mass = 4500
ENT.Inertia = Vector(400000,400000,400000)
ENT.Drag = 1

ENT.SeatPos = Vector(9,3.3,-11)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2800
ENT.LimitRPM = 3200

ENT.RotorPos = Vector(220,0,10)
ENT.WingPos = Vector(100,0,10)
ENT.ElevatorPos = Vector(-200,0,10)
ENT.RudderPos = Vector(-200,0,10)

ENT.MaxVelocity = 2630

ENT.MaxThrust = 30000

ENT.MaxTurnPitch = 700
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 10

ENT.MaxHealth = 1800
ENT.MaxShield = 600

ENT.Stability = 0.7

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 40
ENT.MaxThrustVtol = 12000

ENT.MaxPrimaryAmmo = 1200
ENT.MaxSecondaryAmmo = 8

function ENT:AddDataTables()
	self:NetworkVar( "Bool",12, "WingsOPC" )
end

sound.Add( {
	name = "laz",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {0, 100},
	sound = {
"lfs/x-wing/xwingcannon7.wav",
"lfs/x-wing/xwingcannon8.wav",
"lfs/x-wing/xwingcannon9.wav",
"lfs/x-wing/xwingcannon10.wav",
"lfs/x-wing/xwingcannon11.wav",
"lfs/x-wing/xwingcannon12.wav",



	}
} )

sound.Add( {
	name = "x_exp",
	channel = CHAN_STATIC,
	volume = 2,
	level = 140,
	pitch = { 0, 0 },
	sound = {
"lfs/x-wing/x_exp.wav",
"lfs/x-wing/x_exp2.wav",
"lfs/x-wing/x_exp3.wav",



	}
} )

sound.Add( {
	name = "thor",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 100,
	pitch = { 95, 110 },
	sound = "lfs/x-wing/xwingprotonT.wav"
} )

sound.Add( {
	name = "intel",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 120,
	pitch = { 92, 90 },
	sound = "lfs/x-wing/x-interior.wav"
} )

sound.Add( {
	name = "engin",
	channel = CHAN_STATIC,
	volume = 0.7,
	level = 120,
	pitch = { 92, 90 },
	sound = "lfs/x-wing/xwingengine.wav"
} )

sound.Add( {
	name = "foilsopen",
	channel = CHAN_STATIC,
	volume = 0.7,
	level = 90,
	pitch = { 90, 90 },
	sound = "lfs/x-wing/xwingfoilsopen.wav"
} )

sound.Add( {
	name = "foilsclose",
	channel = CHAN_STATIC,
	volume = 0.7,
	level = 90,
	pitch = { 90, 90 },
	sound = "lfs/x-wing/xwingfoilsclose.wav"
} )
