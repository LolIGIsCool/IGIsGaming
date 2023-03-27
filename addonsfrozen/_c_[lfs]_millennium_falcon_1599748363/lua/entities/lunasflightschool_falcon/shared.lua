--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "Millennium Falcon"
ENT.Author = "Salza"
ENT.Information = ""
ENT.Category = "[LFS-Salza]"

ENT.Spawnable		= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/salza/millennium_falcon.mdl"
ENT.GibModels = {
	"models/salza/falcon_gib1.mdl",
	"models/salza/falcon_gib2.mdl",
	"models/salza/falcon_gib3.mdl",
	"models/salza/falcon_gib4.mdl",
	"models/salza/falcon_gib5.mdl",
	"models/salza/falcon_gib6.mdl",
}

ENT.AITEAM = 2

ENT.Mass = 8000
ENT.Inertia = Vector(500000,500000,500000)
ENT.Drag = 1

ENT.SeatPos = Vector(405,-435,0)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 1500
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(405,0,0)
ENT.WingPos = Vector(100,0,0)
ENT.ElevatorPos = Vector(-80,0,0)
ENT.RudderPos = Vector(-200,0,0)

ENT.MaxVelocity = 4500

ENT.MaxThrust = 80000

ENT.MaxTurnPitch = 400
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 400

ENT.MaxPerfVelocity = 1500

ENT.MaxHealth = 3000
ENT.MaxShield = 3000

ENT.Stability = 0.9

ENT.MaxPrimaryAmmo = 2000
ENT.MaxSecondaryAmmo = -1

ENT.VerticalTakeoff = true

function ENT:AddDataTables()
	self:NetworkVar( "Entity",20, "LowerGunnerSeat" )
end

sound.Add( {
	name = "MFALCON_FIRE_LOOP",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/mfalcon/fireloop.wav"
} )

sound.Add( {
	name = "MFALCON_FIRE_LASTSHOT",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 90,
	sound = "lfs/mfalcon/lastshot.wav"
} )

sound.Add( {
	name = "MFALCON_DIST_B",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	sound = "^lfs/mfalcon/dist_rear.wav"
} )

sound.Add( {
	name = "MFALCON_DIST_A",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 110,
	sound = "^lfs/mfalcon/dist_front.wav"
} )

sound.Add( {
	name = "MFALCON_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/mfalcon/boost.wav"
} )

sound.Add( {
	name = "MFALCON_BRAKE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/mfalcon/brake.wav"
} )