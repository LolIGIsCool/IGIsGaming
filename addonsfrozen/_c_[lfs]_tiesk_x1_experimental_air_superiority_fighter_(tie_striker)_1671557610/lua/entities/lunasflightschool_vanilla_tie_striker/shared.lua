ENT.Type = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )
ENT.PrintName = "TIE/sk x1 Experimental Air Superiority Fighter"
ENT.Author = "VanillaNekoNYAN"
ENT.Category = "[LFS] Empire" -- "[LFS] Vanilla"
ENT.Spawnable = true
ENT.AdminSpawnable=false
ENT.MDL="models/starwars/syphadias/ships/tie_striker/tie_striker_up.mdl"
ENT.AITEAM=1
ENT.Mass=2000
ENT.Inertia=Vector(150000,150000,150000)
ENT.Drag=-1
ENT.SeatPos=Vector(67,0,43)
ENT.SeatAng=Angle(0,0,0)
ENT.IdleRPM=1
ENT.MaxRPM=5000
ENT.LimitRPM=6500
ENT.RPMThrottleIncrement = 400
ENT.RotorPos=Vector(0,0,0)
ENT.WingPos=Vector(100,0,0)
ENT.ElevatorPos=Vector(-300,0,0)
ENT.RudderPos=Vector(-300,0,0)
ENT.MaxVelocity=3000
ENT.MaxPerfVelocity=3200
ENT.MaxThrust=25000
ENT.MaxTurnPitch=600
ENT.MaxTurnYaw=100
ENT.MaxTurnRoll=300
ENT.MaxHealth=2000
ENT.Stability=0.7
ENT.MaxPrimaryAmmo=5000
ENT.MaxSecondaryAmmo=-1
sound.Add( {
	name = "TIE_FIRES",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = {
		"vanilla/striker/s_fire1.wav",
		"vanilla/striker/s_fire2.wav"
	}	
} )
sound.Add( {
	name = "TIE_HUM",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "vanilla/striker/s_hum.wav"
} )