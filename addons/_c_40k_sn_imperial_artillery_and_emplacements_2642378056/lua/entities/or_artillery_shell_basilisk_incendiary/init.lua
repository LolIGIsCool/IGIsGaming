AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include('shared.lua')

function ENT:Initialize()	
	self:SetModel("models/ordoredactus/props/basilisk_shell.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:SetColor( Color(255, 255, 255, 255) )	
	self.StartTime = CurTime()
	self.EndTime = CurTime() + 25 + math.Rand(0,10)
	ParticleEffectAttach( "incendiary_1_final", 3, self, 3 )
	self.Sound = self:StartLoopingSound("artillery_incendiary_fire")
end

function ENT:Think()	
	if self.EndTime < CurTime() then
		self:StopLoopingSound( self.Sound )
		self:Remove()
	end

	if self:CanFire() then
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 512)) do
				if IsValid(v) then
					if v:IsNPC() or v:IsPlayer() then
						self:FireDamage(v)
					end
				end
			end
		self:RateOfFire( CurTime() + 0.20 )
	end
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
