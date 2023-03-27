if SERVER then
    util.AddNetworkString("regimentlistmenu")
end

function GetRegimentsPlayers(regiment,ply)
    if regiment == "501st Vader's Fist" then
        ig_fwk_db:PrepareQuery("SELECT * FROM igdata WHERE regiment LIKE 'Vader%", {}, function(lol, lol1, data)
            local actualregimentplayers = {}

            for k, v in pairs(data) do
                table.insert(actualregimentplayers, {v.name, v.steamid64, TeamTable[tostring(v.regiment)][tonumber(v.rank)].RealName, v.rank})
            end

            local compressedTbl = util.Compress(util.TableToJSON(actualregimentplayers))
            local size = string.len(compressedTbl)
            net.Start("regimentlistmenu")
            net.WriteUInt(size, 32)
            net.WriteData(compressedTbl, size)
            net.Send(ply)
        end)
    else
        ig_fwk_db:PrepareQuery("SELECT * FROM igdata WHERE regiment='" .. regiment .. "'", {}, function(lol, lol1, data)
            local actualregimentplayers = {}

            for k, v in pairs(data) do
                table.insert(actualregimentplayers, {v.name, v.steamid64, TeamTable[tostring(v.regiment)][tonumber(v.rank)].RealName, v.rank})
            end

            local compressedTbl = util.Compress(util.TableToJSON(actualregimentplayers))
            local size = string.len(compressedTbl)
            net.Start("regimentlistmenu")
            net.WriteUInt(size, 32)
            net.WriteData(compressedTbl, size)
            net.Send(ply)
        end)
    end
end

function ulx.regimentlist(ply)
    if ply:IsAdmin() or ply:GetRank() >= 10 then
        GetRegimentsPlayers(ply:GetRegiment(),ply)
    end
end

local regimentlist = ulx.command("Imperial Gaming", "ulx regimentlist", ulx.regimentlist, "!regimentlist")
regimentlist:defaultAccess(ULib.ACCESS_ADMIN)
regimentlist:help("Regiment List Menu")