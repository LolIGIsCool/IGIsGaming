ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_gunship" )

ENT.PrintName   = "LAAT/i"
ENT.Author      = "Fisher & !Ben"
ENT.Information = ""
ENT.Category    = "[LFS] - Star Wars Pack"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.UseLAATiBF2AnimHook = true

ENT.MDL = "models/fisher/laat/laat.mdl"

ENT.AITEAM = 2

ENT.Mass = 10000
ENT.Drag = 0

ENT.SeatPos = Vector(280, 0, 125)
ENT.SeatAng = Angle(0, -90, 0)

ENT.MaxHealth = 6000

ENT.MaxPrimaryAmmo = 1400
ENT.MaxSecondaryAmmo = 24
ENT.MaxThirdAmmo = 8

ENT.MaxTurnPitch = 70
ENT.MaxTurnYaw = 70
ENT.MaxTurnRoll = 70

ENT.PitchDamping = 2
ENT.YawDamping = 2
ENT.RollDamping = 1

ENT.TurnForcePitch = 6000
ENT.TurnForceYaw = 6000
ENT.TurnForceRoll = 4000

ENT.RotorPos = Vector(210, 0, 130)

ENT.RPMThrottleIncrement = 180

ENT.MaxVelocity = 2400

ENT.MaxThrust = 5000

ENT.VerticalTakeoff = true
ENT.VtolAllowInputBelowThrottle = 101
ENT.MaxThrustVtol = 600

function ENT:AddDataTables()
	self:NetworkVar( "Bool", 12, "Uncontrollable" )
	self:NetworkVar( "Bool", 13, "WingTurretFire" )
	self:NetworkVar( "Vector", 14, "WingTurretTarget" )
	self:NetworkVar( "Entity", 15, "BTPodL" )
	self:NetworkVar( "Entity", 16, "BTPodR" )
	self:NetworkVar( "Entity", 17, "BTGunnerL" )
	self:NetworkVar( "Entity", 18, "BTGunnerR" )
	self:NetworkVar( "Bool", 19, "BTLFire" )
	self:NetworkVar( "Bool", 20, "BTRFire" )
	self:NetworkVar( "Int", 21, "LampMode" )
	self:NetworkVar( "Bool", 22, "GXHairRG" )
	self:NetworkVar( "Bool", 23, "GXHairWT" )
	self:NetworkVar( "Entity", 24, "WingRocketTarget" )
	self:NetworkVar( "Int", 25, "TimeLock" )
	self:NetworkVar( "Int", 26, "AmmoThird", { KeyName = "thirdammo", Edit = { type = "Int", order = 5, min = 0, max = self.MaxThirdAmmo, category = "Weapons"} } )
	self:NetworkVar( "Float", 28, "WingTurretHeat" )
	self:NetworkVar( "Entity", 29, "LoadMasterSeat" )
	self:NetworkVar( "Float", 30, "BallTurretLHeat" )
	self:NetworkVar( "Float", 31, "BallTurretRHeat" )
end

function ENT:GetMaxAmmoThird()
	return self.MaxThirdAmmo
end

sound.Add( {
	name = "LAAT_BT_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = {90, 110},
	sound = "laat_bf2/ballturret_fire.mp3"
} )

sound.Add( {
	name = "LAAT_BT_FIRE_LOOP_CHAN1",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 100,
	sound = "laat_bf2/ballturret_loop.wav"
} )

sound.Add( {
	name = "LAAT_BT_FIRE_LOOP_CHAN2",
	channel = CHAN_VOICE2,
	volume = 1.0,
	level = 100,
	sound = "laat_bf2/ballturret_loop.wav"
} )

sound.Add( {
	name = "LAAT_BT_FIRE_LOOP_CHAN3",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 100,
	sound = "laat_bf2/ballturret_loop.wav"
} )

sound.Add( {
	name = "LAAT_TAKEOFF",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = {"^laat_bf2/takeoff_1.wav","^laat_bf2/takeoff_2.wav"}
} )

sound.Add( {
	name = "LAAT_BOOST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = {"^laat_bf2/boost_1.wav","^laat_bf2/boost_2.wav"}
} )

sound.Add( {
	name = "LAAT_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^laat_bf2/engine_loop.mp3"
} )

sound.Add( {
	name = "LAAT_ENGINE_START",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 75,
	sound = "laat_bf2/engine_start.mp3"
} )

sound.Add( {
	name = "LAAT_ENGINE_STOP",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 75,
	sound = "laat_bf2/engine_end.mp3"
} )

sound.Add( {
	name = "LAAT_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^laat_bf2/engine_loop.mp3"
} )

sound.Add( {
	name = "LAAT_FIREMISSILE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "laat_bf2/rocket_shot.mp3"
} )

sound.Add( {
	name = "LAAT_FIRE",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 125,
	pitch = {95, 105},
	sound = "laat_bf2/cannon_shot.mp3"
} )

sound.Add( {
	name = "LAAT_LANDING",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "^laat_bf2/landing.mp3"
} )

sound.Add( {
	name = "LAAT_LOCK_ON",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "laat_bf2/lock_on_beep.mp3"
} )

sound.Add( {
	name = "LAAT_HATCH",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "laat_bf2/ramp.mp3"
} )

hook.Add("CalcMainActivity", "!!!lfs_fb_LAATi_passengeranims", function(ply)
	if not ply.lfsGetPlane then return end
	
	local Ent = ply:lfsGetPlane()
	if not IsValid(Ent) then return end
	if not Ent.UseLAATiBF2AnimHook then return end
	
	local Pod = ply:GetVehicle()
	if Pod == Ent:GetDriverSeat() or Pod == Ent:GetGunnerSeat() or (Ent.GetBTPodL && Pod == Ent:GetBTPodL()) or (Ent.GetBTPodR && Pod == Ent:GetBTPodR()) then return end

	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM) 
		
		if CLIENT then 
			ply:SetIK(true)
		end 
	end 
	
	ply.CalcIdeal = ACT_STAND
	ply.CalcSeqOverride = ply:LookupSequence("idle_all_02")

	if ply:GetAllowWeaponsInVehicle() and IsValid(ply:GetActiveWeapon()) then
		local holdtype = ply:GetActiveWeapon():GetHoldType()
		if holdtype == "smg" then 
			holdtype = "smg1"
		end

		local seqid = ply:LookupSequence("idle_" .. holdtype)
		if seqid ~= -1 then
			ply.CalcSeqOverride = seqid
		end
	end

	return ply.CalcIdeal, ply.CalcSeqOverride
end)