SWEP.Base = "dangumeleebase"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 3
SWEP.PrintName = "Riot Baton [Stun]"
SWEP.Author = "Misahu"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Category = "Imperial Arts"
SWEP.SlotPos = 3
 
SWEP.Purpose = "We're taking heavy losses!"

SWEP.ViewModelFOV = 85
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/models/danguyen/c_oren_katana.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.UseHands = true
SWEP.CanThrow = false

--STAT RATING (1-6)
SWEP.Type=3 --1: Blade, 2: Axe, 3:Bludgeon, 4: Spear
SWEP.Strength=3 -- 1-2: Small Weapons, 3-4: Medium Weapons (e.g crowbar), 5-6: Heavy Weapons (e.g Sledgehammers and Greatswords). Strength affects throwing distance and force
SWEP.Speed=3 -- 1-2: Slow, 3-4: Decent, 5-6: Fast
SWEP.Tier=3 -- General rating based on how good/doodoo the weapon is

--SWEPs are dumb (or I am) so we must state the weapon name again
SWEP.WepName="imperialarts_blade_riotbatonstun"

--Stamina Costs
SWEP.PriAtkStamina=5
SWEP.ThrowStamina=5
SWEP.BlockStamina=5
SWEP.ShoveStamina=5

--Primary Attack Charge Values
SWEP.Charge = 0
SWEP.ChargeSpeed = 0.6
SWEP.DmgMin = 20
SWEP.DmgMax = 40
SWEP.Delay = 0.7
SWEP.TimeToHit = 0.05
SWEP.Range = 65
SWEP.Punch1 = Angle(-5, 10, 0)
SWEP.Punch2 = Angle(-5, 0, -3)
SWEP.HitFX = ""
SWEP.IdleAfter = true
--Throwing Attack Charge Values
SWEP.Charge2 = 0
SWEP.ChargeSpeed2 = 0.8
SWEP.DmgMin2 = 20
SWEP.DmgMax2 = 40
SWEP.ThrowModel = "models/red menace/fallenorder/props/scouttrooper/riotbaton.mdl"
SWEP.ThrowMaterial = ""
SWEP.ThrowScale = 1
SWEP.ThrowForce = 1300
SWEP.FixedThrowAng = Angle(0,180,0)
SWEP.SpinAng = Vector(0,-1500,0)


--HOLDTYPES
SWEP.AttackHoldType="knife"
SWEP.Attack2HoldType="melee"
SWEP.ChargeHoldType="knife"
SWEP.IdleHoldType="slam"
SWEP.BlockHoldType="magic"
SWEP.ShoveHoldType="fist"
SWEP.ThrowHoldType="grenade"

--SOUNDS
SWEP.SwingSound="weapons/iceaxe/iceaxe_swing1.wav"
SWEP.ThrowSound="axethrow.mp3"
SWEP.Hit1Sound="physics/body/body_medium_impact_hard1.wav"
SWEP.Hit2Sound="physics/body/body_medium_impact_hard2.wav"
SWEP.Hit3Sound="physics/body/body_medium_impact_hard3.wav"

SWEP.Impact1Sound="physics/metal/metal_canister_impact_hard1.wav"
SWEP.Impact2Sound="physics/metal/metal_canister_impact_hard2.wav"


SWEP.ViewModelBoneMods = {
	["TrueRoot"] = { scale = Vector(1, 1, 1), pos = Vector(0, 1.146, -1.147), angle = Angle(0, 0, 0) },
	["LeftArm_1stP"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(-30, 30, 30), angle = Angle(0, 0, 0) },
	["RW_Weapon"] = { scale = Vector(0.076, 0.076, 0.076), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["RightArm_1stP"] = { scale = Vector(1, 1, 1), pos = Vector(-1.668, 0, 0), angle = Angle(10, 0, 0) }
}

SWEP.NextFireShove = 0
SWEP.NextFireBlock = 0
SWEP.NextStun = 0

SWEP.DefSwayScale 	= 1.0
SWEP.DefBobScale 	= 1.0

SWEP.StunPos = Vector(0, 0, 0)
SWEP.StunAng = Vector(-16.181, 0, 47.136)

SWEP.ShovePos = Vector(-6.633, -0.403, -1.005)
SWEP.ShoveAng = Vector(-3.518, 70, -70)

SWEP.RollPos = Vector(0,0,0)
SWEP.RollAng = Vector(0, 0, 0)

SWEP.WhipPos = Vector(-3.04, 0, -7.81)
SWEP.WhipAng = Vector(-30.955, -5.628, -31.659)


SWEP.ThrowPos = Vector(3.618, -4.824, 0)
SWEP.ThrowAng = Vector(100, -16.181, 0)

SWEP.FanPos = Vector(3.42, -11.056, 0.8)
SWEP.FanAng = Vector(90, -18.996, 90)


SWEP.WallPos = Vector(0,0,0)
SWEP.WallAng = Vector(0,0,0)

function SWEP:AttackAnimation()
	self.Weapon.AttackAnimRate = 0.9
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing1.wav")	
end
left=false
right=true
function SWEP:AttackAnimation2()
	self.Weapon.AttackAnimRate = 1
	if right==true then  
		self.Punch1 = Angle(0, -15, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
		right=false
		left=true
	elseif left==true then
		self.Punch1 = Angle(5, 10, 0)
		self.Weapon:SendWeaponAnim( ACT_VM_HITLEFT )
		left=false
		right=true
	end
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing1.wav")	
end
function SWEP:AttackAnimation3()
	self.Weapon:SendWeaponAnim( ACT_VM_HITRIGHT )
	self.Owner:EmitSound("weapons/stunstick/stunstick_swing1.wav")		
end


SWEP.VElements = {
	["FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 16), size = { x = 6, y = 6 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 17), size = { x = 7, y = 7 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 18), size = { x = 9, y = 9 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 19), size = { x = 9, y = 9 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 20), size = { x = 9, y = 9 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 21), size = { x = 7, y = 7 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "", rel = "b", pos = Vector(0, 0, 22), size = { x = 6, y = 6 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["b"] = { type = "Model", model = "models/red menace/fallenorder/props/scouttrooper/riotbaton.mdl", bone = "RW_Weapon", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.655, 0.655, 0.655), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["FX"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 16), size = { x = 6, y = 6 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 17), size = { x = 7, y = 7 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 18), size = { x = 9, y = 9 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 19), size = { x = 9, y = 9 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 20), size = { x = 9, y = 9 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX+++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 21), size = { x = 7, y = 7 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["FX++++++"] = { type = "Sprite", sprite = "particle/particle_glow_04", bone = "ValveBiped.Bip01_R_Hand", rel = "b", pos = Vector(0, 0, 22), size = { x = 6, y = 6 }, color = Color(0, 120, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["b"] = { type = "Model", model = "models/red menace/fallenorder/props/scouttrooper/riotbaton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 3, -1), angle = Angle(0, -30, 200), size = Vector(0.82, 0.82, 0.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local Phaseredrags = {}
function SWEP:Stun()
	if ( !self:CanPrimaryAttack() ) then return end

	if ( self.Owner:IsNPC() ) then return end
	
	
 	local eyetrace = self.Owner:GetEyeTrace() 
 	if !eyetrace.Entity:IsPlayer() then 
  		if !eyetrace.Entity:IsNPC() then return end   
  	end
   
 	if (!SERVER) then return end 
    
 	if eyetrace.Entity:IsPlayer() then
		local dist = eyetrace.Entity:GetPos():DistToSqr(self.Owner:GetPos()) < 9400
		if dist then
			self:PhasePlayer(eyetrace.Entity)
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
	
	-- creates the motherfuckers ragdoll
	local rag = ents.Create( "prop_ragdoll" )
    if not rag:IsValid() then return end

	-- builds his motherfucking rag
	--rag:SetModel( ply:GetModel() )
	
	if ply:GetModel() == "models/kingpommes/starwars/playermodels/astromech.mdl" or ply:GetModel() == "models/player/jellik/starwars/highsinger.mdl" or ply:GetModel() == "models/KingPommes/starwars/playermodels/gnk.mdl" or ply:GetModel() == "models/kingpommes/starwars/playermodels/mouse.mdl" then rag:SetModel("models/player/ven/tk_basic_01/tk_basic.mdl" ) else rag:SetModel( ply:GetModel() ) end
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
	
	-- make ragdoll motherfucking flop
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
			-- v Makes sure this motherfucker can't become god and start flying if hes abusing shit
			 if ply:GetMoveType(MOVETYPE_NOCLIP) then ply:SetMoveType(MOVETYPE_WALK) end
			timer.Destroy( "valid_ragdoll_check" .. ply:EntIndex() )
		end
	end )

    timer.Create( "death_check" .. ply:EntIndex(), 0, 0, function()
        if ( IsValid( rag ) and IsValid( ply ) and ply:Health() <= 0 ) then
            rag:Remove()
        end
    end )

    timer.Simple(5, function() 
        CleanUp( rag, ply, weapon, rendermode, movetype )
       
        timer.Destroy( "death_check" .. ply:EntIndex() )
    end )
	
end

function SWEP:PrimaryAttack()
    RandomstunNumba = math.random(1,100)
	if self.Owner:GetActiveWeapon("imperialarts_blade_riotbatonstun") then
	if RandomstunNumba > 60 then
	self:Stun()
	    end
	end
end