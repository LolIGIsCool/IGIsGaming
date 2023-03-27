if (SERVER) then
    util.AddNetworkString("hidePLenhance_setpilot")

    local function up_createLicenseTable()
        ig_fwk_db:PrepareQuery("CREATE TABLE IF NOT EXISTS hidelicences ( steamid TEXT NOT NULL, pilotlvl TEXT, PRIMARY KEY(steamid(255)));")
    end

    function setLicenseString_spawn(ply)
        local steamid = ply:SteamID()
    
        ig_fwk_db:PrepareQuery("SELECT pilotlvl FROM hidelicences WHERE steamid = " .. sql.SQLStr(steamid) .. " LIMIT 1", {}, function(q1, q2, data)
            if not data or not data[1] or not data[1].pilotlvl then
                ply:SetNWString("license", "NONE")
                return
            end
            ply:SetNWString("license", data[1].pilotlvl)
        end)
    end
    
    function setPilotLevel(len, ply)
        if not ((ply:GetRegiment() == "Imperial Navy") or (ply:GetRegiment() == "Imperial High Command") or (ply:GetRegiment() == "Imperial Starfighter Corps") or (ply:IsAdmin())) then return end
        local level = net.ReadString()
        if not level then return end
        local plyr = player.GetBySteamID(net.ReadString())
        if not plyr or not plyr:IsPlayer() then return end
        local plycurlicense = plyr:GetNWString("license")

        if level == plycurlicense then
            ply:ChatPrint("That user already has those licences!")
            return
        end
    
        -- lol wth is this
        --[[if level == "RTL" or level == "IPL" or level == "SL" then
            if plycurlicense == "NONE" then
                ig_fwk_db:PrepareQuery("REPLACE INTO licenses ( steamid, pilotlvl ) VALUES ( " .. sql.SQLStr(plyr:SteamID()) .. ", " .. sql.SQLStr(level) .. " )")
                plyr:SetNWString("license", level)
            else
                ig_fwk_db:PrepareQuery("REPLACE INTO licenses ( steamid, pilotlvl ) VALUES ( " .. sql.SQLStr(plyr:SteamID()) .. ", " .. sql.SQLStr(plycurlicense .. " " .. level) .. " )")
                plyr:SetNWString("license", plycurlicense .. " " .. level)
            end
        else
            ig_fwk_db:PrepareQuery("REPLACE INTO licenses ( steamid, pilotlvl ) VALUES ( " .. sql.SQLStr(plyr:SteamID()) .. ", " .. sql.SQLStr(level) .. " )")
            plyr:SetNWString("license", level)
        end]]

        ig_fwk_db:PrepareQuery("REPLACE INTO hidelicences ( steamid, pilotlvl ) VALUES ( " .. sql.SQLStr(plyr:SteamID()) .. ", " .. sql.SQLStr(level) .. " )")
        plyr:SetNWString("license", level)
    end
    hook.Add("PlayerInitialSpawn", "SetLicenceString_v", setLicenseString_spawn)
    net.Receive("hidePLenhance_setpilot", setPilotLevel)
    hook.Add("PostGamemodeLoaded", "createlicense_v", up_createLicenseTable)
end
