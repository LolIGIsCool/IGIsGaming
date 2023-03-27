AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')

-- ==========================================
-- Initialization. The canister jumps and after 5 seconds starts the gas emission.
-- ==========================================

function ENT:Initialize()	
	self:SetModel("models/ordoredactus/props/basilisk_shell.mdl")
	self:DrawShadow( false )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetColor( Color(255, 255, 255, 255) )
	local phys = self:GetPhysicsObject()	
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMaterial("metal")
		phys:ApplyForceCenter( VectorRand()*5000 )
	end	
	local self_name = "Phosgene Gas" .. self:EntIndex()
	self.Creator = self:GetCreator()
		self:SetName( self_name )
	self.SpawnTime = CurTime()
	self.StartTime = CurTime() + 1
	if CurTime() == self.StartTime then 
		self:EmitSound("wk_gas_shell_emission") 
	end
end

-- ==========================================
-- Finds all entities in sphere and damages them unless they are in vehicle
-- ==========================================

function ENT:Gasdamage(ent)
	if IsValid(ent) then
		if ent:IsPlayer() and not ent:InVehicle() or ent:IsNPC() and self:Visible(ent) and ent:GetPos():Distance(self:GetPos()) < 1600 then
			local dmginfo = DamageInfo()
				dmginfo:SetDamage( 100 )
				dmginfo:SetDamageType( DMG_NERVEGAS) 
				dmginfo:SetAttacker( self.Gunner or self.Creator )
		util.BlastDamageInfo( dmginfo, self:GetPos() + Vector(0,0,20), 1200 )
		end
	end
end

-- ==========================================
-- Gas emission cooldown
-- ==========================================

function ENT:CanEmitGas()
		self.NextGasEmission = self.NextGasEmission or 0
		return self.NextGasEmission < CurTime()
	end

function ENT:RateOfGasEmission( vehicle, time )
	self.NextGasEmission = CurTime() + 1
end

-- ==========================================
-- Think function that tries to emit gas every tick
-- ==========================================

function ENT:Think()	
	if CurTime() > self.StartTime then

		local effectdata2 = EffectData()
				effectdata2:SetOrigin( self:GetPos() )
				effectdata2:SetEntity( self )
				effectdata2:SetScale( 1 )
		util.Effect( "artillery_gas_shell_cloud_green", effectdata2, true, true )
		if self:CanEmitGas() then
			for k, v in pairs(ents.FindInSphere(self:GetPos(), 1600)) do
					if IsValid(v) then
						if v:IsNPC() or v:IsPlayer() then
							self:Gasdamage(v)
						end
					end
				end
			self:RateOfGasEmission( CurTime() + 2 )
			self:Gasdamage( ent )
		end
	end
	if (self.SpawnTime + 30) < CurTime() then
		self:Remove()
	end
end

function ENT:PhysicsCollide( data )
end

function ENT:OnTakeDamage( dmginfo )
	return
end

function ENT:Use( activator, caller )
end