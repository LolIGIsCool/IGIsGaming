SWEP.Gun							= ("rw_sw_e11")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "TFA StarWars First Order"
SWEP.Manufacturer 					= ""
SWEP.Author							= "Aiko"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Handcuff E-44"
SWEP.Type							= "Handcuff First Order Light Blaster Rifle"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= 1
SWEP.Secondary.IronFOV				= 75
SWEP.Slot							= 1
SWEP.SlotPos						= 100

SWEP.FiresUnderwater 				= true

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= true
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "Automatic"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 20
SWEP.Primary.DefaultClip			= 1
SWEP.Primary.RPM					= 300
SWEP.Primary.RPM_Burst				= 300
SWEP.Primary.Ammo					= "battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 5
SWEP.Primary.RangeFalloff 			= 0
SWEP.Primary.NumShots				= 1
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("w/e44.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/pistols.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 2
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= nil

SWEP.DoMuzzleFlash 					= false

SWEP.FireModes = {
	"Automatic",
	"Single"
}


SWEP.IronRecoilMultiplier			= 1
SWEP.CrouchRecoilMultiplier			= 1
SWEP.JumpRecoilMultiplier			= 1
SWEP.WallRecoilMultiplier			= 1
SWEP.ChangeStateRecoilMultiplier	= 1
SWEP.CrouchAccuracyMultiplier		= 1
SWEP.ChangeStateAccuracyMultiplier	= 1
SWEP.JumpAccuracyMultiplier			= 1
SWEP.WalkAccuracyMultiplier			= 1
SWEP.NearWallTime 					= 1
SWEP.ToCrouchTime 					= 1
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= 9

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/bf2017/c_e11.mdl"
SWEP.WorldModel						= "models/bf2017/w_e11.mdl"
SWEP.ViewModelFOV					= 60
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "smg"
SWEP.ReloadHoldTypeOverride 		= "smg"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= true
SWEP.BlowbackVector 				= Vector(0,-1.5,-0.05)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= true
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= "rw_sw_laser_yellow"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_aqua"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(2.01, -02, -0.545)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.2
SWEP.Primary.KickUp					= 0
SWEP.Primary.KickDown				= 0
SWEP.Primary.KickHorizontal			= 0
SWEP.Primary.StaticRecoilFactor 	= 0
SWEP.Primary.Spread					= 0.01
SWEP.Primary.IronAccuracy 			= 0.01
SWEP.Primary.SpreadMultiplierMax 	= 0
SWEP.Primary.SpreadIncrement 		= 0
SWEP.Primary.SpreadRecovery 		= 0
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1.1
SWEP.IronSightsMoveSpeed 			= 0.9

SWEP.IronSightsPos = Vector(-4.9, -8, 3.925)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-3, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["e44"] = { type = "Model", model = "models/kuro/sw_battlefront/weapons/bf1/e44.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(-1.5, 2, -4.5), angle = Angle(0, -90, 0), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["scope1"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_e11_reference001", rel = "e44", pos = Vector(1.1, 0, 10.03), angle = Angle(0, 180, 0), size = Vector(0.27, 0.27, 0.27), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} },
	["scope2"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_e11_reference001", rel = "e44", pos = Vector(4.5, 2.06, 7.86), angle = Angle(0, 180, 0), size = Vector(0.27, 0.27, 0.27), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} },
	["scope3"] = { type = "Model", model = "models/rtcircle.mdl", bone = "v_e11_reference001", rel = "e44", pos = Vector(4.5, -2.06, 7.86), angle = Angle(0, 180, 0), size = Vector(0.27, 0.27, 0.27), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} },
	["trd"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "v_e11_reference001", rel = "e44", pos = Vector(4.5, -2.05, 7.87), angle = Angle(90, -5, 6), size = Vector(0.010, 0.010, 0.010), color = Color(255, 120, 0, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["e44"] = { type = "Model", model = "models/kuro/sw_battlefront/weapons/bf1/e44.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6, 0.75, 1.75), angle = Angle(-11, 0, 180), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

DEFINE_BASECLASS( SWEP.Base )


local MaxTimer				= 12
local CurrentTimer			= 0

function SWEP:Think()

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and SERVER then
		if (CurrentTimer >= MaxTimer) then 
			CurrentTimer = 0
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		else
			CurrentTimer = CurrentTimer + 2
		end
	end

	if( self.Weapon:Clip1() <= 10 ) then 
		self.VElements["trd"].color = Color(30, 250, 250, 255)
	end

	if( self.Weapon:Clip1() <= 9 ) then
		self.VElements["trd"].color = Color(220, 220, 30, 255)
	end

	if( self.Weapon:Clip1() <= 8 ) then
		self.VElements["trd"].color = Color(200, 200, 30, 255)
	end

	if( self.Weapon:Clip1() <= 7 ) then
		self.VElements["trd"].color = Color(180, 180, 30, 255)
	end

	if( self.Weapon:Clip1() == 6 ) then 
		self.VElements["trd"].color = Color(160, 160, 30, 255)
	end

	if( self.Weapon:Clip1() <= 5 ) then 
		self.VElements["trd"].color = Color(140, 140, 30, 255)
	end

	if( self.Weapon:Clip1() <= 4 ) then
		self.VElements["trd"].color = Color(120, 120, 30, 255)
	end

	if( self.Weapon:Clip1() <= 3 ) then
		self.VElements["trd"].color = Color(100, 100, 30, 255)
	end

	if( self.Weapon:Clip1() <= 2 ) then
		self.VElements["trd"].color = Color(80, 80, 30, 255)
	end

	if( self.Weapon:Clip1() == 1 ) then 
		self.VElements["trd"].color = Color(60, 60, 30, 255)
	end

	if( self.Weapon:Clip1() == 0 ) then 
		self.VElements["trd"].color = Color(30, 30, 30, 255)
	end
end


SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red" 
SWEP.Secondary.ScopeZoom 			= 4
SWEP.ScopeReticule_Scale 			= {1.06,1.06}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end

local StunSound = Sound ("weapons/e11/blast_09.mp3")
local EmptyAmmo		= Sound("weapons/sw_noammo.wav")
local Phaseredrags = {}
local Phaseruniquetimer1 = 0
local disablePrintTime = 0

function SWEP:Stun()
	if !weaponStun:GetBool() then
	self.Primary.Damage 		= 0
	self.Primary.Recoil			= 0.75
	self.Primary.NumShots		= 1
	self.Primary.Cone			= 0.0001
	self.Primary.ClipSize		= 10
	self.Primary.Delay			= 1
	self.Primary.DefaultClip	= 0
	self.Primary.Automatic		= false
	self.Primary.Ammo			= "stunammo"
	self.Primary.Tracer 		= "rw_sw_laser_aqua"
	
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	--if ( !self:CanPrimaryAttack() ) then return end

	if ( self:Clip1() < 10 ) then
		self.Weapon:EmitSound( EmptyAmmo )
		return
	end

	self.Weapon:EmitSound( StunSound )

	self:TakePrimaryAmmo( 10 )
	
	if ( self.Owner:IsNPC() ) then return end
	
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )

	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	
	
 	local eyetrace = self.Owner:GetEyeTrace() 
 	if !eyetrace.Entity:IsPlayer() then 
  		if !eyetrace.Entity:IsNPC() then return end   
  	end
   
 	if (!SERVER) then return end 
    
 	if eyetrace.Entity:IsPlayer() then
		local dist = eyetrace.Entity:GetPos():DistToSqr(self.Owner:GetPos()) < 1000000
		if dist then
			self:DoHandcuff(eyetrace.Entity)    
		end
 	end
end
end

local function CleanUp( ragdoll, ent, weapon, rendermode, movetype, time )
    if ( IsValid( ragdoll ) ) then
        if ( IsValid( ent ) ) then
            ent:SetPos( ragdoll:GetPos() )
        end

        if ( ent:IsPlayer() and ent:Alive() or ent:IsNPC() ) then  
            ragdoll:Remove()
        end
    end
        
    if ( not IsValid( ent ) ) then return end

    ent:SetRenderMode( rendermode )
    ent:SetMoveType( movetype )
    ent:DrawShadow( true )
    ent:SetNotSolid( false )

    if ( ent:IsPlayer() ) then
        timer.Simple(5,function()
            ent:Freeze( false )
            ent:SetNWBool("PhaseStunned", false) -- Changed from ply to ent
        end)
        ent:DrawViewModel( true )
    end

    if ( IsValid( weapon ) ) then
        weapon:SetNoDraw( false )
    end
end

function SWEP:DoHandcuff( target )

	if not (target and IsValid(target)) then return end

	if target:IsHandcuffed() then return end

	if not IsValid(self.Owner) then return end

	

	if SERVER then

		-- target.CuffDrop = true

		-- target:DropObject()

		-- target.CuffDrop = nil

		local wep = target:GetActiveWeapon()

		if IsValid(wep) and wep:GetClass()=="weapon_physcannon" then

			wep:Remove()

			timer.Simple( 0.1, function()

				if IsValid(target) and target:Alive() and not (target.isArrested and target:isArrested()) then

					target:Give( "weapon_physcannon" )

				end

			end)

		end

	end

	

	local cuff = target:Give( "weapon_handcuffed" )

	cuff:SetCuffStrength( 1.0 + (math.Rand(-0.1,0.1)) )

	cuff:SetCuffRegen( 0.8 + (math.Rand(-0.3,0.3)) )

	

	cuff:SetCuffMaterial( "models/props_pipes/GutterMetal01a" )

	cuff:SetRopeMaterial( "cable/red" )

	

	cuff:SetKidnapper( self.Owner )

	cuff:SetRopeLength( 60 )

	

	cuff:SetCanBlind( true )

	cuff:SetCanGag( true )

	

	cuff.CuffType = "weapon_cuff_elastic" or ""

	

	if self.IsLeash then

		cuff:SetIsLeash( true )

		timer.Simple( 0, function()

			if IsValid(cuff) then

				cuff:SetHoldType( "normal" )

				cuff.HoldType = "normal"

			end

		end)

	end

	

	PrintMessage( HUD_PRINTCONSOLE, "[Cuffs] "..tostring(self.Owner:Nick()).." has handcuffed "..tostring(target:Nick()).." with "..tostring(self.PrintName) )

	hook.Call( "OnHandcuffed", GAMEMODE, self.Owner, target, cuff )

	

	if self.Owner.isCP and target.arrest and self.Owner:isCP() and cvars.Bool("cuffs_autoarrest") then

		target:arrest( nil, self.Owner)

	end

end

function SWEP:PrimaryAttack()
if not self:IsSafety() then
		self:Stun()
		else return end
end