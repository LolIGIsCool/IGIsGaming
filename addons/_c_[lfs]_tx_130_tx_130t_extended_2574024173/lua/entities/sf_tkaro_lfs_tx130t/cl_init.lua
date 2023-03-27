--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE
--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply )
	local Driver, Gunner = self:GetDriver(), self:GetGunner()

	if ply == Driver then
		view.origin = self:LocalToWorld( Vector(-65,25,55) )
	elseif ply == Gunner then
		view.origin = self:LocalToWorld( Vector(-100,0,95) )
	else
		view.origin = self:LocalToWorld( Vector(-65,-25,55) )
	end
	
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	if ply == self:GetDriver() then
	local Pod = ply:GetVehicle()
	
	local radius = 400
		radius = radius + radius * Pod:GetCameraDistance()
		
		local StartPos = self:LocalToWorld( Vector(0,0,50) ) + view.angles:Up() * 100
		local EndPos = StartPos - view.angles:Forward() * radius
		
		local WallOffset = 4

		local tr = util.TraceHull( {
			start = StartPos,
			endpos = EndPos,
			filter = function( e )
				local c = e:GetClass()
				local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
				
				return collide
			end,
			mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
			maxs = Vector( WallOffset, WallOffset, WallOffset ),
		} )
		
		view.drawviewer = true
		view.origin = tr.HitPos
		
		if tr.Hit and not tr.StartSolid then
			view.origin = view.origin + tr.HitNormal * WallOffset
		end
		end
	return view
end

function ENT:LFSHudPaint( X, Y, data, ply ) -- driver only
end


function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	draw.SimpleText( "SPEED", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	draw.SimpleText( "PRI", "LFS_FONT", 10, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoPrimary, "LFS_FONT", 120, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	draw.SimpleText( "SEC", "LFS_FONT", 10, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoSecondary, "LFS_FONT", 120, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function ENT:LFSHudPaintInfoLine( HitPlane, HitPilot, LFS_TIME_NOTIFY, Dir, Len, FREELOOK )
end

function ENT:LFSHudPaintCrosshair( HitEnt, HitPly)
	local startpos = self:GetRotorPos()
	local TracePilot = util.TraceHull( {
		start = startpos,
		endpos = (startpos + LocalPlayer():EyeAngles():Forward() * 50000),
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		filter = self
	} )
	local HitPilot = TracePilot.HitPos:ToScreen()

	local X = HitPilot.x
	local Y = HitPilot.y
	
	if self:GetWeaponOutOfRange() then
		surface.SetDrawColor( 255, 0, 0, 255 )
	else
		surface.SetDrawColor( 255, 255, 255, 255 )
	end

	simfphys.LFS.DrawCircle( X, Y, 10 )
	surface.DrawLine( X + 10, Y, X + 20, Y ) 
	surface.DrawLine( X - 10, Y, X - 20, Y ) 
	surface.DrawLine( X, Y + 10, X, Y + 20 ) 
	surface.DrawLine( X, Y - 10, X, Y - 20 ) 
	
	-- shadow
	surface.SetDrawColor( 0, 0, 0, 80 )
	simfphys.LFS.DrawCircle( X + 1, Y + 1, 10 )
	surface.DrawLine( X + 11, Y + 1, X + 21, Y + 1 ) 
	surface.DrawLine( X - 9, Y + 1, X - 16, Y + 1 ) 
	surface.DrawLine( X + 1, Y + 11, X + 1, Y + 21 ) 
	surface.DrawLine( X + 1, Y - 19, X + 1, Y - 16 ) 
end

function ENT:LFSHudPaintRollIndicator( HitPlane, Enabled )
end

local function DrawCircle( X, Y, radius )
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
		
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

function ENT:LFSHudPaintPassenger( X, Y, ply )
	if self:GetBodygroup(1) == 0 then return end

	if ply == self:GetGunner() then
		local ID = self:LookupAttachment( "lazer_cannon_muzzle" )
		local Muzzle = self:GetAttachment( ID )
		
		if Muzzle then
			local Pos = Muzzle.Pos
			local Dir = Muzzle.Ang:Up()

			local trace = util.TraceLine( {
				start = Pos,
				endpos = Pos + Dir * 50000,
				filter = self:GetCrosshairFilterEnts()
			} )

			local hitpos = trace.HitPos:ToScreen()

			local X = hitpos.x
			local Y = hitpos.y

			surface.SetDrawColor( 255, 255, 255, 255 )

			DrawCircle( X, Y, 10 )
			surface.DrawLine( X + 10, Y, X + 20, Y ) 
			surface.DrawLine( X - 10, Y, X - 20, Y ) 
			surface.DrawLine( X, Y + 10, X, Y + 20 ) 
			surface.DrawLine( X, Y - 10, X, Y - 20 ) 
			
			-- shadow
			surface.SetDrawColor( 0, 0, 0, 80 )
			DrawCircle( X + 1, Y + 1, 10 )
			surface.DrawLine( X + 11, Y + 1, X + 21, Y + 1 ) 
			surface.DrawLine( X - 9, Y + 1, X - 16, Y + 1 ) 
			surface.DrawLine( X + 1, Y + 11, X + 1, Y + 21 ) 
			surface.DrawLine( X + 1, Y - 19, X + 1, Y - 16 ) 
		end
	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp( 60 + Pitch * 30 + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( Pitch, 0.5,1) )
	end

	if self.ENG_HI then
		self.ENG_HI:ChangePitch(  math.Clamp( 60 + Pitch * 30 + Doppler,0,255) )
		self.ENG_HI:ChangeVolume( math.Clamp( Pitch, 0.5,1) )
	end

	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp(  Pitch * 100, 50,255) + Doppler * 1.25,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1.5 + Pitch * 6, 0.5,1) )
	end
end

function ENT:AnimCabin()
	local Fire = self:GetBTLFire()
	if Fire ~= self.OldFireBTL then
		self.OldFireBTL = Fire
		
		if Fire then
			self:EmitSound("LAATi_BT_FIRE")
			
			self.BTLLOOP = CreateSound( self, "LAATi_BT_FIRE_LOOP_CHAN1" )
			self.BTLLOOP:Play()
			
			local effectdata = EffectData()
			effectdata:SetEntity( self )
			util.Effect( "tx_130_projector", effectdata )
		else
			if self.BTLLOOP then
				self.BTLLOOP:Stop()
			end
		end
	end
	
	local bOn = self:GetActive()
	
	local TVal = bOn and 0 or 1
	
	local Speed = FrameTime() * 4
	
	self.SMcOpen = self.SMcOpen and self.SMcOpen + math.Clamp(TVal - self.SMcOpen,-Speed,Speed) or 0
	
	self:ManipulateBoneAngles( 20, Angle(0,0,self.SMcOpen * -95) ) 
	
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "TX_ENGINE" )
		self.ENG:PlayEx(0,0)

	

		self.DIST = CreateSound( self, "TX_DIST" )
		self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:RemoveLight()
	if IsValid( self.projector ) then
		self.projector:Remove()
		self.projector = nil
	end
end

function ENT:OnRemove()
	self:SoundStop()
	
	self:RemoveLight()
end

function ENT:SoundStop()
	if self.DIST then
		self.DIST:Stop()
	end

	if self.ENG then
		self.ENG:Stop()
	end

	if self.ENG_HI then
		self.ENG_HI:Stop()
	end

	if self.BTLLOOP then
		self.BTLLOOP:Stop()
	end
end

function ENT:AnimFins()
end

local spotlight = Material( "effects/lfs_base/spotlight_projectorbeam" )
local glow_spotlight = Material( "sprites/light_glow02_add" )

function ENT:Draw()
	self:DrawModel()

	if self:GetBodygroup( 9 ) ~= 1 or not self:GetEngineActive() then 
		self:RemoveLight()

		return
	end

	if not IsValid( self.projector ) then
		local thelamp = ProjectedTexture()
		thelamp:SetBrightness( 10 ) 
		thelamp:SetTexture( "effects/flashlight/soft" )
		thelamp:SetColor( Color(255,255,255) ) 
		thelamp:SetEnableShadows( false ) 
		thelamp:SetFarZ( 2500 ) 
		thelamp:SetNearZ( 75 ) 
		thelamp:SetFOV( 50 )
		self.projector = thelamp
	end

	local StartPos = self:LocalToWorld( Vector(60,0,10.5) )
	local Dir = self:GetForward()

	render.SetMaterial( glow_spotlight )
	render.DrawSprite( StartPos + Dir * -10 , 220, 120, Color( 255, 255, 255, 255) )


	render.SetMaterial( spotlight )
	render.DrawBeam(  StartPos - Dir * 10,  StartPos + Dir * 800, 250, 0, 0.99, Color( 255, 255, 255, 10) ) 
	
	if IsValid( self.projector ) then
		self.projector:SetPos( StartPos )
		self.projector:SetAngles( Dir:Angle() )
		self.projector:Update()
	end
end