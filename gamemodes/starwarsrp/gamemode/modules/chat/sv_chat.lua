util.AddNetworkString("SendChatMessage")
local commands = {}
color_white_real = Color(255, 255, 255, 255)

local function CreateChatCommand(cmd, condition, recipients, data)
    if isstring(condition) then
        commands[cmd] = commands[condition]

        return
    end

    commands[cmd] = {
        condition = condition,
        recipients = recipients,
        data = data
    }
end

hook.Add("PlayerSay", "SWRPChatCommands", function(ply, text, teamChat)
    local playersayfix = hook.Run("IGPlayerSay", ply, text, teamChat)
    if playersayfix ~= nil then return playersayfix end
    local team = commands[1]

    if teamChat and team then
        net.Start("SendChatMessage")
        net.WriteTable(team.data(ply, text))
        net.WriteString(os.date("[%H:%M:%S] ", os.time()))
        net.Send(team.recipients(ply))
        local msg = string.format("(Team) %s: %s", ply:Nick(), text)
        ulx.logString(msg, false)
        print(msg)

        return ""
    end

    text = string.Explode(" ", text)
    if not text[1] then return end
    local command = commands[text[1]]

    if command then
        local recipients = command.recipients(ply, table.concat(text, " ", 2)) or {}
        local condition = command.condition(ply, table.concat(text, " ", 2)) or ply:IsSuperAdmin()
        if #recipients == 0 then return end
        if not condition then return end
        net.Start("SendChatMessage")
        net.WriteTable(command.data(ply, table.concat(text, " ", 2)))
        net.WriteString(os.date("[%H:%M:%S] ", os.time()))
        net.Send(recipients)
        local msg = string.format("%s: %s", ply:Nick(), table.concat(text, " "))
        ulx.logString(msg, false)
        print(msg)

        return ""
    elseif not text[1]:StartWith("!") and not text[1]:StartWith("/") then
        net.Start("SendChatMessage")
        net.WriteTable(commands[2].data(ply, table.concat(text, " ")))
        net.WriteString(os.date("[%H:%M:%S] ", os.time()))
        net.Send(commands[2].recipients(ply))
        local msg = string.format("%s: %s", ply:Nick(), table.concat(text, " "))
        ulx.logString(msg, false)
        print(msg)

        return ""
    end
end)

local vadersfistregs = {
    ["501st Infantry"] = true,
    ["501st Heavy"] = true,
    ["501st Support"] = true,
    ["501st Scout"] = true,
    ["501st Commando"] = true,
    ["501st Jumptrooper"] = true,
    ["501st Storm Commando"] = true,
    ["501st Imperial Commando"] = true,
}

local inquisit = {
    ["Purge Trooper"] = true,
    ["Imperial Inquisitor"] = true,
	["Imperial Marauder"] = true,
    ["Shadow Guard"] = true,
}

local navyregs = {
    ["Imperial Naval Engineer"] = true,
    ["Imperial Starfighter Corps"] = true,
    ["Imperial Navy"] = true,
    ["Imperial Naval Medic"] = true,
    ["Chimaera Squad"] = true,
}

local isbregs = {
    ["Imperial Security Bureau"] = true,
    ["Inferno Squad"] = true,
    ["CompForce"] = true,
    ["Death Trooper"] = true,
}

local ihcregs = {
    ["Imperial High Command"] = true,
    ["Imperial Executive Command"] = true,
    ["Imperial Administration"] = true,
	["Experimental Unit"] = true,
}

local securityregs = {
    ["107th Riot Company"] = true,
    ["107th Shock Division"] = true,
    ["107th Medic"] = true,
    ["107th Heavy"] = true,
    ["107th Honour Guard"] = true,
    ["107th Massiff Detachment"] = true,
    ["107th Patrol Trooper"] = true,
    ["96th Nova Division"] = true,
}

local twotwelth = {
    ["212th Airborne Unit"] = true,
    ["212th Attack Battalion"] = true,
    ["212th Juggernaut Unit"] = true
}

local donoregs = {
    ["275th Sky Division"] = true,
    ["275th Support"] = true,
    ["275th Siege Unit"] = true,
    ["275th Heavy"] = true,
    ["275th Infantry"] = true,
}

local regregis = {
    ["439th Stormtroopers"] = true,
    ["439th ARC Trooper"] = true,
	["439th Medical Company"] = true,
}

local regimentchats = {vadersfistregs, inquisit, navyregs, isbregs, ihcregs, securityregs, twotwelth, donoregs, regregis}

CreateChatCommand(1, function(ply) return true end, function(ply)
    local recipients = {}
    local playersa = player.GetAll()

    for _, ent in ipairs(playersa) do
        if ply:GetRegiment() == ent:GetRegiment() then
            table.insert(recipients, ent)
        end
    end

    for _, ent in ipairs(playersa) do
        for k, v in pairs(regimentchats) do
            if v[ply:GetRegiment()] and v[ent:GetRegiment()] then
                table.insert(recipients, ent)
            end
        end
    end

    return recipients
end, function(ply, text)
    return {Color(255, 255, 0), "(Secure Comms) ", ply:GetJobTable().Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand(2, function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 100000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 300000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand("/name", function(ply, text) return true end, function(ply, text)
    if string.len(text) < 2 then
        ply:ChatPrint("That name is too short")

        return
    end

    if string.len(text) > 32 then
        ply:ChatPrint("That name is too long")

        return
    end

    ply:SetPlayerName(text)

    return {}
end, function() end)

CreateChatCommand("/setname", "/name")
CreateChatCommand("/SETNAME", "/name")
CreateChatCommand("/Setname", "/name")
CreateChatCommand("/rpname", "/name")
CreateChatCommand("!name", "/name")
CreateChatCommand("!setname", "/name")
CreateChatCommand("!rpname", "/name")

hook.Add("IGPlayerSay", "MuteOOC", function(ply, text)
    if string.lower(text) == "/oocmute" then
        if ply.oocmute then
            ply.oocmute = false
            ply:ChatPrint("OOC has been unmuted")
        elseif not ply.oocmute then
            ply.oocmute = true
            ply:ChatPrint("OOC has been muted")
        end
    end
end)

function GetUnmutedOOC()
    local players = {}

    for k, v in ipairs(player.GetAll()) do
        if not v.oocmute then
            table.insert(players, v)
        end
    end

    return players
end

CreateChatCommand("/ooc", function(ply) return (not ply.oocmute) end, function(ply) return GetUnmutedOOC() end, function(ply, text)
    return {Color(255, 255, 255), "(OOC) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand("//", "/ooc")
CreateChatCommand("/OOC", "/ooc")
CreateChatCommand("/Ooc", "/ooc")
CreateChatCommand("/oOC", "/ooc")

CreateChatCommand("/looc", function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 300000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 300000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {Color(255, 255, 255), "(LOOC) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand("/LOOC", "/looc")
CreateChatCommand("/Looc", "/looc")
CreateChatCommand("/lOOC", "/looc")

CreateChatCommand("/comms", function(ply) return true end, function(ply) return player.GetAll() end, function(ply, text)
    return {Color(0, 255, 0), "(COMMS) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand("/COMMS", "/comms")
CreateChatCommand("/Comms", "/comms")
CreateChatCommand("/cOMMS", "/comms")
CreateChatCommand("/c", "/comms")

CreateChatCommand("/civcomms", function(ply)
    if ply:GetRegiment() == "Civilian" or ply:GetRegiment() == "Event" or ply:IsSuperAdmin() then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text)
    return {Color(111, 66, 245), "(CIVCOMMS) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand("/civ", "/civcomms")

CreateChatCommand("/holonet", function(ply)
    if ply:GetRegiment() == "Dynamic Environment" or ply:IsSuperAdmin() then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text)
    return {Color(255, 191, 0), "(HOLONET) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), Color(255, 255, 127), ": ", text}
end)

CreateChatCommand("/h", "/holonet")

CreateChatCommand("/shadowfeed", function(ply)
    if ply:GetRegiment() == "Dynamic Environment" or ply:IsSuperAdmin() then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text)
    return {Color(36, 36, 36), "(SHADOWFEED) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), Color(109, 109, 109), ": ", text}
end)

CreateChatCommand("/s", "/shadowfeed")

CreateChatCommand("/pacomms", function(ply)
    if ply:GetRegiment() == "Imperial Navy" or ply:GetRegiment() == "Imperial High Command" or (ply:GetRegiment() == "Naval Engineer" and ply:GetRank() >= 15) or (ply:GetRegiment() == "Imperial Starfighter Corps" and ply:GetRank() >= 15) or (ply:GetRegiment() == "Event" and ply:IsAdmin()) or ply:IsSuperAdmin() then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text)
    return {Color(63, 127, 0), "(PA SYSTEM) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), Color(51, 204, 51), ": ", text}
end)

CreateChatCommand("/pa", "/pacomms")

CreateChatCommand("/ecomms", function(ply)
    if ply:GetRegiment() == "Rebel Alliance" or ply:GetRegiment() == "Event" or ply:IsAdmin() then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text)
    return {Color(255, 0, 0), "(ENEMY COMMS) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand("/enemycomms", "/ecomms")
CreateChatCommand("/ECOMMS", "/ecomms")
CreateChatCommand("/Ecomms", "/ecomms")
CreateChatCommand("/eCOMMS", "/ecomms")
CreateChatCommand("/e", "/ecomms")

CreateChatCommand("/me", function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 100000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 100000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {Color(255, 255, 255), "", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, " ", text}
end)

CreateChatCommand("/ME", "/me")
CreateChatCommand("/Me", "/me")
CreateChatCommand("/mE", "/me")

CreateChatCommand("/it", function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 100000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 100000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {Color(151, 211, 255), "(" .. ply:GetPlayerName() .. ") ", Color(151, 211, 255), "*** ", Color(151, 211, 255), text, " ***"}
end)

CreateChatCommand("/IT", "/it")
CreateChatCommand("/It", "/it")
CreateChatCommand("/iT", "/it")

CreateChatCommand("/git", function(ply)
    if ply:IsAdmin() then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text)
    return {Color(151, 211, 255), "*** ", Color(151, 211, 255), text, " ***"}
end)

CreateChatCommand("/globalit", "/git")

CreateChatCommand("/w", function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 15000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 50000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {color_white_real, "(whisper) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand("/whisper", "/w")
CreateChatCommand("/W", "/w")

CreateChatCommand("/y", function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 200000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 300000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {color_white_real, "(yell) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand("/yell", "/y")
CreateChatCommand("/Y", "/y")

CreateChatCommand("/bcomms", function(ply)
    if (ply:GetRegiment() == "Bounty Hunter") then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text)
    return {Color(255, 93, 0), "(BH COMMS) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", text}
end)

CreateChatCommand("/Bcomms", "/bcomms")
CreateChatCommand("/BCOMMS", "/bcomms")
CreateChatCommand("/bCOMMS", "/bcomms")
CreateChatCommand("/bh", "/bcomms")

CreateChatCommand("/ocomms", function(ply)
    if (ply:GetRegiment() == "Imperial High Command") or (ply:GetRegiment() == "Imperial Executive Command") or (ply:GetRegiment() == "Imperial Administration" and ply:GetRank() >= 18) or (ply:GetRegiment() == "Imperial Security Bureau" and ply:GetRank() >= 20) or (ply:GetRegiment() == "Imperial Navy" and ply:GetRank() >= 24) or (ply:GetJobTable().Clearance == "5") or (ply:GetJobTable().Clearance == "6") or (ply:GetJobTable().Clearance == "All Access") or (ply:GetRegiment() == "Event" and ply:IsAdmin()) then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text)
    return {Color(58, 40, 255), "(ORDERS) ", TeamTable[ply:GetRegiment()][ply:GetRank()].Colour, TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), color_white_real, ": ", Color(0, 169, 255), text}
end)

CreateChatCommand("/orderscomms", "/ocomms")
CreateChatCommand("/OCOMMS", "/ocomms")
CreateChatCommand("/Ocomms", "/ocomms")
CreateChatCommand("/oCOMMS", "/ocomms")
CreateChatCommand("/o", "/ocomms")

CreateChatCommand("/hidden", function(ply)
    if ply:GetRegiment() == "Rebel" or ply:GetRegiment() == "Event" or ply:IsSuperAdmin() then return true end

    return false
end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 100000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 100000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {Color(151, 211, 255), "(" .. ply:GetPlayerName() .. ") ", Color(255, 255, 255), "Someone says: ", Color(180, 180, 180), text}
end)

local function mathrandomkumo(ply, text)
    if ply:SteamID() == "STEAM_0:0:57771691" then
        return text
    else
        return math.random(1, 100)
    end
end

local function customrollkumo(ply, text)
    if ply:SteamID() == "STEAM_0:0:57771691" then
        return " has rolled a " .. text .. "."
    else
        local randomnumber = math.random(1, math.Round(tonumber(text)))

        return " has rolled a " .. randomnumber .. "/" .. math.Round(tonumber(text)) .. "."
    end
end

CreateChatCommand("/roll", function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 100000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 100000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {Color(151, 211, 255), TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), " has rolled a " .. mathrandomkumo(ply, text) .. "/100."}
end)

CreateChatCommand("/bigroll", function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 100000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 100000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {Color(151, 211, 255), TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), " has rolled a " .. math.random(1, 5000) .. "/5000."}
end)

CreateChatCommand("/customroll", function(ply, text) return ply:SteamID() == "STEAM_0:0:57771691" or isnumber(tonumber(text)) and tonumber(text) <= 1000000 and tonumber(text) > 0 end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 100000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 100000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text)
    return {Color(151, 211, 255), TeamTable[ply:GetRegiment()][ply:GetRank()].Name .. " " .. ply:GetPlayerName(), customrollkumo(ply, text)}
end)