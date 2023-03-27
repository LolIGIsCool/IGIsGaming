AddCSLuaFile("shared.lua")
include('shared.lua')

function ENT:Initialize()
    -- Set up the entity
    self.Entity:SetModel("models/riddickstuff/bactagrenade/bactanade.mdl")
    self.Entity:PhysicsInit(SOLID_BSP)
    self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
    self.Entity:SetSolid(SOLID_BSP)
    self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self.Entity:SetColor(Color(255, 255, 255, 255))
    self.Index = self.Entity:EntIndex()
    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:PhysicsCollide(data, physobj)
    local entowner = self.Entity:GetOwner()
    --util.BlastDamage( self, entowner, self.Entity:GetPos(), 165, 4 )
    local tobeblasted = ents.FindInSphere(self.Entity:GetPos(), 500)

    for k, v in pairs(tobeblasted) do
        if v:IsPlayer() then
            if (SERVER) then
                if v:Health() > v:GetMaxHealth() then continue end

                if _G.HasAugment(v, "Heal Intake I") and not _G.HasAugment(v, "Heal Intake II") then
                    v:SetHealth(math.min(v:GetMaxHealth(), v:Health() + (v:GetMaxHealth() * .5)))
                    _G.ActivateAugment(v,"Heal Intake I",1)
                elseif _G.HasAugment(v, "Heal Intake II") then
                    v:SetHealth(math.min(v:GetMaxHealth(), v:Health() + (v:GetMaxHealth() * .4)))
                    _G.ActivateAugment(v,"Heal Intake II",1)
                elseif v == entowner then
                    v:SetHealth(math.min(v:GetMaxHealth(), v:Health() + (v:GetMaxHealth() * .3)))
                else
                    v:SetHealth(math.min(v:GetMaxHealth(), v:Health() + (v:GetMaxHealth() * .3)))
                end

				local need = v:GetMaxHealth() * .3
                
                for i = 1, need do
					_G.AdvanceQuest(entowner,"Daily","Redemption I");
            		_G.AdvanceQuest(entowner,"Daily","Redemption II");
            		_G.AdvanceQuest(entowner,"Daily","Redemption III");
				end

                hook.Call("healfrombacta", GAMEMODE, entowner, v:GetMaxHealth() * .3, v)

                --v:Kill()
                if _G.HasAugment(v, "Swift Recovery") then
                    local extraheal = math.random(10, 50)
                    local healspersecond = extraheal / 5
                    _G.ActivateAugment(v,"Swift Recovery",5)

                    timer.Create("healperk" .. math.random(1, 9999), 1, 5, function()
                        if v:Health() >= v:GetMaxHealth() then return end
                        local healthtoset = v:Health() + healspersecond
                        v:SetHealth(healthtoset)
                    end)
                end
            end
        end
    end

    self.Entity:EmitSound("bacta/bactapop.wav", 75, 50)
    local effectdata = EffectData()
    effectdata:SetOrigin(self.Entity:GetPos())
    --effectdata:SetScale( 1 )
    util.Effect("effect_bactanade", effectdata)
    --util.Effect( "HelicopterMegaBomb", effectdata )
    self.Entity:Remove()
end