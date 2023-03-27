AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
    self:SetModel("models/kingpommes/starwars/misc/misc_panel_1.mdl")
    self:PhysicsInit(SOLID_VPHYSICS) -- Make us work with physics,
    self:SetMoveType(MOVETYPE_VPHYSICS) -- after all, gmod is a physics
    self:SetSolid(SOLID_VPHYSICS) -- Toolbox
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
    end
end

globallockdownpresser = nil
local cooldown = 0

function ENT:Use(activator, caller)
    if caller:GetRegiment() == "Imperial Navy" or caller:IsAdmin() and cooldown <= CurTime() then
        cooldown = CurTime() + 5
        globallockdownpresser = caller
        RunConsoleCommand("ulx", "lockship")
    end
end

function ENT:Think()
    return
end