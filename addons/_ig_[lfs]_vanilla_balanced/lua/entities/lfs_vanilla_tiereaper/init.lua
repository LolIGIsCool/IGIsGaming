AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName ) -- called by garry
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply  -- this is important
	ent:SetPos( tr.HitPos + tr.HitNormal * 200 ) -- spawn 20 units above ground
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:OnTick() -- use this instead of "think"
	if IsValid(self.LandingGear) then
		self.LandingGear:SetSkin( self:GetSkin() )
	end
end

--[[
function ENT:CalcFlightOverride( Pitch, Yaw, Roll, Stability ) -- overwrite flight mechanics?
	return Pitch,Yaw,Roll,Stability,Stability,Stability
end
]]--

function ENT:RunOnSpawn() -- called when the vehicle is spawned
	for i = 1, 9 do
		local seat = self:AddPassengerSeat( Vector(0,0,-10), Angle(0,-90,0) )
		seat.ExitPos = Vector(300,0,-150)
	end

	self:GetDriverSeat().ExitPos = (Vector(300,0,150))

	local e = ents.Create("prop_physics")
	e:SetModel("models/squadrons/tie_reaper_landing_gear.mdl")
	e:SetPos(self:GetPos())
	e:SetAngles(self:GetAngles())
	e:Spawn()
	e:Activate()

	local phys = e:GetPhysicsObject()
	phys:EnableGravity(false)
	phys:EnableDrag(false)
	phys:SetMass(500)
	constraint.Weld(self,e,0,0,0,true)
	self.LandingGear = e

	local l = ents.Create("prop_physics")
	l:SetModel("models/hunter/blocks/cube075x3x075.mdl")
	l:SetPos(self:LocalToWorld(Vector(475,0,-100)))
	l:SetAngles(self:LocalToWorldAngles(Angle(0,0,90)))
	l:Spawn()
	l:Activate()

	local physL = l:GetPhysicsObject()
	physL:EnableGravity(false)
	physL:EnableDrag(false)
	physL:SetMass(500)
	constraint.Weld(self,l,0,0,0,true)
	self.LandingFront = l
	self.LandingFront:SetNoDraw( true )
	self.LandingFront:DrawShadow( false )
	self.LandingFront:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	self:DisableWep( true )
end

function ENT:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	if not self:GetEngineActive() then return end
	if IsValid(self.LandingGear) then return end

	self:EmitSound( "TIER_FIRE" )

	self:SetNextPrimary( 0.2 )

	local fP = {
		Vector(730,145,116),
		Vector(730,-145,116),
	}

	self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
	if self.NumPrim > 2 then self.NumPrim = 1 end

	local startpos =  self:GetRotorPos()
	local TracePlane = util.TraceHull( {
		start = startpos,
		endpos = (startpos + self:GetForward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )

	local bullet = {}
	bullet.Num 	= 1
	bullet.Src 	= self:LocalToWorld( fP[self.NumPrim] )
	bullet.Dir 	= (TracePlane.HitPos - bullet.Src):GetNormalized()
	bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
	bullet.Tracer	= 1
	bullet.TracerName	= "lfs_laser_green"
	bullet.Force	= 100
	bullet.HullSize 	= 50
	bullet.Damage	= 30
	bullet.Attacker 	= self:GetDriver()
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(att, tr, dmginfo)
		dmginfo:SetDamageType(DMG_AIRBOAT)
	end
	self:FireBullets( bullet )
	self:TakePrimaryAmmo()
end

function ENT:CreateAI() -- called when the ai gets enabled
end

function ENT:RemoveAI() -- called when the ai gets disabled
end

function ENT:OnKeyThrottle( bPressed )
	if self:CanSound() then -- makes sure the player cant spam sounds
		if bPressed then -- if throttle key is pressed
			--self:EmitSound( "buttons/button3.wav" )
			--self:DelayNextSound( 1 ) -- when the next sound should be allowed to be played
		else
			--self:EmitSound( "buttons/button11.wav" )
			--self:DelayNextSound( 0.5 )
		end
	end
end

--[[
function ENT:OnReloadWeapon()
	self:EmitSound("lfs/weapons_reload.wav")
end

function ENT:OnUnloadWeapon()
	self:EmitSound("weapons/357/357_reload4.wav")
end
]]--

--[[
function ENT:ApplyThrustVtol( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetElevatorPos() )
	PhysObj:ApplyForceOffset( vDirection * fForce,  self:GetWingPos() )
end

function ENT:ApplyThrust( PhysObj, vDirection, fForce )
	PhysObj:ApplyForceOffset( vDirection * fForce, self:GetRotorPos() )
end
]]--

function ENT:OnEngineStarted()
	self:EmitSound( "TIER_STARTUP" )
end

function ENT:OnEngineStopped()
	self:EmitSound( "TIER_SHUTDOWN" )
end

function ENT:OnVtolMode( IsOn )
	--[[ called when vtol mode is activated / deactivated ]]--
end

function ENT:OnLandingGearToggled( bOn )
	if bOn then
		if IsValid(self.LandingGear) then
			self.LandingGear:Remove()
		end
		if IsValid(self.LandingFront) then
			self.LandingFront:Remove()
		end

		self:SetBodygroup( 1, 1 )
		self:DisableWep( false )
	else
		if IsValid(self.LandingGear) then
			self.LandingGear:Remove()
		end
		if IsValid(self.LandingFront) then
			self.LandingFront:Remove()
		end

		local e = ents.Create("prop_physics")
		e:SetModel("models/squadrons/tie_reaper_landing_gear.mdl")
		e:SetPos(self:GetPos())
		e:SetAngles(self:GetAngles())
		e:Spawn()
		e:Activate()

		local phys = e:GetPhysicsObject()
		phys:EnableGravity(false)
		phys:EnableDrag(false)
		phys:SetMass(500)
		constraint.Weld(self,e,0,0,0,true)
		self.LandingGear = e

		local l = ents.Create("prop_physics")
		l:SetModel("models/hunter/blocks/cube075x3x075.mdl")
		l:SetPos(self:LocalToWorld(Vector(475,0,-100)))
		l:SetAngles(self:LocalToWorldAngles(Angle(0,0,90)))
		l:Spawn()
		l:Activate()

		local physL = l:GetPhysicsObject()
		physL:EnableGravity(false)
		physL:EnableDrag(false)
		physL:SetMass(500)
		constraint.Weld(self,l,0,0,0,true)
		self.LandingFront = l
		self.LandingFront:SetNoDraw( true )
		self.LandingFront:DrawShadow( false )
		self.LandingFront:SetCollisionGroup( COLLISION_GROUP_WEAPON )

		self:SetBodygroup( 1, 0 )
		self:DisableWep( true )
	end
	self:EmitSound( "TIER_GEAR" )
end

function ENT:OnRemove()
	if IsValid(self.LandingGear) then
		self.LandingGear:Remove()
	end
	if IsValid(self.LandingFront) then
		self.LandingFront:Remove()
	end
end

--[[
function ENT:OnStartMaintenance()
	if not self:GetRepairMode() and self:GetAmmoMode() then
		self:UnloadWeapon()
	end
end

function ENT:OnStopMaintenance()
end
]]
