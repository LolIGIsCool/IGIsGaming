include("shared.lua")

function ENT:Initialize()
	zbl.f.EntList_Add(self)
	self:DestroyShadow()
	self.LastEffect = - 1
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:Draw()
end


function ENT:Think()
	if zbl.config.Fence.dmg_per_touch > 0 and (self.LastEffect or 0) < CurTime() then
		local min,max = self:GetCollisionBounds()
		//debugoverlay.BoxAngles( self:GetPos(), min,max, self:LocalToWorldAngles(Angle(0,0,0)), 0.1, Color( 0, 255, 255,10 ) )

		local mid = math.random(min.y,max.y)
		local vPoint = self:GetPos() + self:GetUp() * 70 - self:GetRight() * mid

		//debugoverlay.Sphere(vPoint,5,1,Color( 255, 255, 255 ,100),true)

		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )

		effectdata:SetMagnitude( 1 )
		effectdata:SetScale(1)
		effectdata:SetRadius( 1 )

		util.Effect( "cball_bounce", effectdata )

		sound.Play(zbl.Sounds["sparks"][math.random(#zbl.Sounds["sparks"])], vPoint, 55, 100, 0.85)

		self.LastEffect = CurTime() + math.random(3,6)
	end
end
