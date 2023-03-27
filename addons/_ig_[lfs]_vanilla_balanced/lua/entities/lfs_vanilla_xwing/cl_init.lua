-- INSERT A COMMENT ABOUT NOT REUPLOADING THIS

include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply )
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply )
	local ply = LocalPlayer()
	
	local Pod = ply:GetVehicle()
	
	if not IsValid( Pod ) then return view end
	
	if ply == self:GetDriver() then
		local radius = 600
		radius = radius + radius * Pod:GetCameraDistance()
		
		view.origin = self:LocalToWorld( Vector(0,0,0) )
		
		local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
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
local ply = LocalPlayer()
	local mypos = self:GetPos()
	local plypos = ply:GetPos() + (self.FirstPerson and Vector(0,0,0) or -ply:EyeAngles():Forward() * 50000)
	local IsInFront = self:WorldToLocal( plypos ).x > -100

	local daVol = math.min( (plypos - mypos):Length() / 7000,0.7 )

	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  70 + Pitch * 45, 50,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
		
	if self.INTERIOR then
		self.INTERIOR:ChangePitch( math.Clamp(70 + Pitch * 33,0,255) )
		self.INTERIOR:ChangeVolume( self.FirstPerson and 0.7 or 0 )
		
		if self.MIX then
		self.MIX:ChangePitch( math.Clamp(70 + Pitch * 33,0,255) )
		self.MIX:ChangeVolume( self.FirstPerson and 0.7 or 0 )
		
         end
      end
   end
end

function ENT:EngineActiveChanged( bActive )
if bActive then
		self.ENG = CreateSound( self, "engin" )
		self.ENG:PlayEx(0,0)
		
        self.INTERIOR = CreateSound( LocalPlayer(), "intel" )
		self.INTERIOR:PlayEx(0,0)
		
		self.MIX = CreateSound( LocalPlayer(), "lfs/x-wing/x_mixer.wav" )
		self.MIX:PlayEx(0,0)

		
	else
		self:SoundStop()
   end
end

function ENT:OnRemove()
	self:SoundStop()
	
	if IsValid( self.TheRotor ) then 
       self.TheRotor:Remove()
	end
	
	if IsValid( self.Cockpit ) then
	self.Cockpit:Remove()
   end
   
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
	if self.INTERIOR then
		self.INTERIOR:Stop()
	end
	if self.MIX then
		self.MIX:Stop()
   end
end

function ENT:AnimFins()
local FT = FrameTime() * 10
	local Pitch = self:GetRotPitch()
	local Yaw = self:GetRotYaw()
	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self.smYaw = self.smYaw and self.smYaw + (Yaw - self.smYaw) * FT or 0
	
	self:ManipulateBoneAngles( 4, Angle( 0,0,-self.smPitch/3) )

	self:ManipulateBoneAngles( 5, Angle( -self.smYaw/2) )

self.SMLG = self.SMLG and self.SMLG + (14 *  self:GetLGear() - self.SMLG) * FrameTime() * 1.6 or 0
	
	local A5 = 14 - self.SMLG
    local A7 = 14 - self.SMLG

	self:ManipulateBoneAngles( 10, Angle(0,-A7,0) )
	self:ManipulateBoneAngles( 9, Angle(0,A5,0) )
	
	local A6 = 14 - self.SMLG
	local A8 = 14 - self.SMLG
	
	self:ManipulateBoneAngles( 8, Angle(0,-A6,0) )
	self:ManipulateBoneAngles( 7, Angle(0,A8,0) )

	self.AA5 = A5
	self.AA6 = A6
	self.AA7 = A7
	self.AA8 = A8
	
end

function ENT:AnimRotor()

	self.AstroAng = self.AstroAng or 0
	self.nextAstro = self.nextAstro or 0
	if self.nextAstro < CurTime() then
	self.nextAstro = CurTime() + math.Rand(0.5,2)
	self.AstroAng = math.Rand(-180,180)
		
	end

	self.smastro = self.smastro and (self.smastro + (self.AstroAng - self.smastro) * FrameTime() * 10) or 0
	
	self:ManipulateBoneAngles( 1, Angle(self.smastro,0,0) )
end

function ENT:AnimCabin()	
local bodygroup = self:GetBodygroup( 0 )
if not IsValid( self.Cockpit ) then
		local Prop = ents.CreateClientProp()
		Prop:SetPos( self:LocalToWorld( Vector(0,0,0) ) )
		Prop:SetAngles( self:GetAngles() )
		Prop:SetModel( "models/min3r/X-Wing_c.mdl" )
		Prop:SetParent( self )
		Prop:Spawn()
		self.Cockpit = Prop
end
local bOn = self:GetActive()
	
	local TVal = bOn and 0 or 1
	
	local Speed = FrameTime() * 1.5
	
	self.SMcOpen = self.SMcOpen and self.SMcOpen + math.Clamp(TVal - self.SMcOpen,-Speed,Speed) or 0
	
	self:ManipulateBonePosition( 6, Vector(0,0, self.SMcOpen * 1) ) 
	
	self:ManipulateBoneAngles( 6, Angle(0,0,self.SMcOpen *-70) ) 
end

function ENT:AnimLandingGear()
end

function ENT:ExhaustFX()
if not self:GetEngineActive() then return end
	if not self.AA5 or not self.AA6 or not self.AA7 or not self.AA8 then return end
	
	self.nextEFX = self.nextEFX or 0
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.01
		
		local emitter = ParticleEmitter( self:GetPos(), false )
		
		if emitter then
		
			local A5 = self.AA5
			local A6 = self.AA6
			local A7 = self.AA7
			local A8 = self.AA8
			
			local MirrorY = true
			for d = 0,1 do
				local MirrorX = true
				
				for e = 0,1 do
					local InvX = MirrorX and 1 or -1
					local InvY = MirrorY and 1 or -1
					
					local Rot = self:LocalToWorldAngles( Angle(MirrorY and A5,99,0) )
	                local Pos = self:LocalToWorld( Vector(-380,-13 * InvY,-20) ) - Rot:Right() * -120 * InvY + Rot:Forward() * 65 + Rot:Up() * -29 * InvX
				
				    local vNormal = -self:GetForward()

					local particle = emitter:Add( "effects/muzzleflash2", Pos )
					if not particle then return end

					particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(15,25) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 254, 45, 0 )
			
					local Rot = self:LocalToWorldAngles( Angle(MirrorY and A6,-99,0) )
                    local Pos = self:LocalToWorld( Vector(-145,-17 * InvY,-20) ) - Rot:Right() * -120 * InvY + Rot:Forward() * 65 + Rot:Up() * -29 * InvX
				
					 local vNormal = -self:GetForward()

					local particle = emitter:Add( "effects/muzzleflash2", Pos )
					if not particle then return end

					particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(15,25) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 254, 45, 0 )
				
	 			local Rot = self:LocalToWorldAngles( Angle(MirrorY and A7,-97,0) )
	            local Pos = self:LocalToWorld( Vector(-155,-12 * InvY,1) ) - Rot:Right() * -120 * InvY + Rot:Forward() * -66 + Rot:Up() * 29 * InvX
				
					 local vNormal = -self:GetForward()

					local particle = emitter:Add( "effects/muzzleflash2", Pos )
					if not particle then return end

					particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(15,25) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 254, 45, 0 )
					
	 			local Rot = self:LocalToWorldAngles( Angle(MirrorY and A8,97,0) )
	            local Pos = self:LocalToWorld( Vector(-395,-8 * InvY,2) ) - Rot:Right() * -120 * InvY + Rot:Forward() * -68 + Rot:Up() * 29 * InvX
				
                local vNormal = -self:GetForward()

					local particle = emitter:Add( "effects/muzzleflash2", Pos )
					if not particle then return end

					particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(15,25) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor( 254, 45, 0 )
				MirrorX = true
				end
				
				MirrorY = true
			end
			emitter:Finish()
		end
	end
end	

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.04

		
		local A8 = self.AA8

		if not A8 then return end

		local Size = 1

		local MirrorY = true
		for d = 0,1 do

			local InvY = MirrorY and -1 or -1

			local Rot = self:LocalToWorldAngles( Angle(MirrorY and A8,97,0) )
	        local Pos = self:LocalToWorld( Vector(-70,-10 * InvY,25) ) - Rot:Right() * -120 * InvY + Rot:Forward() * -68

			local effectdata = EffectData()
				effectdata:SetOrigin( Pos )
			util.Effect( "lfs_blacksmoke", effectdata )
			MirrorY = true
		end


   end
end

local mat = Material( "sprites/light_glow02_add" )
function ENT:Draw()
    self:DrawModel()
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
	
	local A5 = self.AA5
	local A6 = self.AA6
	local A7 = self.AA7
	local A8 = self.AA8
	
	if not A5 or not A6 or not A7 or not A8 then return end
	
	local Boost = self.BoostAdd or 0
	
	local Size = 100 + (self:GetRPM() / self:GetLimitRPM()) * 30 + Boost

	local MirrorY = true 
	for d = 0,1 do
		local MirrorX = true
		
		for e = 0,1 do
			local InvX = MirrorX and 1 or -1
			local InvY = MirrorY and 1 or -1
			
	local Rot = self:LocalToWorldAngles( Angle(MirrorY and A5,99,0) )
	local Pos = self:LocalToWorld( Vector(-375,-13 * InvY,-20) ) - Rot:Right() * -120 * InvY + Rot:Forward() * 65 + Rot:Up() * -29 * InvX
	render.SetMaterial( mat )
	render.DrawSprite( Pos, Size, Size, Color( 223, 65, 84, 353) )
	--LINE 1
	local Rot = self:LocalToWorldAngles( Angle(MirrorY and A6,-99,0) )
    local Pos = self:LocalToWorld( Vector(-140,-17 * InvY,-20) ) - Rot:Right() * -120 * InvY + Rot:Forward() * 65 + Rot:Up() * -29 * InvX
	render.SetMaterial( mat )
	render.DrawSprite( Pos, Size, Size, Color( 223, 65, 84, 353) )
    --LINE 2
	local Rot = self:LocalToWorldAngles( Angle(MirrorY and A7,-97,0) )
	local Pos = self:LocalToWorld( Vector(-155,-12 * InvY,1) ) - Rot:Right() * -120 * InvY + Rot:Forward() * -66 + Rot:Up() * 29 * InvX
	render.SetMaterial( mat )
	render.DrawSprite( Pos, Size, Size, Color( 223, 65, 84, 353) )
	--LINE 3
	local Rot = self:LocalToWorldAngles( Angle(MirrorY and A8,97,0) )
	local Pos = self:LocalToWorld( Vector(-395,-8 * InvY,2) ) - Rot:Right() * -120 * InvY + Rot:Forward() * -68 + Rot:Up() * 29 * InvX
	render.SetMaterial( mat )
	render.DrawSprite( Pos, Size, Size, Color( 223, 65, 84, 353) ) 
	--LINE 4
	MirrorX = true
		end	
		MirrorY = true
	end
end