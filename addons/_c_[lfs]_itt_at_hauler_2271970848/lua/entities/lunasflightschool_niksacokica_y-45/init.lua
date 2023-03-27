AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )
	if not tr.Hit then return end

	local ent = ents.Create( ClassName )
	ent.dOwnerEntLFS = ply
	ent:SetPos( tr.HitPos + tr.HitNormal * 50 )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:RunOnSpawn()
	self:AddPassengerSeat( Vector(133,0,185), Angle(0,-90,0) )
end

function ENT:OnTick()
	self:Grabber()
end

function ENT:DropHeldEntity()
	if IsValid( self.PosEnt ) then
		self.PosEnt:Remove()
	end

	self.wheel_L = NULL
	self.wheel_R = NULL

	local FrontEnt = self:GetHeldEntity()
	
	if IsValid( FrontEnt ) then
		if FrontEnt.SetIsCarried then
			FrontEnt:SetIsCarried( false )
		end
		
		if FrontEnt.GetRearEnt then
			local RearEnt = self:GetHeldEntity():GetRearEnt()
			
			RearEnt:SetCollisionGroup( self.OldCollisionGroup2 or COLLISION_GROUP_NONE  )
		end

		FrontEnt:SetCollisionGroup( self.OldCollisionGroup or COLLISION_GROUP_NONE )
		FrontEnt.smSpeed = 200
	end
	
	self:SetHeldEntity( NULL )
end

function ENT:HandleLandingGear()
	local Driver = self:GetDriver()
	
	if IsValid( Driver ) then
		local KeyJump = Driver:lfsGetInput( "VSPEC" )
		
		if self.OldKeyJump ~= KeyJump then
			self.OldKeyJump = KeyJump
			if KeyJump then
				self:ToggleLandingGear()
				self:PhysWake()
			end
		end
	end
end

function ENT:OnLandingGearToggled( bOn )
	self.s = self.s or 0
	if not (self.s < CurTime()) then return end
	self.s = CurTime() + 1
	local i
	
	self.GrabberEnabled = not self.GrabberEnabled
	
	if self.GrabberEnabled then
		self:EmitSound( "niksacokica/jfo_vehicles/y-45_arms.wav" )
		
		i=0
		timer.Create( "rotation_open" .. self:EntIndex(), 1/66, 55, function() 
			self:ManipulateBoneAngles(self:LookupBone("right_flap"), Angle(0,i,0))
			self:ManipulateBoneAngles(self:LookupBone("left_flap"), Angle(0,-i,0))
			i = i-2
		end)
		
		if IsValid( self.PICKUP_ENT ) then
			self.PosEnt = ents.Create( "prop_physics" )
			
			if IsValid( self.PosEnt ) then
				self.PosEnt:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
				self.PosEnt:SetPos( self.PICKUP_ENT:GetPos() )
				self.PosEnt:SetAngles( self.PICKUP_ENT:GetAngles() )
				self.PosEnt:SetCollisionGroup( COLLISION_GROUP_WORLD )
				self.PosEnt:Spawn()
				self.PosEnt:Activate()
				self.PosEnt:SetNoDraw( true ) 
				self:DeleteOnRemove( self.PosEnt )
			
				constraint.Weld( self.PosEnt, self.PICKUP_ENT, 0, 0, 0, false, false )
				
				if self.PICKUP_ENT.GetRearEnt then
					local RearEnt = self.PICKUP_ENT:GetRearEnt()
					RearEnt:SetAngles( self.PICKUP_ENT:GetAngles() )
					RearEnt:SetPos( self.PICKUP_ENT:GetPos() )
					constraint.Weld( self.PosEnt, RearEnt, 0, 0, 0, false, false )
					
					self.OldCollisionGroup2 = RearEnt:GetCollisionGroup()
					
					RearEnt:SetCollisionGroup( COLLISION_GROUP_WORLD )
					
					self.wheel_L = RearEnt -- !!HACK!! for AI traces
				end
				
				self.wheel_R = self.PICKUPENT -- !!HACK!! for AI traces
				
				self:SetHeldEntity( self.PICKUP_ENT )
				
				self.OldCollisionGroup = self:GetHeldEntity():GetCollisionGroup()
				self:GetHeldEntity():SetCollisionGroup( COLLISION_GROUP_WORLD )
				
				if self:GetHeldEntity().SetIsCarried then
					self:GetHeldEntity():SetIsCarried( true )
				end
			else
				self.GrabberEnabled = false
				print("[LFS] LAATc: ERROR COULDN'T CREATE PICKUP_ENT")
			end
		end
	else
		if IsValid( self:GetHeldEntity() ) then
			if self:CanDrop() then
				self:DropHeldEntity()
				self:EmitSound( "niksacokica/jfo_vehicles/y-45_arms.wav" )
				
				i=-110
				timer.Create( "rotation_open" .. self:EntIndex(), 1/66, 55, function() 
					self:ManipulateBoneAngles(self:LookupBone("right_flap"), Angle(0,i,0))
					self:ManipulateBoneAngles(self:LookupBone("left_flap"), Angle(0,-i,0))
					i = i+2
				end)
			else
				self.GrabberEnabled = true
			end
		else
			i=-110
			timer.Create( "rotation_open" .. self:EntIndex(), 1/66, 55, function() 
				self:ManipulateBoneAngles(self:LookupBone("right_flap"), Angle(0,i,0))
				self:ManipulateBoneAngles(self:LookupBone("left_flap"), Angle(0,-i,0))
				i = i+2
			end)
			self:EmitSound( "niksacokica/jfo_vehicles/y-45_arms.wav" )
		end
	end
end

function ENT:Grabber()
	local Rate = FrameTime()
	local Active = self.GrabberEnabled
	
	self.smGrabber = self.smGrabber and self.smGrabber + math.Clamp( (Active and 0 or 1) - self.smGrabber,-Rate,Rate) or 0
	
	if Active then
		if IsValid( self.PosEnt ) then
			local PObj = self.PosEnt:GetPhysicsObject()
			
			if PObj:IsMotionEnabled() then
				PObj:EnableMotion( false )
			end
			
			local HeldEntity = self:GetHeldEntity()
			if IsValid( HeldEntity ) then
				local v = HeldEntity.LAATC_PICKUP_POS
				self.PosEnt:SetPos( self:LocalToWorld( Vector(v.x+66, v.y, v.z-140) or Vector(-155,0,-250) ) + self:GetVelocity() * FrameTime() )
				self.PosEnt:SetAngles( self:LocalToWorldAngles( HeldEntity.LAATC_PICKUP_Angle or Angle(0,0,0) ) )
			end
			
			if self:GetAI() then self:SetAI( false ) end
		end
	else
		if (self.NextFind or 0) < CurTime() then
			self.NextFind = CurTime() + 1
			
			local StartPos = self:LocalToWorld( Vector(-120,0,100) )
			
			self.PICKUP_ENT = NULL
			local Dist = 1000
			local SphereRadius = 150

			if istable( GravHull ) then SphereRadius = 300 end

			for k, v in pairs( ents.FindInSphere( StartPos, SphereRadius ) ) do
				if v.LAATC_PICKUPABLE then

					local Len = (StartPos - v:GetPos()):Length()

					if Len < Dist then
						self.PICKUP_ENT = v
						Dist = Len
					end
				end
			end
		end
	end
end

function ENT:HitGround()
	if IsValid( self:GetHeldEntity() ) then
		return false
	end

	local tr = util.TraceLine( {
		start = self:LocalToWorld( Vector(0,0,100) ),
		endpos = self:LocalToWorld( Vector(0,0,-20) ),
		filter = function( ent ) 
			if ( ent == self ) then 
				return false
			end
		end
	} )

	return tr.Hit 
end

function ENT:CanDrop()
	local tr = util.TraceLine( {
		start = self:LocalToWorld( Vector(0,0,100) ),
		endpos = self:LocalToWorld( Vector(0,0,-300) ),
		filter = function( ent ) 
			if ent == self or ent == self:GetHeldEntity() then 
				return false
			end

			return true
		end
	} )
	
	return tr.Hit 
end

function ENT:OnEngineStarted()
	local RotorWash = ents.Create( "env_rotorwash_emitter" )
	
	if IsValid( RotorWash ) then
		RotorWash:SetPos( self:LocalToWorld( Vector(50,0,0) ) )
		RotorWash:SetAngles( Angle(0,0,0) )
		RotorWash:Spawn()
		RotorWash:Activate()
		RotorWash:SetParent( self )
		
		RotorWash.DoNotDuplicate = true
		self:DeleteOnRemove( RotorWash )
		self:dOwner( RotorWash )
		
		self.RotorWashEnt = RotorWash
	end
	
	self:EmitSound( "niksacokica/jfo_vehicles/y-45_engine_on.wav" )
end

function ENT:OnEngineStopped()	
	if IsValid( self.RotorWashEnt ) then
		self.RotorWashEnt:Remove()
	end
	self:SetGravityMode( true )
	
	self:EmitSound( "niksacokica/jfo_vehicles/y-45_engine_off.wav" )
end

function ENT:OnRemove()
	self:DropHeldEntity()
end