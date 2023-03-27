util.AddNetworkString("NetworkHalloweenPlayers")
util.AddNetworkString("JoinHalloweenTeam")
IGHALLOWEEN = IGHALLOWEEN or {
    ["Spooky Skeletons"] = {
        Players = {},
        PCount = 0,
        Points = 0
    },
    ["Boo! Crew"] = {
        Players = {},
        PCount = 0,
        Points = 0
    },
    ["Scream Team"] = {
        Players = {},
        PCount = 0,
        Points = 0
    },
    SECRETFOUND = false,
    ENDED = false,
    SECRETFOUNDBY = "NONE"
}
IGHALLOWEEN.INDIVIDUAL = IGHALLOWEEN.INDIVIDUAL or {
    ["Spooky Skeletons"] = {
        Players = {}
    },
    ["Boo! Crew"] = {
        Players = {}
    },
    ["Scream Team"] = {
        Players = {}
    }
}

if file.Exists("halloweensaver.txt", "DATA") then
    IGHALLOWEEN = util.JSONToTable(file.Read("halloweensaver.txt", "DATA"))
else
    file.Write("halloweensaver.txt", util.TableToJSON(IGHALLOWEEN))
end

function UpdateHalloTable()
    file.Write("halloweensaver.txt", util.TableToJSON(IGHALLOWEEN))
end

function IGHALLOWEEN:CheckPlayers(team)
    if IGHALLOWEEN.ENDED then return end
    local team1count = table.Count(IGHALLOWEEN["Spooky Skeletons"].Players)
    local team2count = table.Count(IGHALLOWEEN["Boo! Crew"].Players)
    local team3count = table.Count(IGHALLOWEEN["Scream Team"].Players)

    if team == "Spooky Skeletons" then
        if (team1count - team2count) >= 3 then return false end
        if (team1count - team3count) >= 3 then return false end
    elseif team == "Boo! Crew" then
        if (team2count - team3count) >= 3 then return false end
        if (team2count - team1count) >= 3 then return false end
    elseif team == "Scream Team" then
        if (team3count - team1count) >= 3 then return false end
        if (team3count - team2count) >= 3 then return false end
    end

    return true
end

timer.Create("UpdateWebsite", 120, 0, function()
    local team1count = table.Count(IGHALLOWEEN["Spooky Skeletons"].Players)
    local team2count = table.Count(IGHALLOWEEN["Boo! Crew"].Players)
    local team3count = table.Count(IGHALLOWEEN["Scream Team"].Players)
    http.Post( "https://imperialgaming.net/halloteam/post.php", { a = util.TableToJSON({team1count,team2count,team3count,IGHALLOWEEN.SECRETFOUND}) },
    function( result )
        if result then
        end
    end,
    function( failed )
        print( failed )
    end )
end)

function NetworkHalloweenPlayers(broadcast,ply)
    if IGHALLOWEEN.ENDED then return end
    if not broadcast then
        net.Start("NetworkHalloweenPlayers")
        net.WriteUInt(IGHALLOWEEN["Spooky Skeletons"].PCount,16)
        net.WriteUInt(IGHALLOWEEN["Boo! Crew"].PCount,16)
        net.WriteUInt(IGHALLOWEEN["Scream Team"].PCount,16)
        net.Send(ply)
    else
        net.Start("NetworkHalloweenPlayers")
        net.WriteUInt(IGHALLOWEEN["Spooky Skeletons"].PCount,16)
        net.WriteUInt(IGHALLOWEEN["Boo! Crew"].PCount,16)
        net.WriteUInt(IGHALLOWEEN["Scream Team"].PCount,16)
        net.Broadcast()
    end
end

util.AddNetworkString("JoinHalloweenTeam")
util.AddNetworkString("OpenHalloweenChooser")


function IGHALLOWEEN:UpdatePoints(team, points, ply, reason)
    if IGHALLOWEEN.ENDED then return end
    if ply:GetNWString("halloweenteam", "none") == "none" then
        ply:ChatPrint("You could've earnt halloween points for a team, but you aren't in one, visit the cauldron on the third floor to join one!")

        return
    end
    ply:QUEST_SYSTEM_ChatNotify("HALLOWEEN", "You have earnt "..points.." points for your team for "..reason.."!")

    IGHALLOWEEN[team].Points = IGHALLOWEEN[team].Points + points

    if ply then
        IGHALLOWEEN.INDIVIDUAL[team].Players[ply:SteamID()].Points = IGHALLOWEEN.INDIVIDUAL[team].Players[ply:SteamID()].Points + points
    end

    UpdateHalloTable()
end

net.Receive("JoinHalloweenTeam", function(len, ply)
    if IGHALLOWEEN.ENDED then return end
    if ply:GetNWString("halloweenteam", "none") ~= "none" then
        ply:ChatPrint("You are already on a team!")

        return
    end

    local team = net.ReadString()

    if team ~= "Boo! Crew" and team ~= "Spooky Skeletons" and team ~= "Scream Team" then
        ply:ChatPrint("Team does not exist!")

        return
    end

    if not (IGHALLOWEEN:CheckPlayers(team)) then
        ply:ChatPrint("For balancing sake you are not allowed to join this team as there is too many players on it compared to others!")

        return
    end
    table.insert(IGHALLOWEEN[team].Players,ply:SteamID())
    IGHALLOWEEN[team].PCount = IGHALLOWEEN[team].PCount + 1
    IGHALLOWEEN.INDIVIDUAL[team].Players[ply:SteamID()] = {}
    IGHALLOWEEN.INDIVIDUAL[team].Players[ply:SteamID()].Points = 0
    UpdateHalloTable()
    NetworkHalloweenPlayers(true)
    ply:ChatPrint("You have joined " .. team .. " have fun!")
    ply:SetNWString("halloweenteam", team)
end)

hook.Add("PlayerInitialSpawn", "SetHalloteam", function(ply)
    if IGHALLOWEEN.ENDED then return end
    if table.HasValue(IGHALLOWEEN["Spooky Skeletons"].Players, ply:SteamID()) then
        ply:SetNWString("halloweenteam", "Spooky Skeletons")
    elseif table.HasValue(IGHALLOWEEN["Boo! Crew"].Players, ply:SteamID()) then
        ply:SetNWString("halloweenteam", "Boo! Crew")
    elseif table.HasValue(IGHALLOWEEN["Scream Team"].Players, ply:SteamID()) then
        ply:SetNWString("halloweenteam", "Scream Team")
    end
    NetworkHalloweenPlayers(false,ply)
end)

--Spawning Halloween Items
local spawntable = {["rp_stardestroyer_v2_5_inf"] = {Vector(-2071.61,822.94,-4863.97),Vector(-2018.77,17.88,-4863.97),Vector(-2202.36,-1667.77,-4863.97),Vector(-510.51,-1732.55,-4863.97),Vector(-26.09,-1772.74,-4863.97),Vector(-319.14,-1722.17,-5562.23),Vector(2124.46,-1811.06,-5567.97),Vector(4109.74,-1381.38,-5567.97),Vector(3895.96,-806.52,-5375.97),Vector(4620.7,-843.64,-5375.97),Vector(5645.64,-802.07,-5375.97),Vector(5642.36,923.82,-5375.97),Vector(4805.15,1075.03,-5375.97),Vector(70.82,-2131.56,-5567.97),Vector(-725.26,-1693.21,-5759.97),Vector(-1368.04,-1738.75,-6015.97),Vector(-2296.65,-1748.88,-6015.97),Vector(-1797.4,-811.98,-6015.97),Vector(-2716.95,-837.08,-6015.97),Vector(-2813.15,-1710.21,-6015.97),Vector(-2781.41,609.58,-6015.97),Vector(-2321.02,842.77,-6015.97),Vector(-1765.1,835.7,-6006.76),Vector(-2045.73,-61.75,-6015.97),Vector(-2057.22,-1753.78,-6015.97),Vector(-2057.22,-1753.66,-6015.97),Vector(5381.87,-1386.07,-5567.97),Vector(4384.2,-1394.78,-5567.97),Vector(4112.62,881.81,-5375.97),Vector(4471.82,885.54,-5567.97),Vector(-2829.95,-2388.16,-4863.97),Vector(-2832.42,1757.25,-4863.97),Vector(4549.82,-2253.49,-5375.97),Vector(2015.17,-2137.97,-5375.97),Vector(-2063.4,-562.92,-5439.97),Vector(-2408.82,-813.47,-5439.97),Vector(-1714.73,-842.42,-5439.97),Vector(-2065.03,-851.96,-6015.97),Vector(7219.19,452.24,-5375.97),Vector(7287.01,-424.48,-5375.97)},["rp_titan_base_bananakin_ig"] = {Vector(6021.98,6229.53,-13583.56),Vector(3861.28,6229.49,-13583.56),Vector(3879.37,9441.20,-13583.56),Vector(6143.55,9429.20,-13583.56),Vector(4912.09,9761.30,-13652.7),Vector(7488.9,9757.30,-13652.7),Vector(8537.8,9889.7,-13797.7),Vector(9329.9,10034.5,-13795.97),Vector(10354,10027.69,-13874.1),Vector(11080.6,10718.7,-14035.7),Vector(10355.8,11423.7,-13874.97),Vector(10356.3,13395.8,-13395.97),Vector(9321.4,11434.6,-13803.6),Vector(8986.2,11981.4,-13708.5),Vector(7994.5,11996.3,-13630.4),Vector(7269.69,11985.83,-13636.2)},["hfg_starwarsuniverse2_fix"] = {Vector(-13591.77,8612.95,1024.03),Vector(-12966.59,8638.56,1024.03),Vector(-12430.11,8633.86,1024.03),Vector(-12193.43,8632.35,1024.03),Vector(-11621.97,8627.88,1024.03),Vector(-11394.41,8748.73,1024.03),Vector(-11233.32,8989.21,1024.03),Vector(-11267.24,8286.64,1024.03),Vector(-10729.42,8786.49,1024.03),Vector(-10314.27,8722.85,1024.03),Vector(-10449.91,8300.46,1024.03),Vector(-10512.83,7653.89,1024.03),Vector(-10301.3,7407.55,1024.03),Vector(-9955,7221.06,1024.03),Vector(-9773.79,7603.72,1024.03),Vector(-9761,7972.51,1024.03),Vector(-9704.45,8398.16,1024.03),Vector(-9515.15,8637.01,1024.03),Vector(-9177.98,8604.62,1024.03),Vector(-8738.29,8601.03,1024.03),Vector(-8224.36,8634.29,1024.03),Vector(-7701.3,8668.19,1024.03),Vector(-7688.04,9098.91,1024.03),Vector(-8221.52,9091.61,1024.03),Vector(-8676.36,9224.2,1024.03),Vector(-8976.01,9552.29,1024.03),Vector(-9073.76,10055.65,1024.03),Vector(-8720.32,10122.11,1024.03),Vector(-8814.97,10380.85,1024.03),Vector(-9085.76,10535.32,1024.03),Vector(-9022.3,10862.89,1024.03),Vector(-8483.01,10604.36,1024.03),Vector(-8242.38,10522.58,1024.03),Vector(-8177.82,10965.85,1024.03),Vector(-7974.82,11154.72,1024.03),Vector(-7872.15,11372.06,1024.03),Vector(-8770.35,11497.72,1024.03),Vector(-8898.13,12126.56,1024.03),Vector(-8783.78,12418.91,1024.03),Vector(-8750.2,12792.19,1024.03),Vector(-8839.22,13995.27,1024.03),Vector(-8859.29,13888.21,1024.03),Vector(-9307.77,13748.93,1024.03),Vector(-9432.88,13823.57,1024.03),Vector(-9572.66,14137.31,1024.03),Vector(-9877.34,14621.22,1024.03),Vector(-9780.8,14768.67,1024.03),Vector(-10079.97,13396.62,1024.03),Vector(-9991.46,13074.93,1024.03),Vector(-10019.53,12752.33,1024.03),Vector(-10050.81,12386.51,1024.03),Vector(-10341.35,12504.81,1024.03),Vector(-10131.48,12593.18,1024.03),Vector(-10374.4,13443.23,1024.03),Vector(-10727.52,13446.06,1024.03),Vector(-10929.13,13474.52,1024.03),Vector(-10952.85,13802.69,1024.03),Vector(-10834.2,14178.22,1024.03),Vector(-10355.04,14366.96,1024.03),Vector(-10092.04,14657.61,1024.03),Vector(-10868.46,14890.48,1024.03),Vector(-11293.44,15016.87,1024.03),Vector(-11428.71,13849.44,1024.03),Vector(-11501.57,13234.41,1024.03),Vector(-12004.27,13809.71,1024.03),Vector(-12314.01,13276.65,1024.03),Vector(-12395.52,14101.93,1024.03),Vector(-13060.07,13747.48,1024.03),Vector(-12559.04,13627.99,1024.03),Vector(-13368.86,12949.95,1024.03),Vector(-13209.11,12355.1,1024.03),Vector(-14022.62,13105.64,1024.03),Vector(-14183.56,13155.15,1024.03),Vector(-14217.72,13333.49,1024.03),Vector(-14490.53,13351.75,1024.03),Vector(-14872.5,13364.04,1024.03),Vector(-15038.76,13499.51,1024.03),Vector(-14992.44,13732.27,1024.03),Vector(-15075.59,14268.04,1024.03),Vector(-15133.19,14546.08,1024.03),Vector(-14980.31,15110.82,1024.03),Vector(-14751.34,15208.71,1024.03),Vector(-14523.67,15114.23,1024.03),Vector(-14556.52,14807.54,1024.03),Vector(-14189.84,14741.84,1024.03),Vector(-14070.61,10708.89,1024.03),Vector(-14507.95,10636.78,1024.03),Vector(-14880.41,10509.95,1024.03),Vector(-14570.78,9908.26,1024.03),Vector(-14207.01,9706.98,1024.03),Vector(-14563.32,9528.61,1024.03),Vector(-14855.08,9162.21,1024.03),Vector(-14421.94,8965.7,1024.03),Vector(-14150.19,9008.18,1024.03),Vector(-13734.32,9830.14,1024.03),Vector(-13287.09,9933.82,1024.03),Vector(-11078.27,9840.92,1024.03),Vector(-11167.4,9449.25,1024.03),Vector(-11578.39,9746.61,1024.03),Vector(-12214.13,9691.85,1024.03),Vector(-12525.79,9428.58,1024.03),Vector(-12400.69,9422.57,1024.03),Vector(-6338.15,8329.06,1024.03),Vector(-6262.86,7330.06,1024.03),Vector(-6496.86,7464.88,1024.03),Vector(-7401.3,7343.1,1024.03),Vector(-7265.51,7915.47,1024.03),Vector(-7266.11,8454.87,1024.03),Vector(-6985.25,8846.49,1024.03),Vector(-6736.38,9763.37,1024.03),Vector(-6269.87,9757.43,1024.03),Vector(-6752.49,10429.12,1024.03),Vector(-6566.22,11615.2,1024.03),Vector(-6569.64,11789.2,1024.03),Vector(-6436.51,12411.68,1024.03),Vector(-6825.69,12807.87,1024.03),Vector(-6717.97,13410.14,1024.03),Vector(-6690.5,13690.66,1024.03),Vector(-6590.21,14552.57,1024.03),Vector(-5917.97,14533.91,1024.03),Vector(-6739.22,14972.01,1024.03),Vector(-5753.57,14920.01,1024.03),Vector(-5173.28,14720.56,1024.03)}}
local modeltable = {"models/Gibs/HGIBS.mdl","models/Gibs/HGIBS_rib.mdl","models/Gibs/HGIBS_scapula.mdl","models/Gibs/HGIBS_spine.mdl","models/props_c17/doll01.mdl","models/props_lab/huladoll.mdl","models/maxofs2d/balloon_gman.mdl","models/maxofs2d/companion_doll.mdl"}

timer.Create("SpawnHalloitems", 1200, 0, function()
    if IGHALLOWEEN.ENDED then return end
    if not spawntable[game.GetMap()] then return end
    local vecspawnpositions = table.Copy(spawntable[game.GetMap()])
    if not GetGlobalBool("diseasesystemactive") then return end
    if table.Count(ents.FindByClass("kumo_cauldron")) <= 0 then return end
    if globaldefconn <= 4 then return end
    if player.GetCount() < 15 then return end

    if table.Count(ents.FindByClass("kumo_spookitem")) >= 5 then
        print("Too many items, not spawning")

        return
    end

    for i = 1, math.random(3, 6) do
        timer.Simple(math.random(1, 30), function()
            local vecPos, vecPos2 = table.Random(vecspawnpositions)
            table.RemoveByValue(vecspawnpositions, vecPos)
            local thepresent = ents.Create("kumo_spookitem")
            thepresent:SetPos(vecPos + Vector(0, 0, 25))
            local model = table.Random(modeltable)
            thepresent.SetModelOK = model
            thepresent:Spawn()
            thepresent:DropToFloor()
            thepresent:SetModel(model)

            timer.Create("despawn" .. thepresent:EntIndex(), 2000, 1, function()
                if thepresent and isentity(thepresent) then
                    thepresent:Remove()
                    timer.Remove("despawn" .. thepresent:EntIndex())
                end
            end)
        end)
    end
end)

concommand.Add("forcehallospawn", function(ply)
    if not ply:IsSuperAdmin() then return end
    if not spawntable[game.GetMap()] then return end
    local vecspawnpositions = table.Copy(spawntable[game.GetMap()])
    if not GetGlobalBool("diseasesystemactive") then return end
    if table.Count(ents.FindByClass("kumo_cauldron")) <= 0 then return end
    if globaldefconn <= 4 then return end
    if player.GetCount() < 15 then return end

    if table.Count(ents.FindByClass("kumo_spookitem")) >= 5 then
        print("Too many items, not spawning")

        return
    end

    for i = 1, math.random(3, 6) do
        timer.Simple(math.random(1, 30), function()
            local vecPos, vecPos2 = table.Random(vecspawnpositions)
            table.RemoveByValue(vecspawnpositions, vecPos)
            local thepresent = ents.Create("kumo_spookitem")
            thepresent:SetPos(vecPos + Vector(0, 0, 25))
            local model = table.Random(modeltable)
            thepresent.SetModelOK = model
            thepresent:Spawn()
            thepresent:DropToFloor()
            thepresent:SetModel(model)

            timer.Create("despawn" .. thepresent:EntIndex(), 2000, 1, function()
                if thepresent and isentity(thepresent) then
                    thepresent:Remove()
                    timer.Remove("despawn" .. thepresent:EntIndex())
                end
            end)
        end)
    end
end)

function IGHALLOWEEN:PlayersOnline(team)
    local plyonline = 0

    for k, v in pairs(IGHALLOWEEN[team].Players) do
        if player.GetBySteamID(v) then
            plyonline = plyonline + 1
        end
    end

    return plyonline
end

function IGHALLOWEEN:CheckNoTeam()
    local noteams = {}

    for k, v in pairs(player.GetAll()) do
        if v:GetNWString("halloweenteam", "none") == "none" then
            table.insert(noteams, v)
        end
    end

    return noteams
end

timer.Create("HalloteamReminder", 1800, 0, function()
    if IGHALLOWEEN.ENDED then return end
    for k, v in pairs(IGHALLOWEEN:CheckNoTeam()) do
        V:ChatPrint("You have not yet joined a halloween team, head to the third floor cauldron to join a team before it is too late!")
    end
end)

concommand.Add("hallopoints",function(ply)
    if not ply:IsSuperAdmin() then return end
    ply:ChatPrint("Boo Crew: "..IGHALLOWEEN["Boo! Crew"].Points.. "points")
    ply:ChatPrint("Scream Team: "..IGHALLOWEEN["Scream Team"].Points.. "points")
    ply:ChatPrint("Spooky Skeletons: "..IGHALLOWEEN["Spooky Skeletons"].Points.. "points")
end)

hook.Add("IGPlayerSay", "ClaimRewardHalloween", function(ply, text)
    if IGHALLOWEEN.SECRETFOUND or IGHALLOWEEN.ENDED then return end
    if string.lower(text) == string.char(103, 117, 115, 112, 111, 111, 107, 121, 119, 97,108, 107, 101, 114) then
        IGHALLOWEEN:UpdatePoints(ply:GetNWString("halloweenteam", "none"), 250, ply, "finding the secret word!")
        ULib.csay(_, ply:Nick().. " has found the secret word!!", Color(255, 93, 0), 8)
        umsg.Start("ulib_sound")
        umsg.String(Sound("ambient/alarms/warningbell1.wav"))
        umsg.End()
        IGHALLOWEEN.SECRETFOUND = true
        IGHALLOWEEN.SECRETFOUNDBY = ply:SteamID()
        UpdateHalloTable()
    end
end)

function IGHALLOWEEN:GetWinningTeam()
    local winner = "who"

    if IGHALLOWEEN["Boo! Crew"].Points < IGHALLOWEEN["Spooky Skeletons"].Points and IGHALLOWEEN["Scream Team"].Points < IGHALLOWEEN["Spooky Skeletons"].Points then
        winner = "Spooky Skeletons"
    end

    if IGHALLOWEEN["Boo! Crew"].Points < IGHALLOWEEN["Scream Team"].Points and IGHALLOWEEN["Spooky Skeletons"].Points < IGHALLOWEEN["Scream Team"].Points then
        winner = "Scream Team"
    end

    if IGHALLOWEEN["Spooky Skeletons"].Points < IGHALLOWEEN["Boo! Crew"].Points and IGHALLOWEEN["Boo! Crew"].Points > IGHALLOWEEN["Scream Team"].Points then
        winner = "Boo! Crew"
    end

    return winner
end

function IGHALLOWEEN:GetLastTeam()
    local winner = "who"

    if IGHALLOWEEN["Boo! Crew"].Points > IGHALLOWEEN["Spooky Skeletons"].Points and IGHALLOWEEN["Scream Team"].Points > IGHALLOWEEN["Spooky Skeletons"].Points then
        winner = "Spooky Skeletons"
    end

    if IGHALLOWEEN["Boo! Crew"].Points > IGHALLOWEEN["Scream Team"].Points and IGHALLOWEEN["Spooky Skeletons"].Points > IGHALLOWEEN["Scream Team"].Points then
        winner = "Scream Team"
    end

    if IGHALLOWEEN["Spooky Skeletons"].Points > IGHALLOWEEN["Boo! Crew"].Points and IGHALLOWEEN["Boo! Crew"].Points < IGHALLOWEEN["Scream Team"].Points then
        winner = "Boo! Crew"
    end

    return winner
end

function IGHALLOWEEN:GetSecondTeam()
    local winner = "who"

    if IGHALLOWEEN:GetWinningTeam() == "Spooky Skeletons" and IGHALLOWEEN:GetLastTeam() == "Scream Team" or IGHALLOWEEN:GetWinningTeam() == "Scream Team" and IGHALLOWEEN:GetLastTeam() == "Spooky Skeletons" then
        winner = "Boo! Crew"
    elseif IGHALLOWEEN:GetWinningTeam() == "Boo! Crew" and IGHALLOWEEN:GetLastTeam() == "Scream Team" or IGHALLOWEEN:GetWinningTeam() == "Scream Team" and IGHALLOWEEN:GetLastTeam() == "Boo! Crew" then
        winner = "Spooky Skeletons"
    elseif IGHALLOWEEN:GetWinningTeam() == "Spooky Skeletons" and IGHALLOWEEN:GetLastTeam() == "Boo! Crew" or IGHALLOWEEN:GetWinningTeam() == "Boo! Crew" and IGHALLOWEEN:GetLastTeam() == "Spooky Skeletons" then
        winner = "Scream Team"
    end

    return winner
end

function IGHALLOWEEN:GetPlacings()
    return IGHALLOWEEN:GetWinningTeam(), IGHALLOWEEN:GetSecondTeam(), IGHALLOWEEN:GetLastTeam()
end

IGHALLOWEENREWARDS = {
    ["winnerteam"] = {}, -- Winner Gun, 100k points, 25k credits, 30 quest points
    ["mvpwinnerteam"] = {}, -- 50k points, 10k credits, 15 quest
    ["secondteam"] = {}, -- 50k points, 10k credits, 15 quest points
    ["mvpsecondteam"] = {}, -- Winner Gun, 25k points, 5k credits, 5 quest points
    ["loserteam"] = {}, -- 10k points - 5k credits, 10 quest points
    ["mvploserteam"] = {} -- Winner Gun, 5k points, 5k credits, 5 quest points
}

if file.Exists("halloweenrewards.txt", "DATA") then
    IGHALLOWEENREWARDS = util.JSONToTable(file.Read("halloweenrewards.txt", "DATA"))
else
    file.Write("halloweenrewards.txt", util.TableToJSON(IGHALLOWEENREWARDS))
end

function IGHALLOWEEN:FillRewardTable()
    local first,second,third = IGHALLOWEEN:GetPlacings()
    IGHALLOWEENREWARDS["winnerteam"] = table.Copy(IGHALLOWEEN[first].Players)
    IGHALLOWEENREWARDS["secondteam"] = table.Copy(IGHALLOWEEN[second].Players)
    IGHALLOWEENREWARDS["loserteam"] = table.Copy(IGHALLOWEEN[third].Players)
    local temptable = {}
    for k,v in pairs(IGHALLOWEEN.INDIVIDUAL["Boo! Crew"]["Players"]) do 
        table.insert(temptable,{k,v.Points})
    end 
    table.sort( temptable, function(a, b) return a[2] > b[2] end )
    local temptable2 = {}
    for k,v in pairs(IGHALLOWEEN.INDIVIDUAL["Scream Team"]["Players"]) do 
        table.insert(temptable2,{k,v.Points})
    end 
    table.sort( temptable2, function(a, b) return a[2] > b[2] end )
    local temptable3 = {}
    for k,v in pairs(IGHALLOWEEN.INDIVIDUAL["Spooky Skeletons"]["Players"]) do 
        table.insert(temptable3,{k,v.Points})
    end 
    table.sort( temptable3, function(a, b) return a[2] > b[2] end )
    table.insert(IGHALLOWEENREWARDS["mvpwinnerteam"],temptable2[1][1])
    table.insert(IGHALLOWEENREWARDS["mvpsecondteam"],temptable3[1][1])
    table.insert(IGHALLOWEENREWARDS["mvploserteam"],temptable[1][1])
    table.insert(IGHALLOWEENREWARDS["mvpwinnerteam"],temptable2[2][1])
    table.insert(IGHALLOWEENREWARDS["mvpsecondteam"],temptable3[2][1])
    table.insert(IGHALLOWEENREWARDS["mvploserteam"],temptable[2][1])
    table.insert(IGHALLOWEENREWARDS["mvpwinnerteam"],temptable2[3][1])
    table.insert(IGHALLOWEENREWARDS["mvpsecondteam"],temptable3[3][1])
    table.insert(IGHALLOWEENREWARDS["mvploserteam"],temptable[3][1])
    file.Write("halloweenrewards.txt", util.TableToJSON(IGHALLOWEENREWARDS))
end

function IGHALLOWEEN:CheckRewards(ply)
    if not table.HasValue(IGHALLOWEENREWARDS["winnerteam"], ply:SteamID()) and not table.HasValue(IGHALLOWEENREWARDS["secondteam"], ply:SteamID()) and not table.HasValue(IGHALLOWEENREWARDS["loserteam"], ply:SteamID()) then
        ply:ChatPrint("Your reward has already been claimed or you did not receive a reward!")

        return
    end

    ply:ChatPrint("┏ HALLOWEEN REWARDS")
    ply:ChatPrint("┃")

    if table.HasValue(IGHALLOWEENREWARDS["winnerteam"], ply:SteamID()) then
        ply:ChatPrint("┃ WINNING TEAM REWARD")
        ply:ChatPrint("┃ 100,000 Pointshop Points")
        ply:SH_AddPremiumPoints(100000, "Halloween Reward", false, false)
        ply:ChatPrint("┃ 250,000 XP")
        SimpleXPAddXPSafe(ply, 250000)
        table.RemoveByValue(IGHALLOWEENREWARDS["winnerteam"], ply:SteamID())
    end

    if table.HasValue(IGHALLOWEENREWARDS["mvpwinnerteam"], ply:SteamID()) then
        ply:ChatPrint("┃")
        ply:ChatPrint("┃ WINNING TEAM MVP REWARD")
        ply:ChatPrint("┃ $20 Donation Store Credit")
        ply:ChatPrint("┃ 150,000 Pointshop Points")
        ply:SH_AddPremiumPoints(150000, "Halloween Reward", false, false)
        ply:ChatPrint("┃ 200,000 XP")
        SimpleXPAddXPSafe(ply, 200000)
        table.RemoveByValue(IGHALLOWEENREWARDS["mvpwinnerteam"], ply:SteamID())
    end

    if table.HasValue(IGHALLOWEENREWARDS["secondteam"], ply:SteamID()) then
        ply:ChatPrint("┃ SECOND PLACE REWARD")
        ply:ChatPrint("┃ 50,000 Pointshop Points")
        ply:SH_AddPremiumPoints(50000, "Halloween Reward", false, false)
        ply:ChatPrint("┃ 125,000 XP")
        SimpleXPAddXPSafe(ply, 125000)
        table.RemoveByValue(IGHALLOWEENREWARDS["secondteam"], ply:SteamID())
    end

    if table.HasValue(IGHALLOWEENREWARDS["mvpsecondteam"], ply:SteamID()) then
        ply:ChatPrint("┃")
        ply:ChatPrint("┃ SECOND PLACE MVP REWARD")
		ply:ChatPrint("┃ $10 Donation Store Credit")
        ply:ChatPrint("┃ 25,000 Pointshop Points")
        ply:SH_AddPremiumPoints(25000, "Halloween Reward", false, false)
        ply:ChatPrint("┃ 75,000 XP")
        SimpleXPAddXPSafe(ply, 75000)
        table.RemoveByValue(IGHALLOWEENREWARDS["mvpsecondteam"], ply:SteamID())
    end

    if table.HasValue(IGHALLOWEENREWARDS["loserteam"], ply:SteamID()) then
        ply:ChatPrint("┃ LAST PLACE PARTICIPATION REWARD")
        ply:ChatPrint("┃ 30,000 Pointshop Points")
        ply:SH_AddPremiumPoints(30000, "Halloween Reward", false, false)
        ply:ChatPrint("┃ 40,000 XP")
        SimpleXPAddXPSafe(ply, 40000)
        table.RemoveByValue(IGHALLOWEENREWARDS["loserteam"], ply:SteamID())
    end

    if table.HasValue(IGHALLOWEENREWARDS["mvploserteam"], ply:SteamID()) then
        ply:ChatPrint("┃")
        ply:ChatPrint("┃ LAST PLACE MVP REWARD")
		ply:ChatPrint("┃ $5 Donation Store Credit")
        ply:ChatPrint("┃ 25,000 Pointshop Points")
        ply:SH_AddPremiumPoints(25000, "Halloween Reward", false, false)
        ply:ChatPrint("┃ 50,000 XP")
        SimpleXPAddXPSafe(ply, 50000)
        table.RemoveByValue(IGHALLOWEENREWARDS["mvploserteam"], ply:SteamID())
    end

    ply:ChatPrint("┃")
    ply:ChatPrint("┗ GOOD WORK!")
    file.Append("halloweenrewardslog.txt", "[" .. os.date('%d-%m-%Y - %I:%M:%S %p', os.time()) .. "] " .. ply:Nick() .. " claimed their reward\n")
    file.Write("halloweenrewards.txt", util.TableToJSON(IGHALLOWEENREWARDS))
end

hook.Add("IGPlayerSay", "ClaimRewardHalloween", function(ply, text)
    if string.lower(text) == "!claimreward" then
        IGHALLOWEEN:CheckRewards(ply)
    end
end)

hook.Add("PlayerSpawn","HalloweenReminder",function(ply)
    if table.HasValue(IGHALLOWEENREWARDS["winnerteam"], ply:SteamID()) or table.HasValue(IGHALLOWEENREWARDS["secondteam"], ply:SteamID()) or table.HasValue(IGHALLOWEENREWARDS["loserteam"], ply:SteamID()) then
        ply:ChatPrint("You have unclaimed halloween event rewards, type !claimreward to claim them before they expire")
    end
end)

IGMVPTable = {}
function IGHALLOWEEN:SetMVPS()
    local first, second, third = IGHALLOWEEN:GetPlacings()
    local tblReturn = {}
    tblReturn[first] = {}
    tblReturn[second] = {}
    tblReturn[third] = {}

    for k,v in pairs(tblReturn) do
        local tempTable = {}
        for a,b in pairs(IGHALLOWEEN.INDIVIDUAL[k].Players) do
            table.insert(tempTable, 1, {a,b.Points})
        end
        table.sort( tempTable, function(a, b) return a[2] > b[2] end )
        tblReturn[k] = {tempTable[1],tempTable[2],tempTable[3]}
    end
    IGMVPTable = table.Copy(tblReturn)
    for k,v in pairs(IGMVPTable) do
        for a,b in pairs(v) do
            ig_fwk_db:PrepareQuery("SELECT * FROM igdata WHERE steamid64 = ".. util.SteamIDTo64(b[1]), {}, function(query, status, data) b[3] = data[1].name end)
        end
    end
end

concommand.Add("endhalloween", function(ply)
    if ply:SteamID() ~= "STEAM_0:0:57771691" then return end
    IGHALLOWEENREWARDS = {
        ["winnerteam"] = {}, -- Winner Gun, 100k points, 25k credits, 30 quest points
        ["mvpwinnerteam"] = {}, -- 50k points, 10k credits, 15 quest
        ["secondteam"] = {}, -- 50k points, 10k credits, 15 quest points
        ["mvpsecondteam"] = {}, -- Winner Gun, 25k points, 5k credits, 5 quest points
        ["loserteam"] = {}, -- 10k points - 5k credits, 10 quest points
        ["mvploserteam"] = {} -- Winner Gun, 5k points, 5k credits, 5 quest points
    }
    file.Write("halloweenrewards.txt", util.TableToJSON(IGHALLOWEENREWARDS))
    IGHALLOWEEN.ENDED = true
    UpdateHalloTable()

    IGHALLOWEEN:FillRewardTable()
    local first, second, third = IGHALLOWEEN:GetPlacings()
    local mvps = IGMVPTable
    ULib.csay(_, "The Halloween Event is over, thank you all for participating and I hope you had fun.\nThe placings will soon follow, commence the drumrolls", Color(255, 93, 0), 8)

    timer.Simple(8.5, function()
        ULib.csay(_, "In third place we have " .. third .. " with " .. IGHALLOWEEN[third].Points .. " points\n[MVPS]\n[1st] - " .. mvps[third][1][3] .. " | " .. mvps[third][1][2] .. " points" .. " | " .. (math.Round((mvps[third][1][2] / IGHALLOWEEN[third].Points) * 100)) .. "% of teams points\n[2nd] - " .. mvps[third][2][3] .. " | " .. mvps[third][2][2] .. " points" .. " | " .. (math.Round((mvps[third][2][2] / IGHALLOWEEN[third].Points) * 100)) .. "% of teams points\n[3rd] - " .. mvps[third][3][3] .. " | " .. mvps[third][3][2] .. " points" .. " | " .. (math.Round((mvps[third][3][2] / IGHALLOWEEN[third].Points) * 100)) .. "% of teams points", Color(255, 93, 0), 10)
    end)

    timer.Simple(18.5, function()
        ULib.csay(_, "In second place we have " .. second .. " with " .. IGHALLOWEEN[second].Points .. " points\n[MVPS]\n[1st] - " .. mvps[second][1][3] .. " | " .. mvps[second][1][2] .. " points" .. " | " .. (math.Round((mvps[second][1][2] / IGHALLOWEEN[second].Points) * 100)) .. "% of teams points\n[2nd] - " .. mvps[second][2][3] .. " | " .. mvps[second][2][2] .. " points" .. " | " .. (math.Round((mvps[second][2][2] / IGHALLOWEEN[second].Points) * 100)) .. "% of teams points\n[3rd] - " .. mvps[second][3][3] .. " | " .. mvps[second][3][2] .. " points" .. " | " .. (math.Round((mvps[second][3][2] / IGHALLOWEEN[second].Points) * 100)) .. "% of teams points", Color(255, 93, 0), 10)
    end)

    timer.Simple(28.5, function()
        ULib.csay(_, "And the winners by a long stretch are " .. first .. " with " .. IGHALLOWEEN[first].Points .. " points\n[MVPS]\n[1st] - " .. mvps[first][1][3] .. " | " .. mvps[first][1][2] .. " points" .. " | " .. (math.Round((mvps[first][1][2] / IGHALLOWEEN[first].Points) * 100)) .. "% of teams points\n[2nd] - " .. mvps[first][2][3] .. " | " .. mvps[first][2][2] .. " points" .. " | " .. (math.Round((mvps[first][2][2] / IGHALLOWEEN[first].Points) * 100)) .. "% of teams points\n[3rd] - " .. mvps[first][3][3] .. " | " .. mvps[first][3][2] .. " points" .. " | " .. (math.Round((mvps[first][3][2] / IGHALLOWEEN[first].Points) * 100)) .. "% of teams points", Color(255, 93, 0), 10)
    end)

    timer.Simple(38.5, function()
        ULib.csay(_, "Once again thank you for playing, you may now claim your well deserved rewards by typing !claimreward in chat\nEnjoy and come back next year for a new event", Color(255, 93, 0), 10)
    end)

    umsg.Start("ulib_sound")
    umsg.String(Sound("ambient/alarms/warningbell1.wav"))
    umsg.End()
end)