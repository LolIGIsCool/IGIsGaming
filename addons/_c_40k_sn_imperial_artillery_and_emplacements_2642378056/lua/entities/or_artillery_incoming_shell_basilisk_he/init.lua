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
	self:EmitSound("artillery_basilisk_incoming")
	timer.Simple( 2.1, function()
		util.BlastDamage( self, self.Creator, self:GetPos() + Vector(0,0,20), 800, 8000 )
		util.BlastDamage( self, self.Creator, self:GetPos() + Vector(0,0,20), 1600, 80 )
		util.BlastDamage( self, self.Creator, self:GetPos() + Vector(0,0,20), 100, 16000 )
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "artillery_explosion_1", effectdata )
		util.ScreenShake( self:GetPos(), 1000, 50, 1, 1600 )
		self:Remove()
	end)
end