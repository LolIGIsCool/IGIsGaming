--[[
    Hideyoshi Development Servers
    Music Player Helpers

    ***
    SERVERSIDE FILE
    ***

    This file contains the serverside code for the music player.
    All keys are stored in the provided configuration table.
]]

--local hide_dermaFunctions = include("hidehelper/cl_dermafunctions.lua")

local hideMusic_svConfig = {

    ["globalULX"] = {
        "superadmin",
		"Senior Event Master",
		"Event Master",
        "Junior Event Master",
		"admin"
    }, -- What ulx ranks are allowed to play global music.

    ["converter"] = true; -- is the converter enabled

    ["converterULX"] = {
        "superadmin",
		"Senior Event Master",
		"admin",
    }, -- What ulx ranks are allowed to use the converter?

    --[[
        Do not change these unless you know what you're doing!
    ]]

    ["default_flags"] = {'noplay','noblock'}, -- /!\ It's not recommended to change these unless you know what you're doing!
    -- https://wiki.facepunch.com/gmod/sound.PlayFile
    -- /!\ Important Note /!\ Removing 'noblock' ***WILL*** break the seeking and looping of the music player.

    ["apiKey"] = "d~.,s7PU/Hw8P(}ABG8y2umJA&!Jn$", -- This key is required for the Converter to work. 

    ["converterUrl"] = "https://hds-musicconverter.herokuapp.com/", -- This is the URL for the Converter.

    ["server"] = "ig" -- This is the server definition for the Converter.

}

--[[
    Caching Network Strings
]]
-- CLIENT --> SERVER
util.AddNetworkString("hideMusic_submitSongRequest") 
util.AddNetworkString("hds_owner-pushQueue")
util.AddNetworkString("hds_owner-updateQueue")
util.AddNetworkString("hds_stateChange")
util.AddNetworkString("hds_settime")
util.AddNetworkString("hds_setloop")
-- SERVER --> CLIENT
util.AddNetworkString("hideMusic_clProcessSongRequest")

--[[
    Cache Image Files
]]
resource.AddFile("materials/hideyoshi_vgui/derma_forward.png")
resource.AddFile("materials/hideyoshi_vgui/derma_repeatActive.png")
resource.AddFile("materials/hideyoshi_vgui/derma_repeatInactive.png")
resource.AddFile("materials/hideyoshi_vgui/vgui_pause.png")
resource.AddFile("materials/hideyoshi_vgui/vgui_play.png")
resource.AddFile("materials/hideyoshi_vgui/vgui_stop.png")
resource.AddFile("materials/vgui/entities/hds_musicplayer_refactored.vtf")


--[[
    Send request to client when server has processed the request

    @param {table} prdata
        - data[1] = song name
        - data[2] = song path (Url if external)
        - data[3] = song type (url or file)
        - data[4] = sound flags

    returns {void} void
]]
local function processRequest(data, ply)
    --[[
        Data request structure

        ent	=	(Entity)
        flags	=	(String : Flags)
        name	=	(Song Name)
        path	=	(Mp3 Path or URL)
        settings:
                music_3d	=	(True/False)
                music_3d_distance	=	(Dependant : Integer)
                music_loop	=	(True/False)
                music_volume	=	(0 to 1)
        type	=	(file or url or youtube)

    ]]

    local flags = table.Copy(hideMusic_svConfig.default_flags) -- set the default sound flags
    if (data[4]["music_3d"] == true) then 
        table.insert(flags, "3d") 
    else
        if (!table.HasValue(hideMusic_svConfig.globalULX, ply:GetUserGroup())) then
            return
        end
    end-- if 3d is enabled, add the 3d flag to the flags table

    local outgoingData = {
        ["name"] = data[1],
        ["path"] = data[2],
        ["type"] = data[3],
        ["flags"] = table.concat(flags, " "),
        ["settings"] = data[4],
        ["ent"] = data[5]
    }

    net.Start("hideMusic_clProcessSongRequest")
        net.WriteTable(outgoingData)
    net.Broadcast()
end

--[[
    Requests a song from the conversion server

    @param {string} url

    returns {string} converted song url
]]
local function convertYouTube(url, data, ply)
    local urlConverter = hideMusic_svConfig.converterUrl .. "conversion?url=" .. url .. "&key=" .. hideMusic_svConfig.apiKey .. "&server=" .. hideMusic_svConfig.server
    http.Fetch( urlConverter, 
    
        function( body, length, headers, code )
            if (!table.HasValue(hideMusic_svConfig.converterULX, ply:GetUserGroup())) then
                return
            end

            if (string.find(body, "<!DOCTYPE html>")) then
                return
            end

            local baseJSON = util.JSONToTable(body)
            if (baseJSON.code == 200) then
                local song = util.JSONToTable( baseJSON.response )

                data[3] = "url"
                data[2] = song.url

                processRequest(data, ply)
            end
        end,

        -- onFailure function
        function( message )
            -- We failed. =(
            print( message )
        end
    )
end

--[[
    Called when server receives a request to submit a song

    @param {void} void

    returns {void} void
]]
local function recieveRequest( len, ply )
    local data = net.ReadTable()
    --if (!data[1] or !data[2] or !data[3] or !data[4] or !IsValid(data[5])) then return end

    --[[
    local queue = util.JSONToTable(data[5]:Gethds_Queue()) 
    table.insert( queue, 1, data )
    data[5]:Sethds_Queue(util.TableToJSON(queue))
]]
    if (data[3] == "youtube") then -- if the song is a YouTube video
        --if (!hide_dermaFunctions.validateYouTubeURL(data[2])) then return end -- if the url is not a YouTube URL, then return
        return convertYouTube(data[2], data, ply) -- convert the YouTube video to a MP3
    end

    return processRequest(data, ply)
end
net.Receive("hideMusic_submitSongRequest", recieveRequest)

--[[
    Called when server receives a request to add a song to the queue

    @param {void} void

    returns {void} void
]]
local function sv_updateQueue( len, ply )

    if (!ply:IsAdmin()) then return end

    local musicTable = net.ReadTable()
    local musicEnt = musicTable[5]

    if (musicEnt:GetClass() ~= "hds_musicplayer_refactored" || player.GetBySteamID( musicEnt:Gethds_ownerSteamID() ) ~= ply ) then return end

    local queue = util.JSONToTable(musicEnt:Gethds_Queue()) 
    --queue[5] = musicEnt:EntIndex() -- REMEMBER: This is the ENT INDEX of the music player! NOT THE ENTITY ITSELF!

    table.insert( queue, musicTable )

    musicEnt:Sethds_Queue(util.TableToJSON(queue))

end
net.Receive("hds_owner-updateQueue", sv_updateQueue)

--[[
    Called when server receives a request to push a song off the queue

    @param {void} void

    returns {void} void
]]
local function sv_pushQueue( len, ply )
    if (!ply:IsAdmin()) then return end

    local musicEnt = net.ReadEntity()

    if (musicEnt:GetClass() ~= "hds_musicplayer_refactored" || player.GetBySteamID( musicEnt:Gethds_ownerSteamID() ) ~= ply ) then return end
    local queue = util.JSONToTable(musicEnt:Gethds_Queue()) 

    if (next(queue) ~= nil) then

        local data = table.Copy(queue[1]) 
        data[5] = musicEnt -- table to json removes the entity, so we need to add it back in

        table.remove(queue, 1)
        musicEnt:Sethds_Queue(util.TableToJSON(queue))

        if (data[3] == "youtube") then -- if the song is a YouTube video
            --if (!hide_dermaFunctions.validateYouTubeURL(data[2])) then return end -- if the url is not a YouTube URL, then return
            return convertYouTube(data[2], data) -- convert the YouTube video to a MP3
        end
    
        return processRequest(data)
    
    else 
        musicEnt:Sethds_Queue("{}")
    end

    return
end
net.Receive("hds_owner-pushQueue", sv_pushQueue)


--[[
    Called when server receives a request to change the state of a song

    @param {integer} len - the length of the data sent
    @param {entity} ply - the caller

    returns {void} void

]]--
local function sv_changeState( len, ply )
    if (!ply:IsAdmin()) then return end
    
    local musicEnt = net.ReadEntity()
    local state = net.ReadString()
    
    if (IsValid(musicEnt) and musicEnt:GetClass() ~= "hds_musicplayer_refactored") then return end
    
    local musicEnt_index = musicEnt:EntIndex()

    for k,ply in ipairs( player.GetAll() ) do
        ply:SendLua("ents.GetByIndex("..musicEnt_index.."):HDS_ChangeState('"..state.."')")
    end

end
net.Receive("hds_stateChange", sv_changeState)

--[[
    Set's the time of a song for all players

    @param {integer} len - the length of the data sent
    @param {entity} ply - the caller

    returns {void} void

]]
local function sv_changeTime( len, ply )
    if (!ply:IsAdmin()) then return end
    
    local time = net.ReadInt(16)
    local musicEnt = net.ReadEntity()
    
    if (IsValid(musicEnt) and musicEnt:GetClass() ~= "hds_musicplayer_refactored") then return end

    local musicEnt_index = musicEnt:EntIndex()

    for k,ply in ipairs( player.GetAll() ) do
        ply:SendLua("if (IsValid(ents.GetByIndex("..musicEnt_index..").station)) then ents.GetByIndex("..musicEnt_index..").station:SetTime("..time..") end")
    end
end
net.Receive("hds_settime", sv_changeTime)

--[[
    Enables looping of a song for all players

    @param {integer} len - the length of the data sent
    @param {entity} ply - the caller

    returns {void} void

]]
local function sv_setLoop( len, ply )
    if (!ply:IsAdmin()) then return end
    
    local loop = net.ReadBool()
    local musicEnt = net.ReadEntity()
    
    if (IsValid(musicEnt) and musicEnt:GetClass() ~= "hds_musicplayer_refactored") then return end

    local musicEnt_index = musicEnt:EntIndex()
    musicEnt:Sethds_Loop(loop)

    for k,ply in ipairs( player.GetAll() ) do
        ply:SendLua("if (IsValid(ents.GetByIndex("..musicEnt_index..").station)) then ents.GetByIndex("..musicEnt_index..").station:EnableLooping("..tostring(loop)..") end")
    end
end
net.Receive("hds_setloop", sv_setLoop)