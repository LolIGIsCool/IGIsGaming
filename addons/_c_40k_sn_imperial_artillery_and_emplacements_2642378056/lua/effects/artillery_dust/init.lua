-- ==========================================
-- This effect is used when heavy artillery is shooting.
-- A small ring of dust from below the vehicle.
-- ==========================================

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
	local Pos = data:GetOrigin()
	self:Explosion( Pos )
end

-- ==========================================
-- Shoot particles in every direction parallel to ground
-- ==========================================

function EFFECT:Explosion( pos )
	local emitter = ParticleEmitter( pos, false )
	
	if emitter then
		
		for i = 0,36 do
			local particle = emitter:Add( Materials[math.Round(math.Rand(1,table.Count( Materials )),0)], pos )
			
			if particle then
				local ang = i * 10
				local X = math.cos( math.rad(ang) )
				local Y = math.sin( math.rad(ang) )
				
				particle:SetVelocity( Vector(X,Y,0) * math.Rand(1500,2000) )
				particle:SetLifeTime( 4 )
				particle:SetDieTime( 6 )
				particle:SetAirResistance( 50 ) 
				particle:SetStartAlpha( 20 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 0 )
				particle:SetEndSize( math.Rand(120,200) )
				particle:SetRoll( math.Rand(-1,1) )
				particle:SetColor( 250,250,250 )
				particle:SetGravity( Vector( 0, 0, 100 ) )
				particle:SetCollide( false )
				particle:SetLighting(0)
			end
		end
		
		emitter:Finish()
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
