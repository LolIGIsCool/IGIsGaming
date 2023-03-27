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

function ENT:LFSCalcViewFirstPerson( view, ply, FirstPerson )
	for k, v in pairs(self:GetChildren()) do
		if not v:IsVehicle() and ply == self:GetDriver() then
			v:SetNoDraw(true)
		end
	end
	view.origin = self:LocalToWorld( Vector(-15,0,27) )
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply, ThirdPerson )
	for k, v in pairs(self:GetChildren()) do
		if not v:IsVehicle() and ply == self:GetDriver() then
			v:SetNoDraw(false)
		end
	end
	return view
end

function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	draw.SimpleText( "SPEED", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	draw.SimpleText( "PRI", "LFS_FONT", 10, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( AmmoPrimary, "LFS_FONT", 120, 35, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "niksacokica/74-z_speeder_bike/engine_loop.wav" )
		self.ENG:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp( 60 + Pitch * 30 + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( Pitch, 0.5,1) )
	end
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
end