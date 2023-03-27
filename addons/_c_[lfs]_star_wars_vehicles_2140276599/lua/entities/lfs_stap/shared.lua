ENT.Type = "anim"
DEFINE_BASECLASS( "heracles421_lfs_base" )

ENT.PrintName = "STAP"
ENT.Author = "dogger"
ENT.Category = "[LFS] Confederacy"

ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.RotorPos = Vector(0,0,0)

ENT.MDL = "models/stap/STAP.mdl"
ENT.GibModels = {
	"models/stap/STAP.mdl"
}

ENT.AITEAM = 2
ENT.MaxPrimaryAmmo = 1000

ENT.Mass = 2500

ENT.HideDriver = false

ENT.SeatPos = Vector(-32,0,47)
ENT.SeatAng = Angle(0,-90,5)

ENT.MaxHealth = 600
ENT.LevelForceMultiplier = 1000
ENT.LevelRotationMultiplier = 3
ENT.MoveSpeed = 750
ENT.BoostSpeed = 1000
ENT.TurnRateMultiplier = 3
ENT.HeightOffset = 20
ENT.MaxSecondaryAmmo = 200
ENT.CanMoveSideways = true
ENT.IgnoreWater = false
