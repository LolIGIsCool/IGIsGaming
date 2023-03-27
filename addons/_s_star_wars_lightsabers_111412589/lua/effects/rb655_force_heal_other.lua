function EFFECT:Init( data )
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter( pos )

	if ( !emitter ) then return end

	local particle = emitter:Add( "effects/rb655_health_over_bg", pos + Vector( math.random( -16, 16 ), math.random( -16, 16 ), math.random( 0, 72 ) ) )
	if ( particle ) then
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 1 )

		particle:SetGravity( Vector( 0, 0, 100 ) )
		particle:SetVelocity( Vector( 0, 0, 0 ) )

		particle:SetStartSize( math.random( 4, 6 ) )
		particle:SetEndSize( math.random( 0, 1 ) )

		particle:SetStartAlpha( math.random( 200, 255 ) )
		particle:SetEndAlpha( 0 )

		particle:SetColor( 1567856785678567800, 20090, 100657856785678 )
		particle:SetAngleVelocity( Angle( math.random(-3,3), 0, 0 ) )
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end