-- YOU CAN EDIT AND REUPLOAD THIS FILE. 
-- HOWEVER MAKE SURE TO RENAME THE FOLDER TO AVOID CONFLICTS

include("shared.lua")

function ENT:LFSCalcViewFirstPerson( view, ply ) -- modify first person camera view here
	--[[
	if ply == self:GetDriver() then
		-- driver view
	elseif ply == self:GetGunner() then
		-- gunner view
	else
		-- everyone elses view
	end
	]]--
	
	return view
end

function ENT:LFSCalcViewThirdPerson( view, ply ) -- modify third person camera view here
	return view
end

function ENT:LFSHudPaint( X, Y, data, ply ) -- driver only
end

function ENT:LFSHudPaintPassenger( X, Y, ply ) -- all except driver
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch(  math.Clamp( 60 + Pitch * 40 + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( Pitch, 0.5,1) )
	end
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG=CreateSound(self,"VANILLA_UWING_HUM")
		self.ENG:PlayEx(0,0)
		self.DIST=CreateSound(self,"VANILLA_UWING_HUM")
		self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:OnRemove()
	self:SoundStop()
	
	if IsValid( self.TheRotor ) then -- if we have an rotor
		self.TheRotor:Remove() -- remove it
	end
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:AnimFins()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

/*function ENT:AnimRotor()
	if not IsValid( self.TheRotor ) then -- spawn the rotor for all clients that dont have one
		local Rotor = ents.CreateClientProp()
		Rotor:SetPos( self:GetRotorPos() )
		Rotor:SetAngles( self:LocalToWorldAngles( Angle(90,0,0) ) )
		Rotor:SetModel( "models/XQM/propeller1big.mdl" )
		Rotor:SetParent( self )
		Rotor:Spawn()
		
		self.TheRotor = Rotor
	end
	
	local RPM = self:GetRPM() * 2 -- spin twice as fast
	self.RPM = self.RPM and (self.RPM + RPM * FrameTime()) or 0
	
	local Rot = Angle(0,0,-self.RPM)
	Rot:Normalize() 
	
	self.TheRotor:SetAngles( self:LocalToWorldAngles( Rot ) )
end*/

function ENT:AnimCabin()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:AnimLandingGear()
	--[[ function gets called each frame by the base script. you can do whatever you want here ]]--
end

function ENT:ExhaustFX()
	if not self:GetEngineActive() then return end

	self.nextEFX = self.nextEFX or 0
	
	local THR = (self:GetRPM() - self.IdleRPM) / (self.LimitRPM - self.IdleRPM)
	
	local Driver = self:GetDriver()
	if IsValid( Driver ) then
		local W = Driver:KeyPressed( IN_FORWARD )
		if W ~= self.oldW then
			self.oldW = W
			if W then
				self.BoostAdd = 80
			end
		end
	end
	
	self.BoostAdd = self.BoostAdd and (self.BoostAdd - self.BoostAdd * FrameTime()) or 0
	
	if self.nextEFX < CurTime() then
		self.nextEFX = CurTime() + 0.01
		
		local emitter = ParticleEmitter( self:GetPos(), false )
		local Pos = {
			Vector(-450,193,140),
			Vector(-450,-193,140),
			Vector(-450,193,45),
			Vector(-450,-193,45),
			}
		
		if emitter then
			for _, v in pairs( Pos ) do
				local Sub = Mirror and 1 or -1
				local vOffset = self:LocalToWorld( v )
				local vNormal = -self:GetForward()

				vOffset = vOffset + vNormal * 5

				local particle = emitter:Add( "effects/muzzleflash2", vOffset )
				if not particle then return end

				particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.08 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 255 )
				particle:SetStartSize( math.Rand(28,32) )
				particle:SetEndSize( math.Rand(10,10) )
				particle:SetRoll( math.Rand(-1,1) * 100 )
				
				particle:SetColor(10, 140, 255, 255)
			end
			
			emitter:Finish()
		end
	end
end
