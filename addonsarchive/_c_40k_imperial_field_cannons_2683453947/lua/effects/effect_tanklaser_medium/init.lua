-- ==========================================
-- Medium laser tracer for lascannons/
-- ==========================================

EFFECT.Mat = Material( "effects/vehicles/red_beam" )


function EFFECT:Init( data )

	self.texcoord = math.Rand( 0, 20 )/3
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	

	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	

	self.Entity:SetCollisionBounds( self.StartPos -  self.EndPos, Vector( 110, 110, 110 ) )
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos, Vector()*8 )
	
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	
	self.Alpha = 255
	self.FlashA = 255

	self.DieTime = 0.1
	self.Dir = self.EndPos - self.StartPos

	local effectdata = EffectData()
		effectdata:SetStart( Vector(255,0,0) ) 
		effectdata:SetOrigin( self.EndPos )
		effectdata:SetAngles( self.Dir:GetNormalized():Angle() )
	util.Effect( "wh_laserhit_medium", effectdata )
	
end


function EFFECT:Think( )

	self.FlashA = self.FlashA - 250 * FrameTime()
	if (self.FlashA < 0) then self.FlashA = 0 end

	self.Alpha = self.Alpha - 250 * FrameTime()
	if (self.Alpha < 0) then return false end
	
	return true

end


function EFFECT:Render( )
	
	self.Length = (self.StartPos - self.EndPos):Length()
	
	local texcoord = self.texcoord
	
		render.SetMaterial( self.Mat )
		render.DrawBeam( self.StartPos, 										// Start
					 self.EndPos,											// End
					 32,													// Width
					 texcoord,														// Start tex coord
					 texcoord + self.Length / 256,									// End tex coord
					 Color( 255, 255, 255, math.Clamp(self.Alpha, 0,255)) )		// Color (optional)
					 
end
