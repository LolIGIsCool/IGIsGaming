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
	self.EndTime = CurTime() + 30 + math.Rand(0,10)
	self:Explode()
end

function ENT:Think()	
	if self.Triggered then

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

	if self.EndTime < CurTime() then
		self:Remove()
	end
end

function ENT:Explode()
	self:EmitSound("artillery_basilisk_incoming")
	timer.Simple( 2.5, function()
		util.BlastDamage( self, self.Creator, self:GetPos() + Vector(0,0,20), 800, 200 )
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "artillery_explosion_1", effectdata )
		util.ScreenShake( self:GetPos(), 1000, 50, 1, 1600 )
		self.Triggered = true
	end)
end

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

function ENT:CanEmitGas()
		self.NextGasEmission = self.NextGasEmission or 0
		return self.NextGasEmission < CurTime()
	end

function ENT:RateOfGasEmission( vehicle, time )
	self.NextGasEmission = CurTime() + 1
end