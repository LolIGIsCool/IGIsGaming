AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.SetModelOK)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:SetUseType(SIMPLE_USE)
    self.carryteam = "none"
    self.lasttouch = "none"
    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
    end
end

function ENT:Use(activator, caller)
    if (activator:IsPlayer()) then
        local team = activator:GetNWString("halloweenteam", "none")
        if team == "none" then return end

        if self.carryteam == "none" then
            if (self:IsPlayerHolding()) then return end
            activator:ChatPrint("You have claimed this cauldron ingredient for your team, take it back to the cauldron and add it to the mix!")
            self.carryteam = team
            self.lasttouch = activator
            activator:PickupObject(self)
        elseif self.carryteam == team then
            if (self:IsPlayerHolding()) then return end
            activator:PickupObject(self)
            self.lasttouch = activator
        elseif self.carryteam ~= team then
            activator:QUEST_SYSTEM_ChatNotify("Halloween", "Another team has already claimed this cauldron ingredient, go find another")

            return
        end
    end
end