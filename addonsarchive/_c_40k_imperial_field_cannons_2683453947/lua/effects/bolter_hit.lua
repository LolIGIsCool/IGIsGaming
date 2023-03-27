--DO NOT EDIT OR REUPLOAD THIS FILE

function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.Col = data:GetStart() or Vector(255,100,0)
	
	self.mat = Material( "sprites/light_glow02_add" )
	
	self.LifeTime = 0.1
	self.DieTime = CurTime() + self.LifeTime

	local Col = self.Col
	local Pos = self.Pos
	local Dir = data:GetNormal()
end

function EFFECT:Think()
	if self.DieTime < CurTime() then return false end

	return true
end

function EFFECT:Render()
	local Scale = (self.DieTime - CurTime()) / self.LifeTime
	render.SetMaterial( self.mat )
	render.DrawSprite( self.Pos, 100 * Scale, 200 * Scale, Color( self.Col.x, self.Col.y, self.Col.z, 255) )
	render.DrawSprite( self.Pos, 50 * Scale, 50 * Scale, Color( 255, 255, 255, 255) )
end
