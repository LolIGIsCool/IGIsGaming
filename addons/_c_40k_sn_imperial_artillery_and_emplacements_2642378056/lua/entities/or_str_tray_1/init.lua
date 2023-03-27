AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')


function ENT:Initialize()	
	self:SetModel("models/ordoredactus/props/prop_artillery_rack.mdl")
	self:DrawShadow( true )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetColor( Color(255, 255, 255, 255) )
	self:SetHealth( 500 )
	self.Exploded = false
	self.Creator = self:GetCreator()
end

function ENT:OnTakeDamage( dmginfo )
	self:SetHealth( self:Health() - dmginfo:GetDamage() )
	self.Attacker = dmginfo:GetAttacker()

	if self:Health() < 0 then 
		self:Explode( dmginfo )
		self.Exploded = true
	end
end

function ENT:Explode( dmginfo )
		if self.Exploded then return end
		for i = 1, math.Rand(1,3) do
		timer.Simple( math.random()*2, function()
			util.BlastDamage( self, self.Attacker or self.Creator, self:GetPos() + Vector(0,0,20), 2400, 16000 )
			local effectdata = EffectData()
			effectdata:SetOrigin( self:GetPos() )

			util.Effect( "artillery_explosion_2", effectdata )
			util.ScreenShake( self:GetPos(), 1000000, 50, 0.5, 6400 )
		end)
		timer.Simple( 2, function()
			self:Remove()
		end)
	end
end