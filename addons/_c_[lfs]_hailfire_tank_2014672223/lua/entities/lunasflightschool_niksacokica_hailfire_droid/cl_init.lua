include("shared.lua")

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-90,0,40) ) )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:LFSCalcViewThirdPerson( view, ply, FirstPerson )
	local Pod = ply:GetVehicle()
	
		if FirstPerson then
			view.origin = view.origin + Pod:GetUp() * 80
		else
		local radius = 800
		radius = radius + radius * Pod:GetCameraDistance()
		
		local StartPos = self:LocalToWorld( Vector(-130.360611,0,111.885109) ) + view.angles:Up() * 100
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

function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	draw.SimpleText( "SPEED", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	draw.SimpleText( "PRI", "LFS_FONT", 10, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoPrimary, "LFS_FONT", 120, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	draw.SimpleText( "SEC", "LFS_FONT", 10, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoSecondary-1, "LFS_FONT", 120, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "ambient/machines/train_idle.wav" )
		self.ENG:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "ambient/machines/train_idle.wav" )
		self.DIST:PlayEx(0, 0)
	else
		self:SoundStop()
	end
end

function ENT:SoundStop()
	if self.DIST then
		self.DIST:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
end