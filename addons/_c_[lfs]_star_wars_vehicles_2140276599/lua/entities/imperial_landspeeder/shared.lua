ENT.Type = "anim"
DEFINE_BASECLASS( "heracles421_lfs_base" )

ENT.PrintName = "Imperial Speeder"
ENT.Author = "dogger"
ENT.Category = "[LFS] Empire"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.RotorPos = Vector(0,0,0)

ENT.MDL = "models/imp_speeder/AV211.mdl"
ENT.GibModels = {
	"models/imp_speeder/AV211.mdl"
}

ENT.SeatPos = Vector(-21,-15,14)
--ENT.SeatPos = Vector(-25,0,20)
ENT.SeatAng = Angle(0,-90,22)

ENT.MaxHealth = 1300
ENT.LevelForceMultiplier = 1000
ENT.LevelRotationMultiplier = 3
ENT.MoveSpeed = 700
ENT.BoostSpeed = 875
ENT.TurnRateMultiplier = 6
ENT.HeightOffset = 18
ENT.IgnoreWater = false

sound.Add( {
	name = "LANDSPEEDER_ENGINE",
	channel = CHAN_STATIC,
	volume = 3,
	level = 120,
	sound = "imperial_speeding.wav"
} )