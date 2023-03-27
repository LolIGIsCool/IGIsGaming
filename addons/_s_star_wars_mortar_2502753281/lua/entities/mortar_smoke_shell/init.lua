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
    local sfx = EffectData()
    sfx:SetOrigin(self:GetPos())

    util.Effect("effect_smokenade_smoke", sfx)
    self:Remove()
end