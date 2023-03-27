util.AddNetworkString("blacklistmenu")
util.AddNetworkString("setplayerblacklist")

local function createblacklisttable()
    if (not sql.TableExists("igblacklist")) then
        sql.Query("CREATE TABLE IF NOT EXISTS igblacklist ( steamid TEXT NOT NULL PRIMARY KEY, blacklisted TEXT );")
    end
end

function SetBlacklistOnSpawn(ply)
    local steamid = ply:SteamID()
    blacklisttxt = sql.QueryValue("SELECT blacklisted FROM igblacklist WHERE steamid = " .. sql.SQLStr(steamid) .. " LIMIT 1")
    ply:SetNWString("blacklisted", blacklisttxt)
    blacklisttxt = sql.Query("SELECT blacklisted FROM igblacklist WHERE steamid = " .. sql.SQLStr(steamid) .. " LIMIT 1")

    if not (blacklisttxt) then
        settolvl = "false"
        sql.Query("REPLACE INTO igblacklist ( steamid, blacklisted ) VALUES ( " .. sql.SQLStr(steamid) .. ", " .. sql.SQLStr(settolvl) .. " )")
        ply:SetNWString("blacklisted", settolvl)
    end
end

function SetPlayersBLACKLIST(len, ply)
    if ply:IsAdmin() then
        settolvl = net.ReadString()
        selectedsteamid = net.ReadString()

        if settolvl == "true" then
            player101 = player.GetBySteamID(selectedsteamid)
            if not player101 then return end

            if settolvl == "true" and player101:GetNWString("blacklisted") == "true" then
                ply:ChatPrint(player101:Nick() .. " is already blacklisted from events")

                return
            end

            ulx.fancyLogAdmin(ply, "#A has blacklisted #T from events.", player101)
            sql.Query("REPLACE INTO igblacklist ( steamid, blacklisted ) VALUES ( " .. sql.SQLStr(selectedsteamid) .. ", " .. sql.SQLStr(settolvl) .. " )")
            blacklisttxt = sql.QueryValue("SELECT blacklisted FROM igblacklist WHERE steamid = " .. sql.SQLStr(selectedsteamid) .. " LIMIT 1")
            player101:SetNWString("blacklisted", blacklisttxt)
            ply:ChatPrint(player101:Nick() .. " has been blacklisted from events.")
            player101:ChatPrint("You have been blacklisted from events, ask the event master what you did wrong but do not argue.")
        elseif settolvl == "false" then
            player101 = player.GetBySteamID(selectedsteamid)
            if not player101 then return end

            if settolvl == "false" and player101:GetNWString("blacklisted") == "false" then
                ply:ChatPrint(player101:Nick() .. " is not blacklisted from events")

                return
            end

            ulx.fancyLogAdmin(ply, "#A has unblacklisted #T from events.", player101)
            sql.Query("REPLACE INTO igblacklist ( steamid, blacklisted ) VALUES ( " .. sql.SQLStr(selectedsteamid) .. ", " .. sql.SQLStr(settolvl) .. " )")
            blacklisttxt = sql.QueryValue("SELECT blacklisted FROM igblacklist WHERE steamid = " .. sql.SQLStr(selectedsteamid) .. " LIMIT 1")
            player101:SetNWString("blacklisted", blacklisttxt)
            ply:ChatPrint(player101:Nick() .. " has been unblacklisted from events.")
            player101:ChatPrint("You have been unblacklisted from events, do not stuff up again.")
        end
    end
end

net.Receive("setplayerblacklist", SetPlayersBLACKLIST)
hook.Add("PlayerInitialSpawn", "SettheBlacklistonSpawn", SetBlacklistOnSpawn)
createblacklisttable()