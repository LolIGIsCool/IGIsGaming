
include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if not self:GetEngineActive() then return end

	local Boost = self.BoostAdd or 0

	local Size = 20 + (self:GetRPM() / self:GetLimitRPM()) * 100 + Boost

	render.SetMaterial(Material( "sprites/light_glow02_add" ))
	/*render.DrawSprite( self:LocalToWorld( Vector(-167,76,0) ), Size, Size, Color( 255, 25, 25, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-167,58.5,0) ), Size, Size, Color( 255, 25, 25, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-167,-102.5,0) ), Size, Size, Color( 255, 25, 25, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-167,-85,0) ), Size, Size, Color( 255, 25, 25, 255) )*/

	render.DrawSprite( self:LocalToWorld( Vector(-150.3,68.4,0) ), Size, Size, Color( 255, 25, 25, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-150.3,52.56,0) ), Size, Size, Color( 255, 25, 25, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-150.3,-95.25,0) ), Size, Size, Color( 255, 25, 25, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-150.3,-78.5,0) ), Size, Size, Color( 255, 25, 25, 255) )
end

function ENT:LFSCalcViewFirstPerson( view, ply ) -- modify first person camera view here
	--[[
	if ply == self:GetDriver() then
		-- driver view
	elseif ply == self:GetGunner() then
		-- gunner view
	else
		-- everyone elses view
	end
	]]--

	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply ) -- modify third person camera view here
	local ply = LocalPlayer()

	local Pod = ply:GetVehicle()

	if not IsValid( Pod ) then return view end

	if ply == self:GetDriver() then
		local radius = 650
		radius = radius + radius * Pod:GetCameraDistance()

		view.origin = self:LocalToWorld( Vector(0,0,0) )

		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * 1200 * 0.2
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

function ENT:LFSHudPaint( X, Y, data, ply ) -- driver only
end

function ENT:LFSHudPaintPassenger( X, Y, ply ) -- all except driver
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp( 60 + Pitch * 40 + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( Pitch, 0.5,1) )
	end

	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  50 + Pitch * 60, 50,255) + Doppler,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "VANILLA_TIEBOMBER_ENGINE" )
		self.ENG:PlayEx(0,0)

		self.DIST = CreateSound(self,"VANILLA_TIEBOMBER_HUM")
		self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()

	if IsValid( self.TheRotor ) then -- if we have an rotor
		self.TheRotor:Remove() -- remove it
	end
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
	if self.DIST then
		self.DIST:Stop()
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
end
