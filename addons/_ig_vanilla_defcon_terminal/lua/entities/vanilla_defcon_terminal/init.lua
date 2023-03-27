AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
util.AddNetworkString("OPENDEFCONMENUVANILLAILOVEYOU")
util.AddNetworkString("VANILLAFROMTHEUNDERWORLDDEFCON")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/kingpommes/starwars/misc/circle_console_dirty.mdl")
    --self:SetModel("models/props_phx/construct/metal_tubex2.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
    self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
    self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
end

local allowedRegiments = {
    ["Imperial Navy"] = true,
    ["Dynamic Environment"] = true,
    ["Imperial Starfighter Corps"] = true,
    ["Imperial Naval Engineer"] = true,
    ["Imperial Naval Engineers"] = true,
    ["Imperial Executive Command"] = true,
    ["Imperial High Command"] = true
}

function ENT:AcceptInput(strName, activator, caller)
    if (strName == "Use" and caller:IsPlayer() and caller:Alive() and caller:GetPos():Distance(self:GetPos()) < 100 and caller:GetEyeTrace().Entity == self and (allowedRegiments[caller:GetRegiment()] or caller:IsAdmin() or caller:IsEventMaster()) ) then
        net.Start("OPENDEFCONMENUVANILLAILOVEYOU")
        net.Send(caller)
    end
end

net.Receive("VANILLAFROMTHEUNDERWORLDDEFCON",function(len, ply)
    if (allowedRegiments[ply:GetRegiment()] or ply:IsAdmin() or ply:IsEventMaster()) then

        vanillaignewdefcon = net.ReadUInt(16)
		if vanillaignewdefcon == 11 or vanillaignewdefcon == 12 or vanillaignewdefcon == 13 or vanillaignewdefcon == 31 or vanillaignewdefcon == 32 then
            globaldefconn = 3
            SetGlobalBool("diseasesystemactive", false)
            RunConsoleCommand("ulx", "asay", "Event", "Mode", "turned", "on")
        elseif vanillaignewdefcon == 21 or vanillaignewdefcon == 41 or vanillaignewdefcon == 42 then
            globaldefconn = 5
            SetGlobalBool("diseasesystemactive", true)
            RunConsoleCommand("ulx", "asay", "Event", "Mode", "turned", "off")
        --elseif vanillaignewdefcon == 42 then
        --    globaldefconn = 5
        --    SetGlobalBool("diseasesystemactive", true)
        --    RunConsoleCommand("ulx", "asay", "Event", "Mode", "turned", "off")
        end

        local dc = string.Split(vanillaignewdefcon,"")

        net.Start("DefconSound")
        net.WriteUInt(vanillaignewdefcon, 16)
        net.Broadcast()
        --ulx.fancyLogAdmin(calling_ply, "#A set the defcon level to #s", vanillaIGDEFCONTYPES[tonumber(dc[1])][tonumber(dc[2])])
        net.Start("defconchatalert")
        net.Broadcast()
    end
end)
