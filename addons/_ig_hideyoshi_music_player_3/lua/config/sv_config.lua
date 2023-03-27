--[[
    Hideyoshi's Music Player v3
    Configuration and Setup
]]

hdsMusic_config = {

    server = "ig",
    accesKey = "rkKDS6=2X=8y9-ujdt68",
    convServer = "https://floating-falls-14491.herokuapp.com/",

    allowConverter = true,

    -- Please enter the respective names of the ULX Ranks you wish
    -- to be able to access the global music function here;
    globalMusic_ulx = {
        'superadmin',
		'Senior Event Master',
		'Event Master',
		'Junior Event Master',
		'admin'
    },

    -- Please enter the respective names of the ULX Ranks you wish
    -- to be able to access the YouTube Converter function here;
    converterMusic_ulx = {
        'superadmin',
		'Senior Event Master',
		'admin',
    },

    -- Please enter the respective names of the ULX Ranks you wish
    -- to be able to save playlists to the server;

    serverPlaylist_ulx = {
        'superadmin',
    },

}