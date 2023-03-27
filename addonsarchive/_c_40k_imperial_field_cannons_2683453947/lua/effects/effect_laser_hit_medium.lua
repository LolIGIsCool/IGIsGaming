--DO NOT EDIT OR REUPLOAD THIS FILE

local Materials = {
	"particle/smokesprites_0001",
	"particle/smokesprites_0002",
	"particle/smokesprites_0003",
	"particle/smokesprites_0004",
	"particle/smokesprites_0005",
	"particle/smokesprites_0006",
	"particle/smokesprites_0007",
	"particle/smokesprites_0008",
	"particle/smokesprites_0009",
	"particle/smokesprites_0010",
	"particle/smokesprites_0011",
	"particle/smokesprites_0012",
	"particle/smokesprites_0013",
	"particle/smokesprites_0014",
	"particle/smokesprites_0015",
	"particle/smokesprites_0016"
}

function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	self.Col = data:GetStart() or Vector(255,100,0)
	
	self.mat = Material( "sprites/light_glow02_add" )
	
	self.LifeTime = 2
	self.DieTime = CurTime() + self.LifeTime

	local Col = self.Col
	local Pos = self.Pos
	local Dir = data:GetNormal()

	self:Explosion( Pos )
end

function EFFECT:Explosion( pos )
	local emitter = ParticleEmitter( pos, false )
	
	for i = 0,6 do
		local particle = emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
		
		if particle then
			particle:SetVelocity( VectorRand() * 200 )
			particle:SetDieTime( math.Rand(1,2) )
			particle:SetAirResistance( math.Rand(100,300) ) 
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.Rand(5,15) )
			particle:SetEndSize( math.Rand(30,50) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( 100,100,100 )
			particle:SetGravity( Vector( 0, 0, 100 ) )
			particle:SetCollide( false )
			particle:SetLighting( true )
		end
	end
	
	for i = 0, 6 do
		local particle = emitter:Add( "sprites/rico1", pos )
		
		local vel = VectorRand() * 1600
		
		if particle then
			particle:SetVelocity( vel )
			particle:SetAngles( vel:Angle() + Angle(0,90,0) )
			particle:SetDieTime( math.Rand(0.1,0.15) )
			particle:SetStartAlpha( math.Rand( 200, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(10,16) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(-100,100) )
			particle:SetRollDelta( math.Rand(-100,100) )
			particle:SetColor( 255, 255, 255 )

			particle:SetAirResistance( 0 )
		end
	end
	
	emitter:Finish()

	local dlight = DynamicLight( math.random(0,9999) )
	if dlight then
		dlight.pos = self:GetPos() + Vector (0,0,10)
		dlight.r = 255
		dlight.g = 0
		dlight.b = 0
		dlight.brightness = 2
		dlight.Decay = 200
		dlight.Size = 100
		dlight.DieTime = CurTime() + 0.01
	end
end

function EFFECT:Think()
	if self.DieTime < CurTime() then return false end

	return true
end

function EFFECT:Render()
	local Scale = (self.DieTime - CurTime()) / self.LifeTime
	render.SetMaterial( self.mat )
	render.DrawSprite( self.Pos, 200 * Scale, 200 * Scale, Color( self.Col.x, self.Col.y, self.Col.z, 255) )
	render.DrawSprite( self.Pos, 100 * Scale, 100 * Scale, Color( 255, 255, 255, 255) )
end
