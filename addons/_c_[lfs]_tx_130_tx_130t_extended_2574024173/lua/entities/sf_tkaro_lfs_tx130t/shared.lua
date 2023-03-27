--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE

ENT.Type            = "anim"
DEFINE_BASECLASS( "lunasflightschool_basescript_gunship" )

ENT.PrintName = "TX-130 & TX-130t"
ENT.Author = "Tkaro"
ENT.Information = "Republic Fighter Tank"
ENT.Category = "[LFS] Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/tkaro/starwars/vehicle/tx130/tx130.mdl"

ENT.GibModels = {
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_charge_gib.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_flap_gib.mdl",
    "models/tkaro/starwars/vehicle/tx130/gibs/tx130_hatch_gib.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_main_gib.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_sidegun_gib_1.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_sidegun_gib_2.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_model_turret_gib.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_wing_gib_1.mdl",
	"models/tkaro/starwars/vehicle/tx130/gibs/tx130_wing_gib_2.mdl",
}

ENT.MaxPrimaryAmmo = 1500
ENT.MaxSecondaryAmmo = 20

ENT.AITEAM = 2

ENT.Mass = 2500

ENT.HideDriver = false
ENT.SeatPos = Vector(-68,27,18)
--ENT.SeatPos = Vector(-25,0,20)
ENT.SeatAng = Angle(0,-90,15)

ENT.MaxHealth = 6969

ENT.MaxTurnPitch = 1000
ENT.MaxTurnYaw = 80
ENT.MaxTurnRoll = 1000

ENT.PitchDamping = 1
ENT.YawDamping = 1.5
ENT.RollDamping = 1

ENT.TurnForcePitch = 25
ENT.TurnForceYaw = 800
ENT.TurnForceRoll = 25

ENT.RotorPos = Vector(-120,0,30)

ENT.IdleRPM = 0
ENT.MaxRPM = 100
ENT.LimitRPM = 100
ENT.RPMThrottleIncrement = 250

ENT.MaxVelocity = 400
ENT.BoostVelAdd = 100
ENT.ThrustMul = 5
ENT.DampingMul = 1

ENT.DontPushMePlease = true

ENT.LAATC_PICKUPABLE = true
ENT.LAATC_PICKUP_POS = Vector(-200,0,30)
ENT.LAATC_PICKUP_Angle = Angle(0,0,0)

ENT.MaintenanceTime = 20
ENT.MaintenanceRepairAmount = 750

ENT.UseTX130_t_AnimHook = true

function ENT:AddDataTables()
	self:NetworkVar( "Int",18, "DoorMode" )

	self:NetworkVar( "Bool",19, "BTLFire" )
	self:NetworkVar( "Bool",20, "IsCarried" )
	self:NetworkVar( "Bool",21, "RearHatch" )
	self:NetworkVar( "Bool",22, "WeaponOutOfRange" )
	self:NetworkVar( "Bool",23, "FrontInRange" )

	if SERVER then
		self:NetworkVarNotify( "IsCarried", self.OnIsCarried )
	end
end

sound.Add( {
	name = "TX_FIRE",
	channel = CHAN_WEAPON,
	volume = 0.6,
	level = 125,
	pitch = {95, 105},
	sound = "lfs/tx130/twincannonlaser.wav"
} )

sound.Add( {
	name = "TX_ENGINE",
	channel = CHAN_STATIC,
	volume = 1.1,
	level = 120,
	sound = "lfs/tx130/engine.wav"
} )

sound.Add( {
	name = "TX_ENGINE_IN",
	channel = CHAN_STATIC,
	volume = 1,
	level = 90,
	sound = "lfs/tx130/interior.wav"
} )

sound.Add( {
	name = "TX_ROCKET",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "lfs/tx130/rocket.wav"
} )

sound.Add( {
	name = "TX_ROCKETPODS_RAISE",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "lfs/tx130/rocketpods_raise.wav"
} )

sound.Add( {
	name = "TX_ROCKETPODS_LOWER",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "lfs/tx130/rocketpods_lower.wav"
} )

sound.Add( {
	name = "TX_DIST",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 110,
	sound = "lfs/tx130/dist.wav"
} )

sound.Add( {
	name = "TX_TWINCANNON_ACTIVATE",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "lfs/tx130/twincannon_activate.wav"
} )

sound.Add( {
	name = "TX_TWINCANNON_DEACTIVATE",
	channel = CHAN_ITEM,
	volume = 1.0,
	level = 90,
	pitch = 100,
	sound = "lfs/tx130/twincannon_deactivate.wav"
} )

hook.Add("CalcMainActivity", "!!!lfs_tx130_t_passengeranims", function(ply)
	if not ply.lfsGetPlane then return end
	
	local Ent = ply:lfsGetPlane()
	
	if not IsValid( Ent ) then return end
	if not Ent.UseTX130_t_AnimHook then return end
	
	local Pod = ply:GetVehicle()
	
	if Pod == Ent:GetGunnerSeat() then
	
	if ply.m_bWasNoclipping then 
		ply.m_bWasNoclipping = nil 
		ply:AnimResetGestureSlot( GESTURE_SLOT_CUSTOM ) 
		
		if CLIENT then 
			ply:SetIK( true )
		end 
	end 
	
	ply.CalcIdeal = ACT_STAND
	ply.CalcSeqOverride = ply:LookupSequence( "idle_all_02" )

	if ply:GetAllowWeaponsInVehicle() and IsValid( ply:GetActiveWeapon() ) then
		
		local holdtype = ply:GetActiveWeapon():GetHoldType()
		
		if holdtype == "smg" then 
			holdtype = "smg1"
		end

		local seqid = ply:LookupSequence( "idle_" .. holdtype )
		
		if seqid ~= -1 then
			ply.CalcSeqOverride = seqid
		end
	end

	return ply.CalcIdeal, ply.CalcSeqOverride
	end
end)