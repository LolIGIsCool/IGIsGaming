--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:Initialize()
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	local Driver = self:GetDriver()
	if IsValid( Driver ) then
		local W = Driver:lfsGetInput( "+THROTTLE" )
		if W ~= self.oldW then
			self.oldW = W
			if W then
				self.BoostAdd = 0
			end
		end
	end
	
	self.BoostAdd = self.BoostAdd and (self.BoostAdd - self.BoostAdd * FrameTime()) or 0
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.01
		
		local emitter = ParticleEmitter( self:GetPos(), false )

		if emitter then
			local Mirror = false
			for i = 0,1 do
				local Sub = Mirror and 1 or -1
				local vOffset = self:LocalToWorld( Vector(-163.81,64.51 * Sub,8.36) )
				local vNormal = -self:GetForward()

				vOffset = vOffset + vNormal * 5

				local particle = emitter:Add( "effects/muzzleflash2", vOffset )
				if not particle then return end

				particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(15,25) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 255, 0, 200 )
			
				Mirror = true
			end
			
			emitter:Finish()
		end
	end
end

function ENT:CalcEngineSound()
	local CurTone = (LocalPlayer():GetViewEntity() :GetPos() - self:GetPos()):Length()
	self.PitchOffset = self.PitchOffset and self.PitchOffset + (math.Clamp((CurTone - self.OldDist) * FrameTime() * 300,-40,40) - self.PitchOffset) * FrameTime() * 5 or 0
	local Doppler = -self.PitchOffset
	self.OldDist = CurTone
	
	local RPM = self:GetRPM()
	local Pitch = (RPM - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  60 + Pitch * 50, 80,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
	end
	
	if self.TONE then
		self.TONE:ChangePitch(  math.Clamp(math.Clamp( 10 + Pitch * 99, 60,255) + Doppler * 1.25,0,255) )
		self.TONE:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,.8) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "tonnnn" )
		self.ENG:PlayEx(0,0)
		
		self.TONE = CreateSound( self, "tonnnn2" )
		self.TONE:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.TONE then
		self.TONE:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
	local Driver = self:GetDriver()
	local Gunner = self:GetGunner()
	
	local HasGunner = IsValid( Gunner )
	
	if not IsValid( Driver ) and not HasGunner then return end
	
	if HasGunner then Driver = Gunner end
	
	local EyeAngles = self:WorldToLocalAngles( Driver:EyeAngles() )
	EyeAngles:RotateAroundAxis( EyeAngles:Up(), 180 )
	
	local Yaw = math.Clamp( EyeAngles.y,-45,45)
	local Pitch = math.Clamp( EyeAngles.p,-15,15 )
	
	if not Driver:lfsGetInput( "FREELOOK" ) and not HasGunner then
		Yaw = 0
		Pitch = 0
	end
	
	self:ManipulateBoneAngles( 1, Angle(Yaw,0,0) )
	self:ManipulateBoneAngles( 2, Angle(0,0,Pitch) )
	
	self:ManipulateBoneAngles( 5, Angle(Yaw,0,0) )
	self:ManipulateBoneAngles( 4, Angle(0,0,Pitch) )
end

function ENT:AnimRotor()

	self.AstroAng = self.AstroAng or 0
	self.nextAstro = self.nextAstro or 0
	if self.nextAstro < CurTime() then
		self.nextAstro = CurTime() + math.Rand(0.5,2)
		self.AstroAng = math.Rand(-180,180)
		
		if math.random(0,4) == 3 then
		end
	end
	
	self.smastro = self.smastro and (self.smastro + (self.AstroAng - self.smastro) * FrameTime() * 10) or 0
	
	self:ManipulateBoneAngles( 7, Angle(self.smastro,0,0) )
end

function ENT:AnimCabin()
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (20 *  self:GetLGear() - self.SMLG) * FrameTime() * 2 or 0
	
	local Ang = 20 - self.SMLG
	self:ManipulateBoneAngles( 13, Angle(0,-Ang,0) )
	self:ManipulateBoneAngles( 18, Angle(0,Ang,0) )
	
	self:ManipulateBoneAngles( 15, Angle(0,Ang,0) )
	self:ManipulateBoneAngles( 14, Angle(0,-Ang,0) )
end

local mat = Material( "sprites/light_glow02_add" )
function ENT:Draw()
	self:DrawModel()
	
	if not self:GetEngineActive() then return end
	
	local Boost = self.BoostAdd or 0
	
	local Size = 100 + (self:GetRPM() / self:GetLimitRPM()) * 30 + Boost
	local Mirror = false
	for i = 0,1 do
		local Sub = Mirror and 1 or -1
		local pos = self:LocalToWorld( Vector(-175.81,71 * Sub,8.36) )
		
		render.SetMaterial( mat )
		render.DrawSprite( pos, Size, Size, Color( 255, 0, 0, 255) )
		
		local Size = 22 + (self:GetRPM() / self:GetLimitRPM()) * 30 + Boost
		
		render.SetMaterial( mat )
	   render.DrawSprite( self:LocalToWorld( Vector(-173,-70.2,8) ), Size, Size, Color( 255, 250, 250, 255) )
	   render.DrawSprite( self:LocalToWorld( Vector(-173,70.2,8) ), Size, Size, Color( 255, 250, 250, 255) )
		Mirror = true
	end
end
