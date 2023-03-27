------------------------------ SubscribedAddons ------------------------------
local serversaddons = {}

if SERVER then
    util.AddNetworkString("IGSubbedAddons")
    util.AddNetworkString("IGServerAddons")

    timer.Simple(10, function()
        http.Fetch("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. 1846649268, function(page)
            for k in page:gmatch([[<div id="sharedfile_(.-)" class="collectionItem">]]) do
                table.insert(serversaddons, 1, k)
            end
        end)
    end)

    net.Receive("IGServerAddons", function(len, ply)
        local amount = net.ReadString()
        local caller = net.ReadEntity()
        if not caller:IsPlayer() then return end
        local serverd = net.ReadBool()
        local player = ply:Nick()

        if not ply.realsubcheck then
            RunConsoleCommand("ulx", "asay", "!!!!!", ply:Nick(), "(", ply:SteamID(), ")", "exploit", "alarm", "-", "please", "monitor", "the", "individual", "for", "suspicious", "behaviour")

            return
        end

        ply.realsubcheck = false

        if (serverd) then
            if (caller) and (player) then
                if (amount) or amount > 1 then
                    caller:ChatPrint(player .. " is subscribed to " .. amount .. "/" .. #serversaddons .. " addons")
                else
                    caller:ChatPrint(player .. " is not subscribed to any addons")
                end
            end
        else
            if (caller) then
                if (amount) and (tonumber(amount)) and tonumber(amount) < #serversaddons then
                    caller:ChatPrint("Your Imperial Gaming content is outdated, subscribe to new content by typing !content in chat")
                else
                    caller:ChatPrint("Your Imperial Gaming content is up to date!")
                end
            end
        end
    end)

    hook.Add("PlayerInitialSpawn", "CheckAddonUpdated", function(ply)
        timer.Simple(2, function()
            ply.realsubcheck = true
            net.Start("IGSubbedAddons")
            net.WriteTable(serversaddons)
            net.WriteEntity(ply)
            net.WriteBool(false)
            net.Send(ply)
        end)
    end)
end

if CLIENT then
    net.Receive("IGSubbedAddons", function()
        local rcvedaddons = net.ReadTable()
        local caller = net.ReadEntity()
        local serverd = net.ReadBool()
        local clientaddons = {}

        for k, v in pairs(rcvedaddons) do
            if steamworks.IsSubscribed(v) then
                table.insert(clientaddons, 1, v)
            end
        end

        net.Start("IGServerAddons")
        net.WriteString(tostring(#clientaddons))
        net.WriteEntity(caller)
        net.WriteBool(serverd)
        net.SendToServer()
    end)
end

function ulx.subscriptions(calling_ply, target_ply)
    if not isnumber(calling_ply.subscriptionscd) then
        calling_ply.subscriptionscd = 0
    end
    if SERVER then
		print(calling_ply:GetRank())
        if calling_ply:GetRank() >= 4 or calling_ply:GetJobTable().Clearance == "2" and calling_ply.subscriptionscd <= CurTime() or calling_ply:IsAdmin() and calling_ply.subscriptionscd <= CurTime() or calling_ply:GetRegiment() == "Legion Commander" and calling_ply.subscriptionscd <= CurTime() or calling_ply:GetRegiment() == "Imperial High Command" and calling_ply.subscriptionscd <= CurTime() then
            calling_ply.subscriptionscd = CurTime() + 30
            target_ply.realsubcheck = true
            net.Start("IGSubbedAddons")
            net.WriteTable(serversaddons)
            net.WriteEntity(calling_ply)
            net.WriteBool(true)
            net.Send(target_ply)
        elseif calling_ply.subscriptionscd >= CurTime() then
            calling_ply:ChatPrint("There is a 30 second cooldown to prevent abuse. Please wait!")
        else
            calling_ply:ChatPrint("You do not have access to this command, You must be a CPL+")
        end
    end
end

local subscriptions = ulx.command("Imperial Gaming", "ulx addons", ulx.subscriptions, "!addons")
subscriptions:addParam{type = ULib.cmds.PlayerArg}
subscriptions:defaultAccess(ULib.ACCESS_ALL)
subscriptions:help("See how many addons a player is subscribed to.")