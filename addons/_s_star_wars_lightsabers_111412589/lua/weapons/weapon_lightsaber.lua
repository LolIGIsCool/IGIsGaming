AddCSLuaFile()

if ( SERVER ) then
	util.AddNetworkString( "rb655_holdtype" )
	resource.AddWorkshop( "111412589" )
	resource.AddWorkshop("757604550")
	resource.AddWorkshop("848953359")
	CreateConVar( "rb655_lightsaber_infinite", "0" )
end

local DuelForceEnabled = true
local infiniteforce_regiments = {
	["Experimental Unit"] = true,
}
local infiniteforce_steamids = {
	["STEAM_0:0:57771691"] = true, -- Kumo
	["STEAM_0:0:80706730"] = true, -- Jman1308
	["STEAM_0:1:109470858"] = true, -- Tempest (Vader)
}
local dev_abilities_steamids = {
	["Global"] = {
		["STEAM_0:0:57771691"] = true, -- Kumo
		["STEAM_0:0:80706730"] = true, -- Jman1308
		["STEAM_0:1:100919525"] = true, -- Guskywalker
		["STEAM_0:1:109470858"] = true, -- Tempest (Vader)
	},
	["Force Leap"] = {
		-- [""] = true,
		["STEAM_0:0:41555770"] = true, -- zaspan
		["STEAM_0:0:143657869"] = true,
	},
	["Force Repulse"] = {
		-- [""] = true,
	},
	["Force Heal"] = {
		["STEAM_0:0:121909584"] = true, -- Matrix
		["STEAM_0:0:41555770"] = true, -- zaspan
	},
	["Force Lightning"] = {
		-- [""] = true,
	},
	["Force Drain"] = {
		-- [""] = true,
	},
}

SWEP.PrintName = "Lightsaber"
SWEP.Author = "Robotboy655"
SWEP.Category = "Robotboy655's Weapons"
SWEP.Contact = "robotboy655@gmail.com"
SWEP.Purpose = "To slice off each others limbs && heads."
SWEP.Instructions = "Use the force, Luke."
SWEP.RenderGroup = RENDERGROUP_BOTH
SWEP.IsLightsaber = true

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.DrawWeaponInfoBox = false

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl"
SWEP.ViewModelFOV = 55

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.ShouldDraw = true


-- Helper functions
function SWEP:PlayWeaponSound( snd )
	if ( CLIENT ) then return end
	if ( IsValid( self:GetOwner() ) && IsValid( self:GetOwner():GetActiveWeapon() ) && self:GetOwner():GetActiveWeapon() != self ) then return end
	if ( !IsValid( self.Owner ) ) then return self:EmitSound( snd ) end
	self.Owner:EmitSound( snd )
end

function SWEP:SelectTargets( num )
	local t = {}
	local dist = 512

	local p = {}

	if num == 1 then

		local trace = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
		local ent = trace.Entity
		if IsValid(ent) then
			return {ent}
		end
	end

	for id, ply in pairs( ents.GetAll() ) do
		if ( !ply:GetModel() || ply:GetModel() == "" || ply == self.Owner || ply:Health() < 1 ) then continue end
		if ( string.StartWith( ply:GetModel() || "", "models/gibs/" ) ) then continue end
		if ply:GetNWBool("staffnoclip",false) then continue end
		if ( string.find( ply:GetModel() || "", "chunk" ) ) then continue end
		if ( string.find( ply:GetModel() || "", "_shard" ) ) then continue end
		if ( string.find( ply:GetModel() || "", "_splinters" ) ) then continue end

		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = ply.GetShootPos && ply:GetShootPos() || ply:GetPos(),
			filter = self.Owner,
		} )

		if ( tr.Entity != ply && IsValid( tr.Entity ) || tr.Entity == game.GetWorld() ) then continue end

		local pos1 = self.Owner:GetPos() + self.Owner:GetAimVector() * dist
		local pos2 = ply:GetPos()
		local dot = self.Owner:GetAimVector():Dot( ( self.Owner:GetPos() - pos2 ):GetNormalized() )

		if ( pos1:DistToSqr( pos2 ) <= 262144 && ply:EntIndex() > 0 && ply:GetModel() && ply:GetModel() != "" ) then
			table.insert( p, { ply = ply, dist = tr.HitPos:Distance( pos2 ), dot = dot, score = -dot + ( ( dist - pos1:Distance( pos2 ) ) / dist ) * 50 } )
		end
	end

	for id, ply in SortedPairsByMemberValue( p, "dist" ) do
		table.insert( t, ply.ply )
		if ( #t >= num ) then return t end
	end

	return t
end

-- Force Powers

function SWEP:GetAllowedForceAbilities()
	local tbl = {}
	for id, ability in pairs( rb655_ForcePowers ) do
		local ret = hook.Run( "CanUseLightsaberForcePower", self:GetOwner(), ability.name )
		if ( ret == false ) then continue end
		//if self:GetOwner():SteamID() == "STEAM_0:0:178929973" then continue end //troll
		table.insert(tbl, ability)
	end
	return tbl
end

function SWEP:GetSelectedForceAbilities()
	local ForceAbilities = self:GetAllowedForceAbilities()
	local tbl = {}
	for id, ability in pairs( ForceAbilities ) do
		if self.Owner.selectedAbilities[ability.name] == true then
			table.insert(tbl, ability)
		end
	end

	return tbl
end

function SWEP:GetActiveForcePowerType( id )
	local ForcePowers = self:GetSelectedForceAbilities()
	return ForcePowers[ id ]
end

if ( SERVER ) then
	concommand.Add( "rb655_select_force", function( ply, cmd, args )
		if ( !IsValid( ply ) || !IsValid( ply:GetActiveWeapon() ) || ply:GetActiveWeapon():GetClass() != "weapon_lightsaber" || !tonumber( args[ 1 ]) ) then return end

		local ForcePowers = ply:GetActiveWeapon():GetSelectedForceAbilities()
		local typ = math.Clamp( tonumber( args[ 1 ] ), 1, #ForcePowers )
		ply:GetActiveWeapon():SetForceType( typ )
	end )
end

hook.Add( "GetFallDamage", "rb655_lightsaber_no_fall_damage", function( ply, speed )
	if ( IsValid( ply ) && IsValid( ply:GetActiveWeapon() ) && ply:GetActiveWeapon():GetClass() == "weapon_lightsaber" ) then
		local ret = hook.Run( "CanUseLightsaberForcePower", ply, "Force Land" )
		if ( ret == false ) then return end
		return 0
	end
end )


function SWEP:SetNextAttack( delay )
	self:SetNextPrimaryFire( CurTime() + delay )
	self:SetNextSecondaryFire( CurTime() + delay )
end

function SWEP:ForceJumpAnim()
	self.Owner.m_bJumping = true

	self.Owner.m_bFirstJumpFrame = true
	self.Owner.m_flJumpStartTime = CurTime()

	self.Owner:AnimRestartMainSequence()
end

hook.Add("SetupMove", "rb655SetupMove", function(ply, mv)
	if ply:OnGround() then return end

	if !IsValid(ply:GetActiveWeapon()) || !ply:GetActiveWeapon().IsLightsaber then return end

	if !mv:KeyPressed(IN_JUMP) then
		return
	end

	local ret = hook.Run( "CanUseLightsaberForcePower", ply, "Force Jump" )
	if ( ret == false ) then return end

	if DuelForceEnabled then
		if ply:GetActiveWeapon():GetBasicForce() < 5 then return end

		if ply:SteamID() == "STEAM_0:0:57771691" then
			ply:GetActiveWeapon():SetBasicForce(ply:GetActiveWeapon():GetBasicForce() - 1)
		else
			ply:GetActiveWeapon():SetBasicForce(ply:GetActiveWeapon():GetBasicForce() - 5)
		end
	else
		if ply:GetActiveWeapon():GetForce() < 5 then return end

		if ply:SteamID() == "STEAM_0:0:57771691" then
			ply:GetActiveWeapon():SetForce(ply:GetActiveWeapon():GetForce() - 1)
		else
			ply:GetActiveWeapon():SetForce(ply:GetActiveWeapon():GetForce() - 5)
		end
	end

	mv:SetVelocity(ply:GetAimVector() * 256 + Vector( 0, 0, 512 ))

	ply:DoCustomAnimEvent(PLAYERANIMEVENT_JUMP , -1)
end)

rb655_ForcePowers = { {
		name = "Force Leap",
		icon = "L",
		action = function( self )
			if ( !self.Owner:IsOnGround() || CLIENT ) then return end

			if DuelForceEnabled then
				if ( self:GetBasicForce() < 10 ) then return end
				self:SetBasicForce( self:GetBasicForce() - 5 )
			else
				if ( self:GetForce() < 10 ) then return end
				self:SetForce( self:GetForce() - 5 )
			end
			if dev_abilities_steamids["Force Leap"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
				self:SetNextAttack( 0.01 )
				local vel = self.Owner:GetAimVector() * 512 * 2
				vel.z = math.Clamp( vel.z, -256, 512 )
				self.Owner:SetVelocity( vel + Vector( 0, 0, 512 ) )
				self.Owner:SetNWFloat("forcejumptime",CurTime() + 90)
				self:PlayWeaponSound( "lightsaber/force_leap.wav" )
				self:CallOnClient( "ForceJumpAnim", "" )
			else
				self:SetNextAttack( 2.0 )
				local vel = self.Owner:GetAimVector() * 512 * 1.2
				vel.z = math.Clamp( vel.z, -256, 512 )
				self.Owner:SetVelocity( vel + Vector( 0, 0, 512 ) )
				self.Owner:SetNWFloat("forcejumptime",CurTime() + 90)
				self:PlayWeaponSound( "lightsaber/force_leap.wav" )
				self:CallOnClient( "ForceJumpAnim", "" )
			end
		end
	}, {
		name = "Force Repulse",
		icon = "R",
		think = function( self )
			if ( self:GetNextSecondaryFire() > CurTime() ) then return end
			if ( self:GetForce() < 1 || CLIENT ) then return end
			if ( !self.Owner:KeyDown( IN_ATTACK2 ) && !self.Owner:KeyReleased( IN_ATTACK2 ) ) then return end
			if ( !self._ForceRepulse && self:GetForce() < 10 ) then return end

			if ( !self.Owner:KeyReleased( IN_ATTACK2 ) ) then
				if ( !self._ForceRepulse ) then self:SetForce( self:GetForce() - 10 ) self._ForceRepulse = 1 end

				if ( !self.NextForceEffect || self.NextForceEffect < CurTime() ) then
					local ed = EffectData()
					ed:SetOrigin( self.Owner:GetPos() + Vector( 0, 0, 36 ) )
					ed:SetRadius( 128 * self._ForceRepulse )
					util.Effect( "rb655_force_repulse_in", ed, true, true )

					self.NextForceEffect = CurTime() + math.Clamp( self._ForceRepulse / 20, 0.1, 0.5 )
				end

				self._ForceRepulse = self._ForceRepulse + 0.050
				self:SetForce( self:GetForce() - 1 )
				if ( self:GetForce() > 10 ) then return end
			else
				if ( !self._ForceRepulse ) then return end
			end


			local maxdist = 128 * self._ForceRepulse

			if dev_abilities_steamids["Force Repulse"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
				maxdist = 900 * self._ForceRepulse
			end


			for i, e in pairs( ents.FindInSphere( self.Owner:GetPos(), maxdist ) ) do
				if ( e == self.Owner ) then continue end

				local dist = self.Owner:GetPos():Distance( e:GetPos() )
				local mul = ( maxdist - dist ) / 256

				local v = ( self.Owner:GetPos() - e:GetPos() ):GetNormalized()
				v.z = 0

				if ( e:IsNPC() && util.IsValidRagdoll( e:GetModel() || "" ) ) then

					local dmg = DamageInfo()
					dmg:SetDamagePosition( e:GetPos() + e:OBBCenter() )
					if dev_abilities_steamids["Force Repulse"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
						dmg:SetDamage(2000 * mul)
					else
						dmg:SetDamage( 20 * mul )
					end
					dmg:SetDamageType( DMG_GENERIC )
					if ( ( 1 - dist / maxdist ) > 0.8 ) then
						dmg:SetDamageType( DMG_GENERIC )
						dmg:SetDamage( e:Health() * 2 )
					end
					if dev_abilities_steamids["Force Repulse"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
						dmg:SetDamageType( DMG_DISSOLVE )
						dmg:SetDamage(e:Health() * 4 )
					end
					dmg:SetDamageForce( -v * math.min( mul * 40000, 80000 ) )
					dmg:SetInflictor( self.Owner )
					dmg:SetAttacker( self.Owner )
					e:TakeDamageInfo( dmg )

					if ( e:IsOnGround() ) then
						e:SetVelocity( v * mul * -2048 + Vector( 0, 0, 64 ) )
					elseif ( !e:IsOnGround() ) then
						e:SetVelocity( v * mul * -1024 + Vector( 0, 0, 64 ) )
					end

				elseif ( e:IsPlayer() && dev_abilities_steamids["Force Repulse"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] && util.IsValidRagdoll( e:GetModel() || "" ) ) then

					local dmg = DamageInfo()
					dmg:SetDamagePosition( e:GetPos() + e:OBBCenter() )
					if dev_abilities_steamids["Force Repulse"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
						dmg:SetDamage(2000 * mul)
					else
						dmg:SetDamage( 35 * mul )
					end
					dmg:SetDamageType( DMG_GENERIC )
					if ( ( 1 - dist / maxdist ) > 0.8 ) then
						dmg:SetDamageType( DMG_DISSOLVE )
						dmg:SetDamage( e:Health() * 3 )
					end
					if dev_abilities_steamids["Force Repulse"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
						dmg:SetDamageType( DMG_DISSOLVE )
						dmg:SetDamage(e:Health() * 5 )
					end
					dmg:SetDamageForce( -v * math.min( mul * 40000, 80000 ) )
					dmg:SetInflictor( self.Owner )
					dmg:SetAttacker( self.Owner )
					e:TakeDamageInfo( dmg )

					if ( e:IsOnGround() ) then
						e:SetVelocity( v * mul * -2048 + Vector( 0, 0, 64 ) )
					elseif ( !e:IsOnGround() ) then
						e:SetVelocity( v * mul * -1024 + Vector( 0, 0, 64 ) )
					end


				elseif ( e:IsPlayer() && e:IsOnGround() ) then
					e:SetVelocity( v * mul * -2048 + Vector( 0, 0, 64 ) )
				elseif ( e:IsPlayer() && !e:IsOnGround() ) then
					e:SetVelocity( v * mul * -384 + Vector( 0, 0, 64 ) )
				elseif ( e:GetPhysicsObjectCount() > 0 ) then
					if dev_abilities_steamids["Force Repulse"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
						for i = 0, e:GetPhysicsObjectCount() - 1 do
							e:GetPhysicsObjectNum( i ):ApplyForceCenter( v * mul * -512 * math.min( e:GetPhysicsObject():GetMass(), 256 ) * 25 + Vector( 0, 0, 64 ) )
						end
					else
					for i = 0, e:GetPhysicsObjectCount() - 1 do
						e:GetPhysicsObjectNum( i ):ApplyForceCenter( v * mul * -512 * math.min( e:GetPhysicsObject():GetMass(), 256 ) + Vector( 0, 0, 64 ) )
					end
					end
				end
			end

			local ed = EffectData()
			ed:SetOrigin( self.Owner:GetPos() + Vector( 0, 0, 36 ) )
			ed:SetRadius( maxdist )
			util.Effect( "rb655_force_repulse_out", ed, true, true )

			self._ForceRepulse = nil

			self:SetNextAttack( 1 )

			self:PlayWeaponSound( "lightsaber/force_repulse.wav" )
		end
	},{
		name = "Saber Throw",
		icon = "T",
		action = function(self)

			if self:GetForce() < 20 then return end
			self:SetForce( self:GetForce() - 20 )
			self:SetEnabled(false)
			self:SetBladeLength(0)
			self:SetNextAttack( 1 )
			self.ShouldDraw = false
			if SERVER then
				local ent = ents.Create("ent_lightsaber_thrown")
				ent:SetModel(self:GetWorldModel())
				ent:Spawn()
				ent:SetBladeLength(self:GetMaxLength())
				ent:SetMaxLength(self:GetMaxLength())
				ent:SetCrystalColor(self:GetCrystalColor())
				ent:SetDarkInner(self:GetDarkInner())

				local pos = self:GetSaberPosAng()
				ent:SetPos(pos)
				pos = pos + self.Owner:GetAimVector() * 600
				ent:SetEndPos(pos)
				ent:SetOwner(self.Owner)

			end
		end
	}, {
		name = "Force Heal",
		icon = "H",
		action = function( self )
			if dev_abilities_steamids["Force Heal"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] || self.Owner:GetJobTable().RealName == "Darth Vader" || self.Owner:GetRegiment() == "His Imperial Majesty" || self.Owner:GetRegiment() == "Experimental Unit" then
				if ( self:GetForce() < 1 || self.Owner:Health() >= self.Owner:GetMaxHealth() || CLIENT ) then return end
				self:SetForce( self:GetForce() - 0.06 )

				self:SetNextAttack( 0.008 )

				local ed = EffectData()
				ed:SetOrigin( self.Owner:GetPos() )
				util.Effect( "rb655_force_heal", ed, true, true )

				self.Owner:SetHealth( self.Owner:Health() + 10 )
				self.Owner:Extinguish()
			else
				if ( self:GetForce() < 1 || self.Owner:Health() >= (self.Owner:GetMaxHealth()/2) || CLIENT ) then return end
				self:SetForce( self:GetForce() - 0.6 )

				self:SetNextAttack( 0.075 )

				local ed = EffectData()
				ed:SetOrigin( self.Owner:GetPos() )
				util.Effect( "rb655_force_heal", ed, true, true )

				self.Owner:SetHealth( self.Owner:Health() + 3 )
				self.Owner:Extinguish()
			end
		end
	}, {
		name = "Force Combust",
		icon = "C",
		target = 1,
		action = function( self )
			if ( CLIENT ) then return end

			local ent = self:SelectTargets( 1 )[ 1 ]

			if ( !IsValid( ent ) || ent:IsOnFire() ) then self:SetNextAttack( 0.2 ) return end

			local time = math.Clamp( 512 / self.Owner:GetPos():Distance( ent:GetPos() ), 1, 16 )
			local neededForce = math.ceil( math.Clamp( time * 2, 10, 32 ) )

			if ( self:GetForce() < neededForce ) then self:SetNextAttack( 0.2 ) return end

			ent:Ignite( time, 0 )
			self:SetForce( self:GetForce() - neededForce )

			self:SetNextAttack( 1 )
		end
	}, {
		name = "Force Lightning",
		icon = "L",
		target = 3,
		action = function( self )
			if ( self:GetForce() < 3 || CLIENT ) then return end

			local foundents = 0
			for id, ent in pairs( self:SelectTargets( 3 ) ) do
				if ( !IsValid( ent ) ) then continue end

				foundents = foundents + 1
				local ed = EffectData()
				ed:SetOrigin( self:GetSaberPosAng() )
				ed:SetEntity( ent )
				util.Effect( "rb655_force_lighting", ed, true, true )

				local dmg = DamageInfo()
				dmg:SetAttacker( self.Owner || self )
				dmg:SetInflictor( self.Owner || self )

				if dev_abilities_steamids["Force Lightning"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] || self.Owner:GetRegiment() == "His Imperial Majesty" then
					dmg:SetDamage( math.Clamp( 512 / self.Owner:GetPos():Distance( ent:GetPos() ), 300, 300 ) )

					if ( ent:IsNPC() ) then dmg:SetDamage( 40 ) end
					ent:TakeDamageInfo( dmg )
				else
					dmg:SetDamage( math.Clamp( 512 / self.Owner:GetPos():Distance( ent:GetPos() ), 10, 20 ) )
					if ( ent:IsNPC() ) then dmg:SetDamage( 20 ) end
					ent:TakeDamageInfo( dmg )
				end

			end

			if ( foundents > 0 ) then
				self:SetForce( self:GetForce() - foundents )
				if ( !self.SoundLightning ) then
					self.SoundLightning = CreateSound( self.Owner, "lightsaber/force_lightning" .. math.random( 1, 2 ) .. ".wav" )
					self.SoundLightning:Play()
				else
					self.SoundLightning:Play()
				end

				timer.Create( "rb655_force_lighting_soundkill", 0.2, 1, function() if ( self.SoundLightning ) then self.SoundLightning:Stop() self.SoundLightning = nil end end )
			end
			if dev_abilities_steamids["Force Lightning"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
			self:SetNextAttack(0.001)
			else
			self:SetNextAttack( 0.1 )
			end
		end
	}, {
		name = "Force Sense",
		icon = "S",
		action = function( self )
			if ( self:GetForce() < 50 ) then return end
		if SERVER then
				self:SetForce( self:GetForce() - 0.15)
				local ed = EffectData()
				ed:SetOrigin( self.Owner:GetPos() + Vector( 0, 0, 64 ) )
				util.Effect( "rb655_force_sense", ed, true, true )
			return
		end
			sense = true
		end
	}, {
		name = "Force Drain",
		icon = "D",
		target = 1,
		action = function( self )
			if ( CLIENT ) then return end

			local ent = self:SelectTargets( 1 )[ 1 ]

			if !IsValid( ent ) then self:SetNextAttack( 0.2 ) return end

			local time = math.Clamp( 512 / self.Owner:GetPos():Distance( ent:GetPos() ), 1, 16 )
			local neededForce = math.ceil( math.Clamp( time * 2, 10, 32 ) )

			local dmg = DamageInfo()
				dmg:SetAttacker( self.Owner || self )
				dmg:SetInflictor( self.Owner || self )

			if ( self:GetForce() < neededForce ) then self:SetNextAttack( 0.2 ) return end

		if SERVER then
				local ed = EffectData()
				ed:SetOrigin( ent:GetPos() )
				util.Effect( "rb655_force_leech", ed, true, true )

				dmg:SetDamage( math.Clamp( 512 / self.Owner:GetPos():Distance( ent:GetPos() ), 1, 3 ) )
				if ( ent:IsNPC() ) then dmg:SetDamage( 20 ) end
				ent:TakeDamageInfo( dmg )

				if !(self.Owner:Health() > self.Owner:GetMaxHealth()) then
				local ed = EffectData()
				ed:SetOrigin( self.Owner:GetPos() )
				util.Effect( "rb655_force_leechheal", ed, true, true )
				self.Owner:SetHealth(math.min(self.Owner:GetMaxHealth(),self.Owner:Health() + 3))
				end
				if dev_abilities_steamids["Force Drain"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
					self:SetForce( self:GetForce() - 0.0001 )
				else
					self:SetForce( self:GetForce() - 0.5 )
				end

				return end

			if dev_abilities_steamids["Force Drain"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
				self:SetNextAttack( 0.01 )
			else
				self:SetNextAttack( 1 )
			end
		end
	}, {
		name = "Force Dash",
		icon = "FD",
		action = function( self )
			if CLIENT then return end
			local ply = self.Owner
			if ( self:GetBasicForce() < 0 ) then self:SetNextAttack( 0.2 ) return end
			local isLeft = ply:KeyDown(IN_MOVELEFT)
			local isRight = ply:KeyDown(IN_MOVERIGHT)
			local isBack = ply:KeyDown(IN_BACK)
			if ply:IsOnGround() then
				if isLeft then

					timer.Simple(0.2, function()
						ply:SetPos(ply:GetPos() + Vector(0,0,1.5))
						ply:SetVelocity(Vector(0,0,50) + ply:GetRight() * -2000)
						ply:EmitSound("hfg/weapons/force/jump.mp3")
					end)
				elseif isRight then

					timer.Simple(0.2, function()
						ply:SetPos(ply:GetPos() + Vector(0,0,1.5))
						ply:SetVelocity(Vector(0,0,50) + ply:GetRight() * 2000)
						ply:EmitSound("hfg/weapons/force/jump.mp3")
					end)
				elseif isBack then

					timer.Simple(0.2, function()
						ply:SetPos(ply:GetPos() + Vector(0,0,1.5))
						ply:SetVelocity(Vector(0,0,50) + ply:GetForward() * -2000)
						ply:EmitSound("hfg/weapons/force/jump.mp3")
					end)
				else
					timer.Simple(0.2, function()
						ply:SetPos(ply:GetPos() + Vector(0,0,1.5))
						ply:SetVelocity(Vector(0,0,50) + ply:GetForward() * 2000)
						ply:EmitSound("hfg/weapons/force/jump.mp3")
					end)
				end
			end
			self:SetBasicForce( self:GetBasicForce() - 20 )
			self:SetNextSecondaryFire( CurTime() +  2 )
		end
	}, {
		name = "Force Heal Other",
		icon = "HO",
		target = 1,
		action = function( self )
			if ( CLIENT ) then return end
			if ( self:GetForce() < 0 ) then self:SetNextAttack( 0.2 ) return end
			local ent = self:SelectTargets( 1 )[ 1 ]
			if (IsValid(ent) && (ent:IsPlayer() || ent:IsNPC()) && ent:Health() < ent:GetMaxHealth()) then
				local ed = EffectData()
				ed:SetOrigin( ent:GetPos() )
				util.Effect( "rb655_force_heal_other", ed, true, true )
				ent:SetHealth(math.min(ent:GetMaxHealth(),ent:Health() + 10))
				ent:Extinguish()
				if dev_abilities_steamids["Force Heal"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
					self:SetForce( self:GetForce() - 0.0001 )
				else
					self:SetForce( self:GetForce() - 1 )
				end
			end

			if dev_abilities_steamids["Force Heal"][self.Owner:SteamID()] || dev_abilities_steamids["Global"][self.Owner:SteamID()] then
				self:SetNextAttack( 0.01 )
			else
				self:SetNextAttack( 0.1 )
			end
		end
	}, {
		name = "Force Pull",
		icon = "FP",
		target = 10,
		action = function( self )
			if CLIENT then return end
			if ( self:GetForce() < 0 ) then self:SetNextAttack( 0.2 ) return end
			local ply = self.Owner
			timer.Simple(0.2, function()
				for i=-10,-1 do
					for k,v in ipairs(ents.FindInSphere(ply:GetPos() + ply:EyeAngles():Forward() * (100 * math.abs(i)),75)) do
						if (v.LFS || v:IsPlayer() || v:IsNPC()) && v != ply then
							if v:IsPlayer() then
								v:SetVelocity(ply:GetForward() * -50000)
							else
								v:GetPhysicsObject():AddVelocity(ply:GetForward() * -3000 + Vector(0,0,200))
							end
							self:SetForce( self:GetForce() - 2 )
						end
					end
				end
			end)
			self:SetNextAttack( 2 )
		end
	}, {
		name = "Force Push",
		icon = "FP",
		target = 5,
		action = function( self )
			if CLIENT then return end
			if ( self:GetForce() < 0 ) then self:SetNextAttack( 0.2 ) return end
			local ply = self.Owner
			timer.Simple(0.2, function()
				for i = -5,-1 do
					for k,v in ipairs(ents.FindInSphere(ply:GetPos() + ply:EyeAngles():Forward() * (100 * math.abs(i)),75)) do
						if (v.LFS || v:IsPlayer()) && v != ply then
							if v:IsPlayer() then
								v:SetVelocity(ply:GetForward() * 500000)
							else
								v:GetPhysicsObject():AddVelocity(ply:GetForward() * 50000 + Vector(0,0,200))
							end
							self:SetForce( self:GetForce() - 3 )
						end
					end
				end
			end)
			self:SetNextAttack( 2 )
		end
	}
}
hook.Add( "PreDrawHalos", "ForceSenseHalos", function()
	if !sense then return end
	sense = false
	local badHalos = {}

	for _, ent in pairs( ents.FindInSphere( LocalPlayer():GetPos(), 450 ) ) do
		if ent == LocalPlayer() then continue end
		if ent:IsDormant() then continue end
		if ent:IsPlayer() || ent:IsNPC() then
		ent:SetNoDraw( false )
			table.insert( badHalos, ent )
		end
	end

	halo.Add( badHalos, Color( 255, 0, 0 ), 5, 5, 1, true, true )
end )

-- Initialize
function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 0, "BladeLength" )
	self:NetworkVar( "Float", 1, "MaxLength" )
	self:NetworkVar( "Float", 2, "BladeWidth" )
	self:NetworkVar( "Float", 3, "Force" )

	if DuelForceEnabled then
		-- Aiko's Second Force Bar
		self:NetworkVar( "Float", 4, "BasicForce" )
	end

	self:NetworkVar( "Bool", 0, "DarkInner" )
	self:NetworkVar( "Bool", 1, "Enabled" )
	self:NetworkVar( "Bool", 2, "WorksUnderwater" )
	self:NetworkVar( "Int", 0, "ForceType" )
	self:NetworkVar( "Int", 1, "IncorrectPlayerModel" )
	self:NetworkVar( "Int", 2, "DrawBlade" )

	self:NetworkVar( "Vector", 0, "CrystalColor" )
	self:NetworkVar( "Vector", 1, "CrystalColor2" )
	self:NetworkVar( "String", 0, "WorldModel" )
	self:NetworkVar( "String", 1, "OnSound" )
	self:NetworkVar( "String", 2, "OffSound" )

	self:NetworkVarNotify( "DrawBlade", self.OnBladesChanged )

	if ( SERVER ) then
		self:SetBladeLength( 0 )
		self:SetBladeWidth( 2 )
		self:SetMaxLength( 42 )
		self:SetDarkInner( false )
		self:SetWorksUnderwater( true )
		self:SetEnabled( false )

		self:SetForceType( 1 )
		self:SetDrawBlade( 0 )
		self:SetForce( 100 )
		self:SetOnSound( "lightsaber/saber_on" .. math.random( 1, 4 ) .. ".wav" )
		self:SetOffSound( "lightsaber/saber_off" .. math.random( 1, 4 ) .. ".wav" )
		self:SetCrystalColor( Vector( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ) ) )
		self:SetCrystalColor2( Vector( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ) ) )
		local v, k = table.Random( list.Get( "LightsaberModels" ) )
		self:SetWorldModel( k )

		self:NetworkVarNotify( "Force", self.OnForceChanged )

		if DuelForceEnabled then
			-- Aiko's Second Force Bar
			self:SetBasicForce( 100 )
			self:NetworkVarNotify( "BasicForce", self.OnBasicForceChanged )
		end

		self:NetworkVarNotify( "Enabled", self.OnEnabledOrDisabled )
	end
end

local meta = FindMetaTable("Player")

function SWEP:LoadToolValues( ply )
	if LIGHTSABER_WHITELIST_SYSTEM then
		CheckSaber_Aiko(ply)
	end
	if ply:IsSuperAdmin() then
		self:SetMaxLength( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladel", 42 ), 1, 128 ) )
		self:SetCrystalColor( Vector( ply:GetInfo( "rb655_lightsaber_red" ), ply:GetInfo( "rb655_lightsaber_green" ), ply:GetInfo( "rb655_lightsaber_blue" ) ) )
		self:SetCrystalColor2( Vector( ply:GetInfo( "rb655_lightsaber_red1" ), ply:GetInfo( "rb655_lightsaber_green1" ), ply:GetInfo( "rb655_lightsaber_blue1" ) ) )
		self:SetBladeWidth( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladew", 2 ), 1, 8 ) )
	elseif ply:GetRegiment() == "Imperial Inquisitor" || ply:GetRegiment() == "Imperial Guard" || ply:GetRegiment() == "Imperial High Command" || ply:GetRegiment() == "Dynamic Environment" then
		self:SetMaxLength( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladel", 42 ), 32, 64 ) )
		self:SetCrystalColor( Vector( ply:GetInfo( "rb655_lightsaber_red" ), ply:GetInfo( "rb655_lightsaber_green" ), ply:GetInfo( "rb655_lightsaber_blue" ) ) )
		self:SetCrystalColor2( Vector( ply:GetInfo( "rb655_lightsaber_red1" ), ply:GetInfo( "rb655_lightsaber_green1" ), ply:GetInfo( "rb655_lightsaber_blue1" ) ) )
		self:SetBladeWidth( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladew", 2 ), 2, 4 ) )
	else
		self:SetMaxLength( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladel", 42 ), 42, 42 ) )
		self:SetCrystalColor( Vector( ply:GetInfo( "rb655_lightsaber_red" ), ply:GetInfo( "rb655_lightsaber_green" ), ply:GetInfo( "rb655_lightsaber_blue" ) ) )
		self:SetCrystalColor2( Vector( ply:GetInfo( "rb655_lightsaber_red" ), ply:GetInfo( "rb655_lightsaber_green" ), ply:GetInfo( "rb655_lightsaber_blue" ) ) )
		self:SetBladeWidth( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladew", 2 ), 2, 2 ) )
	end

	self:SetDarkInner( ply:GetInfo( "rb655_lightsaber_dark" ) == "1" )

	self:SetWorldModel( ply:GetInfo( "rb655_lightsaber_model" ) )
	self:SetModel( self:GetWorldModel() )
	self.WorldModel = self:GetWorldModel()

	self.LoopSound = ply:GetInfo( "rb655_lightsaber_humsound" )
	self.SwingSound = ply:GetInfo( "rb655_lightsaber_swingsound" )
	self:SetOnSound( ply:GetInfo( "rb655_lightsaber_onsound" ) )
	self:SetOffSound( ply:GetInfo( "rb655_lightsaber_offsound" ) )

	self.WeaponSynched = true
end


hook.Add( "PlayerSpawnedSWEP", "rb655_lightsaber_swep_sync", function( ply, wep )
	if ( wep:GetClass() != "weapon_lightsaber" ) then return end
	wep:LoadToolValues( ply )
end )

function SWEP:Initialize()
	self.LoopSound = self.LoopSound || "lightsaber/saber_loop" .. math.random( 1, 8 ) .. ".wav"
	self.SwingSound = self.SwingSound || "lightsaber/saber_swing" .. math.random( 1, 2 ) .. ".wav"

	if DuelForceEnabled then
		-- Aiko's Second Force Bar
		self._GetBasicForce = self._GetBasicForce || self.GetBasicForce
		function self:GetBasicForce(force)
			if infiniteforce_regiments[self:GetOwner():GetRegiment()] || infiniteforce_steamids[self:GetOwner():SteamID()] then
				return 100
			else
				return self:_GetBasicForce()
			end
		end
	end

	self._GetForce = self._GetForce || self.GetForce

	function self:GetForce(force)
		if infiniteforce_regiments[self:GetOwner():GetRegiment()] || infiniteforce_steamids[self:GetOwner():SteamID()] then
			return 100
		else
			return self:_GetForce()
		end
	end

	self:SetWeaponHoldType( self:GetTargetHoldType() )
end

-- Attacks

function SWEP:PrimaryAttack()
	if !IsValid(self.Owner) then return end
	self:SetNextAttack(0.5)

	local ret = hook.Run( "CanUseLightsaberForcePower", self:GetOwner(), "Saber Swing" )
	if ( ret != false ) then
		if DuelForceEnabled then
			if !self.Owner:IsNPC() && self:GetEnabled() && self.Owner:IsOnGround() then
				self.Owner:SetVelocity(self.Owner:GetAimVector() * 512)
			elseif self:GetBasicForce() > 10 && !self.Owner:IsOnGround() && self:GetEnabled() then
				self:SetBasicForce(self:GetBasicForce() - 2.5)
				self.Owner:SetVelocity(self.Owner:GetAimVector() * 512)
			end
		else
			if !self.Owner:IsNPC() && self:GetEnabled() && self.Owner:IsOnGround() then
				self.Owner:SetVelocity(self.Owner:GetAimVector() * 512)
			elseif self:GetForce() > 10 && !self.Owner:IsOnGround() && self:GetEnabled() then
				self:SetForce(self:GetForce() - 2.5)
				self.Owner:SetVelocity(self.Owner:GetAimVector() * 512)
			end
		end
	end

	self.Owner:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()
	if ( !IsValid( self.Owner ) || !self:GetActiveForcePowerType( self:GetForceType() ) ) then return end
	if ( game.SinglePlayer() && SERVER ) then self:CallOnClient( "SecondaryAttack", "" ) end

	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )
	if ( !selectedForcePower ) then return end

	local ret = hook.Run( "CanUseLightsaberForcePower", self.Owner, selectedForcePower.name )
	if ( ret == false ) then return end

	if ( selectedForcePower.action ) then
		selectedForcePower.action( self )
	end
end

local whitelistedHilts = {
	["models/dani/dani.mdl"] = true,
	["models/donation7/donation7.mdl"] = {["quillon1"] = true,},
	["models/borth-twin/borth-twin.mdl"] = true,
	["models/star/venator/inqusitor_saber.mdl"] = {back = true},
	["models/the grand saber/the grand saber.mdl"] = true,
	["models/trident/trident.mdl"] = {["quillon3"] = true,["quillon4"] = true,},
	["models/twinsaber/twinsaber.mdl"] = true,
	["models/weapons/starwars/w_maul_saber_staff_hilt.mdl"] = {back = true},
}

function SWEP:Reload()
	if ( !self.Owner:KeyPressed( IN_RELOAD ) ) then return end
	if self.Owner:KeyDown( IN_USE ) && (whitelistedHilts[self:GetModel()] == true || type(whitelistedHilts[self:GetModel()]) == "table") then
		self:SetDrawBlade(self:GetDrawBlade() == 1 && 0 || 1)
		return
	end
	if ( self.Owner:WaterLevel() > 2 && !self:GetWorksUnderwater() ) then return end
	if !self.ShouldDraw then return end

	self:SetEnabled( !self:GetEnabled() )
end

function SWEP:GetTargetHoldType()
	if ( self:GetDrawBlade() == 0 && self:GetWorldModel() == "models/weapons/starwars/w_maul_saber_staff_hilt.mdl" ) then return "knife" end
	if ( self:GetDrawBlade() == 0 && self:LookupAttachment( "blade2" ) && self:LookupAttachment( "blade2" ) > 0 ) then return "knife" end

	return "melee2"
end

-- Drop / Deploy / Holster / Enable / Disable

function SWEP:OnEnabled( bDeploy )
	if ( !self:GetEnabled() || bDeploy ) then self:PlayWeaponSound( self:GetOnSound() ) end

	if ( CLIENT || self:GetEnabled() ) then return end

	self:SetHoldType( self:GetTargetHoldType() )
	timer.Remove( "rb655_ls_ht" )

	self.SoundLoop = CreateSound( self.Owner, Sound( self.LoopSound ) )
	if ( self.SoundLoop ) then self.SoundLoop:Play() end

	self.SoundSwing = CreateSound( self.Owner, Sound( self.SwingSound ) )
	if ( self.SoundSwing ) then self.SoundSwing:Play() self.SoundSwing:ChangeVolume( 0, 0 ) end

	self.SoundHit = CreateSound( self.Owner, Sound( "lightsaber/saber_hit.wav" ) )
	if ( self.SoundHit ) then self.SoundHit:Play() self.SoundHit:ChangeVolume( 0, 0 ) end
end

function SWEP:OnDisabled( bRemoved )
	if ( CLIENT ) then
		if ( bRemoved ) then rb655_SaberClean( self:EntIndex() ) end
		return true
	end

	if ( self.SoundLoop ) then self.SoundLoop:Stop() self.SoundLoop = nil end
	if ( self.SoundSwing ) then self.SoundSwing:Stop() self.SoundSwing = nil end
	if ( self.SoundHit ) then self.SoundHit:Stop() self.SoundHit = nil end

	return true
end

function SWEP:OnEnabledOrDisabled( name, old, new )
	if ( old == new ) then return end

	if ( new ) then
		self:OnEnabled()
	else
		self:PlayWeaponSound( self:GetOffSound() )

		timer.Create( "rb655_ls_ht", 0.4, 1, function() if ( IsValid( self ) ) then self:SetHoldType( "normal" ) end end )

		self:OnDisabled()
	end
end

function SWEP:OnDrop()
	if ( self:GetEnabled() ) then self:PlayWeaponSound( self:GetOffSound() ) end
	self:OnDisabled( true )
end
function SWEP:OnRemove()
	if ( self:GetEnabled() && IsValid( self.Owner ) ) then self:PlayWeaponSound( self:GetOffSound() ) end
	self:OnDisabled( true )
end

function SWEP:Deploy()

	local ply = self.Owner

	ply.selectedAbilities = ply.selectedAbilities || {}

	if ( ply:IsPlayer() && !ply:IsBot() && !self.WeaponSynched && SERVER && GAMEMODE.IsSandboxDerived ) then
		self:LoadToolValues( ply )
	end

	if ( self:GetEnabled() ) then self:OnEnabled( true ) else self:SetHoldType( "normal" ) end

	if ( CLIENT ) then return end

	if ( ply:IsPlayer() && ply:FlashlightIsOn() ) then ply:Flashlight( false ) end

	self:SetBladeLength( 0 )

	return true
end

function SWEP:Holster()
	if ( self:GetEnabled() ) then self:PlayWeaponSound( self:GetOffSound() ) end

	return self:OnDisabled( true )
end

function SWEP:GetSaberPosAng( num, side )
	num = num || 1

	if ( SERVER ) then self:SetIncorrectPlayerModel( 0 ) end

	if ( IsValid( self.Owner ) ) then
		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		local attachment = self:LookupAttachment( "blade" .. num )
		if ( side ) then
			attachment = self:LookupAttachment( "quillon" .. num )
		end

		if ( !bone && SERVER ) then
			self:SetIncorrectPlayerModel( 1 )
		end

		if ( attachment && attachment > 0 ) then
			local PosAng = self:GetAttachment( attachment )

			if ( !bone && SERVER ) then
				PosAng.Pos = PosAng.Pos + Vector( 0, 0, 36 )
				if IsValid( self.Owner ) && self.Owner:IsPlayer() && self.Owner:Crouching() then PosAng.Pos = PosAng.Pos - Vector( 0, 0, 18 ) end
				PosAng.Ang.p = 0
			end

			return PosAng.Pos, PosAng.Ang:Forward()
		end

		if ( bone ) then
			local pos, ang = self.Owner:GetBonePosition( bone )
			if ( pos == self.Owner:GetPos() ) then
				local matrix = self.Owner:GetBoneMatrix( bone )
				if ( matrix ) then
					pos = matrix:GetTranslation()
					ang = matrix:GetAngles()
				else
					self:SetIncorrectPlayerModel( 1 )
				end
			end

			ang:RotateAroundAxis( ang:Forward(), 180 )
			ang:RotateAroundAxis( ang:Up(), 30 )
			ang:RotateAroundAxis( ang:Forward(), -5.7 )
			ang:RotateAroundAxis( ang:Right(), 92 )

			pos = pos + ang:Up() * -3.3 + ang:Right() * 0.8 + ang:Forward() * 5.6

			return pos, ang:Forward()
		end

		self:SetIncorrectPlayerModel( 1 )
	else
		self:SetIncorrectPlayerModel( 2 )
	end

	if ( self:GetIncorrectPlayerModel() == 0 ) then self:SetIncorrectPlayerModel( 1 ) end

	local defAng = self:GetAngles()
	defAng.p = 0

	local defPos = self:GetPos() + defAng:Right() * 0.6 - defAng:Up() * 0.2 + defAng:Forward() * 0.8
	if ( SERVER ) then defPos = defPos + Vector( 0, 0, 36 ) end
	if ( SERVER && IsValid( self.Owner ) && self.Owner:Crouching() ) then defPos = defPos - Vector( 0, 0, 18 ) end

	return defPos, -defAng:Forward()
end

function SWEP:OnForceChanged( name, old, new )
	if ( old > new ) then
		self.NextForce = CurTime() + 4
	end
end

function SWEP:OnBladesChanged( name, old, new )
	timer.Simple(0.01, function()
		if self:GetEnabled() != true then return end
		self:SetWeaponHoldType( self:GetTargetHoldType() )
	end)
end

if DuelForceEnabled then
	-- Aiko's Second Force Bar
	function SWEP:OnBasicForceChanged( name, old, new )
		if ( old > new ) then
			self.NextBasicForce = CurTime() + 4
		end
	end
end

meta = FindMetaTable("Player")

if SERVER then
	util.AddNetworkString( "sendblockstart" )
	util.AddNetworkString( "sendblockstart2" )
	util.AddNetworkString( "sendblockend" )
	util.AddNetworkString( "resetblock" )
	util.AddNetworkString( "sabershoulddraw" )
end

function meta:SetSaberShouldDraw( bool )
	local wep = self:GetActiveWeapon()
	wep.ShouldDraw = true
	net.Start( "sabershoulddraw" )
	net.WriteEntity( wep )
	net.WriteBool( bool )
	net.Broadcast()
end

if CLIENT then
	net.Receive( "sabershoulddraw", function()
		net.ReadEntity().ShouldDraw = net.ReadBool()
	end )
end

function meta:SetSaberBlock( default, startend )
	self.prevblockanim = default || math.random( 1, 3 )
	if startend == "start" then
		self.isblockanim = true
		net.Start( "sendblockstart2" )
		net.WriteEntity( self )
		net.WriteUInt( self.prevblockanim, 3 )
		net.Broadcast()
	return elseif startend == "end" then
		net.Start( "sendblockend" )
		net.WriteEntity( self )
		net.WriteUInt( self.prevblockanim, 3 )
		net.Broadcast()
		self.isblockanim = false
	return end
	if self.isblockanim then return end
	self.isblockanim = true
	net.Start( "sendblockstart" )
	net.WriteEntity( self )
	net.WriteUInt( self.prevblockanim, 3 )
	net.Broadcast()
	timer.Simple( 0.3, function() self.isblockanim = false end )
end

function meta:ResetAnimations()
	net.Start( "resetblock" )
	net.WriteEntity( self )
	net.Broadcast()
end

local animtablestart = {
	[ 1 ] = function( self, bone )
		timer.Simple( 0, function() self:ManipulateBoneAngles( bone, Angle( 5, 0, -5 ) ) self.animblocking = true end )
		timer.Simple( 0.01, function() self:ManipulateBoneAngles( bone, Angle( 10, 0, -10 ) ) end )
		timer.Simple( 0.02, function() self:ManipulateBoneAngles( bone, Angle( 15, 0, -15 ) ) end )
		timer.Simple( 0.03, function() self:ManipulateBoneAngles( bone, Angle( 20, 0, -20 ) ) end )
		timer.Simple( 0.04, function() self:ManipulateBoneAngles( bone, Angle( 25, 0, -25 ) ) end )
		timer.Simple( 0.05, function() self:ManipulateBoneAngles( bone, Angle( 30, 0, -30 ) ) end )
		timer.Simple( 0.055, function() self:ManipulateBoneAngles( bone, Angle( 35, 0, -30 ) ) end )
		timer.Simple( 0.06, function() self:ManipulateBoneAngles( bone, Angle( 40, 0, -35 ) ) end )
		timer.Simple( 0.065, function() self:ManipulateBoneAngles( bone, Angle( 45, 0, -35 ) ) end )
		timer.Simple( 0.07, function() self:ManipulateBoneAngles( bone, Angle( 50, 0, -40 ) ) end )
		timer.Simple( 0.08, function() self:ManipulateBoneAngles( bone, Angle( 55, 0, -45 ) ) end )
		timer.Simple( 0.09, function() self:ManipulateBoneAngles( bone, Angle( 60, 0, -50 ) ) end )
		timer.Simple( 0.0925, function() self:ManipulateBoneAngles( bone, Angle( 67, 0, -55 ) ) end )
		timer.Simple( 0.095, function() self:ManipulateBoneAngles( bone, Angle( 75, 0, -60 ) ) end )
		timer.Simple( 0.0975, function() self:ManipulateBoneAngles( bone, Angle( 83, 0, -60 ) ) end )
		timer.Simple( 0.1, function() self:ManipulateBoneAngles( bone, Angle( 90, 0, -60 ) ) end )
	end,
	[ 2 ] = function( self, bone )
		timer.Simple( 0, function() self:ManipulateBoneAngles( bone, Angle( 5, 5, 0 ) ) self.animblocking = true end )
		timer.Simple( 0.01, function() self:ManipulateBoneAngles( bone, Angle( 10, 10, 0 ) ) end )
		timer.Simple( 0.02, function() self:ManipulateBoneAngles( bone, Angle( 15, 15, 0 ) ) end )
		timer.Simple( 0.03, function() self:ManipulateBoneAngles( bone, Angle( 20, 20, 0 ) ) end )
		timer.Simple( 0.04, function() self:ManipulateBoneAngles( bone, Angle( 25, 25, 0 ) ) end )
		timer.Simple( 0.05, function() self:ManipulateBoneAngles( bone, Angle( 30, 30, 0 ) ) end )
		timer.Simple( 0.055, function() self:ManipulateBoneAngles( bone, Angle( 35, 35, 0 ) ) end )
		timer.Simple( 0.06, function() self:ManipulateBoneAngles( bone, Angle( 40, 40, 10 ) ) end )
		timer.Simple( 0.065, function() self:ManipulateBoneAngles( bone, Angle( 50, 45, 30 ) ) end )
		timer.Simple( 0.07, function() self:ManipulateBoneAngles( bone, Angle( 60, 50, 45 ) ) end )
		timer.Simple( 0.08, function() self:ManipulateBoneAngles( bone, Angle( 70, 55, 55 ) ) end )
		timer.Simple( 0.09, function() self:ManipulateBoneAngles( bone, Angle( 80, 60, 60 ) ) end )
		timer.Simple( 0.0925, function() self:ManipulateBoneAngles( bone, Angle( 90, 67, 67 ) ) end )
		timer.Simple( 0.095, function() self:ManipulateBoneAngles( bone, Angle( 100, 80, 80 ) ) end )
		timer.Simple( 0.0975, function() self:ManipulateBoneAngles( bone, Angle( 110, 95, 90 ) ) end )
		timer.Simple( 0.1, function() self:ManipulateBoneAngles( bone, Angle( 120, 110, 90 ) ) end )
	end,
	[ 3 ] = function( self, bone )
		timer.Simple( 0, function() self:ManipulateBoneAngles( bone, Angle( 5, 5, 0 ) ) self.animblocking = true end )
		timer.Simple( 0.01, function() self:ManipulateBoneAngles( bone, Angle( 10, 10, 0 ) ) end )
		timer.Simple( 0.02, function() self:ManipulateBoneAngles( bone, Angle( 15, 15, 0 ) ) end )
		timer.Simple( 0.03, function() self:ManipulateBoneAngles( bone, Angle( 20, 20, 0 ) ) end )
		timer.Simple( 0.04, function() self:ManipulateBoneAngles( bone, Angle( 25, 25, 0 ) ) end )
		timer.Simple( 0.05, function() self:ManipulateBoneAngles( bone, Angle( 30, 30, 0 ) ) end )
		timer.Simple( 0.055, function() self:ManipulateBoneAngles( bone, Angle( 35, 35, 0 ) ) end )
		timer.Simple( 0.06, function() self:ManipulateBoneAngles( bone, Angle( 40, 40, 0 ) ) end )
		timer.Simple( 0.065, function() self:ManipulateBoneAngles( bone, Angle( 45, 45, 0 ) ) end )
		timer.Simple( 0.07, function() self:ManipulateBoneAngles( bone, Angle( 50, 50, 0 ) ) end )
		timer.Simple( 0.08, function() self:ManipulateBoneAngles( bone, Angle( 55, 55, 0 ) ) end )
		timer.Simple( 0.09, function() self:ManipulateBoneAngles( bone, Angle( 60, 60, 0 ) ) end )
		timer.Simple( 0.0925, function() self:ManipulateBoneAngles( bone, Angle( 67, 67, 0 ) ) end )
		timer.Simple( 0.095, function() self:ManipulateBoneAngles( bone, Angle( 80, 80, 0 ) ) end )
		timer.Simple( 0.0975, function() self:ManipulateBoneAngles( bone, Angle( 95, 95, 0 ) ) end )
		timer.Simple( 0.1, function() self:ManipulateBoneAngles( bone, Angle( 110, 110, 0 ) ) end )
	end,
}

local animtableend = {
	[ 1 ] = function( self, bone )
		timer.Simple( 0.22, function() self:ManipulateBoneAngles( bone, Angle( 83, 0, -55 ) ) end )
		timer.Simple( 0.2325, function() self:ManipulateBoneAngles( bone, Angle( 75, 0, -50 ) ) end )
		timer.Simple( 0.235, function() self:ManipulateBoneAngles( bone, Angle( 70, 0, -45 ) ) end )
		timer.Simple( 0.24, function() self:ManipulateBoneAngles( bone, Angle( 60, 0, -40 ) ) end )
		timer.Simple( 0.25, function() self:ManipulateBoneAngles( bone, Angle( 50, 0, -40 ) ) end )
		timer.Simple( 0.2525, function() self:ManipulateBoneAngles( bone, Angle( 45, 0, -35 ) ) end )
		timer.Simple( 0.255, function() self:ManipulateBoneAngles( bone, Angle( 40, 0, -30 ) ) end )
		timer.Simple( 0.2575, function() self:ManipulateBoneAngles( bone, Angle( 35, 0, -25 ) ) end )
		timer.Simple( 0.26, function() self:ManipulateBoneAngles( bone, Angle( 30, 0, -20 ) ) end )
		timer.Simple( 0.27, function() self:ManipulateBoneAngles( bone, Angle( 25, 0, -20 ) ) end )
		timer.Simple( 0.275, function() self:ManipulateBoneAngles( bone, Angle( 20, 0, -15 ) ) end )
		timer.Simple( 0.28, function() self:ManipulateBoneAngles( bone, Angle( 15, 0, -10 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 10, 0, -5 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 5, 0, 0 ) ) end )
		timer.Simple( 0.3, function() self:ManipulateBoneAngles( bone, Angle( 0, 0, 0 ) ) self.animblocking = false end )
	end,
	[ 2 ] = function( self, bone )
		timer.Simple( 0.22, function() self:ManipulateBoneAngles( bone, Angle( 110, 95, 90 ) ) end )
		timer.Simple( 0.2325, function() self:ManipulateBoneAngles( bone, Angle( 100, 80, 80 ) ) end )
		timer.Simple( 0.235, function() self:ManipulateBoneAngles( bone, Angle( 90, 70, 70 ) ) end )
		timer.Simple( 0.24, function() self:ManipulateBoneAngles( bone, Angle( 80, 60, 60 ) ) end )
		timer.Simple( 0.25, function() self:ManipulateBoneAngles( bone, Angle( 70, 50, 50 ) ) end )
		timer.Simple( 0.2525, function() self:ManipulateBoneAngles( bone, Angle( 60, 45, 45 ) ) end )
		timer.Simple( 0.255, function() self:ManipulateBoneAngles( bone, Angle( 50, 40, 40 ) ) end )
		timer.Simple( 0.2575, function() self:ManipulateBoneAngles( bone, Angle( 40, 35, 35 ) ) end )
		timer.Simple( 0.26, function() self:ManipulateBoneAngles( bone, Angle( 30, 30, 30 ) ) end )
		timer.Simple( 0.27, function() self:ManipulateBoneAngles( bone, Angle( 25, 25, 25 ) ) end )
		timer.Simple( 0.275, function() self:ManipulateBoneAngles( bone, Angle( 20, 20, 20 ) ) end )
		timer.Simple( 0.28, function() self:ManipulateBoneAngles( bone, Angle( 15, 15, 15 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 10, 10, 10 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 5, 5, 5 ) ) end )
		timer.Simple( 0.3, function() self:ManipulateBoneAngles( bone, Angle( 0, 0, 0 ) ) self.animblocking = false end )
	end,
	[ 3 ] = function( self, bone )
		timer.Simple( 0.22, function() self:ManipulateBoneAngles( bone, Angle( 95, 95, 0 ) ) end )
		timer.Simple( 0.2325, function() self:ManipulateBoneAngles( bone, Angle( 80, 80, 0 ) ) end )
		timer.Simple( 0.235, function() self:ManipulateBoneAngles( bone, Angle( 70, 70, 0 ) ) end )
		timer.Simple( 0.24, function() self:ManipulateBoneAngles( bone, Angle( 60, 60, 0 ) ) end )
		timer.Simple( 0.25, function() self:ManipulateBoneAngles( bone, Angle( 50, 50, 0 ) ) end )
		timer.Simple( 0.2525, function() self:ManipulateBoneAngles( bone, Angle( 45, 45, 0 ) ) end )
		timer.Simple( 0.255, function() self:ManipulateBoneAngles( bone, Angle( 40, 40, 0 ) ) end )
		timer.Simple( 0.2575, function() self:ManipulateBoneAngles( bone, Angle( 35, 35, 0 ) ) end )
		timer.Simple( 0.26, function() self:ManipulateBoneAngles( bone, Angle( 30, 30, 0 ) ) end )
		timer.Simple( 0.27, function() self:ManipulateBoneAngles( bone, Angle( 25, 25, 0 ) ) end )
		timer.Simple( 0.275, function() self:ManipulateBoneAngles( bone, Angle( 20, 20, 0 ) ) end )
		timer.Simple( 0.28, function() self:ManipulateBoneAngles( bone, Angle( 15, 15, 0 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 10, 10, 0 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 5, 5, 0 ) ) end )
		timer.Simple( 0.3, function() self:ManipulateBoneAngles( bone, Angle( 0, 0, 0 ) ) self.animblocking = false end )
	end,
}

local animtable = {
	[ 1 ] = function( self, bone )
		timer.Simple( 0, function() self:ManipulateBoneAngles( bone, Angle( 5, 0, -5 ) ) self.animblocking = true end )
		timer.Simple( 0.01, function() self:ManipulateBoneAngles( bone, Angle( 10, 0, -10 ) ) end )
		timer.Simple( 0.02, function() self:ManipulateBoneAngles( bone, Angle( 15, 0, -15 ) ) end )
		timer.Simple( 0.03, function() self:ManipulateBoneAngles( bone, Angle( 20, 0, -20 ) ) end )
		timer.Simple( 0.04, function() self:ManipulateBoneAngles( bone, Angle( 25, 0, -25 ) ) end )
		timer.Simple( 0.05, function() self:ManipulateBoneAngles( bone, Angle( 30, 0, -30 ) ) end )
		timer.Simple( 0.055, function() self:ManipulateBoneAngles( bone, Angle( 35, 0, -30 ) ) end )
		timer.Simple( 0.06, function() self:ManipulateBoneAngles( bone, Angle( 40, 0, -35 ) ) end )
		timer.Simple( 0.065, function() self:ManipulateBoneAngles( bone, Angle( 45, 0, -35 ) ) end )
		timer.Simple( 0.07, function() self:ManipulateBoneAngles( bone, Angle( 50, 0, -40 ) ) end )
		timer.Simple( 0.08, function() self:ManipulateBoneAngles( bone, Angle( 55, 0, -45 ) ) end )
		timer.Simple( 0.09, function() self:ManipulateBoneAngles( bone, Angle( 60, 0, -50 ) ) end )
		timer.Simple( 0.0925, function() self:ManipulateBoneAngles( bone, Angle( 67, 0, -55 ) ) end )
		timer.Simple( 0.095, function() self:ManipulateBoneAngles( bone, Angle( 75, 0, -60 ) ) end )
		timer.Simple( 0.0975, function() self:ManipulateBoneAngles( bone, Angle( 83, 0, -60 ) ) end )
		timer.Simple( 0.1, function() self:ManipulateBoneAngles( bone, Angle( 90, 0, -60 ) ) end )
		timer.Simple( 0.22, function() self:ManipulateBoneAngles( bone, Angle( 83, 0, -55 ) ) end )
		timer.Simple( 0.2325, function() self:ManipulateBoneAngles( bone, Angle( 75, 0, -50 ) ) end )
		timer.Simple( 0.235, function() self:ManipulateBoneAngles( bone, Angle( 70, 0, -45 ) ) end )
		timer.Simple( 0.24, function() self:ManipulateBoneAngles( bone, Angle( 60, 0, -40 ) ) end )
		timer.Simple( 0.25, function() self:ManipulateBoneAngles( bone, Angle( 50, 0, -40 ) ) end )
		timer.Simple( 0.2525, function() self:ManipulateBoneAngles( bone, Angle( 45, 0, -35 ) ) end )
		timer.Simple( 0.255, function() self:ManipulateBoneAngles( bone, Angle( 40, 0, -30 ) ) end )
		timer.Simple( 0.2575, function() self:ManipulateBoneAngles( bone, Angle( 35, 0, -25 ) ) end )
		timer.Simple( 0.26, function() self:ManipulateBoneAngles( bone, Angle( 30, 0, -20 ) ) end )
		timer.Simple( 0.27, function() self:ManipulateBoneAngles( bone, Angle( 25, 0, -20 ) ) end )
		timer.Simple( 0.275, function() self:ManipulateBoneAngles( bone, Angle( 20, 0, -15 ) ) end )
		timer.Simple( 0.28, function() self:ManipulateBoneAngles( bone, Angle( 15, 0, -10 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 10, 0, -5 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 5, 0, 0 ) ) end )
		timer.Simple( 0.3, function() self:ManipulateBoneAngles( bone, Angle( 0, 0, 0 ) ) self.animblocking = false end )
	end,
	[ 2 ] = function( self, bone )
		timer.Simple( 0, function() self:ManipulateBoneAngles( bone, Angle( 5, 5, 0 ) ) self.animblocking = true end )
		timer.Simple( 0.01, function() self:ManipulateBoneAngles( bone, Angle( 10, 10, 0 ) ) end )
		timer.Simple( 0.02, function() self:ManipulateBoneAngles( bone, Angle( 15, 15, 0 ) ) end )
		timer.Simple( 0.03, function() self:ManipulateBoneAngles( bone, Angle( 20, 20, 0 ) ) end )
		timer.Simple( 0.04, function() self:ManipulateBoneAngles( bone, Angle( 25, 25, 0 ) ) end )
		timer.Simple( 0.05, function() self:ManipulateBoneAngles( bone, Angle( 30, 30, 0 ) ) end )
		timer.Simple( 0.055, function() self:ManipulateBoneAngles( bone, Angle( 35, 35, 0 ) ) end )
		timer.Simple( 0.06, function() self:ManipulateBoneAngles( bone, Angle( 40, 40, 10 ) ) end )
		timer.Simple( 0.065, function() self:ManipulateBoneAngles( bone, Angle( 50, 45, 30 ) ) end )
		timer.Simple( 0.07, function() self:ManipulateBoneAngles( bone, Angle( 60, 50, 45 ) ) end )
		timer.Simple( 0.08, function() self:ManipulateBoneAngles( bone, Angle( 70, 55, 55 ) ) end )
		timer.Simple( 0.09, function() self:ManipulateBoneAngles( bone, Angle( 80, 60, 60 ) ) end )
		timer.Simple( 0.0925, function() self:ManipulateBoneAngles( bone, Angle( 90, 67, 67 ) ) end )
		timer.Simple( 0.095, function() self:ManipulateBoneAngles( bone, Angle( 100, 80, 80 ) ) end )
		timer.Simple( 0.0975, function() self:ManipulateBoneAngles( bone, Angle( 110, 95, 90 ) ) end )
		timer.Simple( 0.1, function() self:ManipulateBoneAngles( bone, Angle( 120, 110, 90 ) ) end )
		timer.Simple( 0.22, function() self:ManipulateBoneAngles( bone, Angle( 110, 95, 90 ) ) end )
		timer.Simple( 0.2325, function() self:ManipulateBoneAngles( bone, Angle( 100, 80, 80 ) ) end )
		timer.Simple( 0.235, function() self:ManipulateBoneAngles( bone, Angle( 90, 70, 70 ) ) end )
		timer.Simple( 0.24, function() self:ManipulateBoneAngles( bone, Angle( 80, 60, 60 ) ) end )
		timer.Simple( 0.25, function() self:ManipulateBoneAngles( bone, Angle( 70, 50, 50 ) ) end )
		timer.Simple( 0.2525, function() self:ManipulateBoneAngles( bone, Angle( 60, 45, 45 ) ) end )
		timer.Simple( 0.255, function() self:ManipulateBoneAngles( bone, Angle( 50, 40, 40 ) ) end )
		timer.Simple( 0.2575, function() self:ManipulateBoneAngles( bone, Angle( 40, 35, 35 ) ) end )
		timer.Simple( 0.26, function() self:ManipulateBoneAngles( bone, Angle( 30, 30, 30 ) ) end )
		timer.Simple( 0.27, function() self:ManipulateBoneAngles( bone, Angle( 25, 25, 25 ) ) end )
		timer.Simple( 0.275, function() self:ManipulateBoneAngles( bone, Angle( 20, 20, 20 ) ) end )
		timer.Simple( 0.28, function() self:ManipulateBoneAngles( bone, Angle( 15, 15, 15 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 10, 10, 10 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 5, 5, 5 ) ) end )
		timer.Simple( 0.3, function() self:ManipulateBoneAngles( bone, Angle( 0, 0, 0 ) ) self.animblocking = false end )
	end,
	[ 3 ] = function( self, bone )
		timer.Simple( 0, function() self:ManipulateBoneAngles( bone, Angle( 5, 5, 0 ) ) self.animblocking = true end )
		timer.Simple( 0.01, function() self:ManipulateBoneAngles( bone, Angle( 10, 10, 0 ) ) end )
		timer.Simple( 0.02, function() self:ManipulateBoneAngles( bone, Angle( 15, 15, 0 ) ) end )
		timer.Simple( 0.03, function() self:ManipulateBoneAngles( bone, Angle( 20, 20, 0 ) ) end )
		timer.Simple( 0.04, function() self:ManipulateBoneAngles( bone, Angle( 25, 25, 0 ) ) end )
		timer.Simple( 0.05, function() self:ManipulateBoneAngles( bone, Angle( 30, 30, 0 ) ) end )
		timer.Simple( 0.055, function() self:ManipulateBoneAngles( bone, Angle( 35, 35, 0 ) ) end )
		timer.Simple( 0.06, function() self:ManipulateBoneAngles( bone, Angle( 40, 40, 0 ) ) end )
		timer.Simple( 0.065, function() self:ManipulateBoneAngles( bone, Angle( 45, 45, 0 ) ) end )
		timer.Simple( 0.07, function() self:ManipulateBoneAngles( bone, Angle( 50, 50, 0 ) ) end )
		timer.Simple( 0.08, function() self:ManipulateBoneAngles( bone, Angle( 55, 55, 0 ) ) end )
		timer.Simple( 0.09, function() self:ManipulateBoneAngles( bone, Angle( 60, 60, 0 ) ) end )
		timer.Simple( 0.0925, function() self:ManipulateBoneAngles( bone, Angle( 67, 67, 0 ) ) end )
		timer.Simple( 0.095, function() self:ManipulateBoneAngles( bone, Angle( 80, 80, 0 ) ) end )
		timer.Simple( 0.0975, function() self:ManipulateBoneAngles( bone, Angle( 95, 95, 0 ) ) end )
		timer.Simple( 0.1, function() self:ManipulateBoneAngles( bone, Angle( 110, 110, 0 ) ) end )
		timer.Simple( 0.22, function() self:ManipulateBoneAngles( bone, Angle( 95, 95, 0 ) ) end )
		timer.Simple( 0.2325, function() self:ManipulateBoneAngles( bone, Angle( 80, 80, 0 ) ) end )
		timer.Simple( 0.235, function() self:ManipulateBoneAngles( bone, Angle( 70, 70, 0 ) ) end )
		timer.Simple( 0.24, function() self:ManipulateBoneAngles( bone, Angle( 60, 60, 0 ) ) end )
		timer.Simple( 0.25, function() self:ManipulateBoneAngles( bone, Angle( 50, 50, 0 ) ) end )
		timer.Simple( 0.2525, function() self:ManipulateBoneAngles( bone, Angle( 45, 45, 0 ) ) end )
		timer.Simple( 0.255, function() self:ManipulateBoneAngles( bone, Angle( 40, 40, 0 ) ) end )
		timer.Simple( 0.2575, function() self:ManipulateBoneAngles( bone, Angle( 35, 35, 0 ) ) end )
		timer.Simple( 0.26, function() self:ManipulateBoneAngles( bone, Angle( 30, 30, 0 ) ) end )
		timer.Simple( 0.27, function() self:ManipulateBoneAngles( bone, Angle( 25, 25, 0 ) ) end )
		timer.Simple( 0.275, function() self:ManipulateBoneAngles( bone, Angle( 20, 20, 0 ) ) end )
		timer.Simple( 0.28, function() self:ManipulateBoneAngles( bone, Angle( 15, 15, 0 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 10, 10, 0 ) ) end )
		timer.Simple( 0.29, function() self:ManipulateBoneAngles( bone, Angle( 5, 5, 0 ) ) end )
		timer.Simple( 0.3, function() self:ManipulateBoneAngles( bone, Angle( 0, 0, 0 ) ) self.animblocking = false end )
	end,
}

if CLIENT then
	net.Receive( "sendblockstart", function()
		local ply = net.ReadEntity()
		local type = net.ReadUInt( 3 )
		if !ply || !IsValid( ply ) then return end
		local bone = ply:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
		if !bone || bone < 0 then return end
		local rand = type || math.random( 1, 3 )
		animtable[ rand ]( ply, bone )
	end )
	net.Receive( "sendblockstart2", function()
		local ply = net.ReadEntity()
		local type = net.ReadUInt( 3 )
		if !ply || !IsValid( ply ) then return end
		local bone = ply:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
		if !bone || bone < 0 then return end
		local rand = type || math.random( 1, 3 )
		animtablestart[ rand ]( ply, bone )
	end )
	net.Receive( "sendblockend", function()
		local ply = net.ReadEntity()
		local type = net.ReadUInt( 3 )
		if !ply || !IsValid( ply ) then return end
		local bone = ply:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
		if !bone || bone < 0 then return end
		local rand = type || math.random( 1, 3 )
		animtableend[ rand ]( ply, bone )
	end )
	net.Receive( "resetblock", function()
		local ply = net.ReadEntity()
		if !ply || !IsValid( ply ) then return end
		local bone = ply:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
		if !bone || bone < 0 then return end
		ply:ManipulateBoneAngles( bone, Angle( 0, 0, 0 ) )
		ply.animblocking = false
	end )
end

hook.Add( "PlayerSpawn", "ResetAnimationsOnSpawn", function( ply )
	timer.Simple( 1, function()
		ply:ResetAnimations()
		ply.isblockanim = false
	end )
end )

hook.Add( "CanLightsaberDamageEntity", "BlockLightsaberDamageBlock", function( ent, wep, tr )
	if wep.Owner.isblockanim then return false end
	if ent.IsBlocking then
		local angle = ( wep.Owner:GetPos() - ent:GetPos() ):Angle()
		if ( math.AngleDifference( angle.y, ent:EyeAngles().y ) > 60 ) || ( math.AngleDifference( angle.y, ent:EyeAngles().y ) < -60 ) then return end
		ent:GetActiveWeapon():SetForce( ent:GetActiveWeapon():GetForce() - 1																																																																																					   )
		wep:PlayWeaponSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
		if ent.isblockanim then
			timer.Remove( "ResetBlock" .. ent:SteamID() )
			timer.Create( "ResetBlock" .. ent:SteamID(), 0.2, 1, function()
				if !IsValid( ent ) || ent:Health() < 1 then return end
				ent:SetSaberBlock( rand, "end" )
				ent:GetActiveWeapon():SetNextAttack( 0.3 )
			end )
			return false
		end
		ent:GetActiveWeapon():SetForce( ent:GetActiveWeapon():GetForce() - 1																																																																																					  )
		local bone = ent:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
		ent:SetSaberBlock( 1, "start" )
		ent:GetActiveWeapon():SetNextAttack( math.huge )
		timer.Remove( "ResetBlock" .. ent:SteamID() )
		timer.Create( "ResetBlock" .. ent:SteamID(), 0.2, 1, function()
			if !IsValid( ent ) || ent:Health() < 1 then return end
			ent:SetSaberBlock( 1, "end" )
			ent:GetActiveWeapon():SetNextAttack( 0.3 )
		end )
		return false
	end
end )

hook.Add( "ScalePlayerDamage", "BlockingDamageScale", function( ent, hitgroup, dmginfo )
	if !ent:IsPlayer() then return end
	local wep = ent:GetActiveWeapon()
	if ( IsValid( ent ) && IsValid( wep ) && wep.IsLightsaber ) && ent.IsBlocking && dmginfo:IsDamageType( DMG_BULLET ) || dmginfo:IsDamageType( DMG_SHOCK ) then
		if wep:GetForce() < 1 then return end
		local angle = ( dmginfo:GetAttacker():GetPos() - ent:GetPos() ):Angle()
		if ( math.AngleDifference( angle.y, ent:EyeAngles().y ) <= 40 ) && ( math.AngleDifference( angle.y, ent:EyeAngles().y ) >= -40 ) then
			if IsValid( dmginfo:GetInflictor() ) && dmginfo:GetInflictor():IsPlayer() && IsValid( dmginfo:GetInflictor():GetActiveWeapon() ) && dmginfo:GetInflictor():GetActiveWeapon().IsLightsaber then
				dmginfo:SetDamage( 0 )
				wep:SetForce( wep:GetForce() - 0.1 )
				ent:SetSaberBlock()
				return
			end
			local bullet = {}
			bullet.Num 		= 1
			bullet.Src 		= ent:EyePos()
			bullet.Dir 		= ent:GetAimVector()
			bullet.Spread 	= Vector( 0.13, 0.13, 0 )
			bullet.Tracer	= 1
			bullet.HullSize	= 5
			bullet.Force	= 0
			bullet.Attacker	= ent
			bullet.Damage	= dmginfo:GetDamage()
			if bullet.Damage < 0 then bullet.Damage = bullet.Damage * -1 end
			bullet.AmmoType = "Pistol"
			bullet.TracerName = wep.Tracer || wep.TracerName || "Ar2Tracer"
			ent:FireBullets( bullet )
			wep:PlayWeaponSound( "lightsaber/saber_hit_laser" .. math.random( 1, 4 ) .. ".wav" )
			dmginfo:SetDamage( 0 )
			wep:SetForce( wep:GetForce() - 0.2 )
			if ent.isblockanim then return end
			ent:SetSaberBlock()
			wep:SetNextAttack( 0.3 )
			return true
		end
	end
end )

hook.Add( "PlayerDeath", "FixBlockingAfterDeath", function( victim, inflictor, attacker )
	victim.IsBlocking = false
end )

function SWEP:Think()
	if self.Owner:SteamID() == "STEAM_0:1:45778562" || self.Owner:SteamID() == "STEAM_0:1:46112709" then
		local r = math.random(0,255)
		local g = math.random(0,255)
		local b = math.random(0,255)
		self:SetCrystalColor(Vector(r,g,b))
		self:SetCrystalColor2(Vector(r,g,b))
	end
	self.WorldModel = self:GetWorldModel()
	self:SetModel( self:GetWorldModel() )

	if self.Owner:KeyDown( IN_WALK ) && self:GetForce() > 0.1 && self:GetEnabled() then
		self:SetForce( self:GetForce() - 0.01 )
		self.Owner.IsBlocking = true
		self.Owner:SetNWBool( "IsBlocking", true )
	else
		self.Owner.IsBlocking = false
		self.Owner:SetNWBool( "IsBlocking", false )
	end

	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )
	if ( selectedForcePower && selectedForcePower.think && !self.Owner:KeyDown( IN_USE ) ) then
		local ret = hook.Run( "CanUseLightsaberForcePower", self.Owner, selectedForcePower.name )
		if ( ret != false && selectedForcePower.think ) then
			selectedForcePower.think( self )
		end
	end

	if ( CLIENT ) then return true end

	if ( ( self.NextForce || 0 ) < CurTime() ) then
		self:SetForce( math.min( self:GetForce() + 0.5, 100 ) )
	end

	if DuelForceEnabled && ( self.NextBasicForce || 0 ) < CurTime() then
		self:SetBasicForce( math.min( self:GetBasicForce() + 0.5, 100 ) )
	end

	if ( !self:GetEnabled() && self:GetBladeLength() != 0 ) then
		self:SetBladeLength( math.Approach( self:GetBladeLength(), 0, 2 ) )
	elseif ( self:GetEnabled() && self:GetBladeLength() != self:GetMaxLength() ) then
		self:SetBladeLength( math.Approach( self:GetBladeLength(), self:GetMaxLength(), 8 ) )
	end

	if ( self:GetEnabled() && !self:GetWorksUnderwater() && self.Owner:WaterLevel() > 2 ) then
		self:SetEnabled( false )
	end

	if ( self:GetBladeLength() <= 0 ) then return end

	-- DAMAGE
	if !self.Owner.isblockanim then
		local isTrace1Hit = false
		local allowFrontBlade = true
		if self:GetDrawBlade() != 0 && type(whitelistedHilts[self:GetModel()]) == "table" && whitelistedHilts[self:GetModel()].back then
			allowFrontBlade = false
		end
		if allowFrontBlade then
			local pos, ang = self:GetSaberPosAng()
			local trace = util.TraceLine( {
				start = pos,
				endpos = pos + ang * self:GetBladeLength(),
				filter = { self, self.Owner },
			} )
			local traceBack = util.TraceLine( {
				start = pos + ang * self:GetBladeLength(),
				endpos = pos,
				filter = { self, self.Owner },
			} )

			if ( trace.HitSky || ( trace.StartSolid && trace.HitWorld ) ) then trace.Hit = false end
			if ( traceBack.HitSky || ( traceBack.StartSolid && traceBack.HitWorld ) ) then traceBack.Hit = false end

			self:DrawHitEffects( trace, traceBack )
			isTrace1Hit = trace.Hit || traceBack.Hit

			if ( traceBack.Entity == trace.Entity && IsValid( trace.Entity ) ) then traceBack.Hit = false end

			if ( trace.Hit ) then rb655_LS_DoDamage( trace, self ) end
			if ( traceBack.Hit ) then rb655_LS_DoDamage( traceBack, self ) end
		end
		local isTrace2Hit = false
		if !allowFrontBlade || ( self:GetDrawBlade() == 0 && self:LookupAttachment( "blade2" ) > 0 ) then
			local pos2, dir2 = self:GetSaberPosAng( 2 )
			local trace2 = util.TraceLine( {
				start = pos2,
				endpos = pos2 + dir2 * self:GetBladeLength(),
				filter = { self, self.Owner },
			} )
			local traceBack2 = util.TraceLine( {
				start = pos2 + dir2 * self:GetBladeLength(),
				endpos = pos2,
				filter = { self, self.Owner },
			} )

			if ( trace2.HitSky || ( trace2.StartSolid && trace2.HitWorld ) ) then trace2.Hit = false end
			if ( traceBack2.HitSky || ( traceBack2.StartSolid && traceBack2.HitWorld ) ) then traceBack2.Hit = false end

			self:DrawHitEffects( trace2, traceBack2 )
			isTrace2Hit = trace2.Hit || traceBack2.Hit

			if ( traceBack2.Entity == trace2.Entity && IsValid( trace2.Entity ) ) then traceBack2.Hit = false end

			if ( trace2.Hit ) then rb655_LS_DoDamage( trace2, self ) end
			if ( traceBack2.Hit ) then rb655_LS_DoDamage( traceBack2, self ) end

		end

		if ( ( isTrace1Hit || isTrace2Hit ) && self.SoundHit ) then
			self.SoundHit:ChangeVolume( math.Rand( 0.1, 0.5 ), 0 )
		elseif ( self.SoundHit ) then
			self.SoundHit:ChangeVolume( 0, 0 )
		end
	end
end

function SWEP:DrawHitEffects( trace, traceBack )
	if ( self:GetBladeLength() <= 0 ) then return end

	if ( trace.Hit ) then
		rb655_DrawHit( trace.HitPos, trace.HitNormal )
	end

	if ( traceBack && traceBack.Hit ) then
		rb655_DrawHit( traceBack.HitPos, traceBack.HitNormal )
	end
end

-- Fluid holdtype changes

local KnifeHoldType = {
	[ ACT_MP_STAND_IDLE ] = ACT_HL2MP_IDLE_KNIFE,
	[ ACT_MP_WALK ] = ACT_HL2MP_IDLE_KNIFE + 1,
	[ ACT_MP_RUN ] = ACT_HL2MP_IDLE_KNIFE + 2,
	[ ACT_MP_CROUCH_IDLE ] = ACT_HL2MP_IDLE_KNIFE + 3,
	[ ACT_MP_CROUCHWALK ] = ACT_HL2MP_IDLE_KNIFE + 4,
	[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] = ACT_HL2MP_IDLE_KNIFE + 5,
	[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = ACT_HL2MP_IDLE_KNIFE + 5,
	[ ACT_MP_RELOAD_STAND ] = ACT_HL2MP_IDLE_KNIFE + 6,
	[ ACT_MP_RELOAD_CROUCH ] = ACT_HL2MP_IDLE_KNIFE + 6,
	[ ACT_MP_JUMP ] = ACT_HL2MP_IDLE_KNIFE + 7,
	[ ACT_RANGE_ATTACK1 ] = ACT_HL2MP_IDLE_KNIFE + 8,
	[ ACT_MP_SWIM ] = ACT_HL2MP_IDLE_KNIFE + 9
}

function SWEP:TranslateActivity( act )

	if ( self.Owner:IsNPC() ) then return -1 end

	if ( self.Owner:Crouching() ) then
		local tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + Vector( 0, 0, 20 ),
			mins = self.Owner:OBBMins(),
			maxs = self.Owner:OBBMaxs(),
			filter = self.Owner
		} )

		if ( self:GetEnabled() && tr.Hit && act == ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ) then return ACT_HL2MP_IDLE_KNIFE + 5 end

		if ( ( !self:GetEnabled() && self:GetHoldType() == "normal" ) && self.Owner:Crouching() && act == ACT_MP_CROUCH_IDLE ) then return ACT_HL2MP_IDLE_KNIFE + 3 end
		if ( ( ( !self:GetEnabled() && self:GetHoldType() == "normal" ) || ( self:GetEnabled() && tr.Hit ) ) && act == ACT_MP_CROUCH_IDLE ) then return ACT_HL2MP_IDLE_KNIFE + 3 end
		if ( ( ( !self:GetEnabled() && self:GetHoldType() == "normal" ) || ( self:GetEnabled() && tr.Hit ) ) && act == ACT_MP_CROUCHWALK ) then return ACT_HL2MP_IDLE_KNIFE + 4 end

	end

	if ( self.Owner:WaterLevel() > 1 && self:GetEnabled() ) then
		return KnifeHoldType[ act ]
	end

	if ( self.ActivityTranslate[ act ] != nil ) then return self.ActivityTranslate[ act ]end
	return -1
end

if SERVER then
	util.AddNetworkString("ActiveForceAbility")
	util.AddNetworkString("PersistantAbilities")

	net.Receive("ActiveForceAbility", function(_, ply)
		if ply:GetActiveWeapon():GetClass() != "weapon_lightsaber" then return end -- Doesn't have a lightsaber, fuck em
		local type = net.ReadUInt(1)
		local AllowedForceAbilities = ply:GetActiveWeapon():GetAllowedForceAbilities()
		local abilityName = AllowedForceAbilities[net.ReadUInt(16)].name
		if type == 0 then
			ply.selectedAbilities[abilityName] = nil
		else
			ply.selectedAbilities[abilityName] = true
		end
	end)

	net.Receive("PersistantAbilities", function(_, ply)
		local json = net.ReadString()

		local found = false
		for _, wep in ipairs( ply:GetWeapons() ) do
			if wep:GetClass() != "weapon_lightsaber" then continue end
			found = true
		end
		print(found)
		if !found then return end

		ply.selectedAbilities = util.JSONToTable(json)
	end)
end
-- Clientside stuff
if ( SERVER ) then return end

killicon.Add( "weapon_lightsaber", "lightsaber/lightsaber_killicon", color_white )

local WepSelectIcon = Material( "lightsaber/selection.png" )
local Size = 96

function SWEP:DrawWeaponSelection( x, y, w, h, a )
	surface.SetDrawColor( 255, 255, 255, a )
	surface.SetMaterial( WepSelectIcon )

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	surface.DrawTexturedRect( x + ( ( w - Size ) / 2 ), y + ( ( h - Size ) / 2.5 ), Size, Size )

	render.PopFilterMag()
	render.PopFilterMin()
end

function SWEP:DrawWorldModel()
	if !self.ShouldDraw then return end
	self:DrawWorldModelTranslucent()
end

function SWEP:DrawWorldModelTranslucent()
	if !self.ShouldDraw then return end
	self.WorldModel = self:GetWorldModel()
	self:SetModel( self:GetWorldModel() )

	self:DrawModel()
	if ( !IsValid( self:GetOwner() ) || halo.RenderedEntity() == self ) then return end

	local clr = self:GetCrystalColor()
	clr = Color( clr.x, clr.y, clr.z )

	local clr2 = self:GetCrystalColor2()
	clr2 = Color( clr2.x, clr2.y, clr2.z )

	local bladesFound = false
	local blades = 0

	if self.Owner:SteamID() == "STEAM_0:0:57771691" || self.Owner:SteamID() == "STEAM_0:1:53841913" then
		kumo = true
	else
		kumo = false
	end

	for id, t in pairs( self:GetAttachments() ) do
		if ( !string.match( t.name, "blade(%d+)" ) && !string.match( t.name, "quillon(%d+)" ) ) then continue end

		local bladeNum = string.match( t.name, "blade(%d+)" )
		local quillonNum = string.match( t.name, "quillon(%d+)" )

		if ( bladeNum && self:LookupAttachment( "blade" .. bladeNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( bladeNum )
			if self:GetDrawBlade() != 0 && blades % 2 == ((type(whitelistedHilts[self:GetModel()]) == "table" && whitelistedHilts[self:GetModel()].back) && 1 || 0) then
				continue
			end
			rb655_RenderBlade( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), blades % 2 == 1 && clr || clr2, self:GetDarkInner(), self:EntIndex(), self:GetOwner():WaterLevel() > 2, false, blades, moose, martibo, kumo, self.Owner:GetNWInt("saberlevel", 0) )
			bladesFound = true
		end

		if ( quillonNum && self:LookupAttachment( "quillon" .. quillonNum ) > 0 ) then
			blades = blades + 1
			local pos, dir = self:GetSaberPosAng( quillonNum, true )
			if self:GetDrawBlade() != 0 && type(whitelistedHilts[self:GetModel()]) == "table" && whitelistedHilts[self:GetModel()]["quillon" .. quillonNum] then continue end
			rb655_RenderBlade( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), blades % 2 == 1 && clr || clr2, self:GetDarkInner(), self:EntIndex(), self:GetOwner():WaterLevel() > 2, true, blades, moose, martibo, kumo, self.Owner:GetNWInt("saberlevel", 0) )
		end

	end

	if ( !bladesFound ) then
		local pos, dir = self:GetSaberPosAng()
		rb655_RenderBlade( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clr, self:GetDarkInner(), self:EntIndex(), self:GetOwner():WaterLevel() > 2, nil, nil, moose, martibo, kumo, self.Owner:GetNWInt("saberlevel", 0) )
	end
end

-- 3rd Person Camera

concommand.Add("rb655_lightsaber_disable_thirdperson",function(ply)
	if ply:GetActiveWeapon():GetClass() != "weapon_lightsaber" then return end
	ply.lightsaber_pac3camera = ply.lightsaber_pac3camera || nil
	if ply.lightsaber_pac3camera then
		ply.lightsaber_pac3camera = nil
		ply:ChatPrint("Lightsaber Camera Thirdperson has been enabled")
	else
		ply.lightsaber_pac3camera = true
		ply:ChatPrint("Lightsaber Camera Thirdperson has been disabled")
	end
end)

local isCalcViewFuckedUp2 = true
hook.Add( "CalcView", "!!!111_rb655_lightsaber_3rdperson", function( ply, pos, ang )
	if ( !IsValid( ply ) || !ply:Alive() || ply:InVehicle() || ply:GetViewEntity() != ply ) then return end
	if ( !LocalPlayer().GetActiveWeapon || !IsValid( LocalPlayer():GetActiveWeapon() ) || LocalPlayer():GetActiveWeapon():GetClass() != "weapon_lightsaber" ) then return end
	isCalcViewFuckedUp2 = false
	if ply.lightsaber_pac3camera then return end

	local trace = util.TraceHull( {
		start = pos,
		endpos = pos - ang:Forward() * 100,
		filter = { ply:GetActiveWeapon(), ply },
		mins = Vector( -4, -4, -4 ),
		maxs = Vector( 4, 4, 4 ),
	} )

	if ( trace.Hit ) then pos = trace.HitPos else pos = pos - ang:Forward() * 100 end

	return {
		origin = pos,
		angles = ang,
		drawviewer = true
	}
end )

-- HUD

surface.CreateFont( "SelectedForceType", {
	font	= "Roboto Cn",
	size	= ScreenScale( 16 ),
	weight	= 600
} )

surface.CreateFont( "SelectedForceHUD", {
	font	= "Roboto Cn",
	size	= ScreenScale( 6 )
} )

local function OpenAbilityMenu()
	if #LocalPlayer():GetActiveWeapon():GetAllowedForceAbilities() == 0 then return LocalPlayer():ChatPrint("You have no available force abilities to select.") end
	local SelectedAbility = ""
	local idx
	local AbilityMenu = vgui.Create("DFrame")
	AbilityMenu:SetSize(600, 400)
	AbilityMenu:SetTitle("Force Menu")
	AbilityMenu:Center()
	AbilityMenu:MakePopup()

	local AllowedAbilities = vgui.Create( "DScrollPanel", AbilityMenu )
	AllowedAbilities:SetSize(200, 350)
	AllowedAbilities:SetPos(50, 35)
	AllowedAbilities.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
	end

	local ActiveAbilities = vgui.Create( "DScrollPanel", AbilityMenu )
	ActiveAbilities:SetSize(200, 350)
	ActiveAbilities:SetPos(350, 35)
	ActiveAbilities.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(240,240,240))
	end

	local SelectButton = vgui.Create("DButton", AbilityMenu)
	SelectButton:SetSize(30, 30)
	SelectButton:SetPos(285, 170 - 5)
	SelectButton:SetText(">")

	local RevokeButton = vgui.Create("DButton", AbilityMenu)
	RevokeButton:SetSize(30, 30)
	RevokeButton:SetPos(285, 200 + 5)
	RevokeButton:SetText("<")

	local function refresh()
		ActiveAbilities:Clear()
		AllowedAbilities:Clear()
		local activepowers = LocalPlayer():GetActiveWeapon():GetSelectedForceAbilities()
		local allowedpowers = LocalPlayer():GetActiveWeapon():GetAllowedForceAbilities()
		for id, t in pairs( allowedpowers ) do
			for ind, tbl in pairs( activepowers ) do
				if t == tbl then
					local Ability = ActiveAbilities:Add( "DButton" )
					Ability.abilityname = t.name
					Ability:SetText(Ability.abilityname)
					Ability:Dock( TOP )
					Ability:DockMargin( 0, 0, 0, 1 )
					Ability.DoClick = function(s)
						SelectedAbility = s.abilityname
						idx = id

					end
					Ability.Paint = function(s, w, h)
						local color = Color(200,200,200)
						if SelectedAbility == s.abilityname then
							color = Color(100,200,100)
						end
						draw.RoundedBox(0, 0, 0, w, h, color)
					end
					goto endloop
				end
			end
			local Ability = AllowedAbilities:Add( "DButton" )
			Ability.abilityname = t.name
			Ability:SetText(Ability.abilityname)
			Ability:Dock( TOP )
			Ability:DockMargin( 0, 0, 0, 1 )
			Ability.DoClick = function(s)
				SelectedAbility = s.abilityname
				idx = id

			end
			Ability.Paint = function(s, w, h)
				local color = Color(200,200,200)
				if SelectedAbility == s.abilityname then
					color = Color(100,200,100)
				end
				draw.RoundedBox(0, 0, 0, w, h, color)
			end
			::endloop::
		end
	end
	refresh()

	SelectButton.DoClick = function()
		if table.Count(LocalPlayer():GetActiveWeapon():GetSelectedForceAbilities()) > 7 then
			LocalPlayer():ChatPrint("You can only have 8 active abilites.")
			return
		end
		LocalPlayer().selectedAbilities[SelectedAbility] = true
		net.Start("ActiveForceAbility")
		net.WriteUInt(1, 1)
		net.WriteUInt(idx, 16)
		net.SendToServer()
		refresh()
	end
	RevokeButton.DoClick = function()
		LocalPlayer().selectedAbilities[SelectedAbility] = nil
		net.Start("ActiveForceAbility")
		net.WriteUInt(0, 1)
		net.WriteUInt(idx, 16)
		net.SendToServer()
		refresh()
	end

	AbilityMenu.OnClose = function()

		if !file.Exists("rb655_lightsaber", "DATA") then
			file.CreateDir("rb655_lightsaber")
		end

		file.Write("rb655_lightsaber/abilities.json", util.TableToJSON(LocalPlayer().selectedAbilities))

	end
end

concommand.Add("rb655_lightsaber_force_menu", function()
	if LocalPlayer():GetActiveWeapon():GetClass() == "weapon_lightsaber" then
		OpenAbilityMenu()
	end
end)

local ForceSelectEnabled = false
hook.Add( "PlayerBindPress", "rb655_sabers_force", function( ply, bind, pressed )
	if ( LocalPlayer():InVehicle() || ply != LocalPlayer() || !LocalPlayer():Alive() || !IsValid( LocalPlayer():GetActiveWeapon() ) || LocalPlayer():GetActiveWeapon():GetClass() != "weapon_lightsaber" ) then ForceSelectEnabled = false return end

	if ( bind == "impulse 100" && pressed ) then
		if table.Count(LocalPlayer():GetActiveWeapon():GetSelectedForceAbilities()) > 0 then
			ForceSelectEnabled = !ForceSelectEnabled
		end
		return true
	end

	if ( !ForceSelectEnabled ) then return end

	if ( bind:StartWith( "slot" ) ) then
		RunConsoleCommand( "rb655_select_force", bind:sub( 5 ) )
		return true
	end
end )

local delay = 1
local lastOccurance = -delay
hook.Add( "PlayerButtonDown", "rb655_open_force_menu", function( ply, key )
	local timeElapsed = CurTime() - lastOccurance
	if timeElapsed < delay then return end
	lastOccurance = CurTime()
	if ( LocalPlayer():InVehicle() || ply != LocalPlayer() || !LocalPlayer():Alive() || !IsValid( LocalPlayer():GetActiveWeapon() ) || LocalPlayer():GetActiveWeapon():GetClass() != "weapon_lightsaber" ) then return end

	if ( key == KEY_G && input.LookupBinding( "rb655_lightsaber_force_menu" ) == nil ) then
		OpenAbilityMenu()
	end
end )

local grad = Material( "gui/gradient_up" )
local function DrawHUDBox( x, y, w, h, b )

	x = math.floor( x )
	y = math.floor( y )
	w = math.floor( w )
	h = math.floor( h )

	draw.NoTexture()
	surface.SetDrawColor( Color( 0, 0, 0, 128 ) )
	surface.DrawTexturedRect( x, y, w, h )

	surface.SetDrawColor( Color( 0, 0, 0, 128 ) )
	surface.DrawRect( x, y, w, h )

	if ( b ) then
		surface.SetMaterial( grad )
		surface.SetDrawColor( Color( 0, 128, 255, 4 ) )
		surface.DrawTexturedRect( x, y, w, h )
	end

end

local isCalcViewFuckedUp = true
function SWEP:ViewModelDrawn()
	isCalcViewFuckedUp = true
end

function SWEP:DrawHUDTargetSelection()
	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )
	if ! selectedForcePower then return end
	if selectedForcePower.name == "Force Push" then
		for i = -5,-1 do
			for k,v in pairs (ents.FindInSphere(LocalPlayer():GetPos() + LocalPlayer():EyeAngles():Forward() * (100 * math.abs(i)),75)) do
				if (v.LFS || v:IsNPC() || v:IsPlayer()) && v != LocalPlayer() then
					if !IsValid( v ) then continue end
					local maxs = v:OBBMaxs()
					local p = v:GetPos()
					p.z = p.z + maxs.z
					local pos = p:ToScreen()
					local x, y = pos.x, pos.y
					local size = 16
					surface.SetDrawColor( 255, 0, 0, 255 )
					draw.NoTexture()
					surface.DrawPoly( {
						{ x = x - size, y = y - size },
						{ x = x + size, y = y - size },
						{ x = x, y = y }
					} )
				end
			end
		end
	elseif selectedForcePower.name == "Force Pull" then
		for i = -10,-1 do
			for k,v in pairs (ents.FindInSphere(LocalPlayer():GetPos() + LocalPlayer():EyeAngles():Forward() * (100 * math.abs(i)),75)) do
				if (v.LFS || v:IsNPC() || v:IsPlayer() || v:IsNPC()) && v != LocalPlayer() then
					if !IsValid( v ) then continue end
					local maxs = v:OBBMaxs()
					local p = v:GetPos()
					p.z = p.z + maxs.z
					local pos = p:ToScreen()
					local x, y = pos.x, pos.y
					local size = 16
					surface.SetDrawColor( 255, 0, 0, 255 )
					draw.NoTexture()
					surface.DrawPoly( {
						{ x = x - size, y = y - size },
						{ x = x + size, y = y - size },
						{ x = x, y = y }
					} )
				end
			end
		end
	else
		local isTarget = selectedForcePower.target
		if ( isTarget ) then
			for id, ent in pairs( self:SelectTargets( isTarget ) ) do
				if !IsValid( ent ) then continue end
				local maxs = ent:OBBMaxs()
				local p = ent:GetPos()
				p.z = p.z + maxs.z

				local pos = p:ToScreen()
				local x, y = pos.x, pos.y
				local size = 16

				surface.SetDrawColor( 255, 0, 0, 255 )
				draw.NoTexture()
				surface.DrawPoly( {
					{ x = x - size, y = y - size },
					{ x = x + size, y = y - size },
					{ x = x, y = y }
				} )
			end
		end
	end
end

local ForceBar1 = 100
local ForceBar2 = 100
function SWEP:DrawHUD()

	if ( !IsValid( self.Owner ) || self.Owner:GetViewEntity() != self.Owner || self.Owner:InVehicle() ) then return end

	local icon = 52
	local gap = 5

	local bar = 4
	local bar2 = 16

	if ( ForceSelectEnabled ) then
		icon = 128
		bar = 8
		bar2 = 24
	end

	local ForcePowers = self:GetSelectedForceAbilities()

	if DuelForceEnabled then
		-- Force Bar 2 - Aiko's Addition

		ForceBar2 = math.min( 100, Lerp( 0.1, ForceBar2, math.floor( self:GetBasicForce() ) ) )

		local w2 = #ForcePowers * icon + ( #ForcePowers - 1 ) * gap
		local barw = 13 * icon + 12 * gap
		local h2 = bar2
		local x2 = math.floor( ScrW() / 2 - w2 / 2 )
		local barx = math.floor( ScrW() / 2 - barw / 2 )
		local y2 = ScrH() - gap - bar2

		DrawHUDBox( barx, y2, barw, h2 )

		local barW2 = math.ceil( barw * ( ForceBar2 / 100 ) )
		if ( self:GetBasicForce() <= 1 && barW2 <= 1 ) then barW2 = 0 end
		draw.RoundedBox( 0, barx, y2, barW2, h2, Color( 0, 255, 128, 128 ) )

		draw.SimpleText( math.floor( self:GetBasicForce() ) .. "%", "SelectedForceHUD", barx + barw / 2, y2 + h2 / 2, Color( 255, 255, 255 ), 1, 1 )
	end



	-- Force Bar

	ForceBar1 = math.min( 100, Lerp( 0.1, ForceBar1, math.floor( self:GetForce() ) ) )

	local w = #ForcePowers * icon + ( #ForcePowers - 1 ) * gap
	local barw = 13 * icon + 12 * gap
	local h = bar2
	local x = math.floor( ScrW() / 2 - w / 2 )
	local barx = math.floor( ScrW() / 2 - barw / 2 )
	local y
	if DuelForceEnabled then
		y = ScrH() - gap - bar2 - (bar2 + gap)
	else
		y = ScrH() - gap - bar2
	end

	DrawHUDBox( barx, y, barw, h )

	local barW = math.ceil( barw * ( ForceBar1 / 100 ) )
	if ( self:GetForce() <= 1 && barW <= 1 ) then barW = 0 end
	draw.RoundedBox( 0, barx, y, barW, h, Color( 0, 128, 255, 255 ) )

	draw.SimpleText( math.floor( self:GetForce() ) .. "%", "SelectedForceHUD", barx + barw / 2, y + h / 2, Color( 255, 255, 255 ), 1, 1 )


	if ( #ForcePowers < 1 ) then

		surface.SetFont( "SelectedForceHUD" )
		local txt = "Press " .. ( input.LookupBinding( "rb655_lightsaber_force_menu" ) || "G" ):upper() .. " to select Force Powers"
		local tW, tH = surface.GetTextSize( txt )

		local x = x + w / 2
		local y = y - tH - gap

		DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
		draw.SimpleText( txt, "SelectedForceHUD", x, y, Color( 255, 255, 255 ), 1 )

		return
	end
	-- Force Icons

	local y = y - icon - gap
	local h = icon

	for id, t in pairs( ForcePowers ) do
		local x = x + ( id - 1 ) * ( h + gap )
		local x2 = math.floor( x + icon / 2 )

		DrawHUDBox( x, y, h, h, self:GetForceType() == id )
		draw.SimpleText( t.icon || "", "SelectedForceType", x2, math.floor( y + icon / 2 ), Color( 255, 255, 255 ), 1, 1 )
		if ( ForceSelectEnabled ) then
			draw.SimpleText( ( input.LookupBinding( "slot" .. id ) || "<NOT BOUND>" ):upper(), "SelectedForceHUD", x + gap, y + gap, Color( 255, 255, 255 ) )
		end
		if ( self:GetForceType() == id ) then
			local y = y + ( icon - bar )
			surface.SetDrawColor( 0, 128, 255, 255 )
			draw.NoTexture()
			surface.DrawPoly( {
				{ x = x2 - bar, y = y },
				{ x = x2, y = y - bar },
				{ x = x2 + bar, y = y }
			} )
			draw.RoundedBox( 0, x, y, h, bar, Color( 0, 128, 255, 255 ) )
		end
	end

	-- Force Label

	if ( !ForceSelectEnabled ) then
		surface.SetFont( "SelectedForceHUD" )
		local txt = "Press " .. ( input.LookupBinding( "impulse 100" ) || "<NOT BOUND>" ):upper() .. " to toggle Force selection"
		local tW, tH = surface.GetTextSize( txt )

		local x = x + w / 2
		local y = y - tH - gap

		DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
		draw.SimpleText( txt, "SelectedForceHUD", x, y, Color( 255, 255, 255 ), 1 )

		local isGood = hook.Call( "PlayerBindPress", nil, LocalPlayer(), "this_bind_doesnt_exist", true )
		if ( isGood == true ) then
			local txt = "Some addon is breaking the PlayerBindPress hook. Send a screenshot of this error to the mod page!"
			for name, func in pairs( hook.GetTable()[ "PlayerBindPress" ] ) do txt = txt .. "\n" .. tostring( name ) end
			local tW, tH = surface.GetTextSize( txt )

			y = y - tH - gap

			local id = 1
			DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
			draw.SimpleText( string.Explode( "\n", txt )[ 1 ], "SelectedForceHUD", x, y + 0, Color( 255, 230, 230 ), 1 )

			for str, func in pairs( hook.GetTable()[ "PlayerBindPress" ] ) do
				local clr = Color( 255, 255, 128 )
				if ( ( isstring( str ) && func( LocalPlayer(), "this_bind_doesnt_exist", true ) == true ) || ( !isstring( str ) && func( str, LocalPlayer(), "this_bind_doesnt_exist", true ) == true ) ) then
					clr = Color( 255, 128, 128 )
				end
				if ( !isstring( str ) ) then str = tostring( str ) end
				if ( str == "" ) then str = "<empty string hook>" end
				local _, lineH = surface.GetTextSize( str )
				draw.SimpleText( str, "SelectedForceHUD", x, y + id * lineH, clr, 1 )
				id = id + 1
			end
		end
		if LocalPlayer().lightsaber_pac3camera then
			isCalcViewFuckedUp = false
			isCalcViewFuckedUp2 = false
		end

		if ( isCalcViewFuckedUp || isCalcViewFuckedUp2 ) then

			local txt = "Some addon is breaking the CalcView hook. Send a screenshot of this error to the mod page!"
			for name, func in pairs( hook.GetTable()[ "CalcView" ] ) do txt = txt .. "\n" .. tostring( name ) end
			local tW, tH = surface.GetTextSize( txt )

			y = y - tH - gap

			local id = 1
			//DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
			//draw.SimpleText( string.Explode( "\n", txt )[ 1 ], "SelectedForceHUD", x, y + 0, Color( 255, 230, 230 ), 1 )

			for str, func in pairs( hook.GetTable()[ "CalcView" ] ) do
				local clr = Color( 255, 255, 128 )
				if ( ( isstring( str ) && func( LocalPlayer(), EyePos(), EyeAngles(), 90, 4, 16000 ) != nil ) || ( !isstring( str ) && func( str, LocalPlayer(), EyePos(), EyeAngles(), 90, 4, 16000 ) != nil ) ) then
					clr = Color( 255, 128, 128 )
				end
				if ( !isstring( str ) ) then str = tostring( str ) end
				if ( str == "" ) then str = "<empty string hook>" end
				local _, lineH = surface.GetTextSize( str )
				//draw.SimpleText( str, "SelectedForceHUD", x, y + id * lineH, clr, 1 )
				id = id + 1
			end

			isCalcViewFuckedUp = false
		end

		if ( !isCalcViewFuckedUp2 ) then
			isCalcViewFuckedUp2 = true
		end

		if ( self:GetIncorrectPlayerModel() != 0 ) then
			local txt = "Server is missing the player model || missing owner! Send a screenshot of this error to the mod page!\nPlayer model: " .. self.Owner:GetModel() .. " - Error Code: " .. self:GetIncorrectPlayerModel()
			local tW, tH = surface.GetTextSize( txt )

			y = y - tH - gap

			DrawHUDBox( x - tW / 2 - 5, y, tW + 10, tH )
			for id, str in pairs( string.Explode( "\n", txt ) ) do
				local _, lineH = surface.GetTextSize( str )
				draw.SimpleText( str, "SelectedForceHUD", x, y + ( id - 1 ) * lineH, Color( 255, 200, 200 ), 1 )
			end
		end
	end

	local selectedForcePower = self:GetActiveForcePowerType( self:GetForceType() )

	if ( selectedForcePower && ForceSelectEnabled ) then
		surface.SetFont( "SelectedForceType" )
		local txt = selectedForcePower.name || ""
		local tW2, tH2 = surface.GetTextSize( txt )

		local x = x + w / 2- tW2 / 2 - gap * 2
		local y = y + gap - tH2 - gap * 2

		DrawHUDBox( x, y, tW2 + 10, tH2 )
		draw.SimpleText( txt, "SelectedForceType", x + gap, y, Color( 255, 255, 255 ) )
	end

	self:DrawHUDTargetSelection()

end

local function LoadPersistantAbilities()

	local jsonabilities = file.Read("rb655_lightsaber/abilities.json")

	if jsonabilities == nil then return end

	local found = false
	for _, wep in ipairs( LocalPlayer():GetWeapons() ) do
		if wep:GetClass() != "weapon_lightsaber" then continue end
		found = true
	end
	if !found then return end

	LocalPlayer().selectedAbilities = util.JSONToTable(jsonabilities)

	net.Start("PersistantAbilities")
	net.WriteString(jsonabilities)
	net.SendToServer()

end

hook.Add("InitPostEntity", "rb655_lightsaber_load_persistant_abilities", function()

	LoadPersistantAbilities()
	print("Loading rb655_lightsaber_load_persistant_abilities")

end )
