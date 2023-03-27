ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "TIE/rp Reaper"
ENT.Author = "VANILLA!!!!!!!!!!!!!!!!"
ENT.Information = ""
ENT.Category = "[LFS] Empire"

ENT.Spawnable		= true -- set to "true" to make it spawnable
ENT.AdminSpawnable	= false

ENT.MDL = "models/squadrons/tie_reaper.mdl" -- model forward direction must be facing to X+

ENT.AITEAM = 1
--[[
TEAMS:
	0 = FRIENDLY TO EVERYONE
	1 = FRIENDLY TO TEAM 1 and 0
	2 = FRIENDLY TO TEAM 2 and 0
	3 = HOSTILE TO EVERYONE
]]

ENT.Mass = 750 -- lower this value if you encounter spazz
ENT.Inertia = Vector(700000,700000,700000) -- you must increase this when you increase mass or it will spazz
ENT.Drag = 1 -- drag is a good air brake but it will make diving speed worse

ENT.HideDriver = true -- hide the driver?
ENT.SeatPos = Vector(215,0,-20)
ENT.SeatAng = Angle(0,-90,-8)

ENT.IdleRPM = 0 -- idle rpm. this can be used to tweak the minimum flight speed
ENT.MaxRPM = 2500 -- rpm at 100% throttle
ENT.LimitRPM = 3400 -- max rpm when holding throttle key
ENT.RPMThrottleIncrement = 1000 -- how fast the RPM should increase/decrease per second

ENT.RotorPos = Vector(500,0,0) -- make sure you set these correctly or your plane will act wierd.
ENT.WingPos = Vector(0,0,100)
ENT.ElevatorPos = Vector(-600,0,100)
ENT.RudderPos = Vector(-600,0,100)

ENT.MaxVelocity = 4000 -- max theoretical velocity at 0 degree climb
--ENT.MaxPerfVelocity = 4000 -- speed in which the plane will have its maximum turning potential

ENT.MaxThrust = 5000 -- max power of rotor

ENT.MaxTurnPitch = 650 -- max turning force in pitch, lower this value if you encounter spazz
ENT.MaxTurnYaw = 650 -- max turning force in yaw, lower this value if you encounter spazz
ENT.MaxTurnRoll = 650 -- max turning force in roll, lower this value if you encounter spazz

ENT.MaxHealth = 8000
ENT.MaxShield = 2000  -- uncomment this if you want to use deflector shields. Dont use excessive amounts because it regenerates.

ENT.Stability = 1   -- if you uncomment this the plane will always be able to turn at maximum performance. This causes MaxPerfVelocity to get ignored
--ENT.MaxStability = 0.7 -- lower this value if you encounter spazz. You can increase this up to 1 to aid turning performance at MaxPerfVelocity-speeds but be careful

ENT.VerticalTakeoff = true -- move vertically with landing gear out? REQUIRES ENT.Stability
--ENT.VtolAllowInputBelowThrottle = 15 -- number is in % of throttle. Removes the landing gear dependency. Vtol mode will always be active when throttle is below this number. In this mode up movement is done with "Shift" key instead of W
ENT.MaxThrustVtol = 20000 -- amount of vertical thrust

ENT.MaxPrimaryAmmo = 2500   -- set to a positive number if you want to use weapons. set to -1 if you dont
ENT.MaxSecondaryAmmo = -1 -- set to a positive number if you want to use weapons. set to -1 if you dont

ENT.MaintenanceTime = 8 -- how many seconds it takes to perform a repair
ENT.MaintenanceRepairAmount = 250 -- how much health to restore

function ENT:AddDataTables() -- use this to add networkvariables instead of ENT:SetupDataTables().
	--[[DO NOT USE SLOTS SMALLER THAN 10]]--
end

sound.Add( {
	name = "TIER_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	sound = "niksacokica/tie_reaper/shoot.wav"
} )

sound.Add( {
	name = "TIER_STARTUP",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "niksacokica/tie_reaper/engine_start.wav"
} )

sound.Add( {
	name = "TIER_SHUTDOWN",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "niksacokica/tie_reaper/engine_stop.wav"
} )

sound.Add( {
	name = "TIER_ENGINE",
	channel = CHAN_STATIC,
	volume = 0.5,
	level = 120,
	sound = "niksacokica/tie_reaper/engine_loop.wav"
} )

sound.Add( {
	name = "TIER_GEAR",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "niksacokica/tie_reaper/gear.wav"
} )
