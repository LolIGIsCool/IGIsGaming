AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    local model123 = self:GetNWString("carryentmodel", nil)
    self:SetModel("models/kingpommes/emperors_tower/imp_crates/imp_crate_single_closed_static.mdl") -- placeholder

    if (model123) then
        self:SetModel(model123)
    end

    self:PhysicsInit(SOLID_VPHYSICS) -- Make us work with physics,
    self:SetMoveType(MOVETYPE_VPHYSICS) -- after all, gmod is a physics
    self:SetSolid(SOLID_VPHYSICS) -- Toolbox
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
        phys:SetMass(1)
    end
end

function ENT:Use(activator, caller)
    if (activator:IsPlayer()) then
        if activator:SteamID64() == self:GetNWString("carryentid") then
            if (self:IsPlayerHolding()) then return end
            activator:PickupObject(self)
        else
            activator:QUEST_SYSTEM_ChatNotify("Missions", "This is not your mission item, leave it alone")
        end
    end
end