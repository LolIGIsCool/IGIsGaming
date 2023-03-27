--[[Local Database]]
require("mysqloo")
include("sv_mysqloolib.lua")
ig_fwk = {}
ig_fwk_db = mysqloo.CreateDatabase() -- IP to connect to the database server with. -- User to connect to the database with. -- Password to connect to the database with. -- Database to connect too, make sure this is created. -- Port, if you're not sure what it is, most likely it's the default 3306.

--ig_fwk_db:connect()
ig_fwk.coninfo = {
    connected = false, -- Do not Modify
    conAttempts = 1, -- Do not Modify
    conRefreshRate = 180, -- Changes the speed at which the mysqloo refreshes
    refreshOn = true -- Whether or not the database refresh is on or not
}

ig_fwk.debug = {
    debugMode = false -- Is Debug mode on?
}

ig_fwk.headermsg = {
    dbcont = "[ IG_DATABASE ] ",
    dberror = "[ IG_DATABASE ] Error: "
}

ig_fwk.pmsg = {
    dbcon = "///////////////////////////////\n//\n//    " .. ig_fwk.headermsg.dbcont .. "\n//    LOCAL Database has connected\n//\n///////////////////////////////\n",
    dbfail = "///////////////////////////////\n//\n//    " .. ig_fwk.headermsg.dberror .. "\n//    LOCAL Database has failed to connect!\n//\n///////////////////////////////\n"
}

function ig_fwk_db:onConnected()
    ig_fwk.coninfo.connected = true
    print(ig_fwk.pmsg.dbcon)

    if ig_fwk.coninfo.connected then
        print(ig_fwk.headermsg.dbcont .. "CONNECTED TO LOCAL DATABASE...\n\n")
    end
end

function ig_fwk_db:onConnectionFailed(err)
    ig_fwk.coninfo.connected = false
    print(ig_fwk.pmsg.dbfail)
    print(ig_fwk.headermsg.dberror .. err)
end

--[[External Database]]
ig_fwk_extdb = {}
ig_fwk_extdb_db = mysqloo.CreateDatabase("ip", "username", "password", "table", 3306) -- IP to connect to the database server with. -- User to connect to the database with. -- Password to connect to the database with. -- Database to connect too, make sure this is created. -- Port, if you're not sure what it is, most likely it's the default 3306.

--ig_fwk_extdb_db:connect()
ig_fwk_extdb.coninfo = {
    connected = false, -- Do not Modify
    conAttempts = 1, -- Do not Modify
    conRefreshRate = 180, -- Changes the speed at which the mysqloo refreshes
    refreshOn = true -- Whether or not the database refresh is on or not
}

ig_fwk_extdb.debug = {
    debugMode = false -- Is Debug mode on?
}

ig_fwk_extdb.headermsg = {
    dbcont = "[ IG_DATABASE ] ",
    dberror = "[ IG_DATABASE ] Error: "
}

-- Global Variables
SetGlobalBool("refreshOn", ig_fwk_extdb.coninfo.refreshOn)

ig_fwk_extdb.pmsg = {
    dbcon = "///////////////////////////////\n//\n//    " .. ig_fwk_extdb.headermsg.dbcont .. "\n//    External Database has connected\n//\n///////////////////////////////\n",
    dbfail = "///////////////////////////////\n//\n//    " .. ig_fwk_extdb.headermsg.dberror .. "\n//    External Database has failed to connect!\n//\n///////////////////////////////\n"
}

function ig_fwk_extdb_db:onConnected()
    ig_fwk_extdb.coninfo.connected = true
    print(ig_fwk_extdb.pmsg.dbcon)

    if ig_fwk_extdb.coninfo.connected then
        print(ig_fwk_extdb.headermsg.dbcont .. "Server has been restarted, updating player online conditions if there are players on the server...\n\n")
        local steamid64
        local onlinestatus = "online"

        ig_fwk_extdb_db:PrepareQuery("SELECT * FROM p_data WHERE p_onlinestatus = ?", {onlinestatus}, function(query, status, data)
            if ig_fwk_extdb.debug.debugMode then
                PrintTable(data)
                print("\n")
            end

            for _, info in pairs(data) do
                local flag = false

                for k, v in pairs(player.GetAll()) do
                    if info.p_steamid == v:SteamID() then
                        flag = true
                    end
                end

                if ig_fwk_extdb.debug.debugMode and not flag then
                    print(ig_fwk_extdb.headermsg.dbcont .. "[ " .. info.p_name .. " " .. info.p_steamid .. " ] Status has been set to Offline")
                end

                steamid64 = info.p_steamid64
                local lastonline = os.date("%H:%M:%S - %d/%m/%Y", os.time())
                onlinestatus = "offline"

                if not flag then
                    ig_fwk_extdb_db:PrepareQuery("UPDATE p_data SET p_lastonline = ?, p_onlinestatus = ? WHERE p_steamid64 = ?", {lastonline, onlinestatus, steamid64})
                end
            end
        end)
    end
end

function ig_fwk_extdb_db:onConnectionFailed(err)
    ig_fwk_extdb.coninfo.connected = false
    print(ig_fwk_extdb.pmsg.dbfail)
    print(ig_fwk_extdb.headermsg.dberror .. err)
end

local function p_data_verify(ply)
    if ig_fwk_extdb.coninfo.connected and ply:IsValid() and ply:IsPlayer() and not ply:IsBot() then
        local steamid64 = ply:SteamID64()

        ig_fwk_extdb_db:PrepareQuery("SELECT * FROM p_data WHERE p_steamid64 = ?", {steamid64}, function(query, status, data)
            local steamid = ply:SteamID()
            local name = ply:Name()
            local steamname = ply:OldNick()
            local steamimage = ply.MooseSteamImage or "https://steamuserimages-a.akamaihd.net/ugc/885384897182110030/F095539864AC9E94AE5236E04C8CA7C2725BCEFF/"
            local usergroup = string.lower(ply:GetUserGroup())
            local regiment = ply:GetRegiment()
            local rank = ""

            if ply:GetRankName() == "" then
                rank = ply:Name()
            else
                rank = ply:GetRankName()
            end

            local lastonline = "Currently Online"
            local onlinestatus = "online"

            if ig_fwk_extdb.debug.debugMode then
                print(ig_fwk_extdb.headermsg.dbcont .. "[ " .. name .. " " .. steamid .. " ] Joined and has had their data refreshed")
            end

            ig_fwk_extdb_db:PrepareQuery("REPLACE into p_data (p_steamid64, p_steamid, p_steamname, p_steamimage, p_name, p_usergroup, p_regiment, p_rank, p_lastonline, p_onlinestatus) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", {steamid64, steamid, steamname, steamimage, name, usergroup, regiment, rank, lastonline, onlinestatus})
        end)
    else
        if not ig_fwk_extdb.coninfo.connected then
            print(ig_fwk_extdb.headermsg.dberror .. "Cannot send " .. ply:SteamID() .. " to the Database due to it not being connected!")
        end
    end
end

hook.Add("PlayerInitialSpawn", "p_data_con_send_query", p_data_verify)

local function p_data_send(ply, val)
    if ig_fwk_extdb.coninfo.connected and ply:IsValid() and ply:IsPlayer() and not ply:IsBot() and ply.igdata and ply.igdata["regiment"] then
        local steamid64 = ply:SteamID64()
        local steamid = ply:SteamID()
        local steamname = ply:OldNick()
        local steamimage = ply.MooseSteamImage or "https://steamuserimages-a.akamaihd.net/ugc/885384897182110030/F095539864AC9E94AE5236E04C8CA7C2725BCEFF/"
        local name = ply:Name()
        local usergroup = string.lower(ply:GetUserGroup())
        local regiment = ply:GetRegiment()
        local rank = ""

        if ply:GetJobTable().Name == "" then
            rank = ply:Name()
        else
            rank = ply:GetJobTable().Name
        end

        local lastonline = "Currently Online"

        if string.lower(val) == "offline" then
            lastonline = os.date("%H:%M:%S - %d/%m/%Y", os.time())
        end

        local onlinestatus = val

        if ig_fwk_extdb.debug.debugMode then
            print(ig_fwk_extdb.headermsg.dbcont .. "Refreshed: [ " .. name .. " " .. steamid .. " ]")
        end

        ig_fwk_extdb_db:PrepareQuery("REPLACE into p_data (p_steamid64, p_steamid, p_steamname, p_steamimage, p_name, p_usergroup, p_regiment, p_rank, p_lastonline, p_onlinestatus) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", {steamid64, steamid, steamname, steamimage, name, usergroup, regiment, rank, lastonline, onlinestatus})
    else
        if not ig_fwk_extdb.coninfo.connected then
            print(ig_fwk_extdb.headermsg.dberror .. "Cannot send " .. ply:SteamID() .. " to the Database due to it not being connected!")
        end
    end
end

local function p_data_dc(ply)
    p_data_send(ply, "offline")
end

hook.Add("PlayerDisconnected", "p_data_discon_send_query", p_data_dc)

concommand.Add("refreshToggle", function(ply, cmd, args)
    if ig_fwk_extdb.coninfo.connected and ply:IsValid() and ply:IsPlayer() and not ply:IsBot() then
        if not ply:IsSuperAdmin() then return end

        if not timer.Exists("refresh_info") then
            print(ig_fwk_extdb.headermsg.dberror .. "Refresh timer does not exist!")

            return
        end

        if GetGlobalBool("refreshOn", true) then
            SetGlobalBool("refreshOn", false)
            timer.Stop("refresh_info")
            ply:ChatPrint(ig_fwk_extdb.headermsg.dbcont .. "Database refresh has been turned off!")
            print(ig_fwk_extdb.headermsg.dbcont .. "Database refresh has been turned off!")
        elseif not GetGlobalBool("refreshOn", true) then
            SetGlobalBool("refreshOn", true)
            timer.Start("refresh_info")
            ply:ChatPrint(ig_fwk_extdb.headermsg.dbcont .. "Database refresh has been turned on!")
            print(ig_fwk_extdb.headermsg.dbcont .. "Database refresh has been turned on!")
        end
    else
        ply:ChatPrint(ig_fwk_extdb.pmsg.dbfail)
    end
end)

local function p_data_refresh()
    if player.GetCount() <= 0 then
        print("\n\n" .. ig_fwk_extdb.headermsg.dbcont .. "Not refreshing player data as there are no players.\n\n")

        return
    end

    local count = 0
    print("\n\n" .. ig_fwk_extdb.headermsg.dbcont .. "Player Data is being refreshed, stand by while the data is refreshed\n\n")

    for k, v in pairs(player.GetAll()) do
        p_data_send(v, "online")
        count = count + 1
    end

    print("\n\n" .. ig_fwk_extdb.headermsg.dbcont .. "Has refreshed " .. count .. " Player records\n\n")
end

concommand.Add("manualrefreshdb", p_data_refresh)

local function init_timer()
    if GetGlobalBool("refreshOn", true) then
        timer.Create("refresh_info", ig_fwk_extdb.coninfo.conRefreshRate, 0, p_data_refresh)
    end
end

hook.Add("Initialize", "refresh", init_timer)