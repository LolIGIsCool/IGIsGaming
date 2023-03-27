-- ==========================================
-- Horrible green gas cloud emanating from a gas canister.
-- Sticks to the ground and slowly expands.
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

function EFFECT:Explosion( pos )
	local emitter = ParticleEmitter( pos, false )
	
	if emitter then
		
		for i = 0,1 do
			local particle = emitter:Add( Materials[math.Round(math.Rand(1,table.Count( Materials )),0)], pos )
			
			if particle then
				particle:SetVelocity( VectorRand() *400 )
				particle:SetLifeTime( 3 )
				particle:SetDieTime( 10 )
				particle:SetAirResistance( 10 ) 
				particle:SetStartAlpha( 200 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 0 )
				particle:SetEndSize( math.Rand(600,1200) )
				particle:SetRoll( math.Rand(-1,1) )
				particle:SetColor( 255,255,90 )
				particle:SetGravity( Vector( 0, 0, -70 ) )
				particle:SetCollide( true )
				particle:SetLighting(0.3)
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
