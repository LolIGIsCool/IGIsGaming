hook.Add( "InitPostEntity", "hds_musicFlagsDefining", function()

    LocalPlayer().hideMusic_sndFlags = {
        ["music_volume"] = 0.25,
        ["music_loop"] = false,
        ["music_3d"] = true, -- 3d enabled is non-global
        ["music_3d_distance"] = 100,
    }

end)