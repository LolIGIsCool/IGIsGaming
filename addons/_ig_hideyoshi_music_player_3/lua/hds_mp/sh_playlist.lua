function savePlaylist(ent, ply, playlistConfig)
    if (ent:GetClass() ~= "sw_hideyoshi_music_player") then return false end

    if (ent:GetqueueConstruct() ~= "[]") then

        local curPlaylistjson = "[]"
        if (file.Exists( "hideMusic_playlist.txt" , "DATA" )) then
            curPlaylistjson = file.Read( "hideMusic_playlist.txt" , "DATA" )
        end
        local curPlaylistData = util.JSONToTable(curPlaylistjson) or {}

        if (curPlaylistData[playlistConfig.name] ~= nil) then
            if (SERVER) then
                ply:SendLua("notification.AddLegacy( 'Playlist already exists.', 1, 2 )")
            else
                notification.AddLegacy( 'Playlist already exists.', 1, 2 )
            end
            return false;
        end

        local curQueue = util.JSONToTable(ent:GetqueueConstruct())
        curQueue.Owner = ply:SteamID()
        curPlaylistData[playlistConfig.name] = curQueue

        local updatePlaylist = util.TableToJSON(curPlaylistData)

        file.Write("hideMusic_playlist.txt", updatePlaylist)

        return updatePlaylist;

    end

    return false;
end

function deletePlaylist(ply, playlistConfig)
    
    if (file.Exists( "hideMusic/playlist.json" , "DATA" )) then

        local curPlaylistjson = file.Read( "hideMusic/playlist.json" , "DATA" )
        local curPlaylist = util.JSONToTable(curPlaylistjson)

        if (table.HasValue(table.GetKeys(curPlaylist), playlistConfig.name)) then

            curPlaylist[playlistConfig.name] = nil
            local updatePlaylist = util.TableToJSON(curPlaylist)

            file.Write("hideMusic/playlist.json", updatePlaylist)

            return updatePlaylist;

        end

        return false;

    end

    return false;

end

function getPlaylist(ply)

    if (file.Exists( "hideMusic_playlist.txt" , "DATA" )) then

        local curPlaylistjson = file.Read( "hideMusic_playlist.txt" , "DATA" )
        local curPlaylist = util.JSONToTable(curPlaylistjson)

        if ( SERVER ) then
            if (!ply:IsAdmin()) then return end
            net.Start("hdsmp_sendUserPlaylist")
                net.WriteTable(curPlaylist)
            net.Send(ply)
        end

        return curPlaylist

    end

    return false;

end

if ( CLIENT ) then


end
