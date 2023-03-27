AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
util.AddNetworkString("Colour")
util.AddNetworkString("VSize")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/wood/wood_boardx4.mdl")
	self:SetName("Turbolaser")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(true)
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
	end
	self.Phys = self:GetPhysicsObject()
	self:EmitSound("vanilla/turbolaser/vanilla_tl_shot.wav", 511, math.random(95,125))
end

function ENT:KeyValue( key, value )
	if ( key == "Force" ) then
		self.Force = value
	end
	if ( key == "Damage" ) then
		self.Damage = value
	end
	if ( key == "Magnitude" ) then
		self.Magnitude = value
	end
	if ( key == "Colour" ) then
		self:SetColour(value)
	end
	if (key == "Volume") then
		self.Volume = value
	end
	if ( key == "Mute" ) then
		self.Mute = tobool(value)
	end
	if (key == "Size" ) then
		self:SetVSize(value)
	end
end

function ENT:PhysicsUpdate()
	if self.Once then
		self:Remove()
	else
		self.Phys:SetVelocity( self:GetForward() * self.Force )
	end
end

function ENT:Think()
end

function ENT:Boom()
	if not self.Once then
		local Pos = self:GetPos()
		local Scale = self.Magnitude * 500
		util.BlastDamage( self, self, self:GetPos(), self.Magnitude, self.Damage )
		if self.Mute == false then
			local effectdata = EffectData()
			effectdata:SetStart( Pos )
			effectdata:SetOrigin( Pos )
			effectdata:SetScale( Scale )
			util.Effect( "Explosion", effectdata )
			util.Effect( "HelicopterMegaBomb", effectdata)
			self:EmitSound("weapons/explode" .. math.random(3,5) .. ".wav", self.Volume, 100)
		end
	end
	self.Once = true
end

function ENT:PhysicsCollide( data, phys )
	self:Boom()
end
