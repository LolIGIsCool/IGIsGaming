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
	if self:CanFire() and self.Triggered then
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 512)) do
				if IsValid(v) then
					if v:IsNPC() or v:IsPlayer() then
						self:FireDamage(v)
					end
				end
			end
		self:RateOfFire( CurTime() + 0.20 )
	end

	if self.EndTime < CurTime() then
		self:Remove()
	end
end

function ENT:Explode()
	self:EmitSound("artillery_basilisk_incoming")
	timer.Simple( 2.1, function()
		util.BlastDamage( self, self.Creator, self:GetPos() + Vector(0,0,20), 800, 200 )
		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
		util.Effect( "artillery_explosion_1", effectdata )
		util.ScreenShake( self:GetPos(), 1000, 50, 1, 1600 )
		ParticleEffectAttach( "incendiary_1_final", 3, self, 3 )
		self.Sound = self:StartLoopingSound("artillery_incendiary_fire")
		self.Triggered = true
	end)
end

function ENT:FireDamage(ent)
	if IsValid(ent) then
		if ent:IsPlayer() or ent:IsNPC() then
		local dmginfo = DamageInfo()
			dmginfo:SetDamage( 35 )
			dmginfo:SetDamageType( DMG_BURN ) 
			dmginfo:SetAttacker( self.Gunner or self:GetCreator() )
		ent:TakeDamageInfo( dmginfo )
		ent:Ignite( 5, 20 )
		end
	end
end

function ENT:CanFire()
		self.NextFire = self.NextFire or 0
		return self.NextFire < CurTime()
	end

function ENT:RateOfFire( time )
	self.NextFire = time
end

function ENT:OnRemove()
	self:StopLoopingSound( self.Sound )
end