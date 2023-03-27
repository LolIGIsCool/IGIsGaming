
function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.Ang = data:GetAngles()

	self.AttachmentID = ID

	self:Muzzle( self.Pos, self.Ang )
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end


function EFFECT:Muzzle( pos, ang )
	ParticleEffect( "wh_lasermuzzle_medium", pos, ang )
end