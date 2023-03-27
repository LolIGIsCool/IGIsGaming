AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    if SERVER then
        self:SetModel( "models/weapons/tfa_starwars/w_thermal.mdl" )
        self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if (IsValid(phys)) then
        phys:SetMass(1)
    end
        self:DrawShadow( true )
    end
    self.ExplodeTimer = CurTime() + 100000
end

function ENT:PhysicsCollide( data, phys )
    if  (20 < data.Speed and 0.25 < data.DeltaTime) then
    self.ExplodeTimer = 0
    end
end

function ENT:Think()
    if SERVER and (self.ExplodeTimer and self.ExplodeTimer <= CurTime()) then
        self:Explode()
    end
    self:NextThink(CurTime())
    return true
end

function ENT:Explode()
if SERVER then
        local explode = ents.Create( "info_particle_system" )
        explode:SetKeyValue( "effect_name", "BTV4_EXPLO_BARREL_3FRAG" )
        explode:SetOwner( self.Owner )
        explode:SetPos( self:GetPos() )
        explode:Spawn()
        explode:Activate()
        explode:Fire( "start", "", 0 )
        explode:Fire( "kill", "", 15 )
        local explode2 = ents.Create( "info_particle_system" )
        explode2:SetKeyValue( "effect_name", "BTV4_EXPLO_BARREL_3FRAG" )
        explode2:SetOwner( self.Owner )
        explode2:SetPos( self:GetPos() )
        explode2:Spawn()
        explode2:Activate()
        explode2:Fire( "start", "", 0 )
        explode2:Fire( "kill", "", 15 )
        self:EmitSound( "TFA_CSGO_BaseGrenade.Explode" )
end
    util.BlastDamage( self, self.Owner, self:GetPos(), 300, 350 )
    
    local spos = self:GetPos()
    local trs = util.TraceLine({start=spos + Vector(0,0,64), endpos=spos + Vector(0,0,-32), filter=self})
    util.Decal("Scorch", trs.HitPos + trs.HitNormal, trs.HitPos - trs.HitNormal)    
        self:Remove()
end

function ENT:OnRemove()
end