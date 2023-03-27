AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/dolunity/starwars/mortar/shell.mdl")

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetCollisionGroup(COLLISION_GROUP_NONE)
    self:PhysWake()
end

function ENT:PhysicsCollide()
    if self:WaterLevel() > 0 then
        self:Remove()
        return
    end

    local vfire = ents.Create("vfire_cluster")
    if (not IsValid(vfire)) then
        local fires = {}
        local r = 256
        for i = 1, 15 do
            local pos = self:GetPos() + Vector(math.random(-r, r), math.random(-r, r), 0)

            local fire = ents.Create("env_fire")
            fire:SetPos(pos)
            fire:SetKeyValue("health", "999999")
            fire:SetKeyValue("firesize", "64")
            fire:SetKeyValue("damagescale", "25")
            fire:SetKeyValue("spawnflags", "0")
            fire:SetOwner(self:GetOwner())
            fire:Spawn()
            fire:Fire("StartFire", "", 0)
            table.insert(fires, fire)
        end
        timer.Simple(25, function()
            if (istable(fires)) then
                PrintTable(fires)
                for i, v in pairs(fires) do
                    v:Remove()
                end
            end
        end)
    else
        if (isfunction(CreateVFireBall)) then
            CreateVFireBall(60 * 15, 10, self:GetPos(), Vector())
        end

        vfire:Spawn()
        local r = 256
        for i = 1, 3 do
            local pos = self:GetPos() + Vector(math.random(-r, r), math.random(-r, r), 0)
            vfire = ents.Create("vfire_cluster")
            vfire:SetPos(pos)
            vfire:Spawn()
        end
    end

    local explosion = ents.Create("env_explosion")
    explosion:SetPos(self:GetPos())
    explosion:Spawn()
    explosion:Fire("Explode")
    explosion:SetKeyValue("IMagnitude", 1)

    util.BlastDamage(self, self, self:GetPos(), 500, 20)

    self:Remove()
end