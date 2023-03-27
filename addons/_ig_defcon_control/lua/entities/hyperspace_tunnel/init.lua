AddCSLuaFile("cl_init.lua") -- Make sure clientside
AddCSLuaFile("shared.lua") -- and shared scripts are sent.
include('shared.lua')
util.AddNetworkString("ISDTunneladd")
util.AddNetworkString("ISDTunnelremove")

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

local cooldown = 0
local isdtunnelmodel
tunneltoggle = 1

function ENT:Use(activator, caller)
    if caller:GetRegiment() == "Imperial Navy" and tunneltoggle == 1 and cooldown <= CurTime() or caller:IsAdmin() and tunneltoggle == 1 then
        cooldown = CurTime() + 2
        tunneltoggle = 2
            if not isentity(isdtunnelmodel) and tunneltoggle == 2 then
                isdtunnelmodel = ents.Create("prop_dynamic")
                isdtunnelmodel:SetModel("models/kingpommes/starwars/venator/hypertunnel.mdl")
                isdtunnelmodel:SetPos(Vector(1810.06, -6591.44, 13769.5))
                isdtunnelmodel:SetAngles(Angle(0, 180, 0))
                isdtunnelmodel:SetColor(Color(255, 255, 255, 255))
                isdtunnelmodel:Spawn()
                isdtunnelmodel:SetNoDraw(false)
                print("Hyperspace Tunnel spawned")
			end
        ulx.fancyLogAdmin(caller, "#A Has Toggled the Hyperspace Tunnel ON.")
        print(tunneltoggle)
    elseif caller:GetRegiment() == "Imperial Navy" and tunneltoggle == 2 or caller:IsAdmin() and tunneltoggle == 2 then
        tunneltoggle = 1
            if tunneltoggle == 1 and isdtunnelmodel and isentity(isdtunnelmodel) then
                isdtunnelmodel:Remove()
                isdtunnelmodel = nil
                print("Hyperspace Tunnel removed")
			end
        ulx.fancyLogAdmin(caller, "#A Has Toggled the Hyperspace Tunnel OFF.")
    end
end

hook.Add("IGPlayerSay", "chatrtun", function(ply, text)
    if ply:IsSuperAdmin() and (text:lower() == "!rtun") then
        isdtunnelmodel:Remove()
        isdtunnelmodel = nil
    end
    if ply:IsSuperAdmin() and (text:lower() == "!ftun") then
        ents.FindByModel( "models/kingpommes/starwars/venator/hypertunnel.mdl" )
    end
end)

function ENT:Think()
    return
end