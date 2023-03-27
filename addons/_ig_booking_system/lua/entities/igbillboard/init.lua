AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
util.AddNetworkString("openbillboardsetter")
util.AddNetworkString("setbillboardtxt")
include("shared.lua")
SetGlobalString("billboardmsg", "Message Navy to make a Booking")

function ENT:Initialize()
    self:SetModel("models/cire992/props4/gui_terminal02_03_static.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:Use(activator, caller)
    if caller:IsAdmin() then
        net.Start("openbillboardsetter")
        net.Send(caller)
    end
end

net.Receive("setbillboardtxt", function(len, ply)
    local billboardmsg = net.ReadString()
    local len21345 = string.len(billboardmsg)
    if len21345 > 60 then return end
    if ply:IsAdmin() then
        globalmsgbooking = billboardmsg
        net.Start("receiveBooking")
        net.WriteString("MSG")
        net.WriteString(billboardmsg)
        net.Broadcast()
    end
end)

function ENT:Think()
end