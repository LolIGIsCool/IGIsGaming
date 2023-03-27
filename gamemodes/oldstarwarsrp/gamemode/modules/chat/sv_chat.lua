util.AddNetworkString("SendChatMessage")
local commands = {}

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
        ulx.logString(msg)
        print(msg)

        return ""
    end

    text = string.Explode(" ", text)
    if not text[1] then return end
    local command = commands[text[1]]

    if command then
        local recipients = command.recipients(ply, table.concat(text, " ", 2))
        local condition = command.condition(ply, table.concat(text, " ", 2)) or ply:IsSuperAdmin()
        if #recipients == 0 then return end
        if not condition then return end
        net.Start("SendChatMessage")
        net.WriteTable(command.data(ply, table.concat(text, " ", 2)))
        net.WriteString(os.date("[%H:%M:%S] ", os.time()))
        net.Send(recipients)
        local msg = string.format("%s: %s", ply:Nick(), table.concat(text, " "))
        ulx.logString(msg)
        print(msg)

        return ""
    elseif not text[1]:StartWith("!") and not text[1]:StartWith("/") then
        net.Start("SendChatMessage")
        net.WriteTable(commands[2].data(ply, table.concat(text, " ")))
        net.WriteString(os.date("[%H:%M:%S] ", os.time()))
        net.Send(commands[2].recipients(ply))
        local msg = string.format("%s: %s", ply:Nick(), table.concat(text, " "))
        ulx.logString(msg)
        print(msg)

        return ""
    end
end)

CreateChatCommand(1, function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if TeamTable[ply:Team()].Regiment == TeamTable[ent:Team()].Regiment then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text) return {Color(255, 0, 0), "(Team) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", text} end)

CreateChatCommand(2, function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 300000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 300000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text) return {team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", text} end)

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
CreateChatCommand("/ooc", function(ply) return true end, function(ply) return player.GetAll() end, function(ply, text) return {Color(255, 255, 255), "(OOC) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", text} end)
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
end, function(ply, text) return {Color(255, 255, 255), "(LOOC) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", text} end)

CreateChatCommand("/LOOC", "/looc")
CreateChatCommand("/Looc", "/looc")
CreateChatCommand("/lOOC", "/looc")
CreateChatCommand("/comms", function(ply) return true end, function(ply) return player.GetAll() end, function(ply, text) return {Color(0, 255, 0), "(COMMS) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", text} end)
CreateChatCommand("/COMMS", "/comms")
CreateChatCommand("/Comms", "/comms")
CreateChatCommand("/cOMMS", "/comms")

CreateChatCommand("/holonet", function(ply)
    if TeamTable[ply:Team()].Regiment == "Coalition for Progress" or ply:IsSuperAdmin() then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text) return {Color(0, 255, 255), "(HOLONET) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), Color(0, 255, 255), ": ", text} end)

CreateChatCommand("/ecomms", function(ply)
    if TeamTable[ply:Team()].Regiment == "Rebel" or TeamTable[ply:Team()].Regiment == "Event" or ply:IsAdmin() then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text) return {Color(255, 0, 0), "(ENEMY COMMS) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", text} end)

CreateChatCommand("/enemycomms", "/ecomms")
CreateChatCommand("/ECOMMS", "/ecomms")
CreateChatCommand("/Ecomms", "/ecomms")
CreateChatCommand("/eCOMMS", "/ecomms")

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
end, function(ply, text) return {Color(255, 255, 255), "", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), team.GetColor(ply:Team()), " ", text} end)

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
end, function(ply, text) return {Color(151, 211, 255), "(" .. ply:GetPlayerName() .. ") ", Color(151, 211, 255), "*** ", Color(151, 211, 255), text, " ***"} end)

CreateChatCommand("/IT", "/it")
CreateChatCommand("/It", "/it")
CreateChatCommand("/iT", "/it")

CreateChatCommand("/git", function(ply)
    if ply:IsAdmin() then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text) return {Color(151, 211, 255), "*** ", Color(151, 211, 255), text, " ***"} end)

CreateChatCommand("/globalit", "/git")

CreateChatCommand("/w", function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 50000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 50000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text) return {color_white, "(whisper) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", text} end)

CreateChatCommand("/whisper", "/w")
CreateChatCommand("/W", "/w")

CreateChatCommand("/y", function(ply) return true end, function(ply)
    local recipients = {}

    for _, ent in ipairs(player.GetAll()) do
        if ent:GetPos():DistToSqr(ply:GetPos()) < 300000 then
            table.insert(recipients, ent)
        elseif ent.FSpectating and ent.FSpectatePos and isvector(ent.FSpectatePos) and ply:GetPos():DistToSqr(ent.FSpectatePos) < 300000 then
            table.insert(recipients, ent)
        end
    end

    return recipients
end, function(ply, text) return {color_white, "(yell) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", text} end)

CreateChatCommand("/yell", "/y")
CreateChatCommand("/Y", "/y")

CreateChatCommand("/bcomms", function(ply)
    if (TeamTable[ply:Team()].Regiment == "Bounty Hunter") then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text) return {Color(255, 93, 0), "(BH COMMS) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", text} end)

CreateChatCommand("/Bcomms", "/bcomms")
CreateChatCommand("/BCOMMS", "/bcomms")
CreateChatCommand("/bCOMMS", "/bcomms")

CreateChatCommand("/ocomms", function(ply)
    if (TeamTable[ply:Team()].Regiment == "Imperial High Command") or (TeamTable[ply:Team()].Regiment == "Regional Government" and TeamTable[ply:Team()].Rank >= 14) or (TeamTable[ply:Team()].Regiment == "ISB" and TeamTable[ply:Team()].Rank >= 18) or (TeamTable[ply:Team()].Regiment == "Navy Engineer" and TeamTable[ply:Team()].Rank >= 19) or (TeamTable[ply:Team()].Regiment == "Event" and ply:IsAdmin()) then return true end

    return false
end, function(ply) return player.GetAll() end, function(ply, text) return {Color(58, 40, 255), "(ORDERS) ", team.GetColor(ply:Team()), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), color_white, ": ", Color(0, 169, 255), text} end)

CreateChatCommand("/orderscomms", "/ocomms")
CreateChatCommand("/OCOMMS", "/ocomms")
CreateChatCommand("/Ocomms", "/ocomms")
CreateChatCommand("/oCOMMS", "/ocomms")

CreateChatCommand("/hidden", function(ply)
    if TeamTable[ply:Team()].Regiment == "Rebel" or TeamTable[ply:Team()].Regiment == "Event" or ply:IsSuperAdmin() then return true end

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
end, function(ply, text) return {Color(151, 211, 255), "(" .. ply:GetPlayerName() .. ") ", Color(255, 255, 255), "Someone says: ", Color(180, 180, 180), text} end)

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
end, function(ply, text) return {Color(151, 211, 255), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), " has rolled a " .. mathrandomkumo(ply, text) .. "/100."} end)

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
end, function(ply, text) return {Color(151, 211, 255), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), " has rolled a " .. math.random(1, 5000) .. "/5000."} end)

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
end, function(ply, text) return {Color(151, 211, 255), TeamTable[ply:Team()].Name .. " " .. ply:GetPlayerName(), customrollkumo(ply, text)} end)