--DO NOT EDIT OR REUPLOAD THIS FILE

include("shared.lua")

function ENT:LFSCalcViewThirdPerson( view )
	local ply = LocalPlayer()
	
	local Pod = ply:GetVehicle()
	
	if not IsValid( Pod ) then return view end
	
	if ply == self:GetDriver() then
		local radius = 1000
		radius = radius + radius * Pod:GetCameraDistance()
		
		view.origin = self:LocalToWorld( Vector(0,0,50) )
		
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
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
	else
		if Pod == self:GetGunnerSeat() or Pod == self:GetLowerGunnerSeat() then
			return self:LFSCalcViewFirstPerson( view )
		else
			local radius = 800
			radius = radius + 400 + 400 * Pod:GetCameraDistance()
			
			local TargetOrigin = self:LocalToWorld( Vector(0,0,50) ) - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
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
	end
end

function ENT:LFSCalcViewFirstPerson( view )
	local ply = LocalPlayer()
	
	local Pod = ply:GetVehicle()
	
	if not IsValid( Pod ) then return view end
	
	if ply == self:GetDriver() then
	
	elseif Pod == self:GetGunnerSeat() then
		local obj = self:GetAttachment( self:LookupAttachment( "turret_top_attachment" ) )
		local pos = obj.Pos
		local ang = obj.Ang
		
		local EyeAng = ply:EyeAngles()
		view.drawviewer = false
		view.origin = pos - ang:Forward() * 90 - ang:Up() * 20
		view.angles = ang + Angle(0,0,180)
		
	elseif Pod == self:GetLowerGunnerSeat()  then
		local obj = self:GetAttachment( self:LookupAttachment( "turret_bottom_attachment" ) )
		local pos = obj.Pos
		local ang = obj.Ang

		local EyeAng = ply:EyeAngles()
		view.drawviewer = false
		view.origin = pos - ang:Forward() * 90+ ang:Up() * 20
		view.angles = ang
	else
		return self:LFSCalcViewThirdPerson( view )
	end

	return view
end

function ENT:Initialize()	
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		for k,v in pairs( {Vector(-152.21,-286.91,76.02),Vector(-324.17,0.41,88.57),Vector(-197.89,89.68,103.95),Vector(259.44,-163.89,104.01),Vector(-38.51,-84.16,-128.81)} ) do
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( v ) )
			util.Effect( "lfs_blacksmoke", effectdata )
		end
	end
end

local mat = Material( "sprites/light_glow02_add" )
function ENT:Draw()
	local ply = LocalPlayer()
	if not IsValid( ply ) then return end
	
	local Pod = ply:GetVehicle()
	
	if ply == self:GetDriver() then
		if IsValid( Pod ) then
			if Pod:GetThirdPersonMode() then
				self:DrawModel()
				self.FirstPerson = false
			else
				self.FirstPerson = true
			end
		else
			self:DrawModel()
			self.FirstPerson = false
		end
	else
		self:DrawModel()
		self.FirstPerson = false
	end
	
	if not self:GetEngineActive() then return end
	
	local Radius = 482
	for i = -6,6 do
		local Ang = i * 6
		local X = math.cos( math.rad( Ang ) ) * Radius
		local Y = math.sin( math.rad( Ang ) ) * Radius
		
		cam.Start3D2D( self:LocalToWorld( Vector(-X,Y,0) ), self:LocalToWorldAngles( Angle(0,-90 - Ang ,90) ), 1 )
			draw.NoTexture()
			surface.SetDrawColor( math.min(150 + self.BoostAdd * 2,255), 255, 255, 255 )
			surface.DrawTexturedRect( -25, -20, 50, 45 )
		cam.End3D2D()
	end
	
	render.SetMaterial( mat )

	local Boost = self.BoostAdd or 0
	local Size = math.min(50 + Boost,90)
	local Radius = 500
	for i = -25,25 do
		local Ang = i * 1.5
		
		local X = math.cos( math.rad( Ang ) ) * Radius
		local Y = math.sin( math.rad( Ang ) ) * Radius
		
		render.DrawSprite( self:LocalToWorld( Vector(-X,Y,-5) ), Size, Size, Color( 127, 255, 255, 255) )
		render.DrawSprite( self:LocalToWorld( Vector(-X,Y,5) ), Size, Size, Color( 127, 255, 255, 255) )
	end
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	local Driver = self:GetDriver()
	if IsValid( Driver ) then
		local W = Driver:KeyPressed( IN_FORWARD ) and (self:GetLGear() < 0.9)
		if W ~= self.oldW then
			self.oldW = W
			if W then
				self.BoostAdd = 50
			end
		end
	end
	
	self.BoostAdd = self.BoostAdd and (self.BoostAdd - self.BoostAdd * FrameTime()) or 0
	
	
	local Size = 50 + self.BoostAdd
	local Radius = 500
	
	local Time = CurTime()
	self.nextEFX = self.nextEFX or 0
	if self.nextEFX < Time then
		self.nextEFX = Time + 0.01

		local emitter = ParticleEmitter( self:GetPos(), false )
		if emitter then
			for i = -25,25 do
				local Ang = i * 1.5
				
				local X = math.cos( math.rad( Ang ) ) * Radius
				local Y = math.sin( math.rad( Ang ) ) * Radius

				local particle = emitter:Add( "effects/muzzleflash2", self:LocalToWorld( Vector(-X - 5,Y,0) ) )
				if particle then 
					particle:SetVelocity( -self:GetForward() * math.Rand(500,1500) + self:GetVelocity() )
					particle:SetLifeTime( 0 )
					particle:SetDieTime( Size * 0.001 + (self:GetRPM() / self:GetLimitRPM()) * 0.1  )
					particle:SetStartAlpha( 255 )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( 20 + Size * 0.1 )
					particle:SetEndSize( 20 + Size * 0.05 )
					particle:SetRoll( math.Rand(-1,1) * 100 )
					
					particle:SetColor( 0, 200, 255 )
				end
			end
			
			emitter:Finish()
		end
	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	local ply = LocalPlayer()
	local mypos = self:GetPos()
	local plypos = ply:GetPos() + (self.FirstPerson and Vector(0,0,0) or -ply:EyeAngles():Forward() * 50000)
	local IsInFront = self:WorldToLocal( plypos ).x > -100

	local daVol = math.min( (plypos - mypos):Length() / 7000,0.7 )
	
	if self.ENG then
		self.ENG:ChangePitch( math.Clamp(90 + Pitch * 25 + Doppler * 0.5,0,255) )
		self.ENG:ChangeVolume( self.FirstPerson and 0 or (IsInFront and 1 or daVol), 0.2)
	end
	
	if self.DIST then
		self.DIST:ChangePitch( math.Clamp(90 + Pitch * 25 + Doppler * 0.5,0,255) )
		self.DIST:ChangeVolume( self.FirstPerson and 0 or (IsInFront and daVol or 1), 0.2)
	end
	
	if self.INTERIOR then
		self.INTERIOR:ChangePitch( math.Clamp(80 + Pitch * 40,0,255) )
		self.INTERIOR:ChangeVolume( self.FirstPerson and 0.7 or 0 )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "MFALCON_DIST_A" )
		self.ENG:PlayEx(0,0)
		
		self.DIST = CreateSound( self, "MFALCON_DIST_B" )
		self.DIST:PlayEx(0,0)
		
		self.INTERIOR = CreateSound( LocalPlayer(), "lfs/mfalcon/interior.wav" )
		self.INTERIOR:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
	
	if IsValid( self.Dish ) then
		self.Dish:Remove()
	end
	
	if IsValid( self.Details1 ) then
		self.Details1:Remove()
	end
	
	if IsValid( self.Details2 ) then
		self.Details2:Remove()
	end
	
	if IsValid( self.Cockpit ) then
		self.Cockpit:Remove()
	end
	
	if self.pEmitter then
		self.pEmitter:Finish()
	end
end

function ENT:SoundStop()
	if self.DIST then
		self.DIST:Stop()
	end
	
	if self.ENG then
		self.ENG:Stop()
	end
	
	if self.INTERIOR then
		self.INTERIOR:Stop()
	end
end
	
function ENT:AnimFins()
	--[[
	local Driver = self:GetGunner()

	if not IsValid( Driver ) then return end
	
	local Ang = Driver:EyeAngles()
	
	self:ManipulateBoneAngles( 3, Angle(0,0,-90 - Ang.p) )
	self:ManipulateBoneAngles( 2, Angle(0,Ang.y - 90,0) )
	]]--
end

function ENT:AnimRotor()
end

function ENT:AnimCabin()

	local bodygroup = self:GetBodygroup( 3 )
	
	if not IsValid( self.Dish ) then
		if bodygroup ~= 2 then
			local Prop = ents.CreateClientProp()
			Prop:SetPos( self:LocalToWorld( Vector(289,226,100) ) )
			Prop:SetAngles( self:GetAngles() )
			Prop:SetParent( self )
			Prop:Spawn()
			
			self.Dish = Prop
			self.olddish = -1
		end
	else
		self.olddish = isnumber( self.olddish ) and self.olddish or 0
		
		if self.olddish ~= bodygroup then
			if bodygroup == 0 then
				self.Dish:SetModel( "models/salza/round_dish.mdl" )
				self.Dish:SetPos( self:LocalToWorld( Vector(289,226,100) ) )
			elseif bodygroup == 1 then
				self.Dish:SetModel( "models/salza/square_dish.mdl" )
				self.Dish:SetPos( self:LocalToWorld( Vector(283,226,94) ) )
			else
				local Pos = self:LocalToWorld( Vector(275.91,225.83,70) )
				
				local effectdata = EffectData()
					effectdata:SetOrigin( Pos )
				util.Effect( "cball_explode", effectdata, true, true )
				sound.Play( "physics/metal/metal_box_break"..math.random(1,2)..".wav", Pos, 120 )
				
				for i =1,60 do
					timer.Simple( math.Rand(0.5,10), function()
						if not IsValid( self ) then return end
						local effectdata = EffectData()
							effectdata:SetOrigin( self:LocalToWorld( Vector(275.91,225.83,70) + VectorRand() * 10 ) )
						util.Effect( "cball_explode", effectdata, true, true )
						
						sound.Play( "ambient/energy/newspark0"..math.random(1,9)..".wav", Pos, 120 )
					end)
				end
				
				self.Dish:Remove()
			end
			self.olddish = bodygroup
		end
	end
	
	if not IsValid( self.Details1 ) then
		local Prop = ents.CreateClientProp()
		Prop:SetPos( self:GetPos() )
		Prop:SetAngles( self:GetAngles() )
		Prop:SetModel( "models/salza/falcon_details1.mdl" )
		Prop:SetParent( self )
		Prop:Spawn()
		
		self.Details1 = Prop
	end
	
	if not IsValid( self.Details2 ) then
		local Prop = ents.CreateClientProp()
		Prop:SetPos( self:GetPos() )
		Prop:SetAngles( self:GetAngles() )
		Prop:SetModel( "models/salza/falcon_details2.mdl" )
		Prop:SetParent( self )
		Prop:Spawn()
		
		self.Details2 = Prop
	end
	
	if not IsValid( self.Cockpit ) then
		local Prop = ents.CreateClientProp()
		Prop:SetPos( self:LocalToWorld( Vector(440,-435,25) ) )
		Prop:SetAngles( self:GetAngles() )
		Prop:SetModel( "models/salza/falcon_cockpit.mdl" )
		Prop:SetParent( self )
		Prop:Spawn()
		
		self.Cockpit = Prop
	end
	
	self.Details1:SetNoDraw( self.FirstPerson ) 
	self.Details2:SetNoDraw( self.FirstPerson ) 
	
	self.Cockpit:SetNoDraw( not self.FirstPerson ) 
	
	local THR = self:GetRPM() / self:GetLimitRPM()
	
	self.smTHR = self.smTHR and (self.smTHR + (THR - self.smTHR) * FrameTime()) or 0
	
	local FT = FrameTime() * 10
	local Pitch = self:GetRotPitch() / 30
	local Yaw = self:GetRotYaw() / 30
	local Roll = -self:GetRotRoll() / 30
	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self.smYaw = self.smYaw and self.smYaw + (Yaw - self.smYaw) * FT or 0
	self.smRoll = self.smRoll and self.smRoll + (Roll - self.smRoll) * FT or 0
	
	self.Cockpit:SetPoseParameter("lever1_pose", -1 + self.smTHR * 2 )
	self.Cockpit:SetPoseParameter("lever2_pose", self.smPitch )
	self.Cockpit:SetPoseParameter("lever3_pose", self.smYaw )
	self.Cockpit:SetPoseParameter("lever4_pose", self.smRoll )
	self.Cockpit:InvalidateBoneCache()
end

function ENT:AnimLandingGear()
end
