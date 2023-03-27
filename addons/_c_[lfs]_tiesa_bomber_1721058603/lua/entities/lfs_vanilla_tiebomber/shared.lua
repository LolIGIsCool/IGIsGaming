
ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript" )

ENT.PrintName = "TIE/SA Bomber"
ENT.Author = "VanillaNekoNYAN"
ENT.Information = ""
ENT.Category = "[LFS] Empire" -- "[LFS] Vanilla"

ENT.Spawnable		= true -- set to "true" to make it spawnable
ENT.AdminSpawnable	= false

ENT.MDL = "models/vanilla/tiebomber/tiebomber.mdl" -- model forward direction must be facing to X+
--[[
ENT.GibModels = {
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
]]

ENT.AITEAM = 1 -- 0 = FFA  1 = bad guys  2 = good guys

ENT.Mass = 5000
ENT.Inertia = Vector(250000,250000,250000)
ENT.Drag = -1

ENT.SeatPos = Vector(72,-87.5,-30.6)
ENT.SeatAng = Angle(0,-90,0)

ENT.IdleRPM = 1
ENT.MaxRPM = 2500
ENT.LimitRPM = 3000

ENT.RotorPos = Vector(202.5,0,9)
ENT.WingPos = Vector(90,0,9)
ENT.ElevatorPos = Vector(-180,0,9)
ENT.RudderPos = Vector(-180,0,9)

ENT.MaxVelocity = 2000

ENT.MaxThrust = 48000

ENT.MaxTurnPitch = 300
ENT.MaxTurnYaw = 600
ENT.MaxTurnRoll = 300

ENT.MaxPerfVelocity = 1200

ENT.MaxHealth = 700
--ENT.MaxShield = 600

ENT.Stability = 0.7

ENT.VerticalTakeoff = true -- move vertically with landing gear out? REQUIRES ENT.Stability
ENT.VtolAllowInputBelowThrottle = 10 -- number is in % of throttle. Removes the landing gear dependency. Vtol mode will always be active when throttle is below this number. In this mode up movement is done with "Shift" key instead of W
ENT.MaxThrustVtol = 10000 -- amount of vertical thrust

ENT.MaxPrimaryAmmo = 1500   -- set to a positive number if you want to use weapons. set to -1 if you dont
ENT.MaxSecondaryAmmo = 35 -- set to a positive number if you want to use weapons. set to -1 if you dont

function ENT:AddDataTables() -- use this to add networkvariables instead of ENT:SetupDataTables().
	--[[DO NOT USE SLOTS SMALLER THAN 10]]--
end

util.PrecacheModel('models/vanilla/tiebomber/tiebomber_cockpit.mdl')

sound.Add( {
	name = "VANILLA_TIEBOMBER_HUM",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 125,
	sound = "vanilla/tiebomber/vanilla_tiebomber_roar1.wav"
} )

sound.Add( {
	name = "VANILLA_TIEBOMBER_ENGINE",
	channel = CHAN_STATIC,
	volume = 0.8,
	level = 80,
	sound = "vanilla/tiebomber/vanilla_tiebomber_engine1.wav"
} )

sound.Add( {
	name = "VANILLA_TIEBOMBER_FIRE",
	channel = CHAN_WEAPON,
	volume = 0.8,
	level = 125,
	pitch = {95, 98},
	sound = "vanilla/tiebomber/vanilla_tiebomber_fire1.wav"
} )
