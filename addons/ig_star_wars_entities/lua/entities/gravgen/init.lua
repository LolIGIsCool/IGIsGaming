-- Author: Tood/The Toodster. Contact: Discord - The Toodster#0001 || Steam - https://steamcommunity.com/id/freelancertood/
-- Modified for the Imperial Gaming community by Goliath (https://steamcommunity.com/id/gmelchett/)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props/starwars/tech/cis_ship_switcher.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMaxHealth(self.GenHealth)
    self:SetHealth(self.GenHealth)
    local GenPhys = self:GetPhysicsObject()

    if IsValid(GenPhys) then
        GenPhys:Wake()
    end
end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
    if (self:Health() <= 0) then return end
    self:SetHealth(math.Clamp(self:Health() - dmg:GetDamage(), 0, self:GetMaxHealth()))
    

    for k, v in pairs(player.GetAll()) do
        if (self:Health() <= 0) then
            local BoomBoom = ents.Create("env_explosion")
            BoomBoom:SetKeyValue("spawnflags", 144)
            BoomBoom:SetKeyValue("iMagnitude", 15)
            BoomBoom:SetKeyValue("iRadiusOverride", 256)
            BoomBoom:SetPos(self:GetPos())
            BoomBoom:Spawn()
            BoomBoom:Fire("explode", "", 0)
            RunConsoleCommand("sv_gravity", "100")
            RunConsoleCommand("sv_friction", "1")
            PrintMessage(HUD_PRINTCENTER, "Gravity Generator has been destroyed!")
            self:Ignite(20, 250)
        end
    end
end

function ENT:Think()
    self:NextThink(CurTime() + 1)

    if self:GetPlayerRepairing() then
        for k, v in pairs(player.GetAll()) do
            if self:Health() <= 0 then return end

            if self:Health() > 0 then
                timer.Simple(1, function()
                    RunConsoleCommand("sv_gravity", "600")
                    RunConsoleCommand("sv_friction", "8")
                end)
            end
        end

        self:SetPlayerRepairing(false)
    end
end

function ENT:OnRemove()
    RunConsoleCommand("sv_gravity", "600")
    RunConsoleCommand("sv_friction", "8")
end