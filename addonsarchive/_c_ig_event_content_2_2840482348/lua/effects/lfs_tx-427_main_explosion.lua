function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.DieTime = CurTime() + 0.4

	sound.Play( "lfsAAT_EXPLOSION", self.Pos )
	self:Explode()
end

function EFFECT:Explode()
	local emitter = ParticleEmitter( self.Pos, false )
	if not emitter then return end

	for i = 0, 20 do
		local particle = emitter:Add( "particle/smokesprites_00" .. math.random( 0, 1 ) .. math.random( 1, 6 ), self.Pos + VectorRand() * 5 )
		if particle then
			particle:SetVelocity( VectorRand() * 2000 )
			particle:SetDieTime( math.Rand( 2, 3 ) )
			particle:SetAirResistance( math.Rand( 1000, 1500 ) ) 
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 20, 25 ) )
			particle:SetEndSize( math.Rand( 75, 100 ) )
			particle:SetRoll( math.Rand( -1, 1 ) )
			particle:SetColor( 50, 50, 50 )
			particle:SetGravity( Vector( 0, 0, 50 ) )
			particle:SetCollide( false )
		end
		
		particle = emitter:Add( "sprites/flamelet"..math.random( 1, 5 ), self.Pos )
		if particle then
			particle:SetVelocity( VectorRand() * 200 )
			particle:SetDieTime( math.Rand( 0.2, 0.3 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 15 )
			particle:SetEndSize( math.Rand( 25, 50 ) )
			particle:SetColor( 200,150,150 )
			particle:SetCollide( false )
		end
		
		particle = emitter:Add( "sprites/light_glow02_add", self.Pos )
		if particle then
			particle:SetVelocity( VectorRand() * 500 )
			particle:SetDieTime( math.Rand( 0.5, 1 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 15, 20 ) )
			particle:SetEndSize( math.Rand( 25, 50 ) )
			particle:SetColor( 0, 0, 255 )
			particle:SetGravity( Vector( 0, 0, -1000 ) )
			particle:SetCollide( true )
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	if self.DieTime < CurTime() then return false end
end

function EFFECT:Render()
end