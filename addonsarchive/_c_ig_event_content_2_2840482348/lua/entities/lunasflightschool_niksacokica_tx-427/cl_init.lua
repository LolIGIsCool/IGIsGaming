include("shared.lua")

function ENT:DamageFX()
	local HP = self:GetHP()
	if HP > self:GetMaxHP() * 0.5 then return end
	
	self.nextDFX = self.nextDFX or 0

	if self.nextDFX < CurTime() then
		self.nextDFX = CurTime() + 0.05
		
		for i=0, 2 do
			local effectdata = EffectData()
				effectdata:SetOrigin( self:LocalToWorld( Vector(-90,0,40) ) )
			util.Effect( "lfs_blacksmoke", effectdata )
		end
	end
end

function ENT:LFSCalcViewThirdPerson( view )
	local ply = LocalPlayer()
	if not IsValid( ply:GetVehicle() ) then return view end
	if ply == self:GetMainGunner() then
		local bonepos = self:GetBonePosition( self:LookupBone( "rig_tx427.turret" ) )
		
		local WallOffset = 4
		local radius = 500 + 500 * ply:GetVehicle():GetCameraDistance()
		
		local StartPos = bonepos
		local EndPos = StartPos - view.angles:Forward() * radius + view.angles:Up() * 100
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
		local origin = tr.HitPos
		
		if tr.Hit and not tr.StartSolid then
			origin = origin + tr.HitNormal * WallOffset
		end
		view.origin = origin
	else
		local radius = 500 + 400 * ply:GetVehicle():GetCameraDistance()		
		local TargetOrigin = self:LocalToWorld( Vector(0,0,100) ) - view.angles:Forward() * radius + view.angles:Up() * 100
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
	end
	
	return view
end

function ENT:LFSCalcViewFirstPerson( view, ply )
	return self:LFSCalcViewThirdPerson( view )
end

function ENT:LFSHudPaintPassenger( x, y, ply )
	x = x * 0.5
	y = y * 0.5
	if ply == self:GetMainGunner() || ply == self:GetCoDriver() then
		surface.SetDrawColor( 255, 255, 255, 255 )
		simfphys.LFS.DrawCircle( x, y, 10 )
		surface.DrawLine( x + 10, y, x + 20, y ) 
		surface.DrawLine( x - 10, y, x - 20, y ) 
		surface.DrawLine( x, y + 10, x, y + 20 ) 
		surface.DrawLine( x, y - 10, x, y - 20 ) 
		
		-- shadow
		surface.SetDrawColor( 0, 0, 0, 80 )
		simfphys.LFS.DrawCircle( x + 1, y + 1, 10 )
		surface.DrawLine( x + 11, y + 1, x + 21, y + 1 ) 
		surface.DrawLine( x - 9, y + 1, x - 16, y + 1 ) 
		surface.DrawLine( x + 1, y + 11, x + 1, y + 21 ) 
		surface.DrawLine( x + 1, y - 19, x + 1, y - 16 )
		
		self:LFSPaintHitMarker( {x = x, y = y} )
	end
end

function ENT:LFSHudPaintInfoText( X, Y, speed, alt, AmmoPrimary, AmmoSecondary, Throttle )
	draw.SimpleText( "SPEED", "LFS_FONT", 10, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	draw.SimpleText( speed.."km/h", "LFS_FONT", 120, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function ENT:EngineActiveChanged( bActive )
	if bActive then
		self.ENG = CreateSound( self, "niksacokica/tx-427/engine_loop.wav" )
		self.ENG:PlayEx(0,0)
	else
		self:SoundStop()
	end
end

function ENT:CalcEngineSound( RPM, Pitch, Doppler )
	if self.ENG then
		self.ENG:ChangePitch( math.Clamp( 60 + Pitch * 30 + Doppler,0,255) )
		self.ENG:ChangeVolume( math.Clamp( Pitch, 0.5,1) )
	end
end

function ENT:SoundStop()
	if self.ENG then
		self.ENG:Stop()
	end
end

function ENT:ExhaustFX()
	if self:GetEngineActive() then
		self.nextEFX = self.nextEFX or 0
		
		if self.nextEFX < CurTime() then
			self.nextEFX = CurTime() + 0.01
			
			local emitter = ParticleEmitter(self:GetPos(), false)
			local Pos = {
				Vector(-130, -80, 20),
				Vector(-130, 80, 20),
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
						particle:SetDieTime(0.02)
						particle:SetStartAlpha(255)
						particle:SetEndAlpha(0)
						particle:SetStartSize(math.Rand(20, 25))
						particle:SetEndSize(math.Rand(10, 20))
						particle:SetRoll(math.Rand(-1, 1) * 100)
				end
				
				emitter:Finish()
			end
		end
	end
end