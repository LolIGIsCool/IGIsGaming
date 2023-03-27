include("shared.lua")

function ENT:Initialize()	

end

function ENT:Think()

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
				self.BoostAdd = 40
			end
		end
	end
	
	self.BoostAdd = self.BoostAdd and (self.BoostAdd - self.BoostAdd * FrameTime()) or 0
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP > self:GetMaxHP() * 0.5 then return end
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		for k,v in pairs( {Vector(3.52,99.98,-68.78) } ) do
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( v ) )
			util.Effect( "lfs_blacksmoke", effectdata )

		end
	end

	if HP > self:GetMaxHP() * 0.25 then 
		self.pp = 1
	else
		self.pp = 0.5
	end
	
	self.beep = self.beep or 0
	if self.beep < CurTime() then
		self.beep = CurTime() + self.pp
		self:EmitSound("slave1/shielddamage.wav")
	end
	


end

function ENT:GunCamera( view, ply )
	return view
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	if ply == self:GetDriver() then
	end
	return self:GunCamera( view, ply )
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	local Pod = ply:GetVehicle()
	if not IsValid( Pod ) then return view end
	if ply == self:GetDriver() then
		local radius = 500
		radius = radius + radius * Pod:GetCameraDistance()
		
		view.origin = self:LocalToWorld( Vector(0,0,0) )
		
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * 750 * 0.1
		local WallOffset = 1

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

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "slave1/engine.wav" )
		self.ENG:PlayEx(0,0)
        self.ENG:SetSoundLevel(100)
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

local mat = Material( "sprites/light_glow02_add" )
function ENT:Draw()
	self:DrawModel()
	
	if not self:GetEngineActive() then return end

	local Boost = self.BoostAdd or 0
	local Size = 100 + (self:GetRPM() / self:GetLimitRPM()) * 25 + Boost
	
	local Size2 = 200 + (self:GetRPM() / self:GetLimitRPM()) * 25 + Boost
	local Size3 = 150 + (self:GetRPM() / self:GetLimitRPM()) * 25 + Boost
	local Size4 = 60 + (self:GetRPM() / self:GetLimitRPM()) * 25 + Boost
	
	render.SetMaterial(Material( "sprites/redglow1" ))
	render.DrawSprite( self:LocalToWorld( Vector(-40,-70,-93) ), Size, Size, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-40,-70,-93) ), Size2, Size2, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-40,-70,-93) ), Size3, Size3, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-40,-70,-93) ), Size, Size, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-40,70,-93) ), Size, Size, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-40,70,-93) ), Size2, Size2, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-40,70,-93) ), Size3, Size3, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-40,70,-93) ), Size, Size, Color( 80, 255, 255, 255) )
	
	render.DrawSprite( self:LocalToWorld( Vector(-35,75,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,60,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,45,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,30,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,15,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,0,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,-15,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,-30,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,-45,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,-60,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,-75,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,75-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,60-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,45-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,30-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,15-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,0-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,-15-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,-30-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,-45-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-35,-60-7.5,50) ), Size4, Size4, Color( 80, 255, 255, 255) )
end