include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply )
	return self:LFSCalcViewThirdPerson( view )
end

function ENT:LFSCalcViewThirdPerson( view )
	local ply = LocalPlayer()
	if not IsValid( ply:GetVehicle() ) then return view end

	local radius = 1000
	radius = radius + 400 + 400 * ply:GetVehicle():GetCameraDistance()

	local TargetOrigin = self:LocalToWorld( Vector(0,0,0) ) - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
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

function ENT:LFSHudPaint( X, Y, data, ply ) -- driver only
end

function ENT:LFSHudPaintPassenger( X, Y, ply ) -- all except driver
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

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "TIER_ENGINE" )
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

function ENT:Draw()
	self:DrawModel()

	if not self:GetEngineActive() then return end
	local Boost = self.BoostAdd or 0

	local Size = 100
	local c = Color( 255, 100, 100, 255)

	render.SetMaterial(Material( "sprites/light_glow02_add" ))
	for i=0, 1 do
		for j=0, 2 do
			render.DrawSprite( self:LocalToWorld( Vector(-515,30-(60*i),22) ), Size, Size, c )
			render.DrawSprite( self:LocalToWorld( Vector(-515,40-(80*i),22) ), Size, Size, c )
			render.DrawSprite( self:LocalToWorld( Vector(-515,50-(100*i),22) ), Size, Size,c )
			render.DrawSprite( self:LocalToWorld( Vector(-515,60-(120*i),22) ), Size, Size,c )
		end
	end
end

function ENT:AnimFins()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:AnimCabin()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:AnimLandingGear()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:ExhaustFX()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end
