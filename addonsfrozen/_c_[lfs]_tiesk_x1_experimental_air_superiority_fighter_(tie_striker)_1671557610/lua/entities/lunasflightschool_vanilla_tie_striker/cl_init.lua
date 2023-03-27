include("shared.lua")

function ENT:CalcEngineSound(RPM,Pitch,Doppler)
	if self.ENG then
		self.ENG:ChangePitch(math.Clamp(60+Pitch*40+Doppler,0,255))
		self.ENG:ChangeVolume( math.Clamp(Pitch,0.5,1))
	end
end

function ENT:EngineActiveChanged(bActive)
	if bActive then
		self.ENG=CreateSound(self,"TIE_HUM")
		self.ENG:PlayEx(0,0)
		self.DIST=CreateSound(self,"TIE_HUM")
		self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	self.nextEFX=self.nextEFX or 0
	local THR=(self:GetRPM()-self.IdleRPM)/(self.LimitRPM-self.IdleRPM)
	local Driver=self:GetDriver()
	if IsValid(Driver) then
		local W=Driver:KeyPressed(IN_FORWARD)
		if W~=self.oldW then
			self.oldW=W
			if W then
				self.BoostAdd=80
			end
		end
	end
	self.BoostAdd=self.BoostAdd and (self.BoostAdd-self.BoostAdd*FrameTime()) or 0
	if self.nextEFX<CurTime() then
		self.nextEFX=CurTime()+0.01
		local emitter=ParticleEmitter(self:GetPos(),false)
		local Pos={Vector(-150,-37,73),Vector(-150,37,73)}
		if emitter then
			for k,v in pairs(Pos) do
				local Sub=Mirror and 1 or -1
				local vOffset=self:LocalToWorld(v)
				local vNormal=-self:GetForward()
				vOffset=vOffset+vNormal*5
				local particle=emitter:Add("effects/muzzleflash2",vOffset)
				if not particle then return end
				particle:SetLifeTime(0)
				particle:SetDieTime(0.07)
				particle:SetStartAlpha(255)
				particle:SetVelocity(vNormal*math.Rand(500,1000)+self:GetVelocity())
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(5,12))
				particle:SetEndSize(math.Rand(0,10))
				particle:SetRoll(math.Rand(-1,1)*100)
				particle:SetColor(255,0,0)
			end
			emitter:Finish()
		end
	end
end