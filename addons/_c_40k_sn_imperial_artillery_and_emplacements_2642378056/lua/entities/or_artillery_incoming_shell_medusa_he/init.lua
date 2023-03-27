AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')


function ENT:Initialize()	
	self:SetModel("models/ordoredactus/props/basilisk_shell.mdl")
	self:DrawShadow( false )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetColor( Color(255, 255, 255, 255) )
	self.Creator = self:GetCreator()
	self.SpawnTime = CurTime()
	self.Triggered = false
end

function ENT:Think()	
	if self.Triggered == false then
		self.Triggered = true
		self:Explode()
	end
end

function ENT:Explode()
	self:EmitSound("artillery_medusa_incoming")
	timer.Simple( 3, function()
		util.BlastDamage( self, self.Creator, self:GetPos() + Vector(0,0,20), 1600, 8000 )
		util.BlastDamage( self, self.Creator, self:GetPos() + Vector(0,0,20), 2400, 80 )
		util.BlastDamage( self, self.Creator, self:GetPos() + Vector(0,0,20), 400, 24000 )
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "artillery_explosion_2", effectdata )
		util.ScreenShake( self:GetPos(), 100000, 50, 1, 3200 )
		self:Remove()
	end)
end