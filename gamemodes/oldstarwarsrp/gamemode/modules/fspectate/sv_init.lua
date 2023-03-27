util.AddNetworkString("FSpectate")
util.AddNetworkString("FSpectateTarget")
util.AddNetworkString("SendColorMsg")

local function findPlayer(info)
    if not info or info == "" then return nil end
    local pls = player.GetAll()

    for k = 1, #pls do
        local v = pls[k]
        if tonumber(info) == v:UserID() then return v end
        if info == v:SteamID() then return v end
        if string.find(string.lower(v:Name()), string.lower(tostring(info)), 1, true) ~= nil then return v end
    end

    return nil
end

local fspectatorrs = {"STEAM_0:0:52423713", "STEAM_0:0:23047205", "STEAM_0:0:57771691", "STEAM_0:1:155613207", "STEAM_0:1:52838150", "STEAM_0:1:167427435", "STEAM_0:0:80706730", "STEAM_0:1:70442866", "STEAM_0:0:41555770", "STEAM_0:0:31409949","STEAM_0:0:7634642","STEAM_0:0:44722715"} -- Moose -- Wolf -- Kumo -- Frank -- Whitey -- Kosmos -- Jman -- Cecil -- Zaspan -- Welshy-- Tank -- Rook
local fspectatorrlogs = {"STEAM_0:0:52423713", "STEAM_0:0:23047205", "STEAM_0:1:52838150", "STEAM_0:0:80706730", "STEAM_0:0:57771691", "STEAM_0:0:41555770", "STEAM_0:1:70442866","STEAM_0:0:7634642","STEAM_0:0:44722715"} -- Moose -- Wolf -- Whitey -- Jman -- Kumo -- Zaspan -- Cecil
local plymeta = FindMetaTable("Player")

function plymeta:CanFSpecate()
    if table.HasValue(fspectatorrs, self:SteamID()) then return true end
end

function plymeta:CanFSpecateLogs()
    if table.HasValue(fspectatorrlogs, self:SteamID()) then return true end

    return false
end

local function startSpectating(ply, target)
    ply.FSpectatingEnt = target
    ply.FSpectating = true
    ply:ExitVehicle()
    net.Start("FSpectate")
    net.WriteBool(target == nil)

    if IsValid(ply.FSpectatingEnt) then
        net.WriteEntity(ply.FSpectatingEnt)
    end

    net.Send(ply)
    local targetText = IsValid(target) and target:IsPlayer() and (target:Nick() .. " (" .. target:SteamID() .. ")") or IsValid(target) and "an entity" or ""
    ply:ChatPrint("You are now spectating " .. targetText)

    for k, v in pairs(player.GetAll()) do
        if not v:CanFSpecateLogs() then continue end

        if IsValid(target) and target:IsPlayer() then
            net.Start("SendColorMsg")
            net.WriteEntity(v)
            net.WriteEntity(target)
            net.WriteEntity(ply)
            net.WriteString("")
            net.Send(v)
        end
    end
end

local function Spectate(ply, cmd, args)
    if ply:CanFSpecate() then
        local target = findPlayer(args[1])

        if target == ply then
            ply:ChatPrint("Invalid target!")

            return
        end

        for k, v in pairs(player.GetAll()) do
            if not v:CanFSpecateLogs() then continue end

            if target == nil then
                net.Start("SendColorMsg")
                net.WriteEntity(v)
                net.WriteEntity(target)
                net.WriteEntity(ply)
                net.WriteString("start")
                net.Send(v)
            end
        end

        startSpectating(ply, target)
    end
end

concommand.Add("FSpectate", Spectate)

net.Receive("FSpectateTarget", function(_, ply)
    if ply:CanFSpecate() then
        startSpectating(ply, net.ReadEntity())
    end
end)

local function TPToPos(ply, cmd, args)
    if ply:CanFSpecate() then
        local x, y, z = string.match(args[1] or "", "([-0-9\\.]+),%s?([-0-9\\.]+),%s?([-0-9\\.]+)")
        local vx, vy, vz = string.match(args[2] or "", "([-0-9\\.]+),%s?([-0-9\\.]+),%s?([-0-9\\.]+)")
        local pos = Vector(tonumber(x), tonumber(y), tonumber(z))
        local vel = Vector(tonumber(vx or 0), tonumber(vy or 0), tonumber(vz or 0))
        if not args[1] or not x or not y or not z then return end
        ply:SetPos(pos)

        if vx and vy and vz then
            ply:SetVelocity(vel)
        end
    end
end

concommand.Add("FTPToPos", TPToPos)

local function SpectateVisibility(ply, viewEnt)
    if not ply.FSpectating then return end

    if IsValid(ply.FSpectatingEnt) then
        AddOriginToPVS(ply.FSpectatingEnt:IsPlayer() and ply.FSpectatingEnt:GetShootPos() or ply.FSpectatingEnt:GetPos())
    end

    if ply.FSpectatePos then
        AddOriginToPVS(ply.FSpectatePos)
    end
end

hook.Add("SetupPlayerVisibility", "FSpectate", SpectateVisibility)

local function setSpectatePos(ply, cmd, args)
    if ply:CanFSpecate() then
        if not ply.FSpectating or not args[3] then return end
        local x, y, z = tonumber(args[1] or 0), tonumber(args[2] or 0), tonumber(args[3] or 0)
        ply.FSpectatePos = Vector(x, y, z)
        ply.FSpectatingEnt = nil
    end
end

concommand.Add("_FSpectatePosUpdate", setSpectatePos)

local function endSpectate(ply, cmd, args)
    ply.FSpectatingEnt = nil
    ply.FSpectating = nil
    ply.FSpectatePos = nil

    for k, v in pairs(player.GetAll()) do
        if not v:CanFSpecateLogs() then continue end
        net.Start("SendColorMsg")
        net.WriteEntity(v)
        net.WriteEntity(target)
        net.WriteEntity(ply)
        net.WriteString("stop")
        net.Send(v)
    end
end

concommand.Add("FSpectate_StopSpectating", endSpectate)