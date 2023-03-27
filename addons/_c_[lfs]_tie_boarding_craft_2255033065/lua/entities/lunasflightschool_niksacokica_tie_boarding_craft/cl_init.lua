include("shared.lua")

function ENT:Initialize()
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  60 + Pitch * 50, 80,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
	end
	
	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  50 + Pitch * 60, 50,255) + Doppler,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0,1) )
	end
end

function ENT:LFSCalcViewThirdPerson( view )
	local ply = LocalPlayer()
	local Pod = ply:GetVehicle()
	if not IsValid( Pod ) then return view end
	
	if ply == self:GetDriver() then
		local radius = 1000
		radius = radius + radius * Pod:GetCameraDistance()
		
		view.origin = self:LocalToWorld( Vector(0,61,50) )
		
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
		local WallOffset = 4

		local tr = util.TraceHull( {
			start = view.origin,
			endpos = TargetOrigin,
			filter = function( e )
				local c = e:GetClass()
				local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
				
				return collide
			end,
			mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
			maxs = Vector( WallOffset, WallOffset, WallOffset ),
		} )
		
		view.origin = tr.HitPos
		
		if tr.Hit and not tr.StartSolid then
			view.origin = view.origin + tr.HitNormal * WallOffset
		end
		
		return view
	else
		local radius = 800
		radius = radius + 400 + 400 * Pod:GetCameraDistance()
		
		local TargetOrigin = self:LocalToWorld( Vector(0,61,50) ) - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
		local WallOffset = 4
		
		local tr = util.TraceHull( {
			start = view.origin,
			endpos = TargetOrigin,
			filter = function( e )
				local c = e:GetClass()
				local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
				
				return collide
			end,
			mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
			maxs = Vector( WallOffset, WallOffset, WallOffset ),
		} )
		
		view.origin = tr.HitPos
		
		if tr.Hit and not tr.StartSolid then
			view.origin = view.origin + tr.HitNormal * WallOffset
		end
		
		return view
	end
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	return self:LFSCalcViewThirdPerson( view )
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "niksacokica/tie_boarding_craft/engine.wav" )
		self.ENG:PlayEx(1,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.DIST then
		self.DIST:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
end

function ENT:AnimRotor()
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
end

function ENT:Draw()
	self:DrawModel()

	if not self:GetEngineActive() then return end

	local Boost = self.BoostAdd or 0

	local Size = 50
	local Size2 = 33
	local Size3 = 20
	
	local r = Color( 255, 100, 100, 255)

	render.SetMaterial(Material( "sprites/light_glow02_add" ))
	render.DrawSprite( self:LocalToWorld( Vector(-156,4,2.5) ), Size, Size, r )
	render.DrawSprite( self:LocalToWorld( Vector(-160,4,2.5) ), Size2, Size2, r )
	render.DrawSprite( self:LocalToWorld( Vector(-163,4,2.5) ), Size3, Size3, r )
	render.DrawSprite( self:LocalToWorld( Vector(-156,-9,2.5) ), Size, Size, r )
	render.DrawSprite( self:LocalToWorld( Vector(-160,-9,2.5) ), Size2, Size2, r )
	render.DrawSprite( self:LocalToWorld( Vector(-163,-9,2.5) ), Size3, Size3, r )
	
	render.DrawSprite( self:LocalToWorld( Vector(-156,122,2.5) ), Size, Size, r )
	render.DrawSprite( self:LocalToWorld( Vector(-160,122,2.5) ), Size2, Size2, r )
	render.DrawSprite( self:LocalToWorld( Vector(-163,122,2.5) ), Size3, Size3, r )
	render.DrawSprite( self:LocalToWorld( Vector(-156,136,2.5) ), Size, Size, r )
	render.DrawSprite( self:LocalToWorld( Vector(-160,136,2.5) ), Size2, Size2, r )
	render.DrawSprite( self:LocalToWorld( Vector(-163,136,2.5) ), Size3, Size3, r )
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	local Driver = self:GetDriver()
	if IsValid( Driver ) then
		local W = Driver:KeyPressed( IN_FORWARD )
		if W ~= self.oldW then
			self.oldW = W
			if W then
				self.BoostAdd = 80
			end
		end
	end
	
	self.BoostAdd = self.BoostAdd and (self.BoostAdd - self.BoostAdd * FrameTime()) or 0
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.01
		
		local emitter = ParticleEmitter( self:GetPos(), false )
		local Pos = {
			Vector(-150,4,2.5),
			Vector(-150,-9,2.5),
			Vector(-150,122.5,3),
			Vector(-150,136,3),
			Vector(-150,4,2.5),
			Vector(-150,-9,2.5),
			Vector(-150,122.5,3),
			Vector(-150,136,3),
		}
		
		if emitter then
			for k, v in pairs( Pos ) do
				local Sub = Mirror and 1 or -1
				local vOffset = self:LocalToWorld( v )
				local vNormal = -self:GetForward()

				vOffset = vOffset + vNormal * 5

				local particle = emitter:Add( "effects/strider_muzzle", vOffset )
				if not particle then return end

				particle:SetVelocity( vNormal * math.Rand(100,500) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.03 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(15,25) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 255, 100, 100 )
			end
			
			emitter:Finish()
		end
	end
end