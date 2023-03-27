if CLIENT then
	SWEP.PrintName = "Jetpack"
	SWEP.Author = "Sgt. Ownage"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
end

SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = GetConVarNumber("jetpack_max_fuel")
SWEP.Primary.Ammo = "AirboatGun"
SWEP.DrawAmmo = true

SWEP.Secondary.Ammo			= "none"

SWEP.HoldType = "normal"
SWEP.Category = "Sgt. Ownage's Weapons"
SWEP.UseHands = false
SWEP.DrawCrosshair= false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Automatic= false

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

local JetActivate = Sound("hl1/fvox/activated.wav")
local JetDeactivate = Sound("hl1/fvox/deactivated.wav")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 3)
	local JetIsOn = self.Owner:GetNWBool("JetEnabled")
	
	if SERVER then
		self.Owner:SetNWBool("JetEnabled",!JetIsOn)
		if JetIsOn then
			self.Owner:SetAmmo(GetConVarNumber("jetpack_max_fuel"), "AirboatGun")
			self.Owner:StopSound("RocketThrust")
			self.Owner:PrintMessage( HUD_PRINTCENTER, "Jetpack Deactivated" )
		elseif !JetIsOn then
			self.Owner:PrintMessage( HUD_PRINTCENTER, "Jetpack Activated" )
		end
	elseif CLIENT then
		if JetIsOn then
			surface.PlaySound(JetDeactivate)
		elseif !JetIsOn then
			surface.PlaySound(JetActivate)
		end
	end
end 

if SERVER then
	local nextthinking = 0
	local function JetPacking()
		local curtime = CurTime()
		for k,ply in ipairs(player.GetAll()) do
			if not ply:GetNWBool("JetEnabled") then continue end
			local multiplier = 3
			if game.SinglePlayer() then
				multiplier = 1
			end
			ply:LagCompensation( true )
			if ply:GetNWBool("JetEnabled") then
				if ( !ply:IsOnGround() ) then
					ply:SetAnimation( ACT_MP_SWIM )
					ply:SetPlaybackRate(0)
					if (ply:GetAmmoCount("AirboatGun") > GetConVarNumber("jetpack_drain_fuel") and ply:KeyDown(IN_JUMP) or ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK))then
						if ply:KeyDown(IN_JUMP) then
							ply:SetVelocity(ply:GetUp() * 30 * multiplier + ply:GetAimVector() * multiplier)
							ply:SetNWFloat("forcejumptime",CurTime() + 90)
							ply:RemoveAmmo(GetConVarNumber("jetpack_drain_fuel"),"AirboatGun")
							ply:EmitSound("RocketThrust")
							if ply:GetNWFloat("NextJetEffect")<curtime then
								--PrintTable(ply:GetAttachments())
								--ParticleEffectAttach( "rockettrail", 4, ply, 3 )
								ply:StopParticles()
								ply:SetNWFloat("NextJetEffect",curtime+0.95)
							end
						end
						if ply:KeyDown(IN_FORWARD) then
							ply:SetVelocity( ply:GetForward() * 50)
							ply:RemoveAmmo(GetConVarNumber("jetpack_drain_fuel"),"AirboatGun")
						end
						if ply:KeyDown(IN_BACK) then
							ply:SetVelocity( -ply:GetForward() * 50)
							ply:RemoveAmmo(GetConVarNumber("jetpack_drain_fuel"),"AirboatGun")
						end
					else
						local vel = ply:GetVelocity()
						if vel.z < -10 then
							ply:EmitSound("RocketThrust")
							vel.x = 0
							vel.y = 0
							vel.z = -vel.z * 9 * multiplier / 100
							ply:SetVelocity( vel )
						end
						if ply:GetNWFloat("NextJetEffect")<curtime then
							--local fx = EffectData()
							--fx:SetEntity(ply)
							--util.Effect("smoke", fx, true, true)
							ply:SetNWFloat("NextJetEffect",curtime+0.95)
						end
					end
				elseif (ply:GetAmmoCount("AirboatGun") < GetConVarNumber("jetpack_max_fuel")) and ply:IsOnGround() then
					ply:StopSound("RocketThrust")
					ply:GiveAmmo(1, "AirboatGun", true)
				end
			end
			ply:LagCompensation( false )
		end
	end
	hook.Add("Think","Jetpush",JetPacking)
	
	local function PlayerDied(ply)
		local JetIsOn = ply:GetNWBool("JetEnabled")
		
		if JetIsOn then
			ply:SetNWBool("JetEnabled",false)
			ply:StopSound("RocketThrust")
		end
	end
	hook.Add("PlayerDeath","RemoveDeadJets",PlayerDied)
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self.Owner:SetNWFloat("NextJetEffect",CurTime())
end

function SWEP:Deploy()
	self:SetNextPrimaryFire(CurTime() + .2)
	self.Owner:DrawViewModel(false)
end

function SWEP:DrawWorldModel()
	return false
end

function SWEP:Reload()
	return
end

