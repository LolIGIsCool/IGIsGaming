--DO NOT EDIT OR REUPLOAD THIS FILE
include("shared.lua")
function ENT:LFSCalcViewFirstPerson( view )
return view
end

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-70,-150,10) ) )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
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

function ENT:LFSHudPaint( X, Y, data, ply ) 
end

function ENT:LFSHudPaintPassenger( X, Y, ply ) 
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
local ply = LocalPlayer()
	local mypos = self:GetPos()
	local plypos = ply:GetPos() + (self.FirstPerson and Vector(0,0,0) or -ply:EyeAngles():Forward() * 50000)
	local IsInFront = self:WorldToLocal( plypos ).x > -100
	local daVol = math.min( (plypos - mypos):Length() / 7000,0.7 )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp(math.Clamp(  70 + Pitch * 45,0,255) + Doppler,0,255) )
		self.ENG:ChangeVolume( self.FirstPerson and 0 or (IsInFront and 0.6 or daVol), 1)
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
		self.ENG = CreateSound( self, "engine_#777" )
		self.ENG:PlayEx(0,0)
        self.INTERIOR = CreateSound( LocalPlayer(), "lfs/ywing/int_#12.wav" )
		self.INTERIOR:PlayEx(0,0)
		self.MIX = CreateSound( LocalPlayer(), "lfs/ywing/y_mixer.wav" )
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
if self.pEmitter then
	self.pEmitter:Finish()
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
	local Driver = self:GetDriver()
	if not IsValid( Driver ) and not HasGunner then return end
	local EyeAngles = self:WorldToLocalAngles( Driver:EyeAngles() )
	EyeAngles:RotateAroundAxis( EyeAngles:Up(), -180 )
	local Yaw = math.Clamp( EyeAngles.y,-180,180)
	local Pitch = math.Clamp( EyeAngles.p,-5,30 )
	if not Driver:KeyDown( IN_WALK ) and not HasGunner then
		Yaw = 180
		Pitch = 0
	end
	self:ManipulateBoneAngles( 2, Angle(-Yaw,-180,180) )
	self:ManipulateBoneAngles( 3, -Angle(-360,360,Pitch) )
	
	local FT = FrameTime() * 10
	local Pitch = self:GetRotPitch()
	local Yaw = self:GetRotYaw()
	self.smPitch = self.smPitch and self.smPitch + (Pitch - self.smPitch) * FT or 0
	self.smYaw = self.smYaw and self.smYaw + (Yaw - self.smYaw) * FT or 0
	
	self:ManipulateBoneAngles( 11, Angle( 0,0,-self.smPitch/3) )

	self:ManipulateBoneAngles( 10, -Angle( -self.smYaw/2) )
end

function ENT:AnimRotor()
self.AstroAng = self.AstroAng or 0
	self.nextAstro = self.nextAstro or 0
	if self.nextAstro < CurTime() then
		self.nextAstro = CurTime() + math.Rand(0.5,2)
		self.AstroAng = math.Rand(-180,180)
	end
	self.smastro = self.smastro and (self.smastro + (self.AstroAng - self.smastro) * FrameTime() * 10) or 0
	self:ManipulateBoneAngles( 15, Angle(self.smastro,0,0) )
end

function ENT:AnimCabin()	
local bodygroup = self:GetBodygroup( 0 )
if not IsValid( self.Cockpit ) then
		local Prop = ents.CreateClientProp()
		Prop:SetPos( self:LocalToWorld( Vector(0,0,0) ) )
		Prop:SetAngles( self:GetAngles() )
		Prop:SetModel( "models/c_rf/Y-Wing_Cockpit.mdl" )
		Prop:SetParent( self )
		Prop:Spawn()
		self.Cockpit = Prop
end
end

function ENT:AnimLandingGear()
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end
	
	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	self.BoostAdd = self.BoostAdd and (self.BoostAdd - self.BoostAdd * FrameTime()) or 0
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.01
		
		local emitter = ParticleEmitter( self:GetPos(), false )

		if emitter then
			local Mirror = false
			for i = 0,1 do
				local Sub = Mirror and 1 or -1
				local vOffset = self:LocalToWorld( Vector(-180,-152.5 * Sub,0) )
				local vNormal = -self:GetForward()

				vOffset = vOffset + vNormal * 5

				local particle = emitter:Add( "effects/muzzleflash2", vOffset )
				if not particle then return end

				particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.Rand(25,35) )
				particle:SetEndSize( math.Rand(0,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor(255, 0, 0)
			
				Mirror = true
			end
			
			emitter:Finish()
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
	local Boost = self.BoostAdd or 60
	local Size = 125 + (self:GetRPM() / self:GetLimitRPM()) * 60 + Boost
	render.SetMaterial( mat )
	render.DrawSprite( self:LocalToWorld( Vector(-200,150,5) ), Size, Size, Color( 255, 0, 0, 255) )
	render.DrawSprite( self:LocalToWorld( Vector(-200,-150,5) ), Size, Size, Color( 255, 0, 0, 255) )

end