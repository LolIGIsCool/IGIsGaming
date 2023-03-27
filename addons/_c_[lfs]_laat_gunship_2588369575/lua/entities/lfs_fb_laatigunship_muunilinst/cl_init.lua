include("shared.lua")

function ENT:Initialize()
	self.nextEFX = 0
	self.nextDFX = 0
	self.nextBeepSound = 0
	self.nextLFX = 0
	self.NextAlertSound = 0
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP <= 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin(self:LocalToWorld(Vector(-280, 0, 250)))
		util.Effect("lfs_blacksmoke", effectdata)

		if HP <= 2000 then
			if math.random(0, 45) < 3 then
				if math.random(1, 3) == 1 then
					local Pos = self:LocalToWorld(Vector(0, 0, 140) + VectorRand() * 20)
						effectdata:SetOrigin(Pos)
					util.Effect("cball_explode", effectdata, true, true)
					
					sound.Play("laat_bf2/spark"..math.random(1, 4)..".ogg", Pos, 75)
				end
			end

			local ply = LocalPlayer()
			if ply == self:GetGunner() || ply == self:GetDriver() then
				if self.NextAlertSound < CurTime() then
					self.NextAlertSound = CurTime() + 0.27
					sound.Play("laat_bf2/crash.mp3", self:GetPos() + self:GetForward() * 190 + self:GetUp() * 160, 75)
				end
			end
		end
	end
end

local function DrawCircle( X, Y, radius )
	local segmentdist = 360 / ( 2 * math.pi * radius / 2 )
	
	for a = 0, 360, segmentdist do
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
		surface.DrawLine( X + math.cos( math.rad( a ) ) * radius, Y - math.sin( math.rad( a ) ) * radius, X + math.cos( math.rad( a + segmentdist ) ) * radius, Y - math.sin( math.rad( a + segmentdist ) ) * radius )
	end
end

function ENT:EmitLockSound(time)
	if self.nextBeepSound >= CurTime() then return end
	self.nextBeepSound = CurTime() + time
	self:EmitSound("LAAT_LOCK_ON")
end

local zoom_mat = Material( "vgui/zoom" )
function ENT:LFSHudPaintPassenger( X, Y, ply )
	if ply == self:GetGunner() then
		local EyeAngles = ply:EyeAngles()
		
		local RearGunActive = self:GetGXHairRG()
		local WingTurretActive = self:GetGXHairWT()

		local X = ScrW() * 0.5
		local Y = ScrH() * 0.5

		if RearGunActive or WingTurretActive then
			surface.SetDrawColor( 255, 255, 255, 255 )
		else
			surface.SetDrawColor( 255, 0, 0, 255 )
		end
		
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

		local target = self:GetWingRocketTarget()
		if IsValid(target) then
			local pos = target:GetPos() + target:OBBCenter()
			pos = pos:ToScreen()

			local w = ScrW() / 40
			local timelock = self:GetTimeLock()
            if timelock >= 3 then
				self:EmitLockSound(0.1)
                surface.SetDrawColor(255, 0, 0)
            elseif timelock >= 2 then
				self:EmitLockSound(0.2)
                surface.SetDrawColor(255, 255, 0)
            elseif timelock >= 1 then
				self:EmitLockSound(0.4)
                surface.SetDrawColor(0, 255, 0)
            end
            surface.DrawOutlinedRect(pos.x - (w / 2), pos.y - (w / 2), w, w, 2)
		end

		local heat = self:GetWingTurretHeat() / 100
		if heat > 0.01 then
			local sX = 70
			local sY = 6
			X = X - sX * 0.5
			Y = Y + 25
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(X - 1, Y - 1, sX + 2, sY + 2)
			surface.SetDrawColor(150, 150, 150, 100)
			surface.DrawRect(X, Y, sX, sY)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawRect(X, Y, sX * math.min(heat, 1), sY)
	
			if heat > 1 then
				surface.SetDrawColor(255, 0, 0, 255)
				surface.DrawRect(X + sX, Y, sX * math.min(heat - 1, 1), sY)
			end
		end
	end
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	return self:LFSCalcViewThirdPerson( view, ply, true )
end

function ENT:LFSCalcViewThirdPerson( view, ply, FirstPerson )
	local Pod = ply:GetVehicle()

	if ply == self:GetDriver() then
	
	elseif ply == self:GetGunner() then
		local radius = 800
		radius = radius + radius * Pod:GetCameraDistance()
		
		local StartPos = self:GetRotorPos() + view.angles:Up() * 250
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
	else
		view.angles = ply:GetVehicle():LocalToWorldAngles( ply:EyeAngles() )
		
		if FirstPerson then
			view.origin = view.origin + Pod:GetUp() * 40
		else
			view.origin = ply:GetShootPos() + Pod:GetUp() * 40
			
			local radius = 800
			radius = radius + radius * Pod:GetCameraDistance()
			
			local TargetOrigin = view.origin - view.angles:Forward() * radius
			
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
			
			view.drawviewer = true
			view.origin = tr.HitPos
			
			if tr.Hit and not tr.StartSolid then
				view.origin = view.origin + tr.HitNormal * WallOffset
			end
		end
	end
	
	return view
end

function ENT:ExhaustFX()
	local FullThrottle = self:GetThrottlePercent() >= 35
	
	if self.OldFullThrottle ~= FullThrottle then
		self.OldFullThrottle = FullThrottle
		if FullThrottle then 
			self:EmitSound("LAAT_BOOST")
		end
	end

	if self:GetEngineActive() then
		if self.nextEFX < CurTime() then
			self.nextEFX = CurTime() + 0.01
			
			local emitter = ParticleEmitter(self:GetPos(), false)
			local Pos = {
				Vector(-270, -20, 265),
				Vector(-270, 20, 265),
			}

			if emitter then
				for _, v in pairs(Pos) do
					local vOffset = self:LocalToWorld( v )
					local vNormal = -self:GetForward()
					local vOffset2 = vOffset + vNormal * 5

					local particle = emitter:Add("sprites/heatwave", vOffset2)
					if not particle then return end
						particle:SetVelocity(vNormal * math.Rand(1500, 1000) + self:GetVelocity())
						particle:SetLifeTime(0)
						particle:SetDieTime(0.1)
						particle:SetStartAlpha(255)
						particle:SetEndAlpha(0)
						particle:SetStartSize(math.Rand(35, 50))
						particle:SetEndSize(math.Rand(0, 5))
						particle:SetRoll(math.Rand(-1, 1) * 100)
						particle:SetColor(255, 255, 255)
				end
				
				emitter:Finish()
			end
		end
	end
end

function ENT:CanSound()
	self.NextSound = self.NextSound or 0
	return self.NextSound < CurTime()
end

function ENT:CanSound2()
	self.NextSound2 = self.NextSound2 or 0
	return self.NextSound2 < CurTime()
end

function ENT:DelayNextSound( fDelay )
	if not isnumber( fDelay ) then return end
	
	self.NextSound = CurTime() + fDelay
end

function ENT:DelayNextSound2( fDelay )
	if not isnumber( fDelay ) then return end
	
	self.NextSound2 = CurTime() + fDelay
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(math.Clamp(math.Clamp(80 + Pitch * 25, 50, 255) + Doppler, 0, 255))
		self.ENG:ChangeVolume(math.Clamp(-1 + Pitch * 6, 0.5, 1))
	end
	
	if self.DIST then
		local ply = LocalPlayer()
		local DistMul = math.min((self:GetPos() - ply:GetPos()):Length() / 8000, 1) ^ 2
		self.DIST:ChangePitch(math.Clamp(100 + Doppler * 0.2, 0, 255))
		self.DIST:ChangeVolume(math.Clamp(-1.5 + Pitch * 6, 0.5, 1) * DistMul)
	end
	
	local OnGround = self:GetIsGroundTouching()
	if self.OldGroundTouching == nil then self.OldGroundTouching = true end
	
	if OnGround ~= self.OldGroundTouching then
		self.OldGroundTouching = OnGround
		if not OnGround then
			if self:CanSound() then
				self:EmitSound("LAAT_TAKEOFF")
				self:DelayNextSound(3)
				self:DelayNextSound2(1.5)
			end
		else
			if self:CanSound2() then
				self:EmitSound("LAAT_LANDING")
				self:DelayNextSound(1.5)
				self:DelayNextSound2(3)
			end
		end
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound(self, "LAAT_ENGINE")
			self.ENG:PlayEx(0, 0)
		
		self.DIST = CreateSound(self, "LAAT_DIST")
			self.DIST:PlayEx(0, 0)

		self.ActiveTime = CurTime()
		self.nextEFX = CurTime() + 1
	else
		self:SoundStop()

		self.StopTime = CurTime()
	end
end

function ENT:OnRemove()
	self:SoundStop()
end

function ENT:SoundStop()
	if self.BTLOOP then
		self.BTLOOP:Stop()
	end
	
	if self.BTRLOOP then
		self.BTRLOOP:Stop()
	end
	
	if self.BTLLOOP then
		self.BTLLOOP:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
	
	if self.DIST then
		self.DIST:Stop()
	end
end

function ENT:AnimFins()
end

function ENT:AnimRotor()
end

function ENT:AnimCabin()
	local FireWingTurret = self:GetWingTurretFire()
	if FireWingTurret ~= self.OldWingTurretFire then
		self.OldWingTurretFire = FireWingTurret
		
		if FireWingTurret then
			self:EmitSound("LAAT_BT_FIRE")
			
			self.BTLOOP = CreateSound(self, "LAAT_BT_FIRE_LOOP_CHAN1")
				self.BTLOOP:Play()
			
			local effectdata = EffectData()
				effectdata:SetEntity(self)
			util.Effect("lfs_fb_wingturret_projector", effectdata)
		else
			if self.BTLOOP then
				self.BTLOOP:Stop()
			end
		end
	end
end

function ENT:AnimLandingGear()
end

local glow_spotlight = Material("sprites/light_glow02_add")
local glow_reactor = Material("sprites/light_glow02_add")
local lamp_pos = Vector(3, 0, 135)
local lamp_color_black = Color(0, 0, 0)
local lamp_color_red = Color(255, 0, 0)
local lamp_color_green = Color(0, 255, 0)
local reactor_color = Color(0, 127, 255)
local reactor_pos = {
	Vector(-270, -20, 265),
	Vector(-270, 20, 265),
}
function ENT:Draw()
	self:DrawModel()

	if self:GetEngineActive() then
		render.SetMaterial(glow_reactor)
		local delta = CurTime() - self.ActiveTime
		local max = math.min(15 * ( delta / 1 ), 15)

		local t = 0
		for _, v in pairs(reactor_pos) do
			if self:GetUncontrollable() then
				if self.nextLFX > CurTime() && t == 1 then continue end
				self.nextLFX = CurTime() + math.random(0, 2)
			end

			local vOffset = self:LocalToWorld(v)
			local vNormal = -self:GetForward()
			
			for i = 0, max do 
				local vUp = -self:GetUp()
				local ind = i * 2
				local vOffsetTmp = vOffset + vNormal * -2 + vUp * ind + vNormal * ind

				render.DrawSprite(vOffsetTmp, 60, 60, reactor_color)
			end

			t = t + 1
		end
	else
		if self:GetUncontrollable() then
			if self.nextLFX <= CurTime() then 
				self.nextLFX = CurTime() + math.random(0, 2)

				render.SetMaterial(glow_reactor)

				local vOffset = self:LocalToWorld(reactor_pos[2])
				local vNormal = -self:GetForward()
				
				for i = 0, 15 do 
					local vUp = -self:GetUp()
					local ind = i * 2
					local vOffsetTmp = vOffset + vNormal * -2 + vUp * ind + vNormal * ind

					render.DrawSprite(vOffsetTmp, 60, 60, reactor_color)
				end
			end
		end
	end

	local StartPos = self:LocalToWorld(lamp_pos)
	render.SetMaterial(glow_spotlight)
	local lamp_mode = self:GetLampMode()
	render.DrawSprite(StartPos, 80, 80, lamp_mode == 0 && lamp_color_black || lamp_mode == 1 && lamp_color_red || lamp_color_green)
end