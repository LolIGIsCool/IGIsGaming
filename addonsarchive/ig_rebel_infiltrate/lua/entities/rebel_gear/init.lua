AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local target = {}
local radius = {}

function ENT:Initialize()
    --local model123 = self:GetNWString("carryentmodel", nil)
    local model = self:GetNWString("gearmodel", nil)
    local i = self:GetNWInt("PlayerIndex", nil)
    local t = self:GetNWVector("TargetArea",nil)
    local r = self:GetNWInt("TargetRadius", nil)
    if not r or not t or not i or not IsValid(Entity(i)) then
        print("something went horribly wrong") 
        self:Remove() 
    else 
        local ply = Entity(i)
        self.Owner = ply
        target[self:EntIndex()] = t 
        radius[self:EntIndex()] = r
        if model then 
            self:SetModel(model)
        else
            self:SetModel("models/kingpommes/emperors_tower/imp_crates/imp_crate_single_closed_static.mdl") -- placeholder
        end
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetCollisionGroup(COLLISION_GROUP_WORLD)
        self:SetUseType(SIMPLE_USE)
        local phys = self:GetPhysicsObject()

        if (phys:IsValid()) then
            phys:Wake()
            phys:SetMass(1)
        end
        net.Start("CL_Rebel_Gear_Stats")
        net.WriteVector(t)
        net.WriteInt(r, 15)
        net.Send(ply)
    end
end

function ENT:Use(activator, caller)
    if (activator:IsPlayer()) then
        if (activator:SteamID64() == self:GetNWString("PlayerCarry") ) then 
            if (self:IsPlayerHolding()) then return end
            activator:PickupObject(self)
        end
    end
end


function ENT:Think()
    if not target[self:EntIndex()] or not radius[self:EntIndex()] then self:Remove() end
    if self:GetPos():DistToSqr( target[self:EntIndex()]) <= radius[self:EntIndex()]^2 then 
        local owner = self.Owner
        self:Remove()
        target[self:EntIndex()] = nil
        radius[self:EntIndex()] = nil
        if IsValid(owner) then 
            net.Start("StopRebelTheftMission")
            net.Send(owner)
            hook.Run("CallMissionProgress", owner) 
        end
    end
    self:NextThink(CurTime() + 2)
end
