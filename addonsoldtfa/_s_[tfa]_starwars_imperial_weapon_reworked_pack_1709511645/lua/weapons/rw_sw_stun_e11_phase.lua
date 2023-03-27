SWEP.Gun							= ("rw_sw_e11")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_swsft_base"
SWEP.Category						= "TFA StarWars Reworked Imperial"
SWEP.Manufacturer 					= ""
SWEP.Author							= "ChanceSphere574"
SWEP.Contact						= ""
SWEP.Spawnable						= false
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= false
SWEP.PrintName						= "Stun E-11 Phase"
SWEP.Type							= "Stun Imperial Carbine Blaster"
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
SWEP.SelectiveFire					= false
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "Automatic"
SWEP.FireModeName 					= "Automatic"
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize				= 5
SWEP.Primary.DefaultClip			= 1
SWEP.Primary.RPM					= 200
SWEP.Primary.RPM_Burst				= 200
SWEP.Primary.Ammo					= "battery"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 0
SWEP.Primary.RangeFalloff 			= 0
SWEP.Primary.NumShots				= 10
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= 0.2
SWEP.Primary.Sound 					= Sound ("weapons/e11/blast_09.wav");
SWEP.Primary.ReloadSound 			= Sound ("w/rifles.wav");
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 2
SWEP.Primary.HullSize 				= 1
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
SWEP.ViewModelFOV					= 65
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "ar2"
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
SWEP.Primary.StatusEffect = "stun"
SWEP.Primary.StatusEffectDmg = 60
SWEP.Primary.StatusEffectDur = 20
SWEP.Primary.StatusEffectParticle = true
SWEP.Tracer							= 0
SWEP.TracerName 					= "servius_stun"
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= "rw_sw_impact_red"
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(1.96, 0, -0.52)
SWEP.VMAng = Vector(0,0,0)
SWEP.IronSightTime 					= 0.2
SWEP.Primary.KickUp					= 0
SWEP.Primary.KickDown				= 0
SWEP.Primary.KickHorizontal			= 0
SWEP.Primary.StaticRecoilFactor 	= 0
SWEP.Primary.Spread					= 0
SWEP.Primary.IronAccuracy 			= 0.01
SWEP.Primary.SpreadMultiplierMax 	= 0
SWEP.Primary.SpreadIncrement 		= 0
SWEP.Primary.SpreadRecovery 		= 0
SWEP.DisableChambering 				= true
SWEP.MoveSpeed 						= 1.1
SWEP.IronSightsMoveSpeed 			= 0.9

SWEP.IronSightsPos = Vector(-4.86, -5, 3.1)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.226, -2, 0)
SWEP.RunSightsAng = Vector(-18, 36, -13.5)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-3, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["e11"] = { type = "Model", model = "models/sw_battlefront/weapons/e11_noscope.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(-1, 7, -4.3), angle = Angle(0, -90, 0), size = Vector(1.3, 1.3, 1.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["trd"] = { type = "Model", model = "models/props_phx/construct/metal_angle360.mdl", bone = "v_e11_reference001", rel = "e11", pos = Vector(-1.75, -3.6, 6.49), angle = Angle(90, -5, 0), size = Vector(0.008, 0.008, 0.008), color = Color(255, 120, 0, 255), surpresslightning = true, material = "models/debug/debugwhite", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["e11"] = { type = "Model", model = "models/sw_battlefront/weapons/e11_noscope.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10, 0.4, 1), angle = Angle(192, 180, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

local MaxTimer				= 35
local CurrentTimer			= 0
function SWEP:Think()

	if (self.Weapon:Clip1() < self.Primary.ClipSize) and SERVER then
		if (CurrentTimer >= 35) then 
			CurrentTimer = 0
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )
		else
			CurrentTimer = CurrentTimer + 2
		end
	end

	if( self.Weapon:Clip1() <= 5 ) then 
		self.VElements["trd"].color = Color(30, 250, 250, 255)
	end

	if( self.Weapon:Clip1() <= 4 ) then
		self.VElements["trd"].color = Color(200, 200, 30, 255)
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

SWEP.Attachments = {
	[1] = { offset = { 0, 0 }, atts = {"mod_stun5","mod_stun10","mod_stun15","mod_stun20"}, sel = 1, order = 1 },
}
SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BULLET
SWEP.DamageType 					= DMG_BULLET
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "#sw/visor/sw_ret_redux_red" 
SWEP.Secondary.ScopeZoom 			= 7.5
SWEP.ScopeReticule_Scale 			= {1,1}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end
SWEP.CustomBulletCallback = nil
SWEP.CustomBulletCallbackOld = nil
--[[SWEP.CustomBulletCallbackOld = SWEP.CustomBulletCallbackOld or SWEP.CustomBulletCallback
	SWEP.CustomBulletCallback = function(a, tr, dmg)
		local wep = dmg:GetInflictor()
			GMSNX:AddStatus(tr.Entity, wep:GetOwner(), "stun", 10, 10, true)
			--util.Efwep:Attach(attachment, true)fect("BGOLightning", ED_Stun, true, true)
	end]]
	
function SWEP:Equip()
    if not (self.Owner:IsSuperAdmin() or self.Owner:IsUserGroup("Senior Event Master") or self.Owner:IsUserGroup("Lead Event Master")  or self.Owner:IsUserGroup("admin") ) then
        local notyboi = self.Owner:Nick()
        --local effectdata = EffectData()
	    --effectdata:SetOrigin(self.Owner:GetPos())
	    --self.Owner:Kill()
    if CLIENT then return end
    self.Owner:PrintMessage(HUD_PRINTTALK, "You somehow obtained a Dev Weapon, It has been removed.")
    self.Owner:StripWeapon("rw_sw_stun_e11_phase")
    --util.Effect("Explosion", effectdata)
        if SERVER then
        for k, v in ipairs(player.GetAll()) do
            if v:IsSuperAdmin() then
                v:PrintMessage(HUD_PRINTTALK, "[DevWepAlert] "..notyboi.." | Was Given a 'rw_sw_stun_e11_phase', Discord Relay or Echos will show how it was Obtained.|")
            end
        end
    end
elseif SERVER then 
if ( self.Owner:IsUserGroup("Senior Event Master") or self.Owner:IsUserGroup("Lead Event Master")  or self.Owner:IsUserGroup("admin") ) then
for k, v in ipairs(player.GetAll()) do
    local godyboi = self.Owner:Nick()
            if v:IsSuperAdmin() then
                 v:PrintMessage(HUD_PRINTTALK, "[DevWepAlert] "..godyboi.." Has obtained the 'E-11 Stun Phase' Dev Weapon.")
            end
        end
    end
end
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
	self.Primary.Cone			= 0
	self.Primary.ClipSize		= 5
	self.Primary.Delay			= 0
	self.Primary.DefaultClip	= 0
	self.Primary.Automatic		= true
	self.Primary.RPM 			= 200
	self.Primary.RPM_Burst 		= 200
	self.Primary.Ammo			= "stunammo"
	self.Primary.Tracer 		= "rw_sw_laser_red"
	
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if ( !self:CanPrimaryAttack() ) then return end

	if ( self:Clip1() < 1 ) then
		self.Weapon:EmitSound( EmptyAmmo )
		return
	end

	self.Weapon:EmitSound( StunSound )

	self:TakePrimaryAmmo( 1 )
	
	if ( self.Owner:IsNPC() ) then return end
	
	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )

	self:ShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
	
	
 	local eyetrace = self.Owner:GetEyeTrace() 
 	if !eyetrace.Entity:IsPlayer() then 
  		if !eyetrace.Entity:IsNPC() then return end    
  	end
   
 	if (!SERVER) then return end 
 
 	if eyetrace.Entity:IsPlayer() then
		local dist = eyetrace.Entity:GetPos():DistToSqr(self.Owner:GetPos()) < 500000
		if dist then
			self:PhasePlayer(eyetrace.Entity)    
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
        end)
        ent:DrawViewModel( true )
    end

    if ( IsValid( weapon ) ) then
        weapon:SetNoDraw( false )
    end
end
function SWEP:PhasePlayer(ply)
	local movetype = ply:GetMoveType()
    local rendermode = ply:GetRenderMode()
	ply:SetRenderMode( RENDERMODE_NONE )
    ply:SetMoveType( MOVETYPE_NONE ) 
    ply:DrawShadow( false )
    ply:SetNotSolid( true )

    if ( ply:IsPlayer() ) then
        ply:Freeze( true )
        ply:DrawViewModel( false )
    end

    local weapon = ply:GetActiveWeapon()
    if ( IsValid( weapon ) ) then
        weapon:SetNoDraw( true )
    end
	
	-- create ragdoll
	local rag = ents.Create( "prop_ragdoll" )
    if not rag:IsValid() then return end

	-- build rag
	rag:SetModel( ply:GetModel() )
	rag:SetPos( ply:GetPos() )
	rag:SetAngles( ply:GetAngles() )
    rag:SetVelocity( ply:GetVelocity() )
	rag.OwnerEnt = ply
	-- player vars
	rag.Phaseredply = ply
	table.insert(Phaseredrags, rag)
		
	-- "remove" player
	
	-- finalize ragdoll
    rag:Spawn()
    rag:Activate()
	
	-- make ragdoll fall
	rag:GetPhysicsObject():SetVelocity(4*ply:GetVelocity())
	local num = rag:GetPhysicsObjectCount() - 1
    local v = ply:GetVelocity()

    for i=0, num do
        local bone = rag:GetPhysicsObjectNum( i )
        if ( IsValid( bone ) ) then
            local bp, ba = ply:GetBonePosition( rag:TranslatePhysBoneToBone( i ) )
            if ( bp and ba ) then
                bone:SetPos( bp )
                bone:SetAngles( ba )
            end
            bone:SetVelocity( v )
        end
    end
	local effect = EffectData()
		effect:SetOrigin( rag:GetPos() )
		effect:SetStart( rag:GetPos() )
		effect:SetMagnitude( 5 )
		effect:SetEntity( rag )

	util.Effect( "teslaHitBoxes", effect )
	rag:EmitSound( "Weapon_StunStick.Activate" )
	timer.Create( "Electricity" .. self:EntIndex(), 0.35, 0, function()
            if ( not IsValid( rag ) ) then 
                timer.Destroy( "Electricity" .. self:EntIndex() )

                return
            end

            local effect2 = EffectData()
            effect2:SetOrigin( rag:GetPos() )
            effect2:SetStart( rag:GetPos() )
            effect2:SetMagnitude( 5 )
            effect2:SetEntity( rag )

            util.Effect( "teslaHitBoxes", effect2 )
            rag:EmitSound( "Weapon_StunStick.Activate" )
		end )
	-- bring the motherfucker back
	timer.Create( "valid_ragdoll_check" .. ply:EntIndex(), 0, 0, function()
		if ( not IsValid( rag ) ) then
			CleanUp( nil, ply, weapon, rendermode, movetype )
			timer.Destroy( "valid_ragdoll_check" .. ply:EntIndex() )
		end
	end )

    timer.Create( "death_check" .. ply:EntIndex(), 0, 0, function()
        if ( IsValid( rag ) and IsValid( ply ) and ply:IsNPC() and ply:Health() <= 0 ) then
            rag:Remove()
        end
    end )

    timer.Simple( GetConVar( "taser_duration" ):GetInt(), function() 
        CleanUp( rag, ply, weapon, rendermode, movetype )

        timer.Destroy( "death_check" .. ply:EntIndex() )
    end )
	
end

function SWEP:PrimaryAttack()
	if self:GetHoldType() == "ar2" then
		self:Stun()
	end
end