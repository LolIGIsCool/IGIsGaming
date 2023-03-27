GM.Name = "starwarsrp"
GM.Author = "Blue Badger, Martibo and Kumo"
GM.Email = "N/A"
GM.Website = "N/A"
DeriveGamemode("sandbox")

local IncludeFiles = function(root)
    local _, folders = file.Find(root .. "*", "LUA")

    for i = 1, #folders do
        if SERVER then
            for k, file in SortedPairs(file.Find(root .. folders[i] .. "/sv*.lua", "LUA")) do
                include(root .. folders[i] .. "/" .. file)
            end
        end

        for k, file in SortedPairs(file.Find(root .. folders[i] .. "/sh*.lua", "LUA")) do
            if SERVER then
                AddCSLuaFile(root .. folders[i] .. "/" .. file)
                include(root .. folders[i] .. "/" .. file)
            else
                include(root .. folders[i] .. "/" .. file)
            end
        end

        for k, file in SortedPairs(file.Find(root .. folders[i] .. "/cl*.lua", "LUA")) do
            if SERVER then
                AddCSLuaFile(root .. folders[i] .. "/" .. file)
            else
                include(root .. folders[i] .. "/" .. file)
            end
        end
    end
end

IncludeFiles( GM.FolderName .. "/gamemode/modules/" )

function GM:PlayerDeath(ply, inflictor, attacker)
    -- Don't spawn for at least 2 seconds
    ply.NextSpawnTime = CurTime() + 2
    ply.DeathTime = CurTime()

    if (IsValid(attacker) and attacker:GetClass() == "trigger_hurt") then
        attacker = ply
    end

    if (IsValid(attacker) and attacker:IsVehicle() and IsValid(attacker:GetDriver())) then
        attacker = attacker:GetDriver()
    end

    if (not IsValid(inflictor) and IsValid(attacker)) then
        inflictor = attacker
    end

    if (IsValid(inflictor) and inflictor == attacker and (inflictor:IsPlayer() or inflictor:IsNPC())) then
        inflictor = inflictor:GetActiveWeapon()

        if (not IsValid(inflictor)) then
            inflictor = attacker
        end
    end

    if (attacker == ply) then
        net.Start("PlayerKilledSelf")
        net.WriteEntity(ply)
        net.Broadcast()
        MsgAll(attacker:Nick() .. " suicided!\n")

        return
    end

    if (attacker:IsPlayer()) then
        if attacker:GetJobTable().Regiment == "Event" or attacker:GetJobTable().Regiment == "Event2" then return end
        net.Start("PlayerKilledByPlayer")
        net.WriteEntity(ply)
        net.WriteString(inflictor:GetClass())
        net.WriteEntity(attacker)
        net.Broadcast()
        MsgAll(attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n")

        return
    end

    net.Start("PlayerKilled")
    net.WriteEntity(ply)
    net.WriteString(inflictor:GetClass())
    net.WriteString(attacker:GetClass())
    net.Broadcast()
    MsgAll(ply:Nick() .. " was killed by " .. attacker:GetClass() .. "\n")
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
    ply:CreateRagdoll()
    ply:AddDeaths(1)
end

function GM:OnNPCKilled(npc, attacker, inflictor)
    if attacker:IsPlayer() then
        attacker:AddFrags(1)
    end
end

if CLIENT then
    hook.Add("InitPostEntity", "MakeMenus", function()
        timer.Simple(15,function()
            F4Menu()
            PromotionMenu()
        end)
    end)

    hook.Add("ChatText", "joinleavefuckoff", function(index, name, text, typ)
        if (typ == "joinleave") then return true end
    end)
end

function GM:PlayerSwitchFlashlight(ply, SwitchOn)
    return true
end