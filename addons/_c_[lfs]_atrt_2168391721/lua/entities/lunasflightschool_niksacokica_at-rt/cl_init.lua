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

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  70 + 45, 50,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( -1 + 1, 0.5,1) )
	end

	if self.DIST then
		self.DIST:ChangePitch(  math.Clamp(math.Clamp( 150, 50,255) + Doppler,0,255) )
		self.DIST:ChangeVolume( math.Clamp( -1 + 1, 0.5,1) )
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