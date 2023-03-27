if SERVER then
    local function HandleSharedPlayer(ply, lenderSteamID)
        print(string.format("FamilySharing: %s | %s has been lent Garry's Mod by %s", ply:Nick(), ply:SteamID(), lenderSteamID))
        local famshare = "User " .. ply:Nick() .. "(" .. ply:SteamID() .. ") has been lent GMOD by " .. lenderSteamID .. "\n"
        file.Append("familyshare.txt", famshare)
        local Timestamp = os.time()
        local TimeString = os.date("%H:%M:%S - %d/%m/%Y", Timestamp)
        local lenderSteamID64 = util.SteamIDTo64(lenderSteamID)

        if gBan.Bans[lenderSteamID64] then
            gBan:PlayerUnban(nil, lenderSteamID)

            timer.Simple(1, function()
                local altaccount = "User " .. ply:Nick() .. "(" .. ply:SteamID() .. ") has been auto-banned for Alting"
                RunConsoleCommand("ulx", "asay", tostring(altaccount))
                gBan:PlayerBanID(nil, lenderSteamID, 0, "Automatically updated for bypassing a ban. [" .. ply:SteamID() .. "]", false)
                gBan:PlayerBanID(nil, ply:SteamID(), 0, "Automatically banned for bypassing a ban. [" .. lenderSteamID .. "]", false)
            end)
        else
            local famshare = "User " .. ply:Nick() .. "(" .. ply:SteamID() .. ") has been lent GMOD by " .. lenderSteamID .. " (main account not banned)"
            RunConsoleCommand("ulx", "asay", tostring(famshare))
        end
    end

    local function CheckFamilySharing(ply)
        local lender = ply:OwnerSteamID64()
        if lender ~= ply:SteamID64() then
            HandleSharedPlayer(ply, util.SteamIDFrom64(lender))
        end
    end

    hook.Add("PlayerAuthed", "CheckFamilySharing", CheckFamilySharing)

    concommand.Add("checkeveryonefshare", function()
        RunConsoleCommand("ulx", "asay", "[Kumo-Mass-Familyshare] Results:")

        for k, v in pairs(player.GetAll()) do
            CheckFamilySharing(v)
        end
    end)
end