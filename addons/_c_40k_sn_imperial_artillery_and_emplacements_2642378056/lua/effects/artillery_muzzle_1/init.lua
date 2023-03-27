-- ==========================================
-- Muzzle effect for artillery.
-- Has a flame, a smoke cloud and then small smoke emanating from the barrel.
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
	local gun = data:GetEntity()
	
	if not IsValid( gun ) then return end
	
	local ID = data:GetAttachment()
	
	local Attachment = gun:GetAttachment( ID )
	
	local Pos = Attachment.Pos
	local Dir = Attachment.Ang:Forward()
	
	self.emitter = ParticleEmitter( Pos, false )
	
	self:Muzzle( Pos, Dir )
	
	self.Time = math.Rand(6,12)
	self.DieTime = CurTime() + self.Time
	self.AttachmentID = ID
	self.Platform = data:GetEntity()
end

function EFFECT:Muzzle( pos, dir )
	if not self.emitter then return end
	
	for i = 0,20 do
		local particle = self.emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
		
		local rCol = math.Rand(120,140)
		
		if particle then
			particle:SetVelocity( dir * math.Rand(500,2000) + VectorRand() * math.Rand(0,10) )
			particle:SetDieTime( math.Rand(4,7) )
			particle:SetAirResistance( math.Rand(100,500) ) 
			particle:SetStartAlpha( math.Rand(80,180) )
			particle:SetStartSize( 5 )
			particle:SetEndSize( math.Rand(320,500) )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetColor( rCol,rCol,rCol )
			particle:SetGravity( VectorRand() * 20 + Vector(0,0,200) )
			particle:SetCollide( false )
		end
	end

	for i = 0,20 do
		local particle = self.emitter:Add( "effects/muzzleflash2", pos )

		if particle then
			particle:SetVelocity( dir * math.Rand(1200,3000) )
			particle:SetDieTime( 0.3 )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.random(40,80) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -1, 1 ) )
			particle:SetColor( 255,255,255 )
			particle:SetCollide( false )
		end
	end
end

function EFFECT:Think()
	local Platform = self.Platform
	if not IsValid( Platform ) then return false end
	
	if self.DieTime > CurTime() then
		local intensity = ((self.DieTime - CurTime()) / self.Time)
		
		local Attachment = Platform:GetAttachment( self.AttachmentID )
		local dir = Attachment.Ang:Up()
		local pos = Attachment.Pos + dir * 3
	
		if self.emitter then
			for i = 0,math.Rand(3,6) do
				local particle = self.emitter:Add( Materials[math.random(1,table.Count( Materials ))], pos )
				
				if particle then
					particle:SetVelocity( dir * 2 + VectorRand() * 10 )
					particle:SetLifeTime( 5 )
					particle:SetDieTime( math.Rand(5,10) )
					particle:SetAirResistance( 0 ) 
					particle:SetStartAlpha( (intensity ^ 5) * 20 )
					particle:SetStartSize( intensity * 5 )
					particle:SetEndSize( math.Rand(20,30) * intensity )
					particle:SetRoll( math.Rand(-1,1) )
					particle:SetColor( 120,120,120 )
					particle:SetGravity( Vector(0,0,20) + VectorRand() * math.Rand(0,5) )
					particle:SetCollide( false )
				end
			end
		end
		
		return true
	else
	
		if self.emitter then
			self.emitter:Finish()
		end
		
		return false
	end
end

function EFFECT:Render()
end
