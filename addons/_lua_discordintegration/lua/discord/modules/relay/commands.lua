Discord.Util.Commands = Discord.Util.Commands or {}

local zerowidth = '\xE2\x80\x8B'
local staffRank = {}

for _, rank in ipairs(Discord.Config.Relay.AdminRanks) do
    staffRank[rank] = true
end

local permissions = {}
for role, perms in pairs(Discord.Config.Relay.DiscordPermissions) do
    local new = {}

    for __, permString in ipairs(perms) do
        new[permString] = true
    end

    permissions[role] = new
end

local function hasPermission(author, permString)
    for _, role in ipairs(author.roles) do
        if permissions[role.name] and permissions[role.name][permString] then return true end
    end

    return false
end
Discord.Util.Commands.hasPermission = hasPermission

local function commandEvent(data, message)
    Discord.Backend.API:Send(
        Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
            color = 0x3498db,
            title = Discord.Util:GetLang('COMMAND_EVENT'),
            description = message,
        }):ToAPI()
    )
end
Discord.Util.Commands.commandEvent = commandEvent

local function commandError(data, message)
    Discord.Backend.API:Send(
        Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
            color = 0xe74c3c,
            title = Discord.Util:GetLang('COMMAND_ERROR'),
            description = message,
        }):ToAPI()
    )
end
Discord.Util.Commands.commandError = commandError

local function escapeMarkdown(str)
    return string.Replace(str, '`', '') -- actually escape markdown
end

local function findPlayer(name)
    name = string.lower(name)
    for _, ply in ipairs(player.GetAll()) do
        if string.find(string.lower(ply:Nick()), name, 1, true) or
        string.find(string.lower(ply:Name()), name, 1, true) or
        name == ply:SteamID() or
        name == ply:SteamID64() then
            return ply
        end
    end
    return nil
end
Discord.Util.Commands.findPlayer = findPlayer

Discord:RegisterCommand('status', function(data)
    if not hasPermission(data.author, 'status') then return commandError(data, Discord.Util:GetLang('NO_PERMISSIONS')) end

    Discord.Backend.API:Send(
        Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
            color = 0xB400B4,
            title = GetHostName(),
            fields = {
                {
                    name = Discord.Util:GetLang('IP'),
                    value = Discord.Util:GetServerIP(),
                    inline = true,
                },
                {
                    name = Discord.Util:GetLang('GAMEMODE'),
                    value = gmod.GetGamemode().Name,
                    inline = true,
                },
                {
                    name = Discord.Util:GetLang('MAP'),
                    value = game.GetMap(),
                    inline = true,
                },
                {
                    name = Discord.Util:GetLang('PLAYERS'),
                    value = player.GetCount() .. '/' .. game.MaxPlayers(),
                    inline = true,
                },
                {
                    name = Discord.Util:GetLang('STAFF_ONLINE'),
                    value = (function()
                        local a = 0

                        for _, ply in ipairs(player.GetAll()) do
                            if not ply:IsAdmin() and not staffRank[ply:GetUserGroup()] then continue end

                            a = a + 1
                        end

                        return a
                    end)(),
                    inline = true,
                },
                {
                    name = zerowidth,
                    value = zerowidth,
                    inline = true,
                },
            },
        }):ToAPI()
    )
end)

-- Use rcon
--[[Discord:RegisterCommand('say', function(data)
    if not hasPermission(data.author, 'say') then return end
    if data.argstr == '' then return commandError(data, Discord.Util:GetLang('NO_ARGUMENT_PROVIDED')) end

    data.argstr = string.Replace(data.argstr, ';', '')
    game.ConsoleCommand('say ' .. data.argstr .. '\n') -- plz tell me of a better way
    commandEvent(data, Discord.Util:GetLang('SAID_AS_CONSOLE', {
        cmd = escapeMarkdown(data.argstr),
    }))
end)]]

Discord:RegisterCommand('rcon', function(data)
    if not hasPermission(data.author, 'rcon') then return commandError(data, Discord.Util:GetLang('NO_PERMISSIONS')) end
    if data.argstr == '' then return commandError(data, Discord.Util:GetLang('NO_ARGUMENT_PROVIDED')) end

    game.ConsoleCommand(data.argstr .. '\n')
    commandEvent(data, Discord.Util:GetLang('RAN_IN_CONSOLE', {
        cmd = escapeMarkdown(data.argstr),
    }))
end)

Discord:RegisterCommand('lua', function(data)
    if not hasPermission(data.author, 'lua') then return commandError(data, Discord.Util:GetLang('NO_PERMISSIONS')) end
    if string.StartWith(data.argstr, '```') then
        data.argstr = string.sub(data.argstr, 3 + (string.StartWith(data.argstr, '```lua') and 3 or 0) + 1 + 1, string.len(data.argstr) - 3 - 1)
    end
    if data.argstr == '' then return commandError(data, Discord.Util:GetLang('NO_ARGUMENT_PROVIDED')) end

    local func = CompileString(data.argstr, 'DiscordLuaRun', false)
    if type(func) == 'function' then
        func()
        commandEvent(data, Discord.Util:GetLang('RAN_CODE_ON_SERVER', {
            cmd = escapeMarkdown(data.argstr),
        }))
    else
        commandError(data, func)
    end
end)

Discord:RegisterCommand('kick', function(data)
    if not hasPermission(data.author, 'kick') then return commandError(data, Discord.Util:GetLang('NO_PERMISSIONS')) end
    if data.argstr == '' then return commandError(data, Discord.Util:GetLang('NO_ARGUMENT_PROVIDED')) end

    local name = #data.args > 1 and data.args[1] or data.argstr
    local reason = data.args[2]
    local target = findPlayer(name)
    if not target then return commandError(data, Discord.Util:GetLang('PLAYER_COULDNT_BE_FOUND')) end

    local plyName = target:Name()
    target:Kick(reason)
    commandEvent(data, Discord.Util:GetLang(reason and 'KICKED_PLAYER_WITH_REASON' or 'KICKED_PLAYER', {
        name = plyName,
        reason = reason,
    }))
end)

Discord:RegisterCommand('ss', function(data)
    if not hasPermission(data.author, 'ss') then return commandError(data, Discord.Util:GetLang('NO_PERMISSIONS')) end
    if data.argstr == '' then return commandError(data, Discord.Util:GetLang('NO_ARGUMENT_PROVIDED')) end
    
    local name = #data.args > 1 and data.args[1] or data.argstr
    local quality = data.args[2] and tonumber(data.args[2])
    local target = findPlayer(name)
    if not target then return commandError(data, Discord.Util:GetLang('PLAYER_COULDNT_BE_FOUND')) end

    local name = target:Name()
    local sid64 = target:SteamID64()
    Discord.SS:Request(target, quality, function(err, url)
        if err then
            return commandError(data, Discord.Util:GetLang('FAILED_SCREENSHOTTING', {
                name = name,
                err = err,
            }))
        end

        Discord.Backend.API:Send(
            Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
                color = 0x3498db,
                title = Discord.Util:GetLang('COMMAND_EVENT'),
                description = Discord.Util:GetLang('SCREENSHOT_OF_PLAYER', {
                    name = name,
                    sid64 = sid64,
                }),
                url = url,
                image = {
                    url = url,
                },
            }):ToAPI()
        )
    end)
end)

Discord:RegisterCommand('help', function(data)
    if not hasPermission(data.author, 'help') then return commandError(data, Discord.Util:GetLang('NO_PERMISSIONS')) end

    Discord.Backend.API:Send(
        Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
            color = 0x8e44ad,
            title = Discord.Util:GetLang('HELP_TITLE'),
            description = Discord.Util:GetLang('HELP_DESCRIPTION') ..
                (GAS and GAS.JobWhitelist and Discord.Config.Relay.bWhitelist and '\n' .. Discord.Util:GetLang('BWHITELIST_HELP_TEXT') or ''),
        }):ToAPI()
    )
end)

function claimstodiscord(data)
    local tbl = util.JSONToTable(file.Read("caseclaims.txt", "DATA"))
    local stringtbl = ""

    for k, v in pairs(tbl) do
        stringtbl = stringtbl .. "" .. v.name .. " (" .. k .. ")  - " .. v.claims .. "\n"
    end

    local fuck123 = {
        ["failed"] = function()
            Discord.Backend.API:Send(Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
                color = 0xB400B4,
                title = GetHostName(),
                fields = {
                    {
                        name = "ERROR",
                        value = "API FAILED TO POST, CONTACT KUMO",
                        inline = true
                    }
                }
            }):ToAPI())
        end,
        ["success"] = function(lol1, lol2, lol3)
            Discord.Backend.API:Send(Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
                color = 0xB400B4,
                title = GetHostName(),
                fields = {
                    {
                        name = "CLAIMS LINK (@" .. data["author"].nickname .. ")",
                        value = "http://139.99.144.130:7777/" .. util.JSONToTable(lol2).key .. " - <@" .. data["author"].id..">",
                        inline = true
                    }
                }
            }):ToAPI())
        end,
        ["method"] = "POST",
        ["url"] = "http://139.99.144.130:7777/documents",
        ["headers"] = {
            ["Content-Type"] = "text/plain"
        },
        ["body"] = stringtbl,
        ["type"] = "text/plain"
    }

    HTTP(fuck123)
end

Discord:RegisterCommand('claims', function(data)
    claimstodiscord(data)
end)

function logstodiscord(data)
    local logtypestring = ""

    for k, v in pairs(plogs.types) do
        logtypestring = logtypestring .. " " .. k .. " | "
    end

    if not data.argstr or data.argstr == '' then return commandError(data, Discord.Util:GetLang('NO_ARGUMENT_PROVIDED') .. " - Valid Arguments: " .. logtypestring) end
    local upperfirst = data.argstr:gsub("^%l", string.upper)
    if not plogs.types[upperfirst] then return commandError(data, "Log type not found, Valid Log Types: " .. logtypestring) end

    local fuck123 = {
        ["failed"] = function(reason)
            Discord.Backend.API:Send(Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
                color = 0xB400B4,
                title = GetHostName(),
                fields = {
                    {
                        name = "ERROR",
                        value = "API FAILED TO POST, SEND THIS MESSAGE TO KUMO ("..reason..")",
                        inline = true
                    }
                }
            }):ToAPI())
        end,
        ["success"] = function(lol1, lol2, lol3)
            print("LOGS:"..tostring(file.Read("plogsfullsave/" .. string.lower(upperfirst) .. ".txt", "DATA")))
            print(lol1,lol2,lol3)
            Discord.Backend.API:Send(Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
                color = 0xB400B4,
                title = GetHostName(),
                fields = {
                    {
                        name = "LOGS (@" .. data["author"].nickname .. ")",
                        value = "http://139.99.144.130:7777/" .. util.JSONToTable(lol2).key .. " - <@" .. data["author"].id..">",
                        inline = true
                    }
                }
            }):ToAPI())
        end,
        ["method"] = "POST",
        ["url"] = "http://139.99.144.130:7777/documents",
        ["headers"] = {
            ["Content-Type"] = "text/plain"
        },
        ["body"] = tostring(file.Read("plogsfullsave/" .. string.lower(upperfirst) .. ".txt", "DATA")),
        ["type"] = "text/plain"
    }

    HTTP(fuck123)
end

Discord:RegisterCommand('logs', function(data)
    logstodiscord(data)
end)

---------------------------------------------------------------------------------------------------------------------------------------------------------------

function eawardstodiscord(data)
    local tbl = util.JSONToTable(file.Read("awardedpoints.txt", "DATA"))

    local fuck123 = {
        ["failed"] = function()
            Discord.Backend.API:Send(Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
                color = 0xB400B4,
                title = GetHostName(),
                fields = {
                    {
                        name = "ERROR",
                        value = "API FAILED TO POST, CONTACT KUMO",
                        inline = true
                    }
                }
            }):ToAPI())
        end,
        ["success"] = function(lol1, lol2, lol3)
            Discord.Backend.API:Send(Discord.OOP:New('Message'):SetChannel(data.channel):SetEmbed({
                color = 0xB400B4,
                title = GetHostName(),
                fields = {
                    {
                        name = "EVENT PLACINGS LINK (@" .. data["author"].nickname .. ")",
                        value = "http://139.99.144.130:7777/" .. util.JSONToTable(lol2).key .. " - <@" .. data["author"].id..">",
                        inline = true
                    }
                }
            }):ToAPI())
        end,
        ["method"] = "POST",
        ["url"] = "http://139.99.144.130:7777/documents",
        ["headers"] = {
            ["Content-Type"] = "text/plain"
        },
        ["body"] = stringtbl,
        ["type"] = "text/plain"
    }

    HTTP(fuck123)
end

Discord:RegisterCommand('eawards', function(data)
    eawardstodiscord(data)
end)