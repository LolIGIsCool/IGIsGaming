include("shared.lua")

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP == 0 or HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0
	
	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		local effectdata = EffectData()
			effectdata:SetOrigin( self:LocalToWorld( Vector(-65,0,60) ) )
		util.Effect( "lfs_blacksmoke", effectdata )
	end
end

function ENT:LFSHudPaintInfoText( X, Y, speed, alt, Throttle )
	draw.SimpleText( "SPEED", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "LANDSPEEDER_ENGINE" )
		self.ENG:PlayEx(0,0)
		
		--self.DIST = CreateSound( self, "LFS_SPITFIRE_DIST" )
		--self.DIST:PlayEx(0,0)
	else
		self:SoundStop()
	end
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
                self.BoostAdd = 100
            end
        end
    end
    
    self.BoostAdd = self.BoostAdd and (self.BoostAdd - self.BoostAdd * FrameTime()) or 0
    
    if self.nextEFX < CurTime() then
        self.nextEFX = CurTime() + 0.01
        
        local emitter = ParticleEmitter( self:GetPos(), false )
        local Pos = {
            Vector(-100,56,20),
            Vector(-100,-56,20),
            }

        if emitter then
            for _, v in pairs( Pos ) do
                local Sub = Mirror and 1 or -1
                local vOffset = self:LocalToWorld( v )
                local vNormal = -self:GetForward()

                vOffset = vOffset + vNormal * 5

                local particle = emitter:Add( "sprites/heatwave", vOffset )
                if not particle then return end

                particle:SetVelocity( vNormal * math.Rand(500,1000) + self:GetVelocity() )
                particle:SetLifeTime( 0 )
                particle:SetDieTime( 0.1 )
                particle:SetStartAlpha( 255 )
                particle:SetEndAlpha( 0 )
                particle:SetStartSize( math.Rand(15,20) )
                particle:SetEndSize( math.Rand(0,10) )
                particle:SetRoll( math.Rand(-1,1) * 100 )
                
                particle:SetColor( 255, 255, 255 )
            
                Mirror = true
            end
            
            emitter:Finish()
        end
    end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
    if self.ENG then
        self.ENG:ChangePitch(  math.Clamp(math.Clamp(  70 + Pitch * 45, 50,255) + Doppler,0,255) )
        self.ENG:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
    end
    
    if self.DIST then
        self.DIST:ChangePitch(  math.Clamp(math.Clamp(  Pitch * 150, 50,255) + Doppler,0,255) )
        self.DIST:ChangeVolume( math.Clamp( -1 + Pitch * 6, 0.5,1) )
    end
end