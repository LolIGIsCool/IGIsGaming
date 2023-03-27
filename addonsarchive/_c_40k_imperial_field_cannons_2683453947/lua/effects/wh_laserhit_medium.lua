function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local Ang = data:GetAngles()
	
	self:Explosion( Pos, Ang )
end

function EFFECT:Explosion( pos, ang )
	ParticleEffect( "wh_laserhit_medium", pos, ang )
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
