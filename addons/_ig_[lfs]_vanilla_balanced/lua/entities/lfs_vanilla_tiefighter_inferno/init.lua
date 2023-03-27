AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 178 )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:OnTick()
end

function ENT:RunOnSpawn()
	self:GetChildren()[1]:SetVehicleClass("phx_seat2")
	self:SetAutomaticFrameAdvance(true)
	self:ResetSequence(self:LookupSequence("TopOpen"))
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:EmitSound( "TIE_FIRE" )

	self:SetNextPrimary( 0.18 )

	local fP = { Vector(49.91,14.53,-42.09),Vector(49.91,-14.53,-42.09) }

	for k,v in pairs(fP) do
		local startpos =  self:GetRotorPos()
		local TracePlane = util.TraceHull( {
			start = startpos,
			endpos = (startpos + self:GetForward() * 50000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = function( e )
				local collide = e ~= self
				return collide
			end
		} )

		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= self:LocalToWorld( v )
		bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
		bullet.Tracer	= 1
		bullet.TracerName	= "lfs_laser_green"
		bullet.Force	= 100
		bullet.HullSize 	= 40
		bullet.Damage	= 90
		bullet.Attacker 	= self:GetDriver()
		bullet.AmmoType = "Pistol"
		bullet.Callback = function(att, tr, dmginfo)
			dmginfo:SetDamageType(DMG_AIRBOAT)
		end
		self:FireBullets( bullet )

		self:TakePrimaryAmmo()
	end
end

function ENT:SecondaryAttack()
	if self:GetAI() then return end

	if not self:CanSecondaryAttack() then return end

	self:SetNextSecondary( 0.8 )

	self:TakeSecondaryAmmo()

	self.MirrorSecondary = not self.MirrorSecondary

	local Mirror = self.MirrorSecondary and -1 or 1

	local startpos =  self:GetRotorPos()
	local tr = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -40, -40, -40 ),
		maxs = Vector( 40, 40, 40 ),
		filter = function( e )
			local collide = e ~= self
			return collide
		end
	} )

	local ent = ents.Create( "lunasflightschool_missile" )
	local Pos = self:LocalToWorld( Vector(49.91,14.53 * Mirror,-42.09) )
	ent:SetPos( Pos )
	ent:SetAngles( (tr.HitPos - Pos):Angle() )
	ent:Spawn()
	ent:Activate()
	ent:SetAttacker( self:GetDriver() )
	ent:SetInflictor( self )
	ent:SetStartVelocity( self:GetVelocity():Length() )
	ent:SetDirtyMissile( true )

	if tr.Hit then
		local Target = tr.Entity
		if IsValid( Target ) then
			if Target:GetClass():lower() ~= "lunasflightschool_missile" then
				ent:SetLockOn( Target )
				ent:SetStartVelocity( 0 )
			end
		end
	end

	constraint.NoCollide( ent, self, 0, 0 )
end

function ENT:OnKeyThrottle( bPressed )
	if bPressed then
		if self:CanSound() then
			self:EmitSound( "TIE_ROAR" )
			self:DelayNextSound( 1 )
		end
	else
		if (self:GetRPM() + 1) > self:GetMaxRPM() then
			if self:CanSound() then
				self:EmitSound( "TIE_ROAR" )
				self:DelayNextSound( 0.5 )
			end
		end
	end
end

function ENT:CreateAI()
end

function ENT:RemoveAI()
end

function ENT:ToggleLandingGear()
end

function ENT:RaiseLandingGear()
end

function ENT:OnEngineStarted()
	self:SetSkin(1)
	self:EmitSound("TIE_STARTUP")
end

function ENT:OnEngineStopped()
	self:SetSkin(0)
	self:EmitSound("TIE_SHUTDOWN")
end
