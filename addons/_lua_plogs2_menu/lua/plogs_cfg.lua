--
-- General configs
--

-- The chat command to open the menu, (DO NOT ADD A ! or /, it does this for you)
plogs.cfg.Command = 'plogs'

-- User groups that can access the logs.
plogs.cfg.UserGroups = {
    ["founder"] = true,
    ["superadmin"] = true,
	["senior developer"] = true,
	["senior admin"] = true,
    ["advisor"] = true,
    ["admin"] = true,
    ["senior moderator"] = true,
    ["moderator"] = true,
    ["junior moderator"] = true,
    ["trial moderator"] = true,
    ["lead event master"] = true,
    ["senior event master"] = true,
    ["event master"] = true,
    ["trial event master"] = true,
    ["junior event master"] = true,
    ["developer"] = true,
}
-- User groups that can access IP logs
plogs.cfg.IPUserGroups = {
    ["founder"] = true,
    ["superadmin"] = true,
    ["senior developer"] = true,
    ["advisor"] = true,
}

-- Window width percentage, I recomend no lower then 0.75
plogs.cfg.Width = 0.75

-- Window height percentage, I recomend no lower then 0.75
plogs.cfg.Height = 0.75

-- Some logs print to your client console. Enable this to print them to your server console too
plogs.cfg.EchoServer = false

-- Allow me to use logs on your server. (Disable if you're paranoid)
plogs.cfg.DevAccess = false

-- Do you want to store IP logs and playerevents? If enabled make sure to edit plogs_mysql_cfg.lua!
plogs.cfg.EnableMySQL = false

-- The log entry limit, the higher you make this the longer the menu will take to open.
plogs.cfg.LogLimit = 300

-- Format names with steamids? If true "aStoned(STEAMID)", if false just "aStoned"
plogs.cfg.ShowSteamID = true

-- Enable/Disable log types here. Set them to true to disable
plogs.cfg.LogTypes = {
	['chat'] 		= true,
	['commands']	= false,
	['connections'] = false,
	['kills'] 		= false,
	['props'] 		= false,
	['tools'] 		= false,
	['darkrp'] 		= true,
	['ulx']			= true,
	['maestro']		= true,
	['pnlr']		= true, -- NLR Zones					|| 	https://scriptfodder.com/scripts/view/583
	['lac']			= true, -- Leys Serverside AntiCheat 	|| 	https://scriptfodder.com/scripts/view/1148
	['awarn2']		= false, -- AWarn2 						||	https://scriptfodder.com/scripts/view/629
	['hhh']			= true, -- HHH 							||	https://scriptfodder.com/scripts/view/3
	['hitmodule']	= true, -- Hitman Module				||	https://scriptfodder.com/scripts/view/1369
	['cuffs'] 		= false, -- Hand Cuffs 					||	https://scriptfodder.com/scripts/view/910
	['changename']  = false, -- MartibosChangeName
	['bounty']  = false, -- Vanilla's Bounty Hunter System
	['heal']  = false, -- KumoHeal
	['messages'] = false,
}


--
-- Specific configs, if you disabled the log type that uses one of these the config it doesn't matter
--

-- Command log blacklist, blacklist commands here that dont need to be logged
plogs.cfg.CommandBlacklist = {
	['_sendDarkRPvars']		= true,
	['_sendAllDoorData']	= true,
	['ulib_update_cvar']	= true,
	['ulib_cl_ready'] 		= true,
	['_xgui']				= true,
	['ulx']					= true,
	['_u']					= true,
	['FSpectate']			= true,
	['FTPToPos']			= true,
	['_FSpectatePosUpdate']			= true,
	['FSpectate_StopSpectating']			= true,
	['fspectate']			= true,
	['pac_setmodel']			= true,
	['sit']			= true,

}

-- Tool log blacklist, blacklist tools here that dont need to be logged
plogs.cfg.ToolBlacklist = {
	['myexampletool'] = true,
}

plogs.cfg.DmgBlacklist = {
	['func_door'] = true,
	['func_tracktrain'] = true,
}