AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'or/displacements/cl_orto_displacements.lua' )
AddCSLuaFile( 'or/map_orto/cl_map_orto.lua' )
AddCSLuaFile( 'lib/imgui.lua' )

resource.AddSingleFile("materials/vgui/planet_border.png")
resource.AddSingleFile("materials/or/orto_disp_backup.vmt")
resource.AddSingleFile("materials/or/orto_disp_backup0.vmt")
resource.AddSingleFile("materials/or/orto_ground_backup.vmt")

--                --
--  Shared Files  --
--                --
AddCSLuaFile( 'or/sh_creationkit.lua' )
--AddCSLuaFile( 'or/displacements/sh_orto_displacements.lua' )
AddCSLuaFile( 'shared.lua' )

include("or/sh_creationkit.lua")
--include("or/displacements/sh_orto_displacements.lua")
include('shared.lua')

--                --
--  Misc Files    --
--                --
include("or/displacements/sv_orto_displacements.lua")
include("or/map_orto/sv_map_orto.lua")

--                            --
--  Precache Network Strings  --
--                            --
util.AddNetworkString("CreateCustomizerPanel")
util.AddNetworkString("sv_createortopreset")
util.AddNetworkString("sv_getortopresets")
util.AddNetworkString("cl_sendortopresets")
util.AddNetworkString("sv_LoadORPreset")
util.AddNetworkString("cl_LoadORPreset")
util.AddNetworkString("HideyoshiOR_Ready")
util.AddNetworkString("HideyoshiOR_ResetOrto")
util.AddNetworkString("HideyoshiOR_CLResetOrto")

local initialized_players = {}

function ENT:Initialize()

    self:SetModel('models/valk/h4/unsc/props/terminal/terminal_monitor.mdl')
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )

    local phys = self:GetPhysicsObject()
    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:Use( activator, caller )
    return
end

net.Receive("HideyoshiOR_Ready", function(len,ply)
    if or_current_materials and next(or_current_materials) then
        if or_current_materials.map_data then
            sh_HideyoshiApplyChanges(ply, or_current_materials.map_data, false)
        end

        if or_current_materials.displacement_data then
            sh_HideyoshiApplyChanges(ply, or_current_materials.displacement_data, false)
        end
        table.insert(initialized_players, ply)
    end
end)

net.Receive("sv_createortopreset", function(len,ply)
    if !ply:IsAdmin() then return end
    local data = net.ReadTable()
    data[9] = ply:Name()
    file.CreateDir( "orto_presets/" )
    file.Write("orto_presets/"..data[8]..".txt", util.TableToJSON(data))
end)

net.Receive("sv_getortopresets", function(len,ply)
    if !ply:IsAdmin() then return end
    local fil, dir = file.Find( "orto_presets/*.txt", "DATA" )
    local tableofpresets = {}
    for k,v in pairs(fil) do
        local filetable = {
            util.JSONToTable(file.Read("orto_presets/"..v, "DATA"))[8],
            util.JSONToTable(file.Read("orto_presets/"..v, "DATA"))[9],
            v
        }
        table.insert(tableofpresets, filetable) 
    end
    net.Start("cl_sendortopresets")
        net.WriteTable(tableofpresets)
    net.Send(ply)
end)

net.Receive("sv_LoadORPreset", function(len,ply)
    if !ply:IsAdmin() then return end
    net.Start("cl_LoadORPreset")
        net.WriteString(file.Read("orto_presets/"..net.ReadString(), "DATA"))
    net.Send(ply)
end)

net.Receive("HideyoshiOR_ResetOrto", function(len, ply)
    if not (ply:IsAdmin() or ply:GetRegiment() == "Imperial Navy") then
        ply:PrintMessage(HUD_PRINTTALK, "[Orto Customizer] You do not have permission to use this tool")
        return
    end

    if (!string.match(game.GetMap(), "rp_stardestroyer")) then
        PrintMessage(HUD_PRINTTALK, "[Orto Customizer] Not on rp_stardestroyer_v2_5_inf")
        return
    end

    or_current_materials = {}
    net.Start("HideyoshiOR_CLResetOrto")
    net.Broadcast()
end)