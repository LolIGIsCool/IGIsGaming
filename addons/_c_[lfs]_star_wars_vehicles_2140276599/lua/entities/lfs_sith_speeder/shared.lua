ENT.Type = "anim"
DEFINE_BASECLASS( "heracles421_lfs_base" )

ENT.PrintName = "Bloodfin Speeder"
ENT.Author = "dogger"
ENT.Category = "[LFS] Other"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.RotorPos = Vector(30,0,40)

ENT.MDL = "models/sith_speeder/sith_speeder.mdl"
ENT.GibModels = {
	"models/sith_speeder/sith_speeder.mdl"
}

ENT.SeatPos = Vector(-29,1,18)
--ENT.SeatPos = Vector(-25,0,20)
ENT.SeatAng = Angle(0,-90,0)

ENT.MaxHealth = 1000
ENT.LevelForceMultiplier = 1000
ENT.LevelRotationMultiplier = 3
ENT.MoveSpeed = 700
ENT.BoostSpeed = 875
ENT.TurnRateMultiplier = 6
ENT.HeightOffset = 18
ENT.IgnoreWater = false
ENT.MaxPrimaryAmmo = 250
ENT.CanMoveSideways = false

sound.Add( {
	name = "SPEEDERBIKE_ENGINE",
	channel = CHAN_STATIC,
	volume = 3.0,
	level = 125,
	sound = "sith_speed.wav"
} )