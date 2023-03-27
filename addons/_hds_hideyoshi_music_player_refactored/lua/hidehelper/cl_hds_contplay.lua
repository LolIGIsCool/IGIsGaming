--[[
    Hideyoshi Development Servers
    Music Player Helpers

    ***
    THIS SHOULD ONLY BE INCLUDED IN ~1~ FILE
    ***

]]
local contplay = {}
local player_registry = {}
local thinkdelay = CurTime()

--[[
    Distance to Volume

    where plyDis is absolute
    let volume the volume of the music player
    let finVolume the final volume porportionate to the location of the player
    let maxDis the maximum fade distance

    volume - ((|plyDis|/distance)*volume)
]]
local function distanceToVolume(plyDis, volume, maxDis)
    return volume - ((math.abs(plyDis)/maxDis)*volume)
end

--[[
    Stores the station into the player registry for later reference
    Also attaches the station to the entity

    @param {string} str_id
    @param {entity} ent
    @param {IGModAudioChannel} station
    @param {function} _callback

    return {table} player_registry
]]
local function processPlayer(  str_id, ent, station, curSettings, _callback ) -- str_id is the player's unique id, station is the IGModAudioChannel, _callback is the callback function
    local station_ret -- the station that will be returned to the callback function
    if ( IsValid( station ) ) then -- station is a valid entity
        station_ret = station 
        player_registry[str_id] = station_ret -- store the station in the registry 

        if ( IsValid( ent ) ) then -- ent is a valid entity
            
            if (ent.station) then -- ent has a station
                ent.station:Stop() -- stop the station
                ent.station = nil -- remove the station from the entity
            end 
            ent.station = station_ret -- attach the station to the entity
            ent.HideMusic_settings = curSettings -- attach the settings to the entity
            ent.declaredStopped = false

            function ent:Think() -- every tick, check if the player is still connected
                if ( IsValid( self.station ) ) then -- self.station is a valid entity
                    self.station:SetPos( self:GetPos() ) -- set the station's position to the entity's position

                    if (self.station:GetState() == GMOD_CHANNEL_STOPPED and !ent.declaredStopped) then -- if the station is stopped, and the player hasn't declared it stopped yet
                        ent.declaredStopped = true -- declare the player's station stopped
                        hook.Run("hideMusic_playerStopped", self) -- run the playerStopped hook and pass the entity
                    elseif (!ent.declaredStopped) then
                        -- The reason it's multipled by two is because the distance is
                        local volDistance = distanceToVolume(LocalPlayer():GetPos():Distance(ent:GetPos()), curSettings["settings"].music_volume, (curSettings["settings"].music_3d_distance * 1.25))
                        self.station:SetVolume((volDistance >= 0 and volDistance or 0)) -- set the station's volume to the distance to volume function
                    end
                end
            end
            -- TODO: Add a hook for when the player pauses
        else 
            print("[HDS - contplay] Entity is not valid!")
        end
        
        if (_callback) then
            _callback(station_ret) -- Callback for when the player is ready to play 
        end
        return station_ret -- Return the station
    else
        print( "[HDS - contplay] An error occured when playing URL." ) -- TODO: Add a better error message.
        return
    end

    return player_registry -- Return the registry
end

--[[
    Wrapper for the PlayURL function, stores player into the registry

    @param {string} url
    @param {entity} ent
    @param {string} flags
    @param {string} str_id
    @param {function} _callback

    return {IGModAudioChannel} station_ret
]]
function contplay.PlayURL(url, ent, flags, str_id, curSettings, _callback) 
    local station_ret -- the station that will be returned
    sound.PlayURL(url, flags, function( station )
        station_ret = processPlayer( str_id, ent, station, curSettings, _callback ) -- store the station in the registry & attaches the station to the entity
    end)
    return station_ret -- Return the station
end

--[[
    Wrapper for the PlaySound function, stores player into the registry

    @param {string} url
    @param {entity} ent
    @param {string} flags
    @param {string} str_id
    @param {function} _callback

    return {IGModAudioChannel} station_ret
]]
function contplay.PlaySound(path, ent, flags, str_id, curSettings, _callback) 
    local station_ret -- the station that will be returned
    sound.PlayFile(path, flags, function( station )
        station_ret = processPlayer( str_id, ent, station, curSettings, _callback ) -- store the station in the registry & attaches the station to the entity
    end)
    return station_ret -- Return the station
end

--[[
    Get all the players in the registry
    @param {void} void

    return {table} player_registry
]]
function contplay.getAllPlayers()
    return player_registry -- Return the registry
end

local function cl_processRequest()
    local recTable = net.ReadTable()

    -- for my own sanity, I'm going to make sure that the flags are valid
    local songPath = recTable["path"]
    local playerEnity = recTable["ent"]
    local playerFlags = recTable["flags"]
    local rndIdentifier = LocalPlayer():SteamID().."_"..math.Rand(1, 9999)
    local sndType = recTable["type"]
    -- See server for table structure

    local function startPlayer(station)
    	if ( IsValid( station ) ) then
            station:Set3DEnabled(string.find(recTable["flags"], "3d"))
            station:Set3DFadeDistance( 1000000000, 1000000000 )

            station:SetVolume(recTable["settings"].music_volume)

            station:SetPos(recTable.ent:GetPos())

            station:Play()
        else
            print( "Error playing sound!", errCode, errStr )
        end
    end

    if (sndType == "file") then
        contplay.PlaySound(songPath, playerEnity, playerFlags, rndIdentifier, recTable, startPlayer)
    elseif (sndType == "url") then
        contplay.PlayURL(songPath, playerEnity, playerFlags, rndIdentifier, recTable, startPlayer)
    else
        print("[HDS - contplay] Invalid sound type!")
    end
    
end
net.Receive("hideMusic_clProcessSongRequest", cl_processRequest)

--[[
    Pushes the queue to the server
    Dependant on the owner of the player

    @param {entity} ent

    return {void}
]]--
local function pushQueue(ent)
    local queueTable = util.JSONToTable(ent:Gethds_Queue())
    if (next(queueTable) ~= nil) then
        net.Start("hds_owner-pushQueue")
            net.WriteEntity(ent)
        net.SendToServer()
    end
end

-- hook for when a player stops their station
hook.Add("hideMusic_playerStopped", "hideMusic_clearPlayer", function(self) 
    self.HideMusic_settings = nil -- clear the settings
    self.station = nil -- clear the station

    if (self:Gethds_ownerSteamID() == LocalPlayer():SteamID()) then -- if the player is the owner of the station
        pushQueue(self) -- push the queue to the server
    end
end) -- clear the player's settings and station

--[[
    fukc this
    bad code 

    local function hookStat()
        if (thinkdelay > CurTime()) then return end
        thinkdelay = CurTime() + 2 -- dont check it too much lol

        -- Check all music players
        for k,v in pairs(player_registry) do

        end
    end

    hook.Add("Think", "hds_hookPredictor", function()
        hookStat()
    end)
]]--

return contplay -- Return the module